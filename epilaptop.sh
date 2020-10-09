#!/bin/bash
# EpiLaptop by Vincent Mardirossian tek1 [Promo 2020]

function menu()
{
    printf "\033c";
    print_top
    echo "###### 1. Install Gnome Desktop UI          #######";
    echo "###### 2. Download {EPITECH} Background     #######";
    echo "###### 3. Update Fedora & Apps              #######";
    echo "###### 4. Install Visual Studio Code        #######";
    echo "###### 5. Install Discord                   #######";
    echo "###################################################";
    echo "###################################################";
    echo "###################################################";
    echo -e "###### \e[0;31mX. Exit\e[0m ####################################";
    print_bottom
    echo "";
    echo -n "Select the wanted operation (1, 2, 3, x) : ";
    read menu_index;

    if [ $menu_index == 1 ] ; then
        menu_gnome_install
    elif [ $menu_index == 2 ] ; then
        menu_bg_open
    elif [ $menu_index == 3 ] ; then
        menu_update_install
    elif [ $menu_index == 4 ] ; then
        menu_vscode_install
    elif [ $menu_index == 5 ] ; then
        menu_discord_install
    elif [ $menu_index == 'x' ] ; then
        printf "\033c";
        exit
    else
        menu
    fi
}

function menu_bg_open()
{
    printf "\033c";
    print_top
    echo "###### X. Install Gnome Desktop UI          #######";
    echo "###### X. Download {EPITECH} Background     #######";
    echo "#########  - a) Blue Edition    ###################";
    echo "#########  - b) Green Edition   ###################";
    echo "#########  - c) Yellow Edition  ###################";
    echo "#########  - d) Red Edition     ###################";
    echo "###### X. Update Fedora & Apps              #######";
    echo "###### X. Install Visual Studio Code        #######";
    echo "###### X. Install Discord                   #######";
    print_bottom
    echo "";
    echo "Press any key to return to the main menu or Ctr-C to exit...";

    echo -n "Select the wanted operation (a, b, c, d) : ";
    read menu_index;

    if [ $menu_index == 'a' ] ; then
        wget "https://raw.githubusercontent.com/EnergyCube/EpiLaptop/main/Wallpapers/epitech_blue.png" -P "$HOME/Pictures/EPITECH"
    elif [ $menu_index == 'b' ] ; then
        wget "https://raw.githubusercontent.com/EnergyCube/EpiLaptop/main/Wallpapers/epitech_green.png" -P "$HOME/Pictures/EPITECH"
    elif [ $menu_index == 'c' ] ; then
        wget "https://raw.githubusercontent.com/EnergyCube/EpiLaptop/main/Wallpapers/epitech_yellow.png" -P "$HOME/Pictures/EPITECH"
    elif [ $menu_index == 'd' ] ; then
        wget "https://raw.githubusercontent.com/EnergyCube/EpiLaptop/main/Wallpapers/epitech_red.png" -P "$HOME/Pictures/EPITECH"
    else
        menu
    fi

    echo "If the download went well the image is in your 'Pictures' folder in the EPITECH folder, you have to right click on it to set it as wallpaper.";
    echo "Press any key to return to the main menu or Ctr-C to exit...";
    read reply;
    menu

}

function menu_update_install()
{
    printf "\033c";
    print_top
    echo "####         Updating Fedora & Apps...         ####";
    echo "###################################################";
    echo "######  This process can take between 5 to  #######";
    echo "######  20 minutes depending on the number  #######";
    echo "######        of updates to be done.        #######";
    echo "###################################################";
    echo "## Don't close this terminal during the process! ##";
    echo "####################### /!\ #######################";
    echo "###################################################";
    print_bottom
    echo "";
    echo "Pres Ctr-C to cancel the process (! EXTREMLY NOT RECOMMANDED !)...";

    echo -n "Continue ? (y, n) : ";
    read reply;

    if [ $reply == 'y' ] ; then
        # Exclude and update Teams without GPG check due to wrong signture from EPITECH Teams
        sudo dnf upgrade --exclude teams -y && sudo dnf upgrade teams --nogpgcheck -y #| grep 'Complete!' &> /dev/null
    else
        menu
    fi

    printf "\033c";
    print_top
    echo "####   Fedora & Apps : Installation Complete   ####";
    echo "###################################################";
    echo "###################################################";
    echo "###################################################";
    echo "###################################################";
    echo "###################################################";
    echo "###################################################";
    echo "###################################################";
    echo "####################### /!\ #######################";
    print_bottom
    echo "";
    echo "Press any key to return to the main menu or Ctr-C to exit...";
    read reply;
    menu
}

function menu_gnome_install()
{
    printf "\033c";
    print_top
    echo "######    Installing Gnome Desktop UI...    #######";
    echo "###################################################";
    echo "######  This process can take between 2 to  #######";
    echo "######     10 minutes depending on your     #######";
    echo "######           connection speed.          #######";
    echo "###################################################";
    echo "########### Don't close this terminal ! ###########";
    echo "####################### /!\ #######################";
    echo "###################################################";
    print_bottom
    echo "";
    echo "Pres Ctr-C to cancel the process (! NOT RECOMMANDED !)...";

    echo -n "Continue ? (y, n) : ";
    read reply;

    if [ $reply == 'y' ] ; then
        # Exclude RPM of Gnome to keep EPITECH RPM
        #sudo dnf install @gnome-desktop gnome-tweak-tool --nogpgcheck
        sudo dnf install @gnome-desktop gnome-tweak-tool --exclude rpm* -y
        apply_gnome
    else
        menu
    fi

    printf "\033c";
    print_top
    echo "#### Gnome Desktop UI : Installation Complete  ####";
    echo "###################################################";
    echo -e "###  If all goes well GNOME is now installed!   ###";
    echo -e "##  \e[1;33m/!\  Next time you start Fedora, before /!\ \e[0m ##";
    echo -e "###    \e[1;33mvalidating your password don't forget\e[0m   ####";
    echo -e "####   \e[1;33mto select 'GNOME' instead of 'Xfce' !\e[0m   ####";
    echo "###################################################";
    echo "########### Don't close this terminal ! ###########";
    echo "####################### /!\ #######################";
    print_bottom
    echo "";
    echo "Press any key to return to the main menu or Ctr-C to exit...";
    read reply;
    menu
}

function warning()
{

    printf "\033c";
    echo "###################################################";
    echo "###################################################";
    echo "     If you need help or just want to contact me   ";
    echo "         you can send me a message on Teams        ";
    echo "   or by mail at vincent.mardirossian@epitech.eu   ";
    echo "###################################################";
    echo "###################################################";
    echo -e "\e[0;31mYou are solely responsible for what this script run";
    echo -e "\e[0;31mon your machine, this script can damage your device";
    echo -e "   \e[0;31mor system. The author of the script cannot be   ";
    echo -e "     \e[0;31mresponsible for any damage or problems on     ";
    echo -e "                  \e[0;31myour computer.\e[0m                   ";
    echo "###################################################";
    echo -e "####### \e[1;33mThis program is under MIT License !\e[0m #######";
    echo "###################################################";
    echo "###################################################";
    echo "##################  [Y. ACCEPT]  ##################";
    echo "###################  [N. DENY]  ###################";
    echo "###################################################";
    echo "";

    echo -n "Do you accept the limitations of liability written above (Y/y, N/n) ? : ";
    read reply;

    if [ $reply == 'Y' ] || [ $reply == 'y' ] ; then
        menu
    else  
        exit
    fi
}

function menu_vscode_install()
{

    printf "\033c";
    print_top
    echo "######   Installing Visual Studio Code...   #######";
    echo "###################################################";
    echo -e "##   \e[0;31mIt is strictly forbidden to use any other\e[0m   ##";
    echo -e "###   \e[0;31mIDE than Emacs during c/c++/... pools !\e[0m   ###";
    echo -e "###   \e[0;31mVisual Studio Code should therefore not\e[0m   ###";
    echo -e "##########  \e[0;31mbe used during this period.\e[0m  ##########";
    echo "###################################################";
    echo "########### Don't close this terminal ! ###########";
    echo "####################### /!\ #######################";
    print_bottom
    echo "";
    echo "Pres Ctr-C to cancel the process (! NOT RECOMMANDED !)...";

    echo -n "Continue ? (y, n) : ";
    read reply;

    if [ $reply == 'y' ] ; then
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
        sudo dnf check-update
        sudo dnf install code -y
    else
        menu
    fi
    
    printf "\033c";
    print_top
    echo "### Visual Studio Code : Installation Complete  ###";
    echo "###################################################";
    echo "### If all goes well VS Code is now installed ! ###";
    echo -e "###    \e[0;31mPlease use Emacs for c/c++/... pools\e[0m     ###";
    echo -e "###   \e[0;31mI SAY EMACS, JUST EMACS !! NO VS CODE!!\e[0m   ###";
    echo "###################################################";
    echo "###################################################";
    echo "####################### /!\ #######################";
    echo "###################################################";
    print_bottom
    echo "";
    echo "Press any key to return to the main menu or Ctr-C to exit...";
    read reply;
    menu
    
}

function menu_discord_install()
{

    printf "\033c";
    print_top
    echo "######        Installing Discord...         #######";
    echo "###################################################";
    echo -e "####      \e[0;31mPlease don't use discord during\e[0m      ####";
    echo -e "####             \e[0;31mc/c++/... pools !\e[0m             ####";
    echo "###################################################";
    echo "###################################################";
    echo "###################################################";
    echo "########### Don't close this terminal ! ###########";
    echo "####################### /!\ #######################";
    print_bottom
    echo "";
    echo "Pres Ctr-C to cancel the process (! NOT RECOMMANDED !)...";

    echo -n "Continue ? (y, n) : ";
    read reply;

    if [ $reply == 'y' ] ; then
        sudo dnf install discord
    else
        menu
    fi

    printf "\033c";
    print_top
    echo "###       Discord : Installation Complete       ###";
    echo "###################################################";
    echo "### If all goes well Discord is now installed ! ###";
    echo -e "###       \e[0;31mPlease use Teams when you can !\e[0m       ###";
    echo "###################################################";
    echo "###################################################";
    echo "###################################################";
    echo "####################### /!\ #######################";
    echo "###################################################";
    print_bottom
    echo "";
    echo "Press any key to return to the main menu or Ctr-C to exit...";
    read reply;
    menu
}

function print_top()
{
    echo "###################################################";
    echo -e "################  \e[1;34mEpiLaptop v0.1\e[0m  #################";
    echo "###################################################";
    echo -e "######## \e[1;33mEdit your Fedora EPITECH System !\e[0m ########";
    echo "###################################################";
}

function print_bottom()
{
    echo "###################################################";
    echo -e "## \e[1;34m###\e[0m###\e[1;31m###\e[0m # \e[1;34mby vincent.mardirossian@epitech.eu\e[0m #";
    echo "###################################################";
    echo -e "############################### MIT License #######";
    echo "###################################################";
}

function apply_gnome()
{
    sudo systemctl disable lightdm.service && sudo systemctl enable gdm.service
}

function apply_xfce()
{
    sudo systemctl disable lightdm.service && sudo systemctl enable gdm.service
}

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

warning