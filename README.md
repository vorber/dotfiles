# dotfiles
My eternally-WIP dotfiles. Use at your own risk.

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
