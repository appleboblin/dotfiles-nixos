#!/usr/bin/env bash
# adopted from https://github.com/iynaix/dotfiles/blob/main/install.sh

set -o errexit
set -o nounset
set -o pipefail

function yesno() {
    local prompt="$1"

    while true; do
        read -rp "$prompt [y/n] " yn
        case $yn in
            [Yy]* ) echo "y"; return;;
            [Nn]* ) echo "n"; return;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

cat << Introduction
The *entire* disk will be formatted with a 1GB boot partition
(labelled NIXBOOT), 16GB of swap, and the rest allocated to ZFS (labelled NIXROOT).

The following ZFS datasets will be created:
    - NIXROOT/root (mounted at /)
    - NIXROOT/home (mounted at /home)

** IMPORTANT **
This script assumes that the relevant "fileSystems" are declared within the
NixOS config to be installed. It does not create any hardware configuration
or modify the NixOS config to be installed in any way. If you have not done
so, you will need to add the necessary zfs options and filesystems before
proceeding or your install WILL NOT BOOT.

Introduction

# ZFS "fileSystems" declarations can be referenced from zfs.nix
# ZFS also requires the following options to be set within host config:
#   networking.hostId (can be generated using: head -c 8 /etc/machine-id)
#   zfs.devNodes
#       "/dev/disk/by-id" for Intel CPUs
#       "/dev/disk/by-partuuid" for AMD CPUs / within VMs
# impermanence setup can be referenced from impermanence.nix

# in a vm, special case
if [[ -b "/dev/vda" ]]; then
    DISK="/dev/vda"
else
    # listing with the standard lsblk to help with viewing partitions
    lsblk

    # Get the list of disks
    mapfile -t disks < <(lsblk -ndo NAME,SIZE,MODEL)

    echo -e "\nAvailable disks:\n"
    for i in "${!disks[@]}"; do
        printf "%d) %s\n" $((i+1)) "${disks[i]}"
    done

    # Get user selection
    while true; do
        echo ""
        read -rp "Enter the number of the disk to install to: " selection
        if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le ${#disks[@]} ]; then
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done

    # Get the selected disk
    DISK="/dev/$(echo "${disks[$selection-1]}" | awk '{print $1}')"
fi

# if disk contains "nvme", append "p" to partitions
if [[ "$DISK" =~ "nvme" ]]; then
    BOOTDISK="${DISK}p3"
    SWAPDISK="${DISK}p2"
    ZFSDISK="${DISK}p1"
else
    BOOTDISK="${DISK}3"
    SWAPDISK="${DISK}2"
    ZFSDISK="${DISK}1"
fi

echo "Boot Partiton: $BOOTDISK"
echo "SWAP Partiton: $SWAPDISK"
echo "ZFS Partiton: $ZFSDISK"
id=$(head -c 8 /etc/machine-id)
echo "hostId to add to git config: $id"

echo ""
do_format=$(yesno "This irreversibly formats the entire disk. Are you sure?")
if [[ $do_format == "n" ]]; then
    exit
fi

echo "Creating partitions"
sudo blkdiscard -f "$DISK"
sudo sgdisk --clear"$DISK"

sudo sgdisk -n3:1M:+1G -t3:EF00 "$DISK"
sudo sgdisk -n2:0:+16G -t2:8200 "$DISK"
sudo sgdisk -n1:0:0 -t1:BF01 "$DISK"

# notify kernel of partition changes
sudo sgdisk -p "$DISK" > /dev/null
sleep 5

echo "Creating Swap"
sudo mkswap "$SWAPDISK" --label "SWAP"
sudo swapon "$SWAPDISK"

echo "Creating Boot Disk"
sudo mkfs.fat -F 32 "$BOOTDISK" -n NIXBOOT

# setup encryption
use_encryption=$(yesno "Use encryption? (Encryption must also be enabled within host config with boot.zfs.requestEncryptionCredentials = true)")
if [[ $use_encryption == "y" ]]; then
    encryption_options=(-O encryption=aes-256-gcm -O keyformat=passphrase -O keylocation=prompt)
else
    encryption_options=()
fi

echo "Creating base zpool"
sudo zpool create -f \
    -o ashift=12 \
    -o autotrim=on \
    -O compression=zstd \
    -O acltype=posixacl \
    -O atime=off \
    -O xattr=sa \
    -O normalization=formD \
    -O mountpoint=none \
    "${encryption_options[@]}" \
    NIXBOOT "$ZFSDISK"

# NOTE: legacy mounts are used so they can be managed by fstab and swapped out via nixos configuration, e.g. for tmpfs
echo "Creating /"
sudo zfs create -o mountpoint=legacy NIXBOOT/root
sudo mount -t zfs NIXBOOT/root /mnt

echo "Creating /home"
sudo zfs create -o mountpoint=legacy NIXROOT/home
sudo mount --mkdir -t zfs NIXROOT/home /mnt/home

# create the boot parition after creating root
echo "Mounting /boot (efi)"
sudo mount --mkdir "$BOOTDISK" /mnt/boot

# get repo to install from
read -rp "Enter flake URL (default: github:appleboblin/dotfiles-nixos): " repo
repo="${repo:-github:appleboblin/dotfiles-nixos}"

# only relevant for IynaixOS
if [[ $repo == "github:appleboblin/dotfiles-nixos" ]]; then
    hosts=("desktop" "framework" "vm")

    echo "Available hosts:"
    for i in "${!hosts[@]}"; do
        printf "%d) %s\n" $((i+1)) "${hosts[i]}"
    done

    while true; do
        echo ""
        read -rp "Enter the number of the host to install: " selection
        if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le ${#hosts[@]} ]; then
            host="${hosts[$selection-1]}"
            break
        else
            echo "Invalid selection. Please enter a number between 1 and ${#hosts[@]}."
        fi
    done
else
    # non IynaixOS, prompt for host
    read -rp "Which host to install?" host
fi

read -rp "Enter git rev for flake (default: main): " git_rev

echo "Installing NixOS"
if [[ $repo == "appleboblin/dotfiles-nixos" ]]; then
    # root password is irrelevant if initialPassword is set in the config
    sudo nixos-install --no-root-password --flake "$repo/${git_rev:-main}#$host" --option tarball-ttl 0
else
    sudo nixos-install --flake "$repo/${git_rev:-main}#$host" --option tarball-ttl 0
fi

echo "Installation complete. It is now safe to reboot."
