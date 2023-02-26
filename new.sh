#!/bin/bash

# Global
TXT_RN="\e[36mRunning\e[0m"
TXT_SK="\e[31mSkipped\e[0m"
TXT_OK="\e[32mSuccess\e[0m"
TXT_KO="\e[31mFailure\e[0m"

FEDORA_UPGRADE_VERSION="36"
GNOME_DISPLAY_MANAGER_STATE=$(systemctl is-active gdm.service)


# Utils
function current_user {
    # We simply identify error with an uuid since the user can have
    # the bad idea to be named "error", "unknown" etc...
    TEKUSERNAME=${SUDO_USER:-${USERNAME:-a91ac05df4c640f8b00146b51f60afd1}}
    if [ "$TEKUSERNAME" = "root" ] || [ "$TEKUSERNAME" = "" ]; then
        TEKUSERNAME="a91ac05df4c640f8b00146b51f60afd1"
    fi
}

# Desktop Environment

function install_gnome()
{
    dnf install @gnome-desktop gnome-tweak-tool --skip-broken --exclude cheese gnome-boxes -y
}

function enable_gnome()
{
    systemctl disable lightdm.service && sudo systemctl enable gdm.service
    echo -e "\e[31mWARNING\e[0m: After the coming reboot, you will have to select GNOME as your desktop environment."
    echo -e "   You can do it by clicking on the gear icon on the login screen (before validating your password)."
    echo -e "   There is multile choice, select GNOME (or GNOME on Xorg if you have problem with screensharing)."
    echo -e "\e[31mATTENTION\e[0m: Après le prochain redémarrage, vous devrez sélectionner GNOME comme environnement de bureau."
    echo -e "   Vous pouvez le faire en cliquant sur l'icône de l'engrenage sur l'écran de connexion (avant de valider votre mot de passe)."
    echo -e "   Il y a plusieurs choix, sélectionnez GNOME (ou GNOME sur Xorg si le premier ne fonctionne pas ou rencontre des problèmes de partage d'écran)."
    echo ""
    read -p "Press enter to reboot and upgrade your system..."
    reboot
}

function uninstall_xfce_and_co()
{
    # Yep qt-1:* don't ask me why that the only way to uninstall it from cli from what I found
    dnf remove @Xfce *xfce* galculator asunder xterm xscreensaver xarchiver qt-1:* gnumeric claws-mail geany mousepad pidgin --exclude firewall-config -y
}

# Desktop Environment Settings

function gnome_theme()
{
    echo "Please choose a theme:"
    echo "d. Dark"
    echo "l. Light"
    read gnome_theme;
    if [ $gnome_theme = 'l' ] ; then
        sudo -u $TEKUSERNAME gsettings set org.gnome.desktop.interface color-scheme prefer-light
        sudo -u $TEKUSERNAME gsettings set org.gnome.desktop.interface icon-theme "Papirus"
    elif [ $gnome_theme = 'd' ] ; then
        sudo -u $TEKUSERNAME gsettings set org.gnome.desktop.interface color-scheme prefer-dark
        sudo -u $TEKUSERNAME gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
    else
        echo "Invalid theme!"
        gnome_theme
    fi
}

function gnome_settings()
{
    sudo dnf install gnome-shell-extension-user-theme -y;

    mkdir -p "/usr/share/backgrounds/epitech/"
    wget "https://raw.githubusercontent.com/EnergyCube/EpiLaptop/main/Wallpapers/epitech_blue.png" -O "/usr/share/backgrounds/epitech/epitech_blue.png"
    chmod 666 "/usr/share/backgrounds/epitech/epitech_blue.png"
    sudo -u $TEKUSERNAME gsettings set org.gnome.desktop.background picture-uri "/usr/share/backgrounds/epitech/epitech_blue.png"
    sudo -u $TEKUSERNAME gsettings set org.gnome.desktop.background picture-uri-dark "/usr/share/backgrounds/epitech/epitech_blue.png"
    sudo -u $TEKUSERNAME gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
    sudo dnf install papirus-icon-theme -y
    gnome_theme
}

# Gnome Extensions

function gnome_extensions()
{
    sudo dnf install gettext libgettextpo-dev gnome-shell-extension-user-theme -y;

    sudo -u $TEKUSERNAME git clone https://github.com/home-sweet-gnome/dash-to-panel.git
    cd dash-to-panel/
    make install
    rm -rf dash-to-panel/
    sudo -u $TEKUSERNAME gnome-extensions enable dash-to-panel@jderose9.github.com

    sudo -u $TEKUSERNAME git clone https://gitlab.com/arcmenu/ArcMenu.git
    cd ArcMenu/
    ls
    make install
    rm -rf ArcMenu/
    sudo -u $TEKUSERNAME gnome-extensions enable arcmenu@arcmenu.com


    sudo -u $TEKUSERNAME dconf load /org/gnome/shell/extensions/dash-to-panel/ <<END
[/]
animate-appicon-hover=true
animate-appicon-hover-animation-convexity={'RIPPLE': 2.0, 'PLANK': 1.0, 'SIMPLE': 0.0}
animate-appicon-hover-animation-duration={'SIMPLE': uint32 200, 'RIPPLE': 130, 'PLANK': 100}
animate-appicon-hover-animation-extent={'RIPPLE': 4, 'PLANK': 4, 'SIMPLE': 1}
animate-appicon-hover-animation-rotation={'SIMPLE': 0, 'RIPPLE': 10, 'PLANK': 0}
animate-appicon-hover-animation-travel={'SIMPLE': 0.10000000000000001, 'RIPPLE': 0.40000000000000002, 'PLANK': 0.0}
animate-appicon-hover-animation-type='SIMPLE'
animate-appicon-hover-animation-zoom={'SIMPLE': 1.1499999999999999, 'RIPPLE': 1.25, 'PLANK': 2.0}
appicon-margin=4
appicon-padding=6
available-monitors=[0]
click-action='CYCLE-MIN'
desktop-line-custom-color='rgba(200,200,200,0.2)'
desktop-line-use-custom-color=false
dot-color-1='#5294e2'
dot-color-2='#5294e2'
dot-color-3='#5294e2'
dot-color-4='#5294e2'
dot-color-dominant=false
dot-color-override=false
dot-color-unfocused-1='#5294e2'
dot-color-unfocused-2='#5294e2'
dot-color-unfocused-3='#5294e2'
dot-color-unfocused-4='#5294e2'
dot-color-unfocused-different=false
dot-position='BOTTOM'
dot-size=3
dot-style-focused='DASHES'
dot-style-unfocused='DASHES'
focus-highlight=false
focus-highlight-color='#EEEEEE'
focus-highlight-dominant=false
focus-highlight-opacity=10
group-apps=true
hide-overview-on-startup=true
hot-keys=false
hotkeys-overlay-combo='TEMPORARILY'
intellihide=false
isolate-monitors=false
isolate-workspaces=true
leftbox-padding=-1
leftbox-size=0
middle-click-action='LAUNCH'
overview-click-to-exit=false
panel-anchors='{"0":"MIDDLE"}'
panel-element-positions='{"0":[{"element":"showAppsButton","visible":false,"position":"centerMonitor"},{"element":"leftBox","visible":true,"position":"centerMonitor"},{"element":"activitiesButton","visible":true,"position":"centerMonitor"},{"element":"taskbar","visible":true,"position":"centerMonitor"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}'
panel-element-positions-monitors-sync=true
panel-lengths='{"0":100}'
panel-positions='{"0":"BOTTOM"}'
panel-sizes='{"0":54}'
primary-monitor=0
progress-show-count=true
secondarymenu-contains-showdetails=false
shift-click-action='MINIMIZE'
shift-middle-click-action='LAUNCH'
show-appmenu=false
show-apps-icon-file=''
show-apps-icon-side-padding=8
show-apps-override-escape=true
show-favorites=true
show-favorites-all-monitors=true
show-running-apps=true
show-showdesktop-delay=1000
show-showdesktop-hover=false
show-showdesktop-time=300
show-window-previews=true
showdesktop-button-width=6
status-icon-padding=4
stockgs-force-hotcorner=false
stockgs-keep-dash=false
stockgs-keep-top-panel=false
stockgs-panelbtn-click-only=false
taskbar-locked=false
trans-gradient-bottom-color='#062c50'
trans-gradient-bottom-opacity=0.40000000000000002
trans-gradient-top-color='#01172c'
trans-gradient-top-opacity=0.80000000000000004
trans-panel-opacity=0.90000000000000002
trans-use-custom-bg=true
trans-use-custom-gradient=true
trans-use-custom-opacity=false
trans-use-dynamic-opacity=false
tray-padding=-1
tray-size=0
window-preview-title-position='TOP'
END

    sudo -u $TEKUSERNAME dconf load /org/gnome/shell/extensions/arcmenu/ <<END
[/]
apps-show-extra-details=true
arc-menu-icon=0
button-padding=-1
category-icon-type='Symbolic'
custom-menu-button-icon='/home/vincent/Pictures/Wallpapers/icon_energycube.png'
custom-menu-button-icon-size=38.0
custom-menu-button-text=''
dash-to-panel-standalone=false
disable-scrollview-fade-effect=false
distro-icon=2
eleven-disable-frequent-apps=false
enable-standlone-runner-menu=false
extra-categories=[(0, true), (1, true), (2, false), (3, false), (4, false)]
force-menu-location='BottomCentered'
highlight-search-result-terms=true
left-panel-width=200
menu-arrow-rise=(false, 6)
menu-background-color='rgba(48,48,49,0.98)'
menu-border-color='rgb(60,60,60)'
menu-button-appearance='Icon'
menu-button-border-color=(false, 'transparent')
menu-button-border-radius=(true, 8)
menu-button-border-width=(false, 3)
menu-button-fg-color=(false, 'rgb(242,242,242)')
menu-button-hover-fg-color=(false, 'rgb(242,242,242)')
menu-button-icon='Custom_Icon'
menu-button-position-offset=0
menu-foreground-color='rgb(223,223,223)'
menu-height=650
menu-hotkey='Super_L'
menu-item-active-bg-color='rgb(25,98,163)'
menu-item-active-fg-color='rgb(255,255,255)'
menu-item-hover-bg-color='rgb(21,83,158)'
menu-item-hover-fg-color='rgb(255,255,255)'
menu-layout='Eleven'
menu-separator-color='rgba(255,255,255,0.1)'
menu-width-adjustment=0
multi-lined-labels=true
multi-monitor=true
override-menu-theme=false
pinned-app-list=['Microsoft Edge', '', 'com.microsoft.Edge.desktop', 'CLion 2022.2.3', '', 'jetbrains-clion.desktop', 'WebStorm 2022.2.2', '', 'jetbrains-webstorm.desktop', 'Rider 2022.2.3', '', 'jetbrains-rider.desktop', 'Files', '', 'org.gnome.Nautilus.desktop', 'Terminal', '', 'org.gnome.Terminal.desktop', 'Discord', '', 'com.discordapp.Discord.desktop', 'ArcMenu Settings', '/home/vincent/.local/share/gnome-shell/extensions/arcmenu@arcmenu.com/media/icons/menu_icons/arc-menu-symbolic.svg', 'gnome-extensions prefs arcmenu@arcmenu.com']
position-in-panel='Left'
power-display-style='Default'
power-options=[(0, true), (1, true), (4, true), (3, true), (2, true), (5, false), (6, false)]
prefs-visible-page=0
recently-installed-apps=['com.github.eneshecan.WhatsAppForLinux.desktop']
right-panel-width=200
search-entry-border-radius=(true, 8)
settings-height=725
settings-width=775
show-activities-button=false
show-external-devices=false
show-hidden-recent-files=false
show-search-result-details=true
unity-pinned-app-list=['Home', 'ArcMenu_Home', 'ArcMenu_Home', 'Documents', 'ArcMenu_Documents', 'ArcMenu_Documents', 'Downloads', 'ArcMenu_Downloads', 'ArcMenu_Downloads', 'Software', '', 'org.gnome.Software.desktop', 'Files', '', 'org.gnome.Nautilus.desktop', 'Log Out', 'application-exit-symbolic', 'ArcMenu_LogOut', 'Lock', 'changes-prevent-symbolic', 'ArcMenu_Lock', 'Power Off', 'system-shutdown-symbolic', 'ArcMenu_PowerOff']
vert-separator=false
END

    # sudo -u $TEKUSERNAME busctl --user call "org.gnome.Shell" "/org/gnome/Shell" "org.gnome.Shell" "Eval" "s" 'Meta.restart("Restarting…")';
}

# Fedora Update

function update_fedora()
{
    echo -ne "    Updating Fedora\t\t\t[$TXT_RN]\r"
    if ! dnf upgrade --refresh --best --allowerasing --skip-broken --nogpgcheck -y >/dev/null 2>&1
    then
        echo -e "    Updating Fedora\t\t\t[$TXT_KO]"
        exit
    else
        echo -e "    Updating Fedora\t\t\t[$TXT_OK]"
    fi

    echo -ne "    Cleaning update files\t\t[$TXT_RN]\r"
    if ! dnf clean all -y >/dev/null 2>&1
    then
        echo -e "    Cleaning update files\t\t[$TXT_KO]"
        exit
    else
        echo -e "    Cleaning update files\t\t[$TXT_OK]"
    fi
}

function upgrade_fedora()
{
    source /etc/os-release

    if [ "$VERSION_ID" = "" ]; then
        echo "Error: VERSION_ID not found!"
        exit
    fi

    if [ $(("$VERSION_ID" + 0)) -lt $(("$FEDORA_UPGRADE_VERSION" + 0)) ]; then

        echo -ne "    Installing upgrade plugin\t\t[$TXT_RN]\r"
        if ! dnf install dnf-plugin-system-upgrade -y >/dev/null 2>&1
        then
            echo -e "    Installing upgrade plugin\t\t[$TXT_KO]"
            exit
        else
            echo -e "    Installing upgrade plugin\t\t[$TXT_OK]"
        fi

        echo -ne "    Upgrading system (Fedora $VERSION_ID => $FEDORA_UPGRADE_VERSION)\t[$TXT_RN]\r"
        if ! dnf system-upgrade download --releasever=$FEDORA_UPGRADE_VERSION --allowerasing --skip-broken --nogpgcheck --exclude ffmpeg,pipewire-utils -y >/dev/null 2>&1
        then
            echo -e "    Upgrading system (Fedora $VERSION_ID => $FEDORA_UPGRADE_VERSION)\t[$TXT_KO]"
            exit
        else
            echo -e "    Upgrading system (Fedora $VERSION_ID => $FEDORA_UPGRADE_VERSION)\t[$TXT_OK]"
            echo ""
            read -p "Press enter to reboot and upgrade your system..."
            dnf system-upgrade reboot
        fi
    else
        echo -e "    Upgrading system (Not required)\t[$TXT_SK]"
    fi
}

function wifi_fix()
{
    sudo update-crypto-policies --set DEFAULT:FEDORA32
}

# Additional Software

function install_mendatory_apps()
{
    echo -ne "    Installing mendatory apps\t\t[$TXT_RN]\r"
    if ! dnf install git wget htop make glibc-langpack-fr -y >/dev/null 2>&1
    then
        echo -e "    Installing mendatory apps\t\t[$TXT_KO]"
        exit
    else
        echo -e "    Installing mendatory apps\t\t[$TXT_OK]"
    fi
}

function install_browser()
{
    echo "Please choose a browser:"
    echo "0. I don't want to install a new browser"
    echo "1. Brave"
    echo "2. Firefox"
    echo "3. Chrome"
    echo "4. Chromium"
    echo "5. Edge (Allow Epitech account browser login)"
    read gnome_theme;
    if [ $gnome_theme == '0' ] ; then
        echo "Okay!"
    elif [ $gnome_theme == '1' ] ; then
        flatpak install --app flathub com.brave.Browser -y
    elif [ $gnome_theme == '2' ] ; then
        flatpak install --app flathub org.mozilla.firefox -y
    elif [ $gnome_theme == '3' ] ; then
        flatpak install --app flathub com.google.Chrome -y
    elif [ $gnome_theme == '4' ] ; then
        flatpak install --app flathub org.chromium.Chromium -y
    elif [ $gnome_theme == '5' ] ; then
        flatpak install --app flathub com.microsoft.Edge -y
    else
        echo "Invalid browser!"
        install_browser
    fi
}

function install_additional_apps()
{
    # Uninstall DNF teams & discord (because not enough up to date)
    sudo dnf remove teams discord -y

    # Ensure flatpak install and repo
    sudo dnf install flatpak -y
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    # Install teams & discord & Gnome Extention Manager from flatpak (flathub)
    flatpak install --app flathub com.microsoft.Teams com.discordapp.Discord com.mattjakeman.ExtensionManager -y
    # Rename "Microsoft Teams - Preview" => "Microsoft Teams"
    sudo sed -i "s/Name=Microsoft Teams - Preview/Name=Microsoft Teams/" /var/lib/flatpak/exports/share/applications/com.microsoft.Teams.desktop
    sudo dnf install virt-manager
    install_browser
}

# Actual script

# Ensure we are root
if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

echo "Welcome to EpiLaptop!"
echo -e "\e[33mSome operation can take a while, please be patient!\e[0m"

# Routine
echo ""
echo "Routine"
current_user
echo -ne "    Checking current user\t\t[$TXT_RN]\r"
if [ $TEKUSERNAME = "a91ac05df4c640f8b00146b51f60afd1" ]; then
    echo -e "    Checking current user\t\t[$TXT_KO]"
    exit 84
else
    echo -e "    Checking current user\t\t[$TXT_OK]"
fi
install_mendatory_apps

# System Update
echo ""
echo "Fedora Update/Upgrade"
update_fedora
upgrade_fedora

if [ $GNOME_DISPLAY_MANAGER_STATE = "active" ]; then
    echo ""
    echo "Gnome is already installed"

    echo ""
    echo "Configuring Gnome"
    gnome_settings
    gnome_extensions
    uninstall_xfce_and_co
else
    echo ""
    echo "Installing Gnome"
    # Install Gnome
    install_gnome
    enable_gnome
fi
