# 🐍 Programming for Cybersecurity

## Python, Bash, and C — Your Offensive and Defensive Arsenal

---

## 📌 Table of Contents

1. [Why Programming for Security](#why-programming-for-security)
2. [Python Fundamentals](#python-fundamentals)
3. [Python for Security](#python-for-security)
4. [Bash Scripting for Security](#bash-scripting-for-security)
5. [C Programming Basics](#c-programming-basics)
6. [Socket Programming](#socket-programming)
7. [Security Projects](#security-projects)
8. [Exercises and Labs](#exercises-and-labs)

---

## Why Programming for Security

| Scenario | Programming Skill Needed |
|----------|------------------------|
| Automate reconnaissance | Python scripting |
| Build custom exploits | Python + C |
| Parse log files | Python/Bash |
| Create network tools | Python sockets |
| Modify existing tools | Read any language |
| Write detection rules | Regex, scripting |
| Reverse engineer malware | C, Assembly understanding |

---

## Python Fundamentals

### Variables and Data Types

```python
# Strings
target_ip = "192.168.1.100"
username = "admin"

# Numbers
port = 8080
timeout = 5.0

# Booleans
is_vulnerable = True
is_patched = False

# Lists (ordered, mutable)
open_ports = [22, 80, 443, 8080]
open_ports.append(3306)

# Dictionaries (key-value pairs)
host_info = {
    "ip": "192.168.1.100",
    "hostname": "web-server",
    "os": "Ubuntu 20.04",
    "ports": [22, 80, 443]
}

# Tuples (ordered, immutable)
credentials = ("admin", "password123")

# Sets (unique values)
unique_ips = {"192.168.1.1", "192.168.1.2", "192.168.1.1"}
# Result: {"192.168.1.1", "192.168.1.2"}
```

### Control Flow

```python
# If/elif/else
def check_port(port):
    if port < 1024:
        return "Well-known port (requires root)"
    elif port < 49152:
        return "Registered port"
    else:
        return "Dynamic/private port"

# For loops
for port in range(1, 1025):
    # scan port
    pass

# While loops
attempts = 0
max_attempts = 3
while attempts < max_attempts:
    # try login
    attempts += 1

# List comprehension
open_ports = [p for p in range(1, 65536) if is_open(target, p)]
```

### Functions

```python
import socket

def scan_port(target, port, timeout=1):
    """Check if a port is open on target host."""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        result = sock.connect_ex((target, port))
        sock.close()
        return result == 0  # True if open
    except socket.error:
        return False

def scan_range(target, start_port, end_port):
    """Scan a range of ports on target."""
    open_ports = []
    for port in range(start_port, end_port + 1):
        if scan_port(target, port):
            open_ports.append(port)
            print(f"[+] Port {port} is OPEN")
    return open_ports
```

### File Handling

```python
# Reading files
with open("/etc/passwd", "r") as f:
    for line in f:
        username = line.split(":")[0]
        print(username)

# Writing files
with open("scan_results.txt", "w") as f:
    f.write("Port Scan Results\n")
    f.write("=" * 40 + "\n")
    for port in open_ports:
        f.write(f"Port {port}: OPEN\n")

# Reading binary files (for malware analysis)
with open("suspicious.exe", "rb") as f:
    magic_bytes = f.read(4)
    if magic_bytes[:2] == b'MZ':
        print("This is a Windows PE executable")
```

### Error Handling

```python
import socket

def safe_connect(target, port):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(3)
        sock.connect((target, port))
        banner = sock.recv(1024).decode('utf-8', errors='ignore')
        sock.close()
        return banner
    except socket.timeout:
        return "Connection timed out"
    except ConnectionRefusedError:
        return "Connection refused"
    except socket.error as e:
        return f"Socket error: {e}"
    finally:
        sock.close()
```

### Regular Expressions

```python
import re

# Find IP addresses in text
text = "Server at 192.168.1.100 connected to 10.0.0.1"
ips = re.findall(r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b', text)
print(ips)  # ['192.168.1.100', '10.0.0.1']

# Find email addresses
emails = re.findall(r'[\w.-]+@[\w.-]+\.\w+', webpage_content)

# Find URLs
urls = re.findall(r'https?://[\w./\-?=&]+', html_content)

# Validate input (defense)
def is_valid_ip(ip):
    pattern = r'^(\d{1,3}\.){3}\d{1,3}$'
    if re.match(pattern, ip):
        octets = ip.split('.')
        return all(0 <= int(o) <= 255 for o in octets)
    return False
```

---

## Python for Security

### Port Scanner (Complete)

```python
#!/usr/bin/env python3
"""
Simple TCP Port Scanner
Usage: python3 port_scanner.py <target> [start_port] [end_port]
"""

import socket
import sys
import threading
from datetime import datetime

# Thread lock for clean output
print_lock = threading.Lock()
open_ports = []

def scan_port(target, port):
    """Scan a single port."""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(1)
        result = sock.connect_ex((target, port))
        if result == 0:
            with print_lock:
                service = get_service(port)
                print(f"  [+] Port {port:>5}/tcp  OPEN  ({service})")
                open_ports.append(port)
        sock.close()
    except:
        pass

def get_service(port):
    """Get common service name for port."""
    services = {
        21: "FTP", 22: "SSH", 23: "Telnet", 25: "SMTP",
        53: "DNS", 80: "HTTP", 110: "POP3", 143: "IMAP",
        443: "HTTPS", 445: "SMB", 3306: "MySQL",
        3389: "RDP", 5432: "PostgreSQL", 8080: "HTTP-Proxy"
    }
    return services.get(port, "Unknown")

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 port_scanner.py <target> [start_port] [end_port]")
        sys.exit(1)
    
    target = sys.argv[1]
    start_port = int(sys.argv[2]) if len(sys.argv) > 2 else 1
    end_port = int(sys.argv[3]) if len(sys.argv) > 3 else 1024
    
    # Resolve hostname
    try:
        target_ip = socket.gethostbyname(target)
    except socket.gaierror:
        print(f"[-] Cannot resolve hostname: {target}")
        sys.exit(1)
    
    print(f"\n{'='*50}")
    print(f"  Port Scanner - Target: {target_ip}")
    print(f"  Scanning ports {start_port}-{end_port}")
    print(f"  Started at: {datetime.now()}")
    print(f"{'='*50}\n")
    
    # Scan with threads
    threads = []
    for port in range(start_port, end_port + 1):
        t = threading.Thread(target=scan_port, args=(target_ip, port))
        threads.append(t)
        t.start()
        
        # Limit concurrent threads
        if len(threads) >= 100:
            for t in threads:
                t.join()
            threads = []
    
    # Wait for remaining threads
    for t in threads:
        t.join()
    
    print(f"\n{'='*50}")
    print(f"  Scan complete: {len(open_ports)} open ports found")
    print(f"  Finished at: {datetime.now()}")
    print(f"{'='*50}\n")

if __name__ == "__main__":
    main()
```

### Network Scanner (Host Discovery)

```python
#!/usr/bin/env python3
"""
Network Host Discovery using ARP
Requires: pip install scapy
"""

from scapy.all import ARP, Ether, srp
import sys

def discover_hosts(network):
    """Discover live hosts on a network using ARP."""
    print(f"\n[*] Scanning network: {network}")
    print("-" * 50)
    
    # Create ARP request
    arp_request = ARP(pdst=network)
    broadcast = Ether(dst="ff:ff:ff:ff:ff:ff")
    packet = broadcast / arp_request
    
    # Send and receive
    answered, unanswered = srp(packet, timeout=2, verbose=False)
    
    hosts = []
    for sent, received in answered:
        hosts.append({
            'ip': received.psrc,
            'mac': received.hwsrc
        })
    
    # Display results
    print(f"{'IP Address':<20} {'MAC Address':<20}")
    print("-" * 40)
    for host in hosts:
        print(f"{host['ip']:<20} {host['mac']:<20}")
    
    print(f"\n[+] {len(hosts)} hosts discovered")
    return hosts

if __name__ == "__main__":
    network = sys.argv[1] if len(sys.argv) > 1 else "192.168.1.0/24"
    discover_hosts(network)
```

### Password Hash Cracker

```python
#!/usr/bin/env python3
"""
Simple password hash cracker using dictionary attack.
Educational purposes only!
"""

import hashlib
import sys
import time

def crack_hash(target_hash, wordlist_path, hash_type="md5"):
    """Attempt to crack a hash using a wordlist."""
    
    hash_functions = {
        "md5": hashlib.md5,
        "sha1": hashlib.sha1,
        "sha256": hashlib.sha256,
        "sha512": hashlib.sha512
    }
    
    if hash_type not in hash_functions:
        print(f"[-] Unsupported hash type: {hash_type}")
        return None
    
    hash_func = hash_functions[hash_type]
    attempts = 0
    start_time = time.time()
    
    print(f"[*] Target hash: {target_hash}")
    print(f"[*] Hash type: {hash_type}")
    print(f"[*] Wordlist: {wordlist_path}")
    print("[*] Cracking...\n")
    
    try:
        with open(wordlist_path, "r", encoding="utf-8", errors="ignore") as f:
            for line in f:
                word = line.strip()
                attempts += 1
                
                # Hash the word
                computed_hash = hash_func(word.encode()).hexdigest()
                
                if computed_hash == target_hash:
                    elapsed = time.time() - start_time
                    print(f"[+] CRACKED! Password: {word}")
                    print(f"[+] Attempts: {attempts:,}")
                    print(f"[+] Time: {elapsed:.2f} seconds")
                    return word
                
                # Progress indicator
                if attempts % 100000 == 0:
                    print(f"  [{attempts:,} attempts...]", end="\r")
    
    except FileNotFoundError:
        print(f"[-] Wordlist not found: {wordlist_path}")
        return None
    
    elapsed = time.time() - start_time
    print(f"\n[-] Password not found after {attempts:,} attempts ({elapsed:.2f}s)")
    return None

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 hash_cracker.py <hash> <wordlist> [hash_type]")
        print("Example: python3 hash_cracker.py 5f4dcc3b5aa765d61d8327deb882cf99 rockyou.txt md5")
        sys.exit(1)
    
    target = sys.argv[1]
    wordlist = sys.argv[2]
    htype = sys.argv[3] if len(sys.argv) > 3 else "md5"
    
    crack_hash(target, wordlist, htype)
```

### Web Directory Brute Forcer

```python
#!/usr/bin/env python3
"""
Web directory brute forcer.
Only use on systems you have permission to test!
"""

import requests
import sys
import threading
from queue import Queue

def check_directory(target_url, path, results):
    """Check if a directory/file exists."""
    url = f"{target_url.rstrip('/')}/{path}"
    try:
        response = requests.get(url, timeout=5, allow_redirects=False)
        if response.status_code in [200, 301, 302, 403]:
            status = response.status_code
            size = len(response.content)
            print(f"  [{status}] /{path:<30} (Size: {size})")
            results.append({"path": path, "status": status, "size": size})
    except requests.exceptions.RequestException:
        pass

def brute_force(target_url, wordlist_path, threads=10):
    """Brute force directories on a web server."""
    print(f"\n[*] Target: {target_url}")
    print(f"[*] Wordlist: {wordlist_path}")
    print(f"[*] Threads: {threads}")
    print("-" * 60)
    
    results = []
    
    try:
        with open(wordlist_path, "r") as f:
            paths = [line.strip() for line in f if line.strip()]
    except FileNotFoundError:
        print(f"[-] Wordlist not found: {wordlist_path}")
        return
    
    thread_list = []
    for path in paths:
        t = threading.Thread(target=check_directory, args=(target_url, path, results))
        thread_list.append(t)
        t.start()
        
        if len(thread_list) >= threads:
            for t in thread_list:
                t.join()
            thread_list = []
    
    for t in thread_list:
        t.join()
    
    print(f"\n[+] Scan complete: {len(results)} paths found")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 dir_brute.py <url> <wordlist>")
        sys.exit(1)
    
    brute_force(sys.argv[1], sys.argv[2])
```

---

## Bash Scripting for Security

### Automated Recon Script

```bash
#!/bin/bash
# Automated reconnaissance script
# Usage: ./recon.sh <target_domain>

if [ -z "$1" ]; then
    echo "Usage: $0 <target_domain>"
    exit 1
fi

TARGET=$1
OUTPUT_DIR="recon_$TARGET"
mkdir -p "$OUTPUT_DIR"

echo "=================================="
echo "  Reconnaissance: $TARGET"
echo "=================================="

# DNS Enumeration
echo "[*] DNS Enumeration..."
dig +short $TARGET A > "$OUTPUT_DIR/dns_a.txt"
dig +short $TARGET MX > "$OUTPUT_DIR/dns_mx.txt"
dig +short $TARGET NS > "$OUTPUT_DIR/dns_ns.txt"
dig +short $TARGET TXT > "$OUTPUT_DIR/dns_txt.txt"

# Subdomain enumeration (basic)
echo "[*] Subdomain enumeration..."
for sub in www mail ftp admin dev staging api portal; do
    result=$(dig +short $sub.$TARGET A)
    if [ -n "$result" ]; then
        echo "  [+] $sub.$TARGET → $result"
        echo "$sub.$TARGET,$result" >> "$OUTPUT_DIR/subdomains.txt"
    fi
done

# WHOIS
echo "[*] WHOIS lookup..."
whois $TARGET > "$OUTPUT_DIR/whois.txt" 2>/dev/null

# Port scan
echo "[*] Port scanning..."
nmap -sV -sC -oN "$OUTPUT_DIR/nmap_scan.txt" $TARGET

echo ""
echo "[+] Recon complete! Results in: $OUTPUT_DIR/"
ls -la "$OUTPUT_DIR/"
```

### Log Analysis Script

```bash
#!/bin/bash
# Analyze auth.log for security events
LOG="/var/log/auth.log"

echo "=== Security Log Analysis ==="
echo "Date: $(date)"
echo ""

echo "[*] Failed SSH Logins (Top 10 IPs):"
grep "Failed password" $LOG 2>/dev/null | \
    awk '{print $(NF-3)}' | sort | uniq -c | sort -rn | head -10
echo ""

echo "[*] Successful SSH Logins:"
grep "Accepted" $LOG 2>/dev/null | \
    awk '{print $1, $2, $3, $9, $11}' | tail -10
echo ""

echo "[*] Sudo Commands:"
grep "sudo:" $LOG 2>/dev/null | grep "COMMAND" | tail -10
echo ""

echo "[*] New User Accounts Created:"
grep "useradd" $LOG 2>/dev/null
echo ""

echo "[*] Total Failed Attempts: $(grep -c 'Failed password' $LOG 2>/dev/null)"
echo "[*] Total Successful Logins: $(grep -c 'Accepted' $LOG 2>/dev/null)"
```

---

## C Programming Basics

### Why C for Security

- Buffer overflow exploits are written targeting C programs
- Understanding C = understanding vulnerabilities
- Shellcode, exploit development requires C/Assembly
- Many system tools and OS kernels are written in C

### Vulnerable C Program (Educational)

```c
#include <stdio.h>
#include <string.h>

// THIS IS INTENTIONALLY VULNERABLE - for learning buffer overflows
void vulnerable_function(char *input) {
    char buffer[64];  // Fixed-size buffer
    strcpy(buffer, input);  // NO bounds checking! VULNERABLE!
    printf("You entered: %s\n", buffer);
}

// SECURE version
void secure_function(char *input) {
    char buffer[64];
    strncpy(buffer, input, sizeof(buffer) - 1);  // Bounds checking
    buffer[sizeof(buffer) - 1] = '\0';  // Null terminate
    printf("You entered: %s\n", buffer);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <input>\n", argv[0]);
        return 1;
    }
    vulnerable_function(argv[1]);
    return 0;
}

// Compile: gcc -fno-stack-protector -z execstack -no-pie -o vuln vuln.c
// The flags disable security protections for learning purposes
```

---

## Socket Programming

### TCP Client

```python
import socket

def tcp_client(target, port, message):
    """Simple TCP client."""
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client.connect((target, port))
    client.send(message.encode())
    response = client.recv(4096)
    print(f"Response: {response.decode()}")
    client.close()

# Banner grabbing
def grab_banner(target, port):
    """Grab service banner."""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(3)
        sock.connect((target, port))
        banner = sock.recv(1024).decode('utf-8', errors='ignore').strip()
        sock.close()
        return banner
    except:
        return None
```

### TCP Server (Reverse Shell Listener Concept)

```python
import socket
import threading

def handle_client(client_socket, addr):
    """Handle incoming client connection."""
    print(f"[+] Connection from {addr}")
    while True:
        data = client_socket.recv(4096)
        if not data:
            break
        print(f"Received: {data.decode()}")
        client_socket.send(b"ACK")
    client_socket.close()

def start_server(host, port):
    """Start a TCP server."""
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind((host, port))
    server.listen(5)
    print(f"[*] Listening on {host}:{port}")
    
    while True:
        client, addr = server.accept()
        handler = threading.Thread(target=handle_client, args=(client, addr))
        handler.start()

if __name__ == "__main__":
    start_server("0.0.0.0", 4444)
```

---

## Security Projects

### Project 1: Complete Port Scanner (Month 3)
Build a multi-threaded port scanner with service detection, banner grabbing, and output to file.

### Project 2: Packet Sniffer (Month 3)
Build a network sniffer using Scapy that captures and analyzes packets.

### Project 3: Password Manager (Month 3)
Build a secure password manager with encryption (using `cryptography` library).

### Project 4: Log Parser (Month 3)
Build a log analysis tool that detects suspicious activity in auth logs.

### Project 5: File Integrity Monitor (Month 3)
Build a tool that monitors files for unauthorized changes using hashing.

---

## Exercises and Labs

### Exercise 1: Python Basics
1. Write a script that takes an IP address and validates it
2. Write a script that reads `/etc/passwd` and lists all users
3. Write a function that converts between decimal, hex, and binary

### Exercise 2: Security Scripting
1. Write a port scanner for the top 100 ports
2. Write a script that checks if a website is up
3. Write a brute force script for a login page (on YOUR test server)

### Exercise 3: Bash Automation
1. Write a script that checks for SUID files
2. Write a script that monitors new network connections
3. Write a script that backs up important config files

---

## Summary

| Language | Primary Use | Security Application |
|----------|------------|---------------------|
| Python | Automation, tools | Exploits, scanners, parsers |
| Bash | System admin | Recon, automation, one-liners |
| C | System programming | Understanding vulnerabilities |

**Next:** → [05-Web-Development](../05-Web-Development/README.md)

---

*"The best security professionals write code. The best hackers automate everything."*
