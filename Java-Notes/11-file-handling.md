# 11. File Handling

## Table of Contents
- [11.1 File Class](#111-file-class)
- [11.2 Writing to Files](#112-writing-to-files)
- [11.3 Reading from Files](#113-reading-from-files)
- [11.4 try-with-resources for Files](#114-try-with-resources-for-files)
- [11.5 Practice & Assessment](#115-practice--assessment)

---

## 11.1 File Class

### Definition
The `File` class in `java.io` represents a file or directory path. It doesn't read/write content — it provides metadata and operations on the path.

```java
import java.io.File;

File file = new File("data.txt");

// Check existence
System.out.println("Exists: " + file.exists());
System.out.println("Is file: " + file.isFile());
System.out.println("Is directory: " + file.isDirectory());

// File information
System.out.println("Name: " + file.getName());
System.out.println("Path: " + file.getAbsolutePath());
System.out.println("Size: " + file.length() + " bytes");
System.out.println("Can read: " + file.canRead());
System.out.println("Can write: " + file.canWrite());

// Create new file
File newFile = new File("output.txt");
if (newFile.createNewFile()) {
    System.out.println("File created!");
} else {
    System.out.println("File already exists.");
}

// Create directory
File dir = new File("myFolder");
dir.mkdir();       // Single directory
// dir.mkdirs();  // Creates parent directories too

// List directory contents
File folder = new File(".");
String[] files = folder.list();
for (String f : files) {
    System.out.println(f);
}

// Delete
file.delete();
```

---

## 11.2 Writing to Files

### FileWriter (Character Stream)

```java
import java.io.FileWriter;
import java.io.IOException;

try {
    // Write (overwrites existing content)
    FileWriter writer = new FileWriter("output.txt");
    writer.write("Hello, World!\n");
    writer.write("Second line\n");
    writer.close();
    System.out.println("File written successfully.");
    
    // Append mode
    FileWriter appender = new FileWriter("output.txt", true);  // true = append
    appender.write("Appended line\n");
    appender.close();
    
} catch (IOException e) {
    System.out.println("Error: " + e.getMessage());
}
```

### BufferedWriter (Efficient Writing)

```java
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

try (BufferedWriter bw = new BufferedWriter(new FileWriter("output.txt"))) {
    bw.write("Line 1");
    bw.newLine();           // Platform-independent newline
    bw.write("Line 2");
    bw.newLine();
    bw.write("Line 3");
    System.out.println("Written with BufferedWriter");
} catch (IOException e) {
    System.out.println("Error: " + e.getMessage());
}
```

### PrintWriter (Most Convenient)

```java
import java.io.PrintWriter;
import java.io.IOException;

try (PrintWriter pw = new PrintWriter("output.txt")) {
    pw.println("Name: Alice");            // println adds newline
    pw.println("Age: 25");
    pw.printf("GPA: %.2f%n", 3.85);      // Formatted output
    pw.print("No newline here");
} catch (IOException e) {
    System.out.println("Error: " + e.getMessage());
}
```

---

## 11.3 Reading from Files

### FileReader + BufferedReader (Most Common)

```java
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

try (BufferedReader br = new BufferedReader(new FileReader("output.txt"))) {
    String line;
    while ((line = br.readLine()) != null) {
        System.out.println(line);
    }
} catch (IOException e) {
    System.out.println("Error: " + e.getMessage());
}
```

### Scanner (Simple Reading)

```java
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

try {
    Scanner scanner = new Scanner(new File("output.txt"));
    while (scanner.hasNextLine()) {
        String line = scanner.nextLine();
        System.out.println(line);
    }
    scanner.close();
} catch (FileNotFoundException e) {
    System.out.println("File not found: " + e.getMessage());
}
```

### Files Class (Java NIO — Modern Approach)

```java
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

// Read all lines at once
Path path = Paths.get("output.txt");
List<String> lines = Files.readAllLines(path);
for (String line : lines) {
    System.out.println(line);
}

// Read entire file as String
String content = Files.readString(path);  // Java 11+
System.out.println(content);

// Write
Files.writeString(Path.of("test.txt"), "Hello from NIO!");  // Java 11+

// Write multiple lines
List<String> data = List.of("Line 1", "Line 2", "Line 3");
Files.write(Path.of("lines.txt"), data);
```

---

## 11.4 try-with-resources for Files

### Why?
Ensures resources (streams, connections) are automatically closed, even if an exception occurs.

```java
// WITHOUT try-with-resources (manual close — error-prone)
BufferedReader br = null;
try {
    br = new BufferedReader(new FileReader("data.txt"));
    String line = br.readLine();
} catch (IOException e) {
    e.printStackTrace();
} finally {
    if (br != null) {
        try { br.close(); } catch (IOException e) {}
    }
}

// WITH try-with-resources (automatic close — clean!)
try (BufferedReader br2 = new BufferedReader(new FileReader("data.txt"))) {
    String line = br2.readLine();
    System.out.println(line);
} catch (IOException e) {
    e.printStackTrace();
}
// br2 is automatically closed here!
```

---

## 11.5 Practice & Assessment

### MCQs

**Q1.** Which class is used for efficient line-by-line reading?
- A) FileReader
- B) BufferedReader
- C) Scanner
- D) All of the above

**Answer:** B — BufferedReader with readLine() is most efficient for line-by-line reading.

---

**Q2.** `new FileWriter("file.txt", true)` means:
- A) Read mode
- B) Write mode (overwrite)
- C) Append mode
- D) Binary mode

**Answer:** C — `true` enables append mode.

---

### Coding Task

**Task:** Write a program that reads a file, counts words, lines, and characters.

```java
import java.io.*;

public class FileStats {
    public static void main(String[] args) {
        int lines = 0, words = 0, chars = 0;
        
        try (BufferedReader br = new BufferedReader(new FileReader("sample.txt"))) {
            String line;
            while ((line = br.readLine()) != null) {
                lines++;
                chars += line.length();
                String[] wordArr = line.trim().split("\\s+");
                if (!line.trim().isEmpty()) {
                    words += wordArr.length;
                }
            }
        } catch (IOException e) {
            System.out.println("Error: " + e.getMessage());
            return;
        }
        
        System.out.println("Lines: " + lines);
        System.out.println("Words: " + words);
        System.out.println("Characters: " + chars);
    }
}
```

---

> **Next Topic:** [12 - JDBC](12-jdbc.md)
