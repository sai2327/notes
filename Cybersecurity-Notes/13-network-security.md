# 13. Network Security

## Table of Contents
- [13.1 Secure Network Architecture](#131-secure-network-architecture)
- [13.2 VPN (Virtual Private Network)](#132-vpn-virtual-private-network)
- [13.3 Secure Protocols](#133-secure-protocols)
- [13.4 Network Monitoring & SIEM](#134-network-monitoring--siem)
- [13.5 Wireless Security](#135-wireless-security)
- [13.6 Network Attacks & Defenses](#136-network-attacks--defenses)
- [13.7 Common Mistakes & Interview Tips](#137-common-mistakes--interview-tips)
- [13.8 Practice & Assessment](#138-practice--assessment)

---

## 13.1 Secure Network Architecture

### Network Segmentation

```
                     INTERNET
                        │
                   ┌────┴────┐
                   │ FIREWALL │
                   └────┬────┘
                        │
          ┌─────────────┼─────────────┐
          │             │             │
    ┌─────┴─────┐ ┌────┴────┐ ┌─────┴─────┐
    │    DMZ    │ │ INTERNAL │ │  MGMT     │
    │           │ │ NETWORK  │ │  NETWORK  │
    │ Web Server│ │ Workstns │ │ Admin PCs │
    │ Mail Srvr │ │ Printers │ │ Servers   │
    │ DNS       │ │ File Shr │ │ Backups   │
    └───────────┘ └──────────┘ └───────────┘

DMZ:      Public-facing servers (limited access to internal)
Internal: Employee workstations and resources
MGMT:     Administrative access only (most restricted)
```

### Key Concepts

| Concept | Definition | Example |
|---------|-----------|---------|
| **DMZ** | Semi-trusted zone between internet and internal network | Web server exposed to internet |
| **VLAN** | Logically separate networks on same physical switch | HR on VLAN 10, Finance on VLAN 20 |
| **NAT** | Translates private IPs to public IPs | 192.168.1.x → single public IP |
| **Zero Trust** | Never trust, always verify — every request authenticated | Google BeyondCorp model |

---

## 13.2 VPN (Virtual Private Network)

### Definition
A **VPN** creates an encrypted tunnel between two points over an untrusted network (like the internet).

### Types

| Type | Use Case | Example |
|------|----------|---------|
| **Remote Access VPN** | Employee connects to company network | OpenVPN, Cisco AnyConnect |
| **Site-to-Site VPN** | Connect two office networks | IPSec tunnel between routers |
| **SSL/TLS VPN** | Browser-based VPN access | Clientless VPN portals |

### Protocols

| Protocol | Security | Speed | Port |
|----------|----------|-------|------|
| **OpenVPN** | Strong (AES-256) | Good | 1194/UDP or 443/TCP |
| **WireGuard** | Strong (ChaCha20) | Very Fast | 51820/UDP |
| **IPSec/IKEv2** | Strong | Fast | 500/UDP, 4500/UDP |
| **L2TP/IPSec** | Strong (with IPSec) | Moderate | 1701/UDP |
| **PPTP** | Weak (broken) | Fast | 1723/TCP |

```
PPTP is BROKEN — never use it!
Use WireGuard or OpenVPN for best security + performance.
```

### OpenVPN Setup (Basic)

```bash
# Install OpenVPN
sudo apt install openvpn

# Connect using config file
sudo openvpn --config client.ovpn

# Check VPN is working
ip addr show tun0          # Should show VPN interface
curl ifconfig.me           # Should show VPN's public IP
```

---

## 13.3 Secure Protocols

### Insecure vs Secure

| Insecure | Secure | Difference |
|----------|--------|-----------|
| HTTP (80) | HTTPS (443) | TLS encryption |
| FTP (21) | SFTP (22) / FTPS (990) | Encrypted file transfer |
| Telnet (23) | SSH (22) | Encrypted remote access |
| SMTP (25) | SMTPS (465/587) | Encrypted email |
| DNS (53) | DoH (443) / DoT (853) | Encrypted DNS queries |
| SNMP v1/v2 | SNMP v3 | Encrypted + authenticated |
| HTTP cookies | Secure + HttpOnly cookies | Protected session data |

### SSH Security

```bash
# Generate SSH key pair (Ed25519 — modern and fast)
ssh-keygen -t ed25519 -C "user@example.com"

# Copy public key to server
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@server

# Connect with key
ssh -i ~/.ssh/id_ed25519 user@server

# SSH tunneling (port forwarding)
# Local: Access remote service through local port
ssh -L 8080:localhost:80 user@server
# Now http://localhost:8080 → server's port 80

# Remote: Expose local service through remote port
ssh -R 9090:localhost:3000 user@server

# Dynamic SOCKS proxy
ssh -D 1080 user@server
# Configure browser to use SOCKS proxy localhost:1080
```

---

## 13.4 Network Monitoring & SIEM

### What is SIEM?
**SIEM** (Security Information and Event Management) collects logs from all systems, correlates events, and detects threats.

```
┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
│ Firewall │  │  Server  │  │   IDS    │  │Endpoints │
│   Logs   │  │   Logs   │  │  Alerts  │  │   Logs   │
└────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘
     │             │             │             │
     └──────┬──────┴──────┬──────┘             │
            │             │                    │
       ┌────┴─────────────┴────────────────────┴───┐
       │                 SIEM                       │
       │  Collect → Normalize → Correlate → Alert   │
       │                                            │
       │  Dashboard: Real-time visibility            │
       │  Rules: Detect suspicious patterns          │
       │  Incidents: Automated response              │
       └────────────────────────────────────────────┘
```

### Popular SIEM Tools

| Tool | Type | Key Feature |
|------|------|-------------|
| **Splunk** | Commercial | Powerful search, huge ecosystem |
| **IBM QRadar** | Commercial | Strong correlation engine |
| **Elastic SIEM** | Open Source | Built on ELK stack |
| **Wazuh** | Open Source | Host-based + SIEM |
| **Microsoft Sentinel** | Cloud | Azure-native SIEM |

### Network Monitoring Commands

```bash
# Monitor active connections
netstat -tulpn                    # Linux: listening ports
ss -tulpn                        # Modern alternative to netstat

# Monitor traffic in real-time
sudo iftop -i eth0               # Bandwidth per connection
sudo nethogs                     # Bandwidth per process
sudo tcpdump -i eth0 -c 100      # Capture 100 packets

# Check for suspicious connections
# Look for:
#   - Connections to unusual countries
#   - High outbound traffic (exfiltration)
#   - Connections on unusual ports
#   - Processes making network connections you don't recognize
```

---

## 13.5 Wireless Security

### Wi-Fi Encryption Standards

| Standard | Year | Security | Status |
|----------|------|----------|--------|
| **WEP** | 1999 | Broken (cracked in minutes) | Do NOT use |
| **WPA** | 2003 | Weak (TKIP has flaws) | Deprecated |
| **WPA2** | 2004 | Good (AES-CCMP) | Acceptable |
| **WPA3** | 2018 | Strong (SAE handshake) | Recommended |

### Wi-Fi Attack Tools

```bash
# ═══════════════════════════════════════
# Aircrack-ng suite (for authorized testing only)
# ═══════════════════════════════════════

# Put wireless card in monitor mode
sudo airmon-ng start wlan0

# Scan for networks
sudo airodump-ng wlan0mon

# Capture handshake from specific network
sudo airodump-ng -c 6 --bssid AA:BB:CC:DD:EE:FF -w capture wlan0mon

# Deauth attack (force clients to reconnect → capture handshake)
sudo aireplay-ng -0 5 -a AA:BB:CC:DD:EE:FF wlan0mon

# Crack WPA2 handshake with wordlist
aircrack-ng -w /usr/share/wordlists/rockyou.txt capture-01.cap
```

---

## 13.6 Network Attacks & Defenses

| Attack | How It Works | Defense |
|--------|-------------|---------|
| ARP Spoofing | Fake ARP replies redirect traffic | Static ARP, Dynamic ARP Inspection |
| DNS Spoofing | Fake DNS responses redirect domains | DNSSEC, DoH/DoT |
| MITM | Intercept traffic between two parties | Encryption (TLS), certificate pinning |
| DHCP Starvation | Exhaust DHCP pool | DHCP snooping |
| Rogue DHCP | Attacker runs fake DHCP server | DHCP snooping |
| MAC Flooding | Overflow switch MAC table | Port security |
| VLAN Hopping | Access other VLANs | Disable DTP, prune VLANs |

---

## 13.7 Common Mistakes & Interview Tips

### Interview Questions

**Q: What is a DMZ?**
> A DMZ (Demilitarized Zone) is a network segment between the external (internet) and internal network. Public-facing servers (web, email, DNS) are placed here so compromising them doesn't give direct internal access.

**Q: Difference between IDS and firewall?**
> A firewall controls traffic flow based on rules (allow/deny). An IDS monitors traffic for suspicious patterns and generates alerts. Firewalls block known-bad; IDS detects unknown-bad.

**Q: What is Zero Trust?**
> A security model that assumes no user or device should be automatically trusted, even inside the network. Every access request must be verified, authenticated, and authorized regardless of location.

---

## 13.8 Practice & Assessment

### MCQs

**Q1.** Which VPN protocol is considered broken and should NOT be used?
- A) OpenVPN
- B) WireGuard
- C) PPTP
- D) IPSec

**Answer:** C) PPTP

---

**Q2.** WPA3 uses which handshake method?
- A) 4-way handshake
- B) SAE (Simultaneous Authentication of Equals)
- C) PSK only
- D) SSL handshake

**Answer:** B) SAE

---

**Q3.** A DMZ is:
- A) The most secure internal zone
- B) A zone between internet and internal network for public services
- C) A wireless network zone
- D) A backup network

**Answer:** B) A zone between internet and internal network

---

> **Next Topic:** [14 - Cloud Security](14-cloud-security.md)
