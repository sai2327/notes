# 🏁 Capture The Flag (CTF) Competitions

## Sharpen Your Skills Through Competitive Hacking Challenges

---

## What are CTFs?

CTFs are cybersecurity competitions where participants solve security challenges to find hidden "flags" (usually strings like `flag{th1s_1s_a_fl4g}`). They're the best way to practice real skills.

---

## CTF Categories

| Category | Skills Tested | Common Challenges |
|----------|--------------|-------------------|
| **Web** | Web exploitation | SQLi, XSS, SSRF, auth bypass |
| **Pwn** (Binary Exploitation) | Buffer overflows, ROP | Exploit binaries |
| **Crypto** | Cryptanalysis | Break encryption, find weaknesses |
| **Reverse Engineering** | Binary analysis | Understand and crack programs |
| **Forensics** | Evidence analysis | Disk/memory/network forensics |
| **OSINT** | Open source intelligence | Find info from public sources |
| **Misc** | Various | Steganography, programming |

---

## CTF Types

| Type | Format | Duration |
|------|--------|----------|
| **Jeopardy** | Individual challenges with point values | 24-48 hours |
| **Attack-Defense** | Teams attack each other's services | Real-time |
| **King of the Hill** | Maintain control of systems | Real-time |
| **Boot2Root** | Complete machine compromise | Self-paced |

---

## Getting Started with CTFs

### Beginner Path

```
Month 1: PicoCTF (beginner-friendly, educational hints)
Month 2: OverTheWire (Bandit → Natas → Narnia)
Month 3: TryHackMe CTF rooms
Month 4: HackTheBox Starting Point
Month 5: CTFtime.org competitions (easy-rated)
Month 6: HackTheBox retired machines
```

### Web CTF Methodology

```
1. Reconnaissance
   - View source code
   - Check robots.txt, sitemap.xml
   - Inspect cookies, headers
   - Check for hidden parameters

2. Test for vulnerabilities
   - Input fields → SQLi, XSS
   - URL parameters → IDOR, LFI
   - File uploads → Webshell
   - Authentication → Bypass, brute force

3. Exploit
   - Craft payload
   - Extract flag
   - Document solution
```

### Binary Exploitation (Pwn) Methodology

```
1. Analyze binary
   - file, checksec, strings
   - Disassemble with Ghidra/GDB

2. Identify vulnerability
   - Buffer overflow?
   - Format string?
   - Use-after-free?

3. Develop exploit
   - Find offset to return address
   - Build ROP chain or shellcode
   - Test in debugger

4. Get flag
   - Execute exploit against remote target
```

### Useful CTF Tools

| Category | Tools |
|----------|-------|
| Web | Burp Suite, curl, Developer Tools |
| Crypto | CyberChef, Python, SageMath |
| Forensics | Volatility, Autopsy, Wireshark, binwalk |
| Reverse | Ghidra, GDB + GEF, ltrace/strace |
| Pwn | pwntools (Python), ROPgadget, checksec |
| OSINT | Shodan, Google, Wayback, exiftool |
| Stego | steghide, zsteg, stegsolve |

### CyberChef (The Cyber Swiss Army Knife)

CyberChef (gchq.github.io/CyberChef/) can:
- Decode Base64, Hex, URL encoding
- XOR data
- Analyze and convert formats
- Chain multiple operations ("recipes")

---

## CTF Platforms

| Platform | Level | Type |
|----------|-------|------|
| PicoCTF | Beginner | Jeopardy |
| OverTheWire | Beginner-Intermediate | Wargames |
| TryHackMe | All | Guided + CTF |
| HackTheBox | Intermediate-Advanced | Machines + Challenges |
| CTFtime.org | All | Competition directory |
| Root-Me | All | Challenges |
| CryptoHack | All | Crypto-focused |
| pwnable.kr | Intermediate | Pwn-focused |

---

## CTF Writeup Template

```markdown
# Challenge Name
## Category: Web | Points: 200

### Description
[Challenge description]

### Solution

#### Step 1: Reconnaissance
[What I found during recon]

#### Step 2: Vulnerability Identification
[What vulnerability I found]

#### Step 3: Exploitation
[How I exploited it]
```code
[commands or payloads used]
```

#### Step 4: Flag
`flag{example_flag_here}`

### Lessons Learned
- What I learned from this challenge
- New techniques discovered
```

---

## Exercises

1. Complete PicoCTF (aim for 30+ challenges)
2. Solve OverTheWire Bandit levels 0-25
3. Solve 5 web challenges on HackTheBox
4. Participate in a live CTF competition (CTFtime.org)
5. Write writeups for every challenge you solve

---

**Next:** → [19-Bug-Bounty](../19-Bug-Bounty/README.md)

*"CTFs turn learning into play. The best hackers never stop playing."*
