# Working on this repo

This is a NixOS and Home Manager flake with three hosts: `desktop`, `framework`, and `framework-intel`. No machine runs `framework-intel` yet. Read `README.md` and `docs/layout.md` first.

## Git workflow

`main` is protected. Changes only land through a pull request, and `build (desktop)`, `build (framework)`, and `fmt` have to pass. Pull requests are squash merged.

1. Make a branch from the latest `main` with `git switch -c <short-topic> origin/main`. Never commit to `main`.
2. Write clear commit messages. Put unrelated changes in separate pull requests.
3. Before pushing, run `nix fmt` and build every host the change affects.
4. Push with `git push -u origin <branch>` and open a pull request with `gh pr create`. Write the title and description in the format below.
5. Stop there. The owner reviews the pull request and either merges it or tells you to merge it.
6. Only merge when the owner has said so for that specific pull request, and only once the required checks pass. Use `gh pr merge <N> --squash`. Each merge asks the owner for permission. Never use `--auto` or `--admin`, and never change rulesets or repo settings.

## Pull request title and description

The repo squash-merges with the pull request title and description as the commit message, and GitHub adds "(#N)" to the title. Whatever you write here ends up on `main`, so write it as a commit message.

- Title: a short summary in plain words, like "Drop the LocalSend zlib wrapper". No `type:` prefix.
- Description: summary bullets first, then a `## Testing` section, then the `Co-Authored-By` line. Add a `## Notes` section only when something needs explaining. Don't add a "Generated with Claude Code" line. If the pull request changes, update the description to match.

```
- <what changed>
- <why, if it isn't obvious>

## Testing
- <what was built or run, and what the owner tested on hardware>

Co-Authored-By: Claude …
```

## Checking a change

- A flake only sees files that git tracks, so `git add` new files before building.
- `nix flake check` checks that every host evaluates.
- Build a host with `nix build --no-link .#nixosConfigurations.<host>.config.system.build.toplevel`.
- Changes in `nixos/` or `home-manager/` affect all three hosts. Changes in `hosts/framework/` affect both Framework hosts. Changes in `hosts/desktop/` only affect the desktop.
- If a change breaks `framework-intel`, say so in the pull request. It isn't in use, so it shouldn't hold the pull request back.
- Don't switch to a new generation with `nixos-rebuild switch`, `nh os switch`, or `rebuild` unless the owner asks. Tell the owner what to test on the real machine.

## Conventions

- Put settings where `docs/layout.md` says they go.
- In shared modules, use `lib.mkDefault` for values a host might want to change.
- Write scripts with `pkgs.writeShellApplication` and list their tools in `runtimeInputs`. It runs shellcheck when it builds.
- When behaviour, keybinds, or the workflow change, update the matching page in `docs/`.
