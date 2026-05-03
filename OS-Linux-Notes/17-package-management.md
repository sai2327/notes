# 17. Package Management

## Table of Contents
- [17.1 What is Package Management?](#171-what-is-package-management)
- [17.2 APT (Debian/Ubuntu)](#172-apt-debianubuntu)
- [17.3 DNF/YUM (RHEL/Fedora)](#173-dnfyum-rhelfedora)
- [17.4 Other Package Managers](#174-other-package-managers)
- [17.5 Practice & Assessment](#175-practice--assessment)

---

## 17.1 What is Package Management?

### Definition
A **package manager** automates installing, updating, configuring, and removing software packages and their dependencies.

```
Without package manager:
  1. Download source code
  2. Find and install all dependencies manually
  3. Compile from source (./configure && make && make install)
  4. No easy way to update or remove

With package manager:
  1. sudo apt install firefox    ← ONE command!
  2. Dependencies auto-resolved
  3. Easy update: sudo apt upgrade
  4. Easy remove: sudo apt remove firefox
```

| Distro Family | Package Format | Manager |
|--------------|----------------|---------|
| Debian/Ubuntu | .deb | apt, dpkg |
| RHEL/Fedora/CentOS | .rpm | dnf, yum, rpm |
| Arch | .pkg.tar.zst | pacman |
| Alpine | .apk | apk |

---

## 17.2 APT (Debian/Ubuntu)

### Essential Commands

```bash
# ═══════════════════════════════════════
# UPDATE & UPGRADE
# ═══════════════════════════════════════
# Update package list (check what's new)
sudo apt update

# Upgrade all installed packages
sudo apt upgrade

# Full upgrade (handles dependency changes)
sudo apt full-upgrade

# ═══════════════════════════════════════
# INSTALL & REMOVE
# ═══════════════════════════════════════
# Install a package
sudo apt install nginx
sudo apt install python3 git vim     # Multiple packages

# Install without confirmation
sudo apt install -y package_name

# Remove package (keep config files)
sudo apt remove nginx

# Remove package AND config files
sudo apt purge nginx

# Remove unused dependencies
sudo apt autoremove

# ═══════════════════════════════════════
# SEARCH & INFO
# ═══════════════════════════════════════
# Search for packages
apt search "web server"
apt search nginx

# Show package details
apt show nginx

# List installed packages
apt list --installed
apt list --installed | grep python

# Check if package is installed
dpkg -l | grep nginx

# ═══════════════════════════════════════
# MAINTENANCE
# ═══════════════════════════════════════
# Clean downloaded package cache
sudo apt clean              # Remove all cached .deb files
sudo apt autoclean          # Remove outdated cached files

# Fix broken dependencies
sudo apt --fix-broken install

# List upgradable packages
apt list --upgradable
```

### dpkg (Low-Level Package Manager)

```bash
# Install .deb file directly
sudo dpkg -i package.deb

# List files installed by package
dpkg -L nginx

# Find which package owns a file
dpkg -S /usr/bin/python3

# List all installed packages
dpkg --list
```

---

## 17.3 DNF/YUM (RHEL/Fedora)

```bash
# Update package list and upgrade
sudo dnf upgrade            # (yum update on older systems)

# Install
sudo dnf install nginx
sudo dnf install -y httpd php mysql

# Remove
sudo dnf remove nginx

# Search
dnf search "text editor"

# Info
dnf info nginx

# List installed
dnf list installed

# List available updates
dnf check-update

# Clean cache
sudo dnf clean all

# Group install (install set of related packages)
sudo dnf groupinstall "Development Tools"
```

---

## 17.4 Other Package Managers

### Snap (Universal Packages)

```bash
# Install snap package
sudo snap install vlc
sudo snap install code --classic    # VS Code

# List installed snaps
snap list

# Update all snaps
sudo snap refresh
```

### Flatpak (Universal Packages)

```bash
# Install
flatpak install flathub org.mozilla.firefox

# Run
flatpak run org.mozilla.firefox
```

---

## 17.5 Practice & Assessment

### MCQs

**Q1.** `sudo apt update` does:
- A) Installs all updates
- B) Downloads updated package list from repositories
- C) Removes old packages
- D) Updates the kernel

**Answer:** B) Downloads package list (doesn't install anything)

---

**Q2.** To remove a package AND its configuration files:
- A) `sudo apt remove package`
- B) `sudo apt purge package`
- C) `sudo apt delete package`
- D) `sudo apt clean package`

**Answer:** B) purge

---

### Hands-On

**Task:** Write commands to:
1. Update package lists
2. Search for a package called "htop"
3. Install it
4. Verify it's installed
5. Remove it completely

```bash
sudo apt update
apt search htop
sudo apt install -y htop
which htop                    # or: dpkg -l | grep htop
sudo apt purge htop && sudo apt autoremove
```

---

> **Next Topic:** [18 - System Services and Scheduling](18-system-services-scheduling.md)
