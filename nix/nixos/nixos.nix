
# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, user, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./vorber-nixos/hardware-configuration.nix
      ./config/gaming.nix
      ./config/DE.nix
      ./config/wine.nix
    ];
  
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "amdgpu.vm_update_mode=3"
     # "radeon.dpm=1"
    ];
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.kernelModules = ["amdgpu"];
    supportedFilesystems = [ "ntfs" ];

    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };

  fileSystems = {
    "/".options = ["compress=zstd"];
    "/home".options = ["compress=zstd"];
    "/nix".options = ["compress=zstd" "noatime"];
    "/var/log".options = ["compress=zstd"];
    "/run/media/vorber/SSD2" = {
      device = "/dev/disk/by-uuid/81655dc2-bbac-438d-8c6c-bc5890ad8f38";
      fsType = "ext4";
    };
    "/run/media/vorber/4tb" = {
      device = "/dev/disk/by-uuid/180b3946-5670-4ff2-b531-a0d2c8ad9330";
      fsType = "ext4";
    };
  };

  networking.hostName = "vorber-nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  services = {
    udev.packages = with pkgs; [
      bazecor
      game-devices-udev-rules
    ];
  };

  hardware.uinput.enable = true;
  
  services.jellyfin = {
      enable = true;
      openFirewall = true;
      user="vorber";
  };

  services.flatpak.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  #sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };
  hardware.pulseaudio.enable = false;
  environment.systemPackages = [
    pkgs.pavucontrol
    pkgs.distrobox
  ];

  #vulkan
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true; # For 32 bit applications

#  hardware.opengl.extraPackages = with pkgs; [
#  amdvlk
#  ];
## For 32 bit applications 
#  hardware.opengl.extraPackages32 = with pkgs; [
#    driversi686Linux.amdvlk
#  ];
#
## Force radv, comment out for amdvlk
#  environment.variables.AMD_VULKAN_ICD = "RADV";
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.ssh.startAgent = true;
  programs.gnupg.agent.enable = true;
  programs.firefox.enable = true;
  programs.firefox.nativeMessagingHosts.packages = [pkgs.passff-host];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vorber = {
    packages = with pkgs; [
      pinentry
      tree
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    allowedTCPPorts = [
      6987 #rtorrent
    ];
    allowedUDPPorts = [
      6987 #rtorrent
    ];
  };
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  services = {
    syncthing = {
      inherit user;
      enable = true;
      dataDir = "/home/${user}/sync";
      configDir = "/home/${user}/sync/.config/syncthing";
      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI
      settings = {
        devices = {
          #"phone" = { id = "RKHNAH7-Q6TOFMD-Y7U3EPG-OHWYNGO-UDM4AKF-RW2FUR3-MTXCA6G-ZNV3KAV"; };
          "phone" = { id = "JUDDPME-CSPQU6P-YLIHDDU-PD7U4X3-6OYVOPH-WXCA6N6-4CIMDUE-254EHAT"; };
        };
        folders = {
          "phone" = {         # Name of folder in Syncthing, also the folder ID
            path = "/home/${user}/sync/phone";    # Which folder to add to Syncthing
            devices = [ "phone" ];      # Which devices to share the folder with
          };
        };
      };
    };
  };
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}

