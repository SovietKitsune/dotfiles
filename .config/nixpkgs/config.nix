{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; rec {
   cli = pkgs.buildEnv {
      name = "cli-packages";
      paths = [
        exa                         # Better ls
        bat                         # Better cat
        moc                         # Music player
        fzf                         # Fuzzy finder
        git                         # Version control
        starship                    # Prompt
        bpytop                      # System monitor
        cava                        # Audio thing
        xclip                       # Copy and paste
        neofetch                    # Fetch tool
        pulsemixer                  # Pulse audio helper
        bitwarden-cli               # Passowrd Manager
        peaclock                    # Clocks are cool
      ];
    };
    gui = pkgs.buildEnv {
      name = "gui-packages";
      paths = [
        mpv           # Video player
        nitrogen      # Wallpaper manager
        feh           # Image viewer
        spotify       # Music player
      ];
    };
    all = pkgs.buildEnv {
      name = "all";
      paths = [
        cli
        gui
      ];
    };
  };
}
