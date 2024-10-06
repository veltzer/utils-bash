#!/bin/bash -e

# Function to print colored output
print_color() {
    case $1 in
        "green") echo -e "\033[0;32m$2\033[0m" ;;
        "red") echo -e "\033[0;31m$2\033[0m" ;;
        "yellow") echo -e "\033[0;33m$2\033[0m" ;;
    esac
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required commands
check_requirements() {
    local missing_requirements=0

    if ! command_exists nvim
    then
        print_color "red" "Error: Neovim is not installed. Please install Neovim 0.8.0+ (0.9+ recommended)."
        missing_requirements=1
    fi

    if ! command_exists git
    then
        print_color "red" "Error: Git is not installed. Please install Git."
        missing_requirements=1
    fi

    if [ "${missing_requirements}" -eq 1 ]
    then
        exit 1
    fi
}

# Main setup function
setup_lazyvim() {
    print_color "yellow" "This script will set up LazyVim for Neovim."
    print_color "yellow" "It will backup your existing Neovim configuration if it exists."
    read -p "Do you want to proceed? (y/n): " -n 1 -r
    echo
    if [[ ! "${REPLY}" =~ ^[Yy]$ ]]
    then
        print_color "yellow" "Setup cancelled."
        exit 0
    fi

    # Backup existing configuration
    if [ -d ~/.config/nvim ]
    then
        print_color "yellow" "Backing up existing Neovim configuration..."
        mv ~/.config/nvim "${HOME}/.config/nvim.bak.$(date +%Y%m%d%H%M%S)"
    fi

    # Optional backups
    for dir in ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
    do
        if [ -d "${dir}" ]
	then
            print_color "yellow" "Backing up ${dir}..."
            mv "${dir}" "${dir}.bak.$(date +%Y%m%d%H%M%S)"
        fi
    done

    # Clone LazyVim starter
    print_color "green" "Cloning LazyVim starter..."
    git clone https://github.com/LazyVim/starter ~/.config/nvim

    # Remove .git folder
    print_color "green" "Removing .git folder..."
    rm -rf ~/.config/nvim/.git

    print_color "green" "LazyVim setup complete!"
    print_color "yellow" "You can now start Neovim by running 'nvim'."
    print_color "yellow" "LazyVim will automatically install plugins on first run."
}

# Run the script
check_requirements
setup_lazyvim
