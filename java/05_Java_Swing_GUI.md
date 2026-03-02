# 🖥️ Java Swing GUI Programming

> **Complete guide to building desktop applications with Java Swing — from basics to mini projects.**

---

## Table of Contents

- [Introduction to GUI Programming](#introduction-to-gui-programming)
- [AWT vs Swing](#awt-vs-swing)
- [Swing Architecture](#swing-architecture)
- [Important Components](#important-components)
  - [JFrame](#jframe)
  - [JPanel](#jpanel)
  - [JLabel](#jlabel)
  - [JTextField](#jtextfield)
  - [JTextArea](#jtextarea)
  - [JButton](#jbutton)
  - [JCheckBox](#jcheckbox)
  - [JRadioButton](#jradiobutton)
  - [JComboBox](#jcombobox)
  - [JTable](#jtable)
- [Layouts](#layouts)
  - [FlowLayout](#flowlayout)
  - [BorderLayout](#borderlayout)
  - [GridLayout](#gridlayout)
  - [BoxLayout](#boxlayout)
- [Event Handling](#event-handling)
  - [ActionListener](#actionlistener)
  - [MouseListener](#mouselistener)
  - [KeyListener](#keylistener)
- [Mini Projects](#mini-projects)
  - [Calculator](#1-calculator)
  - [Login Form](#2-login-form)
  - [Registration Form](#3-registration-form)
  - [Notepad](#4-notepad)
- [Practice Sections](#practice-sections)

---

# Introduction to GUI Programming

## What is GUI?

**GUI (Graphical User Interface)** allows users to interact with programs using graphical elements like buttons, text fields, menus, and windows — instead of typing commands in a console.

## What is Swing?

**Swing** is Java's built-in GUI toolkit (part of `javax.swing` package). It provides a rich set of **lightweight**, **platform-independent** components for building desktop applications.

### Concept Explanation

- Swing was introduced in **Java 1.2** (JFC — Java Foundation Classes)
- Built on top of **AWT** (Abstract Window Toolkit)
- All Swing components start with **"J"** prefix: `JFrame`, `JButton`, `JLabel`, etc.
- Swing is **lightweight** — components are painted by Java, not the OS

### Visual Diagram — How Swing Works

```
┌─────────────────────────────────────────┐
│              Your Java Code              │
│         (Create JFrame, JButton)         │
├─────────────────────────────────────────┤
│           Swing (javax.swing)            │
│    Lightweight components, Look & Feel   │
├─────────────────────────────────────────┤
│            AWT (java.awt)                │
│      Native OS window, events, layout    │
├─────────────────────────────────────────┤
│         Operating System (OS)            │
│     Windows / macOS / Linux              │
└─────────────────────────────────────────┘
```

---

## AWT vs Swing

| Feature | AWT | Swing |
|---------|-----|-------|
| Package | `java.awt` | `javax.swing` |
| Components | Heavyweight (OS-rendered) | Lightweight (Java-rendered) |
| Look & Feel | Platform-dependent | Platform-independent (pluggable L&F) |
| Components | Limited (Button, Label, etc.) | Rich (JTable, JTree, JTabbedPane, etc.) |
| MVC | No | Yes (Model-View-Controller) |
| Performance | Faster (native) | Slightly slower (but more flexible) |
| Prefix | No prefix (Button) | "J" prefix (JButton) |

### When to Use What?

- **Swing** — Desktop apps, learning GUI, forms, tools
- **JavaFX** — Modern alternative to Swing (richer UI, CSS support)
- **AWT** — Rarely used directly; Swing builds on it

---

## Swing Architecture

### MVC Pattern in Swing

```
┌─────────┐     ┌──────────┐     ┌──────────┐
│  Model   │◄───►│Controller│◄───►│   View   │
│ (Data)   │     │ (Logic)  │     │  (UI)    │
└─────────┘     └──────────┘     └──────────┘

Example with JButton:
- Model: ButtonModel (pressed state, enabled/disabled)
- View: ButtonUI (how button looks)
- Controller: ActionListener (what happens on click)
```

### Swing Component Hierarchy

```
java.lang.Object
  └── java.awt.Component
        └── java.awt.Container
              ├── java.awt.Window
              │     └── java.awt.Frame
              │           └── javax.swing.JFrame
              └── javax.swing.JComponent
                    ├── JPanel
                    ├── JLabel
                    ├── JButton
                    ├── JTextField
                    ├── JTextArea
                    ├── JCheckBox
                    ├── JRadioButton
                    ├── JComboBox
                    ├── JTable
                    └── ... (many more)
```

### Quick Revision – Swing Basics

```
┌────────────────────────────────────────────────────────────┐
│ KEY POINTS                                                  │
├────────────────────────────────────────────────────────────┤
│ • Swing = Java GUI toolkit (javax.swing)                   │
│ • Lightweight, platform-independent                         │
│ • All components start with "J" (JFrame, JButton)          │
│ • Built on AWT, uses MVC architecture                       │
│ • JFrame = main window, JPanel = container for components  │
│ • Event-driven programming: listeners handle user actions  │
└────────────────────────────────────────────────────────────┘
```

---

# Important Components

## JFrame

### Concept Explanation

`JFrame` is the **main window** of a Swing application. It provides the title bar, minimize/maximize/close buttons, and a content pane for adding components.

### Syntax

```java
JFrame frame = new JFrame("Title");
frame.setSize(400, 300);             // width, height in pixels
frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
frame.setVisible(true);
```

### Example Code

```java
import javax.swing.JFrame;

public class JFrameDemo {
    public static void main(String[] args) {
        // Create frame
        JFrame frame = new JFrame("My First Swing App");

        // Set size
        frame.setSize(500, 400);

        // Center on screen
        frame.setLocationRelativeTo(null);

        // Close operation
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // Prevent resizing (optional)
        // frame.setResizable(false);

        // Make visible (always call last!)
        frame.setVisible(true);
    }
}
```

### Visual Diagram

```
┌──────────────────────────────────────┐
│  My First Swing App    [_][□][X]     │ ← Title Bar
├──────────────────────────────────────┤
│                                      │
│                                      │
│          Content Pane                │ ← Where components go
│        (500 x 400 pixels)           │
│                                      │
│                                      │
└──────────────────────────────────────┘
```

### Common Mistakes

| Mistake | Fix |
|---------|-----|
| Forgetting `setVisible(true)` | Window won't show |
| Using `HIDE_ON_CLOSE` | App keeps running in background |
| Adding to `frame` directly | Use `frame.getContentPane().add()` or just `frame.add()` (shortcut) |

### Important JFrame Methods

| Method | Description |
|--------|-------------|
| `setTitle(String)` | Set window title |
| `setSize(int, int)` | Set width and height |
| `setLocation(int, int)` | Set position (x, y) |
| `setLocationRelativeTo(null)` | Center on screen |
| `setDefaultCloseOperation(int)` | Action on close |
| `setResizable(boolean)` | Allow/prevent resize |
| `setLayout(LayoutManager)` | Set layout manager |
| `add(Component)` | Add component to frame |
| `pack()` | Resize to fit components |

---

## JPanel

### Concept Explanation

`JPanel` is a **lightweight container** used to group and organize components. You can add multiple panels to a frame to create complex layouts.

### Example Code

```java
import javax.swing.*;
import java.awt.*;

public class JPanelDemo {
    public static void main(String[] args) {
        JFrame frame = new JFrame("JPanel Demo");
        frame.setSize(400, 300);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // Create panels with different colors
        JPanel topPanel = new JPanel();
        topPanel.setBackground(Color.RED);
        topPanel.add(new JLabel("Top Panel"));

        JPanel bottomPanel = new JPanel();
        bottomPanel.setBackground(Color.BLUE);
        bottomPanel.add(new JLabel("Bottom Panel"));

        // Add panels to frame
        frame.setLayout(new GridLayout(2, 1)); // 2 rows, 1 column
        frame.add(topPanel);
        frame.add(bottomPanel);

        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }
}
```

### Visual Diagram

```
┌──────────────────────────────────┐
│         JPanel Demo     [_][□][X]│
├──────────────────────────────────┤
│  ┌────────────────────────────┐  │
│  │   Top Panel (RED)          │  │
│  └────────────────────────────┘  │
│  ┌────────────────────────────┐  │
│  │   Bottom Panel (BLUE)      │  │
│  └────────────────────────────┘  │
└──────────────────────────────────┘
```

---

## JLabel

### Concept Explanation

`JLabel` displays **text or images** (read-only). It cannot be edited by the user.

### Example Code

```java
import javax.swing.*;
import java.awt.*;

public class JLabelDemo {
    public static void main(String[] args) {
        JFrame frame = new JFrame("JLabel Demo");
        frame.setSize(400, 200);
        frame.setLayout(new FlowLayout());

        // Simple text label
        JLabel label1 = new JLabel("Hello, Swing!");
        label1.setFont(new Font("Arial", Font.BOLD, 20));
        label1.setForeground(Color.BLUE);

        // Label with icon
        // JLabel label2 = new JLabel("With Icon", new ImageIcon("icon.png"), JLabel.LEFT);

        // HTML in label
        JLabel label3 = new JLabel("<html><b>Bold</b> and <i>Italic</i> text</html>");

        frame.add(label1);
        frame.add(label3);

        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }
}
```

### Key Methods

| Method | Description |
|--------|-------------|
| `setText(String)` | Set label text |
| `getText()` | Get label text |
| `setFont(Font)` | Set font style and size |
| `setForeground(Color)` | Set text color |
| `setIcon(Icon)` | Set image icon |
| `setHorizontalAlignment(int)` | Alignment (LEFT, CENTER, RIGHT) |

---

## JTextField

### Concept Explanation

`JTextField` is a **single-line text input** field. Users can type text into it.

### Example Code

```java
import javax.swing.*;
import java.awt.*;

public class JTextFieldDemo {
    public static void main(String[] args) {
        JFrame frame = new JFrame("JTextField Demo");
        frame.setSize(400, 200);
        frame.setLayout(new FlowLayout());

        // Create text field with column width
        JLabel nameLabel = new JLabel("Name: ");
        JTextField nameField = new JTextField(20);  // 20 columns wide

        // Text field with default text
        JTextField cityField = new JTextField("Enter city", 15);

        // Password field
        JLabel passLabel = new JLabel("Password: ");
        JPasswordField passField = new JPasswordField(20);

        // Get text from field
        JButton btn = new JButton("Submit");
        btn.addActionListener(e -> {
            String name = nameField.getText();
            String password = new String(passField.getPassword());
            JOptionPane.showMessageDialog(frame, "Name: " + name);
        });

        frame.add(nameLabel);
        frame.add(nameField);
        frame.add(passLabel);
        frame.add(passField);
        frame.add(cityField);
        frame.add(btn);

        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }
}
```

### Key Methods

| Method | Description |
|--------|-------------|
| `getText()` | Get text content |
| `setText(String)` | Set text content |
| `setEditable(boolean)` | Make read-only/editable |
| `setColumns(int)` | Set display width |
| `getPassword()` | Get password (JPasswordField) |
| `selectAll()` | Select all text |

---

## JTextArea

### Concept Explanation

`JTextArea` is a **multi-line text input** component. Wrap it in a `JScrollPane` for scrolling.

### Example Code

```java
import javax.swing.*;
import java.awt.*;

public class JTextAreaDemo {
    public static void main(String[] args) {
        JFrame frame = new JFrame("JTextArea Demo");
        frame.setSize(400, 300);
        frame.setLayout(new BorderLayout());

        // Create text area (rows, columns)
        JTextArea textArea = new JTextArea(10, 30);
        textArea.setLineWrap(true);           // Wrap lines
        textArea.setWrapStyleWord(true);      // Wrap at word boundaries
        textArea.setFont(new Font("Monospaced", Font.PLAIN, 14));

        // Add scroll pane
        JScrollPane scrollPane = new JScrollPane(textArea);

        // Button to get text
        JButton btn = new JButton("Get Text");
        btn.addActionListener(e -> {
            System.out.println("Text: " + textArea.getText());
        });

        frame.add(scrollPane, BorderLayout.CENTER);
        frame.add(btn, BorderLayout.SOUTH);

        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }
}
```

### Key Methods

| Method | Description |
|--------|-------------|
| `getText()` | Get all text |
| `setText(String)` | Set text |
| `append(String)` | Append text at end |
| `insert(String, int)` | Insert at position |
| `setLineWrap(boolean)` | Enable/disable line wrapping |
| `setWrapStyleWord(boolean)` | Wrap at word boundaries |
| `setRows(int)` / `setColumns(int)` | Set dimensions |

---

## JButton

### Concept Explanation

`JButton` is a clickable **push button**. You attach an `ActionListener` to handle click events.

### Example Code

```java
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class JButtonDemo {
    public static void main(String[] args) {
        JFrame frame = new JFrame("JButton Demo");
        frame.setSize(400, 200);
        frame.setLayout(new FlowLayout());

        // Create buttons
        JButton btn1 = new JButton("Click Me");
        JButton btn2 = new JButton("Reset");
        JLabel label = new JLabel("No button clicked yet");

        // Style button
        btn1.setBackground(Color.GREEN);
        btn1.setForeground(Color.WHITE);
        btn1.setFont(new Font("Arial", Font.BOLD, 14));
        btn1.setFocusPainted(false);  // Remove focus border

        // Method 1: Anonymous inner class
        btn1.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                label.setText("Button 1 clicked!");
            }
        });

        // Method 2: Lambda expression
        btn2.addActionListener(e -> label.setText("Reset clicked!"));

        frame.add(btn1);
        frame.add(btn2);
        frame.add(label);

        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }
}
```

---

## JCheckBox

### Concept Explanation

`JCheckBox` is a toggle component that can be **checked or unchecked**. Multiple checkboxes can be selected independently.

### Example Code

```java
import javax.swing.*;
import java.awt.*;

public class JCheckBoxDemo {
    public static void main(String[] args) {
        JFrame frame = new JFrame("JCheckBox Demo");
        frame.setSize(400, 250);
        frame.setLayout(new FlowLayout());

        JLabel label = new JLabel("Select your hobbies:");
        JCheckBox cb1 = new JCheckBox("Reading");
        JCheckBox cb2 = new JCheckBox("Gaming", true);  // Pre-selected
        JCheckBox cb3 = new JCheckBox("Cooking");

        JButton btn = new JButton("Show Selection");
        JLabel result = new JLabel("");

        btn.addActionListener(e -> {
            StringBuilder sb = new StringBuilder("Selected: ");
            if (cb1.isSelected()) sb.append("Reading ");
            if (cb2.isSelected()) sb.append("Gaming ");
            if (cb3.isSelected()) sb.append("Cooking ");
            result.setText(sb.toString());
        });

        frame.add(label);
        frame.add(cb1);
        frame.add(cb2);
        frame.add(cb3);
        frame.add(btn);
        frame.add(result);

        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }
}
```

---

## JRadioButton

### Concept Explanation

`JRadioButton` allows **only one selection** from a group. Use `ButtonGroup` to group radio buttons so only one can be selected at a time.

### Example Code

```java
import javax.swing.*;
import java.awt.*;

public class JRadioButtonDemo {
    public static void main(String[] args) {
        JFrame frame = new JFrame("JRadioButton Demo");
        frame.setSize(400, 250);
        frame.setLayout(new FlowLayout());

        JLabel label = new JLabel("Select Gender:");

        JRadioButton male = new JRadioButton("Male");
        JRadioButton female = new JRadioButton("Female");
        JRadioButton other = new JRadioButton("Other");

        // Group them — only one can be selected
        ButtonGroup group = new ButtonGroup();
        group.add(male);
        group.add(female);
        group.add(other);

        JButton btn = new JButton("Submit");
        JLabel result = new JLabel("");

        btn.addActionListener(e -> {
            String selected = "None";
            if (male.isSelected()) selected = "Male";
            else if (female.isSelected()) selected = "Female";
            else if (other.isSelected()) selected = "Other";
            result.setText("Selected: " + selected);
        });

        frame.add(label);
        frame.add(male);
        frame.add(female);
        frame.add(other);
        frame.add(btn);
        frame.add(result);

        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }
}
```

### Key Difference: JCheckBox vs JRadioButton

| Feature | JCheckBox | JRadioButton |
|---------|-----------|--------------|
| Selection | Multiple | Only one (in group) |
| ButtonGroup | Not required | Required for single selection |
| Use Case | Multi-select options | Mutually exclusive choices |

---

## JComboBox

### Concept Explanation

`JComboBox` is a **dropdown menu** that lets users select one item from a list.

### Example Code

```java
import javax.swing.*;
import java.awt.*;

public class JComboBoxDemo {
    public static void main(String[] args) {
        JFrame frame = new JFrame("JComboBox Demo");
        frame.setSize(400, 200);
        frame.setLayout(new FlowLayout());

        JLabel label = new JLabel("Select Language:");

        // Create combo box with items
        String[] languages = {"Java", "Python", "C++", "JavaScript", "Go"};
        JComboBox<String> combo = new JComboBox<>(languages);

        // Add item dynamically
        combo.addItem("Rust");

        // Set default selection
        combo.setSelectedIndex(0);  // Java

        JButton btn = new JButton("Show Selection");
        JLabel result = new JLabel("");

        btn.addActionListener(e -> {
            String selected = (String) combo.getSelectedItem();
            int index = combo.getSelectedIndex();
            result.setText("Selected: " + selected + " at index " + index);
        });

        // Listen for selection changes
        combo.addActionListener(e -> {
            System.out.println("Changed to: " + combo.getSelectedItem());
        });

        frame.add(label);
        frame.add(combo);
        frame.add(btn);
        frame.add(result);

        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }
}
```

### Key Methods

| Method | Description |
|--------|-------------|
| `addItem(Object)` | Add item to list |
| `removeItem(Object)` | Remove specific item |
| `removeAllItems()` | Clear all items |
| `getSelectedItem()` | Get selected item |
| `getSelectedIndex()` | Get selected index |
| `setSelectedIndex(int)` | Set selection by index |
| `getItemCount()` | Get total items |
| `setEditable(boolean)` | Allow typing custom values |

---

## JTable

### Concept Explanation

`JTable` displays data in a **tabular format** (rows and columns). It's commonly used for displaying database records, spreadsheets, and lists.

### Example Code

```java
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;

public class JTableDemo {
    public static void main(String[] args) {
        JFrame frame = new JFrame("JTable Demo");
        frame.setSize(500, 300);

        // Column names
        String[] columns = {"ID", "Name", "Age", "City"};

        // Row data
        Object[][] data = {
            {1, "Alice", 25, "New York"},
            {2, "Bob", 30, "London"},
            {3, "Charlie", 22, "Tokyo"},
            {4, "Diana", 28, "Paris"},
            {5, "Eve", 35, "Sydney"}
        };

        // Create table with data
        DefaultTableModel model = new DefaultTableModel(data, columns);
        JTable table = new JTable(model);

        // Customize
        table.setRowHeight(25);
        table.setFont(new Font("Arial", Font.PLAIN, 14));
        table.getTableHeader().setFont(new Font("Arial", Font.BOLD, 14));

        // Add to scroll pane (needed for header to show)
        JScrollPane scrollPane = new JScrollPane(table);

        // Button to add row
        JButton addBtn = new JButton("Add Row");
        addBtn.addActionListener(e -> {
            model.addRow(new Object[]{model.getRowCount() + 1, "New", 0, "Unknown"});
        });

        // Button to get selected row
        JButton getBtn = new JButton("Get Selected");
        getBtn.addActionListener(e -> {
            int row = table.getSelectedRow();
            if (row != -1) {
                String name = model.getValueAt(row, 1).toString();
                JOptionPane.showMessageDialog(frame, "Selected: " + name);
            }
        });

        JPanel btnPanel = new JPanel();
        btnPanel.add(addBtn);
        btnPanel.add(getBtn);

        frame.setLayout(new BorderLayout());
        frame.add(scrollPane, BorderLayout.CENTER);
        frame.add(btnPanel, BorderLayout.SOUTH);

        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }
}
```

### Visual Diagram

```
┌───────────────────────────────────────────┐
│  JTable Demo                    [_][□][X] │
├─────┬──────────┬──────┬──────────────────┤
│ ID  │   Name   │ Age  │      City         │  ← Header
├─────┼──────────┼──────┼──────────────────┤
│  1  │  Alice   │  25  │    New York       │
│  2  │  Bob     │  30  │    London         │
│  3  │  Charlie │  22  │    Tokyo          │
│  4  │  Diana   │  28  │    Paris          │
│  5  │  Eve     │  35  │    Sydney         │
├─────┴──────────┴──────┴──────────────────┤
│    [Add Row]    [Get Selected]             │
└───────────────────────────────────────────┘
```

---

### Quick Revision – Swing Components

```
┌────────────────────────────────────────────────────────────┐
│ COMPONENT SUMMARY                                           │
├────────────────────────────────────────────────────────────┤
│ • JFrame    → Main window (title bar, close button)        │
│ • JPanel    → Container to group components                │
│ • JLabel    → Display text/image (read-only)               │
│ • JTextField → Single-line text input                      │
│ • JTextArea  → Multi-line text input                       │
│ • JButton    → Clickable button                            │
│ • JCheckBox  → Multiple selection toggle                   │
│ • JRadioButton → Single selection (use ButtonGroup)        │
│ • JComboBox  → Dropdown selection                          │
│ • JTable     → Tabular data display                        │
│ • JPasswordField → Masked text input                       │
│ • JScrollPane → Adds scrollbars to components              │
└────────────────────────────────────────────────────────────┘
```

---

# Layouts

## Concept Explanation

**Layout Managers** determine how components are arranged inside a container (`JFrame`, `JPanel`). Instead of using absolute positioning, Java uses layout managers for responsive, cross-platform UIs.

---

## FlowLayout

### Concept

Arranges components in a **left-to-right flow**, wrapping to the next line when the row is full. **Default layout for JPanel.**

### Visual

```
┌──────────────────────────────────────┐
│  [Btn1] [Btn2] [Btn3] [Btn4]        │
│  [Btn5] [Btn6]                       │
└──────────────────────────────────────┘
```

### Example Code

```java
import javax.swing.*;
import java.awt.*;

public class FlowLayoutDemo {
    public static void main(String[] args) {
        JFrame frame = new JFrame("FlowLayout Demo");
        frame.setSize(400, 200);

        // FlowLayout(alignment, hGap, vGap)
        frame.setLayout(new FlowLayout(FlowLayout.LEFT, 10, 10));

        for (int i = 1; i <= 8; i++) {
            frame.add(new JButton("Button " + i));
        }

        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }
}
```

### Alignment Options
- `FlowLayout.LEFT` — Align left
- `FlowLayout.CENTER` — Align center (default)
- `FlowLayout.RIGHT` — Align right

---

## BorderLayout

### Concept

Divides the container into **5 regions**: NORTH, SOUTH, EAST, WEST, CENTER. Each region can hold **one component**. **Default layout for JFrame.**

### Visual

```
┌──────────────────────────────────────┐
│              NORTH                    │
├──────┬───────────────────────┬───────┤
│      │                       │       │
│ WEST │       CENTER          │ EAST  │
│      │                       │       │
├──────┴───────────────────────┴───────┤
│              SOUTH                    │
└──────────────────────────────────────┘
```

### Example Code

```java
import javax.swing.*;
import java.awt.*;

public class BorderLayoutDemo {
    public static void main(String[] args) {
        JFrame frame = new JFrame("BorderLayout Demo");
        frame.setSize(500, 400);
        frame.setLayout(new BorderLayout(5, 5)); // hGap, vGap

        frame.add(new JButton("NORTH"), BorderLayout.NORTH);
        frame.add(new JButton("SOUTH"), BorderLayout.SOUTH);
        frame.add(new JButton("EAST"), BorderLayout.EAST);
        frame.add(new JButton("WEST"), BorderLayout.WEST);
        frame.add(new JButton("CENTER"), BorderLayout.CENTER);

        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }
}
```

---

## GridLayout

### Concept

Arranges components in a **grid of rows and columns**. All cells are **equal size**. Components fill cells left-to-right, top-to-bottom.

### Visual

```
┌──────────┬──────────┬──────────┐
│  Btn 1   │  Btn 2   │  Btn 3   │
├──────────┼──────────┼──────────┤
│  Btn 4   │  Btn 5   │  Btn 6   │
├──────────┼──────────┼──────────┤
│  Btn 7   │  Btn 8   │  Btn 9   │
└──────────┴──────────┴──────────┘
```

### Example Code

```java
import javax.swing.*;
import java.awt.*;

public class GridLayoutDemo {
    public static void main(String[] args) {
        JFrame frame = new JFrame("GridLayout Demo");
        frame.setSize(400, 300);

        // GridLayout(rows, cols, hGap, vGap)
        frame.setLayout(new GridLayout(3, 3, 5, 5));

        for (int i = 1; i <= 9; i++) {
            frame.add(new JButton("Button " + i));
        }

        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }
}
```

---

## BoxLayout

### Concept

Arranges components in a **single row (X_AXIS)** or **single column (Y_AXIS)**. Unlike FlowLayout, components don't wrap — they stay in one line.

### Visual

```
Y_AXIS:                    X_AXIS:
┌──────────┐              ┌────┬────┬────┐
│  Btn 1   │              │Btn1│Btn2│Btn3│
├──────────┤              └────┴────┴────┘
│  Btn 2   │
├──────────┤
│  Btn 3   │
└──────────┘
```

### Example Code

```java
import javax.swing.*;
import java.awt.*;

public class BoxLayoutDemo {
    public static void main(String[] args) {
        JFrame frame = new JFrame("BoxLayout Demo");
        frame.setSize(300, 300);

        JPanel panel = new JPanel();
        panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS)); // Vertical

        JButton btn1 = new JButton("Button 1");
        JButton btn2 = new JButton("Button 2");
        JButton btn3 = new JButton("Button 3");

        // Center align
        btn1.setAlignmentX(Component.CENTER_ALIGNMENT);
        btn2.setAlignmentX(Component.CENTER_ALIGNMENT);
        btn3.setAlignmentX(Component.CENTER_ALIGNMENT);

        panel.add(Box.createVerticalStrut(20)); // Spacing
        panel.add(btn1);
        panel.add(Box.createVerticalStrut(10));
        panel.add(btn2);
        panel.add(Box.createVerticalStrut(10));
        panel.add(btn3);

        frame.add(panel);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }
}
```

---

### Layout Comparison

| Layout | Arrangement | Default For | Best Use |
|--------|-------------|-------------|----------|
| FlowLayout | Left-to-right, wrapping | JPanel | Toolbars, button rows |
| BorderLayout | 5 regions (N, S, E, W, C) | JFrame | Main window layout |
| GridLayout | Equal-size grid cells | — | Calculators, forms |
| BoxLayout | Single row or column | — | Stacked forms, sidebars |
| GridBagLayout | Flexible grid (complex) | — | Complex professional UIs |
| null | Absolute positioning | — | NOT recommended |

### Quick Revision – Layouts

```
┌────────────────────────────────────────────────────────────┐
│ LAYOUT MANAGERS                                             │
├────────────────────────────────────────────────────────────┤
│ • FlowLayout → Flow left to right, wrap                    │
│ • BorderLayout → 5 regions: N, S, E, W, CENTER            │
│ • GridLayout → Equal grid cells (rows × columns)           │
│ • BoxLayout → Single row or column stack                   │
│ • Default: JPanel=FlowLayout, JFrame=BorderLayout          │
│ • Use setLayout(new LayoutManager()) to change             │
│ • Avoid null layout — use layout managers instead          │
└────────────────────────────────────────────────────────────┘
```

---

# Event Handling

## Concept Explanation

**Event handling** is the mechanism that controls what happens when a user interacts with the GUI (clicks button, types text, moves mouse). Java uses the **Delegation Event Model**:

```
Event Source  →→→  Event Object  →→→  Event Listener
(JButton)         (ActionEvent)      (ActionListener)
     ↓                                    ↓
User clicks      Event created        Handler method
  button         and dispatched       executes code
```

### Key Terms

| Term | Meaning |
|------|---------|
| **Event Source** | The component that generates the event (e.g., JButton) |
| **Event Object** | Object carrying event info (e.g., ActionEvent) |
| **Event Listener** | Interface that handles the event (e.g., ActionListener) |

---

## ActionListener

### Concept

Handles **button clicks**, **menu selections**, **Enter key in text fields**, and **combo box selections**.

### Syntax

```java
component.addActionListener(new ActionListener() {
    @Override
    public void actionPerformed(ActionEvent e) {
        // Handle event here
    }
});

// Lambda version (Java 8+)
component.addActionListener(e -> {
    // Handle event here
});
```

### Example Code

```java
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class ActionListenerDemo extends JFrame implements ActionListener {
    JTextField field;
    JLabel result;

    public ActionListenerDemo() {
        setTitle("ActionListener Demo");
        setSize(400, 200);
        setLayout(new FlowLayout());

        field = new JTextField(15);
        JButton greetBtn = new JButton("Greet");
        JButton clearBtn = new JButton("Clear");
        result = new JLabel("Enter your name");

        // Method 1: Implement interface
        greetBtn.addActionListener(this);

        // Method 2: Lambda
        clearBtn.addActionListener(e -> {
            field.setText("");
            result.setText("Cleared!");
        });

        // ActionListener on Enter key in text field
        field.addActionListener(e -> {
            result.setText("Hello, " + field.getText() + "!");
        });

        add(new JLabel("Name: "));
        add(field);
        add(greetBtn);
        add(clearBtn);
        add(result);

        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setVisible(true);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        String name = field.getText();
        if (name.isEmpty()) {
            result.setText("Please enter a name!");
        } else {
            result.setText("Hello, " + name + "! Welcome!");
        }
    }

    public static void main(String[] args) {
        new ActionListenerDemo();
    }
}
```

---

## MouseListener

### Concept

Handles **mouse events** — clicks, presses, releases, enters, and exits on a component.

### Interface Methods

| Method | When Called |
|--------|------------|
| `mouseClicked(MouseEvent e)` | Mouse button clicked (press + release) |
| `mousePressed(MouseEvent e)` | Mouse button pressed down |
| `mouseReleased(MouseEvent e)` | Mouse button released |
| `mouseEntered(MouseEvent e)` | Mouse cursor enters component |
| `mouseExited(MouseEvent e)` | Mouse cursor exits component |

### Example Code

```java
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class MouseListenerDemo extends JFrame {
    JLabel statusLabel;

    public MouseListenerDemo() {
        setTitle("MouseListener Demo");
        setSize(400, 300);
        setLayout(new BorderLayout());

        JPanel panel = new JPanel();
        panel.setBackground(Color.LIGHT_GRAY);
        panel.setPreferredSize(new Dimension(400, 200));

        statusLabel = new JLabel("Move mouse over the panel", JLabel.CENTER);
        statusLabel.setFont(new Font("Arial", Font.PLAIN, 16));

        // Using MouseAdapter (no need to implement all methods)
        panel.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                statusLabel.setText("Clicked at (" + e.getX() + ", " + e.getY() + ")");
                if (e.getClickCount() == 2) {
                    statusLabel.setText("Double-clicked!");
                }
                if (SwingUtilities.isRightMouseButton(e)) {
                    statusLabel.setText("Right-clicked!");
                }
            }

            @Override
            public void mouseEntered(MouseEvent e) {
                panel.setBackground(Color.CYAN);
                statusLabel.setText("Mouse entered panel");
            }

            @Override
            public void mouseExited(MouseEvent e) {
                panel.setBackground(Color.LIGHT_GRAY);
                statusLabel.setText("Mouse exited panel");
            }
        });

        // MouseMotionListener for tracking movement
        panel.addMouseMotionListener(new MouseMotionAdapter() {
            @Override
            public void mouseMoved(MouseEvent e) {
                statusLabel.setText("Position: (" + e.getX() + ", " + e.getY() + ")");
            }
        });

        add(panel, BorderLayout.CENTER);
        add(statusLabel, BorderLayout.SOUTH);

        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setVisible(true);
    }

    public static void main(String[] args) {
        new MouseListenerDemo();
    }
}
```

### Tip: MouseListener vs MouseAdapter

| MouseListener (Interface) | MouseAdapter (Class) |
|--------------------------|---------------------|
| Must implement **all 5** methods | Override **only needed** methods |
| More verbose | More convenient |
| Used with anonymous classes | Preferred for partial implementation |

---

## KeyListener

### Concept

Handles **keyboard events** — key presses, releases, and character typing.

### Interface Methods

| Method | When Called |
|--------|------------|
| `keyTyped(KeyEvent e)` | Character key typed (press + release) |
| `keyPressed(KeyEvent e)` | Any key pressed down |
| `keyReleased(KeyEvent e)` | Any key released |

### Example Code

```java
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class KeyListenerDemo extends JFrame {
    JLabel keyLabel, codeLabel;
    JTextArea logArea;

    public KeyListenerDemo() {
        setTitle("KeyListener Demo");
        setSize(400, 300);
        setLayout(new BorderLayout());

        JPanel topPanel = new JPanel(new GridLayout(2, 1));
        keyLabel = new JLabel("Press any key...", JLabel.CENTER);
        keyLabel.setFont(new Font("Arial", Font.BOLD, 18));
        codeLabel = new JLabel("Key Code: ", JLabel.CENTER);

        topPanel.add(keyLabel);
        topPanel.add(codeLabel);

        logArea = new JTextArea(5, 30);
        logArea.setEditable(false);

        // Add KeyListener using KeyAdapter
        addKeyListener(new KeyAdapter() {
            @Override
            public void keyPressed(KeyEvent e) {
                int keyCode = e.getKeyCode();
                char keyChar = e.getKeyChar();
                String keyText = KeyEvent.getKeyText(keyCode);

                keyLabel.setText("Key: " + keyText);
                codeLabel.setText("Key Code: " + keyCode + " | Char: " + keyChar);

                logArea.append("Pressed: " + keyText + "\n");

                // Detect special keys
                if (keyCode == KeyEvent.VK_ESCAPE) {
                    logArea.append("ESC pressed — Exiting!\n");
                }
                if (keyCode == KeyEvent.VK_ENTER) {
                    logArea.append("ENTER pressed!\n");
                }

                // Detect modifier keys
                if (e.isControlDown()) logArea.append("CTRL held\n");
                if (e.isShiftDown()) logArea.append("SHIFT held\n");
                if (e.isAltDown()) logArea.append("ALT held\n");
            }
        });

        add(topPanel, BorderLayout.NORTH);
        add(new JScrollPane(logArea), BorderLayout.CENTER);

        setFocusable(true); // Required for KeyListener on JFrame
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setVisible(true);
    }

    public static void main(String[] args) {
        new KeyListenerDemo();
    }
}
```

### Common Key Codes

| Constant | Key |
|----------|-----|
| `VK_ENTER` | Enter |
| `VK_ESCAPE` | Escape |
| `VK_SPACE` | Spacebar |
| `VK_UP / DOWN / LEFT / RIGHT` | Arrow keys |
| `VK_A` to `VK_Z` | Letters |
| `VK_0` to `VK_9` | Numbers |
| `VK_F1` to `VK_F12` | Function keys |
| `VK_BACK_SPACE` | Backspace |
| `VK_DELETE` | Delete |

---

### Quick Revision – Event Handling

```
┌────────────────────────────────────────────────────────────┐
│ EVENT HANDLING SUMMARY                                      │
├────────────────────────────────────────────────────────────┤
│ • Delegation Model: Source → Event → Listener              │
│ • ActionListener → button clicks, Enter key, combo box     │
│ • MouseListener → click, enter, exit, press, release       │
│ • KeyListener → keyPressed, keyReleased, keyTyped          │
│ • Use Adapter classes to only override needed methods      │
│ • Lambda works for single-method interfaces (ActionListener)│
│ • setFocusable(true) needed for KeyListener on JFrame      │
│ • getSource() tells which component triggered event        │
└────────────────────────────────────────────────────────────┘
```

---

# Mini Projects

## 1. Calculator

### Full Working Code

```java
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Calculator extends JFrame implements ActionListener {
    JTextField display;
    double num1 = 0, num2 = 0, result = 0;
    String operator = "";

    public Calculator() {
        setTitle("Calculator");
        setSize(350, 500);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setResizable(false);

        // Display field
        display = new JTextField();
        display.setFont(new Font("Arial", Font.BOLD, 28));
        display.setHorizontalAlignment(JTextField.RIGHT);
        display.setEditable(false);
        display.setBackground(Color.WHITE);

        // Button panel
        JPanel buttonPanel = new JPanel();
        buttonPanel.setLayout(new GridLayout(5, 4, 5, 5));
        buttonPanel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // Button labels
        String[] buttons = {
            "C", "⌫", "%", "/",
            "7", "8", "9", "*",
            "4", "5", "6", "-",
            "1", "2", "3", "+",
            "±", "0", ".", "="
        };

        for (String text : buttons) {
            JButton btn = new JButton(text);
            btn.setFont(new Font("Arial", Font.BOLD, 20));
            btn.setFocusPainted(false);
            btn.addActionListener(this);

            // Color coding
            if (text.matches("[0-9.]")) {
                btn.setBackground(new Color(240, 240, 240));
            } else if (text.equals("=")) {
                btn.setBackground(new Color(66, 133, 244));
                btn.setForeground(Color.WHITE);
            } else {
                btn.setBackground(new Color(220, 220, 220));
            }

            buttonPanel.add(btn);
        }

        // Layout
        setLayout(new BorderLayout(5, 5));
        add(display, BorderLayout.NORTH);
        add(buttonPanel, BorderLayout.CENTER);

        setVisible(true);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        String command = e.getActionCommand();

        switch (command) {
            case "C":
                display.setText("");
                num1 = num2 = result = 0;
                operator = "";
                break;

            case "⌫":
                String text = display.getText();
                if (!text.isEmpty()) {
                    display.setText(text.substring(0, text.length() - 1));
                }
                break;

            case "±":
                if (!display.getText().isEmpty()) {
                    double val = Double.parseDouble(display.getText());
                    display.setText(String.valueOf(-val));
                }
                break;

            case "+": case "-": case "*": case "/": case "%":
                if (!display.getText().isEmpty()) {
                    num1 = Double.parseDouble(display.getText());
                    operator = command;
                    display.setText("");
                }
                break;

            case "=":
                if (!display.getText().isEmpty() && !operator.isEmpty()) {
                    num2 = Double.parseDouble(display.getText());
                    switch (operator) {
                        case "+": result = num1 + num2; break;
                        case "-": result = num1 - num2; break;
                        case "*": result = num1 * num2; break;
                        case "/":
                            if (num2 != 0) result = num1 / num2;
                            else { display.setText("Error"); return; }
                            break;
                        case "%": result = num1 % num2; break;
                    }
                    // Display result (remove trailing .0 for integers)
                    if (result == (long) result) {
                        display.setText(String.valueOf((long) result));
                    } else {
                        display.setText(String.valueOf(result));
                    }
                    operator = "";
                }
                break;

            default: // Number or decimal
                display.setText(display.getText() + command);
                break;
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(Calculator::new);
    }
}
```

### Visual

```
┌──────────────────────────┐
│  Calculator     [_][□][X]│
├──────────────────────────┤
│               123        │ ← Display
├──────┬──────┬──────┬─────┤
│  C   │  ⌫   │  %   │  /  │
├──────┼──────┼──────┼─────┤
│  7   │  8   │  9   │  *  │
├──────┼──────┼──────┼─────┤
│  4   │  5   │  6   │  -  │
├──────┼──────┼──────┼─────┤
│  1   │  2   │  3   │  +  │
├──────┼──────┼──────┼─────┤
│  ±   │  0   │  .   │  =  │
└──────┴──────┴──────┴─────┘
```

---

## 2. Login Form

### Full Working Code

```java
import javax.swing.*;
import java.awt.*;

public class LoginForm extends JFrame {
    JTextField usernameField;
    JPasswordField passwordField;
    JLabel messageLabel;

    public LoginForm() {
        setTitle("Login Form");
        setSize(400, 300);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setResizable(false);

        // Main panel
        JPanel mainPanel = new JPanel();
        mainPanel.setLayout(new BoxLayout(mainPanel, BoxLayout.Y_AXIS));
        mainPanel.setBorder(BorderFactory.createEmptyBorder(30, 50, 30, 50));
        mainPanel.setBackground(new Color(245, 245, 245));

        // Title
        JLabel titleLabel = new JLabel("Welcome Back!");
        titleLabel.setFont(new Font("Arial", Font.BOLD, 22));
        titleLabel.setAlignmentX(Component.CENTER_ALIGNMENT);

        // Username
        JPanel userPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        userPanel.setOpaque(false);
        userPanel.add(new JLabel("Username: "));
        usernameField = new JTextField(18);
        userPanel.add(usernameField);

        // Password
        JPanel passPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        passPanel.setOpaque(false);
        passPanel.add(new JLabel("Password: "));
        passwordField = new JPasswordField(18);
        passPanel.add(passwordField);

        // Buttons
        JPanel btnPanel = new JPanel(new FlowLayout());
        btnPanel.setOpaque(false);
        JButton loginBtn = new JButton("Login");
        JButton resetBtn = new JButton("Reset");
        loginBtn.setBackground(new Color(66, 133, 244));
        loginBtn.setForeground(Color.WHITE);
        loginBtn.setFocusPainted(false);

        btnPanel.add(loginBtn);
        btnPanel.add(resetBtn);

        // Message
        messageLabel = new JLabel(" ");
        messageLabel.setAlignmentX(Component.CENTER_ALIGNMENT);
        messageLabel.setFont(new Font("Arial", Font.PLAIN, 14));

        // Event Handlers
        loginBtn.addActionListener(e -> {
            String username = usernameField.getText();
            String password = new String(passwordField.getPassword());

            if (username.equals("admin") && password.equals("1234")) {
                messageLabel.setText("Login Successful!");
                messageLabel.setForeground(new Color(0, 128, 0));
                JOptionPane.showMessageDialog(this, "Welcome, " + username + "!");
            } else if (username.isEmpty() || password.isEmpty()) {
                messageLabel.setText("Please fill all fields!");
                messageLabel.setForeground(Color.ORANGE);
            } else {
                messageLabel.setText("Invalid credentials!");
                messageLabel.setForeground(Color.RED);
            }
        });

        resetBtn.addActionListener(e -> {
            usernameField.setText("");
            passwordField.setText("");
            messageLabel.setText(" ");
        });

        // Enter key to login
        passwordField.addActionListener(e -> loginBtn.doClick());

        // Add components
        mainPanel.add(titleLabel);
        mainPanel.add(Box.createVerticalStrut(20));
        mainPanel.add(userPanel);
        mainPanel.add(Box.createVerticalStrut(5));
        mainPanel.add(passPanel);
        mainPanel.add(Box.createVerticalStrut(10));
        mainPanel.add(btnPanel);
        mainPanel.add(Box.createVerticalStrut(10));
        mainPanel.add(messageLabel);

        add(mainPanel);
        setVisible(true);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(LoginForm::new);
    }
}
```

---

## 3. Registration Form

### Full Working Code

```java
import javax.swing.*;
import java.awt.*;

public class RegistrationForm extends JFrame {

    public RegistrationForm() {
        setTitle("Registration Form");
        setSize(500, 550);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setResizable(false);

        JPanel mainPanel = new JPanel(new GridBagLayout());
        mainPanel.setBorder(BorderFactory.createEmptyBorder(15, 30, 15, 30));
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.insets = new Insets(5, 5, 5, 5);

        // Title
        JLabel title = new JLabel("Student Registration", JLabel.CENTER);
        title.setFont(new Font("Arial", Font.BOLD, 22));
        gbc.gridx = 0; gbc.gridy = 0; gbc.gridwidth = 2;
        mainPanel.add(title, gbc);
        gbc.gridwidth = 1; // Reset

        // Name
        gbc.gridx = 0; gbc.gridy = 1;
        mainPanel.add(new JLabel("Full Name:"), gbc);
        JTextField nameField = new JTextField(20);
        gbc.gridx = 1;
        mainPanel.add(nameField, gbc);

        // Email
        gbc.gridx = 0; gbc.gridy = 2;
        mainPanel.add(new JLabel("Email:"), gbc);
        JTextField emailField = new JTextField(20);
        gbc.gridx = 1;
        mainPanel.add(emailField, gbc);

        // Phone
        gbc.gridx = 0; gbc.gridy = 3;
        mainPanel.add(new JLabel("Phone:"), gbc);
        JTextField phoneField = new JTextField(20);
        gbc.gridx = 1;
        mainPanel.add(phoneField, gbc);

        // Password
        gbc.gridx = 0; gbc.gridy = 4;
        mainPanel.add(new JLabel("Password:"), gbc);
        JPasswordField passField = new JPasswordField(20);
        gbc.gridx = 1;
        mainPanel.add(passField, gbc);

        // Gender
        gbc.gridx = 0; gbc.gridy = 5;
        mainPanel.add(new JLabel("Gender:"), gbc);
        JPanel genderPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 0, 0));
        JRadioButton male = new JRadioButton("Male");
        JRadioButton female = new JRadioButton("Female");
        ButtonGroup genderGroup = new ButtonGroup();
        genderGroup.add(male);
        genderGroup.add(female);
        genderPanel.add(male);
        genderPanel.add(female);
        gbc.gridx = 1;
        mainPanel.add(genderPanel, gbc);

        // Course
        gbc.gridx = 0; gbc.gridy = 6;
        mainPanel.add(new JLabel("Course:"), gbc);
        String[] courses = {"Select Course", "B.Tech", "B.Sc", "BCA", "MCA", "MBA"};
        JComboBox<String> courseCombo = new JComboBox<>(courses);
        gbc.gridx = 1;
        mainPanel.add(courseCombo, gbc);

        // Hobbies
        gbc.gridx = 0; gbc.gridy = 7;
        mainPanel.add(new JLabel("Hobbies:"), gbc);
        JPanel hobbyPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 0, 0));
        JCheckBox reading = new JCheckBox("Reading");
        JCheckBox sports = new JCheckBox("Sports");
        JCheckBox music = new JCheckBox("Music");
        hobbyPanel.add(reading);
        hobbyPanel.add(sports);
        hobbyPanel.add(music);
        gbc.gridx = 1;
        mainPanel.add(hobbyPanel, gbc);

        // Address
        gbc.gridx = 0; gbc.gridy = 8;
        mainPanel.add(new JLabel("Address:"), gbc);
        JTextArea addressArea = new JTextArea(3, 20);
        addressArea.setLineWrap(true);
        gbc.gridx = 1;
        mainPanel.add(new JScrollPane(addressArea), gbc);

        // Buttons
        JPanel btnPanel = new JPanel(new FlowLayout());
        JButton submitBtn = new JButton("Submit");
        JButton resetBtn = new JButton("Reset");
        submitBtn.setBackground(new Color(0, 128, 0));
        submitBtn.setForeground(Color.WHITE);
        btnPanel.add(submitBtn);
        btnPanel.add(resetBtn);
        gbc.gridx = 0; gbc.gridy = 9; gbc.gridwidth = 2;
        mainPanel.add(btnPanel, gbc);

        // Result label
        JLabel resultLabel = new JLabel(" ", JLabel.CENTER);
        gbc.gridy = 10;
        mainPanel.add(resultLabel, gbc);

        // Submit action
        submitBtn.addActionListener(e -> {
            String name = nameField.getText();
            String email = emailField.getText();
            String phone = phoneField.getText();
            String password = new String(passField.getPassword());
            String gender = male.isSelected() ? "Male" : female.isSelected() ? "Female" : "Not selected";
            String course = (String) courseCombo.getSelectedItem();

            StringBuilder hobbies = new StringBuilder();
            if (reading.isSelected()) hobbies.append("Reading ");
            if (sports.isSelected()) hobbies.append("Sports ");
            if (music.isSelected()) hobbies.append("Music ");

            String address = addressArea.getText();

            // Validation
            if (name.isEmpty() || email.isEmpty() || password.isEmpty()) {
                JOptionPane.showMessageDialog(this, "Please fill required fields!",
                        "Validation Error", JOptionPane.WARNING_MESSAGE);
                return;
            }

            // Display summary
            String summary = String.format(
                    "Name: %s\nEmail: %s\nPhone: %s\nGender: %s\nCourse: %s\nHobbies: %s\nAddress: %s",
                    name, email, phone, gender, course, hobbies.toString(), address
            );
            JOptionPane.showMessageDialog(this, summary, "Registration Details",
                    JOptionPane.INFORMATION_MESSAGE);
            resultLabel.setText("Registration Successful!");
            resultLabel.setForeground(new Color(0, 128, 0));
        });

        // Reset action
        resetBtn.addActionListener(e -> {
            nameField.setText("");
            emailField.setText("");
            phoneField.setText("");
            passField.setText("");
            genderGroup.clearSelection();
            courseCombo.setSelectedIndex(0);
            reading.setSelected(false);
            sports.setSelected(false);
            music.setSelected(false);
            addressArea.setText("");
            resultLabel.setText(" ");
        });

        add(new JScrollPane(mainPanel));
        setVisible(true);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(RegistrationForm::new);
    }
}
```

---

## 4. Notepad

### Full Working Code

```java
import javax.swing.*;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.awt.*;
import java.awt.event.*;
import java.io.*;

public class Notepad extends JFrame implements ActionListener {
    JTextArea textArea;
    JFileChooser fileChooser;
    String currentFile = null;

    public Notepad() {
        setTitle("Notepad - Untitled");
        setSize(800, 600);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        // Text Area
        textArea = new JTextArea();
        textArea.setFont(new Font("Consolas", Font.PLAIN, 16));
        textArea.setLineWrap(true);
        textArea.setWrapStyleWord(true);
        textArea.setTabSize(4);
        JScrollPane scrollPane = new JScrollPane(textArea);

        // Menu Bar
        JMenuBar menuBar = new JMenuBar();

        // File Menu
        JMenu fileMenu = new JMenu("File");
        fileMenu.setMnemonic('F');

        JMenuItem newItem = new JMenuItem("New");
        newItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_N, InputEvent.CTRL_DOWN_MASK));
        newItem.addActionListener(this);

        JMenuItem openItem = new JMenuItem("Open");
        openItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_O, InputEvent.CTRL_DOWN_MASK));
        openItem.addActionListener(this);

        JMenuItem saveItem = new JMenuItem("Save");
        saveItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_S, InputEvent.CTRL_DOWN_MASK));
        saveItem.addActionListener(this);

        JMenuItem saveAsItem = new JMenuItem("Save As");
        saveAsItem.addActionListener(this);

        JMenuItem exitItem = new JMenuItem("Exit");
        exitItem.addActionListener(this);

        fileMenu.add(newItem);
        fileMenu.add(openItem);
        fileMenu.addSeparator();
        fileMenu.add(saveItem);
        fileMenu.add(saveAsItem);
        fileMenu.addSeparator();
        fileMenu.add(exitItem);

        // Edit Menu
        JMenu editMenu = new JMenu("Edit");
        editMenu.setMnemonic('E');

        JMenuItem cutItem = new JMenuItem("Cut");
        cutItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_X, InputEvent.CTRL_DOWN_MASK));
        cutItem.addActionListener(e -> textArea.cut());

        JMenuItem copyItem = new JMenuItem("Copy");
        copyItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_C, InputEvent.CTRL_DOWN_MASK));
        copyItem.addActionListener(e -> textArea.copy());

        JMenuItem pasteItem = new JMenuItem("Paste");
        pasteItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_V, InputEvent.CTRL_DOWN_MASK));
        pasteItem.addActionListener(e -> textArea.paste());

        JMenuItem selectAllItem = new JMenuItem("Select All");
        selectAllItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_A, InputEvent.CTRL_DOWN_MASK));
        selectAllItem.addActionListener(e -> textArea.selectAll());

        editMenu.add(cutItem);
        editMenu.add(copyItem);
        editMenu.add(pasteItem);
        editMenu.addSeparator();
        editMenu.add(selectAllItem);

        // Format Menu
        JMenu formatMenu = new JMenu("Format");

        JMenuItem fontItem = new JMenuItem("Font Size");
        fontItem.addActionListener(e -> {
            String size = JOptionPane.showInputDialog(this, "Enter font size:", "16");
            if (size != null) {
                try {
                    int fontSize = Integer.parseInt(size);
                    textArea.setFont(new Font("Consolas", Font.PLAIN, fontSize));
                } catch (NumberFormatException ex) {
                    JOptionPane.showMessageDialog(this, "Invalid font size!");
                }
            }
        });

        JCheckBoxMenuItem wordWrap = new JCheckBoxMenuItem("Word Wrap", true);
        wordWrap.addActionListener(e -> {
            textArea.setLineWrap(wordWrap.isSelected());
            textArea.setWrapStyleWord(wordWrap.isSelected());
        });

        formatMenu.add(fontItem);
        formatMenu.add(wordWrap);

        // Help Menu
        JMenu helpMenu = new JMenu("Help");
        JMenuItem aboutItem = new JMenuItem("About");
        aboutItem.addActionListener(e ->
                JOptionPane.showMessageDialog(this,
                        "Java Notepad\nBuilt with Swing\nVersion 1.0",
                        "About", JOptionPane.INFORMATION_MESSAGE));
        helpMenu.add(aboutItem);

        menuBar.add(fileMenu);
        menuBar.add(editMenu);
        menuBar.add(formatMenu);
        menuBar.add(helpMenu);
        setJMenuBar(menuBar);

        // Status Bar
        JLabel statusBar = new JLabel(" Ready");
        statusBar.setBorder(BorderFactory.createLoweredBevelBorder());
        textArea.addCaretListener(e -> {
            try {
                int pos = textArea.getCaretPosition();
                int line = textArea.getLineOfOffset(pos);
                int col = pos - textArea.getLineStartOffset(line);
                statusBar.setText(" Line: " + (line + 1) + " | Column: " + (col + 1) +
                        " | Length: " + textArea.getText().length());
            } catch (Exception ex) { /* ignore */ }
        });

        // File Chooser
        fileChooser = new JFileChooser();
        fileChooser.setFileFilter(new FileNameExtensionFilter("Text Files", "txt", "java", "md"));

        // Layout
        add(scrollPane, BorderLayout.CENTER);
        add(statusBar, BorderLayout.SOUTH);

        setVisible(true);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        String command = e.getActionCommand();

        switch (command) {
            case "New":
                textArea.setText("");
                currentFile = null;
                setTitle("Notepad - Untitled");
                break;

            case "Open":
                if (fileChooser.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
                    File file = fileChooser.getSelectedFile();
                    try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                        textArea.setText("");
                        String line;
                        while ((line = reader.readLine()) != null) {
                            textArea.append(line + "\n");
                        }
                        currentFile = file.getAbsolutePath();
                        setTitle("Notepad - " + file.getName());
                    } catch (IOException ex) {
                        JOptionPane.showMessageDialog(this, "Error opening file: " + ex.getMessage());
                    }
                }
                break;

            case "Save":
                if (currentFile != null) {
                    saveFile(currentFile);
                } else {
                    saveAs();
                }
                break;

            case "Save As":
                saveAs();
                break;

            case "Exit":
                int choice = JOptionPane.showConfirmDialog(this,
                        "Do you want to save before exiting?", "Exit",
                        JOptionPane.YES_NO_CANCEL_OPTION);
                if (choice == JOptionPane.YES_OPTION) {
                    if (currentFile != null) saveFile(currentFile);
                    else saveAs();
                    System.exit(0);
                } else if (choice == JOptionPane.NO_OPTION) {
                    System.exit(0);
                }
                break;
        }
    }

    private void saveAs() {
        if (fileChooser.showSaveDialog(this) == JFileChooser.APPROVE_OPTION) {
            File file = fileChooser.getSelectedFile();
            currentFile = file.getAbsolutePath();
            saveFile(currentFile);
            setTitle("Notepad - " + file.getName());
        }
    }

    private void saveFile(String path) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(path))) {
            writer.write(textArea.getText());
            JOptionPane.showMessageDialog(this, "File saved successfully!");
        } catch (IOException ex) {
            JOptionPane.showMessageDialog(this, "Error saving file: " + ex.getMessage());
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(Notepad::new);
    }
}
```

### Visual

```
┌─────────────────────────────────────────────────────────┐
│  Notepad - Untitled                        [_] [□] [X]  │
├───────┬────────┬──────────┬──────────────────────────────┤
│ File  │  Edit  │  Format  │  Help                        │
├───────┴────────┴──────────┴──────────────────────────────┤
│                                                          │
│  public class Hello {                                    │
│      public static void main(String[] args) {            │
│          System.out.println("Hello World!");              │
│      }                                                   │
│  }                                                       │
│                                                          │
│                                                          │
│                                                          │
├──────────────────────────────────────────────────────────┤
│  Line: 3 | Column: 12 | Length: 142                      │
└──────────────────────────────────────────────────────────┘
```

---

# Practice Sections

## 📝 Practice Section – Swing Components

### Level 1 – Very Simple Checks (10 Questions)

| # | Question | Answer |
|---|----------|--------|
| 1 | What prefix do all Swing components have? | "J" (e.g., JButton, JFrame) |
| 2 | What is the default layout of JFrame? | BorderLayout |
| 3 | What is the default layout of JPanel? | FlowLayout |
| 4 | Which method makes a JFrame visible? | `setVisible(true)` |
| 5 | Which component is used for password input? | JPasswordField |
| 6 | How do you group JRadioButtons? | Using ButtonGroup |
| 7 | Which interface handles button clicks? | ActionListener |
| 8 | What package contains Swing classes? | `javax.swing` |
| 9 | Which layout arranges in 5 regions? | BorderLayout |
| 10 | What method gets text from JTextField? | `getText()` |

### Level 2 – Concept MCQs (10 Questions)

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Swing components are? | A) Heavyweight B) Lightweight C) Native D) OS-dependent | **B** |
| 2 | Which is NOT a Swing component? | A) JButton B) JLabel C) Button D) JComboBox | **C** (Button is AWT) |
| 3 | `setDefaultCloseOperation(EXIT_ON_CLOSE)` does? | A) Hides window B) Terminates JVM C) Nothing D) Minimizes | **B** |
| 4 | FlowLayout arranges components? | A) In grid B) Left to right C) In 5 regions D) Top to bottom | **B** |
| 5 | Which method centers JFrame on screen? | A) `setCenter()` B) `setLocationRelativeTo(null)` C) `centerFrame()` D) `pack()` | **B** |
| 6 | JTextArea vs JTextField difference? | A) No difference B) Multi-line vs single-line C) Read-only vs editable D) Color | **B** |
| 7 | GridLayout cells are? | A) Variable size B) Equal size C) Auto-sized D) Zero-sized | **B** |
| 8 | MouseAdapter vs MouseListener? | A) Same thing B) Adapter is abstract C) Adapter lets you override only needed methods D) Listener is faster | **C** |
| 9 | `SwingUtilities.invokeLater()` is used for? | A) Delays B) Thread-safe GUI creation C) Animation D) Closing | **B** |
| 10 | JTable requires what for headers to show? | A) JPanel B) JScrollPane C) JLabel D) Nothing | **B** |

### Level 3 – Deep Understanding MCQs (5 Questions)

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Why use `SwingUtilities.invokeLater()`? | A) Performance B) Swing is NOT thread-safe — ensures GUI runs on EDT C) Style D) Debugging | **B** — Event Dispatch Thread |
| 2 | `pack()` vs `setSize()`? | A) Same B) pack() sizes to fit components, setSize() sets fixed size C) pack() is faster D) setSize() is deprecated | **B** |
| 3 | Why is null layout discouraged? | A) Slower B) Not portable — doesn't adjust to different screens/fonts C) Causes errors D) Not supported | **B** |
| 4 | What happens if no layout is set on JPanel? | A) Error B) FlowLayout used (default) C) No components visible D) Grid used | **B** |
| 5 | JComboBox `setEditable(true)` allows? | A) Multiple selection B) User to type custom value C) Drag and drop D) Sorting | **B** |

### Level 4 – Quick True/False (5 Questions)

| # | Statement | Answer |
|---|-----------|--------|
| 1 | Swing is part of the java.awt package | **False** (javax.swing) |
| 2 | JFrame uses BorderLayout by default | **True** |
| 3 | Multiple JCheckBoxes can be selected at same time | **True** |
| 4 | KeyListener works on JFrame without setFocusable(true) | **False** |
| 5 | JTable headers are visible without JScrollPane | **False** |

### Level 5 – Small Coding Practice

**Exercise 1:** Create a JFrame with a button that shows the current date and time in a JLabel when clicked.

```java
import javax.swing.*;
import java.awt.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class DateTimeApp {
    public static void main(String[] args) {
        JFrame frame = new JFrame("Date Time App");
        frame.setSize(400, 150);
        frame.setLayout(new FlowLayout());

        JLabel label = new JLabel("Click the button to see date/time");
        JButton btn = new JButton("Show Date & Time");

        btn.addActionListener(e -> {
            String dateTime = LocalDateTime.now()
                    .format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss"));
            label.setText("Current: " + dateTime);
        });

        frame.add(btn);
        frame.add(label);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }
}
```

**Exercise 2:** Create a simple temperature converter (Celsius to Fahrenheit and vice versa).

```java
import javax.swing.*;
import java.awt.*;

public class TempConverter {
    public static void main(String[] args) {
        JFrame frame = new JFrame("Temperature Converter");
        frame.setSize(400, 200);
        frame.setLayout(new FlowLayout(FlowLayout.CENTER, 10, 20));

        JTextField input = new JTextField(10);
        JLabel resultLabel = new JLabel("Result: ");
        JButton cToF = new JButton("°C → °F");
        JButton fToC = new JButton("°F → °C");

        cToF.addActionListener(e -> {
            try {
                double c = Double.parseDouble(input.getText());
                double f = (c * 9 / 5) + 32;
                resultLabel.setText(String.format("%.2f°C = %.2f°F", c, f));
            } catch (NumberFormatException ex) {
                resultLabel.setText("Enter a valid number!");
            }
        });

        fToC.addActionListener(e -> {
            try {
                double f = Double.parseDouble(input.getText());
                double c = (f - 32) * 5 / 9;
                resultLabel.setText(String.format("%.2f°F = %.2f°C", f, c));
            } catch (NumberFormatException ex) {
                resultLabel.setText("Enter a valid number!");
            }
        });

        frame.add(new JLabel("Enter Temperature:"));
        frame.add(input);
        frame.add(cToF);
        frame.add(fToC);
        frame.add(resultLabel);

        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }
}
```

---

### 20 Tricky Interview MCQs – Java Swing

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Swing runs on which thread? | A) Main thread B) Event Dispatch Thread (EDT) C) Daemon thread D) Any thread | **B** |
| 2 | Which is lightweight? | A) Button (AWT) B) JButton (Swing) C) Both D) Neither | **B** |
| 3 | `JFrame.DISPOSE_ON_CLOSE` vs `EXIT_ON_CLOSE`? | A) Same B) DISPOSE closes window only, EXIT terminates JVM C) No difference D) DISPOSE is faster | **B** |
| 4 | Can you add JFrame to another JFrame? | A) Yes B) No — JFrame is a top-level container C) Only with layouts D) Only one level deep | **B** |
| 5 | `JOptionPane.showConfirmDialog()` returns? | A) String B) boolean C) int (YES=0, NO=1, CANCEL=2) D) void | **C** |
| 6 | Which method should be called LAST when setting up JFrame? | A) setSize() B) setLayout() C) setVisible(true) D) add() | **C** |
| 7 | Swing is successor to? | A) JavaFX B) AWT C) SWT D) Qt | **B** |
| 8 | `getContentPane()` returns? | A) JFrame B) JPanel C) Container D) Component | **C** |
| 9 | How many components can each region of BorderLayout hold? | A) Unlimited B) 1 C) 5 D) Depends on component | **B** |
| 10 | JTextField default columns affect? | A) Character limit B) Preferred width C) Font size D) Nothing | **B** (display width, not limit) |
| 11 | Which is NOT a valid layout? | A) FlowLayout B) BorderLayout C) LineLayout D) GridLayout | **C** |
| 12 | `JLabel` can display? | A) Only text B) Only image C) Text and image D) Neither | **C** |
| 13 | KeyEvent.VK_ENTER represents? | A) Space B) Enter key C) Escape D) Tab | **B** |
| 14 | `isSelected()` is method of? | A) JButton B) JTextField C) JCheckBox D) JLabel | **C** (also JRadioButton) |
| 15 | `setEditable(false)` on JTextField makes it? | A) Invisible B) Read-only C) Disabled D) Empty | **B** |
| 16 | To add scrollbar to JTextArea, wrap it in? | A) JPanel B) JScrollPane C) JFrame D) JViewport | **B** |
| 17 | ActionEvent.getSource() returns? | A) String B) int C) Object (the source component) D) ActionListener | **C** |
| 18 | Which Swing class shows popup dialogs? | A) JDialog B) JOptionPane C) JPopup D) JAlert | **B** |
| 19 | `repaint()` triggers which method? | A) main() B) paintComponent() C) update() D) refresh() | **B** |
| 20 | MVC in Swing: JButton's model stores? | A) Color B) Size C) State (pressed, enabled, armed) D) Text | **C** |

---

## 🎯 Final Quick Revision – Java Swing

```
┌─────────────────────────────────────────────────────────────────┐
│                    JAVA SWING SUMMARY                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  CORE CONCEPTS:                                                  │
│  • Swing = Lightweight GUI toolkit (javax.swing)                │
│  • All components have "J" prefix                                │
│  • JFrame = main window, JPanel = container                     │
│  • Event-driven: Source → Event → Listener                      │
│                                                                  │
│  COMPONENTS:                                                     │
│  • Input: JTextField, JPasswordField, JTextArea                 │
│  • Selection: JCheckBox, JRadioButton, JComboBox                │
│  • Display: JLabel, JTable                                      │
│  • Action: JButton                                               │
│  • Container: JPanel, JScrollPane                                │
│                                                                  │
│  LAYOUTS:                                                        │
│  • FlowLayout (JPanel default) — left to right flow             │
│  • BorderLayout (JFrame default) — N/S/E/W/CENTER              │
│  • GridLayout — equal-size grid                                  │
│  • BoxLayout — single row or column                             │
│                                                                  │
│  EVENTS:                                                         │
│  • ActionListener → button clicks                                │
│  • MouseListener → mouse events                                 │
│  • KeyListener → keyboard events                                │
│  • Use Adapter classes for convenience                           │
│                                                                  │
│  BEST PRACTICES:                                                 │
│  • Use SwingUtilities.invokeLater() for thread safety           │
│  • Call setVisible(true) LAST                                    │
│  • Use layout managers instead of null layout                   │
│  • Wrap scrollable components in JScrollPane                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

> **📌 Tip:** Practice building these mini projects step by step. Start with a JFrame, add components one at a time, and add event handlers last!

---

# 🖼️ Visual Reference Diagrams – Java Swing

## 📌 Swing Component Hierarchy

```
┌─────────────────────────────────────────────────────────────────┐
│              SWING COMPONENT HIERARCHY                           │
│                                                                  │
│  java.awt.Component                                              │
│  └── java.awt.Container                                          │
│      └── javax.swing.JComponent                                  │
│          ├── JLabel          (text/image display)               │
│          ├── AbstractButton                                      │
│          │   ├── JButton     (clickable button)                 │
│          │   ├── JCheckBox   (on/off toggle)                    │
│          │   ├── JRadioButton(one of many)                      │
│          │   └── JToggleButton                                  │
│          ├── JTextField      (single-line input)                │
│          ├── JTextArea       (multi-line input)                 │
│          ├── JComboBox       (dropdown list)                    │
│          ├── JList           (scrollable list)                  │
│          ├── JTable          (tabular data)                     │
│          ├── JPanel          (container for grouping)           │
│          ├── JScrollPane     (adds scrollbars)                  │
│          ├── JMenuBar/JMenu/JMenuItem (menus)                   │
│          └── JOptionPane     (dialogs: confirm, input, message) │
│                                                                  │
│  Top-Level Containers (special):                                 │
│  ├── JFrame   ← Main window (most used)                        │
│  ├── JDialog  ← Popup window                                   │
│  └── JApplet  ← Browser applet (deprecated)                    │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 Layout Manager Comparison

```
┌─────────────────────────────────────────────────────────────────┐
│              LAYOUT MANAGER COMPARISON                           │
│                                                                  │
│  FlowLayout (default for JPanel):                               │
│  ┌──────────────────────────────────────────┐                   │
│  │ [Btn1] [Btn2] [Btn3] [Btn4]              │  ← left to right │
│  │ [Btn5] [Btn6]                            │  ← wraps         │
│  └──────────────────────────────────────────┘                   │
│                                                                  │
│  BorderLayout (default for JFrame):                             │
│  ┌──────────────────────────────────────────┐                   │
│  │              NORTH                       │                   │
│  ├────────┬──────────────────┬──────────────┤                   │
│  │  WEST  │     CENTER       │    EAST      │                   │
│  ├────────┴──────────────────┴──────────────┤                   │
│  │              SOUTH                       │                   │
│  └──────────────────────────────────────────┘                   │
│                                                                  │
│  GridLayout(rows, cols):                                        │
│  ┌──────────────────────────────────────────┐                   │
│  │ [Cell0] │ [Cell1] │ [Cell2]              │  ← row 1         │
│  │─────────┼─────────┼──────────            │                   │
│  │ [Cell3] │ [Cell4] │ [Cell5]              │  ← row 2         │
│  └──────────────────────────────────────────┘                   │
│                                                                  │
│  GridBagLayout: Most flexible — use GridBagConstraints         │
│  ┌──────────────────────────────────────────┐                   │
│  │ [Label    ] [Input field................]│   colspan=2       │
│  │ [Short Btn] [──Long Button────────────] │   gridwidth       │
│  └──────────────────────────────────────────┘                   │
│                                                                  │
│  BoxLayout: Horizontal or Vertical stack                        │
│  X_AXIS: [Btn1] [Btn2] [Btn3]   (horizontal)                   │
│  Y_AXIS: [Btn1]                  (vertical stack)               │
│          [Btn2]                                                  │
│          [Btn3]                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 Event Delegation Model

```
┌─────────────────────────────────────────────────────────────────┐
│              EVENT DELEGATION MODEL                              │
│                                                                  │
│    User Action                                                   │
│        │                                                         │
│        ▼                                                         │
│   ┌──────────────────┐                                          │
│   │   Event Source   │  (JButton, JTextField, JList, etc.)      │
│   │   button.addActionListener(listener)                        │
│   └────────┬─────────┘                                          │
│            │ Event object created (ActionEvent, MouseEvent, etc)│
│            ▼                                                     │
│   ┌──────────────────┐                                          │
│   │  Event Object    │  (ActionEvent, KeyEvent, MouseEvent...)   │
│   │  - source        │                                          │
│   │  - action command│                                          │
│   │  - time stamp    │                                          │
│   └────────┬─────────┘                                          │
│            │ dispatched to                                       │
│            ▼                                                     │
│   ┌──────────────────┐                                          │
│   │  Event Listener  │  (your code / lambda)                   │
│   │  actionPerformed(e) { ... do something ... }                │
│   └──────────────────┘                                          │
│                                                                  │
│  Interface → Methods:                                            │
│  ActionListener  → actionPerformed(ActionEvent)                 │
│  MouseListener   → mouseClicked, mousePressed, mouseReleased    │
│                    mouseEntered, mouseExited                     │
│  KeyListener     → keyPressed, keyReleased, keyTyped            │
│  WindowListener  → windowClosing, windowOpened, etc.            │
└─────────────────────────────────────────────────────────────────┘
```

## 📌 JFrame Setup Checklist

```
┌─────────────────────────────────────────────────────────────────┐
│            JFRAME SETUP CHECKLIST                               │
│                                                                  │
│  ✓ 1. Create JFrame:        JFrame frame = new JFrame("Title"); │
│  ✓ 2. Set size:             frame.setSize(400, 300);            │
│  ✓ 3. Close operation:      frame.setDefaultCloseOperation(     │
│                                 JFrame.EXIT_ON_CLOSE);          │
│  ✓ 4. Set layout:           frame.setLayout(new BorderLayout());│
│  ✓ 5. Add components:       frame.add(panel, BorderLayout.CENTER│
│  ✓ 6. Set visible LAST:     frame.setVisible(true);             │
│                                                                  │
│  THREAD SAFETY (swing not thread-safe):                         │
│  ✓ Always run on EDT:                                           │
│    SwingUtilities.invokeLater(() -> {                           │
│        new MyFrame().setVisible(true);                          │
│    });                                                           │
│                                                                  │
│  Look and Feel:                                                  │
│  UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName│
└─────────────────────────────────────────────────────────────────┘
```

---

# 📚 Extra Examples – Swing GUI

## Example: Complete Registration Form

```java
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class RegistrationForm extends JFrame {
    private JTextField nameField, emailField, ageField;
    private JComboBox<String> genderBox;
    private JCheckBox termsCheck;
    private JLabel resultLabel;

    public RegistrationForm() {
        setTitle("User Registration");
        setSize(450, 350);
        setDefaultCloseOperation(EXIT_ON_CLOSE);

        JPanel form = new JPanel(new GridBagLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5,5,5,5);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        // Name row
        gbc.gridx=0; gbc.gridy=0; form.add(new JLabel("Name:"), gbc);
        gbc.gridx=1; nameField = new JTextField(20); form.add(nameField, gbc);

        // Email row
        gbc.gridx=0; gbc.gridy=1; form.add(new JLabel("Email:"), gbc);
        gbc.gridx=1; emailField = new JTextField(20); form.add(emailField, gbc);

        // Age row
        gbc.gridx=0; gbc.gridy=2; form.add(new JLabel("Age:"), gbc);
        gbc.gridx=1; ageField = new JTextField(5); form.add(ageField, gbc);

        // Gender row
        gbc.gridx=0; gbc.gridy=3; form.add(new JLabel("Gender:"), gbc);
        gbc.gridx=1;
        genderBox = new JComboBox<>(new String[]{"Male","Female","Other","Prefer not to say"});
        form.add(genderBox, gbc);

        // T&C
        gbc.gridx=0; gbc.gridy=4; gbc.gridwidth=2;
        termsCheck = new JCheckBox("I agree to Terms and Conditions");
        form.add(termsCheck, gbc);

        // Buttons
        gbc.gridy=5; gbc.gridwidth=1; gbc.gridx=0;
        JButton submitBtn = new JButton("Register");
        JButton clearBtn  = new JButton("Clear");
        form.add(submitBtn, gbc);
        gbc.gridx=1; form.add(clearBtn, gbc);

        // Result label
        gbc.gridx=0; gbc.gridy=6; gbc.gridwidth=2;
        resultLabel = new JLabel("");
        resultLabel.setHorizontalAlignment(SwingConstants.CENTER);
        form.add(resultLabel, gbc);

        // Event: Register
        submitBtn.addActionListener(e -> {
            if (!termsCheck.isSelected()) {
                resultLabel.setForeground(Color.RED);
                resultLabel.setText("Please accept Terms & Conditions!");
                return;
            }
            String name   = nameField.getText().trim();
            String email  = emailField.getText().trim();
            String ageStr = ageField.getText().trim();
            String gender = (String) genderBox.getSelectedItem();

            if (name.isEmpty() || email.isEmpty() || ageStr.isEmpty()) {
                resultLabel.setForeground(Color.RED);
                resultLabel.setText("All fields are required!");
                return;
            }
            try {
                int age = Integer.parseInt(ageStr);
                resultLabel.setForeground(new Color(0, 128, 0));
                resultLabel.setText("✓ Registered: " + name + " (" + age + ") - " + gender);
            } catch (NumberFormatException ex) {
                resultLabel.setForeground(Color.RED);
                resultLabel.setText("Age must be a number!");
            }
        });

        // Event: Clear
        clearBtn.addActionListener(e -> {
            nameField.setText("");
            emailField.setText("");
            ageField.setText("");
            genderBox.setSelectedIndex(0);
            termsCheck.setSelected(false);
            resultLabel.setText("");
        });

        add(form);
        setLocationRelativeTo(null);
        setVisible(true);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(RegistrationForm::new);
    }
}
```

## Example: Simple Text Editor

```java
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;

public class SimpleTextEditor extends JFrame {
    private JTextArea textArea;
    private JLabel statusBar;

    public SimpleTextEditor() {
        setTitle("Simple Text Editor");
        setSize(700, 500);
        setDefaultCloseOperation(EXIT_ON_CLOSE);

        textArea = new JTextArea(20, 60);
        textArea.setFont(new Font("Monospaced", Font.PLAIN, 14));
        textArea.setTabSize(4);
        add(new JScrollPane(textArea), BorderLayout.CENTER);

        statusBar = new JLabel("Ready");
        add(statusBar, BorderLayout.SOUTH);

        // Menu bar
        JMenuBar menuBar = new JMenuBar();

        JMenu fileMenu = new JMenu("File");
        JMenuItem newItem  = new JMenuItem("New");
        JMenuItem openItem = new JMenuItem("Open");
        JMenuItem saveItem = new JMenuItem("Save");
        JMenuItem exitItem = new JMenuItem("Exit");
        fileMenu.add(newItem); fileMenu.add(openItem);
        fileMenu.add(saveItem); fileMenu.addSeparator(); fileMenu.add(exitItem);

        JMenu editMenu = new JMenu("Edit");
        JMenuItem cutItem   = new JMenuItem("Cut");
        JMenuItem copyItem  = new JMenuItem("Copy");
        JMenuItem pasteItem = new JMenuItem("Paste");
        JMenuItem selectAll = new JMenuItem("Select All");
        editMenu.add(cutItem); editMenu.add(copyItem);
        editMenu.add(pasteItem); editMenu.add(selectAll);

        menuBar.add(fileMenu); menuBar.add(editMenu);
        setJMenuBar(menuBar);

        // File actions
        newItem.addActionListener(e -> { textArea.setText(""); setTitle("New File"); });
        saveItem.addActionListener(e -> saveFile());
        openItem.addActionListener(e -> openFile());
        exitItem.addActionListener(e -> System.exit(0));

        // Edit actions
        cutItem.addActionListener(e -> textArea.cut());
        copyItem.addActionListener(e -> textArea.copy());
        pasteItem.addActionListener(e -> textArea.paste());
        selectAll.addActionListener(e -> textArea.selectAll());

        // Word count on text change
        textArea.addKeyListener(new KeyAdapter() {
            @Override public void keyReleased(KeyEvent e) {
                String text = textArea.getText();
                int words = text.trim().isEmpty() ? 0 : text.trim().split("\\s+").length;
                int chars = text.length();
                statusBar.setText("Words: " + words + " | Chars: " + chars);
            }
        });

        setLocationRelativeTo(null);
        setVisible(true);
    }

    void openFile() {
        JFileChooser fc = new JFileChooser();
        if (fc.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
            try (BufferedReader br = new BufferedReader(new FileReader(fc.getSelectedFile()))) {
                textArea.read(br, null);
                setTitle(fc.getSelectedFile().getName());
                statusBar.setText("Opened: " + fc.getSelectedFile().getPath());
            } catch (IOException ex) {
                JOptionPane.showMessageDialog(this, "Error opening file: " + ex.getMessage());
            }
        }
    }

    void saveFile() {
        JFileChooser fc = new JFileChooser();
        if (fc.showSaveDialog(this) == JFileChooser.APPROVE_OPTION) {
            try (PrintWriter pw = new PrintWriter(new FileWriter(fc.getSelectedFile()))) {
                textArea.write(pw);
                statusBar.setText("Saved: " + fc.getSelectedFile().getPath());
            } catch (IOException ex) {
                JOptionPane.showMessageDialog(this, "Error saving: " + ex.getMessage());
            }
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(SimpleTextEditor::new);
    }
}
```

---

# 📝 Extended Question Bank – Java Swing

## ✍️ Fill in the Blanks – Swing

| # | Statement | Answer |
|---|-----------|--------|
| 1 | `JFrame` is the _______ window in a Swing application. | **main / top-level** |
| 2 | `setVisible(true)` must be called _______ all components are added. | **after** |
| 3 | Default layout of `JFrame` is _______. | **BorderLayout** |
| 4 | Default layout of `JPanel` is _______. | **FlowLayout** |
| 5 | `JScrollPane` wraps a component to add _______. | **scroll bars** |
| 6 | `JOptionPane.showMessageDialog()` shows a _______ dialog. | **message / popup** |
| 7 | `ActionListener.actionPerformed()` takes a _______ parameter. | **ActionEvent** |
| 8 | `SwingUtilities.invokeLater()` ensures GUI runs on the _______ Thread. | **Event Dispatch Thread (EDT)** |
| 9 | `JList` requires a _______ to hold its data. | **ListModel / DefaultListModel** |
| 10 | `GridLayout(3, 2)` creates _______ rows and _______ columns. | **3 / 2** |
| 11 | `JTextField.getText()` returns a _______. | **String** |
| 12 | `setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)` exits app when _______ is clicked. | **close (X) button** |
| 13 | `JButton.addActionListener()` registers a listener for _______ events. | **click / action** |
| 14 | `JLabel.setForeground(Color.RED)` changes _______ color. | **text** |
| 15 | `repaint()` method on a component triggers a _______. | **redraw / repaint** |

---

## 🔗 Match the Following – Swing

### Set A – Component to Purpose

| Component | Purpose |
|-----------|---------|
| 1. JTextField | A. Displays non-editable text or icon |
| 2. JLabel | B. Multi-line scrollable text editing |
| 3. JComboBox | C. Single-line text input |
| 4. JTextArea | D. Choose one from a dropdown list |
| 5. JCheckBox | E. Toggle on/off independently |

**Answers:** 1→C, 2→A, 3→D, 4→B, 5→E

---

### Set B – Layout Managers

| Layout | Behavior |
|--------|----------|
| 1. FlowLayout | A. 5 regions: N/S/E/W/Center |
| 2. BorderLayout | B. Equal-sized cells in a grid |
| 3. GridLayout | C. Left-to-right, wraps to next line |
| 4. GridBagLayout | D. Vertical or horizontal stack |
| 5. BoxLayout | E. Most flexible, uses constraints |

**Answers:** 1→C, 2→A, 3→B, 4→E, 5→D

---

## 🐛 Error Spotting – Swing

### Bug 1
```java
JFrame frame = new JFrame("My App");
JButton btn = new JButton("Click");
frame.add(btn);
frame.setSize(300, 200);
// Missing frame.setVisible(true);
```
**Bug:** `setVisible(true)` is missing — window won't show. Add `frame.setVisible(true)` at end.

---

### Bug 2
```java
new JFrame("App").setVisible(true); // Direct on main thread
```
**Bug:** Swing must run on EDT. Should use:
```java
SwingUtilities.invokeLater(() -> new JFrame("App").setVisible(true));
```

---

### Bug 3
```java
JFrame frame = new JFrame();
frame.setLayout(new BorderLayout());
frame.add(new JButton("A"), BorderLayout.NORTH);
frame.add(new JButton("B"), BorderLayout.NORTH); // Bug!
```
**Bug:** Only one component per region in BorderLayout — second add replaces the first. Use a JPanel to add multiple in one region.

---

### Bug 4
```java
JTextField tf = new JTextField();
int value = Integer.parseInt(tf.getText()); // may crash!
```
**Bug:** If `tf.getText()` returns empty string or non-numeric, throws `NumberFormatException`. Always validate/wrap in try-catch.

---

### Bug 5
```java
class MyFrame extends JFrame {
    MyFrame() {
        JButton btn = new JButton("OK");
        btn.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                System.out.println(tf.getText()); // Bug!
            }
        });
        JTextField tf = new JTextField(10); // declared AFTER use!
        add(btn); add(tf);
    }
}
```
**Bug:** `tf` is declared after it's referenced in anonymous class. Move `tf` declaration before the listener attachment.

---

## 🖥️ Output Prediction – Swing Event Order

### Q1 — What happens step by step?
```java
JButton btn = new JButton("Go");
btn.addActionListener(e -> System.out.println("Action 1"));
btn.addActionListener(e -> System.out.println("Action 2"));
// User clicks btn
```
**Output (in order):**
```
Action 1
Action 2
```
> Multiple listeners execute in the order they were added.

---

### Q2
```java
JTextField tf = new JTextField("hello");
System.out.println(tf.getText().toUpperCase());
```
**Output:** `HELLO`

---

### Q3 — JOptionPane return value
```java
int result = JOptionPane.showConfirmDialog(null, "Are you sure?");
// User clicks "No" (returns 1)
if (result == JOptionPane.YES_OPTION) {
    System.out.println("Yes");
} else if (result == JOptionPane.NO_OPTION) {
    System.out.println("No");
} else {
    System.out.println("Cancel");
}
```
**Output (if user clicks No):** `No`
> YES=0, NO=1, CANCEL=2, CLOSED=-1

---

## 🧐 Short Answer – Swing

| # | Question | Answer |
|---|----------|--------|
| 1 | Why use `SwingUtilities.invokeLater()`? | Swing is not thread-safe; all GUI creation must be on EDT |
| 2 | Difference `setSize()` vs `pack()`? | setSize sets explicit size; pack() sizes frame to fit all components |
| 3 | How to make a button disabled? | `button.setEnabled(false)` |
| 4 | What does `setResizable(false)` do? | Prevents user from resizing the window |
| 5 | How to center a JFrame on screen? | `setLocationRelativeTo(null)` |
| 6 | What is an Adapter class in Swing? | Abstract class implementing a listener with empty methods — override only what you need (e.g., MouseAdapter) |
| 7 | Difference `JTextField` vs `JPasswordField`? | JPasswordField masks characters (shows dots/asterisks) |
| 8 | How to add a tooltip to a button? | `button.setToolTipText("Click to submit")` |
| 9 | What is `JOptionPane.showInputDialog()` used for? | Displays a dialog to get user text input |
| 10 | Why wrap JTextArea in JScrollPane? | JTextArea itself has no scrollbars — JScrollPane adds them |
