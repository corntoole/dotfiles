#!/usr/bin/env bash
#
# Provisioning script for aus-1271 (Ubuntu host)
#
# Installs:
#   1. Systemd services (docker, libvirt, virt-manager) via apt
#   2. Nix package manager via the Determinate Systems installer
#   3. Applies home-manager configuration via flake
#
# Usage:
#   sudo ./bin/setup-ubuntu.sh

set -euo pipefail

# ---------------------------------------------------------------------------
# Pre-flight checks
# ---------------------------------------------------------------------------

echo "=== Pre-flight checks ==="

# Check if running as root (required for apt and systemd commands)
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: This script must be run as root." >&2
    exit 1
fi

# Check OS version
if [ ! -f /etc/os-release ]; then
    echo "ERROR: /etc/os-release not found. Are you running Ubuntu?" >&2
    exit 1
fi

. /etc/os-release
echo "Detected OS: $NAME $VERSION"

# Check Ubuntu version (22.04+)
UBUNTU_VERSION_ID=$(echo "$VERSION_ID" | tr -d '.')
if [ "$ID" != "ubuntu" ] || [ -z "$VERSION_ID" ] || [ "$UBUNTU_VERSION_ID" -lt 2204 ]; then
    echo "WARNING: This script is designed for Ubuntu 22.04+. You are running $NAME $VERSION_ID."
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# ---------------------------------------------------------------------------
# Step 1: Install apt packages and enable services
# ---------------------------------------------------------------------------

echo ""
echo "=== Step 1: Installing apt packages ==="

apt-get update -y
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    software-properties-common \
    docker.io \
    libvirt-daemon-system \
    virt-manager

echo ""
echo "=== Enabling systemd services ==="

systemctl enable --now docker
systemctl enable --now libvirtd

# ---------------------------------------------------------------------------
# Step 2: Install Nix via Determinate Systems installer
# ---------------------------------------------------------------------------

echo ""
echo "=== Step 2: Installing Nix (Determinate installer) ==="

if command -v nix >/dev/null 2>&1; then
    echo "Nix is already installed. Skipping install."
else
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
fi

# ---------------------------------------------------------------------------
# Step 3: Apply home-manager configuration
# ---------------------------------------------------------------------------

echo ""
echo "=== Step 3: Applying home-manager configuration ==="

# Ensure the user exists (create if necessary)
USERNAME="ctoole"
if ! id "$USERNAME" >/dev/null 2>&1; then
    echo "User $USERNAME does not exist. Creating..."
    useradd -m -s /bin/bash -G docker,libvirtd "$USERNAME"
    echo "Please set a password for $USERNAME:"
    passwd "$USERNAME"
fi

# Apply home-manager config as the user
su - "$USERNAME" -c "home-manager switch --flake $(dirname "$0")/..#aus-1271"

echo ""
echo "=== Provisioning complete ==="
echo "The host is configured with:"
echo "  - Docker (via apt + systemd)"
echo "  - Libvirt/virt-manager (via apt + systemd)"
echo "  - Nix + home-manager (via Determinate)"
echo ""
echo "Run 'home-manager switch --flake .#aus-1271' in the future to update."
