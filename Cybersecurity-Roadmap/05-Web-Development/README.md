# 🌐 Web Development Fundamentals

## Understanding Web Applications to Break and Secure Them

---

## 📌 Overview

Before you can hack web applications, you must understand how they work. This section teaches HTML, CSS, JavaScript, HTTP, databases, authentication, and backend development — all from a security perspective.

---

## Why Web Development for Security

| Security Task | Web Knowledge Needed |
|--------------|---------------------|
| Finding XSS | Understanding HTML/JavaScript rendering |
| SQL Injection | Understanding database queries |
| CSRF attacks | Understanding cookies/sessions |
| API testing | Understanding REST/JSON |
| Authentication bypass | Understanding auth flows |
| SSRF | Understanding server-side requests |

---

## HTML Fundamentals

### Structure

```html
<!DOCTYPE html>
<html>
<head>
    <title>Login Page</title>
</head>
<body>
    <h1>Welcome</h1>
    
    <!-- Login form - SECURITY NOTE: action, method matter! -->
    <form action="/login" method="POST">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username">
        
        <label for="password">Password:</label>
        <input type="password" id="password" name="password">
        
        <input type="hidden" name="csrf_token" value="abc123">
        
        <button type="submit">Login</button>
    </form>
</body>
</html>
```

### Security-Relevant HTML Elements

| Element | Security Relevance |
|---------|-------------------|
| `<form>` | Method (GET exposes data in URL), action (where data goes) |
| `<input type="hidden">` | CSRF tokens, hidden parameters (visible in source!) |
| `<a href="javascript:...">` | XSS vector |
| `<img src="...">` | CSRF via GET, SSRF |
| `<iframe>` | Clickjacking |
| `<script>` | XSS injection point |

---

## JavaScript for Security

### DOM Manipulation (XSS Relevance)

```javascript
// Dangerous: directly inserting user input into DOM
document.getElementById("output").innerHTML = userInput;  // XSS!

// Safe: using textContent
document.getElementById("output").textContent = userInput;  // Safe

// Fetch API (understanding AJAX requests)
fetch('/api/users', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    },
    body: JSON.stringify({ username: 'admin', password: 'pass' })
})
.then(response => response.json())
.then(data => console.log(data));

// Cookies (session management)
document.cookie = "session=abc123; Secure; HttpOnly; SameSite=Strict";
// HttpOnly prevents JavaScript access (XSS defense!)
```

---

## HTTP Deep Dive

### Request/Response Cycle

```
Browser → HTTP Request → Web Server → Application → Database
Browser ← HTTP Response ← Web Server ← Application ← Database

GET /profile?id=1 HTTP/1.1       ← What if id=1 OR 1=1?
Host: target.com
Cookie: session=eyJhbGci...      ← What if we modify this?
```

### Cookies vs Sessions vs Tokens

| Mechanism | Storage | Security |
|-----------|---------|----------|
| Cookie | Browser | Can be stolen (XSS), set HttpOnly/Secure |
| Session | Server | Session ID in cookie, server validates |
| JWT Token | Client | Self-contained, verify signature |

---

## SQL and Databases

### Basic SQL (Understanding Injection)

```sql
-- Normal query
SELECT * FROM users WHERE username = 'admin' AND password = 'pass123';

-- SQL Injection: Input: ' OR '1'='1
SELECT * FROM users WHERE username = '' OR '1'='1' AND password = '' OR '1'='1';
-- Returns ALL users! Authentication bypassed!

-- Secure: Parameterized query
-- Python example:
-- cursor.execute("SELECT * FROM users WHERE username = ? AND password = ?", (user, pass))
```

---

## Building a Vulnerable Practice App

```python
# Flask app with INTENTIONAL vulnerabilities for learning
# NEVER deploy this to production!

from flask import Flask, request, render_template_string
import sqlite3

app = Flask(__name__)

@app.route('/search')
def search():
    query = request.args.get('q', '')
    # VULNERABLE TO XSS - reflects user input without sanitization
    return f"<h1>Results for: {query}</h1>"

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    # VULNERABLE TO SQL INJECTION - string concatenation
    sql = f"SELECT * FROM users WHERE username='{username}' AND password='{password}'"
    # This is how NOT to do it!
    return "Login attempted"

if __name__ == '__main__':
    app.run(debug=True)
```

---

## Authentication Systems

### Secure vs Insecure Patterns

| Insecure | Secure | Why |
|----------|--------|-----|
| MD5 password hash | bcrypt/argon2 hash | MD5 is fast to crack |
| Session in URL | Session in HttpOnly cookie | URL visible in logs |
| No rate limiting | Account lockout after N attempts | Prevents brute force |
| Predictable session IDs | Cryptographically random | Prevents session prediction |
| No CSRF token | CSRF token per request | Prevents cross-site forgery |

---

## Exercises

1. Build a login form and understand how credentials flow through HTTP
2. Set up a local database and practice SQL queries
3. Create a simple REST API with Flask/Express
4. Examine requests in browser DevTools (Network tab)
5. Use `curl` to manually craft HTTP requests

---

**Next:** → [06-Cybersecurity-Fundamentals](../06-Cybersecurity-Fundamentals/README.md)

*"You can't hack what you don't understand. Build it first, then break it."*
