# 21. Scripting & Automation

## Table of Contents
- [21.1 OS and System Tasks](#211-os-and-system-tasks)
- [21.2 File Automation](#212-file-automation)
- [21.3 Web Scraping](#213-web-scraping)
- [21.4 Email Automation](#214-email-automation)
- [21.5 Task Scheduling](#215-task-scheduling)
- [21.6 Practice & Assessment](#216-practice--assessment)

---

## 21.1 OS and System Tasks

```python
import os
import shutil
import subprocess
from pathlib import Path

# Current directory
print(os.getcwd())

# List files
for item in os.listdir("."):
    print(item)

# Create directories
os.makedirs("project/data/raw", exist_ok=True)

# Rename / Move
os.rename("old_name.txt", "new_name.txt")
shutil.move("file.txt", "project/file.txt")

# Copy files and directories
shutil.copy2("source.txt", "dest.txt")         # Copy with metadata
shutil.copytree("src_dir", "dest_dir")         # Copy entire directory

# Delete
os.remove("file.txt")                           # Single file
shutil.rmtree("directory")                      # Entire directory

# File info
stat = os.stat("file.txt")
print(f"Size: {stat.st_size} bytes")
print(f"Modified: {stat.st_mtime}")

# Run system commands
result = subprocess.run(["ping", "-c", "3", "google.com"],
                       capture_output=True, text=True)
print(result.stdout)
```

### Pathlib (Modern Approach)

```python
from pathlib import Path

# Create path
p = Path("project") / "data" / "output.csv"
print(p)               # project/data/output.csv
print(p.name)          # output.csv
print(p.stem)          # output
print(p.suffix)        # .csv
print(p.parent)        # project/data

# File operations
p.parent.mkdir(parents=True, exist_ok=True)
p.write_text("col1,col2\n1,2\n3,4")
content = p.read_text()

# Glob — find files
for py_file in Path(".").rglob("*.py"):
    print(py_file)
```

---

## 21.2 File Automation

### Organize Files by Extension

```python
import os
import shutil
from pathlib import Path

def organize_downloads(download_dir):
    """Sort files into folders by type."""
    categories = {
        "Images": [".jpg", ".jpeg", ".png", ".gif", ".svg", ".webp"],
        "Documents": [".pdf", ".doc", ".docx", ".txt", ".xlsx", ".pptx"],
        "Videos": [".mp4", ".avi", ".mkv", ".mov"],
        "Audio": [".mp3", ".wav", ".flac", ".aac"],
        "Archives": [".zip", ".rar", ".7z", ".tar", ".gz"],
        "Code": [".py", ".js", ".html", ".css", ".java", ".cpp"]
    }
    
    download_path = Path(download_dir)
    
    for file in download_path.iterdir():
        if file.is_file():
            ext = file.suffix.lower()
            
            # Find category
            folder_name = "Other"
            for category, extensions in categories.items():
                if ext in extensions:
                    folder_name = category
                    break
            
            # Move file
            dest_folder = download_path / folder_name
            dest_folder.mkdir(exist_ok=True)
            shutil.move(str(file), str(dest_folder / file.name))
            print(f"Moved: {file.name} → {folder_name}/")

# Usage
# organize_downloads("/path/to/Downloads")
```

### Batch Rename Files

```python
from pathlib import Path

def batch_rename(directory, pattern, replacement):
    """Rename files matching a pattern."""
    folder = Path(directory)
    count = 0
    
    for file in folder.iterdir():
        if pattern in file.name:
            new_name = file.name.replace(pattern, replacement)
            file.rename(folder / new_name)
            print(f"Renamed: {file.name} → {new_name}")
            count += 1
    
    print(f"\nTotal renamed: {count} files")

# Usage: Replace spaces with underscores
# batch_rename("./photos", " ", "_")
```

### Watch Directory for Changes

```python
# pip install watchdog
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import time

class FileHandler(FileSystemEventHandler):
    def on_created(self, event):
        if not event.is_directory:
            print(f"New file: {event.src_path}")
    
    def on_modified(self, event):
        if not event.is_directory:
            print(f"Modified: {event.src_path}")

# Usage
# observer = Observer()
# observer.schedule(FileHandler(), path="./watch_folder", recursive=False)
# observer.start()
# try:
#     while True:
#         time.sleep(1)
# except KeyboardInterrupt:
#     observer.stop()
# observer.join()
```

---

## 21.3 Web Scraping

```python
# pip install requests beautifulsoup4
import requests
from bs4 import BeautifulSoup

# Basic scraping
url = "https://quotes.toscrape.com/"
response = requests.get(url)
soup = BeautifulSoup(response.text, "html.parser")

# Extract all quotes
quotes = soup.find_all("div", class_="quote")
for quote in quotes:
    text = quote.find("span", class_="text").get_text()
    author = quote.find("small", class_="author").get_text()
    print(f'"{text}" — {author}')

# Extract links
links = soup.find_all("a")
for link in links:
    href = link.get("href")
    print(f"{link.text.strip()}: {href}")
```

### Scrape Multiple Pages

```python
import requests
from bs4 import BeautifulSoup
import csv
import time

def scrape_quotes(pages=3):
    all_quotes = []
    
    for page in range(1, pages + 1):
        url = f"https://quotes.toscrape.com/page/{page}/"
        response = requests.get(url)
        soup = BeautifulSoup(response.text, "html.parser")
        
        for quote in soup.find_all("div", class_="quote"):
            all_quotes.append({
                "text": quote.find("span", class_="text").get_text(),
                "author": quote.find("small", class_="author").get_text(),
                "tags": [t.get_text() for t in quote.find_all("a", class_="tag")]
            })
        
        time.sleep(1)  # Be respectful — don't overload server
    
    # Save to CSV
    with open("quotes.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["text", "author", "tags"])
        writer.writeheader()
        writer.writerows(all_quotes)
    
    print(f"Scraped {len(all_quotes)} quotes")
    return all_quotes

# scrape_quotes()
```

---

## 21.4 Email Automation

```python
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def send_email(to_email, subject, body):
    sender = "your_email@gmail.com"
    password = "your_app_password"  # Use App Password, not regular password
    
    msg = MIMEMultipart()
    msg["From"] = sender
    msg["To"] = to_email
    msg["Subject"] = subject
    msg.attach(MIMEText(body, "html"))
    
    with smtplib.SMTP("smtp.gmail.com", 587) as server:
        server.starttls()
        server.login(sender, password)
        server.send_message(msg)
    
    print(f"Email sent to {to_email}")

# Bulk email from CSV
import csv

def send_bulk_emails(csv_file):
    with open(csv_file, "r") as f:
        reader = csv.DictReader(f)
        for row in reader:
            body = f"<h1>Hello, {row['name']}!</h1><p>Your report is ready.</p>"
            send_email(row["email"], "Monthly Report", body)
```

---

## 21.5 Task Scheduling

```python
# pip install schedule
import schedule
import time

def daily_backup():
    print("Running daily backup...")
    # backup logic here

def hourly_check():
    print("Checking server health...")

# Schedule tasks
schedule.every().day.at("02:00").do(daily_backup)
schedule.every().hour.do(hourly_check)
schedule.every(10).minutes.do(lambda: print("Heartbeat"))

# Run scheduler
# while True:
#     schedule.run_pending()
#     time.sleep(60)
```

---

## 21.6 Practice & Assessment

### MCQs

**Q1.** Which module is best for modern path manipulation?
- A) os
- B) sys
- C) pathlib
- D) shutil

**Answer:** C — `pathlib` provides object-oriented path handling.

---

**Q2.** What does `time.sleep(1)` do in web scraping?
- A) Makes code faster
- B) Delays requests to avoid overloading the server
- C) Downloads faster
- D) Skips a page

**Answer:** B — Polite scraping requires delays between requests.

---

### Coding Task

**Task:** Create a script that monitors a folder and auto-organizes new files.

```python
from pathlib import Path
import shutil
import time

WATCH_DIR = Path("./incoming")
WATCH_DIR.mkdir(exist_ok=True)

RULES = {
    "images": [".jpg", ".png", ".gif"],
    "docs": [".pdf", ".docx", ".txt"],
    "data": [".csv", ".json", ".xlsx"]
}

def organize_file(filepath):
    ext = filepath.suffix.lower()
    for folder, extensions in RULES.items():
        if ext in extensions:
            dest = WATCH_DIR / folder
            dest.mkdir(exist_ok=True)
            shutil.move(str(filepath), str(dest / filepath.name))
            print(f"Organized: {filepath.name} → {folder}/")
            return
    print(f"No rule for: {filepath.name}")

def watch_and_organize():
    seen = set()
    print(f"Watching: {WATCH_DIR.absolute()}")
    while True:
        for f in WATCH_DIR.iterdir():
            if f.is_file() and f not in seen:
                organize_file(f)
                seen.add(f)
        time.sleep(2)

# watch_and_organize()
```

---

> **Next Topic:** [22 - Cheat Sheet](22-cheat-sheet.md)
