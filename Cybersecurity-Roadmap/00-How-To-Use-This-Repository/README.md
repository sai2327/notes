# 📖 How To Use This Repository

## Your Complete Guide to Getting the Most Out of This Cybersecurity Curriculum

---

## 📌 Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Learning Philosophy](#learning-philosophy)
4. [Study Methodology](#study-methodology)
5. [Time Commitment](#time-commitment)
6. [Setting Up Your Environment](#setting-up-your-environment)
7. [How to Navigate This Repository](#how-to-navigate-this-repository)
8. [Learning Strategies](#learning-strategies)
9. [Note-Taking System](#note-taking-system)
10. [Practice Philosophy](#practice-philosophy)
11. [Common Mistakes to Avoid](#common-mistakes-to-avoid)
12. [FAQ](#faq)

---

## Overview

This repository is designed as a **self-paced, structured curriculum** that mirrors what you'd receive in a $15,000+ cybersecurity bootcamp — but completely free and open-source.

### What Makes This Different

| Feature | This Repository | Typical Online Course |
|---------|----------------|----------------------|
| Structure | Complete 12-month roadmap | Random topics |
| Depth | Beginner to Advanced | Usually one level |
| Practice | Hands-on labs every section | Watch and forget |
| Projects | Real-world security tools | Toy examples |
| Career | Full preparation guide | Certificate only |
| Updates | Community maintained | Often outdated |

---

## Prerequisites

### Absolute Minimum Requirements

You need:
- ✅ A computer (minimum 8GB RAM, 256GB storage recommended)
- ✅ Internet connection
- ✅ Dedication to learn (15-25 hours/week)
- ✅ Patience and persistence
- ✅ Curiosity and passion for technology

### You Do NOT Need

- ❌ Prior programming experience
- ❌ Prior IT knowledge
- ❌ A degree in computer science
- ❌ Expensive tools or software
- ❌ A powerful gaming PC

---

## Learning Philosophy

### The 70-20-10 Rule

```
┌─────────────────────────────────────────────┐
│                                             │
│   70% — Hands-On Practice                   │
│   ├── Labs                                  │
│   ├── Building projects                     │
│   ├── CTF challenges                        │
│   └── Breaking/fixing things                │
│                                             │
│   20% — Learning From Others                │
│   ├── Reading documentation                 │
│   ├── Watching demonstrations               │
│   ├── Studying write-ups                    │
│   └── Community discussions                 │
│                                             │
│   10% — Formal Study                        │
│   ├── Reading theory                        │
│   ├── Taking notes                          │
│   ├── Memorizing concepts                   │
│   └── Studying for certifications           │
│                                             │
└─────────────────────────────────────────────┘
```

### Core Principles

1. **Learn by Doing** — Never just read. Always type commands yourself.
2. **Break Things** — The best way to understand security is to break it.
3. **Fix Things** — After breaking, understand how to defend.
4. **Document Everything** — Keep notes. Future you will thank present you.
5. **Stay Legal** — Always practice in authorized environments only.
6. **Be Patient** — Mastery takes time. Trust the process.
7. **Build Consistently** — Small daily progress beats weekend cramming.

---

## Study Methodology

### The PRACT Framework

For every topic in this repository, follow this framework:

| Step | Action | Description |
|------|--------|-------------|
| **P** | Preview | Skim the topic, understand what you'll learn |
| **R** | Read | Read the full explanation carefully |
| **A** | Apply | Do the hands-on exercises and labs |
| **C** | Create | Build something using what you learned |
| **T** | Teach | Explain the concept to someone (or write about it) |

### Daily Study Routine

```
Morning (1-2 hours):
├── Review yesterday's notes (10 min)
├── Read new theory/concepts (30-40 min)
├── Watch demonstrations (20 min)
└── Take notes (10-20 min)

Afternoon/Evening (1-2 hours):
├── Hands-on lab work (45-60 min)
├── Practice commands (15-20 min)
├── Work on projects (15-20 min)
└── Review and plan tomorrow (10 min)

Weekend (3-4 hours):
├── Extended lab sessions (2 hours)
├── CTF practice (1 hour)
├── Project work (1 hour)
└── Community engagement (30 min)
```

---

## Time Commitment

### Minimum Viable Schedule

| Commitment Level | Hours/Week | Completion Time | Outcome |
|-----------------|------------|-----------------|---------|
| Casual | 10 hours | 18-24 months | Good understanding |
| Dedicated | 15-20 hours | 12 months | Job ready |
| Intensive | 25-30 hours | 8-9 months | Highly competitive |
| Full-time | 40+ hours | 5-6 months | Expert level |

### Recommended: 20 Hours/Week

```
Monday:    3 hours (Theory + Lab)
Tuesday:   3 hours (Theory + Lab)
Wednesday: 3 hours (Practice + Project)
Thursday:  3 hours (Theory + Lab)
Friday:    3 hours (Practice + Review)
Saturday:  4 hours (Extended Lab + CTF)
Sunday:    1 hour  (Review + Plan next week)
─────────────────────────────────
Total:     20 hours/week
```

---

## Setting Up Your Environment

### Hardware Requirements

| Component | Minimum | Recommended | Ideal |
|-----------|---------|-------------|-------|
| RAM | 8 GB | 16 GB | 32 GB |
| Storage | 256 GB | 512 GB SSD | 1 TB NVMe |
| CPU | Dual-core | Quad-core | 8-core |
| Network | WiFi | Ethernet | Both |

### Software You'll Need (All Free)

#### Virtualization
- **VirtualBox** (Free) — For running virtual machines
- **VMware Workstation Player** (Free) — Alternative to VirtualBox

#### Operating Systems
- **Kali Linux** — Primary hacking OS
- **Ubuntu/Parrot** — Secondary Linux
- **Windows 10/11 VM** — For Windows labs
- **Windows Server** — For Active Directory labs

#### Essential Tools (Pre-installed on Kali)
- Nmap, Wireshark, Burp Suite, Metasploit
- Python 3, Bash, Git

### Quick Start Setup

```bash
# Step 1: Download VirtualBox
# https://www.virtualbox.org/wiki/Downloads

# Step 2: Download Kali Linux VM
# https://www.kali.org/get-kali/#kali-virtual-machines

# Step 3: Import Kali VM into VirtualBox
# File → Import Appliance → Select .ova file

# Step 4: Start Kali Linux
# Default credentials: kali/kali

# Step 5: Update the system
sudo apt update && sudo apt upgrade -y

# Step 6: Verify tools
nmap --version
python3 --version
msfconsole -v
```

> **Detailed setup instructions:** See [28-Home-Lab-Setup](../28-Home-Lab-Setup/README.md)

---

## How to Navigate This Repository

### Sequential Learning (Recommended for Beginners)

Follow the numbered folders in order:
```
01 → 02 → 03 → 04 → 05 → ... → 30
```

Each folder builds upon knowledge from the previous one.

### Topic-Based Learning (For Those with Experience)

Jump to specific topics if you already have foundations:
- **Already know Linux?** → Start at 03-Networking
- **Already a developer?** → Start at 06-Cybersecurity-Fundamentals
- **Already in IT?** → Start at 07-Web-Security
- **Want pentesting only?** → 09-Penetration-Testing (but review prereqs)

### Each Section Contains

```
XX-Topic-Name/
├── README.md          ← Main learning content
├── exercises/         ← Practice exercises
├── labs/              ← Hands-on labs
├── projects/          ← Mini projects
├── cheatsheet.md      ← Quick reference
└── resources.md       ← Additional learning resources
```

---

## Learning Strategies

### Active Recall

Don't just re-read notes. Test yourself:
- After reading a section, close it and write what you remember
- Use flashcards for commands and concepts
- Explain concepts without looking at notes

### Spaced Repetition

Review material at increasing intervals:
- Day 1: Learn it
- Day 2: Review
- Day 4: Review
- Day 7: Review
- Day 14: Review
- Day 30: Review

### The Feynman Technique

1. Choose a concept
2. Explain it as if teaching a 12-year-old
3. Identify gaps in your explanation
4. Go back and fill the gaps
5. Simplify and use analogies

### Build a Second Brain

Keep a personal knowledge base:
- **Obsidian** or **Notion** for notes
- **CherryTree** for security-specific notes
- Document every command you learn
- Save every lab walkthrough
- Keep a "lessons learned" journal

---

## Note-Taking System

### Recommended Structure

```
Notes/
├── 01-Fundamentals/
│   ├── cpu-architecture.md
│   ├── memory-management.md
│   └── boot-process.md
├── 02-Linux/
│   ├── commands.md
│   ├── permissions.md
│   └── troubleshooting.md
├── Commands/
│   ├── linux-commands.md
│   ├── nmap-commands.md
│   └── metasploit-commands.md
├── Labs/
│   ├── lab-001-linux-basics.md
│   ├── lab-002-networking.md
│   └── lab-003-web-hacking.md
└── Journal/
    ├── daily-log.md
    └── lessons-learned.md
```

### Note Template

```markdown
# [Topic Name]

## Date: YYYY-MM-DD

## Key Concepts
- Concept 1
- Concept 2

## Commands Learned
```command
explanation
```

## What I Built/Did
- Description of practical work

## Challenges Faced
- Challenge and how I solved it

## Questions to Research Later
- Question 1
- Question 2

## Resources Used
- Link 1
- Link 2
```

---

## Practice Philosophy

### The Hacker Mindset

```
┌──────────────────────────────────────────┐
│                                          │
│   "How does this work?"                  │
│         ↓                                │
│   "What happens if I change this?"       │
│         ↓                                │
│   "Can I make it do something            │
│    it wasn't designed to do?"            │
│         ↓                                │
│   "How can I defend against              │
│    what I just discovered?"              │
│                                          │
└──────────────────────────────────────────┘
```

### Practice Platforms (All Free Tiers Available)

| Platform | Focus | Level | URL |
|----------|-------|-------|-----|
| TryHackMe | All security topics | Beginner-Advanced | tryhackme.com |
| HackTheBox | Pentesting | Intermediate-Advanced | hackthebox.com |
| OverTheWire | Linux/Wargames | Beginner | overthewire.org |
| PicoCTF | CTF challenges | Beginner | picoctf.org |
| PortSwigger Academy | Web Security | All levels | portswigger.net/web-security |
| VulnHub | Vulnerable VMs | All levels | vulnhub.com |
| CyberDefenders | Blue Team | Intermediate | cyberdefenders.org |
| LetsDefend | SOC Analyst | Beginner-Intermediate | letsdefend.io |

---

## Common Mistakes to Avoid

### ❌ Mistake 1: Tutorial Hell
**Problem:** Watching tutorials endlessly without practicing.
**Solution:** For every 30 minutes of watching, spend 60 minutes doing.

### ❌ Mistake 2: Skipping Fundamentals
**Problem:** Jumping to "cool hacking stuff" without foundations.
**Solution:** Trust the process. Months 1-5 build the foundation everything else depends on.

### ❌ Mistake 3: Not Taking Notes
**Problem:** Forgetting everything you learned.
**Solution:** Document every command, concept, and lab.

### ❌ Mistake 4: Comparing Progress
**Problem:** Feeling behind compared to others.
**Solution:** Focus on YOUR journey. Consistency beats speed.

### ❌ Mistake 5: Not Building Projects
**Problem:** Can follow tutorials but can't create independently.
**Solution:** Build at least one project per month.

### ❌ Mistake 6: Ignoring Defense
**Problem:** Only learning offense without defense.
**Solution:** For every attack technique, learn the defense.

### ❌ Mistake 7: Working Illegally
**Problem:** Testing on systems without permission.
**Solution:** ONLY practice on your own labs and authorized platforms.

### ❌ Mistake 8: Not Engaging Community
**Problem:** Learning in isolation.
**Solution:** Join Discord servers, attend meetups, contribute to open source.

---

## FAQ

### Q: Do I need to know programming first?
**A:** No. This curriculum teaches programming as part of the journey (Month 3). However, being comfortable with basic computer usage helps.

### Q: Can I skip sections I find boring?
**A:** Not recommended for beginners. Each section builds on the previous. Advanced learners can assess their knowledge and skip known material.

### Q: How do I know when to move to the next section?
**A:** Complete all exercises and labs. If you can explain the concepts without notes and solve the challenge tasks, move on.

### Q: Is this enough to get a job?
**A:** Combined with certifications (Section 22), projects (Section 21), and networking (Section 24), yes. Many successful security professionals are self-taught.

### Q: What certification should I get first?
**A:** CompTIA Security+ for most people. eJPT if you want to focus on pentesting. See Section 22 for details.

### Q: Do I need expensive tools?
**A:** No. 95% of cybersecurity tools are free and open-source. Burp Suite Community Edition, Kali Linux, and free training platforms are sufficient.

### Q: Can I do this alongside a full-time job?
**A:** Yes. The 15-20 hours/week schedule is designed for working professionals. Adjust the timeline if needed — 18 months is perfectly fine.

### Q: What if I get stuck?
**A:** 
1. Re-read the material
2. Search online (Google, StackOverflow)
3. Watch video explanations
4. Ask in community forums
5. Move on and come back later

---

## 🎯 Success Metrics

Track these monthly to measure progress:

| Month | You Should Be Able To... |
|-------|--------------------------|
| 1 | Navigate Linux, manage files, explain OS concepts |
| 2 | Analyze packets, explain protocols, subnet networks |
| 3 | Write Python scripts, automate tasks, parse data |
| 4 | Build web applications, understand HTTP deeply |
| 5 | Explain security concepts, implement basic crypto |
| 6 | Find and exploit web vulnerabilities in labs |
| 7 | Escalate privileges on Linux and Windows |
| 8 | Perform complete penetration tests |
| 9 | Attack Active Directory environments |
| 10 | Work in your chosen specialization |
| 11 | Solve CTFs and find real bugs |
| 12 | Apply for jobs with confidence |

---

## 🚀 Ready to Begin?

**Next Step:** → [01-Computer-Fundamentals](../01-Computer-Fundamentals/README.md)

Remember:
> *"Every expert was once a beginner. The difference is they never stopped practicing."*

---

*Good luck on your cybersecurity journey! 🛡️*
