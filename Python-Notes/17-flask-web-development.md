# 17. Flask Web Development

## Table of Contents
- [17.1 Introduction to Flask](#171-introduction-to-flask)
- [17.2 Routing and Views](#172-routing-and-views)
- [17.3 Templates (Jinja2)](#173-templates-jinja2)
- [17.4 Forms and User Input](#174-forms-and-user-input)
- [17.5 REST APIs with Flask](#175-rest-apis-with-flask)
- [17.6 Authentication Basics](#176-authentication-basics)
- [17.7 Practice & Assessment](#177-practice--assessment)

---

## 17.1 Introduction to Flask

### What is Flask?
**Flask** is a lightweight Python web framework — a "micro-framework" with minimal core but highly extensible.

### Flask vs Django

| Feature | Flask | Django |
|---------|-------|--------|
| Type | Micro-framework | Full framework |
| Complexity | Simple, minimal | Batteries-included |
| ORM | Not included (use SQLAlchemy) | Built-in |
| Admin panel | Not included | Built-in |
| Best for | APIs, small-medium apps | Large apps, CMS |
| Learning curve | Easy | Moderate |

### Architecture

```
┌─────────────────────────────────────────────────────┐
│  FLASK REQUEST/RESPONSE CYCLE                        │
│                                                     │
│  Browser ──► Route ──► View Function ──► Response   │
│                              │                      │
│                         ┌────┴────┐                 │
│                         │ Template│                  │
│                         │ (HTML)  │                  │
│                         └────┬────┘                  │
│                              │                      │
│                         ┌────┴────┐                 │
│                         │Database │                  │
│                         └─────────┘                  │
└─────────────────────────────────────────────────────┘
```

### Setup and First App

```python
# Install: pip install flask

from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "<h1>Hello, Flask!</h1>"

@app.route("/about")
def about():
    return "<h1>About Page</h1>"

if __name__ == "__main__":
    app.run(debug=True)  # Run on http://127.0.0.1:5000
```

---

## 17.2 Routing and Views

```python
from flask import Flask, request, redirect, url_for

app = Flask(__name__)

# Basic route
@app.route("/")
def home():
    return "Home Page"

# Route with variable
@app.route("/user/<username>")
def profile(username):
    return f"Profile: {username}"

# Type converters
@app.route("/post/<int:post_id>")
def show_post(post_id):
    return f"Post #{post_id}"

# Multiple HTTP methods
@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form["username"]
        return f"Logged in as {username}"
    return '''
        <form method="post">
            <input name="username" placeholder="Username">
            <button type="submit">Login</button>
        </form>
    '''

# Redirect
@app.route("/old-page")
def old_page():
    return redirect(url_for("home"))

# Query parameters: /search?q=python
@app.route("/search")
def search():
    query = request.args.get("q", "")
    return f"Searching for: {query}"
```

---

## 17.3 Templates (Jinja2)

### Project Structure
```
my_app/
├── app.py
├── templates/
│   ├── base.html
│   ├── index.html
│   └── profile.html
└── static/
    ├── css/style.css
    └── js/script.js
```

### Base Template (base.html)

```html
<!DOCTYPE html>
<html>
<head>
    <title>{% block title %}My App{% endblock %}</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='css/style.css') }}">
</head>
<body>
    <nav>
        <a href="{{ url_for('home') }}">Home</a>
        <a href="{{ url_for('about') }}">About</a>
    </nav>
    
    <main>
        {% block content %}{% endblock %}
    </main>
    
    <footer>© 2024 My App</footer>
</body>
</html>
```

### Child Template (index.html)

```html
{% extends "base.html" %}

{% block title %}Home{% endblock %}

{% block content %}
    <h1>Welcome, {{ user.name }}!</h1>
    
    {% if user.is_admin %}
        <p>Admin Panel Available</p>
    {% endif %}
    
    <h2>Items:</h2>
    <ul>
    {% for item in items %}
        <li>{{ item.name }} — ${{ item.price }}</li>
    {% endfor %}
    </ul>
{% endblock %}
```

### Rendering Templates

```python
from flask import render_template

@app.route("/")
def home():
    user = {"name": "Alice", "is_admin": True}
    items = [
        {"name": "Laptop", "price": 999},
        {"name": "Phone", "price": 699}
    ]
    return render_template("index.html", user=user, items=items)
```

---

## 17.4 Forms and User Input

```python
from flask import Flask, request, render_template, flash, redirect, url_for

app = Flask(__name__)
app.secret_key = "your-secret-key"  # Required for flash messages

@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        username = request.form.get("username")
        email = request.form.get("email")
        password = request.form.get("password")
        
        # Validation
        if not username or not email or not password:
            flash("All fields are required!", "error")
            return redirect(url_for("register"))
        
        if len(password) < 6:
            flash("Password must be at least 6 characters!", "error")
            return redirect(url_for("register"))
        
        # Process registration
        flash("Registration successful!", "success")
        return redirect(url_for("home"))
    
    return render_template("register.html")
```

---

## 17.5 REST APIs with Flask

```python
from flask import Flask, jsonify, request

app = Flask(__name__)

# In-memory database
books = [
    {"id": 1, "title": "Python 101", "author": "Alice"},
    {"id": 2, "title": "Flask Web Dev", "author": "Bob"},
    {"id": 3, "title": "Data Science", "author": "Charlie"}
]

# GET all books
@app.route("/api/books", methods=["GET"])
def get_books():
    return jsonify({"books": books, "count": len(books)})

# GET single book
@app.route("/api/books/<int:book_id>", methods=["GET"])
def get_book(book_id):
    book = next((b for b in books if b["id"] == book_id), None)
    if book is None:
        return jsonify({"error": "Book not found"}), 404
    return jsonify(book)

# POST create book
@app.route("/api/books", methods=["POST"])
def create_book():
    data = request.get_json()
    if not data or "title" not in data or "author" not in data:
        return jsonify({"error": "Title and author required"}), 400
    
    new_book = {
        "id": max(b["id"] for b in books) + 1 if books else 1,
        "title": data["title"],
        "author": data["author"]
    }
    books.append(new_book)
    return jsonify(new_book), 201

# PUT update book
@app.route("/api/books/<int:book_id>", methods=["PUT"])
def update_book(book_id):
    book = next((b for b in books if b["id"] == book_id), None)
    if book is None:
        return jsonify({"error": "Book not found"}), 404
    
    data = request.get_json()
    book["title"] = data.get("title", book["title"])
    book["author"] = data.get("author", book["author"])
    return jsonify(book)

# DELETE book
@app.route("/api/books/<int:book_id>", methods=["DELETE"])
def delete_book(book_id):
    global books
    books = [b for b in books if b["id"] != book_id]
    return jsonify({"message": "Deleted"}), 200

if __name__ == "__main__":
    app.run(debug=True)
```

### Testing with curl/requests

```python
import requests

BASE = "http://127.0.0.1:5000/api/books"

# GET all
r = requests.get(BASE)
print(r.json())

# POST new book
r = requests.post(BASE, json={"title": "ML Guide", "author": "Diana"})
print(r.json())

# PUT update
r = requests.put(f"{BASE}/1", json={"title": "Python Advanced"})
print(r.json())

# DELETE
r = requests.delete(f"{BASE}/2")
print(r.status_code)
```

---

## 17.6 Authentication Basics

```python
from flask import Flask, request, jsonify, session
from functools import wraps
import hashlib

app = Flask(__name__)
app.secret_key = "super-secret-key"

# Simple user store
users = {}

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

# Login required decorator
def login_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if "user" not in session:
            return jsonify({"error": "Login required"}), 401
        return f(*args, **kwargs)
    return decorated

@app.route("/api/register", methods=["POST"])
def register():
    data = request.get_json()
    username = data.get("username")
    password = data.get("password")
    
    if username in users:
        return jsonify({"error": "User exists"}), 400
    
    users[username] = hash_password(password)
    return jsonify({"message": "Registered"}), 201

@app.route("/api/login", methods=["POST"])
def login():
    data = request.get_json()
    username = data.get("username")
    password = data.get("password")
    
    if username not in users or users[username] != hash_password(password):
        return jsonify({"error": "Invalid credentials"}), 401
    
    session["user"] = username
    return jsonify({"message": f"Welcome, {username}!"})

@app.route("/api/dashboard")
@login_required
def dashboard():
    return jsonify({"message": f"Hello, {session['user']}! This is protected."})

@app.route("/api/logout", methods=["POST"])
def logout():
    session.pop("user", None)
    return jsonify({"message": "Logged out"})
```

---

## 17.7 Practice & Assessment

### MCQs

**Q1.** What does `@app.route("/")` do?
- A) Creates a file
- B) Maps URL "/" to a function
- C) Imports a module
- D) Creates a template

**Answer:** B

---

**Q2.** Which HTTP method is used to create a new resource?
- A) GET
- B) POST
- C) PUT
- D) DELETE

**Answer:** B

---

### Coding Task

**Task:** Create a REST API for a TODO app with CRUD operations.

```python
from flask import Flask, jsonify, request

app = Flask(__name__)
todos = []

@app.route("/api/todos", methods=["GET"])
def get_todos():
    return jsonify(todos)

@app.route("/api/todos", methods=["POST"])
def add_todo():
    data = request.get_json()
    todo = {
        "id": len(todos) + 1,
        "task": data["task"],
        "done": False
    }
    todos.append(todo)
    return jsonify(todo), 201

@app.route("/api/todos/<int:todo_id>", methods=["PUT"])
def update_todo(todo_id):
    todo = next((t for t in todos if t["id"] == todo_id), None)
    if not todo:
        return jsonify({"error": "Not found"}), 404
    todo["done"] = not todo["done"]
    return jsonify(todo)

@app.route("/api/todos/<int:todo_id>", methods=["DELETE"])
def delete_todo(todo_id):
    global todos
    todos = [t for t in todos if t["id"] != todo_id]
    return "", 204
```

---

> **Next Topic:** [18 - Databases](18-databases.md)
