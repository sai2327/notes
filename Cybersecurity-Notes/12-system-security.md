# 12. System Security

## Table of Contents
- [12.1 Firewalls](#121-firewalls)
- [12.2 Antivirus & EDR](#122-antivirus--edr)
- [12.3 IDS/IPS](#123-idsips)
- [12.4 Access Control](#124-access-control)
- [12.5 System Hardening](#125-system-hardening)
- [12.6 Patch Management](#126-patch-management)
- [12.7 Common Mistakes & Interview Tips](#127-common-mistakes--interview-tips)
- [12.8 Practice & Assessment](#128-practice--assessment)

---

## 12.1 Firewalls

### Definition
A **firewall** filters network traffic based on predefined rules, allowing or blocking traffic between networks.

### Types

| Type | Layer | Description | Example |
|------|-------|-------------|---------|
| **Packet Filtering** | L3-L4 | Checks source/dest IP, port, protocol | iptables, ACLs |
| **Stateful Inspection** | L3-L4 | Tracks connection state (new/established) | pfSense |
| **Application (Proxy)** | L7 | Inspects application data (HTTP, DNS) | Squid proxy |
| **Next-Gen (NGFW)** | L3-L7 | Deep packet inspection + IPS + app awareness | Palo Alto, Fortinet |
| **WAF** | L7 | Specifically protects web applications | ModSecurity, Cloudflare |

### Linux Firewall — iptables / nftables

```bash
# ═══════════════════════════════════════
# iptables BASICS
# ═══════════════════════════════════════
# View current rules
sudo iptables -L -v -n

# Allow incoming SSH
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP and HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow established connections
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Block everything else (default deny)
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Block specific IP
sudo iptables -A INPUT -s 10.10.10.5 -j DROP

# Delete a rule (by number)
sudo iptables -L --line-numbers
sudo iptables -D INPUT 3

# Save rules
sudo iptables-save > /etc/iptables.rules

# ═══════════════════════════════════════
# UFW (Uncomplicated Firewall — Ubuntu)
# ═══════════════════════════════════════
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw status verbose
```

### Windows Firewall

```powershell
# View firewall status
Get-NetFirewallProfile | Format-Table Name, Enabled

# Allow inbound port
New-NetFirewallRule -DisplayName "Allow SSH" -Direction Inbound -Protocol TCP -LocalPort 22 -Action Allow

# Block inbound port
New-NetFirewallRule -DisplayName "Block Telnet" -Direction Inbound -Protocol TCP -LocalPort 23 -Action Block

# List rules
Get-NetFirewallRule | Where-Object {$_.Enabled -eq "True"} | Format-Table DisplayName, Direction, Action
```

---

## 12.2 Antivirus & EDR

### Antivirus (AV)

| Detection Method | How It Works | Limitation |
|-----------------|-------------|-----------|
| **Signature-based** | Compares files against known malware signatures | Can't detect new/unknown malware |
| **Heuristic** | Analyzes code behavior patterns | May cause false positives |
| **Behavioral** | Monitors runtime behavior | Needs malware to execute first |
| **Sandboxing** | Runs suspicious files in isolated environment | Advanced malware detects sandboxes |

### EDR (Endpoint Detection & Response)

EDR goes beyond antivirus:

```
Traditional AV:  Detect → Block → Done
EDR:             Detect → Investigate → Respond → Hunt → Learn

EDR capabilities:
  ✓ Real-time monitoring of all endpoint activity
  ✓ Behavioral analysis (not just signatures)
  ✓ Threat hunting (proactive searching)
  ✓ Incident response (isolate endpoint, kill process)
  ✓ Forensic data (timeline of events)
  ✓ Centralized management

Popular EDR: CrowdStrike Falcon, Microsoft Defender for Endpoint,
             SentinelOne, Carbon Black
```

---

## 12.3 IDS/IPS

### Definition

| System | Function | Action |
|--------|----------|--------|
| **IDS** (Intrusion Detection) | Monitors and alerts on suspicious activity | Passive — alerts only |
| **IPS** (Intrusion Prevention) | Monitors and blocks suspicious activity | Active — blocks threats |

```
Network traffic flow:

With IDS (passive):
  Traffic ──► [IDS monitors copy] ──► Destination
                    │
                    └──► Alert: "Suspicious activity detected!"

With IPS (inline):
  Traffic ──► [IPS inspects] ──► Allowed traffic ──► Destination
                    │
                    └──✗ Blocked traffic + Alert
```

### Types

| Type | Placement | Monitors |
|------|-----------|----------|
| **NIDS/NIPS** (Network-based) | At network boundary | All network traffic |
| **HIDS/HIPS** (Host-based) | On individual host | System calls, file changes, logs |

### Snort (Popular Open-Source IDS/IPS)

```bash
# Install Snort
sudo apt install snort

# Run in IDS mode
sudo snort -A console -q -c /etc/snort/snort.conf -i eth0

# Sample Snort rule:
# Alert on any SSH brute force attempt
alert tcp any any -> $HOME_NET 22 (msg:"SSH Brute Force Attempt"; 
  flags:S; threshold:type both, track by_src, count 5, seconds 60; 
  sid:1000001; rev:1;)

# Rule breakdown:
#   alert        → action (alert, log, drop)
#   tcp          → protocol
#   any any      → source IP and port
#   ->           → direction
#   $HOME_NET 22 → destination (your network, port 22)
#   msg          → alert message
#   threshold    → 5 SYNs in 60 seconds from same source
```

---

## 12.4 Access Control

### Principle of Least Privilege

Every user and process should have **only the minimum access necessary**.

```
Example — Web server:
  ✗ Running as root (if compromised → full system access)
  ✓ Running as www-data (if compromised → limited access)

Example — Database user:
  ✗ Application uses DB admin account
  ✓ Application uses account with only SELECT/INSERT on needed tables
```

### Linux Access Control

```bash
# User management
sudo useradd -m -s /bin/bash newuser
sudo passwd newuser
sudo usermod -aG sudo newuser       # Add to sudo group

# File permissions
chmod 600 private_key                # Owner read/write only
chmod 755 script.sh                  # Owner rwx, others rx
chown root:root /etc/shadow          # Set ownership

# sudo configuration
sudo visudo
# username ALL=(ALL:ALL) ALL          # Full sudo access
# username ALL=(ALL) NOPASSWD: /usr/bin/apt  # Specific command without password

# Check user's privileges
sudo -l
```

### Windows Access Control

```powershell
# Check user privileges
whoami /priv

# Check group membership
net localgroup Administrators

# Manage permissions
icacls "C:\sensitive_folder" /grant "User:(R)"     # Read only
icacls "C:\sensitive_folder" /deny "Guest:(F)"     # Deny full control
icacls "C:\sensitive_folder" /remove "OldUser"      # Remove permissions
```

---

## 12.5 System Hardening

### Linux Hardening Checklist

```bash
# 1. Update system
sudo apt update && sudo apt upgrade -y

# 2. Disable unnecessary services
sudo systemctl disable bluetooth
sudo systemctl disable cups
systemctl list-unit-files --type=service | grep enabled

# 3. SSH hardening (/etc/ssh/sshd_config)
PermitRootLogin no                  # Disable root SSH login
PasswordAuthentication no           # Use key-based auth only
MaxAuthTries 3                      # Limit login attempts
AllowUsers admin deploy             # Whitelist users
Port 2222                           # Change default port

# 4. Firewall (deny by default)
sudo ufw default deny incoming
sudo ufw allow 2222/tcp             # SSH on custom port
sudo ufw enable

# 5. Remove unnecessary packages
sudo apt autoremove

# 6. Set file permissions
chmod 600 /etc/shadow
chmod 644 /etc/passwd
chmod 700 /root

# 7. Enable audit logging
sudo apt install auditd
sudo auditctl -w /etc/passwd -p wa -k passwd_changes
sudo auditctl -w /etc/shadow -p wa -k shadow_changes
```

### Windows Hardening Checklist

```
✓ Enable Windows Firewall on all profiles
✓ Disable unnecessary services (Telnet, FTP)
✓ Enable BitLocker disk encryption
✓ Configure Windows Update for automatic updates
✓ Disable guest account
✓ Set strong password policies via Group Policy
✓ Enable audit logging (Security Events)
✓ Disable SMBv1 (vulnerable to EternalBlue)
✓ Enable Credential Guard (protects against Mimikatz)
✓ Use LAPS for local admin password management
```

---

## 12.6 Patch Management

### Why Patching Matters

```
60% of breaches involve vulnerabilities where a patch was available
but not applied. — Ponemon Institute

Timeline of a typical vulnerability:
  Day 0:   Vulnerability discovered
  Day 1-7: Exploit developed by attackers
  Day 30:  Vendor releases patch
  Day 90:  Most organizations still haven't patched ← DANGER ZONE
```

### Patch Management Process

```
1. DISCOVER → Inventory all systems and software
2. ASSESS   → Identify missing patches, prioritize by severity
3. TEST     → Apply patches in test/staging environment
4. DEPLOY   → Roll out to production (maintenance window)
5. VERIFY   → Confirm patches applied successfully
6. DOCUMENT → Record what was patched and when
```

---

## 12.7 Common Mistakes & Interview Tips

### Interview Questions

**Q: What is the difference between IDS and IPS?**
> IDS is passive — it monitors and alerts. IPS is active — it monitors and blocks. IDS is like a security camera; IPS is like a security guard.

**Q: What is defense in depth?**
> Using multiple layers of security controls so that if one fails, others still protect the system. Like a castle: moat → walls → guards → locked rooms.

**Q: Explain the principle of least privilege.**
> Every user and process should have only the minimum permissions needed to do their job. This limits the damage if an account is compromised.

---

## 12.8 Practice & Assessment

### MCQs

**Q1.** A NGFW (Next-Gen Firewall) differs from a traditional firewall because:
- A) It's faster
- B) It includes deep packet inspection and application awareness
- C) It's cheaper
- D) It only works with Linux

**Answer:** B) Deep packet inspection and application awareness

---

**Q2.** IPS is placed _____ in the network:
- A) Out-of-band (monitoring copy)
- B) Inline (traffic passes through it)
- C) On each endpoint
- D) In the cloud only

**Answer:** B) Inline

---

**Q3.** The command `sudo ufw default deny incoming` does:
- A) Blocks all outgoing traffic
- B) Blocks all incoming traffic by default
- C) Allows all incoming traffic
- D) Disables the firewall

**Answer:** B) Blocks all incoming traffic by default

---

> **Next Topic:** [13 - Network Security](13-network-security.md)
