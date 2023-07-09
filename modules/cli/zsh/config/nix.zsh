# Make sure that nix is loaded
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# This shouldn't be necessary, but MacOS updates often remove the nix initaliation
# from global configuration. A simple solution is to have this in my .zshrc
