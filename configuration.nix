# use it in /etc/nixos/configuration.nix:
# imports = [ /home/user/.dotfiles/configuration.nix ];

{ config, pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./services.nix
    ./xserver.nix
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
  ];

  boot.loader = {
    grub.device = "/dev/sda";
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "nixos-pc";
    networkmanager.enable = true;
    connman = {
      enable = false;
      enableVPN = true;
    };
    wireless = {
      enable = false;
      networks = {
        SomeNetwork = {
          psk = "SomePassword";
        };
      };
      userControlled.enable = true;
    };
    firewall.allowedTCPPorts = [ 22 80 8080 8888 4200 ];
  };

  i18n = {
    consoleUseXkbConfig = true;
    consoleFont = "LatArCyrHeb-16";
  };

  sound.mediaKeys.enable = true;

  virtualisation = {
    docker.enable = true;
  };

  nixpkgs.config.pulseaudio = true;

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      s3tcSupport = true;
      extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiVdpau libvdpau-va-gl vaapiVdpau ];
    };
    pulseaudio = {
      enable = true;
      support32Bit = true;
      daemon.config = {
        flat-volumes = "no";
      };
    };
  };

  time.timeZone = "Europe/Moscow";

  systemd.coredump = {
    enable = true;
    extraConfig = "Storage=external";
  };

  security = {
    sudo.enable = true;
    pam.loginLimits = [
      { domain = "*"; type = "hard"; item = "core"; value = "unlimited"; }
      { domain = "*"; type = "soft"; item = "core"; value = "unlimited"; }
    ];
    polkit.enable = true;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "Fri 20:00";
    };
    extraOptions = ''
      gc-keep-outputs = true
      gc-keep-derivations = true
    '';
  };

  system = {
    stateVersion = "unstable";
    autoUpgrade = {
      enable = false;
      dates = "Fri 20:00";
    };
  };

  programs.bash = {
    enableCompletion = true;
    shellAliases = {
      ls = "ls -h --color";
      "ls.pure" = "`which ls`";
      la = "ls -lta";
      ll = "ls -lt";
      grep = "grep --color";
      cal = "cal -m3";
      df = "df -h";
      wineru = "LC_ALL=ru_RU.UTF-8 wine";
      wineru64 = "WINEARCH=win64 WINEPREFIX=~/.wine64 wineru";
      fix = "TF_CMD=$(TF_ALIAS=fuck PYTHONIOENCODING=utf-8 TF_SHELL_ALIASES=$(alias) thefuck $(fc -ln -1)) && eval $TF_CMD && history -s $TF_CMD";
    };
    loginShellInit = ''
      export HISTCONTROL=ignoredups
      unset SSH_ASKPASS
      export EDITOR=nvim
      export BROWSER=qutebrowser
      export PDFVIEWER=zathura
      export PSVIEWER=$PDFVIEWER
      export DVIVIEWER=$PDFVIEWER
      export TERMINAL=alacritty
    '';
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    terminal = "screen-256color";
    shortcut = "a";
    extraTmuxConf = ''
      run-shell ${pkgs.tmuxPlugins.prefix-highlight}/share/tmux-plugins/prefix-highlight/prefix_highlight.tmux
      run-shell ${pkgs.tmuxPlugins.sidebar}/share/tmux-plugins/sidebar/sidebar.tmux
      run-shell ${pkgs.tmuxPlugins.urlview}/share/tmux-plugins/urlview/urlview.tmux
      run-shell ${pkgs.tmuxPlugins.yank}/share/tmux-plugins/yank/yank.tmux
      run-shell ${pkgs.tmuxPlugins.pain-control}/share/tmux-plugins/pain-control/pain_control.tmux
      run-shell ${pkgs.tmuxPlugins.logging}/share/tmux-plugins/logging/logging.tmux
      run-shell ${pkgs.tmuxPlugins.open}/share/tmux-plugins/open/open.tmux
      run-shell ${pkgs.tmuxPlugins.copycat}/share/tmux-plugins/copycat/copycat.tmux
      ${builtins.readFile ./configs/tmux.conf}
    '';
  };

  programs.sway = {
    enable = true;
    extraSessionCommands = ''
      export XKB_DEFAULT_LAYOUT=us,ru
      export XKB_DEFAULT_VARIANT=nodeadkeys
      export XKB_DEFAULT_OPTIONS=grp:sclk_toggle,grp:shift_caps_toggle,grp_led:scroll,keypad:pointerkeys
      export WLC_REPEAT_DELAY=300
      export WLC_REPEAT_RATE=20
    '';
  };
}
