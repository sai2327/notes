# 24. Mini Projects

## Table of Contents
- [24.1 Password Generator](#241-password-generator)
- [24.2 Quiz Application](#242-quiz-application)
- [24.3 Expense Tracker](#243-expense-tracker)
- [24.4 URL Shortener](#244-url-shortener)
- [24.5 Weather App (API)](#245-weather-app-api)
- [24.6 Markdown to HTML Converter](#246-markdown-to-html-converter)

---

## 24.1 Password Generator

```python
import random
import string

def generate_password(length=12, uppercase=True, digits=True, special=True):
    """Generate a secure random password."""
    chars = string.ascii_lowercase
    
    if uppercase:
        chars += string.ascii_uppercase
    if digits:
        chars += string.digits
    if special:
        chars += string.punctuation
    
    # Ensure at least one of each required type
    password = []
    if uppercase:
        password.append(random.choice(string.ascii_uppercase))
    if digits:
        password.append(random.choice(string.digits))
    if special:
        password.append(random.choice(string.punctuation))
    
    # Fill remaining length
    remaining = length - len(password)
    password.extend(random.choices(chars, k=remaining))
    
    # Shuffle to randomize positions
    random.shuffle(password)
    return "".join(password)

def check_strength(password):
    """Rate password strength."""
    score = 0
    if len(password) >= 8: score += 1
    if len(password) >= 12: score += 1
    if any(c.isupper() for c in password): score += 1
    if any(c.islower() for c in password): score += 1
    if any(c.isdigit() for c in password): score += 1
    if any(c in string.punctuation for c in password): score += 1
    
    levels = {0: "Very Weak", 1: "Weak", 2: "Fair",
              3: "Moderate", 4: "Strong", 5: "Very Strong", 6: "Excellent"}
    return levels.get(score, "Excellent")

# Demo
for _ in range(5):
    pwd = generate_password(16)
    print(f"{pwd}  |  Strength: {check_strength(pwd)}")
```

---

## 24.2 Quiz Application

```python
import random

class Quiz:
    def __init__(self):
        self.questions = [
            {"q": "What is the output of 2**3?", "options": ["6", "8", "9", "12"], "answer": "8"},
            {"q": "Which is mutable?", "options": ["tuple", "string", "list", "frozenset"], "answer": "list"},
            {"q": "What does len([1,[2,3]]) return?", "options": ["2", "3", "4", "1"], "answer": "2"},
            {"q": "Which keyword creates a generator?", "options": ["return", "yield", "generate", "next"], "answer": "yield"},
            {"q": "What is 'None' in Python?", "options": ["0", "False", "Null object", "Empty string"], "answer": "Null object"},
            {"q": "Which is NOT a Python data type?", "options": ["list", "array", "dict", "tuple"], "answer": "array"},
            {"q": "What does PEP stand for?", "options": ["Python Enhancement Proposal", "Python Execution Plan", "Python Error Protocol", "None"], "answer": "Python Enhancement Proposal"},
            {"q": "Which loop guarantees execution at least once?", "options": ["for", "while", "do-while", "None in Python"], "answer": "None in Python"},
        ]
        self.score = 0
    
    def run(self, num_questions=5):
        selected = random.sample(self.questions, min(num_questions, len(self.questions)))
        
        print("=" * 50)
        print("       PYTHON QUIZ")
        print("=" * 50)
        
        for i, q in enumerate(selected, 1):
            print(f"\nQ{i}. {q['q']}")
            for j, opt in enumerate(q["options"], 1):
                print(f"   {j}. {opt}")
            
            while True:
                try:
                    choice = int(input("Your answer (1-4): "))
                    if 1 <= choice <= 4:
                        break
                except ValueError:
                    pass
                print("Invalid! Enter 1-4.")
            
            selected_answer = q["options"][choice - 1]
            if selected_answer == q["answer"]:
                print("✓ Correct!")
                self.score += 1
            else:
                print(f"✗ Wrong! Answer: {q['answer']}")
        
        print(f"\n{'=' * 50}")
        print(f"Score: {self.score}/{len(selected)} ({self.score/len(selected)*100:.0f}%)")
        
        if self.score == len(selected):
            print("Perfect score!")
        elif self.score >= len(selected) * 0.7:
            print("Good job!")
        else:
            print("Keep practicing!")

# quiz = Quiz()
# quiz.run()
```

---

## 24.3 Expense Tracker

```python
import json
from datetime import datetime
from pathlib import Path

class ExpenseTracker:
    def __init__(self, filename="expenses.json"):
        self.filename = filename
        self.expenses = self._load()
    
    def _load(self):
        if Path(self.filename).exists():
            with open(self.filename, "r") as f:
                return json.load(f)
        return []
    
    def _save(self):
        with open(self.filename, "w") as f:
            json.dump(self.expenses, f, indent=2)
    
    def add(self, amount, category, description=""):
        expense = {
            "id": len(self.expenses) + 1,
            "amount": amount,
            "category": category,
            "description": description,
            "date": datetime.now().strftime("%Y-%m-%d %H:%M")
        }
        self.expenses.append(expense)
        self._save()
        print(f"Added: ${amount:.2f} ({category})")
    
    def summary(self):
        if not self.expenses:
            print("No expenses recorded.")
            return
        
        total = sum(e["amount"] for e in self.expenses)
        by_category = {}
        for e in self.expenses:
            cat = e["category"]
            by_category[cat] = by_category.get(cat, 0) + e["amount"]
        
        print(f"\n{'=' * 40}")
        print(f"  EXPENSE SUMMARY")
        print(f"{'=' * 40}")
        print(f"  Total: ${total:.2f}")
        print(f"  Count: {len(self.expenses)} transactions")
        print(f"\n  By Category:")
        for cat, amt in sorted(by_category.items(), key=lambda x: -x[1]):
            pct = (amt / total) * 100
            bar = "█" * int(pct / 5)
            print(f"    {cat:12s}: ${amt:8.2f} ({pct:4.1f}%) {bar}")
    
    def list_recent(self, n=10):
        recent = self.expenses[-n:]
        for e in reversed(recent):
            print(f"  [{e['date']}] ${e['amount']:.2f} - {e['category']} - {e['description']}")

# Demo
tracker = ExpenseTracker()
tracker.add(45.99, "Food", "Groceries")
tracker.add(120.00, "Transport", "Monthly pass")
tracker.add(15.50, "Food", "Lunch")
tracker.add(9.99, "Entertainment", "Netflix")
tracker.add(85.00, "Utilities", "Electric bill")
tracker.summary()
```

---

## 24.4 URL Shortener

```python
import hashlib
import json
from pathlib import Path

class URLShortener:
    def __init__(self, base_url="http://short.url/"):
        self.base_url = base_url
        self.db_file = "urls.json"
        self.urls = self._load()
    
    def _load(self):
        if Path(self.db_file).exists():
            with open(self.db_file, "r") as f:
                return json.load(f)
        return {}
    
    def _save(self):
        with open(self.db_file, "w") as f:
            json.dump(self.urls, f, indent=2)
    
    def shorten(self, long_url):
        # Generate short code from URL hash
        hash_obj = hashlib.md5(long_url.encode())
        short_code = hash_obj.hexdigest()[:6]
        
        self.urls[short_code] = {
            "url": long_url,
            "clicks": 0
        }
        self._save()
        return f"{self.base_url}{short_code}"
    
    def resolve(self, short_code):
        if short_code in self.urls:
            self.urls[short_code]["clicks"] += 1
            self._save()
            return self.urls[short_code]["url"]
        return None
    
    def stats(self):
        print(f"\n{'Code':<8} {'Clicks':<8} {'URL'}")
        print("-" * 60)
        for code, data in self.urls.items():
            print(f"{code:<8} {data['clicks']:<8} {data['url'][:40]}")

# Demo
shortener = URLShortener()
short = shortener.shorten("https://www.example.com/very/long/path/to/page")
print(f"Short URL: {short}")

resolved = shortener.resolve(short.split("/")[-1])
print(f"Resolved: {resolved}")
shortener.stats()
```

---

## 24.5 Weather App (API)

```python
import requests
import json

class WeatherApp:
    def __init__(self, api_key="your_api_key"):
        self.api_key = api_key
        self.base_url = "https://api.openweathermap.org/data/2.5/weather"
    
    def get_weather(self, city):
        params = {
            "q": city,
            "appid": self.api_key,
            "units": "metric"
        }
        
        try:
            response = requests.get(self.base_url, params=params, timeout=10)
            response.raise_for_status()
            data = response.json()
            
            weather_info = {
                "city": data["name"],
                "country": data["sys"]["country"],
                "temp": data["main"]["temp"],
                "feels_like": data["main"]["feels_like"],
                "humidity": data["main"]["humidity"],
                "description": data["weather"][0]["description"],
                "wind_speed": data["wind"]["speed"]
            }
            return weather_info
            
        except requests.exceptions.RequestException as e:
            return {"error": str(e)}
    
    def display(self, city):
        info = self.get_weather(city)
        
        if "error" in info:
            print(f"Error: {info['error']}")
            return
        
        print(f"\n{'=' * 35}")
        print(f"  Weather: {info['city']}, {info['country']}")
        print(f"{'=' * 35}")
        print(f"  Temperature: {info['temp']}°C")
        print(f"  Feels like:  {info['feels_like']}°C")
        print(f"  Humidity:    {info['humidity']}%")
        print(f"  Condition:   {info['description']}")
        print(f"  Wind:        {info['wind_speed']} m/s")

# Demo (requires API key from openweathermap.org)
# app = WeatherApp("your_api_key_here")
# app.display("London")
```

---

## 24.6 Markdown to HTML Converter

```python
import re

def markdown_to_html(md_text):
    """Simple Markdown to HTML converter."""
    lines = md_text.split("\n")
    html_lines = []
    in_code_block = False
    in_list = False
    
    for line in lines:
        # Code blocks
        if line.startswith("```"):
            if in_code_block:
                html_lines.append("</code></pre>")
                in_code_block = False
            else:
                html_lines.append("<pre><code>")
                in_code_block = True
            continue
        
        if in_code_block:
            html_lines.append(line)
            continue
        
        # Headers
        if line.startswith("### "):
            html_lines.append(f"<h3>{line[4:]}</h3>")
        elif line.startswith("## "):
            html_lines.append(f"<h2>{line[3:]}</h2>")
        elif line.startswith("# "):
            html_lines.append(f"<h1>{line[2:]}</h1>")
        # Lists
        elif line.startswith("- "):
            if not in_list:
                html_lines.append("<ul>")
                in_list = True
            html_lines.append(f"  <li>{line[2:]}</li>")
        else:
            if in_list:
                html_lines.append("</ul>")
                in_list = False
            if line.strip():
                # Inline formatting
                line = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', line)
                line = re.sub(r'\*(.+?)\*', r'<em>\1</em>', line)
                line = re.sub(r'`(.+?)`', r'<code>\1</code>', line)
                html_lines.append(f"<p>{line}</p>")
    
    if in_list:
        html_lines.append("</ul>")
    
    return "\n".join(html_lines)

# Demo
md = """# Hello World

This is **bold** and *italic* text with `code`.

## Features

- Fast conversion
- Simple syntax
- Code blocks supported

### Example

```
print("Hello!")
```
"""

html = markdown_to_html(md)
print(html)
```

---

> **Next Topic:** [25 - Final Projects](25-final-projects.md)
