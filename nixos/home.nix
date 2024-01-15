{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mvhove";
  home.homeDirectory = "/home/mvhove";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release

  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    thunderbird
    brave
    qgis
    firefox
    armcord
    protonvpn-gui
    vscode
    lm_sensors
    gnome.gnome-tweaks
    gnome.gnome-terminal
    localsend
    steam
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.pop-shell
    protonmail-bridge
    gimp
    virt-manager
    libreoffice
    # dev stuff (this sucks kinda, may wanna have flakes for dev enviros down the road)
    (python3.withPackages(ps: with ps; [ pandas requests selenium xlrd ]))
    chromium
    chromedriver
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mvhove/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    TERMINAL = "gnome-terminal";
    BROWSER = "firefox";
    EMAIL = "thunderbird"; # syntax may be wrong, idk
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # this might work now, big if true ~~aliases, not presently working~~
  programs.bash = {
    enable = true;
    shellAliases = {
      nixconf = "sudo nano /etc/nixos/configuration.nix";
      homeconf = "sudo nano /etc/nixos/home.nix";
      flakeconf = "sudo nano /etc/nixos/flake.nix";
      rebuild = "sudo nixos-rebuild switch --upgrade";
      nixpush = "./home/mvhove/push.sh";
      nixpull = "./home/mvhove/pull.sh";
      fuck = "'sudo $(history -p !!)'";
    };
  };

  # stuff that can't be changed here
  # - default apps (browser, photos defaults to brave lmao)
  # - firefox, armcord settings
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      
      enabled-extensions = [ 
        "pop-shell@system76.com"
        "trayIconsReloaded@selfmade.pl"
      ];

      favorite-apps = [
        "firefox.desktop"
        "armcord.desktop"
        "org.gnome.Terminal.desktop"
        "org.gnome.Nautilus.desktop"
      ];

    };


    "org/gnome/mutter" = {
      dynamic-workspaces = true; 
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat"; 
    };

    "org/gtk/settings/file-chooser" = {
      clock-format = "12h"; 
    };

    "org/gnome/desktop/interface" = {
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      font-name = "Fira Sans Semi-Light 10";
      document-font-name = "Roboto 11";
      monospace-font-name = "Fira Mono 11";
      titlebar-font = "Fira Sans Semi-Bold 10";
      clock-format = "12h";
    };

    "org/gnome/desktop/wm/keybindings" = {
      maximize = [ "<Super>m" ];
      close = [ "<Super>q" ];
      move-to-monitor-left = [  ];
      move-to-workspace-left = [ "<Shift><Super>Left" ];
      move-to-monitor-right = [  ];
      move-to-workspace-right = [ "<Shift><Super>Right" ];
      switch-to-workspace-left = [ "<Control><Super>Left" ];
      switch-to-workspace-right = [ "<Control><Super>Right" ];
      panel-run-dialog = [ "<Super>r" ];
    };

    "org/gnome/shell/keybindings" = {
      toggle-message-tray = [  ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "gnome-terminal";
      name = "Open Terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>f";
      command = "firefox";
      name = "Open Firefox";
    };
   
    # unneeded so long as we're defaulting to dark mode
    #  "org/gnome/terminal/legacy" = {
    #    theme-variant = "dark";
    #  };
    
    # nope this works lmao awesome ~~probably doesn't work, theme name seems unique~~
    "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
      use-system-font = false;
      font = "Fira Mono 12";
      foreground-color = "rgb(208,207,204)";
      background-color = "rgb(23,20,33)";
      palette = [
        "rgb(23,20,33)"
        "rgb(192,28,40)"
        "rgb(255,173,212)"
        "rgb(209,187,232)"
        "rgb(18,72,139)"
        "rgb(163,71,186)"
        "rgb(42,161,179)"
        "rgb(208,207,204)"
        "rgb(94,92,100)"
        "rgb(246,97,81)"
        "rgb(255,182,193)"
        "rgb(220,208,255)"
        "rgb(42,123,222)"
        "rgb(192,97,203)"
        "rgb(51,199,222)"
        "rgb(255,255,255)"
      ];
    };

    "org/gnome/shell/extensions/pop-shell" = {
      active-hint = true;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
    };

    # swapping lalt and lwin functionality
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "terminate:ctrl_alt_bksp" "altwin:swap_lalt_lwin" ];
    };

    # virt-manager default qemu
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };

  };
  
  # doesn't appear to work, use ~/.config/mimeapps.list
  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "application/xhtml+xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
