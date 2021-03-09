let
  pkgs = import <nixpkgs> { };
  luvit-nix = pkgs.fetchFromGitHub {
    owner = "aiverson";
    repo = "luvit-nix";
    rev = "a7f19f4566a3cf133f537d35492fdb2467e69b92";
    sha256 = "1a7cr70qrcc3inr9y0gg47iqqvgi983aycnz81mv4mcy8r8d9zsy";
  };
in
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
        youtube-dl                  # YouTube downloader
        xclip                       # Copy and paste
        neofetch                    # Fetch tool
        pulsemixer                  # Pulse audio helper
        bitwarden-cli               # Passowrd Manager
        peaclock                    # Clocks are cool
        (import luvit-nix {}).lit   # Luvit package manager
        (import luvit-nix {}).luvi  # Lua bundler
        (import luvit-nix {}).luvit # Luvit runtime
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
