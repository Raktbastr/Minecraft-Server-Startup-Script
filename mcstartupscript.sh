#! /bin/bash

echo Minecraft Server Start Script
echo Created by Raktbastr101
echo '(plugins & port-forwarding not included)'
echo ' '
echo 'For MC Java Edition v1.21.1'
echo '******************************'
read -rp "Enter Username (case-sensitive, usually in bash prompt): " specuser

if [ "$specuser" = root ] ;then
    # shellcheck disable=SC1010
    echo Root account not supported, also please do NOT do daily tasks as root user!
    exit
fi

sleep 1

unameOut="$(uname -s)"
if [ "$unameOut" = Linux ] ;then
    homedir=home
    read -rp "Do you want this script to install needed packages (tmux, java)? (y,n) " installpacks
    if [ "$installpacks" = y ] ;then
        # shellcheck disable=SC2046
        if [ $(id -u) -ne 0 ] ;then 
            echo To download packages please run script with sudo!
            exit
        fi
        echo What package manager?
        echo "1. apt (Ubuntu, Debian, PopOS, Mint)"
        echo "2. pacman (Arch, Manjaro)"
        echo "3. dnf (Fedora)"
        echo 4. Download tar.gz files and install outside of script
        read -rp "Package manager: " packagemanager

        if [ "$packagemanager" = 1 ] ;then
            sudo apt-get -y install tmux
            mkdir /home/"$specuser"/mcserverscripttempfiles
            cd /home/"$specuser"/mcserverscripttempfiles || exit
            curl -O https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb
            sudo dpkg -i ./jdk-21_linux-x64_bin.deb
            cd ..
            rm -rf /home/"$specuser"/mcserverscripttempfiles
            echo -e "\e[1;34mDownloading Done!.\e[0m"
        fi

        if [ "$packagemanager" = 2 ] ;then
            sudo pacman -S --noconfirm tmux curl jdk21-openjdk
            echo -e "\e[1;34mDownloading Done!.\e[0m"
        fi

        if [ "$packagemanager" = 3 ] ;then
            sudo dnf install --assumeyes java-21-openjdk-devel
            sudo dnf install --assumeyes tmux
            echo -e "\e[1;34mDownloading Done!.\e[0m"

        fi

        if [ "$packagemanager" = 4 ] ;then
            mkdir /home/"$specuser"/mcserver-script-installed-files
            cd /home/"$specuser"/mcserver-script-installed-files || exit
            curl -O https://download.oracle.com/java/21/archive/jdk-21.0.3_linux-x64_bin.tar.gz
            curl -O https://github.com/tmux/tmux/archive/refs/heads/master.zip
            echo Tmux will need to be compiled. Files are in ~/mcserver-script-installed-files
            echo -e "\e[1;34mDownloading Done!.\e[0m"
            installpacs=n
        fi
    fi
fi

if [ "$unameOut" = Darwin ] ;then
    homedir=users
    read -rp "Do you have homebrew installed? (package manager)? (y,n) " homebrewinst
    if [ "$homebrewinst" = y ] ;then
        read -rp "Do you want this script to install tmux and Java with brew? (y,n) " installpacs
        if [ "$installpacs" = y ] ;then
            brew install tmux
            brew install openjdk@21
        fi
    else
        read -rp "Do you want this script to install java? (y,n) " installjava
        if [ "$installjava" = y ] ;then
            read -rp "Do you have a Intel or M-Series mac? (i or m)" intelorarm
            if [ "$intelorarm" = m ] ;then
                cd /users/"$specuser"/Downloads || exit
                curl -O https://download.oracle.com/java/21/archive/jdk-21.0.3_macos-x64_bin.dmg
                echo -e "\e[1;34mDownloading Done!.\e[0m"
                open ~/Downloads
                installpacs=n
            fi
            if [ "$intelorarm" = i ] ;then
                cd /users/"$specuser"/Downloads || exit
                curl -O https://download.oracle.com/java/21/archive/jdk-21.0.3_macos-aarch64_bin.dmg
                echo -e "\e[1;34mDownloading Done!.\e[0m"
                open ~/Downloads
                installpacs=n
            fi
        fi
    fi
fi

echo Where would you like to create server folder?
echo 1. Home Directory
echo 2. Documents Directory
echo 3. Custom path from /

read -rp "Server Folder Directory: " serverdirectory

if [ "$serverdirectory" = 1 ] ;then
    cd /"$homedir"/"$specuser" || exit
    mkdir ./ServerFiles
    serverpath=/home/$specuser/ServerFiles
    cd "$serverpath" || exit
fi
if [ "$serverdirectory" = 2 ] ;then
    mkdir /"$homedir"/"$specuser"/Documents
    cd /"$homedir"/"$specuser"/Documents || exit
    mkdir ./ServerFiles
    serverpath=/home/$specuser/Documents/ServerFiles
    cd "$serverpath" || exit
fi
if [ "$serverdirectory" = 3 ] ;then
    read -rp "Input Path: " custompath
    cd "$custompath" || exit
    mkdir ./ServerFiles
    serverpath=$custompath/ServerFiles
    cd "$serverpath" || exit
fi

echo What Server Type?
echo 1. Survival
echo 2. Creative

read -rp "Server Type: " servertype
if [ "$servertype" = 1 ] ;then
    type=survival
    mkdir ./"$type"
    cd ./"$type" || exit
fi

if [ "$servertype" = 2 ] ;then
    type=creative
    mkdir ./"$type"
    cd ./"$type" || exit
fi

echo What Server Base?
echo 1. Vanilla
echo 2. Paper

read -rp "Server Base: " serverbase
if [ "$serverbase" = 1 ] ;then
    curl -o server.jar https://piston-data.mojang.com/v1/objects/59353fb40c36d304f2035d51e7d6e6baa98dc05c/server.jar
    curl -o server.properties https://raw.githubusercontent.com/Raktbastr/Server-Configs/refs/heads/main/"$type"server.properties
fi

if [ "$serverbase" = 2 ] ;then
    curl -o server.jar https://api.papermc.io/v2/projects/paper/versions/1.21.1/builds/119/downloads/paper-1.21.1-119.jar
    curl -o server.properties https://raw.githubusercontent.com/Raktbastr/Server-Configs/refs/heads/main/paper"$type"server.properties
    mkdir ./plugins
    cd ./plugins || exit
    read -rp "Would you like do install Geyser/Floodgate (Bedrock compatability, manual config necessary)? (y/n)" geyserinst
    if [ "$geyserinst" = y ] ;then
        mkdir ./plugins
        cd ./plugins || exit
        curl -O "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot"
        curl -O "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot"
        echo -e "\e[1;34mDownloading Done!.\e[0m"
    fi
    read -rp "How many plugins do you want to add? (0-5)" pluginnumber
        case $pluginnumber in
        0)
            echo '0 plugins selected!'
            ;;
        1)
            mkdir ./plugins
            cd ./plugins || exit
            read -rp "Link Number 1: " link1
            curl -O "$link1"
            cd ..
            echo -e "\e[1;34mDownloading Done!.\e[0m"
            ;;
        2)
            mkdir ./plugins
            cd ./plugins || exit
            read -rp "Link Number 1: " link1
            curl -O "$link1"
            read -rp "Link Number 2: " link2
            curl -O "$link2"
            cd ..
            echo -e "\e[1;34mDownloading Done!.\e[0m"
            ;;
        3)
            mkdir ./plugins
            cd ./plugins || exit
            read -rp "Link Number 1: " link1
            curl -O "$link1"
            read -rp "Link Number 2: " link2
            curl -O "$link2"
            read -rp "Link Number 3: " link3
            curl -O "$link3"
            cd ..
            echo -e "\e[1;34mDownloading Done!.\e[0m"
            ;;
        4)
            mkdir ./plugins
            cd ./plugins || exit
            read -rp "Link Number 1: " link1
            curl -O "$link1"
            read -rp "Link Number 2: " link2
            curl -O "$link2"
            read -rp "Link Number 3: " link3
            curl -O "$link3"
            read -rp "Link Number 4: " link4
            curl -O "$link4"
            cd ..
            echo -e "\e[1;34mDownloading Done!.\e[0m"
            ;;
        5)
            mkdir ./plugins
            cd ./plugins || exit
            read -rp "Link Number 1: " link1
            curl -O "$link1"
            read -rp "Link Number 2: " link2
            curl -O "$link2"
            read -rp "Link Number 3: " link3
            curl -O "$link3"
            read -rp "Link Number 4: " link4
            curl -O "$link4"
            read -rp "Link Number 5: " link5
            curl -O "$link5"
            cd ..
            echo -e "\e[1;34mDownloading Done!.\e[0m"
            ;;
    esac
fi

echo Creating EULA file..
sleep 2
touch eula.txt
echo Accepting EULA File..
sleep 2
printf "eula=true" >> eula.txt

read -rp "Do you have a premade world? (y,n) " pmworld
if [ "$pmworld" = y ] ;then
    read -rp "Enter path to folder from /:" ptworldfolder
    cp -r "$ptworldfolder" "$serverpath"/"$type"/world
fi

read -rp "Do you have a server icon (must be 64x64 pixels)? (y,n) " icon
if [ "$icon" = y ] ;then
    read -rp "Enter path to icon from /:" pticon
    cp -r "$pticon" "$serverpath"/"$type"/server-icon.png
fi

read -rp "Start Server? (y,n) " serverstart
if [ "$serverstart" = y ] ;then
    if [ "$installpacs" = n ] ;then
        echo Tmux and/or java are downloaded but need to be installed, please start server manually after.
        sleep 1
        echo Once installed please type the following command in a terminal.
        cd "$serverpath"/"$type" tmux new-session -d -s "$type" 'java -jar server.jar' || exit
    else 
        tmux new-session -d -s "$type" 'java -jar server.jar'
        echo Tmux session started with name "$type"
    fi
fi

# shellcheck disable=SC2046
if [ $(id -u) -eq 0 ] ;then 
    sudo chown -R "$specuser" "$serverpath"
fi

echo '*************************'
echo Server Created! Have Fun!
echo '*************************'