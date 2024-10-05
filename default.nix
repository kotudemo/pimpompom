{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    kernelModules = [
      "nvidia"
      "kvm-intel"
    ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
    };
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      supportedFilesystems = [
        "refs"
        "ntfs"
      ];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/root";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
      ];
      "/boot" = {
        device = "/dev/disk/by-label/boot";
        fsType = "vfat";
        options = [
          "dmask=0022"
          "fmask=0022"
        ];
        "/mnt/hdd" = {
          device = "/dev/disk/by-label/hdd";
          fsType = "ext4";
          options = [
            "fmask=0022"
            "dmask=0022"
          ];
        };
      };
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  nix = {
    settings = {
      allowed-users = [ 
        "kotudemo"
        "root" 
      ];
      trusted-users = [ 
        "kotudemo"
        "root"
      ];
       experimental-features = [
        "flakes"
        "nix-commands"
      ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      system = "x86_64-linux";
      hostPlatform = lib.mkDefault "x86_64-linux";
    };
  };

  system = {
    stateVersion = "24.05";
    name = lib.mkDefault "goidapc";
  };

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      datacenter.enable = false;
      modesetting.enable = false;
      nvidiaSettings = true;
      open = false;
      powerManagement.enable = false;
    };
  };

  networking = {
    firewall = {
      allowPing = true;
      enable = true;
    };
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };

 	environment.systemPackages = [
      # home-manager
    ];

  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      twemoji-color-font
      jetbrains-mono
      poweline-fonts
      powerline-symbols
      nerdfonts
      miracode
      monocraft
    ];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ru-RU.UTF-8/UTF-8"
    ];
  };

  console = {
    enable = true;
    useXkbConfig = true;
  };

  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    xserver = {
      enable = true;
      display = 0;
      videoDrivers = [
        "nvidia"
      ];
      xkb = {
        layout = "us,ru";
        variant = "qwerty";
        options = "grp:shift_alt_toggle";
      };
    };
    printing = {
      enable = true;
      drivers = with pkgs; [
        canon-cups-ufr2
        cups-filters
        gutenprint
      ];
      listenAddresses = [
        "localhost:631"
      ];
      openFirewall = true;
      webInterface = true; 
    };
  };

  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
    users.kotudemo = {
      extraGroups = [
        "wheel"
      ];
      isNormalUser = true;
      hashedPassword = "$y$j9T$8.1i8Su9BOnVpfT0fcINx0$pD/gNvJRqDDKujwFp6.NFe4VV8K42WQk7xUetAzbEDD"; 
    };
  };

  programs = {
    nh = {
      enable = true;
      flake = "./";
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };

  home-manager = {
    users.kotudemo = {
      home = {
        username = "kd-home";
        stateVersion = "24.05";
        shellAliases = {
          # ...
        };
        
        sessionVariables = {
          QT_QPA_PLATFORM = "wayland";
          SDL_VIDEODRIVER = "wayland";
          CLUTTER_BACKEND = "wayland";
          GDK_BACKEND = "wayland";
          XDG_SESSION_TYPE = "wayland";

          NIXPKGS_ALLOW_UFREE = "1";
          NIXPKGS_ALLOW_BROKEN = "1";
          NIXOS_OZONE_WL = "1";
        };
        
        programs = {
          firefox = {
            enable = true;
            package = pkgs.firefox-bin;
          };
        };
        
        packages = with pkgs; [
          cava
          eza
          zsh
          fastfetch
          foot
          fuzzel
          fzf
          yazi
          zoxide
          dconf
          grimblast
          pwvucontrol
          pamixer
          obs-studio
          mpv
          gparted
          jq
          vesktop
          materialgram
          tetrio-desktop
          heroic
          mako
          nemo
          vanilla-dmz
          waybar
          hyprlock
          hypridle
          hyprpaper
          swaync

          gruvbox-dark-gtk
          gruvbox-dark-icons-gtk
        ];
        
        keyboard = {
          variant = "qwerty";
          layout = "us, ru";
          options = [
            "grp:shift_alt_toggle"
          ];
        };
        
        stylix = {
          enable = true;
          autoEnable = true;
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
          image = "./wallpaper.jpg";
          cursor = {
            package = pkgs.vanilla-dmz;
            name = "Vanilla-DMZ";
          }; 
        };
        
        wayland.windowManager = {
          hyprland.enable = true;
          river.enable = true;
        };
      };
    };
  };
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    image = "./image.png";
  };
}
