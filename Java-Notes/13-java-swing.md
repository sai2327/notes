# 13. Java Swing (GUI)

## Table of Contents
- [13.1 What is Swing?](#131-what-is-swing)
- [13.2 Core Components](#132-core-components)
- [13.3 Layout Managers](#133-layout-managers)
- [13.4 Event Handling](#134-event-handling)
- [13.5 Calculator Project](#135-calculator-project)
- [13.6 Practice & Assessment](#136-practice--assessment)

---

## 13.1 What is Swing?

### Definition
**Swing** is a GUI (Graphical User Interface) toolkit in Java for building desktop applications with windows, buttons, text fields, and more.

### Swing vs AWT

| Feature | AWT | Swing |
|---------|-----|-------|
| Package | `java.awt` | `javax.swing` |
| Components | Heavy-weight (OS-native) | Light-weight (Java-rendered) |
| Look & Feel | OS-dependent | Consistent across platforms |
| Prefix | Button, Label | JButton, JLabel |

### Basic Window

```java
import javax.swing.*;

public class HelloSwing {
    public static void main(String[] args) {
        JFrame frame = new JFrame("My First Window");
        frame.setSize(400, 300);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        
        JLabel label = new JLabel("Hello, Swing!", SwingConstants.CENTER);
        frame.add(label);
        
        frame.setVisible(true);
    }
}
```

---

## 13.2 Core Components

### JFrame — Main Window

```java
JFrame frame = new JFrame("Title");
frame.setSize(500, 400);          // Width, Height
frame.setLocation(100, 100);      // X, Y position
frame.setResizable(false);        // Fixed size
frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
frame.setVisible(true);
```

### JLabel — Display Text/Image

```java
JLabel label = new JLabel("Hello World");
label.setFont(new Font("Arial", Font.BOLD, 20));
label.setForeground(Color.BLUE);
label.setHorizontalAlignment(SwingConstants.CENTER);
```

### JButton — Clickable Button

```java
JButton btn = new JButton("Click Me");
btn.setBounds(50, 50, 120, 30);  // x, y, width, height (for null layout)
btn.setEnabled(true);
```

### JTextField — Single-Line Input

```java
JTextField textField = new JTextField(20);  // 20 columns wide
textField.setText("Default text");
String userInput = textField.getText();     // Get typed text
```

### JTextArea — Multi-Line Input

```java
JTextArea textArea = new JTextArea(5, 20);  // 5 rows, 20 columns
textArea.setLineWrap(true);
textArea.setWrapStyleWord(true);

// Add scrollbar
JScrollPane scroll = new JScrollPane(textArea);
```

### JPanel — Container/Grouping

```java
JPanel panel = new JPanel();
panel.setBackground(Color.LIGHT_GRAY);
panel.add(new JButton("Button 1"));
panel.add(new JButton("Button 2"));
frame.add(panel);
```

### Other Components

| Component | Purpose |
|-----------|---------|
| `JCheckBox` | Toggle option |
| `JRadioButton` | Select one from group |
| `JComboBox` | Dropdown list |
| `JList` | Scrollable list |
| `JTable` | Data table |
| `JMenuBar` | Menu bar |
| `JPasswordField` | Hidden input |
| `JProgressBar` | Progress indicator |

---

## 13.3 Layout Managers

### FlowLayout (Default for JPanel)

```java
panel.setLayout(new FlowLayout());  // Left to right, wraps
panel.add(new JButton("1"));
panel.add(new JButton("2"));
panel.add(new JButton("3"));
// [1] [2] [3] — flows horizontally
```

### BorderLayout (Default for JFrame)

```java
frame.setLayout(new BorderLayout());
frame.add(new JButton("North"), BorderLayout.NORTH);
frame.add(new JButton("South"), BorderLayout.SOUTH);
frame.add(new JButton("East"), BorderLayout.EAST);
frame.add(new JButton("West"), BorderLayout.WEST);
frame.add(new JButton("Center"), BorderLayout.CENTER);

//     ┌──────────────────────┐
//     │       NORTH          │
//     ├────┬──────────┬──────┤
//     │    │          │      │
//     │WEST│  CENTER  │ EAST │
//     │    │          │      │
//     ├────┴──────────┴──────┤
//     │       SOUTH          │
//     └──────────────────────┘
```

### GridLayout

```java
panel.setLayout(new GridLayout(3, 3));  // 3 rows, 3 columns
for (int i = 1; i <= 9; i++) {
    panel.add(new JButton(String.valueOf(i)));
}
// ┌───┬───┬───┐
// │ 1 │ 2 │ 3 │
// ├───┼───┼───┤
// │ 4 │ 5 │ 6 │
// ├───┼───┼───┤
// │ 7 │ 8 │ 9 │
// └───┴───┴───┘
```

### Null Layout (Absolute Positioning)

```java
panel.setLayout(null);
JButton btn = new JButton("Click");
btn.setBounds(50, 50, 100, 30);  // x, y, width, height
panel.add(btn);
// Not recommended — doesn't adapt to window resize
```

---

## 13.4 Event Handling

### ActionListener (Button Click)

```java
import javax.swing.*;
import java.awt.event.*;

public class EventDemo {
    public static void main(String[] args) {
        JFrame frame = new JFrame("Event Demo");
        JButton btn = new JButton("Click Me");
        JLabel label = new JLabel("Status: Ready");
        
        // Method 1: Anonymous class
        btn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                label.setText("Button clicked!");
            }
        });
        
        // Method 2: Lambda (Java 8+) — shorter!
        btn.addActionListener(e -> label.setText("Button clicked!"));
        
        frame.setLayout(new java.awt.FlowLayout());
        frame.add(btn);
        frame.add(label);
        frame.setSize(300, 100);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setVisible(true);
    }
}
```

### KeyListener (Keyboard Input)

```java
textField.addKeyListener(new KeyAdapter() {
    @Override
    public void keyPressed(KeyEvent e) {
        if (e.getKeyCode() == KeyEvent.VK_ENTER) {
            System.out.println("Enter pressed! Text: " + textField.getText());
        }
    }
});
```

### MouseListener

```java
panel.addMouseListener(new MouseAdapter() {
    @Override
    public void mouseClicked(MouseEvent e) {
        System.out.println("Clicked at: " + e.getX() + ", " + e.getY());
    }
});
```

---

## 13.5 Calculator Project

```java
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Calculator extends JFrame implements ActionListener {
    private JTextField display;
    private double num1 = 0;
    private String operator = "";
    private boolean startNewNumber = true;
    
    public Calculator() {
        setTitle("Calculator");
        setSize(300, 400);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setLayout(new BorderLayout());
        
        // Display
        display = new JTextField("0");
        display.setFont(new Font("Arial", Font.BOLD, 24));
        display.setHorizontalAlignment(JTextField.RIGHT);
        display.setEditable(false);
        add(display, BorderLayout.NORTH);
        
        // Button panel
        JPanel buttonPanel = new JPanel(new GridLayout(4, 4, 5, 5));
        String[] buttons = {
            "7", "8", "9", "/",
            "4", "5", "6", "*",
            "1", "2", "3", "-",
            "0", "C", "=", "+"
        };
        
        for (String text : buttons) {
            JButton btn = new JButton(text);
            btn.setFont(new Font("Arial", Font.PLAIN, 18));
            btn.addActionListener(this);
            buttonPanel.add(btn);
        }
        
        add(buttonPanel, BorderLayout.CENTER);
        setVisible(true);
    }
    
    @Override
    public void actionPerformed(ActionEvent e) {
        String cmd = e.getActionCommand();
        
        if (cmd.matches("[0-9]")) {
            if (startNewNumber) {
                display.setText(cmd);
                startNewNumber = false;
            } else {
                display.setText(display.getText() + cmd);
            }
        } else if (cmd.equals("C")) {
            display.setText("0");
            num1 = 0;
            operator = "";
            startNewNumber = true;
        } else if (cmd.equals("=")) {
            double num2 = Double.parseDouble(display.getText());
            double result = calculate(num1, num2, operator);
            display.setText(String.valueOf(result));
            startNewNumber = true;
        } else {
            // Operator pressed
            num1 = Double.parseDouble(display.getText());
            operator = cmd;
            startNewNumber = true;
        }
    }
    
    private double calculate(double a, double b, String op) {
        switch (op) {
            case "+": return a + b;
            case "-": return a - b;
            case "*": return a * b;
            case "/": return b != 0 ? a / b : 0;
            default: return b;
        }
    }
    
    public static void main(String[] args) {
        new Calculator();
    }
}
```

---

## 13.6 Practice & Assessment

### MCQs

**Q1.** Default layout manager of JFrame is:
- A) FlowLayout
- B) GridLayout
- C) BorderLayout
- D) Null

**Answer:** C — BorderLayout

---

**Q2.** To handle button clicks, implement:
- A) MouseListener
- B) ActionListener
- C) KeyListener
- D) WindowListener

**Answer:** B

---

### Coding Task

**Task:** Create a login form with:
- Username and password fields
- Login button
- Show message dialog on login attempt

```java
import javax.swing.*;
import java.awt.*;

public class LoginForm {
    public static void main(String[] args) {
        JFrame frame = new JFrame("Login");
        frame.setSize(300, 200);
        frame.setLayout(new GridLayout(3, 2, 10, 10));
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        
        frame.add(new JLabel("  Username:"));
        JTextField userField = new JTextField();
        frame.add(userField);
        
        frame.add(new JLabel("  Password:"));
        JPasswordField passField = new JPasswordField();
        frame.add(passField);
        
        frame.add(new JLabel());  // Spacer
        JButton loginBtn = new JButton("Login");
        frame.add(loginBtn);
        
        loginBtn.addActionListener(e -> {
            String user = userField.getText();
            String pass = new String(passField.getPassword());
            if (user.equals("admin") && pass.equals("1234")) {
                JOptionPane.showMessageDialog(frame, "Login Successful!");
            } else {
                JOptionPane.showMessageDialog(frame, "Invalid credentials!", 
                    "Error", JOptionPane.ERROR_MESSAGE);
            }
        });
        
        frame.setVisible(true);
    }
}
```

---

> **Next Topic:** [14 - Spring Boot](14-spring-boot.md)
