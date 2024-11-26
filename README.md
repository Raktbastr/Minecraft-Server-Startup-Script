# Minecraft Java Server Startup Script
By: Raktbastr101

This bash script automates the creation of a Minecraft Java Server, either being Creative or Survival!

Runs on MacOS and Linux.
Batch script not coming, because batch is hard to work with :( just use WSL if you are on windows (linux is better anyway lol).

What the script does:
1. Downloads dependencies from your package manager(apt, dnf, pacman, brew) or from website(.tar.gz files or .dmg files)
2. Downloads server files from GitHub, Paper, or Minecraft
3. Creates a new server directory in your desired directory
4. Creates a Survival or Creative server
5. Downloads requested plugins
6. Accepts the EULA
7. Imports a premade world if you have one
8. Starts the server in a new tmux window

Comment if you have suggestions!

# Installation
Run the command below in a terminal with curl and bash installed (You most likely have both already).

`curl -O https://raw.githubusercontent.com/Raktbastr/Minecraft-Server-Startup-Script/refs/heads/main/mcstartupscript.sh && bash ./mcstartupscript.sh`

# Notes
* The Homebrew package manager is reccomeneded if you are using this on macOS. Download from [here](https://www.brew.sh)

* Tmux is only availible from Homebrew on macOS