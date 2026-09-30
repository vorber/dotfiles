{ pkgs, lib, ... }:
{
  programs.rtorrent.extraConfig = ''
    network.scgi.open_local = (cat,(system.env,XDG_RUNTIME_DIR),"/rtorrent.sock")
  '';

  systemd.user.services.flood = {
    Unit.Description = "Flood web UI for rTorrent";
    Service = {
      ExecStart = "${lib.getExe pkgs.flood} --host 127.0.0.1 --port 8112";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
