# Minecraft Java Server Startup Script
By: Raktbastr101

This bash script automates the creation of a Minecraft Java Server, either being Creative or Survival!

Runs on MacOS and Linux.
Batch script not coming, because batch is hard to work with :( just use WSL if you are on windows (linux is better anyway).

What the script does:
1. Creates Server Folders in desired directory
2. Downloads needed dependencies, either from package manager (apt or pacman, request others if needed) or as tar.gz files.
3. Installs them if possible
4. Downloads server files
5. Accepts the EULA
6. Downloads premade server.properties files with preset gamemodes
7. Starts server inside tmux session if wanted

Comment if you have suggestions!

# Installation
Run the command below in a terminal with curl and bash installed (You most likely have it already).

`curl -O https://raw.githubusercontent.com/Raktbastr/Minecraft-Server-Startup-Script/refs/heads/main/mcstartupscript.sh && bash ./mcstartupscript.sh`
