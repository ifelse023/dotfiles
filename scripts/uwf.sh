#!/bin/bash

set -e

log_file="package_installation.log"

function log() {
	echo "$@" | tee -a "$log_file"
}

function install_ufw() {
	if ! command -v ufw &>/dev/null; then
		log "Installing UFW..."
		sudo pacman -Syu --needed --noconfirm ufw | tee -a "$log_file"
	else
		log "UFW is already installed."
	fi
}

function configure_ufw() {
	log "Configuring UFW..."

	# Batch commands to minimize sudo calls
	sudo bash -c 'if ! systemctl is-enabled ufw.service &>/dev/null; then
      systemctl enable ufw.service
      systemctl start ufw.service
    fi

    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    ufw allow http
    ufw allow Deluge
    ufw allow https

    if ! ufw status verbose | grep -q "Status: active"; then
      yes | ufw enable
    fi'
}

function check_status() {
	log "UFW installation and configuration complete."
	sudo ufw status verbose | tee -a "$log_file"
}

install_ufw
configure_ufw
check_status
