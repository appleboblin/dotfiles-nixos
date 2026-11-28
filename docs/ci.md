# CI and updates

[← README](../README.md)

There are two GitHub Actions workflows in `.github/workflows/`.

## check.yml

| Job     | When it runs                                | What it does                                              |
| ------- | ------------------------------------------- | --------------------------------------------------------- |
| `fmt`   | On pull requests, pushes to `main`, and by hand | Fails if any `.nix` file isn't formatted              |
| `build` | On pull requests and by hand                | Builds `desktop`, `framework`, and `framework-intel` at the same time |

The build job clears space on the runner first. It also pulls Noctalia, Umbriel, and Catppuccin from their binary caches, so CI doesn't have to compile them.

## update.yml

Every Monday at 07:37 UTC, this workflow updates `flake.lock` and opens a pull request. The pull request merges by itself once the required checks pass, so `main` only ever gets a lock file that builds. To get it on a machine, run `update`.

The workflow uses a personal token stored as `GH_TOKEN_FOR_UPDATES`. Pull requests opened with GitHub's default token don't start other workflows, so the builds would never run without it.

## Rules on main

`main` is protected by a repository ruleset.

- Changes have to go through a pull request. Nobody can push to `main` directly. Approvals aren't required, because GitHub doesn't let you approve your own pull request.
- `build (desktop)`, `build (framework)`, and `fmt` must pass before a pull request can merge.
- Pull requests are squash merged, so each one becomes a single commit on `main`. The commit uses the pull request's title and description, so write the description as a summary. Merge commits and rebase merges are turned off.
- `main` can't be deleted or force-pushed. Branches are deleted automatically after they merge.
- As an admin, you can still merge a pull request whose checks failed, for example when a binary cache is down. You still can't push to `main` directly.

`build (framework-intel)` still runs, but it isn't required, because no machine uses that host yet ([more on that](framework.md)). If it fails, the pull request can still merge. Add it to the required checks once the Intel board is in use.

## Working with Claude Code

Claude Code uses your `git` and `gh` login, so GitHub can't tell its actions apart from yours. Two files in the repo keep it working through pull requests.

- `CLAUDE.md` tells it to work on a branch, build, open a pull request, and then stop. You either merge the pull request yourself or tell Claude Code to merge it.
- `.claude/settings.json` makes every merge command ask you for permission first, so Claude Code can't merge without your OK. It also blocks auto-merge, merging past failed checks with `--admin`, pushing to `main`, force-pushing, and changing rulesets or repo settings. These rules also apply in auto mode.

To change the rules, edit the ruleset on GitHub under Settings → Rules → Rulesets → `main`, and edit `.claude/settings.json`. Personal overrides go in `.claude/settings.local.json`, which git ignores.

## Running the checks locally

```sh
nix fmt                  # format everything
nix flake check          # make sure every host evaluates
nix build .#nixosConfigurations.desktop.config.system.build.toplevel   # build one host
```

`rebuild` only builds the machine you're on. If you change something shared, build the other hosts too, or open a pull request and let CI build them.
