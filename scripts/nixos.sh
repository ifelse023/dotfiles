DISK=/dev/nvme0n1 # or /dev/nvme0 as needed

setup_disk() {
	sudo parted "$DISK" -- mklabel gpt
	sudo parted "$DISK" -- mkpart ESP fat32 1MiB 1GiB
	sudo parted "$DISK" -- set 1 boot on
	sudo mkfs.vfat -F 32 -n BOOT /dev/nvme0n1p1

	sudo parted "$DISK" -- mkpart Swap linux-swap 1GiB 20GiB
	sudo mkswap -L SWAP /dev/nvme0n1p2
	sudo swapon /dev/nvme0n1p2

	sudo parted "$DISK" -- mkpart primary 20GiB 100%
	sudo mkfs.btrfs -L NIXOS /dev/nvme0n1p3
}

setup_subvolumes() {
	sudo mount -t btrfs /dev/nvme0n1p3 /mnt

	sudo btrfs subvolume create /mnt/root
	sudo btrfs subvolume create /mnt/home # New subvolume for /home
	sudo btrfs subvolume create /mnt/nix
	sudo btrfs subvolume create /mnt/persist
	sudo btrfs subvolume create /mnt/log

	sudo btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
	sudo umount /mnt
}

mount_subvolumes() {
	sudo mount -o subvol=root,compress=zstd,noatime /dev/nvme0n1p3 /mnt
	sudo mkdir -p /mnt/home                                                  # Ensures directory exists for home mount
	sudo mount -o subvol=home,compress=zstd,noatime /dev/nvme0n1p3 /mnt/home # Mount home subvolume
	sudo mkdir /mnt/nix
	sudo mount -o subvol=nix,compress=zstd,noatime /dev/nvme0n1p3 /mnt/nix

	sudo mkdir /mnt/persist
	sudo mount -o subvol=persist,compress=zstd,noatime /dev/nvme0n1p3 /mnt/persist

	sudo mkdir -p /mnt/var/log
	sudo mount -o subvol=log,compress=zstd,noatime /dev/nvme0n1p3 /mnt/var/log

	# Mount the boot partition
	sudo mkdir /mnt/boot
	sudo mount /dev/nvme0n1p1 /mnt/boot
}

install_nixos() {
	sudo nixos-generate-config --root /mnt
	sudo nixos-install --root /mnt --flake .#linix --show-trace
	sudo nixos-enter
}

finalize_setup() {
	sudo mv /etc/machine-id /mnt/persist/etc/
	sudo mv /etc/ssh /mnt/persist/etc/

	sudo git config --global user.email "a.erkol@tu-braunschweig.de"
	sudo git config --global user.name "someone023"

	sync
	sudo swapoff /mnt/swap/swapfile
	sudo umount -R /mnt
}

main() {
	setup_disk
	setup_subvolumes
	mount_subvolumes
	install_nixos
	finalize_setup
}

main
