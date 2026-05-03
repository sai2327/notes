# 16. Cyber Laws & Ethics

## Table of Contents
- [16.1 Why Cyber Laws Matter](#161-why-cyber-laws-matter)
- [16.2 Major Cyber Laws](#162-major-cyber-laws)
- [16.3 Data Protection & Privacy Laws](#163-data-protection--privacy-laws)
- [16.4 Ethical Hacking — Legal Boundaries](#164-ethical-hacking--legal-boundaries)
- [16.5 Cybercrime Categories](#165-cybercrime-categories)
- [16.6 Professional Ethics & Codes of Conduct](#166-professional-ethics--codes-of-conduct)
- [16.7 Common Mistakes & Interview Tips](#167-common-mistakes--interview-tips)
- [16.8 Practice & Assessment](#168-practice--assessment)

---

## 16.1 Why Cyber Laws Matter

```
Without authorization → Scanning a network = ILLEGAL
With authorization   → Scanning a network = Penetration Testing (legal)

The ONLY difference is PERMISSION.
Even with good intentions, unauthorized hacking is a crime.
```

---

## 16.2 Major Cyber Laws

### India — Information Technology Act, 2000 (IT Act)

| Section | Offense | Punishment |
|---------|---------|-----------|
| **Section 43** | Unauthorized access to computer system | Compensation up to ₹1 crore |
| **Section 65** | Tampering with computer source code | 3 years imprisonment + fine |
| **Section 66** | Computer-related offenses (hacking) | 3 years imprisonment + ₹5 lakh fine |
| **Section 66B** | Receiving stolen computer resource | 3 years + ₹1 lakh fine |
| **Section 66C** | Identity theft | 3 years + ₹1 lakh fine |
| **Section 66D** | Cheating by personation using computer | 3 years + ₹1 lakh fine |
| **Section 66E** | Privacy violation (publishing private images) | 3 years + ₹2 lakh fine |
| **Section 66F** | Cyber terrorism | Life imprisonment |
| **Section 67** | Publishing obscene content | 5 years + ₹10 lakh fine |
| **Section 72** | Breach of confidentiality and privacy | 2 years + ₹1 lakh fine |

### USA — Key Laws

| Law | Purpose |
|-----|---------|
| **CFAA** (Computer Fraud and Abuse Act) | Federal anti-hacking law |
| **ECPA** (Electronic Communications Privacy Act) | Protects electronic communications |
| **DMCA** (Digital Millennium Copyright Act) | Anti-piracy and circumvention |
| **HIPAA** | Healthcare data protection |
| **SOX** (Sarbanes-Oxley) | Financial data integrity |

### International

| Law/Regulation | Scope | Key Requirement |
|---------------|-------|-----------------|
| **GDPR** (EU) | Anyone handling EU citizen data | Consent, right to erasure, 72hr breach notification |
| **Budapest Convention** | International cybercrime treaty | Cooperation between countries |
| **PCI DSS** | Anyone processing credit cards | Secure cardholder data |

---

## 16.3 Data Protection & Privacy Laws

### GDPR (General Data Protection Regulation)

```
Key Principles:
  1. Lawfulness — Process data with legal basis
  2. Purpose limitation — Only for stated purpose
  3. Data minimization — Collect only what's needed
  4. Accuracy — Keep data correct and up to date
  5. Storage limitation — Don't keep data longer than needed
  6. Integrity — Protect data from unauthorized access
  7. Accountability — Organization must prove compliance

Individual Rights:
  ✓ Right to access your data
  ✓ Right to rectification (correct errors)
  ✓ Right to erasure ("right to be forgotten")
  ✓ Right to data portability
  ✓ Right to object to processing
  ✓ Right to not be subject to automated decisions

Penalties:
  Up to €20 million or 4% of annual global revenue (whichever is higher)
```

### India — Digital Personal Data Protection Act (DPDPA), 2023

```
Key Points:
  → Applies to digital personal data processed in India
  → Consent required for data collection
  → Purpose limitation (use data only for stated purpose)
  → Right to correction and erasure
  → Data breach notification mandatory
  → Penalties up to ₹250 crore
  → Data Protection Board of India for enforcement
```

---

## 16.4 Ethical Hacking — Legal Boundaries

### What Makes Hacking LEGAL

```
Requirements for legal ethical hacking:
  1. WRITTEN AUTHORIZATION (scope document / contract)
  2. Defined SCOPE (which systems, what tests)
  3. Defined TIMELINE (start and end dates)
  4. RULES OF ENGAGEMENT (what's allowed, what's not)
  5. Emergency CONTACT information
  6. DATA HANDLING procedures (how to handle found data)
  7. LIABILITY and INSURANCE

Without these → You're committing a crime, no matter your intent.
```

### Bug Bounty Programs — Legal Path to Hacking

```
Companies that PAY you to find vulnerabilities:
  → HackerOne (hackerone.com)
  → Bugcrowd (bugcrowd.com)
  → Google VRP (bughunters.google.com)
  → Microsoft MSRC
  → GitHub Security Bug Bounty

Rules:
  ✓ Only test within defined scope
  ✓ Don't access user data
  ✓ Report vulnerabilities responsibly
  ✓ Don't publicly disclose before fix
  ✗ Never sell vulnerabilities on black market
```

---

## 16.5 Cybercrime Categories

| Category | Examples |
|----------|---------|
| **Against Individuals** | Identity theft, cyberstalking, phishing, sextortion |
| **Against Property** | Hacking, virus attacks, intellectual property theft |
| **Against Organizations** | Data breaches, ransomware, DDoS, corporate espionage |
| **Against Government** | Cyber terrorism, attacking critical infrastructure |
| **Financial** | Online fraud, cryptocurrency scams, carding |

---

## 16.6 Professional Ethics & Codes of Conduct

### Ethical Principles for Security Professionals

```
1. AUTHORIZATION — Never test without written permission
2. CONFIDENTIALITY — Protect client data and findings
3. INTEGRITY — Report all findings honestly
4. LEGAL COMPLIANCE — Follow all applicable laws
5. RESPONSIBLE DISCLOSURE — Report vulnerabilities to vendor first
6. DO NO HARM — Minimize impact during testing
7. PROFESSIONAL DEVELOPMENT — Stay current with threats
```

### Responsible Disclosure vs Full Disclosure

| Approach | Process | Pros | Cons |
|----------|---------|------|------|
| **Responsible** | Report to vendor → wait for fix → then publish | Vendor can fix first | Vendor may ignore/delay |
| **Full** | Publish immediately | Forces fast fix | Users at risk before patch |
| **Coordinated** | Report to vendor → set deadline → publish after deadline or fix | Balanced approach | Requires negotiation |

---

## 16.7 Common Mistakes & Interview Tips

### Interview Questions

**Q: Is scanning a network without permission legal?**
> No. Even a simple port scan without authorization can be considered unauthorized access under laws like the CFAA (USA) or IT Act Section 43 (India).

**Q: What is GDPR?**
> General Data Protection Regulation — an EU law that gives individuals control over their personal data. It requires consent for data collection, breach notification within 72 hours, and right to erasure. Penalties can reach €20M or 4% of global revenue.

**Q: What is responsible disclosure?**
> Reporting a discovered vulnerability to the vendor privately, giving them time to fix it before making it public. This protects users while ensuring the vulnerability gets patched.

---

## 16.8 Practice & Assessment

### MCQs

**Q1.** Under India's IT Act, cyber terrorism (Section 66F) can lead to:
- A) Fine only
- B) 3 years imprisonment
- C) 7 years imprisonment
- D) Life imprisonment

**Answer:** D) Life imprisonment

---

**Q2.** GDPR applies to:
- A) Only EU companies
- B) Any organization handling EU citizen data
- C) Only government organizations
- D) Only financial companies

**Answer:** B) Any organization handling EU citizen data

---

**Q3.** What makes ethical hacking LEGAL?
- A) Good intentions
- B) Being a certified professional
- C) Written authorization from the asset owner
- D) Using only open-source tools

**Answer:** C) Written authorization from the asset owner

---

**Q4.** In responsible disclosure, you should:
- A) Post the vulnerability on social media immediately
- B) Report to the vendor and wait for a fix before publishing
- C) Sell the vulnerability to the highest bidder
- D) Ignore the vulnerability

**Answer:** B) Report to the vendor and wait for a fix before publishing

---

> **Next Topic:** [17 - Advanced Topics](17-advanced-topics.md)
