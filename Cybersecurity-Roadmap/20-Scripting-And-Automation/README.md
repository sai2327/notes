# ⚡ Scripting & Automation for Cybersecurity

## Automate Everything — Work Smarter, Hack Faster, Defend Better

---

## Table of Contents

1. [Why Automation Matters](#why-automation-matters)
2. [Python for Security Automation](#python-for-security-automation)
3. [Bash Scripting for Security](#bash-scripting-for-security)
4. [PowerShell for Security](#powershell-for-security)
5. [Network Automation](#network-automation)
6. [Web Application Automation](#web-application-automation)
7. [Log Analysis Automation](#log-analysis-automation)
8. [Threat Intelligence Automation](#threat-intelligence-automation)
9. [Incident Response Automation](#incident-response-automation)
10. [Reconnaissance Automation](#reconnaissance-automation)
11. [Vulnerability Scanning Automation](#vulnerability-scanning-automation)
12. [Reporting Automation](#reporting-automation)
13. [Enterprise Automation Platforms](#enterprise-automation-platforms)
14. [Labs & Exercises](#labs--exercises)
15. [Interview Questions](#interview-questions)

---

## Why Automation Matters

### The Automation Mindset

```
Manual process:
- Analyst receives alert
- Opens SIEM, copies IP address
- Checks VirusTotal manually
- Checks AbuseIPDB manually
- Checks internal asset database manually
- Writes findings in ticket manually
- Time: 15-30 minutes per alert

Automated process:
- Alert triggers automation
- Script enriches IOC from 10+ sources simultaneously
- Cross-references internal assets
- Assigns severity based on rules
- Creates pre-populated ticket
- Time: 5 seconds per alert

At 100 alerts/day:
Manual: 25-50 hours of analyst time
Automated: 8 minutes total + analyst review
```

### What to Automate in Cybersecurity

```
Offensive (Red Team/Pentest):
├── Reconnaissance (subdomain enum, port scanning, content discovery)
├── Vulnerability scanning (template-based scanning)
├── Exploitation (payload generation, delivery)
├── Post-exploitation (data collection, persistence)
├── Reporting (findings → report generation)
└── Monitoring (new assets, changes)

Defensive (Blue Team/SOC):
├── Alert triage (enrichment, deduplication, prioritization)
├── IOC enrichment (check IOCs against multiple sources)
├── Log analysis (pattern detection, anomaly identification)
├── Threat intelligence (feed ingestion, correlation)
├── Incident response (containment, evidence collection)
├── Compliance checking (configuration auditing)
└── Report generation (executive summaries, metrics)

General:
├── Asset inventory (discover and track all systems)
├── Configuration management (ensure security baselines)
├── Patch management (identify missing patches)
├── User management (deprovisioning, access reviews)
└── Backup verification (integrity checks)
```

---

## Python for Security Automation

### Python Security Libraries - Complete Reference

```python
# ═══════════════════════════════════════════════════════
# ESSENTIAL LIBRARIES FOR SECURITY AUTOMATION
# ═══════════════════════════════════════════════════════

# Network operations
import socket          # Low-level networking (port scanning, connections)
import ssl             # SSL/TLS operations
import struct          # Binary data packing/unpacking (packet crafting)

# HTTP operations
import requests        # HTTP client (web testing, API calls)
import aiohttp         # Async HTTP (high-performance scanning)
import urllib3         # Low-level HTTP (custom requests)

# Packet crafting and analysis
from scapy.all import *  # Packet manipulation (requires root/admin)

# DNS operations
import dns.resolver    # DNS queries
import dns.zone        # Zone transfers

# Cryptography
from cryptography.fernet import Fernet  # Symmetric encryption
from cryptography.hazmat.primitives import hashes  # Hashing
import hashlib         # Standard hashing
import hmac            # HMAC operations

# Web scraping / parsing
from bs4 import BeautifulSoup  # HTML parsing
import lxml            # Fast XML/HTML parsing
import re              # Regular expressions

# System operations
import subprocess      # Execute system commands
import os              # OS interaction
import platform        # System information
import psutil          # Process and system monitoring

# Async operations
import asyncio         # Async framework
import concurrent.futures  # Thread/process pools

# Data handling
import json            # JSON parsing
import csv             # CSV operations
import sqlite3         # Local database
import yaml            # YAML parsing

# File operations
import pathlib         # Modern path handling
import zipfile         # Archive operations
import hashlib         # File integrity checking

# Date/time
from datetime import datetime, timedelta
import time

# Logging
import logging         # Structured logging

# Security-specific
import paramiko        # SSH client
import pyperclip       # Clipboard operations
import colorama        # Colored terminal output
```

### Network Scanner - Production Quality

```python
#!/usr/bin/env python3
"""
Advanced Network Scanner
Performs: host discovery, port scanning, service detection, OS fingerprinting
"""

import socket
import struct
import asyncio
import ipaddress
from dataclasses import dataclass, field
from typing import List, Dict, Optional, Tuple
from datetime import datetime
import json
import sys

@dataclass
class PortResult:
    """Represents a single port scan result."""
    port: int
    state: str  # open, closed, filtered
    service: str = ""
    banner: str = ""
    version: str = ""

@dataclass
class HostResult:
    """Represents scan results for a single host."""
    ip: str
    is_alive: bool = False
    hostname: str = ""
    os_guess: str = ""
    ports: List[PortResult] = field(default_factory=list)
    scan_time: float = 0.0

class NetworkScanner:
    """
    Production-quality network scanner.
    
    Features:
    - Async port scanning (thousands of ports in seconds)
    - Service banner grabbing
    - Common service identification
    - Rate limiting to avoid detection
    - Multiple output formats (JSON, CSV, human-readable)
    - Configurable timeouts and retry logic
    """
    
    # Common ports and their services
    COMMON_PORTS = {
        21: "FTP", 22: "SSH", 23: "Telnet", 25: "SMTP",
        53: "DNS", 80: "HTTP", 110: "POP3", 111: "RPCbind",
        135: "MSRPC", 139: "NetBIOS", 143: "IMAP", 443: "HTTPS",
        445: "SMB", 993: "IMAPS", 995: "POP3S", 1433: "MSSQL",
        1521: "Oracle", 2049: "NFS", 3306: "MySQL", 3389: "RDP",
        5432: "PostgreSQL", 5900: "VNC", 6379: "Redis",
        8080: "HTTP-Alt", 8443: "HTTPS-Alt", 8888: "HTTP-Alt",
        9200: "Elasticsearch", 27017: "MongoDB"
    }
    
    def __init__(self, timeout: float = 2.0, max_concurrent: int = 100,
                 retries: int = 1):
        self.timeout = timeout
        self.max_concurrent = max_concurrent
        self.retries = retries
        self.semaphore = asyncio.Semaphore(max_concurrent)
    
    async def check_port(self, ip: str, port: int) -> PortResult:
        """Check if a single port is open using TCP connect scan."""
        async with self.semaphore:
            for attempt in range(self.retries + 1):
                try:
                    reader, writer = await asyncio.wait_for(
                        asyncio.open_connection(ip, port),
                        timeout=self.timeout
                    )
                    
                    # Port is open - try to grab banner
                    banner = ""
                    try:
                        # Send empty line to trigger banner
                        writer.write(b"\r\n")
                        await writer.drain()
                        data = await asyncio.wait_for(
                            reader.read(1024), timeout=2.0
                        )
                        banner = data.decode('utf-8', errors='ignore').strip()
                    except (asyncio.TimeoutError, Exception):
                        pass
                    
                    writer.close()
                    await writer.wait_closed()
                    
                    service = self.COMMON_PORTS.get(port, "unknown")
                    return PortResult(
                        port=port, state="open",
                        service=service, banner=banner
                    )
                    
                except asyncio.TimeoutError:
                    if attempt == self.retries:
                        return PortResult(port=port, state="filtered")
                except ConnectionRefusedError:
                    return PortResult(port=port, state="closed")
                except OSError:
                    if attempt == self.retries:
                        return PortResult(port=port, state="filtered")
        
        return PortResult(port=port, state="filtered")
    
    async def scan_host(self, ip: str, ports: List[int]) -> HostResult:
        """Scan all specified ports on a single host."""
        start_time = datetime.now()
        result = HostResult(ip=ip)
        
        # Check if host is alive (quick port check)
        alive_check = await self.check_port(ip, 80)
        if alive_check.state != "open":
            alive_check = await self.check_port(ip, 443)
        result.is_alive = alive_check.state == "open"
        
        # Resolve hostname
        try:
            hostname = socket.gethostbyaddr(ip)
            result.hostname = hostname[0]
        except socket.herror:
            pass
        
        # Scan all ports concurrently
        tasks = [self.check_port(ip, port) for port in ports]
        port_results = await asyncio.gather(*tasks)
        
        # Only keep open/filtered ports
        result.ports = [p for p in port_results if p.state == "open"]
        result.is_alive = len(result.ports) > 0
        result.scan_time = (datetime.now() - start_time).total_seconds()
        
        return result
    
    async def scan_network(self, target: str, ports: List[int]) -> List[HostResult]:
        """Scan an entire network range."""
        try:
            network = ipaddress.ip_network(target, strict=False)
            hosts = [str(ip) for ip in network.hosts()]
        except ValueError:
            hosts = [target]
        
        print(f"[*] Scanning {len(hosts)} hosts, {len(ports)} ports each")
        print(f"[*] Max concurrent connections: {self.max_concurrent}")
        
        tasks = [self.scan_host(ip, ports) for ip in hosts]
        results = await asyncio.gather(*tasks)
        
        # Filter to only alive hosts
        alive = [r for r in results if r.is_alive]
        return alive
    
    def generate_report(self, results: List[HostResult]) -> str:
        """Generate human-readable scan report."""
        report = []
        report.append("=" * 60)
        report.append("        NETWORK SCAN REPORT")
        report.append(f"        Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        report.append("=" * 60)
        report.append(f"\nHosts alive: {len(results)}\n")
        
        for host in results:
            report.append(f"─── {host.ip} ({host.hostname or 'no PTR'}) ───")
            report.append(f"    Scan time: {host.scan_time:.2f}s")
            report.append(f"    Open ports: {len(host.ports)}")
            
            if host.ports:
                report.append(f"    {'PORT':<8} {'STATE':<10} {'SERVICE':<15} {'BANNER'}")
                report.append(f"    {'─'*8} {'─'*10} {'─'*15} {'─'*30}")
                for port in sorted(host.ports, key=lambda p: p.port):
                    banner_short = port.banner[:40] if port.banner else ""
                    report.append(
                        f"    {port.port:<8} {port.state:<10} "
                        f"{port.service:<15} {banner_short}"
                    )
            report.append("")
        
        return "\n".join(report)
    
    def export_json(self, results: List[HostResult], filepath: str):
        """Export results as JSON."""
        data = []
        for host in results:
            data.append({
                "ip": host.ip,
                "hostname": host.hostname,
                "ports": [
                    {"port": p.port, "state": p.state,
                     "service": p.service, "banner": p.banner}
                    for p in host.ports
                ]
            })
        with open(filepath, 'w') as f:
            json.dump(data, f, indent=2)


async def main():
    """Main execution."""
    if len(sys.argv) < 2:
        print("Usage: python3 scanner.py <target> [port_range]")
        print("Examples:")
        print("  python3 scanner.py 192.168.1.0/24")
        print("  python3 scanner.py 10.10.10.10 1-1000")
        sys.exit(1)
    
    target = sys.argv[1]
    
    # Parse port range
    if len(sys.argv) > 2:
        port_arg = sys.argv[2]
        if "-" in port_arg:
            start, end = port_arg.split("-")
            ports = list(range(int(start), int(end) + 1))
        else:
            ports = [int(p) for p in port_arg.split(",")]
    else:
        # Default: top 100 ports
        ports = [21,22,23,25,53,80,110,111,135,139,143,443,445,993,
                 995,1433,1521,2049,3306,3389,5432,5900,6379,8080,8443,
                 8888,9200,27017]
    
    scanner = NetworkScanner(timeout=2.0, max_concurrent=200)
    results = await scanner.scan_network(target, ports)
    
    # Print report
    print(scanner.generate_report(results))
    
    # Export JSON
    scanner.export_json(results, f"scan_{target.replace('/', '_')}.json")
    print(f"[+] Results saved to scan_{target.replace('/', '_')}.json")


if __name__ == "__main__":
    asyncio.run(main())
```

### Web Vulnerability Scanner Framework

```python
#!/usr/bin/env python3
"""
Web Application Vulnerability Scanner Framework
Tests for: SQLi, XSS, Security Headers, Sensitive Files, CORS misconfig
"""

import requests
import re
from urllib.parse import urljoin, urlparse, parse_qs, urlencode
from bs4 import BeautifulSoup
from dataclasses import dataclass, field
from typing import List, Dict, Set, Tuple
import json
from datetime import datetime
import warnings
warnings.filterwarnings('ignore')  # Suppress SSL warnings for testing

@dataclass
class Finding:
    """Represents a vulnerability finding."""
    severity: str  # Critical, High, Medium, Low, Info
    title: str
    url: str
    description: str
    evidence: str = ""
    remediation: str = ""

class WebVulnScanner:
    """
    Modular web vulnerability scanner.
    
    Architecture:
    ┌──────────────────────────────────────────┐
    │              WebVulnScanner               │
    ├──────────────────────────────────────────┤
    │  Crawler → Discovers URLs and forms      │
    │  HeaderChecker → Security headers        │
    │  SQLiTester → SQL injection              │
    │  XSSTester → Cross-site scripting        │
    │  FileFinder → Sensitive file detection    │
    │  CORSChecker → CORS misconfiguration     │
    │  Reporter → Generate findings report     │
    └──────────────────────────────────────────┘
    """
    
    def __init__(self, target_url: str, max_depth: int = 3,
                 timeout: int = 10, verify_ssl: bool = False):
        self.target = target_url.rstrip('/')
        self.max_depth = max_depth
        self.timeout = timeout
        self.verify_ssl = verify_ssl
        self.session = requests.Session()
        self.session.verify = verify_ssl
        self.session.headers.update({
            'User-Agent': 'SecurityScanner/1.0 (Authorized Testing)'
        })
        
        self.crawled_urls: Set[str] = set()
        self.forms: List[Dict] = []
        self.findings: List[Finding] = []
        self.parameters: Dict[str, List[str]] = {}
    
    # ─────────────────────────────────────────────────
    # CRAWLER MODULE
    # ─────────────────────────────────────────────────
    
    def crawl(self, url: str = None, depth: int = 0):
        """Spider the website to discover pages and forms."""
        if url is None:
            url = self.target
        
        if depth > self.max_depth or url in self.crawled_urls:
            return
        
        if not url.startswith(self.target):
            return  # Don't crawl external sites
        
        self.crawled_urls.add(url)
        
        try:
            response = self.session.get(url, timeout=self.timeout)
            soup = BeautifulSoup(response.text, 'html.parser')
            
            # Extract forms
            for form in soup.find_all('form'):
                form_data = self._parse_form(form, url)
                if form_data:
                    self.forms.append(form_data)
            
            # Extract links
            for link in soup.find_all('a', href=True):
                next_url = urljoin(url, link['href'])
                # Remove fragment
                next_url = next_url.split('#')[0]
                if next_url.startswith(self.target):
                    self.crawl(next_url, depth + 1)
            
            # Extract parameters from URL
            parsed = urlparse(url)
            if parsed.query:
                params = parse_qs(parsed.query)
                self.parameters[url] = list(params.keys())
                    
        except requests.RequestException:
            pass
    
    def _parse_form(self, form, page_url: str) -> Dict:
        """Parse HTML form into testable structure."""
        action = form.get('action', '')
        method = form.get('method', 'get').upper()
        form_url = urljoin(page_url, action)
        
        inputs = []
        for inp in form.find_all(['input', 'textarea', 'select']):
            input_data = {
                'name': inp.get('name', ''),
                'type': inp.get('type', 'text'),
                'value': inp.get('value', '')
            }
            if input_data['name']:
                inputs.append(input_data)
        
        return {
            'url': form_url,
            'method': method,
            'inputs': inputs,
            'page': page_url
        }
    
    # ─────────────────────────────────────────────────
    # SECURITY HEADERS CHECK
    # ─────────────────────────────────────────────────
    
    def check_security_headers(self):
        """Check for missing security headers."""
        try:
            response = self.session.get(self.target, timeout=self.timeout)
        except requests.RequestException:
            return
        
        headers_to_check = {
            'Strict-Transport-Security': {
                'severity': 'Medium',
                'desc': 'Missing HSTS header. Browser can be downgraded to HTTP.',
                'fix': 'Add: Strict-Transport-Security: max-age=31536000; includeSubDomains'
            },
            'X-Content-Type-Options': {
                'severity': 'Low',
                'desc': 'Missing X-Content-Type-Options. MIME sniffing possible.',
                'fix': 'Add: X-Content-Type-Options: nosniff'
            },
            'X-Frame-Options': {
                'severity': 'Medium',
                'desc': 'Missing X-Frame-Options. Clickjacking may be possible.',
                'fix': 'Add: X-Frame-Options: DENY or SAMEORIGIN'
            },
            'Content-Security-Policy': {
                'severity': 'Medium',
                'desc': 'Missing CSP header. XSS impact not mitigated.',
                'fix': 'Implement Content-Security-Policy with strict directives'
            },
            'X-XSS-Protection': {
                'severity': 'Low',
                'desc': 'Missing X-XSS-Protection header.',
                'fix': 'Add: X-XSS-Protection: 1; mode=block'
            },
            'Permissions-Policy': {
                'severity': 'Low',
                'desc': 'Missing Permissions-Policy. Browser features unrestricted.',
                'fix': 'Add Permissions-Policy to restrict camera, microphone, etc.'
            }
        }
        
        for header, info in headers_to_check.items():
            if header.lower() not in [h.lower() for h in response.headers]:
                self.findings.append(Finding(
                    severity=info['severity'],
                    title=f"Missing Security Header: {header}",
                    url=self.target,
                    description=info['desc'],
                    evidence=f"Header '{header}' not present in response",
                    remediation=info['fix']
                ))
        
        # Check for information disclosure headers
        dangerous_headers = ['Server', 'X-Powered-By', 'X-AspNet-Version']
        for header in dangerous_headers:
            if header in response.headers:
                self.findings.append(Finding(
                    severity='Low',
                    title=f"Information Disclosure: {header} header",
                    url=self.target,
                    description=f"Server reveals technology via {header} header",
                    evidence=f"{header}: {response.headers[header]}",
                    remediation=f"Remove or obfuscate the {header} header"
                ))
    
    # ─────────────────────────────────────────────────
    # SQL INJECTION TESTING
    # ─────────────────────────────────────────────────
    
    def test_sqli(self):
        """Test parameters for SQL injection vulnerabilities."""
        
        # Error-based SQLi payloads
        payloads = [
            ("'", "Single quote"),
            ("''", "Double single quote"),
            ("' OR '1'='1", "OR true condition"),
            ("' OR '1'='1'--", "OR true with comment"),
            ("1' ORDER BY 100--", "ORDER BY high number"),
            ("' UNION SELECT NULL--", "UNION with NULL"),
            ("1; WAITFOR DELAY '0:0:5'--", "Time-based (MSSQL)"),
            ("1' AND SLEEP(5)--", "Time-based (MySQL)"),
        ]
        
        # SQL error signatures
        sql_errors = [
            r"SQL syntax.*MySQL",
            r"Warning.*mysql_",
            r"PostgreSQL.*ERROR",
            r"ORA-\d{5}",
            r"Microsoft.*ODBC",
            r"Microsoft.*SQL Server",
            r"Unclosed quotation mark",
            r"quoted string not properly terminated",
            r"SQLite3::query",
            r"sqlite_",
            r"pg_query",
            r"valid MySQL result",
        ]
        
        # Test URL parameters
        for url, params in self.parameters.items():
            for param in params:
                for payload, desc in payloads:
                    test_url = self._inject_param(url, param, payload)
                    try:
                        response = self.session.get(
                            test_url, timeout=self.timeout
                        )
                        for error_pattern in sql_errors:
                            if re.search(error_pattern, response.text, re.IGNORECASE):
                                self.findings.append(Finding(
                                    severity='Critical',
                                    title=f"SQL Injection in parameter '{param}'",
                                    url=url,
                                    description=f"SQL error triggered with: {desc}",
                                    evidence=f"Payload: {payload}\nError pattern matched: {error_pattern}",
                                    remediation="Use parameterized queries/prepared statements"
                                ))
                                break
                    except requests.RequestException:
                        pass
        
        # Test forms
        for form in self.forms:
            for inp in form['inputs']:
                if inp['type'] in ('text', 'search', 'hidden'):
                    for payload, desc in payloads[:3]:  # Fewer payloads for forms
                        self._test_form_sqli(form, inp['name'], payload, desc)
    
    def _inject_param(self, url: str, param: str, payload: str) -> str:
        """Inject payload into a specific URL parameter."""
        parsed = urlparse(url)
        params = parse_qs(parsed.query)
        params[param] = [payload]
        new_query = urlencode(params, doseq=True)
        return f"{parsed.scheme}://{parsed.netloc}{parsed.path}?{new_query}"
    
    def _test_form_sqli(self, form: Dict, param: str, payload: str, desc: str):
        """Test a form parameter for SQL injection."""
        data = {}
        for inp in form['inputs']:
            if inp['name'] == param:
                data[inp['name']] = payload
            else:
                data[inp['name']] = inp['value'] or 'test'
        
        try:
            if form['method'] == 'POST':
                response = self.session.post(
                    form['url'], data=data, timeout=self.timeout
                )
            else:
                response = self.session.get(
                    form['url'], params=data, timeout=self.timeout
                )
            
            sql_errors = [r"SQL syntax", r"mysql_", r"PostgreSQL.*ERROR",
                         r"ORA-\d{5}", r"ODBC", r"Unclosed quotation"]
            for pattern in sql_errors:
                if re.search(pattern, response.text, re.IGNORECASE):
                    self.findings.append(Finding(
                        severity='Critical',
                        title=f"SQL Injection in form parameter '{param}'",
                        url=form['url'],
                        description=f"SQL error triggered via form. Payload: {desc}",
                        evidence=f"Form action: {form['url']}\nParam: {param}\nPayload: {payload}",
                        remediation="Use parameterized queries/prepared statements"
                    ))
                    return
        except requests.RequestException:
            pass
    
    # ─────────────────────────────────────────────────
    # XSS TESTING
    # ─────────────────────────────────────────────────
    
    def test_xss(self):
        """Test for reflected XSS vulnerabilities."""
        
        # Unique marker to detect reflection
        marker = "sc4nn3r7x5s"
        
        # XSS payloads with marker for detection
        payloads = [
            (f"<script>{marker}</script>", f"<script>{marker}</script>"),
            (f"<img src=x onerror={marker}>", f"onerror={marker}"),
            (f'"><script>{marker}</script>', f"<script>{marker}</script>"),
            (f"'{marker}", marker),  # Check for reflection first
        ]
        
        # Test URL parameters
        for url, params in self.parameters.items():
            for param in params:
                # First check if parameter is reflected at all
                test_url = self._inject_param(url, param, marker)
                try:
                    response = self.session.get(test_url, timeout=self.timeout)
                    if marker in response.text:
                        # Parameter is reflected - test XSS payloads
                        for payload, check in payloads:
                            test_url = self._inject_param(url, param, payload)
                            response = self.session.get(
                                test_url, timeout=self.timeout
                            )
                            if check in response.text:
                                self.findings.append(Finding(
                                    severity='High',
                                    title=f"Reflected XSS in parameter '{param}'",
                                    url=url,
                                    description="User input reflected in page without encoding",
                                    evidence=f"Payload: {payload}\nReflected as: {check}",
                                    remediation="Encode output based on context (HTML, JS, URL)"
                                ))
                                break
                except requests.RequestException:
                    pass
    
    # ─────────────────────────────────────────────────
    # SENSITIVE FILE DETECTION
    # ─────────────────────────────────────────────────
    
    def check_sensitive_files(self):
        """Check for exposed sensitive files and directories."""
        
        sensitive_paths = [
            ('.git/HEAD', 'Git repository exposed'),
            ('.git/config', 'Git configuration exposed'),
            ('.env', 'Environment file exposed (may contain secrets)'),
            ('.htaccess', 'Apache configuration exposed'),
            ('wp-config.php.bak', 'WordPress config backup'),
            ('web.config', 'IIS configuration exposed'),
            ('robots.txt', 'Robots.txt (informational)'),
            ('sitemap.xml', 'Sitemap (informational)'),
            ('.DS_Store', 'macOS directory metadata exposed'),
            ('server-status', 'Apache server-status exposed'),
            ('server-info', 'Apache server-info exposed'),
            ('phpinfo.php', 'PHP info page exposed'),
            ('info.php', 'PHP info page exposed'),
            ('test.php', 'Test file exposed'),
            ('debug.log', 'Debug log file exposed'),
            ('error.log', 'Error log file exposed'),
            ('access.log', 'Access log file exposed'),
            ('backup.sql', 'Database backup exposed'),
            ('dump.sql', 'Database dump exposed'),
            ('database.sql', 'Database file exposed'),
            ('config.json', 'Configuration file exposed'),
            ('config.yaml', 'Configuration file exposed'),
            ('composer.json', 'PHP dependencies exposed'),
            ('package.json', 'Node.js dependencies exposed'),
            ('.svn/entries', 'SVN repository exposed'),
            ('crossdomain.xml', 'Flash cross-domain policy'),
            ('WEB-INF/web.xml', 'Java deployment descriptor'),
            ('actuator/env', 'Spring Boot actuator (env vars!)'),
            ('actuator/heapdump', 'Spring Boot heap dump'),
        ]
        
        for path, description in sensitive_paths:
            url = f"{self.target}/{path}"
            try:
                response = self.session.get(
                    url, timeout=self.timeout, allow_redirects=False
                )
                if response.status_code == 200:
                    # Verify it's not a custom 404
                    if len(response.text) > 0 and 'not found' not in response.text.lower():
                        severity = 'High' if any(
                            x in path for x in ['.env', '.git', 'config', 'backup', 'dump', 'actuator']
                        ) else 'Medium'
                        
                        self.findings.append(Finding(
                            severity=severity,
                            title=f"Sensitive File Exposed: {path}",
                            url=url,
                            description=description,
                            evidence=f"HTTP 200 response, {len(response.text)} bytes",
                            remediation="Remove file or restrict access via web server config"
                        ))
            except requests.RequestException:
                pass
    
    # ─────────────────────────────────────────────────
    # CORS MISCONFIGURATION CHECK
    # ─────────────────────────────────────────────────
    
    def check_cors(self):
        """Check for CORS misconfigurations."""
        
        test_origins = [
            "https://evil.com",
            f"https://{urlparse(self.target).hostname}.evil.com",
            "null",
            f"https://sub.{urlparse(self.target).hostname}",
        ]
        
        for origin in test_origins:
            try:
                response = self.session.get(
                    self.target,
                    headers={'Origin': origin},
                    timeout=self.timeout
                )
                
                acao = response.headers.get('Access-Control-Allow-Origin', '')
                acac = response.headers.get('Access-Control-Allow-Credentials', '')
                
                if acao == origin or acao == '*':
                    if acac.lower() == 'true' or acao == origin:
                        self.findings.append(Finding(
                            severity='High',
                            title="CORS Misconfiguration - Arbitrary Origin Reflected",
                            url=self.target,
                            description=f"Server reflects arbitrary Origin header with credentials",
                            evidence=f"Origin sent: {origin}\nACAO: {acao}\nACAC: {acac}",
                            remediation="Implement strict origin whitelist, never reflect arbitrary origins"
                        ))
                        break
            except requests.RequestException:
                pass
    
    # ─────────────────────────────────────────────────
    # REPORT GENERATION
    # ─────────────────────────────────────────────────
    
    def run_all_checks(self):
        """Execute all security checks."""
        print(f"[*] Target: {self.target}")
        print(f"[*] Starting scan at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        
        print("[*] Phase 1: Crawling...")
        self.crawl()
        print(f"    Found {len(self.crawled_urls)} URLs, {len(self.forms)} forms")
        
        print("[*] Phase 2: Checking security headers...")
        self.check_security_headers()
        
        print("[*] Phase 3: Testing for SQL injection...")
        self.test_sqli()
        
        print("[*] Phase 4: Testing for XSS...")
        self.test_xss()
        
        print("[*] Phase 5: Checking sensitive files...")
        self.check_sensitive_files()
        
        print("[*] Phase 6: Checking CORS...")
        self.check_cors()
        
        print(f"\n[+] Scan complete! {len(self.findings)} findings.")
        return self.generate_report()
    
    def generate_report(self) -> str:
        """Generate formatted vulnerability report."""
        severity_order = {'Critical': 0, 'High': 1, 'Medium': 2, 'Low': 3, 'Info': 4}
        sorted_findings = sorted(
            self.findings, 
            key=lambda f: severity_order.get(f.severity, 5)
        )
        
        report = []
        report.append("=" * 70)
        report.append("          WEB APPLICATION VULNERABILITY SCAN REPORT")
        report.append("=" * 70)
        report.append(f"Target:     {self.target}")
        report.append(f"Date:       {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        report.append(f"URLs Found: {len(self.crawled_urls)}")
        report.append(f"Forms Found: {len(self.forms)}")
        report.append(f"Findings:   {len(self.findings)}")
        report.append("")
        
        # Summary by severity
        for sev in ['Critical', 'High', 'Medium', 'Low', 'Info']:
            count = len([f for f in self.findings if f.severity == sev])
            if count > 0:
                report.append(f"  [{sev}]: {count}")
        
        report.append("\n" + "─" * 70)
        
        for i, finding in enumerate(sorted_findings, 1):
            report.append(f"\n[{finding.severity}] Finding #{i}: {finding.title}")
            report.append(f"  URL: {finding.url}")
            report.append(f"  Description: {finding.description}")
            if finding.evidence:
                report.append(f"  Evidence: {finding.evidence}")
            if finding.remediation:
                report.append(f"  Remediation: {finding.remediation}")
            report.append("─" * 70)
        
        return "\n".join(report)


# Usage
if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else "http://testphp.vulnweb.com"
    scanner = WebVulnScanner(target, max_depth=2)
    report = scanner.run_all_checks()
    print(report)
```

### Log Analysis Automation

```python
#!/usr/bin/env python3
"""
Security Log Analyzer
Detects: Brute force, port scans, suspicious patterns, anomalies
Supports: Apache, Nginx, auth.log, Windows Event Logs (exported)
"""

import re
from collections import defaultdict, Counter
from datetime import datetime, timedelta
from dataclasses import dataclass
from typing import List, Dict, Tuple
import json
import sys

@dataclass
class SecurityAlert:
    """Represents a security alert."""
    timestamp: str
    severity: str
    alert_type: str
    source_ip: str
    description: str
    evidence: List[str]

class LogAnalyzer:
    """
    Multi-format security log analyzer.
    
    Detection capabilities:
    - Brute force attacks (multiple failed logins from same IP)
    - Port scanning (connections to many ports from same IP)
    - Web attacks (SQL injection, XSS, path traversal in URLs)
    - Suspicious user agents (scanners, bots)
    - Anomalous access patterns (unusual times, locations)
    - Data exfiltration indicators (large responses)
    - Directory traversal attempts
    - Admin panel access attempts
    """
    
    def __init__(self):
        self.alerts: List[SecurityAlert] = []
        self.ip_stats: Dict[str, Dict] = defaultdict(lambda: {
            'requests': 0,
            'failed_logins': 0,
            'unique_paths': set(),
            'status_codes': Counter(),
            'timestamps': [],
            'user_agents': set(),
            'methods': Counter(),
            'total_bytes': 0
        })
    
    # Apache/Nginx combined log format parser
    APACHE_PATTERN = re.compile(
        r'(\S+) \S+ \S+ \[([^\]]+)\] "(\S+) (\S+) \S+" (\d+) (\d+|-) "([^"]*)" "([^"]*)"'
    )
    
    # Auth.log pattern (Linux)
    AUTH_PATTERN = re.compile(
        r'(\w+\s+\d+\s+\d+:\d+:\d+)\s+\S+\s+\S+\[\d+\]:\s+(.*)'
    )
    
    def parse_apache_log(self, filepath: str):
        """Parse Apache/Nginx access logs."""
        with open(filepath, 'r', errors='ignore') as f:
            for line in f:
                match = self.APACHE_PATTERN.match(line)
                if match:
                    ip, timestamp, method, path, status, size, referer, ua = match.groups()
                    
                    stats = self.ip_stats[ip]
                    stats['requests'] += 1
                    stats['unique_paths'].add(path)
                    stats['status_codes'][int(status)] += 1
                    stats['timestamps'].append(timestamp)
                    stats['user_agents'].add(ua)
                    stats['methods'][method] += 1
                    stats['total_bytes'] += int(size) if size != '-' else 0
                    
                    # Real-time attack detection
                    self._check_web_attack(ip, method, path, status, ua, timestamp)
    
    def parse_auth_log(self, filepath: str):
        """Parse Linux auth.log for authentication events."""
        failed_logins = defaultdict(list)
        successful_logins = defaultdict(list)
        
        with open(filepath, 'r', errors='ignore') as f:
            for line in f:
                # Failed password
                if "Failed password" in line:
                    ip_match = re.search(r'from (\d+\.\d+\.\d+\.\d+)', line)
                    user_match = re.search(r'for (?:invalid user )?(\S+)', line)
                    if ip_match:
                        ip = ip_match.group(1)
                        user = user_match.group(1) if user_match else "unknown"
                        failed_logins[ip].append({
                            'user': user,
                            'line': line.strip()
                        })
                
                # Successful login
                elif "Accepted" in line:
                    ip_match = re.search(r'from (\d+\.\d+\.\d+\.\d+)', line)
                    if ip_match:
                        ip = ip_match.group(1)
                        successful_logins[ip].append(line.strip())
                
                # Sudo commands
                elif "sudo:" in line and "COMMAND=" in line:
                    user_match = re.search(r'sudo:\s+(\S+)', line)
                    cmd_match = re.search(r'COMMAND=(.*)', line)
                    if user_match and cmd_match:
                        cmd = cmd_match.group(1)
                        # Alert on suspicious commands
                        suspicious_cmds = [
                            'chmod 777', 'wget', 'curl.*|.*sh', 
                            'nc -', 'ncat', '/dev/tcp', 'python.*-c',
                            'base64 -d', 'useradd', 'passwd'
                        ]
                        for pattern in suspicious_cmds:
                            if re.search(pattern, cmd):
                                self.alerts.append(SecurityAlert(
                                    timestamp=line[:15],
                                    severity="High",
                                    alert_type="Suspicious Command",
                                    source_ip="local",
                                    description=f"Suspicious sudo command by {user_match.group(1)}",
                                    evidence=[line.strip()]
                                ))
        
        # Detect brute force
        for ip, attempts in failed_logins.items():
            if len(attempts) >= 5:
                self.alerts.append(SecurityAlert(
                    timestamp=datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                    severity="High" if len(attempts) >= 10 else "Medium",
                    alert_type="Brute Force Attack",
                    source_ip=ip,
                    description=f"{len(attempts)} failed login attempts",
                    evidence=[a['line'] for a in attempts[:5]]
                ))
            
            # Credential stuffing (many different usernames from same IP)
            unique_users = set(a['user'] for a in attempts)
            if len(unique_users) >= 5:
                self.alerts.append(SecurityAlert(
                    timestamp=datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                    severity="High",
                    alert_type="Credential Stuffing",
                    source_ip=ip,
                    description=f"{len(unique_users)} unique usernames attempted",
                    evidence=[f"Users tried: {', '.join(list(unique_users)[:10])}"]
                ))
    
    def _check_web_attack(self, ip: str, method: str, path: str, 
                          status: str, ua: str, timestamp: str):
        """Check individual request for attack patterns."""
        
        # SQL Injection patterns
        sqli_patterns = [
            r"(\%27)|(\')|(\-\-)|(\%23)|(#)",
            r"((\%3D)|(=))[^\n]*((\%27)|(\')|(\-\-)|(\%3B)|(;))",
            r"\w*((\%27)|(\'))((\%6F)|o|(\%4F))((\%72)|r|(\%52))",
            r"union.*select", r"concat.*\(", r"group_by.*\(",
            r"insert.*into", r"drop.*table", r"update.*set",
        ]
        
        for pattern in sqli_patterns:
            if re.search(pattern, path, re.IGNORECASE):
                self.alerts.append(SecurityAlert(
                    timestamp=timestamp,
                    severity="High",
                    alert_type="SQL Injection Attempt",
                    source_ip=ip,
                    description=f"SQLi pattern detected in URL",
                    evidence=[f"{method} {path}"]
                ))
                break
        
        # XSS patterns
        xss_patterns = [
            r"<script", r"javascript:", r"onerror\s*=",
            r"onload\s*=", r"eval\s*\(", r"document\.",
            r"alert\s*\(", r"<img.*onerror", r"<svg.*onload",
        ]
        
        for pattern in xss_patterns:
            if re.search(pattern, path, re.IGNORECASE):
                self.alerts.append(SecurityAlert(
                    timestamp=timestamp,
                    severity="Medium",
                    alert_type="XSS Attempt",
                    source_ip=ip,
                    description=f"XSS pattern detected in URL",
                    evidence=[f"{method} {path}"]
                ))
                break
        
        # Path traversal
        if re.search(r"\.\./|\.\.\\|%2e%2e|%252e", path, re.IGNORECASE):
            self.alerts.append(SecurityAlert(
                timestamp=timestamp,
                severity="High",
                alert_type="Path Traversal Attempt",
                source_ip=ip,
                description=f"Directory traversal pattern detected",
                evidence=[f"{method} {path}"]
            ))
        
        # Scanner/bot detection
        scanner_patterns = [
            r"sqlmap", r"nikto", r"nmap", r"masscan",
            r"dirbuster", r"gobuster", r"wfuzz", r"burp",
            r"acunetix", r"nessus", r"openvas",
        ]
        
        for pattern in scanner_patterns:
            if re.search(pattern, ua, re.IGNORECASE):
                self.alerts.append(SecurityAlert(
                    timestamp=timestamp,
                    severity="Medium",
                    alert_type="Scanner Detected",
                    source_ip=ip,
                    description=f"Known security scanner user-agent",
                    evidence=[f"User-Agent: {ua}"]
                ))
                break
    
    def detect_port_scan(self, threshold: int = 20):
        """Detect port scanning behavior."""
        for ip, stats in self.ip_stats.items():
            unique_paths = len(stats['unique_paths'])
            if unique_paths >= threshold:
                # High number of unique paths = likely scanning
                error_rate = stats['status_codes'].get(404, 0) / max(stats['requests'], 1)
                if error_rate > 0.5:  # >50% 404s = scanning
                    self.alerts.append(SecurityAlert(
                        timestamp=datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
                        severity="Medium",
                        alert_type="Directory Scanning",
                        source_ip=ip,
                        description=f"{unique_paths} unique paths, {error_rate:.0%} error rate",
                        evidence=[f"Total requests: {stats['requests']}, 404s: {stats['status_codes'].get(404, 0)}"]
                    ))
    
    def generate_report(self) -> str:
        """Generate analysis report."""
        report = []
        report.append("=" * 60)
        report.append("       SECURITY LOG ANALYSIS REPORT")
        report.append("=" * 60)
        report.append(f"Analysis time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        report.append(f"Total alerts: {len(self.alerts)}")
        report.append("")
        
        # Summary
        severity_counts = Counter(a.severity for a in self.alerts)
        for sev in ['Critical', 'High', 'Medium', 'Low']:
            if severity_counts[sev]:
                report.append(f"  {sev}: {severity_counts[sev]}")
        
        report.append("\n" + "─" * 60)
        
        # Detailed alerts
        for i, alert in enumerate(sorted(self.alerts, 
                                         key=lambda a: {'Critical':0,'High':1,'Medium':2,'Low':3}[a.severity]), 1):
            report.append(f"\n[{alert.severity}] #{i}: {alert.alert_type}")
            report.append(f"  Source IP: {alert.source_ip}")
            report.append(f"  Time: {alert.timestamp}")
            report.append(f"  Description: {alert.description}")
            for ev in alert.evidence[:3]:
                report.append(f"  Evidence: {ev}")
        
        return "\n".join(report)


# Usage
if __name__ == "__main__":
    analyzer = LogAnalyzer()
    
    if len(sys.argv) > 1:
        logfile = sys.argv[1]
        if 'auth' in logfile:
            analyzer.parse_auth_log(logfile)
        else:
            analyzer.parse_apache_log(logfile)
            analyzer.detect_port_scan()
    
    print(analyzer.generate_report())
```

---

## Bash Scripting for Security

### Automated Security Audit Script

```bash
#!/bin/bash
# ══════════════════════════════════════════════════════════
# LINUX SECURITY AUDIT SCRIPT
# ══════════════════════════════════════════════════════════
# Performs comprehensive security checks on a Linux system
# Run as root for complete results

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

REPORT_FILE="security_audit_$(hostname)_$(date +%Y%m%d_%H%M%S).txt"

log() {
    echo -e "$1" | tee -a "$REPORT_FILE"
}

header() {
    log "\n${YELLOW}══════════════════════════════════════════${NC}"
    log "${YELLOW}  $1${NC}"
    log "${YELLOW}══════════════════════════════════════════${NC}\n"
}

finding() {
    log "${RED}[!] FINDING: $1${NC}"
}

ok() {
    log "${GREEN}[✓] $1${NC}"
}

info() {
    log "[*] $1"
}

# ──────────────────────────────────────────────────────
header "SYSTEM INFORMATION"
# ──────────────────────────────────────────────────────
info "Hostname: $(hostname)"
info "OS: $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d'"' -f2)"
info "Kernel: $(uname -r)"
info "Uptime: $(uptime -p)"
info "Date: $(date)"

# ──────────────────────────────────────────────────────
header "USER SECURITY AUDIT"
# ──────────────────────────────────────────────────────

# Check for users with UID 0 (root privileges)
ROOT_USERS=$(awk -F: '$3 == 0 {print $1}' /etc/passwd)
if [ "$(echo "$ROOT_USERS" | wc -l)" -gt 1 ]; then
    finding "Multiple users with UID 0 (root): $ROOT_USERS"
else
    ok "Only root has UID 0"
fi

# Check for users with empty passwords
EMPTY_PASS=$(awk -F: '($2 == "" || $2 == "!") {print $1}' /etc/shadow 2>/dev/null)
if [ ! -z "$EMPTY_PASS" ]; then
    finding "Users with empty/no password: $EMPTY_PASS"
else
    ok "No users with empty passwords"
fi

# Check for users with login shells that shouldn't have them
SYSTEM_SHELL_USERS=$(awk -F: '$3 >= 1000 && $3 < 65534 && $7 != "/usr/sbin/nologin" && $7 != "/bin/false" {print $1":"$7}' /etc/passwd)
info "Users with login shells:"
echo "$SYSTEM_SHELL_USERS" | while read line; do
    info "  $line"
done

# Check sudoers for dangerous configurations
if grep -qE "NOPASSWD|ALL.*ALL" /etc/sudoers 2>/dev/null; then
    finding "Dangerous sudoers entries found (NOPASSWD or ALL ALL)"
    grep -E "NOPASSWD|ALL.*ALL" /etc/sudoers 2>/dev/null | while read line; do
        info "  $line"
    done
fi

# ──────────────────────────────────────────────────────
header "FILE SYSTEM SECURITY"
# ──────────────────────────────────────────────────────

# SUID binaries (potential privilege escalation)
info "SUID binaries (potential privesc vectors):"
find / -perm -4000 -type f 2>/dev/null | while read file; do
    # Check against known exploitable SUID binaries
    basename=$(basename "$file")
    case "$basename" in
        nmap|vim|find|bash|sh|dash|python*|perl|ruby|node|php|env|awk|less|more|nano|cp|mv)
            finding "Exploitable SUID binary: $file"
            ;;
        *)
            info "  $file"
            ;;
    esac
done

# SGID binaries
info "\nSGID binaries:"
find / -perm -2000 -type f 2>/dev/null | head -20 | while read file; do
    info "  $file"
done

# World-writable files (excluding /tmp, /proc, /sys)
WORLD_WRITE=$(find / -xdev -type f -perm -0002 ! -path "/proc/*" ! -path "/sys/*" ! -path "/tmp/*" 2>/dev/null)
if [ ! -z "$WORLD_WRITE" ]; then
    finding "World-writable files found:"
    echo "$WORLD_WRITE" | head -20 | while read file; do
        info "  $file"
    done
fi

# Files with no owner
NO_OWNER=$(find / -xdev -nouser -o -nogroup 2>/dev/null | head -10)
if [ ! -z "$NO_OWNER" ]; then
    finding "Files with no owner/group:"
    echo "$NO_OWNER" | while read file; do
        info "  $file"
    done
fi

# Check /etc/passwd and /etc/shadow permissions
PASSWD_PERMS=$(stat -c "%a" /etc/passwd)
SHADOW_PERMS=$(stat -c "%a" /etc/shadow 2>/dev/null)

if [ "$PASSWD_PERMS" != "644" ]; then
    finding "/etc/passwd has unusual permissions: $PASSWD_PERMS (expected 644)"
fi
if [ "$SHADOW_PERMS" != "640" ] && [ "$SHADOW_PERMS" != "600" ]; then
    finding "/etc/shadow has unusual permissions: $SHADOW_PERMS (expected 640 or 600)"
fi

# ──────────────────────────────────────────────────────
header "NETWORK SECURITY"
# ──────────────────────────────────────────────────────

# Open ports and listening services
info "Listening services:"
ss -tulnp 2>/dev/null | grep LISTEN | while read line; do
    info "  $line"
done

# Check for common dangerous services
for port in 21 23 69 111 512 513 514 2049; do
    if ss -tulnp 2>/dev/null | grep -q ":$port "; then
        finding "Potentially dangerous service on port $port"
    fi
done

# Check firewall status
if command -v ufw &>/dev/null; then
    UFW_STATUS=$(ufw status 2>/dev/null | head -1)
    if echo "$UFW_STATUS" | grep -q "inactive"; then
        finding "UFW firewall is INACTIVE"
    else
        ok "UFW firewall is active"
    fi
elif command -v iptables &>/dev/null; then
    RULES=$(iptables -L -n 2>/dev/null | grep -c "^[A-Z]")
    if [ "$RULES" -le 3 ]; then
        finding "iptables has no custom rules (only default chains)"
    else
        ok "iptables has custom rules configured"
    fi
fi

# Check for SSH configuration issues
if [ -f /etc/ssh/sshd_config ]; then
    info "\nSSH Security Configuration:"
    
    if grep -qE "^PermitRootLogin\s+yes" /etc/ssh/sshd_config; then
        finding "SSH: Root login permitted"
    else
        ok "SSH: Root login disabled or restricted"
    fi
    
    if grep -qE "^PasswordAuthentication\s+yes" /etc/ssh/sshd_config; then
        finding "SSH: Password authentication enabled (consider key-based only)"
    fi
    
    if ! grep -qE "^Protocol\s+2" /etc/ssh/sshd_config 2>/dev/null; then
        # Modern SSH defaults to 2, but check anyway
        info "SSH: Protocol version not explicitly set (likely defaulting to 2)"
    fi
fi

# ──────────────────────────────────────────────────────
header "CRON JOBS & SCHEDULED TASKS"
# ──────────────────────────────────────────────────────

# System cron
info "System crontab:"
cat /etc/crontab 2>/dev/null | grep -v "^#" | grep -v "^$" | while read line; do
    info "  $line"
done

# User crons
info "\nUser crontabs:"
for user in $(cut -f1 -d: /etc/passwd); do
    cron=$(crontab -l -u "$user" 2>/dev/null)
    if [ ! -z "$cron" ]; then
        info "  [$user]:"
        echo "$cron" | grep -v "^#" | while read line; do
            info "    $line"
        done
    fi
done

# Check for writable cron scripts
find /etc/cron* -type f 2>/dev/null | while read file; do
    if [ -w "$file" ]; then
        finding "Writable cron file: $file"
    fi
done

# ──────────────────────────────────────────────────────
header "RUNNING PROCESSES & SERVICES"
# ──────────────────────────────────────────────────────

# Check for processes running as root that shouldn't be
info "Processes running as root:"
ps aux | grep "^root" | grep -vE "(kernel|init|systemd|sshd|cron|agetty)" | head -20 | while read line; do
    info "  $line"
done

# Check for processes with suspicious names
SUSPICIOUS=$(ps aux | grep -iE "(nc |ncat|netcat|meterpreter|reverse|bind.*shell|crypto.*mine)" | grep -v grep)
if [ ! -z "$SUSPICIOUS" ]; then
    finding "Suspicious processes detected:"
    echo "$SUSPICIOUS" | while read line; do
        finding "  $line"
    done
fi

# ──────────────────────────────────────────────────────
header "AUDIT SUMMARY"
# ──────────────────────────────────────────────────────

FINDINGS_COUNT=$(grep -c "\[!\] FINDING" "$REPORT_FILE" 2>/dev/null)
info "Total findings: $FINDINGS_COUNT"
info "Report saved to: $REPORT_FILE"

if [ "$FINDINGS_COUNT" -gt 10 ]; then
    log "\n${RED}⚠️  HIGH NUMBER OF SECURITY FINDINGS - IMMEDIATE ACTION RECOMMENDED${NC}"
elif [ "$FINDINGS_COUNT" -gt 5 ]; then
    log "\n${YELLOW}⚠️  MODERATE SECURITY FINDINGS - ACTION RECOMMENDED${NC}"
else
    log "\n${GREEN}✓ System appears reasonably secure${NC}"
fi
```

---

## PowerShell for Security

### Windows Security Audit Script

```powershell
<#
.SYNOPSIS
    Windows Security Audit Script
.DESCRIPTION
    Performs comprehensive security checks on Windows systems.
    Checks: Users, Services, Firewall, Patches, Scheduled Tasks, 
    Registry, Network, Processes, and more.
.NOTES
    Run as Administrator for complete results.
#>

$Report = @()
$Findings = 0

function Write-Finding {
    param([string]$Message, [string]$Severity = "Medium")
    $script:Findings++
    Write-Host "[$Severity] $Message" -ForegroundColor $(
        switch($Severity) {
            "Critical" { "Red" }
            "High" { "DarkRed" }
            "Medium" { "Yellow" }
            "Low" { "Cyan" }
        }
    )
    $script:Report += "[$Severity] $Message"
}

function Write-OK {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════
Write-Host "`n═══ WINDOWS SECURITY AUDIT ═══" -ForegroundColor Cyan
Write-Host "Hostname: $env:COMPUTERNAME"
Write-Host "User: $env:USERNAME"
Write-Host "Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n"

# ──────────────────────────────────────────────────────
# USER ACCOUNT SECURITY
# ──────────────────────────────────────────────────────
Write-Host "`n[*] Checking User Accounts..." -ForegroundColor Yellow

# Check for local admin accounts
$Admins = Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue
if ($Admins.Count -gt 2) {
    Write-Finding "Multiple local admin accounts: $($Admins.Count)" "Medium"
    $Admins | ForEach-Object { Write-Host "    - $($_.Name)" }
}

# Check for disabled guest account
$Guest = Get-LocalUser -Name "Guest" -ErrorAction SilentlyContinue
if ($Guest -and $Guest.Enabled) {
    Write-Finding "Guest account is ENABLED" "High"
} else {
    Write-OK "Guest account is disabled"
}

# Check password policy
$PassPolicy = net accounts 2>$null
$MinLength = ($PassPolicy | Select-String "Minimum password length").ToString() -replace '\D+',''
if ([int]$MinLength -lt 8) {
    Write-Finding "Minimum password length is $MinLength (should be >= 12)" "High"
}

# ──────────────────────────────────────────────────────
# SERVICES SECURITY
# ──────────────────────────────────────────────────────
Write-Host "`n[*] Checking Services..." -ForegroundColor Yellow

# Unquoted service paths (privilege escalation vector)
$Services = Get-WmiObject Win32_Service | Where-Object {
    $_.PathName -notmatch '^"' -and 
    $_.PathName -match ' ' -and
    $_.PathName -notmatch 'system32'
}
foreach ($svc in $Services) {
    Write-Finding "Unquoted service path: $($svc.Name) - $($svc.PathName)" "High"
}

# Services running as LocalSystem that shouldn't
$HighPrivServices = Get-WmiObject Win32_Service | Where-Object {
    $_.StartName -eq "LocalSystem" -and
    $_.State -eq "Running" -and
    $_.Name -notmatch "(wuauserv|Winmgmt|BITS|Spooler|Themes|Schedule|EventLog)"
}

# ──────────────────────────────────────────────────────
# FIREWALL STATUS
# ──────────────────────────────────────────────────────
Write-Host "`n[*] Checking Firewall..." -ForegroundColor Yellow

$FWProfiles = Get-NetFirewallProfile
foreach ($profile in $FWProfiles) {
    if (-not $profile.Enabled) {
        Write-Finding "Firewall profile '$($profile.Name)' is DISABLED" "Critical"
    } else {
        Write-OK "Firewall profile '$($profile.Name)' is enabled"
    }
}

# ──────────────────────────────────────────────────────
# WINDOWS UPDATE / PATCHES
# ──────────────────────────────────────────────────────
Write-Host "`n[*] Checking Windows Updates..." -ForegroundColor Yellow

$LastUpdate = Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 1
if ($LastUpdate) {
    $DaysSinceUpdate = (New-TimeSpan -Start $LastUpdate.InstalledOn -End (Get-Date)).Days
    if ($DaysSinceUpdate -gt 30) {
        Write-Finding "Last patch installed $DaysSinceUpdate days ago" "High"
    } else {
        Write-OK "System patched within last $DaysSinceUpdate days"
    }
}

# ──────────────────────────────────────────────────────
# NETWORK SECURITY
# ──────────────────────────────────────────────────────
Write-Host "`n[*] Checking Network..." -ForegroundColor Yellow

# Open ports
$Listeners = Get-NetTCPConnection -State Listen | 
    Select-Object LocalAddress, LocalPort, OwningProcess |
    Sort-Object LocalPort

Write-Host "  Listening ports:"
foreach ($listener in $Listeners) {
    $ProcessName = (Get-Process -Id $listener.OwningProcess -ErrorAction SilentlyContinue).ProcessName
    Write-Host "    $($listener.LocalAddress):$($listener.LocalPort) - $ProcessName"
}

# Check for RDP enabled
$RDP = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -ErrorAction SilentlyContinue
if ($RDP.fDenyTSConnections -eq 0) {
    Write-Finding "RDP is enabled" "Medium"
    # Check if NLA is required
    $NLA = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -ErrorAction SilentlyContinue
    if ($NLA.UserAuthentication -ne 1) {
        Write-Finding "RDP Network Level Authentication (NLA) not required" "High"
    }
}

# ──────────────────────────────────────────────────────
# SUMMARY
# ──────────────────────────────────────────────────────
Write-Host "`n═══ AUDIT COMPLETE ═══" -ForegroundColor Cyan
Write-Host "Total Findings: $Findings" -ForegroundColor $(if($Findings -gt 5){"Red"}else{"Yellow"})
```

---

## Reconnaissance Automation

### Complete Automated Recon Framework

```python
#!/usr/bin/env python3
"""
Automated Reconnaissance Framework
Chains: Subdomain Enum → Resolution → HTTP Probe → 
        URL Collection → Vulnerability Scan → Report
"""

import subprocess
import json
import os
from pathlib import Path
from datetime import datetime
from dataclasses import dataclass
from typing import List, Optional
import shutil

@dataclass
class ReconConfig:
    """Configuration for reconnaissance."""
    domain: str
    output_dir: str
    threads: int = 50
    resolvers_file: str = "resolvers.txt"
    wordlist: str = "/usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt"
    nuclei_severity: str = "critical,high,medium"
    skip_brute: bool = False
    notify: bool = False

class ReconFramework:
    """
    Modular reconnaissance automation framework.
    
    Phases:
    1. Subdomain Enumeration (passive + active)
    2. DNS Resolution & Filtering
    3. HTTP Probing (alive detection)
    4. URL Collection (historical + crawling)
    5. Vulnerability Scanning
    6. Report Generation
    """
    
    def __init__(self, config: ReconConfig):
        self.config = config
        self.output = Path(config.output_dir)
        self.output.mkdir(parents=True, exist_ok=True)
        
        # Create subdirectories
        for subdir in ['subdomains', 'urls', 'vulns', 'reports']:
            (self.output / subdir).mkdir(exist_ok=True)
        
        self.stats = {
            'subdomains_found': 0,
            'resolved': 0,
            'alive': 0,
            'urls_collected': 0,
            'vulns_found': 0
        }
    
    def run_tool(self, cmd: List[str], description: str) -> Optional[str]:
        """Run an external tool and capture output."""
        tool_name = cmd[0]
        if not shutil.which(tool_name):
            print(f"  [!] Tool not found: {tool_name}, skipping...")
            return None
        
        print(f"  [+] {description}")
        try:
            result = subprocess.run(
                cmd, capture_output=True, text=True, timeout=600
            )
            return result.stdout
        except subprocess.TimeoutExpired:
            print(f"  [!] {tool_name} timed out")
            return None
        except Exception as e:
            print(f"  [!] Error running {tool_name}: {e}")
            return None
    
    def phase1_subdomain_enum(self):
        """Phase 1: Discover subdomains from multiple sources."""
        print(f"\n{'='*50}")
        print(f"PHASE 1: SUBDOMAIN ENUMERATION")
        print(f"{'='*50}")
        
        subs_dir = self.output / 'subdomains'
        
        # subfinder
        self.run_tool(
            ['subfinder', '-d', self.config.domain, '-all', '-silent',
             '-o', str(subs_dir / 'subfinder.txt')],
            "Running subfinder (passive)..."
        )
        
        # amass passive
        self.run_tool(
            ['amass', 'enum', '-passive', '-d', self.config.domain,
             '-o', str(subs_dir / 'amass.txt')],
            "Running amass (passive)..."
        )
        
        # assetfinder
        output = self.run_tool(
            ['assetfinder', '--subs-only', self.config.domain],
            "Running assetfinder..."
        )
        if output:
            with open(subs_dir / 'assetfinder.txt', 'w') as f:
                f.write(output)
        
        # Combine all results
        all_subs = set()
        for subfile in subs_dir.glob('*.txt'):
            if subfile.name != 'all.txt':
                with open(subfile) as f:
                    all_subs.update(line.strip() for line in f if line.strip())
        
        with open(subs_dir / 'all.txt', 'w') as f:
            f.write('\n'.join(sorted(all_subs)))
        
        self.stats['subdomains_found'] = len(all_subs)
        print(f"  [✓] Total unique subdomains: {len(all_subs)}")
    
    def phase2_resolution(self):
        """Phase 2: Resolve subdomains and filter alive."""
        print(f"\n{'='*50}")
        print(f"PHASE 2: DNS RESOLUTION")
        print(f"{'='*50}")
        
        subs_file = self.output / 'subdomains' / 'all.txt'
        resolved_file = self.output / 'subdomains' / 'resolved.txt'
        
        self.run_tool(
            ['puredns', 'resolve', str(subs_file),
             '-r', self.config.resolvers_file,
             '-w', str(resolved_file)],
            "Resolving subdomains..."
        )
        
        if resolved_file.exists():
            self.stats['resolved'] = sum(1 for _ in open(resolved_file))
            print(f"  [✓] Resolved: {self.stats['resolved']}")
    
    def phase3_http_probe(self):
        """Phase 3: Find alive web servers."""
        print(f"\n{'='*50}")
        print(f"PHASE 3: HTTP PROBING")
        print(f"{'='*50}")
        
        resolved_file = self.output / 'subdomains' / 'resolved.txt'
        alive_file = self.output / 'subdomains' / 'alive.txt'
        
        self.run_tool(
            ['httpx', '-l', str(resolved_file),
             '-o', str(alive_file),
             '-status-code', '-title', '-tech-detect',
             '-follow-redirects', '-threads', str(self.config.threads),
             '-silent'],
            "Probing HTTP services..."
        )
        
        if alive_file.exists():
            self.stats['alive'] = sum(1 for _ in open(alive_file))
            print(f"  [✓] Alive web servers: {self.stats['alive']}")
    
    def phase4_url_collection(self):
        """Phase 4: Collect URLs from multiple sources."""
        print(f"\n{'='*50}")
        print(f"PHASE 4: URL COLLECTION")
        print(f"{'='*50}")
        
        resolved_file = self.output / 'subdomains' / 'resolved.txt'
        urls_dir = self.output / 'urls'
        
        # gau
        if resolved_file.exists():
            output = self.run_tool(
                ['gau', '--threads', '5', '--subs'],
                "Running gau (historical URLs)..."
            )
            # gau reads from stdin, so we use subprocess differently
            try:
                with open(resolved_file) as f:
                    domains = f.read()
                result = subprocess.run(
                    ['gau', '--threads', '5'],
                    input=domains, capture_output=True, text=True, timeout=300
                )
                if result.stdout:
                    with open(urls_dir / 'gau.txt', 'w') as f:
                        f.write(result.stdout)
            except Exception:
                pass
        
        # Combine URLs
        all_urls = set()
        for urlfile in urls_dir.glob('*.txt'):
            if urlfile.name != 'all.txt':
                with open(urlfile) as f:
                    all_urls.update(line.strip() for line in f if line.strip())
        
        with open(urls_dir / 'all.txt', 'w') as f:
            f.write('\n'.join(sorted(all_urls)))
        
        self.stats['urls_collected'] = len(all_urls)
        print(f"  [✓] URLs collected: {len(all_urls)}")
    
    def phase5_vulnerability_scan(self):
        """Phase 5: Run nuclei vulnerability scanner."""
        print(f"\n{'='*50}")
        print(f"PHASE 5: VULNERABILITY SCANNING")
        print(f"{'='*50}")
        
        alive_file = self.output / 'subdomains' / 'alive.txt'
        vulns_file = self.output / 'vulns' / 'nuclei.txt'
        
        if alive_file.exists():
            # Extract URLs only (remove metadata from httpx output)
            urls_only = self.output / 'subdomains' / 'alive_urls_only.txt'
            with open(alive_file) as f:
                urls = [line.split()[0] for line in f if line.strip()]
            with open(urls_only, 'w') as f:
                f.write('\n'.join(urls))
            
            self.run_tool(
                ['nuclei', '-l', str(urls_only),
                 '-severity', self.config.nuclei_severity,
                 '-o', str(vulns_file),
                 '-silent'],
                f"Running nuclei (severity: {self.config.nuclei_severity})..."
            )
            
            if vulns_file.exists():
                self.stats['vulns_found'] = sum(1 for _ in open(vulns_file))
                print(f"  [✓] Vulnerabilities found: {self.stats['vulns_found']}")
    
    def generate_report(self):
        """Generate final reconnaissance report."""
        print(f"\n{'='*50}")
        print(f"GENERATING REPORT")
        print(f"{'='*50}")
        
        report = {
            'domain': self.config.domain,
            'timestamp': datetime.now().isoformat(),
            'statistics': self.stats,
            'output_directory': str(self.output)
        }
        
        report_file = self.output / 'reports' / 'summary.json'
        with open(report_file, 'w') as f:
            json.dump(report, f, indent=2)
        
        # Human-readable summary
        summary = f"""
╔══════════════════════════════════════════════════╗
║          RECONNAISSANCE COMPLETE                 ║
╠══════════════════════════════════════════════════╣
║ Target:        {self.config.domain:<30}  ║
║ Subdomains:    {self.stats['subdomains_found']:<30}  ║
║ Resolved:      {self.stats['resolved']:<30}  ║
║ Alive (HTTP):  {self.stats['alive']:<30}  ║
║ URLs Found:    {self.stats['urls_collected']:<30}  ║
║ Vulnerabilities: {self.stats['vulns_found']:<28}  ║
╠══════════════════════════════════════════════════╣
║ Output: {str(self.output):<38}  ║
╚══════════════════════════════════════════════════╝
"""
        print(summary)
        
        with open(self.output / 'reports' / 'summary.txt', 'w') as f:
            f.write(summary)
    
    def run(self):
        """Execute full reconnaissance pipeline."""
        start_time = datetime.now()
        
        self.phase1_subdomain_enum()
        self.phase2_resolution()
        self.phase3_http_probe()
        self.phase4_url_collection()
        self.phase5_vulnerability_scan()
        self.generate_report()
        
        elapsed = (datetime.now() - start_time).total_seconds()
        print(f"\nTotal time: {elapsed:.0f} seconds ({elapsed/60:.1f} minutes)")


if __name__ == "__main__":
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python3 recon.py <domain> [output_dir]")
        sys.exit(1)
    
    domain = sys.argv[1]
    output_dir = sys.argv[2] if len(sys.argv) > 2 else f"recon_{domain}_{datetime.now().strftime('%Y%m%d')}"
    
    config = ReconConfig(domain=domain, output_dir=output_dir)
    framework = ReconFramework(config)
    framework.run()
```

---

## Labs & Exercises

### Beginner Labs

```
Lab 1: Python Port Scanner
- Build a TCP connect scanner from scratch
- Add banner grabbing
- Add threading for speed
- Output results in JSON format
- Time: 2-3 hours

Lab 2: Bash Log Parser
- Parse Apache access logs
- Count requests per IP
- Find IPs with most 404 errors
- Detect potential scanners
- Time: 1-2 hours

Lab 3: Password Strength Checker
- Check length, complexity, common passwords
- Integrate with HaveIBeenPwned API (k-anonymity)
- Provide strength score and suggestions
- Time: 1-2 hours
```

### Intermediate Labs

```
Lab 4: Web Vulnerability Scanner
- Implement the framework from this section
- Add XSS detection
- Add SQL injection detection
- Generate HTML report
- Time: 6-8 hours

Lab 5: Automated Recon Pipeline
- Chain subdomain enumeration tools
- Automate URL collection
- Run nuclei scans
- Generate comprehensive report
- Time: 4-6 hours

Lab 6: Log Analysis SIEM (Lite)
- Parse multiple log formats
- Correlate events across sources
- Detect attack patterns
- Alert on thresholds
- Time: 6-8 hours
```

### Advanced Labs

```
Lab 7: Custom C2 Communication Framework
- Build encrypted client-server communication
- Implement task queuing
- Add file transfer capability
- (FOR EDUCATIONAL PURPOSES IN LAB ONLY)
- Time: 10-15 hours

Lab 8: Automated Incident Response
- Monitor for IOCs in real-time
- Auto-isolate compromised hosts
- Collect forensic evidence
- Generate incident timeline
- Time: 8-12 hours

Lab 9: Full Enterprise Security Automation
- Asset discovery + inventory
- Vulnerability scanning + tracking
- Compliance checking
- Alert enrichment + triage
- Dashboard generation
- Time: 20+ hours
```

---

## Interview Questions

```
Q: How would you automate the process of checking if a list of IPs 
   are malicious?
A: Write a script that queries multiple threat intelligence APIs
   (VirusTotal, AbuseIPDB, OTX) concurrently for each IP, aggregates
   results, and scores based on detection count and source reliability.
   Use async I/O for performance with rate limiting per API.

Q: What's the difference between threading and async for security tools?
A: Threading: Good for I/O-bound tasks (network scanning), limited by GIL
   for CPU tasks. Async: Better for high-concurrency I/O (thousands of
   connections), single-threaded event loop, more efficient memory usage.
   Use async for scanners, threading for mixed CPU/IO workloads.

Q: How would you design an automated alert triage system?
A: Ingest alerts from SIEM → Enrich with context (asset info, threat 
   intel, historical alerts) → Score based on rules (known IOCs, asset
   criticality, attack pattern) → Route based on severity → Auto-close
   known false positives → Create tickets for genuine alerts with 
   pre-populated investigation data.

Q: What security considerations apply when writing automation scripts?
A: Secure credential storage (not hardcoded), input validation,
   rate limiting (don't DoS targets), logging without sensitive data,
   error handling (don't expose internals), least privilege execution,
   code review for injection vulnerabilities in the script itself.
```

---

**Next:** → [21-Security-Projects](../21-Security-Projects/README.md)

*"The best security professionals don't just use tools — they build them. Automation is your force multiplier."*
