#!/bin/bash

# Check that at least one argument (executable) has been passed
if [ $# -lt 1 ]; then
    echo "Usage: $0 <executable_path> [args...]"
    exit 1
fi

# 1. Take the first argument as the command to run and shift the $@ array
APP_EXEC="$1"
shift

# Default base directory
TARGET_DIR="/work"

# Function for URL decoding (turns %20 into spaces, decodes Cyrillic, etc.)
urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

# Look for the first argument that is an existing file or directory
for arg in "$@"; do
    # 1. Strip protocol prefix if present
    clean_arg="${arg#file://}"
    
    # 2. Decode the URL if KDE/GNOME/Windows passed an escaped path
    if [[ "$clean_arg" == *%* ]]; then
        clean_arg=$(urldecode "$clean_arg")
    fi

    # 3. WSL2 AND WINDOWS PATH SUPPORT
    if [[ "$clean_arg" =~ ^/?([a-zA-Z]:[\\/].*) ]]; then
        clean_arg="${BASH_REMATCH[1]}" # Remove leading slash, keep "C:/..."
        
        # If we are in WSL, convert Windows path to Linux path (/mnt/c/...)
        if command -v wslpath >/dev/null 2>&1; then
            clean_arg=$(wslpath -u "$clean_arg" 2>/dev/null || echo "$clean_arg")
        fi
    fi

    # 4. Check if the directory or file exists (with protection against filenames starting with a dash)
    if [ -d -- "$clean_arg" ]; then
        TARGET_DIR="$clean_arg"
        break
    elif [ -f -- "$clean_arg" ]; then
        TARGET_DIR=$(dirname -- "$clean_arg")
        break
    fi
done

# 5. TOMCAT MAGIC: Convert the path to absolute and resolve all symlinks.
if command -v realpath >/dev/null 2>&1; then
    TARGET_DIR=$(realpath "$TARGET_DIR")
else
    # Reliable POSIX fallback for systems without the realpath utility
    TARGET_DIR=$(cd "$TARGET_DIR" 2>/dev/null && pwd -P)
fi

# 6. Change to the resolved directory and execute the requested app via mise
cd "$TARGET_DIR" || exit 1

# Use APP_EXEC, while $@ now contains only flags and files (since we performed shift)
exec ~/.local/bin/mise exec -- "$APP_EXEC" "$@"

#
#DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
