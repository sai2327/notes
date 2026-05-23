# 🗺️ Career Roadmap

## From Zero to Cybersecurity Professional — Your Complete Path

---

## Table of Contents

1. [Career Paths in Cybersecurity](#career-paths-in-cybersecurity)
2. [Complete Beginner Roadmap](#complete-beginner-roadmap)
3. [SOC Analyst Path](#soc-analyst-path)
4. [Penetration Tester Path](#penetration-tester-path)
5. [Security Engineer Path](#security-engineer-path)
6. [Cloud Security Path](#cloud-security-path)
7. [Resume Building](#resume-building)
8. [GitHub Profile Optimization](#github-profile-optimization)
9. [LinkedIn Strategy](#linkedin-strategy)
10. [Networking & Community](#networking--community)
11. [Job Search Strategy](#job-search-strategy)
12. [First 90 Days on the Job](#first-90-days-on-the-job)

---

## Career Paths in Cybersecurity

```
CYBERSECURITY CAREER MAP
═════════════════════════

                    ┌─────────────────────┐
                    │       CISO          │
                    │  (Chief Information │
                    │  Security Officer)  │
                    └──────────┬──────────┘
                               │
            ┌──────────────────┼──────────────────┐
            │                  │                  │
   ┌────────▼────────┐ ┌──────▼───────┐ ┌───────▼───────┐
   │  Security       │ │   Security   │ │   Security    │
   │  Architecture   │ │  Management  │ │  Engineering  │
   │  & Research     │ │  & GRC       │ │  & Operations │
   └────────┬────────┘ └──────┬───────┘ └───────┬───────┘
            │                  │                  │
   ┌────────▼────────┐ ┌──────▼───────┐ ┌───────▼───────┐
   │ Security        │ │ Risk/        │ │ SOC Manager   │
   │ Architect       │ │ Compliance   │ │ IR Manager    │
   │ Threat Research │ │ Manager      │ │ SecOps Lead   │
   └────────┬────────┘ └──────┬───────┘ └───────┬───────┘
            │                  │                  │
   ┌────────▼────────┐ ┌──────▼───────┐ ┌───────▼───────┐
   │ Senior Pentest  │ │ GRC Analyst  │ │ Security      │
   │ Red Team Lead   │ │ Auditor      │ │ Engineer      │
   │ Exploit Dev     │ │              │ │ DevSecOps     │
   └────────┬────────┘ └──────┬───────┘ └───────┬───────┘
            │                  │                  │
   ┌────────▼────────┐ ┌──────▼───────┐ ┌───────▼───────┐
   │ Jr Pentester    │ │ Jr GRC       │ │ SOC Analyst   │
   │ Bug Bounty      │ │ Analyst      │ │ L1/L2         │
   └────────┬────────┘ └──────┬───────┘ └───────┬───────┘
            │                  │                  │
            └──────────────────┼──────────────────┘
                               │
                    ┌──────────▼──────────┐
                    │    ENTRY POINT      │
                    │ Help Desk / IT      │
                    │ Support / Student   │
                    └─────────────────────┘
```

### Role Comparison

```
Role                  | Skills Focus           | Avg Salary | Demand
──────────────────────────────────────────────────────────────────────
SOC Analyst L1        | Monitoring, triage     | $65K       | Very High
SOC Analyst L2        | Investigation, IR      | $90K       | High
Security Engineer     | Build security tools   | $130K      | Very High
Penetration Tester    | Break things legally   | $110K      | High
Cloud Security Eng.   | AWS/Azure/GCP security | $140K      | Very High
DevSecOps Engineer    | CI/CD + security       | $135K      | Very High
Threat Hunter         | Proactive detection    | $120K      | High
Malware Analyst       | Reverse engineering    | $115K      | Medium
GRC Analyst           | Compliance, risk       | $90K       | High
Security Architect    | Design secure systems  | $160K      | High
CISO                  | Strategy, leadership   | $250K+     | Medium
```

---

## Complete Beginner Roadmap

### Month 1-2: Foundations

```
Week 1-2: Networking Fundamentals
├── TCP/IP model (all 4 layers, deep understanding)
├── OSI model (7 layers, when to reference each)
├── IP addressing and subnetting
├── Common protocols (HTTP, DNS, SMTP, FTP, SSH)
├── Routing and switching basics
├── Practice: Set up home network, packet capture with Wireshark
└── Resource: CompTIA Network+ material (free: Professor Messer)

Week 3-4: Operating Systems
├── Linux fundamentals:
│   ├── File system navigation
│   ├── Users and permissions
│   ├── Process management
│   ├── Package management
│   ├── Network commands
│   ├── Service management (systemd)
│   └── Practice: Install Ubuntu, live in terminal for 2 weeks
├── Windows fundamentals:
│   ├── Active Directory basics
│   ├── Group Policy
│   ├── Windows Event Logs
│   ├── PowerShell basics
│   ├── Registry
│   └── Practice: Set up Windows Server VM
└── Resource: TryHackMe Linux/Windows fundamentals rooms

Week 5-6: Security Fundamentals
├── CIA Triad deep understanding
├── Authentication vs. Authorization
├── Encryption basics (symmetric/asymmetric)
├── Hashing and integrity
├── Common attack types overview
├── Security controls (preventive, detective, corrective)
├── Practice: Secure a Linux server (SSH hardening, firewall, updates)
└── Resource: CompTIA Security+ objectives

Week 7-8: Programming/Scripting
├── Python basics:
│   ├── Variables, data types, control flow
│   ├── Functions and modules
│   ├── File handling
│   ├── Network programming (sockets)
│   ├── HTTP requests (requests library)
│   └── Practice: Build simple port scanner
├── Bash basics:
│   ├── Variables and loops
│   ├── File operations
│   ├── Text processing (grep, awk, sed)
│   └── Practice: Write log analysis script
└── Resource: Automate the Boring Stuff with Python (free online)
```

### Month 3-4: Core Security Skills

```
Week 9-10: Network Security
├── Firewalls (iptables, UFW, Windows Firewall)
├── IDS/IPS concepts (Snort, Suricata)
├── VPN technologies
├── Network segmentation
├── Proxy servers and WAFs
├── Practice: Configure firewall rules, set up Snort
└── Lab: TryHackMe Network Security rooms

Week 11-12: Web Application Security
├── OWASP Top 10 (understand each vulnerability)
├── SQL Injection (manual + automated)
├── XSS (reflected, stored, DOM)
├── Authentication attacks
├── Burp Suite usage
├── Practice: DVWA, WebGoat, PortSwigger Academy
└── Lab: Complete 20+ PortSwigger labs

Week 13-14: System Security
├── Vulnerability assessment process
├── Patch management
├── Hardening (CIS Benchmarks)
├── Malware types and behavior
├── Log analysis basics
├── Practice: Harden a system to CIS benchmark
└── Lab: Vulnerability scan with Nessus/OpenVAS

Week 15-16: Practical Application
├── Set up home lab (see Section 28)
├── Complete first CTF challenges
├── Start TryHackMe learning paths
├── Begin CompTIA Security+ study
├── Build first security project (port scanner)
└── Start daily practice routine
```

### Month 5-6: Specialization Begins

```
Choose your path and deep-dive (see specific paths below)

Regardless of path, complete:
├── CompTIA Security+ certification
├── 2-3 security projects on GitHub
├── 50+ TryHackMe/HTB rooms completed
├── Participate in 1 CTF competition
├── Active LinkedIn with security content
├── Join 2-3 security communities
└── Begin applying for entry-level positions
```

---

## SOC Analyst Path

```
Phase 1: Foundation (Months 1-3)
├── Security+ certification
├── SIEM basics (Splunk free tier or ELK stack)
├── Log analysis fundamentals
├── Network traffic analysis (Wireshark)
├── Alert triage concepts
└── Build: Home SIEM lab (Section 21)

Phase 2: Core Skills (Months 4-6)
├── Advanced SIEM (queries, dashboards, alerts)
├── Incident response process
├── Threat intelligence fundamentals
├── Windows event log analysis
├── Email security analysis
├── Practice: TryHackMe SOC Level 1 path
└── Certification: CySA+ or BTL1

Phase 3: Advanced (Months 7-9)
├── Threat hunting
├── Malware triage (basic analysis)
├── SOAR platform usage
├── Detection engineering (write SIEM rules)
├── Digital forensics basics
└── Practice: Boss of the SOC (BOTS) challenges

Phase 4: Job Ready (Months 10-12)
├── Apply to SOC Analyst L1 positions
├── Portfolio: SIEM project, detection rules, write-ups
├── Practice interviews (technical + scenario)
├── Network at local security meetups
└── Consider: Splunk Core Certified User
```

---

## Penetration Tester Path

```
Phase 1: Foundation (Months 1-3)
├── Networking deep knowledge
├── Linux mastery (Kali-focused)
├── Python scripting
├── Web app security basics
├── Tool familiarity (Nmap, Burp, Metasploit)
└── Practice: TryHackMe Complete Beginner path

Phase 2: Core Skills (Months 4-6)
├── eJPT certification
├── Web application attacks (deep)
├── Network exploitation
├── Privilege escalation (Windows + Linux)
├── Active Directory attacks (introductory)
├── Practice: 3 HTB machines per week
└── Build: Vulnerability scanner project

Phase 3: Advanced (Months 7-12)
├── PNPT certification
├── Active Directory full attack chain
├── Advanced web attacks (SSRF, deserialization)
├── Buffer overflow basics
├── Report writing mastery
├── Pivoting and tunneling
├── Practice: 5+ HTB machines per week
└── Start: Bug bounty (apply to programs)

Phase 4: Professional (Months 12-18)
├── OSCP certification (or equivalent)
├── Specialized topics (cloud, mobile, IoT)
├── Professional report portfolio
├── Bug bounty successes
├── Network with pentest community
└── Apply: Jr Pentester / Security Consultant
```

---

## Resume Building

### Resume Template for Cybersecurity

```
YOUR NAME
City, State | email@example.com | linkedin.com/in/yourname | github.com/yourname

════════════════════════════════════════════════════════════════

SUMMARY
───────
Security professional with [X] years of experience in [specific area].
Proven ability to [key achievement]. Skilled in [top 3-4 skills].
Certified in [relevant certifications].

EXPERIENCE
──────────
[Job Title] | [Company] | [Date Range]
• [Action verb] + [what you did] + [measurable result]
• "Reduced mean time to detect (MTTD) from 45 minutes to 8 minutes 
   by implementing automated alert enrichment playbooks"
• "Identified and remediated 15 critical vulnerabilities across 
   200+ hosts during quarterly vulnerability assessment cycle"
• "Developed Python automation saving 20 hours/week in manual 
   log review, increasing alert coverage by 300%"

PROJECTS
────────
Home SIEM Lab | github.com/yourname/siem-lab
• Built production-quality SIEM with Wazuh/ELK ingesting logs 
  from 5 sources, created 12 custom detection rules, detected 
  simulated attacks with <30 second MTTD

Custom Vulnerability Scanner | github.com/yourname/vuln-scanner
• Developed modular Python scanner with 8 detection plugins,
  tested against OWASP WebGoat with 95% detection rate

CERTIFICATIONS
──────────────
• CompTIA Security+ (SY0-701) | 2024
• eLearnSecurity Junior Penetration Tester (eJPT) | 2024
• [Additional certs]

SKILLS
──────
Tools: Splunk, Wireshark, Nmap, Burp Suite, Metasploit, Nessus
Languages: Python, Bash, PowerShell, SQL
Platforms: Linux (Ubuntu, Kali), Windows Server, AWS
Concepts: Incident Response, Threat Hunting, Vulnerability Management

EDUCATION
─────────
[Degree] | [University] | [Year]
Relevant coursework: Network Security, Cryptography, Digital Forensics
```

### Resume Power Words for Security

```
Action Verbs:
Detected, Identified, Mitigated, Remediated, Investigated,
Analyzed, Automated, Implemented, Developed, Architected,
Secured, Hardened, Monitored, Responded, Contained,
Engineered, Configured, Deployed, Documented, Led

Quantification Examples:
- "Reduced false positive rate by 40% through SIEM rule tuning"
- "Managed vulnerability remediation across 500+ endpoints"
- "Processed 200+ security alerts daily with 99.5% accuracy"
- "Decreased incident response time from 4 hours to 45 minutes"
- "Authored 30+ incident reports with zero quality escalations"
```

---

## GitHub Profile Optimization

### What Security Recruiters Look For

```
Profile Elements:
├── Professional photo and bio
├── Pinned repositories (best 6 projects)
├── Contribution graph (consistent green squares)
├── README.md on profile (personal introduction)
├── Clean, documented repositories
└── Recent activity (within last 30 days)

Repository Best Practices:
├── Clear README with:
│   ├── What it does
│   ├── How to install/use
│   ├── Screenshots or demo
│   ├── Technologies used
│   └── What you learned
├── Organized code structure
├── Meaningful commit messages
├── Issues/project boards (shows planning)
└── License file
```

### Example GitHub Profile README

```markdown
# 👋 Hi, I'm [Your Name]

## 🔒 Aspiring Security Professional

I'm passionate about cybersecurity, focusing on [blue team/red team/both].
Currently building tools and completing challenges to break into the industry.

### 🛠️ Current Projects
- 🏠 [Home SIEM Lab](link) - Wazuh deployment with custom detection rules
- 🔍 [Vuln Scanner](link) - Python web vulnerability scanner
- 📝 [Security Notes](link) - My cybersecurity learning journey

### 📊 Stats
- 🏆 50+ TryHackMe rooms completed
- 🐛 3 accepted bug bounty reports
- 📜 CompTIA Security+ certified
- 🎯 Top 5% on HackTheBox

### 🌱 Currently Learning
- Active Directory attack chains
- Cloud security (AWS)
- Malware analysis

### 📫 Connect
- [LinkedIn](link) | [Blog](link) | [TryHackMe](link)
```

---

## LinkedIn Strategy

```
Profile Optimization:
├── Headline: "Cybersecurity [Role] | [Cert] | [Specialty]"
│   Example: "SOC Analyst | Security+ | Threat Detection & IR"
├── Banner: Professional security-related image
├── About: 3 paragraphs (passion + skills + what you're seeking)
├── Experience: Quantified achievements (same as resume)
├── Skills: Top 5 should be security-specific
├── Certifications: All listed with dates
├── Projects: Link to GitHub repos
└── Recommendations: Ask colleagues/mentors

Content Strategy (post 2-3x/week):
├── Share what you're learning (TIL posts)
├── Write about a security concept (teach others)
├── Share CTF writeups (shows practical skills)
├── Comment on industry news
├── Celebrate milestones (certs, projects, wins)
├── Share tools or resources you find useful
└── Engage with others' posts (build relationships)

Networking:
├── Connect with: Recruiters, hiring managers, team leads
├── Join groups: ISACA, ISC², local security groups
├── Follow companies you want to work for
├── Reach out to security professionals for coffee chats
└── Attend virtual events and engage in chat
```

---

## Job Search Strategy

```
Where to Find Security Jobs:
├── LinkedIn (most security jobs posted here)
├── Indeed / Glassdoor
├── InfoSec Jobs (infosec-jobs.com)
├── CyberSecJobs.com
├── Company career pages directly
├── Security conferences (many have job boards)
├── Recruiters (build relationships with 3-5)
└── Referrals (highest success rate by far)

Application Strategy:
├── Apply to 5-10 positions per week
├── Customize resume for each application
├── Write cover letter connecting YOUR skills to THEIR needs
├── Follow up after 1 week if no response
├── Track all applications in spreadsheet
├── Don't self-filter: Apply even if you meet 60% of requirements
└── Entry-level requiring "3 years experience" → still apply

Roles That Lead to Security:
(If you can't get direct security role immediately)
├── Help Desk / IT Support (foot in the door)
├── System Administrator (build infrastructure knowledge)
├── Network Administrator (networking depth)
├── Software Developer → AppSec
├── Cloud Engineer → Cloud Security
└── Any IT role + internal transfer to security team
```

---

## First 90 Days on the Job

```
Days 1-30: LEARN
├── Understand the environment (network diagram, tools, processes)
├── Meet everyone on the team
├── Read all documentation and playbooks
├── Shadow senior analysts/engineers
├── Ask questions (write them down, ask in batches)
├── Learn the SIEM/tools used daily
├── Understand escalation procedures
├── Study recent incidents (how team handled them)
└── DON'T: Try to change things or show off

Days 31-60: CONTRIBUTE
├── Handle basic tasks independently
├── Start taking ownership of specific areas
├── Identify small improvements you can make
├── Document things that aren't documented
├── Begin building automation for repetitive tasks
├── Participate in team discussions
├── Share knowledge from your learning
└── DON'T: Overcommit or take on too much

Days 61-90: ADD VALUE
├── Propose improvements with data backing
├── Take ownership of a project or initiative
├── Develop a specialty (become go-to for something)
├── Mentor newer team members
├── Create/improve runbooks and documentation
├── Present findings or learning to the team
├── Set goals for next quarter with manager
└── DON'T: Coast — this is when you establish your reputation
```

---

**Next:** → [25-Resources](../25-Resources/README.md)

*"Your career path is unique. There's no single right way — but there is consistent effort, continuous learning, and strategic positioning."*
