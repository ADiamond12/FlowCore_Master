#!/bin/bash

# Run this from the project root after the D05 Bash runtime has generated CSV outputs.

set -e

find_cpp_compiler() {
    local candidate

    for candidate in \
        g++ \
        c++ \
        clang++ \
        /mnt/c/msys64/mingw64/bin/g++.exe \
        /mnt/c/msys64/ucrt64/bin/g++.exe \
        /mnt/c/msys64/clang64/bin/clang++.exe \
        /c/msys64/mingw64/bin/g++.exe \
        /c/msys64/ucrt64/bin/g++.exe \
        /c/msys64/clang64/bin/clang++.exe
    do
        if command -v "$candidate" >/dev/null 2>&1; then
            printf '%s\n' "$candidate"
            return 0
        fi

        if [ -x "$candidate" ]; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    return 1
}

CPP_COMPILER="$(find_cpp_compiler)" || {
    echo "No C++ compiler found." >&2
    echo "Install g++/clang++, or add your compiler to PATH." >&2
    echo "If you are using WSL on this machine, C:\\msys64\\mingw64\\bin\\g++.exe is a supported fallback location." >&2
    exit 127
}

OUTPUT_BIN="cpp/flowcore_priority_checker.exe"

# Compile the small C++17 decision checker.
"$CPP_COMPILER" -std=c++17 -Wall -Wextra -O2 cpp/flowcore_priority_checker.cpp -o "$OUTPUT_BIN"

# Execute the checker against the current runtime files.
"$OUTPUT_BIN"
