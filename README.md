# dotfiles
My eternally-WIP dotfiles. Use at your own risk.

## GitHub Copilot app (NixOS)

The `vorber-nixos` desktop profile installs the GitHub Copilot app through
Home Manager using the community
[GithubCopilot-Nix flake](https://github.com/fumoctl/GithubCopilot-Nix).
It wraps GitHub's official Linux AppImage for NixOS and provides a desktop
launcher and URL handlers for browser sign-in. The app is proprietary and
uses the existing unfree-package allowance. It is not added to the WSL or
generic Linux profiles, and the standalone Copilot CLI is not installed.

From the repository root, apply it with:

```sh
sudo nixos-rebuild switch --flake ./nix#vorber-nixos
```

Launch **GitHub Copilot** from the application menu or run
`github-copilot-desktop` (also available as `copilot-desktop`).
Sign in with a GitHub account that has access to the app.

The version is pinned by `nix/flake.lock`. To update just the app's flake
input, then rebuild:

```sh
nix flake update github-copilot --flake ./nix
sudo nixos-rebuild switch --flake ./nix#vorber-nixos
```

## Flood and rTorrent (NixOS)

rTorrent still runs manually with its Home Manager configuration. On NixOS,
that configuration also opens a local SCGI socket at
`$XDG_RUNTIME_DIR/rtorrent.sock`. Flood runs as a user service, listens only
on `127.0.0.1:8112`, and keeps its default login enabled. No torrent data or
session directories need to move.

After rebuilding, restart rTorrent to create the socket. Open
http://127.0.0.1:8112, create a Flood login, and select rTorrent with a
Unix socket connection. Run `printf '%s/rtorrent.sock\n' "$XDG_RUNTIME_DIR"`
to get the full socket path to enter. Flood can run while rTorrent is stopped,
but it will not connect until rTorrent is started again.
