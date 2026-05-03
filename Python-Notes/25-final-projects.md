# 25. Final Projects

## Table of Contents
- [25.1 Student Management System (OOP + Database)](#251-student-management-system)
- [25.2 REST API Blog Application (Flask)](#252-rest-api-blog-application)
- [25.3 Data Analysis Dashboard (Pandas + Visualization)](#253-data-analysis-dashboard)
- [25.4 ML Prediction App (Scikit-learn + Flask)](#254-ml-prediction-app)

---

## 25.1 Student Management System

### Architecture

```
┌────────────────────────────────────────────────────────┐
│  STUDENT MANAGEMENT SYSTEM                              │
│                                                        │
│  ┌──────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │   CLI    │─►│  StudentMgr  │─►│   SQLite DB  │    │
│  │Interface │  │  (Business)  │  │  (Storage)   │    │
│  └──────────┘  └──────────────┘  └──────────────┘    │
└────────────────────────────────────────────────────────┘
```

### Implementation

```python
import sqlite3
from datetime import datetime

class Database:
    def __init__(self, db_name="students.db"):
        self.conn = sqlite3.connect(db_name)
        self.conn.row_factory = sqlite3.Row
        self._create_tables()
    
    def _create_tables(self):
        self.conn.executescript("""
            CREATE TABLE IF NOT EXISTS students (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                email TEXT UNIQUE NOT NULL,
                age INTEGER,
                course TEXT,
                gpa REAL DEFAULT 0.0,
                enrolled_date TEXT DEFAULT CURRENT_DATE
            );
            
            CREATE TABLE IF NOT EXISTS grades (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                student_id INTEGER,
                subject TEXT NOT NULL,
                score REAL NOT NULL,
                FOREIGN KEY (student_id) REFERENCES students(id)
            );
        """)
        self.conn.commit()
    
    def execute(self, query, params=()):
        cursor = self.conn.execute(query, params)
        self.conn.commit()
        return cursor
    
    def fetchall(self, query, params=()):
        return [dict(row) for row in self.conn.execute(query, params).fetchall()]
    
    def fetchone(self, query, params=()):
        row = self.conn.execute(query, params).fetchone()
        return dict(row) if row else None


class StudentManager:
    def __init__(self):
        self.db = Database()
    
    def add_student(self, name, email, age, course):
        try:
            self.db.execute(
                "INSERT INTO students (name, email, age, course) VALUES (?, ?, ?, ?)",
                (name, email, age, course)
            )
            print(f"Student '{name}' added successfully.")
        except sqlite3.IntegrityError:
            print(f"Error: Email '{email}' already exists.")
    
    def get_all_students(self):
        return self.db.fetchall("SELECT * FROM students ORDER BY name")
    
    def search(self, keyword):
        return self.db.fetchall(
            "SELECT * FROM students WHERE name LIKE ? OR course LIKE ?",
            (f"%{keyword}%", f"%{keyword}%")
        )
    
    def add_grade(self, student_id, subject, score):
        self.db.execute(
            "INSERT INTO grades (student_id, subject, score) VALUES (?, ?, ?)",
            (student_id, subject, score)
        )
        # Update GPA
        grades = self.db.fetchall(
            "SELECT score FROM grades WHERE student_id = ?", (student_id,)
        )
        avg = sum(g["score"] for g in grades) / len(grades)
        self.db.execute("UPDATE students SET gpa = ? WHERE id = ?", (avg, student_id))
        print(f"Grade added. New GPA: {avg:.2f}")
    
    def get_report(self, student_id):
        student = self.db.fetchone("SELECT * FROM students WHERE id = ?", (student_id,))
        grades = self.db.fetchall(
            "SELECT subject, score FROM grades WHERE student_id = ?", (student_id,)
        )
        return {"student": student, "grades": grades}
    
    def get_statistics(self):
        stats = self.db.fetchone("""
            SELECT COUNT(*) as total, AVG(gpa) as avg_gpa,
                   MAX(gpa) as max_gpa, MIN(gpa) as min_gpa
            FROM students
        """)
        by_course = self.db.fetchall("""
            SELECT course, COUNT(*) as count, AVG(gpa) as avg_gpa
            FROM students GROUP BY course ORDER BY avg_gpa DESC
        """)
        return {"overall": stats, "by_course": by_course}
    
    def delete_student(self, student_id):
        self.db.execute("DELETE FROM grades WHERE student_id = ?", (student_id,))
        self.db.execute("DELETE FROM students WHERE id = ?", (student_id,))
        print("Student deleted.")


def main():
    mgr = StudentManager()
    
    # Add sample data
    mgr.add_student("Alice Johnson", "alice@uni.edu", 20, "Computer Science")
    mgr.add_student("Bob Smith", "bob@uni.edu", 22, "Mathematics")
    mgr.add_student("Charlie Brown", "charlie@uni.edu", 21, "Computer Science")
    
    mgr.add_grade(1, "Python", 92)
    mgr.add_grade(1, "Algorithms", 88)
    mgr.add_grade(2, "Calculus", 95)
    mgr.add_grade(3, "Databases", 85)
    
    # Display all students
    print("\n--- All Students ---")
    for s in mgr.get_all_students():
        print(f"  {s['id']}. {s['name']} | {s['course']} | GPA: {s['gpa']:.2f}")
    
    # Statistics
    stats = mgr.get_statistics()
    print(f"\n--- Statistics ---")
    print(f"  Total students: {stats['overall']['total']}")
    print(f"  Average GPA: {stats['overall']['avg_gpa']:.2f}")

if __name__ == "__main__":
    main()
```

---

## 25.2 REST API Blog Application

```python
from flask import Flask, jsonify, request
from datetime import datetime
import sqlite3

app = Flask(__name__)

def get_db():
    conn = sqlite3.connect("blog.db")
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    with get_db() as conn:
        conn.executescript("""
            CREATE TABLE IF NOT EXISTS posts (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                content TEXT NOT NULL,
                author TEXT NOT NULL,
                created_at TEXT DEFAULT CURRENT_TIMESTAMP,
                updated_at TEXT DEFAULT CURRENT_TIMESTAMP
            );
            CREATE TABLE IF NOT EXISTS comments (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                post_id INTEGER,
                author TEXT NOT NULL,
                content TEXT NOT NULL,
                created_at TEXT DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (post_id) REFERENCES posts(id)
            );
        """)

init_db()

# --- POSTS ---

@app.route("/api/posts", methods=["GET"])
def get_posts():
    page = request.args.get("page", 1, type=int)
    per_page = request.args.get("per_page", 10, type=int)
    offset = (page - 1) * per_page
    
    with get_db() as conn:
        posts = conn.execute(
            "SELECT * FROM posts ORDER BY created_at DESC LIMIT ? OFFSET ?",
            (per_page, offset)
        ).fetchall()
        total = conn.execute("SELECT COUNT(*) FROM posts").fetchone()[0]
    
    return jsonify({
        "posts": [dict(p) for p in posts],
        "total": total,
        "page": page,
        "pages": (total + per_page - 1) // per_page
    })

@app.route("/api/posts/<int:post_id>", methods=["GET"])
def get_post(post_id):
    with get_db() as conn:
        post = conn.execute("SELECT * FROM posts WHERE id = ?", (post_id,)).fetchone()
        if not post:
            return jsonify({"error": "Post not found"}), 404
        
        comments = conn.execute(
            "SELECT * FROM comments WHERE post_id = ? ORDER BY created_at DESC",
            (post_id,)
        ).fetchall()
    
    return jsonify({
        "post": dict(post),
        "comments": [dict(c) for c in comments]
    })

@app.route("/api/posts", methods=["POST"])
def create_post():
    data = request.get_json()
    
    if not data or not all(k in data for k in ["title", "content", "author"]):
        return jsonify({"error": "title, content, and author required"}), 400
    
    with get_db() as conn:
        cursor = conn.execute(
            "INSERT INTO posts (title, content, author) VALUES (?, ?, ?)",
            (data["title"], data["content"], data["author"])
        )
    
    return jsonify({"id": cursor.lastrowid, "message": "Post created"}), 201

@app.route("/api/posts/<int:post_id>", methods=["PUT"])
def update_post(post_id):
    data = request.get_json()
    
    with get_db() as conn:
        post = conn.execute("SELECT * FROM posts WHERE id = ?", (post_id,)).fetchone()
        if not post:
            return jsonify({"error": "Post not found"}), 404
        
        conn.execute("""
            UPDATE posts SET title = ?, content = ?, updated_at = ?
            WHERE id = ?
        """, (
            data.get("title", post["title"]),
            data.get("content", post["content"]),
            datetime.now().isoformat(),
            post_id
        ))
    
    return jsonify({"message": "Post updated"})

@app.route("/api/posts/<int:post_id>", methods=["DELETE"])
def delete_post(post_id):
    with get_db() as conn:
        conn.execute("DELETE FROM comments WHERE post_id = ?", (post_id,))
        conn.execute("DELETE FROM posts WHERE id = ?", (post_id,))
    return jsonify({"message": "Post deleted"})

# --- COMMENTS ---

@app.route("/api/posts/<int:post_id>/comments", methods=["POST"])
def add_comment(post_id):
    data = request.get_json()
    
    if not data or "content" not in data or "author" not in data:
        return jsonify({"error": "content and author required"}), 400
    
    with get_db() as conn:
        conn.execute(
            "INSERT INTO comments (post_id, author, content) VALUES (?, ?, ?)",
            (post_id, data["author"], data["content"])
        )
    
    return jsonify({"message": "Comment added"}), 201

# --- SEARCH ---

@app.route("/api/search", methods=["GET"])
def search_posts():
    q = request.args.get("q", "")
    if not q:
        return jsonify({"error": "Query parameter 'q' required"}), 400
    
    with get_db() as conn:
        posts = conn.execute(
            "SELECT * FROM posts WHERE title LIKE ? OR content LIKE ?",
            (f"%{q}%", f"%{q}%")
        ).fetchall()
    
    return jsonify({"results": [dict(p) for p in posts], "count": len(posts)})

if __name__ == "__main__":
    app.run(debug=True)
```

---

## 25.3 Data Analysis Dashboard

```python
"""Sales Data Analysis Project"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Generate sample sales data
np.random.seed(42)
n = 1000

data = pd.DataFrame({
    "date": pd.date_range("2023-01-01", periods=n, freq="D"),
    "product": np.random.choice(["Laptop", "Phone", "Tablet", "Headphones", "Watch"], n),
    "region": np.random.choice(["North", "South", "East", "West"], n),
    "quantity": np.random.randint(1, 20, n),
    "unit_price": np.random.choice([999, 699, 499, 99, 299], n),
    "customer_type": np.random.choice(["New", "Returning"], n, p=[0.4, 0.6])
})
data["revenue"] = data["quantity"] * data["unit_price"]
data["month"] = data["date"].dt.to_period("M")

# === ANALYSIS ===

print("=" * 60)
print("  SALES ANALYSIS REPORT")
print("=" * 60)

# 1. Overall Summary
print(f"\n📊 Overall Summary:")
print(f"   Total Revenue: ${data['revenue'].sum():,.0f}")
print(f"   Total Orders:  {len(data):,}")
print(f"   Avg Order Value: ${data['revenue'].mean():,.0f}")
print(f"   Date Range: {data['date'].min().date()} to {data['date'].max().date()}")

# 2. Revenue by Product
print(f"\n📦 Revenue by Product:")
product_rev = data.groupby("product")["revenue"].agg(["sum", "mean", "count"])
product_rev.columns = ["Total", "Average", "Orders"]
product_rev = product_rev.sort_values("Total", ascending=False)
print(product_rev.to_string())

# 3. Monthly Trend
monthly = data.groupby("month")["revenue"].sum()
print(f"\n📈 Monthly Revenue Trend (first 6 months):")
for month, rev in list(monthly.items())[:6]:
    bar = "█" * int(rev / monthly.max() * 30)
    print(f"   {month}: ${rev:>10,.0f} {bar}")

# 4. Regional Performance
print(f"\n🌍 Regional Performance:")
regional = data.groupby("region").agg(
    revenue=("revenue", "sum"),
    orders=("quantity", "sum"),
    avg_order=("revenue", "mean")
).sort_values("revenue", ascending=False)
print(regional.to_string())

# 5. Customer Insights
print(f"\n👥 Customer Type Analysis:")
customer = data.groupby("customer_type").agg(
    revenue=("revenue", "sum"),
    orders=("quantity", "count"),
    avg_spend=("revenue", "mean")
)
print(customer.to_string())

# === VISUALIZATION ===

fig, axes = plt.subplots(2, 2, figsize=(14, 10))
fig.suptitle("Sales Dashboard", fontsize=16, fontweight="bold")

# Revenue by product
product_totals = data.groupby("product")["revenue"].sum().sort_values()
axes[0, 0].barh(product_totals.index, product_totals.values, color="steelblue")
axes[0, 0].set_title("Revenue by Product")
axes[0, 0].set_xlabel("Revenue ($)")

# Monthly trend
monthly_data = data.groupby(data["date"].dt.to_period("M"))["revenue"].sum()
axes[0, 1].plot(range(len(monthly_data)), monthly_data.values, "b-o", linewidth=2)
axes[0, 1].set_title("Monthly Revenue Trend")
axes[0, 1].set_ylabel("Revenue ($)")

# Regional pie
region_rev = data.groupby("region")["revenue"].sum()
axes[1, 0].pie(region_rev, labels=region_rev.index, autopct="%1.1f%%", startangle=90)
axes[1, 0].set_title("Revenue by Region")

# Customer type comparison
customer_data = data.groupby(["customer_type", "product"])["revenue"].sum().unstack()
customer_data.plot(kind="bar", ax=axes[1, 1])
axes[1, 1].set_title("Revenue: Customer Type × Product")
axes[1, 1].legend(fontsize=8)
axes[1, 1].tick_params(axis="x", rotation=0)

plt.tight_layout()
plt.savefig("sales_dashboard.png", dpi=150, bbox_inches="tight")
plt.show()
print("\nDashboard saved to sales_dashboard.png")
```

---

## 25.4 ML Prediction App

```python
"""House Price Prediction with Flask API"""
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.metrics import mean_squared_error, r2_score
import json

# === MODEL TRAINING ===

class HousePriceModel:
    def __init__(self):
        self.model = None
        self.scaler = StandardScaler()
        self.features = ["sqft", "bedrooms", "bathrooms", "age", "garage"]
    
    def generate_data(self, n=1000):
        """Generate synthetic housing data."""
        np.random.seed(42)
        data = pd.DataFrame({
            "sqft": np.random.randint(800, 4000, n),
            "bedrooms": np.random.randint(1, 6, n),
            "bathrooms": np.random.randint(1, 4, n),
            "age": np.random.randint(0, 50, n),
            "garage": np.random.randint(0, 3, n)
        })
        
        # Price formula with noise
        data["price"] = (
            data["sqft"] * 150 +
            data["bedrooms"] * 20000 +
            data["bathrooms"] * 15000 -
            data["age"] * 1000 +
            data["garage"] * 25000 +
            np.random.randn(n) * 20000 +
            100000
        )
        return data
    
    def train(self):
        data = self.generate_data()
        X = data[self.features]
        y = data["price"]
        
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42
        )
        
        X_train_scaled = self.scaler.fit_transform(X_train)
        X_test_scaled = self.scaler.transform(X_test)
        
        self.model = GradientBoostingRegressor(
            n_estimators=200, max_depth=4, random_state=42
        )
        self.model.fit(X_train_scaled, y_train)
        
        # Evaluate
        y_pred = self.model.predict(X_test_scaled)
        rmse = np.sqrt(mean_squared_error(y_test, y_pred))
        r2 = r2_score(y_test, y_pred)
        
        print(f"Model trained!")
        print(f"  RMSE: ${rmse:,.0f}")
        print(f"  R² Score: {r2:.4f}")
        
        # Feature importance
        importance = pd.Series(
            self.model.feature_importances_, index=self.features
        ).sort_values(ascending=False)
        print(f"\nFeature Importance:")
        for feat, imp in importance.items():
            bar = "█" * int(imp * 40)
            print(f"  {feat:12s}: {imp:.3f} {bar}")
        
        return {"rmse": rmse, "r2": r2}
    
    def predict(self, features_dict):
        """Predict price for a single house."""
        X = np.array([[features_dict[f] for f in self.features]])
        X_scaled = self.scaler.transform(X)
        price = self.model.predict(X_scaled)[0]
        return round(price, 2)


# === FLASK API ===

from flask import Flask, jsonify, request

app = Flask(__name__)
model = HousePriceModel()
metrics = model.train()

@app.route("/api/predict", methods=["POST"])
def predict():
    data = request.get_json()
    
    # Validate input
    required = ["sqft", "bedrooms", "bathrooms", "age", "garage"]
    missing = [f for f in required if f not in data]
    if missing:
        return jsonify({"error": f"Missing fields: {missing}"}), 400
    
    try:
        price = model.predict(data)
        return jsonify({
            "predicted_price": price,
            "formatted": f"${price:,.0f}",
            "input": data
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/api/model-info", methods=["GET"])
def model_info():
    return jsonify({
        "model": "GradientBoostingRegressor",
        "features": model.features,
        "metrics": {"rmse": round(metrics["rmse"], 2), "r2": round(metrics["r2"], 4)},
        "feature_importance": dict(zip(
            model.features,
            model.model.feature_importances_.tolist()
        ))
    })

@app.route("/api/batch-predict", methods=["POST"])
def batch_predict():
    data = request.get_json()
    if not isinstance(data, list):
        return jsonify({"error": "Expected array of houses"}), 400
    
    results = []
    for house in data:
        try:
            price = model.predict(house)
            results.append({"input": house, "price": price})
        except Exception as e:
            results.append({"input": house, "error": str(e)})
    
    return jsonify({"predictions": results, "count": len(results)})

if __name__ == "__main__":
    print("\n--- Testing Predictions ---")
    test_houses = [
        {"sqft": 2000, "bedrooms": 3, "bathrooms": 2, "age": 10, "garage": 2},
        {"sqft": 1200, "bedrooms": 2, "bathrooms": 1, "age": 30, "garage": 1},
        {"sqft": 3500, "bedrooms": 5, "bathrooms": 3, "age": 5, "garage": 2},
    ]
    
    for house in test_houses:
        price = model.predict(house)
        print(f"  {house['sqft']}sqft, {house['bedrooms']}bd/{house['bathrooms']}ba, "
              f"{house['age']}yr, {house['garage']}gar → ${price:,.0f}")
    
    print("\nStarting Flask API on http://127.0.0.1:5000")
    # app.run(debug=True)
```

---

## Summary

These projects demonstrate:

| Project | Skills Used |
|---------|-------------|
| Student System | OOP, SQLite, CRUD, relationships |
| Blog API | Flask, REST, pagination, search |
| Data Dashboard | Pandas, Matplotlib, analysis |
| ML App | Scikit-learn, Flask API, prediction |

---

> **Congratulations!** You've completed the entire Python Notes series — from basics to advanced projects. 🎉
