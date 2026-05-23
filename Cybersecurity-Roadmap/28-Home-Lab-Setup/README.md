# 🏠 Home Lab Setup

## Build Your Personal Cybersecurity Training Ground — Complete Hardware to Configuration

---

## Table of Contents

1. [Why You Need a Home Lab](#why-you-need-a-home-lab)
2. [Hardware Requirements](#hardware-requirements)
3. [Virtualization Platform Setup](#virtualization-platform-setup)
4. [Network Architecture](#network-architecture)
5. [Attack Machine Setup (Kali Linux)](#attack-machine-setup)
6. [Target Machines](#target-machines)
7. [Active Directory Lab](#active-directory-lab)
8. [SIEM/Blue Team Setup](#siemblue-team-setup)
9. [Cloud Lab Options](#cloud-lab-options)
10. [Lab Maintenance](#lab-maintenance)
11. [Budget Builds](#budget-builds)

---

## Why You Need a Home Lab

```
A home lab gives you:
✓ Safe environment to practice attacks (legal!)
✓ Learn enterprise technologies (AD, SIEM, firewalls)
✓ Build projects for your portfolio
✓ Prepare for certifications (OSCP, PNPT, etc.)
✓ Experiment without consequences
✓ Always available (no subscription needed)
✓ Customize to your learning goals

What you CAN'T get from online platforms:
- Full control over network architecture
- Custom Active Directory configurations
- Integration testing between systems
- Building from scratch (real-world skill)
- Running 24/7 for detection engineering
```

---

## Hardware Requirements

### Minimum Viable Lab (Budget: $0-$200)

```
Option A: Your Existing Computer
─────────────────────────────────
Minimum specs:
- CPU: Any modern quad-core (Intel i5/Ryzen 5+)
- RAM: 16GB (absolute minimum, 32GB recommended)
- Storage: 256GB free SSD space
- Network: Standard ethernet/WiFi

What you can run simultaneously:
- Kali Linux (2GB RAM)
- 1-2 target machines (2-4GB each)
- Limited AD lab (1 DC + 1 workstation)

Option B: Used Enterprise Hardware ($100-$200)
──────────────────────────────────────────────
Best value: Used Dell OptiPlex or HP EliteDesk
- Dell OptiPlex 7050/7060: ~$100-150 on eBay
- Add RAM to 32GB: ~$30-50
- Add 1TB SSD: ~$60

Alternative: Used ThinkPad T480/T490 laptop
- Portable lab you can take anywhere
- $150-250 used, add RAM/SSD
```

### Recommended Lab (Budget: $300-$800)

```
Option A: Desktop Build
───────────────────────
- CPU: AMD Ryzen 7 5700G or Intel i7 (8+ cores)
- RAM: 64GB DDR4 (run full AD lab + SIEM)
- Storage: 1TB NVMe SSD + 2TB HDD for ISOs/snapshots
- Network: Dual NIC (separate lab network)
- Cost: ~$500-700

Option B: Used Server (Best performance/$)
──────────────────────────────────────────
- Dell PowerEdge R720/R730: $200-400
- Dual Xeon processors (16-24 cores total)
- 128GB RAM (cheap ECC DDR3/DDR4)
- Multiple drive bays
- Loud and power-hungry (put in closet/garage)
- Cost: ~$300-600

What 64GB RAM gets you (running simultaneously):
- Kali Linux (4GB)
- Windows Server 2019 DC (4GB)
- Windows 10 workstation ×2 (4GB each)
- Ubuntu web server (2GB)
- SIEM (Wazuh/Splunk) (8GB)
- Vulnerable machines ×2 (2-4GB each)
- Total: ~30-40GB used, room to grow
```

### Advanced Lab (Budget: $1000+)

```
Multi-machine setup:
- Proxmox/ESXi server (main hypervisor)
- Dedicated firewall (pfSense/OPNsense on mini-PC)
- Managed switch (VLANs for network segmentation)
- NAS for storage (Synology/TrueNAS)
- Separate attack laptop
```

---

## Virtualization Platform Setup

### VirtualBox (Free, Cross-Platform)

```bash
# Installation (Windows/Mac/Linux)
# Download from: https://www.virtualbox.org/

# After installation, configure:
# 1. Host-Only Network (isolated lab network)
File → Host Network Manager → Create
  - IPv4 Address: 192.168.56.1
  - Subnet Mask: 255.255.255.0
  - DHCP: Enable (or disable for static IPs)

# 2. NAT Network (lab machines with internet access)
File → Preferences → Network → Add NAT Network
  - Network CIDR: 10.10.10.0/24
  - Enable DHCP

# VM Best Practices:
- Use "Linked Clones" to save disk space
- Take snapshots BEFORE making changes
- Use "Internal Network" for isolated segments
- Allocate fixed memory (not dynamic) for stability
```

### VMware Workstation Pro (Now Free for Personal Use)

```bash
# Download from: https://www.vmware.com/products/workstation-pro.html

# Network Configuration:
# Edit → Virtual Network Editor
# 
# VMnet1 (Host-Only): 192.168.56.0/24
#   - For isolated attack/target network
#
# VMnet8 (NAT): 10.10.10.0/24
#   - For VMs needing internet access
#
# VMnet2 (Custom): 172.16.0.0/24
#   - For AD network segment

# VMware advantages over VirtualBox:
# - Better performance (especially Windows VMs)
# - Better snapshot management
# - Better networking features
# - Unity mode (mix host and guest windows)
```

### Proxmox VE (Free, Server-Grade)

```bash
# Best for dedicated lab hardware
# Download ISO: https://www.proxmox.com/en/downloads

# Installation:
# 1. Flash ISO to USB (use Rufus/Etcher)
# 2. Boot from USB on lab server
# 3. Follow installation wizard
# 4. Access web UI: https://SERVER_IP:8006

# Proxmox advantages:
# - Run many VMs simultaneously
# - Web-based management
# - Container support (LXC) for lightweight services
# - ZFS storage (snapshots, compression)
# - Clustering support (multiple nodes)
# - Industry-standard (same tech as enterprise)

# Network configuration for lab:
# Create virtual bridges:
# vmbr0 → Management (your connection to Proxmox)
# vmbr1 → Lab network (isolated, no internet)
# vmbr2 → AD network
# vmbr3 → DMZ (simulated public-facing)
```

---

## Network Architecture

### Recommended Lab Network Design

```
┌─────────────────────────────────────────────────────────────────┐
│                    HOME LAB NETWORK DESIGN                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  YOUR HOME NETWORK (192.168.1.0/24)                             │
│       │                                                          │
│  ┌────▼────┐                                                    │
│  │ Router/ │                                                     │
│  │Firewall │ (pfSense/OPNsense VM or physical)                  │
│  └────┬────┘                                                    │
│       │                                                          │
│  ═════╪══════════════════════════════════════════════            │
│       │                                                          │
│  ┌────┴─── LAB SEGMENTS ────────────────────────────────┐       │
│  │                                                       │       │
│  │  SEGMENT 1: Attack Network (10.10.10.0/24)           │       │
│  │  ┌─────────────┐                                     │       │
│  │  │  Kali Linux │ 10.10.10.5                          │       │
│  │  │  (Attacker) │                                     │       │
│  │  └─────────────┘                                     │       │
│  │                                                       │       │
│  │  SEGMENT 2: Target Network (10.10.20.0/24)           │       │
│  │  ┌───────────┐ ┌───────────┐ ┌───────────┐         │       │
│  │  │Metasploit-│ │ DVWA/Web  │ │  Vuln     │         │       │
│  │  │able 2     │ │  Server   │ │  Machine  │         │       │
│  │  │ .20.10    │ │ .20.20    │ │ .20.30    │         │       │
│  │  └───────────┘ └───────────┘ └───────────┘         │       │
│  │                                                       │       │
│  │  SEGMENT 3: Active Directory (10.10.30.0/24)         │       │
│  │  ┌───────────┐ ┌───────────┐ ┌───────────┐         │       │
│  │  │   DC01    │ │   WS01    │ │   WS02    │         │       │
│  │  │(Win Srv)  │ │ (Win 10)  │ │ (Win 10)  │         │       │
│  │  │ .30.10    │ │ .30.20    │ │ .30.30    │         │       │
│  │  └───────────┘ └───────────┘ └───────────┘         │       │
│  │                                                       │       │
│  │  SEGMENT 4: Blue Team (10.10.40.0/24)               │       │
│  │  ┌───────────┐ ┌───────────┐                        │       │
│  │  │   SIEM    │ │  Security │                        │       │
│  │  │(Wazuh/ELK)│ │  Onion    │                        │       │
│  │  │ .40.10    │ │ .40.20    │                        │       │
│  │  └───────────┘ └───────────┘                        │       │
│  │                                                       │       │
│  └───────────────────────────────────────────────────────┘       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Attack Machine Setup

### Kali Linux Configuration

```bash
# Download: https://www.kali.org/get-kali/
# Use the VM image (pre-configured for VirtualBox/VMware)

# After first boot (login: kali/kali):

# 1. Update system
sudo apt update && sudo apt upgrade -y

# 2. Install additional tools
sudo apt install -y \
  seclists \
  gobuster \
  feroxbuster \
  bloodhound \
  neo4j \
  crackmapexec \
  evil-winrm \
  python3-pip \
  golang-go \
  docker.io

# 3. Install Go tools
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/ffuf/ffuf/v2@latest

# 4. Install Python tools
pip3 install impacket
pip3 install pwntools
pip3 install bloodhound

# 5. Configure shell
# Add to ~/.zshrc:
export PATH=$PATH:~/go/bin
alias serve='python3 -m http.server 8000'
alias listen='rlwrap nc -lvnp'

# 6. Take snapshot (clean state to revert to)
```

---

## Target Machines

### Essential Vulnerable VMs

```
BEGINNER TARGETS:
─────────────────
1. Metasploitable 2
   - Download: SourceForge
   - Services: FTP, SSH, Telnet, HTTP, MySQL, PostgreSQL, Samba
   - Great for: Learning enumeration and basic exploitation

2. DVWA (Damn Vulnerable Web Application)
   - Docker: docker run -d -p 80:80 vulnerables/web-dvwa
   - Great for: Web app testing (SQLi, XSS, Command Injection)

3. VulnHub "Kioptrix" series (Levels 1-5)
   - Download: vulnhub.com
   - Great for: Progressive difficulty, realistic scenarios

INTERMEDIATE TARGETS:
────────────────────
4. HackTheBox "Retired" machines (use HTB VPN)
   - Realistic difficulty
   - Walkthroughs available after retirement

5. Metasploitable 3
   - More modern, Windows + Linux versions
   - Active Directory components

6. DVCP (Damn Vulnerable Cloud Platform)
   - AWS misconfigurations
   - Cloud-specific attacks

ADVANCED TARGETS:
────────────────
7. Vulnhub multi-machine networks
8. Custom AD lab (see Section 21)
9. HTB Pro Labs (Dante, Offshore, RastaLabs)
```

---

## Active Directory Lab

### Minimal AD Lab Setup (3 VMs)

```powershell
# ═══════════════════════════════════════
# VM 1: DOMAIN CONTROLLER (Windows Server 2019/2022)
# ═══════════════════════════════════════
# RAM: 4GB | Disk: 60GB | Network: Lab segment
# IP: 10.10.30.10/24 | DNS: 127.0.0.1

# Install AD DS + DNS:
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-WindowsFeature DNS -IncludeManagementTools

# Promote to DC:
$Password = ConvertTo-SecureString "Lab@dmin123!" -AsPlainText -Force
Install-ADDSForest `
    -DomainName "lab.local" `
    -SafeModeAdministratorPassword $Password `
    -Force:$true

# After reboot - create users, groups, OUs (see Section 21)

# ═══════════════════════════════════════
# VM 2: WORKSTATION 1 (Windows 10/11)
# ═══════════════════════════════════════
# RAM: 4GB | Disk: 60GB | Network: Lab segment
# IP: 10.10.30.20/24 | DNS: 10.10.30.10

# Join domain (PowerShell as Admin):
$Password = ConvertTo-SecureString "Lab@dmin123!" -AsPlainText -Force
$Credential = New-Object PSCredential("lab\Administrator", $Password)
Add-Computer -DomainName "lab.local" -Credential $Credential -Restart

# ═══════════════════════════════════════
# VM 3: WORKSTATION 2 (Windows 10/11)
# ═══════════════════════════════════════
# Same process as WS01, IP: 10.10.30.30

# After all machines joined:
# - Log in with different domain users on each workstation
# - This creates cached credentials (for credential harvesting practice)
# - Install common software (simulates real environment)
# - Install Sysmon (for blue team detection practice)
```

### Getting Windows ISOs (Legal/Free)

```
Windows Server Evaluation (180 days):
https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2022

Windows 10/11 Development VM:
https://developer.microsoft.com/en-us/windows/downloads/virtual-machines/

Notes:
- Evaluation versions are fully functional
- Can rearm (extend) evaluation period
- Snapshot before expiration (revert to extend)
- Microsoft provides these specifically for testing/development
```

---

## SIEM/Blue Team Setup

### Wazuh All-in-One (Recommended for Home Lab)

```bash
# Dedicated VM: Ubuntu 22.04, 8GB RAM, 100GB disk
# IP: 10.10.40.10

# Quick install:
curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh
sudo bash wazuh-install.sh -a

# After installation:
# Access dashboard: https://10.10.40.10
# Credentials shown after installation

# Install agents on all lab machines:
# - Domain Controller
# - Workstations
# - Linux targets
# - Web servers

# This gives you:
# - Central log collection
# - Real-time alerting
# - File integrity monitoring
# - Vulnerability detection
# - Compliance checking
```

### Security Onion (Network Monitoring)

```bash
# Dedicated VM: 4+ cores, 8-16GB RAM, 200GB disk
# Download: https://securityonionsolutions.com/

# Security Onion includes:
# - Suricata (IDS/IPS)
# - Zeek (network analysis)
# - Elasticsearch + Kibana
# - CyberChef
# - NetworkMiner
# - Full packet capture

# Perfect for:
# - Analyzing attack traffic from your lab
# - Writing IDS/IPS rules
# - Network forensics practice
# - Threat hunting in network data
```

---

## Cloud Lab Options

### AWS Free Tier Lab

```bash
# Create AWS account (free tier: 12 months)
# Useful services for security practice:

# 1. EC2 instances (run vulnerable apps)
# 2. CloudTrail (log analysis)
# 3. GuardDuty (threat detection)
# 4. Security Hub (posture management)
# 5. IAM (access control practice)

# Cloud-specific vulnerable platforms:
# - CloudGoat (Rhino Security): AWS attack scenarios
# - flaws.cloud: AWS misconfiguration challenges
# - DVCP: Multi-cloud vulnerabilities

# IMPORTANT: Set billing alerts to avoid charges!
# - Set $5 budget alert in AWS Billing
# - Terminate instances when not in use
# - Never commit AWS keys to Git
```

---

## Lab Maintenance

```
Weekly Tasks:
├── Update all VMs (apt update, Windows Update)
├── Verify snapshots are current
├── Check disk space (VMs grow over time)
├── Rotate/refresh vulnerable machines
└── Review SIEM for interesting alerts

Monthly Tasks:
├── Add new vulnerable machines
├── Update tools on attack machine
├── Practice a new attack technique
├── Document lab changes
└── Review and optimize VM resource allocation

Snapshot Strategy:
├── "Clean Install" - Right after OS setup
├── "Configured" - After all tools installed
├── "Lab Ready" - Full environment configured
├── "Pre-Attack" - Before each practice session
└── Always snapshot BEFORE making major changes
```

---

## Budget Builds

```
$0 Budget (Use existing computer):
├── VirtualBox (free)
├── Kali Linux VM (free)
├── Metasploitable 2 (free)
├── DVWA via Docker (free)
├── Windows evaluation VMs (free)
└── Limitation: Can only run 2-3 VMs simultaneously

$100-200 Budget:
├── Used Dell OptiPlex from eBay ($100)
├── Upgrade RAM to 32GB ($40)
├── 500GB SSD ($40)
├── Everything from $0 budget
└── Can run: 4-5 VMs simultaneously

$300-500 Budget:
├── Used server or built desktop
├── 64GB RAM
├── 1TB SSD
├── Dedicated lab network (extra NIC)
├── Everything above
└── Can run: Full AD + SIEM + multiple targets

Best ROI purchases (priority order):
1. RAM (more RAM = more VMs = more practice)
2. SSD (fast snapshots, fast boot)
3. CPU cores (run more VMs concurrently)
4. Network switch (VLAN practice)
5. Second monitor (efficiency)
```

---

**Next:** → [29-Daily-Practice](../29-Daily-Practice/README.md)

*"Your home lab is your personal dojo. The more time you spend there, the sharper your skills become."*
