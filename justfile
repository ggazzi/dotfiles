# Justfile for Nix dotfiles management
# Run 'just --list' to see available commands

# Internal function to run rebuild command for current host
_rebuild action:
    #!/usr/bin/env bash
    set -euo pipefail

    # Detect platform and hostname
    platform=$(uname -s)
    hostname=$(hostname)

    echo "Running {{action}} for host: $hostname ($platform)"

    # Determine if sudo is needed
    if [[ "{{action}}" == "switch" ]]; then
        echo -e "\033[1;33m⚠️  Note: This operation requires sudo privileges. You may be prompted for your password.\033[0m"
        sudo_prefix="sudo"
    else
        sudo_prefix=""
    fi

    if [[ "$platform" == "Darwin" ]]; then
        $sudo_prefix darwin-rebuild {{action}} --flake ".#$hostname"
    elif [[ "$platform" == "Linux" ]]; then
        $sudo_prefix nixos-rebuild {{action}} --flake ".#$hostname"
    else
        echo "Error: Unsupported platform: $platform"
        exit 1
    fi

    echo "{{action}} completed successfully!"

# Build config for current host without applying
build:
    just _rebuild build

# Build and apply config for current host
apply:
    just _rebuild switch

# Update flake inputs
update:
    #!/usr/bin/env bash
    set -euo pipefail

    # Check if git working tree is clean
    if ! git diff-index --quiet HEAD -- || [ -n "$(git ls-files --others --exclude-standard)" ]; then
        echo -e "\033[1;31m❌ Error: Git working tree is dirty!\033[0m"
        echo -e "\033[1;33m⚠️  The update command requires a clean repository to safely commit flake.lock.\033[0m"
        echo -e "\033[1;36m💡 Suggestion: Stash your changes first:\033[0m"
        echo -e "   \033[0;36mgit stash push -u -m \"WIP: changes before dependency update\"\033[0m"
        echo -e "\033[1;36m   Then run the update again and restore with:\033[0m"
        echo -e "   \033[0;36mgit stash pop\033[0m"
        exit 1
    fi

    echo -e "\033[1;34m🔄 Updating flake inputs...\033[0m"
    nix flake update

    # Check if flake.lock was actually modified
    if ! git diff --quiet flake.lock; then
        echo -e "\033[1;32m✅ Flake inputs updated successfully!\033[0m"
    else
        echo -e "\033[1;33m📦 No dependency updates found, flake.lock unchanged.\033[0m"
        echo -e "\033[1;32m✅ Update completed - no changes needed!\033[0m"
        exit 0
    fi

    echo -e "\033[1;35m🔍 Checking flake validity...\033[0m"
    nix flake check
    echo -e "\033[1;32m✅ Flake check passed!\033[0m"

    echo -e "\033[1;35m🧪 Testing updated configuration...\033[0m"
    just build
    echo -e "\033[1;32m✅ Configuration test passed!\033[0m"

    echo -e "\033[1;36m📝 Committing flake.lock...\033[0m"
    git add flake.lock
    git commit -m "chore: update dependencies"
    echo -e "\033[1;32m🎉 Dependencies updated and committed successfully!\033[0m"
