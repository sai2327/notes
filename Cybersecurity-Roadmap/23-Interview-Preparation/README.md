# 🎤 Interview Preparation

## Ace Every Cybersecurity Interview — Technical, Behavioral, and Scenario-Based

---

## Table of Contents

1. [Interview Process Overview](#interview-process-overview)
2. [HR/Recruiter Screening](#hrrecruiter-screening)
3. [Behavioral Questions (STAR Method)](#behavioral-questions)
4. [Technical Questions - Networking](#technical-questions---networking)
5. [Technical Questions - Security Concepts](#technical-questions---security-concepts)
6. [Technical Questions - Blue Team](#technical-questions---blue-team)
7. [Technical Questions - Red Team](#technical-questions---red-team)
8. [Scenario-Based Questions](#scenario-based-questions)
9. [Hands-On Assessments](#hands-on-assessments)
10. [Questions to Ask Interviewers](#questions-to-ask-interviewers)
11. [Salary Negotiation](#salary-negotiation)
12. [Common Mistakes to Avoid](#common-mistakes-to-avoid)

---

## Interview Process Overview

```
Typical Cybersecurity Interview Pipeline:
──────────────────────────────────────────

Stage 1: Resume Screen (HR/ATS)
├── Keywords matching (tools, certs, skills)
├── Experience requirements
├── Education requirements
└── Pass rate: ~20-30% of applicants

Stage 2: Recruiter Phone Screen (15-30 min)
├── Verify experience/qualifications
├── Salary expectations
├── Availability/location
├── Basic cultural fit
└── Pass rate: ~50% of screened candidates

Stage 3: Hiring Manager Interview (45-60 min)
├── Technical depth assessment
├── Scenario-based questions
├── Team fit evaluation
├── Experience deep-dive
└── Pass rate: ~30-50%

Stage 4: Technical Assessment (varies)
├── Hands-on lab challenge
├── Take-home assignment
├── Live coding/tool usage
├── Architecture whiteboarding
└── Pass rate: ~40-60%

Stage 5: Team/Panel Interview (60-90 min)
├── Multiple interviewers
├── Mix of technical + behavioral
├── Cultural fit assessment
├── Peer evaluation
└── Pass rate: ~50-70%

Stage 6: Final/Executive Interview
├── VP/Director level
├── Strategic thinking
├── Leadership potential
├── Final culture check
└── Pass rate: ~70-80%
```

---

## HR/Recruiter Screening

### Common Questions & Strong Answers

```
Q: Tell me about yourself.
────────────────────────────
Framework: Present → Past → Future (2 minutes max)

Strong answer:
"I'm currently a SOC Analyst at [Company] where I handle threat 
detection and incident response across 5,000 endpoints. Before 
that, I earned my Security+ and eJPT certifications while building 
home lab projects including a full SIEM deployment. I'm looking 
to move into a role where I can do more proactive threat hunting 
and use my skills in a larger, more complex environment like yours."

Why it works:
- Establishes current role immediately
- Mentions quantifiable scope
- Shows progression and initiative
- Connects to why you're interviewing there
```

```
Q: Why are you interested in cybersecurity?
─────────────────────────────────────────────
Strong answer:
"I've always been fascinated by the adversarial nature of security — 
it's the one field where you're solving puzzles against intelligent 
opponents. I got hooked when I set up my first home lab and caught a 
simulated attacker pivoting through my network. Since then, I've been 
practicing daily on platforms like HackTheBox and contributing to 
open-source security tools. The constant evolution of threats keeps 
me learning something new every day."

Why it works:
- Shows genuine passion (not just "good salary")
- Specific examples prove it's not lip service
- Demonstrates continuous learning mindset
```

```
Q: What are your salary expectations?
──────────────────────────────────────
Strategy:
1. Research market rate (Glassdoor, Levels.fyi, Payscale)
2. Give a range, not a specific number
3. Anchor high within reason
4. Consider total compensation

Strong answer:
"Based on my research of the market rate for this role and my 
qualifications, I'm looking for something in the $85,000-$100,000 
range, but I'm flexible depending on the total compensation package 
including benefits, bonus, and professional development budget."
```

---

## Behavioral Questions

### STAR Method Framework

```
S - Situation: Set the scene (brief context)
T - Task: What was your specific responsibility?
A - Action: What did YOU do? (be specific)
R - Result: What was the outcome? (quantify if possible)
```

### Q: Tell me about a time you handled a security incident.

```
Situation:
"During my time at [Company], our SIEM generated a critical alert 
at 2 AM on a Saturday — multiple failed login attempts followed by 
a successful authentication on our VPN gateway from a foreign IP."

Task:
"As the on-call analyst, I needed to determine if this was a 
compromised account or authorized travel, contain any damage, 
and decide on escalation."

Action:
"I immediately:
1. Checked the user's travel calendar — they weren't traveling
2. Disabled the VPN account within 3 minutes of the alert
3. Reviewed logs: attacker had already connected and accessed 
   3 file shares containing PII
4. Isolated the affected network segment
5. Called the incident manager to escalate
6. Began evidence preservation (exported logs, connection records)
7. Checked for lateral movement indicators"

Result:
"We contained the breach within 12 minutes of initial access. 
The attacker only exfiltrated 2 files before disconnection. 
Post-incident, I proposed implementing conditional access policies 
and geo-blocking which reduced similar incidents by 90%. My 
response was used as a training example for new analysts."
```

### Q: Describe a time you disagreed with a colleague about a security decision.

```
Situation:
"Our development team wanted to deploy a new customer portal 
without completing a penetration test, citing time pressure from 
the business. My security team lead agreed to delay testing."

Task:
"I believed this was a significant risk given the portal handled 
payment data, and I needed to advocate for security without 
creating conflict."

Action:
"Rather than escalating over my lead's head, I:
1. Ran a quick automated scan (with permission) that took 2 hours
2. Found 3 critical vulnerabilities including an SQLi
3. Documented the risk in business terms (potential breach cost, 
   regulatory fines, reputation damage)
4. Presented findings to my lead privately with a proposed 
   compromise: fix the critical 3 issues (1 day) + schedule full 
   pentest for the following sprint"

Result:
"My lead appreciated the approach — we fixed the critical issues 
before launch and completed the full test the next week, finding 
5 more medium-severity issues. The application launched securely 
with only a 1-day delay instead of the 2-week full test cycle."
```

### Q: Tell me about a time you had to learn something quickly.

```
Situation:
"Our company was migrating to AWS and I was assigned to secure 
the new cloud infrastructure. I had zero cloud security experience —
all my background was on-premises."

Task:
"I needed to become proficient enough in AWS security to architect 
and implement controls within 6 weeks before the migration date."

Action:
"I created an intensive learning plan:
1. Completed AWS Security Specialty course in 2 weeks (evenings/weekends)
2. Set up personal AWS account and built insecure environment, then secured it
3. Studied every AWS security service (GuardDuty, SecurityHub, CloudTrail, etc.)
4. Found 3 open-source tools for cloud security posture management
5. Connected with AWS security engineers through LinkedIn
6. Created runbooks for the top 20 cloud security scenarios"

Result:
"I delivered the security architecture on time. Our first AWS 
security audit had only 2 minor findings (vs. industry average 
of 15+). I was subsequently asked to lead cloud security for the 
entire organization and trained 4 other team members."
```

---

## Technical Questions - Networking

### Q: Explain the TCP three-way handshake and how it relates to port scanning.

```
The TCP Three-Way Handshake:
────────────────────────────
Client          Server
  │── SYN ──────→│    (Client sends SYN, seq=x)
  │←── SYN-ACK ──│    (Server responds SYN-ACK, seq=y, ack=x+1)
  │── ACK ──────→│    (Client sends ACK, ack=y+1)
  │   Connection Established   │

Relation to Port Scanning:

1. TCP Connect Scan (Nmap -sT):
   - Completes full handshake
   - Port open: SYN → SYN-ACK → ACK (connection established)
   - Port closed: SYN → RST
   - Logged by target (completes connection)

2. SYN Scan (Nmap -sS, "stealth scan"):
   - Sends SYN, doesn't complete handshake
   - Port open: SYN → SYN-ACK → RST (we reset immediately)
   - Port closed: SYN → RST
   - Less likely to be logged (never completes connection)
   - Requires root/admin (raw socket access)

3. How firewalls/IDS detect scans:
   - Multiple SYN packets to different ports from same source
   - High ratio of SYN to established connections
   - Connection attempts to non-existent services
```

### Q: What's the difference between TCP and UDP? Security implications?

```
TCP (Transmission Control Protocol):
- Connection-oriented (handshake required)
- Reliable (acknowledges received data)
- Ordered delivery
- Flow control and congestion control
- Used by: HTTP, SSH, FTP, SMTP

UDP (User Datagram Protocol):
- Connectionless (no handshake)
- Unreliable (no acknowledgment)
- No ordering guarantee
- Faster/lower overhead
- Used by: DNS, DHCP, SNMP, gaming, VoIP

Security Implications:

TCP Attacks:
- SYN flood (exhaust server connection table)
- TCP session hijacking (predict sequence numbers)
- RST injection (kill established connections)
- Man-in-the-middle (intercept during handshake)

UDP Attacks:
- UDP flood / amplification (DNS, NTP, memcached)
- DNS spoofing (no connection verification)
- SNMP enumeration (community strings sent in clear)
- Can't establish "state" — harder to firewall properly

Firewall Considerations:
- TCP: Stateful inspection tracks connection state
- UDP: Harder to track — no "connection" to follow
- UDP amplification is the #1 DDoS vector today
```

### Q: Explain DNS resolution process and common DNS attacks.

```
DNS Resolution Process:
───────────────────────
1. User types "example.com" in browser
2. Browser checks its cache → not found
3. OS checks /etc/hosts (or hosts file) → not found
4. OS queries configured DNS resolver (usually ISP or 8.8.8.8)
5. Resolver checks its cache → not found
6. Resolver queries root nameserver → "Ask .com TLD server"
7. Resolver queries .com TLD → "Ask ns1.example.com"
8. Resolver queries authoritative NS → Returns IP address
9. Resolver caches result (TTL-based)
10. Returns IP to client

Common DNS Attacks:

1. DNS Cache Poisoning
   - Inject false records into resolver cache
   - Redirects all users of that resolver
   - Mitigated by: DNSSEC, randomized ports/IDs

2. DNS Tunneling
   - Encode data in DNS queries (exfiltration channel)
   - Bypasses firewalls (DNS is almost always allowed)
   - Detection: Long subdomain names, high query volume, TXT records

3. DNS Amplification (DDoS)
   - Spoof victim's IP as source
   - Send small query to open DNS resolvers
   - Response is 50-100x larger → floods victim
   - Mitigated by: BCP38, response rate limiting

4. DNS Hijacking
   - Compromise registrar account → change NS records
   - Redirect entire domain to attacker-controlled IP
   - Mitigated by: Registry lock, MFA on registrar, monitoring

5. Typosquatting/DNS spoofing
   - Register similar domains (goog1e.com)
   - Phishing attacks via lookalike domains
```

---

## Technical Questions - Security Concepts

### Q: Explain the CIA Triad with real-world examples.

```
CIA Triad:
──────────

Confidentiality: Only authorized people can access data
├── Example: Patient medical records encrypted in database
├── Controls: Encryption, access controls, data classification
├── Attack: Data breach (unauthorized access to confidential data)
└── Metric: Number of unauthorized access incidents

Integrity: Data hasn't been tampered with
├── Example: Financial transaction amounts match what was sent
├── Controls: Hashing, digital signatures, checksums, audit logs
├── Attack: Man-in-the-middle modifying wire transfer amounts
└── Metric: Number of data integrity violations detected

Availability: Systems are accessible when needed
├── Example: Hospital systems available 24/7 for patient care
├── Controls: Redundancy, failover, DDoS protection, backups
├── Attack: Ransomware encrypting hospital systems
└── Metric: System uptime percentage (99.9% = 8.76 hours downtime/year)

Additional principles often added:
- Authentication: Proving identity
- Authorization: What you're allowed to do
- Non-repudiation: Cannot deny an action (digital signatures)
```

### Q: What's the difference between symmetric and asymmetric encryption?

```
Symmetric Encryption:
─────────────────────
- Same key encrypts and decrypts
- Fast (1000x faster than asymmetric)
- Key distribution problem (how to share key securely?)
- Examples: AES-256, ChaCha20, 3DES
- Use cases: File encryption, database encryption, VPN data

    Alice ──[Key A]──→ Ciphertext ──[Key A]──→ Bob
    (Same key on both sides)

Asymmetric Encryption:
──────────────────────
- Two keys: public (encrypt) + private (decrypt)
- Slow (computationally expensive)
- Solves key distribution (public key is... public)
- Examples: RSA-2048, ECC (Curve25519), ElGamal
- Use cases: Key exchange, digital signatures, TLS handshake

    Alice ──[Bob's Public Key]──→ Ciphertext ──[Bob's Private Key]──→ Bob
    (Only Bob's private key can decrypt)

Real-world usage (TLS/HTTPS):
1. Asymmetric used for key exchange (handshake)
2. Session key generated (symmetric)
3. Symmetric used for actual data (fast)
= "Hybrid encryption" (best of both worlds)

Digital Signatures (asymmetric, reversed):
1. Alice signs with HER private key
2. Anyone can verify with Alice's PUBLIC key
3. Proves: Authentication + Integrity + Non-repudiation
```

### Q: Explain the difference between IDS and IPS. Where would you deploy each?

```
IDS (Intrusion Detection System):
──────────────────────────────────
- PASSIVE: monitors and alerts only
- Does NOT block traffic
- Deployed out-of-band (SPAN/mirror port)
- Lower risk of disrupting legitimate traffic
- Better for: Monitoring, threat hunting, forensics

IPS (Intrusion Prevention System):
───────────────────────────────────
- ACTIVE: monitors AND blocks malicious traffic
- Inline deployment (traffic passes through it)
- Can drop/reset malicious connections
- Risk of blocking legitimate traffic (false positives)
- Better for: Known threats, compliance requirements

Detection Methods (both use):
1. Signature-based: Pattern matching against known threats
   + Low false positives for known attacks
   - Can't detect zero-days or novel attacks
   
2. Anomaly-based: Baseline normal, alert on deviations
   + Can detect unknown attacks
   - High false positive rate initially
   
3. Heuristic/behavioral: Rule-based analysis of behavior
   + Catches variants of known attacks
   - Requires tuning and expertise

Deployment Architecture:
┌─────────────────────────────────────────┐
│  Internet                                │
│     │                                    │
│  [Firewall]                              │
│     │                                    │
│  [IPS] ← Inline, blocks known threats   │
│     │                                    │
│  [Switch] ──mirror──→ [IDS]             │
│     │                  (monitors all)    │
│  [Servers]                               │
└─────────────────────────────────────────┘
```

---

## Technical Questions - Blue Team

### Q: Walk me through your incident response process.

```
NIST Incident Response Framework (SP 800-61):
─────────────────────────────────────────────

Phase 1: PREPARATION
├── Incident response plan documented
├── Team roles and contact info
├── Communication templates
├── Tools ready (forensic workstation, evidence bags)
├── Playbooks for common scenarios
└── Regular tabletop exercises

Phase 2: DETECTION & ANALYSIS
├── Identify indicators of compromise
├── Determine scope (how many systems affected?)
├── Classify severity and impact
├── Document timeline of events
├── Preserve evidence (forensic images, logs)
└── Determine attack vector

Phase 3: CONTAINMENT
├── Short-term: Isolate affected systems immediately
│   - Network isolation (VLAN change, firewall rule)
│   - Disable compromised accounts
│   - Block malicious IPs/domains
├── Long-term: Plan eradication without alerting attacker
│   - Identify all compromised systems first
│   - Prepare clean images
│   - Plan simultaneous containment
└── Evidence preservation during containment

Phase 4: ERADICATION
├── Remove malware from all systems
├── Close attack vectors exploited
├── Patch vulnerabilities
├── Reset all potentially compromised credentials
├── Verify no persistence mechanisms remain
└── Validate systems are clean

Phase 5: RECOVERY
├── Restore from clean backups
├── Rebuild compromised systems
├── Gradual return to production
├── Enhanced monitoring on recovered systems
├── Validate normal operations
└── Monitor for re-compromise indicators

Phase 6: LESSONS LEARNED (within 1-2 weeks)
├── What happened? (complete timeline)
├── What went well?
├── What could improve?
├── Action items with owners and deadlines
├── Update playbooks and detection rules
└── Report to management/stakeholders
```

### Q: You see 10,000 failed login attempts from one IP against your VPN. What do you do?

```
Immediate Actions (first 5 minutes):
1. Block the source IP at the firewall/VPN gateway
2. Check if any successful authentications from that IP
3. If YES successful login → treat as CONFIRMED COMPROMISE:
   - Disable that user account immediately
   - Begin incident response process
   - Check what the account accessed after login

Investigation (next 30 minutes):
4. Check timing pattern:
   - Even spacing → automated tool (hydra, medusa)
   - Irregular → possible manual/human
5. Check targeted usernames:
   - Same username → targeted attack on known account
   - Different usernames → credential stuffing
   - Username enumeration pattern → reconnaissance
6. Check source IP:
   - Threat intel lookup (known bad IP?)
   - Geolocation (expected country for our users?)
   - ASN/hosting provider (VPN/proxy/cloud?)
7. Check for other indicators:
   - Same IP hitting other services?
   - Other IPs doing similar from same range?
   - Distributed attack (many IPs, few attempts each)?

Response:
8. If isolated incident:
   - Keep block, document, close as handled
9. If targeted attack:
   - Notify targeted user(s)
   - Enforce password reset
   - Add MFA if not already in place
   - Brief security team
10. Detection improvement:
    - Create alert rule for threshold (e.g., >20 failures in 5 min)
    - Consider implementing account lockout policy
    - Consider geographic-based access restrictions
```

---

## Technical Questions - Red Team

### Q: Explain the penetration testing methodology.

```
Penetration Testing Phases:
───────────────────────────

Phase 1: SCOPING & RULES OF ENGAGEMENT
├── Define targets (IP ranges, domains, applications)
├── Define out-of-scope systems
├── Agree on testing window
├── Emergency contacts
├── Legal authorization (signed ROE)
└── Determine test type (black/gray/white box)

Phase 2: RECONNAISSANCE
├── Passive (no direct contact with target):
│   - OSINT (LinkedIn, job postings, social media)
│   - DNS enumeration (records, zone transfers)
│   - Technology identification (Wappalyzer, BuiltWith)
│   - Email harvesting (theHarvester, Hunter.io)
│   - Leaked credentials (breach databases)
│   - GitHub/code repositories (secrets in code)
├── Active (direct contact):
│   - Port scanning (Nmap)
│   - Service enumeration
│   - Directory brute forcing
│   - Vulnerability scanning (Nessus, Nuclei)
└── Output: Attack surface map

Phase 3: EXPLOITATION
├── Attempt exploits for identified vulnerabilities
├── Priority: Low-noise attacks first
├── Web app attacks (SQLi, auth bypass, etc.)
├── Network service exploits
├── Default/weak credentials
├── Social engineering (if in scope)
└── Output: Initial access achieved

Phase 4: POST-EXPLOITATION
├── Privilege escalation (user → admin/root)
├── Lateral movement (compromised host → other hosts)
├── Credential harvesting
├── Data collection (prove impact)
├── Persistence establishment (to demonstrate risk)
└── Output: Document full impact of compromise

Phase 5: REPORTING
├── Executive summary (business risk, non-technical)
├── Technical findings (each vulnerability detailed)
├── Evidence (screenshots, commands, data accessed)
├── Risk ratings (CVSS, business context)
├── Remediation recommendations (prioritized)
└── Output: Professional penetration test report
```

### Q: How would you attack an Active Directory environment?

```
AD Attack Chain:
────────────────

1. INITIAL ACCESS
├── LLMNR/NBT-NS Poisoning (Responder)
│   → Capture NTLMv2 hashes on network
├── SMB Relay (ntlmrelayx)
│   → Relay captured auth to other machines
├── Password spraying
│   → Try common passwords against all users
├── Phishing (if in scope)
│   → Macro documents, credential harvesting
└── Exploit public-facing service

2. ENUMERATION
├── BloodHound (graph-based AD mapping)
│   → Visualize paths to Domain Admin
├── PowerView/SharpHound
│   → Enumerate users, groups, GPOs, trusts
├── Identify: Kerberoastable accounts
├── Identify: AS-REP roastable accounts
├── Identify: Abusable ACLs/DACLs
├── Identify: Unconstrained delegation
└── Map: Shortest path to DA

3. PRIVILEGE ESCALATION
├── Kerberoasting:
│   → Request TGS for accounts with SPNs
│   → Crack service tickets offline
│   → If password is weak → gain service account access
├── AS-REP Roasting:
│   → Request encrypted part without pre-auth
│   → Crack offline
├── ACL Abuse:
│   → GenericAll → reset password
│   → WriteDACL → give yourself permissions
│   → WriteOwner → take ownership
└── Token Impersonation:
    → Steal tokens from high-priv processes

4. LATERAL MOVEMENT
├── Pass-the-Hash (don't need plaintext password)
├── Pass-the-Ticket (use stolen Kerberos tickets)
├── PsExec/WMI/WinRM (admin access to other machines)
├── DCOM execution
├── RDP (if credentials obtained)
└── Overpass-the-Hash (hash → ticket → access)

5. DOMAIN DOMINANCE
├── DCSync (replication → extract all hashes)
├── Golden Ticket (forge TGTs with KRBTGT hash)
├── Silver Ticket (forge TGS for specific services)
├── Skeleton Key (master password on DC)
└── AdminSDHolder abuse (persistent admin access)
```

---

## Scenario-Based Questions

### Q: A user reports their computer is "acting slow" and they received a suspicious email yesterday. Walk me through your investigation.

```
This is a potential phishing → malware scenario. Here's my approach:

Step 1: Initial Triage (5 minutes)
├── Ask user: Did you click any links or open attachments?
├── Ask user: What specifically is slow? (everything or specific apps?)
├── Check: Is the email still in inbox? (preserve it)
├── Decision: If user clicked → treat as potential compromise
└── DO NOT: Have user "check if it's still slow" (might alert malware)

Step 2: Isolate (if user interacted with email)
├── Disconnect from network (unplug cable, disable WiFi)
├── Do NOT power off (preserves memory evidence)
├── Note the time of isolation
└── Inform user this is precautionary

Step 3: Evidence Collection
├── Email analysis:
│   - Sender address (spoofed? lookalike domain?)
│   - Headers (originating IP, mail servers)
│   - Attachment (hash it, check VirusTotal)
│   - URLs in email (check with urlscan.io)
├── Endpoint investigation:
│   - Check running processes (look for unusual)
│   - Check network connections (any C2 beaconing?)
│   - Check startup items (persistence?)
│   - Check recently created/modified files
│   - Check browser history (credential harvesting?)
│   - Review event logs (new services, scheduled tasks)
└── Network logs:
    - DNS queries from that machine
    - Proxy logs (suspicious domains?)
    - Firewall logs (outbound to C2?)

Step 4: Determine Scope
├── Did the email go to other users? (check email gateway)
├── Are other machines showing same indicators?
├── Has the user's account been used abnormally?
└── Check shared resources the user has access to

Step 5: Containment & Remediation
├── If confirmed malicious:
│   - Reset user credentials
│   - Block IOCs (sender, domains, IPs, hashes)
│   - Scan all recipients for the same email
│   - Image the machine for forensics if needed
│   - Reimage machine from clean build
│   - Monitor for related activity for 72 hours
└── Report and document findings
```

---

## Hands-On Assessments

### What to Expect

```
Common hands-on assessment formats:

1. Live CTF Challenge (1-4 hours)
   - Given vulnerable machine(s)
   - Find flags (user.txt, root.txt)
   - Demonstrate exploitation skills
   - Usually in isolated lab environment

2. Take-Home Security Assessment (24-72 hours)
   - Analyze a code sample for vulnerabilities
   - Review network diagram for security gaps
   - Write detection rules for given scenarios
   - Perform OSINT on a target (sanitized)

3. Incident Response Simulation (1-2 hours)
   - Given SIEM alerts and logs
   - Investigate and determine what happened
   - Classify the incident
   - Propose response actions
   - Write executive summary

4. Architecture Review (whiteboard, 30-60 min)
   - Given a business requirement
   - Design secure architecture
   - Explain your security decisions
   - Discuss trade-offs
```

### Tips for Hands-On Success

```
1. Document EVERYTHING as you go
   - Screenshots of each step
   - Commands used and their output
   - Timestamps of actions

2. Show your methodology
   - Interviewers care about PROCESS, not just results
   - Systematic approach > random guessing
   - Explain WHY you're doing each step

3. Manage your time
   - Don't spend 80% on one problem
   - Get "easy wins" first
   - Note things to come back to

4. If you get stuck:
   - State what you've tried
   - Explain your reasoning
   - Describe what you'd do next
   - Ask if hints are allowed
   - Being stuck is OK — how you handle it matters

5. Communicate throughout
   - Think out loud
   - Explain your decision-making
   - Show you know when to escalate
```

---

## Questions to Ask Interviewers

```
About the Role:
- "What does a typical day/week look like in this role?"
- "What are the biggest security challenges you're currently facing?"
- "What tools and technologies does your security team use?"
- "How is the security team structured?"
- "What does success look like in this role at 30/60/90 days?"

About Growth:
- "What professional development opportunities are available?"
- "Is there a budget for certifications and training?"
- "Can you describe the career progression path from this role?"
- "Do team members attend conferences?"

About Culture:
- "How does the security team interact with engineering/DevOps?"
- "What's the on-call rotation like?"
- "How are incidents handled — is there blame culture or blameless postmortems?"
- "What's the team's philosophy on automation vs. manual processes?"

Red Flag Questions (gauge toxicity):
- "What's the average tenure on the security team?"
- "Why is this position open?"
- "What would you change about the team if you could?"
```

---

## Salary Negotiation

```
Research Before Negotiating:
- Glassdoor, Levels.fyi, PayScale
- Security-specific: ISC² salary survey, SANS salary survey
- Factor in: Location, company size, industry, experience

US Market Ranges (2024, approximate):
- SOC Analyst L1: $60,000 - $85,000
- SOC Analyst L2: $80,000 - $110,000
- Security Engineer: $100,000 - $150,000
- Penetration Tester: $90,000 - $140,000
- Security Architect: $140,000 - $200,000
- CISO: $200,000 - $400,000+

Negotiation Tips:
1. Never give a number first if possible
2. Counter at least once (they expect it)
3. Negotiate total comp (base + bonus + stock + benefits)
4. Use competing offers as leverage
5. Be enthusiastic about the role (they invest in people who want to be there)
6. Get everything in writing before accepting
```

---

## Common Mistakes to Avoid

```
❌ Being too theoretical (give real examples, not textbook answers)
❌ Saying "I don't know" without follow-up (say what you'd do to find out)
❌ Badmouthing previous employers
❌ Not asking questions (shows lack of interest)
❌ Failing to show enthusiasm for security
❌ Not preparing examples for behavioral questions
❌ Being defensive about gaps in knowledge
❌ Rambling (keep answers 2-3 minutes max)
❌ Not researching the company beforehand
❌ Forgetting to follow up with a thank-you email

✅ Admit knowledge gaps honestly, then explain how you'd learn
✅ Use specific examples from real experience or labs
✅ Show your problem-solving process, not just answers
✅ Demonstrate passion for continuous learning
✅ Be personable — people hire people they want to work with
✅ Prepare 5-7 STAR stories that cover different scenarios
✅ Research the company's recent security news/challenges
✅ Bring a portfolio or be ready to screen-share projects
```

---

**Next:** → [24-Career-Roadmap](../24-Career-Roadmap/README.md)

*"The best interview answers demonstrate not just what you know, but how you think. Show your process."*
