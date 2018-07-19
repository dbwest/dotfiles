{ pkgs, user, email }:

let
  packagesPath = builtins.toPath ./packages/default.nix;
  nixpkgsConfig = builtins.replaceStrings [ "./packages" ] [ packagesPath ] (builtins.readFile ./nixpkgs-config.nix);

in rec {
  home.packages = with pkgs; [
    atool
    wine winetricks
    davmail
    mpv
    pavucontrol
    pqiv
    inkscape krita
    xournal
    zathura
    ffmpeg-full
    freerdp
    thunderbird
    abiword
    neovim-qt
    tdesktop
    qutebrowser flashplayer-standalone google-chrome
    virtmanager virt-viewer
    mcomix
    maim
  ];

  programs = {
    home-manager.enable = true;
    git = import ./gitConfig.nix { userName = user; userEmail = email; };
    fzf.enable = true;
    pidgin = {
      enable = true;
      plugins = with pkgs; [ pidgin-latex pidgin-osd purple-hangouts telegram-purple pidgin-window-merge pidgin-skypeweb ];
    };
  };

  services = {
    flameshot.enable = true;
  };

  nixpkgs.config = import ./nixpkgs-config.nix;

  xdg.configFile."nixpkgs/config.nix".text = nixpkgsConfig;
  xdg.configFile."matplotlib".source = configs/matplotlib;
  xdg.configFile."vifm/vifmrc".source = configs/vifmrc;
  xdg.configFile."qutebrowser/config.py".source = configs/qutebrowser/config.py;
  xdg.configFile."qutebrowser/scrollbar.css".source = configs/qutebrowser/scrollbar.css;
  xdg.configFile."dunst/dunstrc".source = configs/dunstrc;

  home.file = {
    ".wcalcrc".source = configs/wcalcrc;
    ".gdbinit".source = configs/gdbinit;
    ".Xdefaults".source = configs/Xdefaults;
    ".git-prompt.sh".source = configs/git-prompt.sh;
    ".bashrc".source = configs/bashrc;
    ".themes/urxvt".source = builtins.fetchTarball https://api.github.com/repos/felixr/urxvt-color-themes/tarball/master;
  };
}
