#! /bin/bash

echo Minecraft Server Start Script
echo Created by Raktbastr101
echo '(plugins & properties not included)'
echo ' '
echo 'For MC Java Edition v1.21.1+'
echo '******************************'
read -rp "Enter PC Username: " specuser

sleep 1


# I know most of the code is wrongly indented, i wrote it before i realized this needed mac support
# and added the $unameOut if statement. It works anyway!

unameOut="$(uname -s)"
if [ "$unameOut" = Linux ] ;then
    read -rp "Do you want this script to install needed packages (tmux, java)? (y,n) " installpacks
    if [ "$installpacks" = y ] ;then
        # shellcheck disable=SC2046
        if [ $(id -u) -ne 0 ] ;then 
            echo To use this setting please run script with sudo!
            exit
        fi
        echo What package manager?
        echo 1. Apt
        echo 2. Pacman
        echo 3. Install tar.gz files and install outside of script
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
            mkdir /home/"$specuser"/mcserver-script-installed-files
            cd /home/"$specuser"/mcserver-script-installed-files || exit
            curl -O https://download.oracle.com/java/21/archive/jdk-21.0.3_linux-x64_bin.tar.gz
            curl -O https://github.com/tmux/tmux/archive/refs/heads/master.zip
            echo tmux will need to be compiled
            echo -e "\e[1;34mDownloading Done!.\e[0m"
        fi

    fi

    echo Where would you like to create server folder?
    echo 1. Home Directory
    echo 2. Documents Directory
    echo 3. Custom path from /

    read -rp "Server Folder Directory: " serverdirectory

    if [ "$serverdirectory" = 1 ] ;then
        cd /home/"$specuser" || exit
        mkdir ./ServerFiles
        serverpath=/home/$specuser/ServerFiles
        cd "$serverpath" || exit
    fi
    if [ "$serverdirectory" = 2 ] ;then
        cd /home/"$specuser"/Documents || exit
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

    echo What Kind of Server Would You Like?
    echo 1. Survival
    echo 2. Creative

    read -rp "Type of Server: " servertype

    if [ "$servertype" = 1 ] ;then
        echo Creating Survival Server...
        echo !Port Will Be 25565!
        mkdir "$serverpath"/Survival
        cd "$serverpath"/Survival || exit
        echo What Server Base?
        echo 1. Vanilla
        echo 2. Paper

        read -rp "Server Base: " serverbase

        if [ "$serverbase" = 1 ] ;then
            curl -o server.jar https://piston-data.mojang.com/v1/objects/59353fb40c36d304f2035d51e7d6e6baa98dc05c/server.jar
            curl -o server.properties https://raw.githubusercontent.com/Raktbastr/Server-Configs/refs/heads/main/survivalserver.properties
        fi
        if [ "$serverbase" = 2 ] ;then
            curl -o server.jar https://api.papermc.io/v2/projects/paper/versions/1.21.1/builds/119/downloads/paper-1.21.1-119.jar
            curl -o server.properties https://raw.githubusercontent.com/Raktbastr/Server-Configs/refs/heads/main/papersurvivalserver.properties
        fi

        echo Creating EULA file..
        sleep 2
        touch eula.txt
        echo Accepting Eula File..
        sleep 2
        printf "eula=true" >> eula.txt

        read -rp "Do you have a premade world? (y,n) " pmworld
        if [ "$pmworld" = y ] ;then
            read -rp "Enter path to folder from /:" ptworldfolder
            cp -r "$ptworldfolder" "$serverpath"/Survival/world
        fi        

        read -rp "Start Server? (y,n) " sserverstart
        if [ "$sserverstart" = y ] ;then
            tmux new-session -d -s survival 'java -jar server.jar'
            echo Tmux session started with name survival
        fi
    fi

    if [ "$servertype" = 2 ] ;then
        echo Creating Creative Server...
        echo !Port Will Be 25566!
        mkdir "$serverpath"/Creative
        cd "$serverpath"/Creative || exit
        echo What Server Base?
        echo 1. Vanilla
        echo 2. Paper

        read -rp "Server Base: " serverbase

        if [ "$serverbase" = 1 ] ;then
            curl -o server.jar https://piston-data.mojang.com/v1/objects/59353fb40c36d304f2035d51e7d6e6baa98dc05c/server.jar
            curl -o server.properties https://raw.githubusercontent.com/Raktbastr/Server-Configs/refs/heads/main/creativeserver.properties
        fi
        if [ "$serverbase" = 2 ] ;then
            curl -o server.jar https://api.papermc.io/v2/projects/paper/versions/1.21.1/builds/119/downloads/paper-1.21.1-119.jar
            curl -o server.properties https://raw.githubusercontent.com/Raktbastr/Server-Configs/refs/heads/main/papercreativeserver.properties
        fi
        
        echo Creating EULA file..
        sleep 2
        touch eula.txt
        echo Accepting Eula File..
        sleep 2
        printf "eula=true" >> eula.txt

        read -rp "Do you have a premade world? (y,n) " pmworld
        if [ "$pmworld" = y ] ;then
            read -rp "Enter path to folder from /:" ptworldfolder
            cp -r "$ptworldfolder" "$serverpath"/Creative/world
        fi

        read -rp "Start Server? (y,n) " cserverstart
        if [ "$cserverstart" = y ] ;then
            tmux new-session -d -s creative 'java -jar server.jar'
            echo Tmux session started with name creative
        fi
    fi

    # shellcheck disable=SC2046
    if [ $(id -u) -eq 0 ] ;then 
        sudo chown -R "$specuser" "$serverpath"
    fi

    echo '***************'
    echo Server Created!
    echo '***************'
fi

if [ "$unameOut" = Darwin ] ;then

    read -rp "Do you want this script to install java? (y,n) " installjava

    if [ "$installjava" = y ] ;then
        read -rp "Do you have a Intel or M-Series mac? (i or m)" intelorarm
        if [ "$intelorarm" = m ] ;then
            cd /users/"$specuser"/Downloads || exit
            curl -O https://download.oracle.com/java/21/archive/jdk-21.0.3_macos-x64_bin.dmg
            echo -e "\e[1;34mDownloading Done!.\e[0m"
        fi
    fi
    if [ "$intelorarm" = i ] ;then
        cd /users/"$specuser"/Downloads || exit
        curl -O https://download.oracle.com/java/21/archive/jdk-21.0.3_macos-aarch64_bin.dmg
        echo -e "\e[1;34mDownloading Done!.\e[0m"
    fi

    echo Where would you like to create server folder?
    echo 1. Home Directory
    echo 2. Documents Directory
    echo 3. Custom path from /

    read -rp "Server Folder Directory: " serverdirectory

    if [ "$serverdirectory" = 1 ] ;then
        cd /users/"$specuser" || exit
        mkdir ./ServerFiles
        serverpath=/home/$specuser/ServerFiles
        cd "$serverpath" || exit
    fi
    if [ "$serverdirectory" = 2 ] ;then
        cd /users/"$specuser"/Documents || exit
        mkdir ./ServerFiles
        serverpath=/users/$specuser/Documents/ServerFiles
        cd "$serverpath" || exit
    fi
    if [ "$serverdirectory" = 3 ] ;then
        read -rp "Input Path: " custompath
        cd "$custompath" || exit
        mkdir ./ServerFiles
        serverpath=$custompath/ServerFiles
        cd "$serverpath" || exit
    fi

    echo What Kind of Server Would You Like?
    echo 1. Survival
    echo 2. Creative

    read -rp "Type of Server: " servertype

    if [ "$servertype" = 1 ] ;then
        echo Creating Survival Server...
        echo !Port Will Be 25565!
        mkdir "$serverpath"/Survival
        cd "$serverpath"/Survival || exit
        echo What Server Base?
        echo 1. Vanilla
        echo 2. Paper

        read -rp "Server Base: " serverbase

        if [ "$serverbase" = 1 ] ;then
            curl -o server.jar https://piston-data.mojang.com/v1/objects/59353fb40c36d304f2035d51e7d6e6baa98dc05c/server.jar
            curl -o server.properties https://raw.githubusercontent.com/Raktbastr/Server-Configs/refs/heads/main/survivalserver.properties
        fi
        if [ "$serverbase" = 2 ] ;then
            curl -o server.jar https://api.papermc.io/v2/projects/paper/versions/1.21.1/builds/119/downloads/paper-1.21.1-119.jar
            curl -o server.properties https://raw.githubusercontent.com/Raktbastr/Server-Configs/refs/heads/main/papersurvivalserver.properties
        fi

        curl -o server.properties https://raw.githubusercontent.com/Raktbastr/Server-Configs/refs/heads/main/survivalserver.properties

        echo Creating EULA file..
        sleep 2
        touch eula.txt
        echo Accepting Eula File..
        sleep 2
        printf "eula=true" >> eula.txt

        read -rp "Do you have a premade world? (y,n) " pmworld
        if [ "$pmworld" = y ] ;then
            read -rp "Enter path to folder from /:" ptworldfolder
            cp -r "$ptworldfolder" "$serverpath"/Survival/world
        fi

        read -rp "Start Server? (y,n) " sserverstart
        if [ "$sserverstart" = y ] ;then
            tmux new-session -d -s survival 'java -jar server.jar'
            echo Tmux session started with name survival
        fi
    fi

    if [ "$servertype" = 2 ] ;then
        echo Creating Creative Server...
        echo !Port Will Be 25566!
        mkdir "$serverpath"/Creative
        cd "$serverpath"/Creative || exit
        echo What Server Base?
        echo 1. Vanilla
        echo 2. Paper

        read -rp "Server Base: " serverbase

        if [ "$serverbase" = 1 ] ;then
            curl -o server.jar https://piston-data.mojang.com/v1/objects/59353fb40c36d304f2035d51e7d6e6baa98dc05c/server.jar
            curl -o server.properties https://raw.githubusercontent.com/Raktbastr/Server-Configs/refs/heads/main/creativeserver.properties
        fi
        if [ "$serverbase" = 2 ] ;then
            curl -o server.jar https://api.papermc.io/v2/projects/paper/versions/1.21.1/builds/119/downloads/paper-1.21.1-119.jar
            curl -o server.properties https://raw.githubusercontent.com/Raktbastr/Server-Configs/refs/heads/main/papercreativeserver.properties
        fi
        
        echo Creating EULA file..
        sleep 2
        touch eula.txt
        echo Accepting Eula File..
        sleep 2
        printf "eula=true" >> eula.txt

        read -rp "Do you have a premade world? (y,n) " pmworld
        if [ "$pmworld" = y ] ;then
            read -rp "Enter path to folder from /:" ptworldfolder
            cp -r "$ptworldfolder" "$serverpath"/Creative/world
        fi

        read -rp "Start Server? (y,n) " cserverstart
        if [ "$cserverstart" = y ] ;then
            tmux new-session -d -s creative 'java -jar server.jar'
            echo Tmux session started with name creative
        fi
    fi
    
    echo '***************'
    echo Server Created!
    echo '***************'

fi