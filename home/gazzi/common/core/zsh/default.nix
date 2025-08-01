{ pkgs, ... }:

{
  imports = [
    ./shortcuts.nix
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";

    # This shouldn't be necessary, but MacOS updates often remove the nix initalisation
    # from global configuration. A simple solution is to have this in my .zshrc
    initContent =
      if pkgs.stdenv.isDarwin then
        ''
          # Make sure that nix is loaded
          if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
            . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
          fi
        ''
      else
        "";
  };

  # Use direnv to manage environment variables on a per-directory basis
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
  programs.git.ignores = [ ".direnv" ]; # temporary files created by direnv

  # Use starship for a pretty and helpful shell prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {

      add_newline = true;

      character = {
        success_symbol = "[✓](bold green) [»](cyan)";
        error_symbol = "[✗](bold red) [»](cyan)";
      };

      directory.substitutions = {
        "Documents" = "📄";
        "Downloads" = "⬇️";
        "Music" = "🎵";
        "Pictures" = "📷";
        "workspace" = "⚙️";
      };

    };
  };
}
