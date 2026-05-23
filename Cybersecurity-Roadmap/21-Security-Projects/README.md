# 🏗️ Security Projects

## Build a Portfolio That Gets You Hired — Complete Project Blueprints

---

## Table of Contents

1. [Why Projects Matter](#why-projects-matter)
2. [Project 1: Home SIEM Lab](#project-1-home-siem-lab)
3. [Project 2: Custom Vulnerability Scanner](#project-2-custom-vulnerability-scanner)
4. [Project 3: Network Intrusion Detection System](#project-3-network-intrusion-detection-system)
5. [Project 4: Active Directory Attack Lab](#project-4-active-directory-attack-lab)
6. [Project 5: Malware Analysis Sandbox](#project-5-malware-analysis-sandbox)
7. [Project 6: Threat Intelligence Platform](#project-6-threat-intelligence-platform)
8. [Project 7: Encrypted Password Manager](#project-7-encrypted-password-manager)
9. [Project 8: Security Compliance Auditor](#project-8-security-compliance-auditor)
10. [Project 9: Phishing Detection System](#project-9-phishing-detection-system)
11. [Project 10: Cloud Security Scanner](#project-10-cloud-security-scanner)
12. [Portfolio Presentation](#portfolio-presentation)
13. [What Recruiters Look For](#what-recruiters-look-for)

---

## Why Projects Matter

```
The hiring equation:
Certifications + Projects + Experience = Job Offer

Without projects:
- You're competing with thousands of cert holders
- No proof of practical ability
- Nothing to discuss in technical interviews
- No GitHub presence for recruiters

With projects:
- Tangible proof of skills
- Conversation starters in interviews
- Shows initiative and passion
- Differentiates you from other candidates
- Demonstrates you can BUILD, not just pass exams
```

### Project Requirements for Maximum Impact

```
Every project in your portfolio should:
1. Solve a real-world security problem
2. Be well-documented (README, architecture diagram)
3. Include setup instructions anyone can follow
4. Show both offensive AND defensive understanding
5. Use industry-standard tools/frameworks
6. Have clean, readable code
7. Include screenshots/demos
8. Be hosted on GitHub with proper structure
```

---

## Project 1: Home SIEM Lab

### Overview

Build a complete Security Information and Event Management system that ingests logs from multiple sources, correlates events, detects attacks, and generates alerts.

### Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                    HOME SIEM LAB ARCHITECTURE                 │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │  Kali Linux │  │  Windows 10 │  │  Ubuntu      │        │
│  │  (Attacker) │  │  (Target)   │  │  (Web Srv)   │        │
│  │  10.10.10.5 │  │  10.10.10.10│  │  10.10.10.20 │        │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘        │
│         │                 │                 │                │
│         └─────────────────┼─────────────────┘                │
│                           │                                  │
│                    ┌──────▼──────┐                           │
│                    │   Network   │                           │
│                    │   Switch    │                           │
│                    └──────┬──────┘                           │
│                           │                                  │
│                    ┌──────▼──────┐                           │
│                    │    SIEM     │                           │
│                    │  (Wazuh/    │                           │
│                    │   Splunk)   │                           │
│                    │  10.10.10.2 │                           │
│                    └─────────────┘                           │
│                           │                                  │
│                    ┌──────▼──────┐                           │
│                    │  Dashboard  │                           │
│                    │  (Grafana/  │                           │
│                    │   Kibana)   │                           │
│                    └─────────────┘                           │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### Implementation Guide - Wazuh SIEM

```bash
# ═══════════════════════════════════════════════════════
# STEP 1: INSTALL WAZUH SERVER (Ubuntu 22.04)
# ═══════════════════════════════════════════════════════

# Download and run Wazuh installation assistant
curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh
chmod +x wazuh-install.sh
sudo ./wazuh-install.sh -a
# -a: All-in-one installation (manager + indexer + dashboard)

# Note the admin credentials displayed after installation!
# Access dashboard: https://WAZUH_IP:443

# ═══════════════════════════════════════════════════════
# STEP 2: INSTALL AGENTS ON TARGET MACHINES
# ═══════════════════════════════════════════════════════

# Linux agent:
curl -sO https://packages.wazuh.com/4.7/wazuh-agent_4.7.0-1_amd64.deb
sudo dpkg -i wazuh-agent_4.7.0-1_amd64.deb
# Configure: /var/ossec/etc/ossec.conf
# Set manager IP: <server>10.10.10.2</server>
sudo systemctl start wazuh-agent

# Windows agent:
# Download MSI from Wazuh website
# Install with: msiexec /i wazuh-agent.msi WAZUH_MANAGER="10.10.10.2"

# ═══════════════════════════════════════════════════════
# STEP 3: CONFIGURE SYSMON ON WINDOWS (Enhanced Logging)
# ═══════════════════════════════════════════════════════

# Download Sysmon from Microsoft Sysinternals
# Download SwiftOnSecurity config:
# https://github.com/SwiftOnSecurity/sysmon-config

# Install Sysmon with config:
# sysmon64.exe -accepteula -i sysmonconfig-export.xml

# Sysmon logs: Event ID mapping
# 1: Process Create
# 3: Network Connection
# 7: Image Loaded (DLL)
# 8: CreateRemoteThread
# 10: Process Access
# 11: File Create
# 12/13/14: Registry Events
# 22: DNS Query

# ═══════════════════════════════════════════════════════
# STEP 4: CREATE CUSTOM DETECTION RULES
# ═══════════════════════════════════════════════════════

# Wazuh custom rules: /var/ossec/etc/rules/local_rules.xml

# Rule: Detect brute force (5 failed logins in 2 minutes)
cat >> /var/ossec/etc/rules/local_rules.xml << 'EOF'
<group name="custom_brute_force">
  <rule id="100001" level="10" frequency="5" timeframe="120">
    <if_matched_sid>5710</if_matched_sid>
    <description>Brute force attack detected (5+ failures in 2 min)</description>
    <group>authentication_failures,</group>
  </rule>
</group>
EOF

# Rule: Detect suspicious PowerShell execution
cat >> /var/ossec/etc/rules/local_rules.xml << 'EOF'
<group name="custom_powershell">
  <rule id="100002" level="12">
    <if_sid>61600</if_sid>
    <field name="win.eventdata.commandLine">
      -enc|encodedcommand|bypass|hidden|downloadstring|iex|invoke-expression
    </field>
    <description>Suspicious PowerShell command detected</description>
    <group>malware,</group>
  </rule>
</group>
EOF

# Rule: Detect new admin user creation
cat >> /var/ossec/etc/rules/local_rules.xml << 'EOF'
<group name="custom_user_admin">
  <rule id="100003" level="14">
    <if_sid>60144</if_sid>
    <field name="win.system.eventID">4732</field>
    <field name="win.eventdata.targetDomainName">Administrators</field>
    <description>User added to Administrators group</description>
    <group>admin_escalation,</group>
  </rule>
</group>
EOF

# ═══════════════════════════════════════════════════════
# STEP 5: ATTACK SIMULATION & VALIDATION
# ═══════════════════════════════════════════════════════

# From Kali (attacker), run attacks and verify alerts:

# Test 1: Brute force SSH
hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://10.10.10.20 -t 4
# Expected alert: Rule 100001 triggers

# Test 2: Nmap scan
nmap -sV -sC 10.10.10.10
# Expected alert: Port scan detection

# Test 3: Metasploit exploitation
msfconsole -q -x "use exploit/windows/smb/ms17_010_eternalblue; set RHOSTS 10.10.10.10; run"
# Expected alerts: Network anomaly + suspicious process

# Test 4: PowerShell Empire
# Launch encoded PowerShell command
# Expected alert: Rule 100002 triggers

# ═══════════════════════════════════════════════════════
# STEP 6: BUILD DASHBOARDS
# ═══════════════════════════════════════════════════════

# In Wazuh Dashboard (Kibana-based), create visualizations:
# 1. Alert timeline (line chart - alerts over time)
# 2. Top attacking IPs (bar chart)
# 3. Alert severity distribution (pie chart)
# 4. Geographic map of attack sources
# 5. MITRE ATT&CK coverage (matrix visualization)
# 6. Top triggered rules
# 7. Failed login heatmap (by hour/day)
```

### Documentation for Portfolio

```markdown
# Home SIEM Lab

## Overview
Built a production-quality SIEM environment to detect cyber attacks
in real-time across Windows and Linux endpoints.

## Architecture
[Include diagram above]

## Technologies Used
- Wazuh 4.7 (SIEM Manager + Indexer + Dashboard)
- Sysmon (Enhanced Windows logging)
- Ubuntu 22.04 (SIEM Server + Linux target)
- Windows 10 (Endpoint target)
- Kali Linux (Attack simulation)

## Detection Rules Created
| Rule | Description | Severity |
|------|------------|----------|
| Brute Force | 5+ failed logins in 2 min | High |
| Suspicious PowerShell | Encoded/download commands | Critical |
| Admin Escalation | User added to Admins group | Critical |
| Port Scan | 20+ ports from single IP | Medium |
| Lateral Movement | PsExec/WMI execution | High |

## Attacks Detected
- SSH/RDP brute force → Alert within 30 seconds
- Nmap scanning → Detected by network rules
- Metasploit exploitation → Process + network alerts
- PowerShell Empire → Encoded command detection
- Mimikatz execution → LSASS access alert

## Screenshots
[Include dashboard screenshots]

## Lessons Learned
- Log visibility is critical (Sysmon covers gaps in default Windows logging)
- Tuning reduces false positives (baseline normal behavior first)
- Multiple data sources provide better context for alerts
- Custom rules outperform generic ones for specific environments
```

---

## Project 2: Custom Vulnerability Scanner

### Overview

Build a modular web application vulnerability scanner that can detect common security issues, generate professional reports, and be extended with custom plugins.

### Architecture

```
┌────────────────────────────────────────────────────────┐
│              VULNERABILITY SCANNER ARCHITECTURE         │
├────────────────────────────────────────────────────────┤
│                                                        │
│  ┌──────────────────────────────────────────────────┐ │
│  │                 SCANNER ENGINE                     │ │
│  ├──────────────────────────────────────────────────┤ │
│  │                                                  │ │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐     │ │
│  │  │ Crawler  │  │  Plugin  │  │ Reporter │     │ │
│  │  │ Module   │  │  Engine  │  │  Module  │     │ │
│  │  └────┬─────┘  └────┬─────┘  └────┬─────┘     │ │
│  │       │              │              │           │ │
│  │  ┌────▼─────────────▼──────────────▼─────┐    │ │
│  │  │           Plugin Registry              │    │ │
│  │  ├────────────────────────────────────────┤    │ │
│  │  │ ┌─────┐ ┌─────┐ ┌─────┐ ┌──────────┐│    │ │
│  │  │ │SQLi │ │ XSS │ │SSRF │ │ Headers  ││    │ │
│  │  │ └─────┘ └─────┘ └─────┘ └──────────┘│    │ │
│  │  │ ┌─────┐ ┌─────┐ ┌─────┐ ┌──────────┐│    │ │
│  │  │ │CORS │ │CSRF │ │Files│ │ Custom   ││    │ │
│  │  │ └─────┘ └─────┘ └─────┘ └──────────┘│    │ │
│  │  └────────────────────────────────────────┘    │ │
│  │                                                  │ │
│  └──────────────────────────────────────────────────┘ │
│                         │                              │
│                  ┌──────▼──────┐                      │
│                  │   Output    │                      │
│                  ├─────────────┤                      │
│                  │ JSON │ HTML │                      │
│                  │ CSV  │ PDF  │                      │
│                  └─────────────┘                      │
│                                                        │
└────────────────────────────────────────────────────────┘
```

### Core Implementation

```python
#!/usr/bin/env python3
"""
Modular Vulnerability Scanner with Plugin Architecture.
Demonstrates: Software design, security testing, reporting.
"""

from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from typing import List, Dict, Optional, Type
from enum import Enum
import importlib
import pkgutil

class Severity(Enum):
    CRITICAL = "Critical"
    HIGH = "High"
    MEDIUM = "Medium"
    LOW = "Low"
    INFO = "Informational"

@dataclass
class Vulnerability:
    """Standard vulnerability finding."""
    title: str
    severity: Severity
    url: str
    description: str
    evidence: str = ""
    remediation: str = ""
    cwe: str = ""
    cvss: float = 0.0
    plugin_name: str = ""

class ScannerPlugin(ABC):
    """Base class for scanner plugins. All plugins must implement this."""
    
    @property
    @abstractmethod
    def name(self) -> str:
        """Plugin name."""
        pass
    
    @property
    @abstractmethod
    def description(self) -> str:
        """What this plugin checks for."""
        pass
    
    @abstractmethod
    def run(self, target: str, session) -> List[Vulnerability]:
        """Execute the security check. Returns list of findings."""
        pass

class PluginRegistry:
    """Manages and discovers scanner plugins."""
    
    def __init__(self):
        self._plugins: Dict[str, Type[ScannerPlugin]] = {}
    
    def register(self, plugin_class: Type[ScannerPlugin]):
        """Register a plugin with the scanner."""
        instance = plugin_class()
        self._plugins[instance.name] = plugin_class
    
    def get_all(self) -> List[Type[ScannerPlugin]]:
        """Get all registered plugins."""
        return list(self._plugins.values())
    
    def get_by_name(self, name: str) -> Optional[Type[ScannerPlugin]]:
        """Get a specific plugin by name."""
        return self._plugins.get(name)

# This architecture allows anyone to write new plugins
# by simply inheriting from ScannerPlugin and implementing
# the name, description, and run() method.
# The scanner automatically discovers and runs all plugins.
```

### Key Features to Implement

```
1. Modular plugin system (easy to add new checks)
2. Concurrent scanning (async for speed)
3. Rate limiting (don't crash the target)
4. Authentication support (test authenticated areas)
5. Multiple output formats (JSON, HTML, PDF)
6. Severity scoring (CVSS-like)
7. False positive reduction (validation logic)
8. Resumable scans (save state, continue later)
9. Scope control (stay within defined boundaries)
10. Evidence collection (save requests/responses)
```

---

## Project 3: Network Intrusion Detection System

### Overview

Build a network IDS that monitors traffic in real-time, detects attacks using signature and anomaly-based methods, and generates alerts.

### Implementation

```python
#!/usr/bin/env python3
"""
Network Intrusion Detection System (NIDS)
Detection methods: Signature-based + Anomaly-based + Statistical

Detects:
- Port scans (SYN scan, FIN scan, XMAS scan)
- Brute force attacks
- DoS/DDoS patterns
- Known exploit signatures
- DNS tunneling
- ARP spoofing
- Suspicious payload patterns
"""

from scapy.all import *
from collections import defaultdict, deque
from dataclasses import dataclass
from datetime import datetime, timedelta
from typing import Dict, List, Callable
import threading
import time
import json
import logging

logging.basicConfig(level=logging.INFO, 
                   format='%(asctime)s [%(levelname)s] %(message)s')
logger = logging.getLogger('NIDS')

@dataclass
class Alert:
    """IDS Alert."""
    timestamp: str
    severity: str  # Critical, High, Medium, Low
    alert_type: str
    source_ip: str
    dest_ip: str = ""
    dest_port: int = 0
    description: str = ""
    raw_packet: str = ""

class SignatureEngine:
    """Signature-based detection (pattern matching)."""
    
    def __init__(self):
        self.signatures = [
            # SQL Injection patterns in HTTP
            (rb"(?:union\s+select|or\s+1\s*=\s*1|'\s*or\s*'|drop\s+table)",
             "SQL Injection Attempt", "High"),
            # XSS patterns
            (rb"<script[^>]*>|javascript:|onerror\s*=|onload\s*=",
             "XSS Attempt", "Medium"),
            # Shell commands in HTTP
            (rb"/etc/passwd|/etc/shadow|/bin/bash|cmd\.exe|powershell",
             "Command Injection Attempt", "High"),
            # Known exploit strings
            (rb"EternalBlue|MS17-010|CVE-\d{4}-\d+",
             "Known Exploit Reference", "Critical"),
            # Reverse shell indicators
            (rb"/dev/tcp/|nc\s+-[elp]|bash\s+-i|python\s+-c.*socket",
             "Reverse Shell Attempt", "Critical"),
            # Directory traversal
            (rb"\.\./\.\./|\.\.\\\\|%2e%2e%2f|%252e%252e",
             "Directory Traversal Attempt", "High"),
        ]
    
    def check(self, payload: bytes) -> List[tuple]:
        """Check payload against all signatures."""
        matches = []
        for pattern, name, severity in self.signatures:
            if re.search(pattern, payload, re.IGNORECASE):
                matches.append((name, severity))
        return matches

class AnomalyEngine:
    """Anomaly-based detection (statistical analysis)."""
    
    def __init__(self):
        # Track connections per source IP
        self.connections: Dict[str, deque] = defaultdict(lambda: deque(maxlen=1000))
        # Track ports accessed per source IP
        self.ports_accessed: Dict[str, set] = defaultdict(set)
        # Track SYN packets (for SYN flood detection)
        self.syn_count: Dict[str, int] = defaultdict(int)
        # Track failed connections (RST received)
        self.rst_count: Dict[str, int] = defaultdict(int)
        # Thresholds
        self.PORT_SCAN_THRESHOLD = 20  # ports in 60 seconds
        self.SYN_FLOOD_THRESHOLD = 100  # SYN packets per second
        self.BRUTE_FORCE_THRESHOLD = 10  # connections to same port in 60s
        # Time window
        self.window = 60  # seconds
        # Reset counters periodically
        self.last_reset = time.time()
    
    def analyze(self, src_ip: str, dst_ip: str, dst_port: int, 
                flags: str) -> List[Alert]:
        """Analyze packet for anomalous behavior."""
        alerts = []
        now = datetime.now()
        
        # Reset counters every minute
        if time.time() - self.last_reset > self.window:
            self.ports_accessed.clear()
            self.syn_count.clear()
            self.rst_count.clear()
            self.last_reset = time.time()
        
        # Track port access
        self.ports_accessed[src_ip].add(dst_port)
        
        # PORT SCAN DETECTION
        if len(self.ports_accessed[src_ip]) > self.PORT_SCAN_THRESHOLD:
            alerts.append(Alert(
                timestamp=now.strftime("%Y-%m-%d %H:%M:%S"),
                severity="Medium",
                alert_type="Port Scan Detected",
                source_ip=src_ip,
                dest_ip=dst_ip,
                description=f"Accessed {len(self.ports_accessed[src_ip])} ports in {self.window}s"
            ))
            self.ports_accessed[src_ip].clear()
        
        # SYN FLOOD DETECTION
        if 'S' in flags and 'A' not in flags:
            self.syn_count[src_ip] += 1
            if self.syn_count[src_ip] > self.SYN_FLOOD_THRESHOLD:
                alerts.append(Alert(
                    timestamp=now.strftime("%Y-%m-%d %H:%M:%S"),
                    severity="High",
                    alert_type="SYN Flood Attack",
                    source_ip=src_ip,
                    dest_ip=dst_ip,
                    description=f"{self.syn_count[src_ip]} SYN packets in {self.window}s"
                ))
                self.syn_count[src_ip] = 0
        
        return alerts

class NetworkIDS:
    """Main IDS engine that coordinates detection modules."""
    
    def __init__(self, interface: str = None):
        self.interface = interface
        self.signature_engine = SignatureEngine()
        self.anomaly_engine = AnomalyEngine()
        self.alerts: List[Alert] = []
        self.packet_count = 0
        self.running = False
    
    def packet_handler(self, packet):
        """Process each captured packet."""
        self.packet_count += 1
        
        if not packet.haslayer(IP):
            return
        
        src_ip = packet[IP].src
        dst_ip = packet[IP].dst
        
        # TCP analysis
        if packet.haslayer(TCP):
            dst_port = packet[TCP].dport
            flags = str(packet[TCP].flags)
            
            # Anomaly detection
            anomaly_alerts = self.anomaly_engine.analyze(
                src_ip, dst_ip, dst_port, flags
            )
            self.alerts.extend(anomaly_alerts)
            for alert in anomaly_alerts:
                self._notify(alert)
            
            # Signature detection on payload
            if packet.haslayer(Raw):
                payload = bytes(packet[Raw].load)
                matches = self.signature_engine.check(payload)
                for name, severity in matches:
                    alert = Alert(
                        timestamp=datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                        severity=severity,
                        alert_type=name,
                        source_ip=src_ip,
                        dest_ip=dst_ip,
                        dest_port=dst_port,
                        description=f"Signature match in TCP payload to port {dst_port}"
                    )
                    self.alerts.append(alert)
                    self._notify(alert)
    
    def _notify(self, alert: Alert):
        """Handle alert notification."""
        color = {
            'Critical': '\033[91m',
            'High': '\033[93m',
            'Medium': '\033[33m',
            'Low': '\033[36m'
        }.get(alert.severity, '\033[0m')
        
        print(f"{color}[{alert.severity}] {alert.alert_type} | "
              f"{alert.source_ip} → {alert.dest_ip}:{alert.dest_port} | "
              f"{alert.description}\033[0m")
    
    def start(self):
        """Start packet capture and analysis."""
        self.running = True
        logger.info(f"IDS started. Interface: {self.interface or 'default'}")
        logger.info(f"Loaded {len(self.signature_engine.signatures)} signatures")
        logger.info("Monitoring for attacks...")
        
        try:
            sniff(
                iface=self.interface,
                prn=self.packet_handler,
                store=0,
                stop_filter=lambda p: not self.running
            )
        except KeyboardInterrupt:
            self.stop()
    
    def stop(self):
        """Stop the IDS."""
        self.running = False
        logger.info(f"IDS stopped. Processed {self.packet_count} packets, "
                   f"generated {len(self.alerts)} alerts")
    
    def export_alerts(self, filepath: str):
        """Export alerts to JSON file."""
        data = [
            {
                'timestamp': a.timestamp,
                'severity': a.severity,
                'type': a.alert_type,
                'source': a.source_ip,
                'destination': f"{a.dest_ip}:{a.dest_port}",
                'description': a.description
            }
            for a in self.alerts
        ]
        with open(filepath, 'w') as f:
            json.dump(data, f, indent=2)


if __name__ == "__main__":
    import sys
    interface = sys.argv[1] if len(sys.argv) > 1 else None
    ids = NetworkIDS(interface=interface)
    ids.start()
```

---

## Project 4: Active Directory Attack Lab

### Overview

Build a realistic enterprise Active Directory environment for practicing both offensive and defensive techniques.

### Complete Lab Setup Script

```powershell
# ══════════════════════════════════════════════════════════
# ACTIVE DIRECTORY LAB AUTOMATED SETUP
# Run on Windows Server 2019/2022 (Domain Controller)
# ══════════════════════════════════════════════════════════

# STEP 1: Install Active Directory
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-WindowsFeature DNS -IncludeManagementTools

# Promote to Domain Controller
$SecurePassword = ConvertTo-SecureString "LabP@ssw0rd!" -AsPlainText -Force
Install-ADDSForest `
    -DomainName "corp.local" `
    -DomainNetBIOSName "CORP" `
    -SafeModeAdministratorPassword $SecurePassword `
    -InstallDns:$true `
    -Force:$true

# After reboot, continue with:

# STEP 2: Create Organizational Units
New-ADOrganizationalUnit -Name "Corp Users" -Path "DC=corp,DC=local"
New-ADOrganizationalUnit -Name "Corp Computers" -Path "DC=corp,DC=local"
New-ADOrganizationalUnit -Name "Corp Groups" -Path "DC=corp,DC=local"
New-ADOrganizationalUnit -Name "Service Accounts" -Path "DC=corp,DC=local"
New-ADOrganizationalUnit -Name "Servers" -Path "DC=corp,DC=local"

# STEP 3: Create Users (with various privilege levels)
$Users = @(
    @{Name="John Smith"; Sam="jsmith"; Pass="Summer2024!"; Dept="IT"},
    @{Name="Jane Doe"; Sam="jdoe"; Pass="Welcome1!"; Dept="HR"},
    @{Name="Bob Wilson"; Sam="bwilson"; Pass="Password123!"; Dept="Finance"},
    @{Name="Alice Brown"; Sam="abrown"; Pass="C0mplex!Pass"; Dept="IT"},
    @{Name="SQL Service"; Sam="svc_sql"; Pass="SQLServiceP@ss"; Dept="Service"},
    @{Name="Web Service"; Sam="svc_web"; Pass="W3bServ!ce"; Dept="Service"},
    @{Name="Backup Admin"; Sam="backup_admin"; Pass="Backup2024!"; Dept="IT"},
    @{Name="Help Desk"; Sam="helpdesk"; Pass="HelpDesk1!"; Dept="IT"}
)

foreach ($user in $Users) {
    $secPass = ConvertTo-SecureString $user.Pass -AsPlainText -Force
    New-ADUser `
        -Name $user.Name `
        -SamAccountName $user.Sam `
        -UserPrincipalName "$($user.Sam)@corp.local" `
        -Path "OU=Corp Users,DC=corp,DC=local" `
        -AccountPassword $secPass `
        -Enabled $true `
        -PasswordNeverExpires $true `
        -Department $user.Dept
}

# STEP 4: Create Groups and Add Members
New-ADGroup -Name "IT Admins" -GroupScope Global -Path "OU=Corp Groups,DC=corp,DC=local"
New-ADGroup -Name "Help Desk" -GroupScope Global -Path "OU=Corp Groups,DC=corp,DC=local"
New-ADGroup -Name "Developers" -GroupScope Global -Path "OU=Corp Groups,DC=corp,DC=local"
New-ADGroup -Name "Domain Admins Tier 1" -GroupScope Global -Path "OU=Corp Groups,DC=corp,DC=local"

Add-ADGroupMember -Identity "IT Admins" -Members "abrown","backup_admin"
Add-ADGroupMember -Identity "Help Desk" -Members "helpdesk"
Add-ADGroupMember -Identity "Domain Admins" -Members "abrown"

# STEP 5: Configure Vulnerabilities for Practice

# Kerberoastable account (SPN set on user account)
Set-ADUser -Identity "svc_sql" -ServicePrincipalNames @{Add="MSSQLSvc/sql01.corp.local:1433"}
Set-ADUser -Identity "svc_web" -ServicePrincipalNames @{Add="HTTP/web01.corp.local"}

# AS-REP Roastable account (no pre-auth required)
Set-ADAccountControl -Identity "jdoe" -DoesNotRequirePreAuth $true

# Weak ACLs (abusable permissions)
# Give helpdesk GenericAll on jsmith (password reset attack path)
$TargetUser = Get-ADUser "jsmith"
$HelpDesk = Get-ADUser "helpdesk"
$ACL = Get-Acl "AD:\$($TargetUser.DistinguishedName)"
$Rule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $HelpDesk.SID, "GenericAll", "Allow"
)
$ACL.AddAccessRule($Rule)
Set-Acl "AD:\$($TargetUser.DistinguishedName)" $ACL

# STEP 6: Configure Group Policy (Security Settings)
# Enable PowerShell logging (for blue team detection practice)
# Enable command line in process creation events (Event ID 4688)
# Configure audit policies

# Create GPO for logging
New-GPO -Name "Security Logging" | New-GPLink -Target "DC=corp,DC=local"

Write-Host "Lab setup complete! Attack paths available:"
Write-Host "1. Kerberoasting: svc_sql, svc_web (weak passwords)"
Write-Host "2. AS-REP Roasting: jdoe (no pre-auth)"
Write-Host "3. ACL Abuse: helpdesk has GenericAll on jsmith"
Write-Host "4. Password spraying: Multiple users with common passwords"
Write-Host "5. Domain Admin: abrown is DA (find credentials)"
```

### Attack Scenarios to Document

```
Scenario 1: Initial Access → Domain Admin
─────────────────────────────────────────
1. Network scan → Find DC and workstations
2. LLMNR/NBT-NS poisoning (Responder)
3. Capture NTLMv2 hash
4. Crack hash → Get valid credentials
5. BloodHound enumeration
6. Identify Kerberoastable accounts
7. Request TGS → Crack offline → Get svc_sql password
8. svc_sql has admin on file server
9. Find abrown's cached credentials on file server
10. DCSync as abrown (Domain Admin) → Full compromise

Document each step with:
- Exact commands used
- Expected output
- Detection methods (blue team perspective)
- Remediation for each vulnerability exploited
```

---

## Project 5: Threat Intelligence Platform

### Overview

Build an automated threat intelligence aggregation and analysis platform that collects IOCs from multiple feeds, enriches them, and provides actionable intelligence.

```python
#!/usr/bin/env python3
"""
Threat Intelligence Platform (TIP)
Aggregates IOCs from multiple sources, enriches, correlates, and alerts.
"""

import asyncio
import aiohttp
import hashlib
import json
from datetime import datetime, timedelta
from dataclasses import dataclass, field
from typing import List, Dict, Set, Optional
from enum import Enum
import sqlite3
import re

class IOCType(Enum):
    IP = "ip"
    DOMAIN = "domain"
    URL = "url"
    HASH_MD5 = "hash_md5"
    HASH_SHA256 = "hash_sha256"
    EMAIL = "email"

@dataclass
class IOC:
    """Indicator of Compromise."""
    value: str
    ioc_type: IOCType
    source: str
    first_seen: str
    last_seen: str
    confidence: int = 50  # 0-100
    tags: List[str] = field(default_factory=list)
    context: str = ""
    
class ThreatIntelPlatform:
    """
    Aggregates threat intelligence from multiple sources.
    
    Features:
    - Multi-source IOC collection
    - Automatic IOC type detection
    - Enrichment from multiple APIs
    - Confidence scoring
    - Deduplication
    - Age-based expiration
    - Search and correlation
    - Alert on matches against internal assets
    """
    
    def __init__(self, db_path: str = "threat_intel.db"):
        self.db_path = db_path
        self._init_database()
        self.feeds = []
    
    def _init_database(self):
        """Initialize SQLite database for IOC storage."""
        conn = sqlite3.connect(self.db_path)
        conn.execute("""
            CREATE TABLE IF NOT EXISTS iocs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                value TEXT NOT NULL,
                type TEXT NOT NULL,
                source TEXT,
                first_seen TEXT,
                last_seen TEXT,
                confidence INTEGER DEFAULT 50,
                tags TEXT,
                context TEXT,
                UNIQUE(value, type)
            )
        """)
        conn.execute("""
            CREATE TABLE IF NOT EXISTS enrichments (
                ioc_value TEXT,
                provider TEXT,
                result TEXT,
                timestamp TEXT,
                PRIMARY KEY(ioc_value, provider)
            )
        """)
        conn.commit()
        conn.close()
    
    def detect_ioc_type(self, value: str) -> Optional[IOCType]:
        """Auto-detect IOC type from value."""
        # IPv4
        if re.match(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$', value):
            return IOCType.IP
        # Domain
        if re.match(r'^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?(\.[a-zA-Z]{2,})+$', value):
            return IOCType.DOMAIN
        # URL
        if value.startswith(('http://', 'https://')):
            return IOCType.URL
        # MD5
        if re.match(r'^[a-fA-F0-9]{32}$', value):
            return IOCType.HASH_MD5
        # SHA256
        if re.match(r'^[a-fA-F0-9]{64}$', value):
            return IOCType.HASH_SHA256
        # Email
        if re.match(r'^[^@]+@[^@]+\.[^@]+$', value):
            return IOCType.EMAIL
        
        return None
    
    def add_ioc(self, ioc: IOC):
        """Add or update an IOC in the database."""
        conn = sqlite3.connect(self.db_path)
        conn.execute("""
            INSERT INTO iocs (value, type, source, first_seen, last_seen, confidence, tags, context)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT(value, type) DO UPDATE SET
                last_seen = excluded.last_seen,
                confidence = MAX(confidence, excluded.confidence),
                source = source || ',' || excluded.source
        """, (ioc.value, ioc.ioc_type.value, ioc.source, 
              ioc.first_seen, ioc.last_seen, ioc.confidence,
              json.dumps(ioc.tags), ioc.context))
        conn.commit()
        conn.close()
    
    async def enrich_ioc(self, value: str, ioc_type: IOCType) -> Dict:
        """Enrich IOC with data from threat intel APIs."""
        enrichment = {}
        
        async with aiohttp.ClientSession() as session:
            if ioc_type == IOCType.IP:
                # AbuseIPDB check
                enrichment['abuseipdb'] = await self._check_abuseipdb(session, value)
                # VirusTotal check
                enrichment['virustotal'] = await self._check_virustotal(session, value)
            
            elif ioc_type == IOCType.DOMAIN:
                enrichment['virustotal'] = await self._check_virustotal(session, value)
            
            elif ioc_type in (IOCType.HASH_MD5, IOCType.HASH_SHA256):
                enrichment['virustotal'] = await self._check_virustotal(session, value)
        
        return enrichment
    
    async def _check_abuseipdb(self, session, ip: str) -> Dict:
        """Check IP against AbuseIPDB."""
        # Requires API key in production
        # This is the structure of what's returned
        return {
            "ip": ip,
            "is_public": True,
            "abuse_confidence_score": 0,
            "country_code": "Unknown",
            "total_reports": 0
        }
    
    async def _check_virustotal(self, session, ioc: str) -> Dict:
        """Check IOC against VirusTotal."""
        # Requires API key in production
        return {
            "ioc": ioc,
            "detections": 0,
            "total_engines": 0,
            "malicious": False
        }
    
    def search(self, query: str) -> List[Dict]:
        """Search IOCs by value, tag, or source."""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.execute("""
            SELECT * FROM iocs 
            WHERE value LIKE ? OR tags LIKE ? OR source LIKE ?
            ORDER BY confidence DESC, last_seen DESC
        """, (f"%{query}%", f"%{query}%", f"%{query}%"))
        
        results = []
        for row in cursor.fetchall():
            results.append({
                'id': row[0], 'value': row[1], 'type': row[2],
                'source': row[3], 'first_seen': row[4],
                'last_seen': row[5], 'confidence': row[6],
                'tags': json.loads(row[7]) if row[7] else [],
                'context': row[8]
            })
        conn.close()
        return results
    
    def check_against_assets(self, assets: List[str]) -> List[Dict]:
        """Check if any known IOCs match internal assets."""
        matches = []
        conn = sqlite3.connect(self.db_path)
        
        for asset in assets:
            cursor = conn.execute(
                "SELECT * FROM iocs WHERE value = ?", (asset,)
            )
            for row in cursor.fetchall():
                matches.append({
                    'asset': asset,
                    'ioc_value': row[1],
                    'type': row[2],
                    'confidence': row[6],
                    'source': row[3]
                })
        
        conn.close()
        return matches
    
    def generate_report(self) -> str:
        """Generate threat intelligence summary report."""
        conn = sqlite3.connect(self.db_path)
        
        total = conn.execute("SELECT COUNT(*) FROM iocs").fetchone()[0]
        by_type = conn.execute(
            "SELECT type, COUNT(*) FROM iocs GROUP BY type"
        ).fetchall()
        high_confidence = conn.execute(
            "SELECT COUNT(*) FROM iocs WHERE confidence > 75"
        ).fetchone()[0]
        recent = conn.execute(
            "SELECT COUNT(*) FROM iocs WHERE last_seen > datetime('now', '-7 days')"
        ).fetchone()[0]
        
        conn.close()
        
        report = f"""
═══════════════════════════════════════════
   THREAT INTELLIGENCE SUMMARY REPORT
═══════════════════════════════════════════
Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

Total IOCs: {total}
High Confidence (>75): {high_confidence}
Added in Last 7 Days: {recent}

By Type:
"""
        for ioc_type, count in by_type:
            report += f"  {ioc_type}: {count}\n"
        
        return report
```

---

## Portfolio Presentation

### GitHub Repository Structure for Projects

```
your-github-username/
├── Security-Projects/
│   ├── README.md              ← Overview of all projects
│   ├── home-siem-lab/
│   │   ├── README.md          ← Detailed setup guide
│   │   ├── docs/
│   │   │   ├── architecture.md
│   │   │   └── detection-rules.md
│   │   ├── configs/
│   │   │   ├── wazuh-rules.xml
│   │   │   ├── sysmon-config.xml
│   │   │   └── dashboard-export.json
│   │   └── screenshots/
│   │       ├── dashboard.png
│   │       ├── alert-example.png
│   │       └── attack-detection.png
│   │
│   ├── vuln-scanner/
│   │   ├── README.md
│   │   ├── src/
│   │   │   ├── scanner.py
│   │   │   ├── plugins/
│   │   │   └── reporters/
│   │   ├── tests/
│   │   └── docs/
│   │
│   └── network-ids/
│       ├── README.md
│       ├── src/
│       ├── signatures/
│       └── docs/
│
├── CTF-Writeups/
│   ├── README.md
│   ├── HackTheBox/
│   ├── TryHackMe/
│   └── Competitions/
│
└── Security-Notes/
    ├── README.md
    └── topics/
```

---

## What Recruiters Look For

```
Technical Recruiters evaluate:
1. Code quality (clean, commented, organized)
2. Problem complexity (non-trivial solutions)
3. Documentation quality (can someone else use it?)
4. Variety (offensive + defensive + automation)
5. Recency (active in last 3 months)
6. Real-world applicability (solves actual problems)

Hiring Managers evaluate:
1. Does this person understand security concepts?
2. Can they build tools, not just use them?
3. Do they show initiative and self-direction?
4. Is their work well-organized and professional?
5. Can they explain their work clearly?

Red flags in portfolios:
❌ Copied projects without modification
❌ No documentation
❌ Broken code that doesn't run
❌ Only tutorial-following (no original work)
❌ Inactive for months
```

---

## Exercises

```
1. Complete the SIEM lab project with at least 5 custom detection rules
2. Build the vulnerability scanner with minimum 3 detection plugins
3. Set up the AD lab and document 3 complete attack paths
4. Create the threat intelligence platform with at least 2 feed sources
5. Document all projects professionally on GitHub
6. Write a blog post about one project explaining what you learned
```

---

**Next:** → [22-Certifications](../22-Certifications/README.md)

*"A portfolio of working security projects demonstrates more skill than any certification alone. Build things that solve real problems."*
