# dotfiles
Here are some of my configurations and setting of my Arch Linux system and other stuff
Installing ArchLinux
pacstrap -K /mnt base linux linux-firmware
arch-chroot /mnt
# Timezone
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc

# Locales
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Keyboard layout
echo "KEYMAP=pl" > /etc/vconsole.conf

# Hostname
echo "arch-viktor" > /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1    localhost
::1          localhost
127.0.1.1    arch-viktor.localdomain arch-viktor
EOF
#Create the user
useradd -m -G wheel -s /bin/bash viktor
passwd "my password"
EDITOR=nvim visudo
uncomment # %wheel ALL=(ALL:ALL) ALL
pacman s hyprland kitty zsh obsidian
sudo pacman -S hyprland xorg-xwayland kitty ttf-fira-code swaybg swayidle pipewire pipewire-pulse wireplumber wl-clipboard
pacman -S neovim tmux git sudo base-devel networkmanager pipewire pipewire-pulse firefox
