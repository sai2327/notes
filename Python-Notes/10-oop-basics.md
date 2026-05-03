# 10. Object-Oriented Programming — Basics

## Table of Contents
- [10.1 What is OOP?](#101-what-is-oop)
- [10.2 Classes and Objects](#102-classes-and-objects)
- [10.3 Constructor (__init__)](#103-constructor-__init__)
- [10.4 Instance vs Class Variables](#104-instance-vs-class-variables)
- [10.5 Methods (Types)](#105-methods-types)
- [10.6 Encapsulation](#106-encapsulation)
- [10.7 Practice & Assessment](#107-practice--assessment)

---

## 10.1 What is OOP?

### Definition
**Object-Oriented Programming (OOP)** is a programming paradigm based on the concept of "objects" that contain data (attributes) and behavior (methods).

### Four Pillars of OOP

```
┌─────────────────────────────────────────────────────────┐
│                FOUR PILLARS OF OOP                        │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────────┐    ┌─────────────────┐            │
│  │  ENCAPSULATION  │    │   INHERITANCE   │            │
│  │  (Hide data)    │    │  (Reuse code)   │            │
│  │  Private attrs  │    │  Parent→Child   │            │
│  └─────────────────┘    └─────────────────┘            │
│                                                         │
│  ┌─────────────────┐    ┌─────────────────┐            │
│  │  POLYMORPHISM   │    │   ABSTRACTION   │            │
│  │  (Many forms)   │    │  (Hide complex) │            │
│  │  Same interface │    │  Show only       │            │
│  │  diff behavior  │    │  essential       │            │
│  └─────────────────┘    └─────────────────┘            │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 10.2 Classes and Objects

### Definition
- **Class:** Blueprint/template for creating objects
- **Object:** Instance of a class (actual entity in memory)

```python
# Class definition
class Dog:
    # Class attribute (shared by all instances)
    species = "Canis familiaris"
    
    # Constructor
    def __init__(self, name, age):
        # Instance attributes (unique to each object)
        self.name = name
        self.age = age
    
    # Method
    def bark(self):
        return f"{self.name} says Woof!"
    
    def info(self):
        return f"{self.name} is {self.age} years old"

# Creating objects (instances)
dog1 = Dog("Buddy", 3)
dog2 = Dog("Max", 5)

print(dog1.bark())   # Buddy says Woof!
print(dog2.info())   # Max is 5 years old
print(dog1.species)  # Canis familiaris
```

### Memory Model

```
┌──────────────────────────────────────────────────┐
│  Class: Dog                                       │
│  ┌────────────────────────────┐                   │
│  │ species = "Canis familiaris"│ (shared)         │
│  │ bark()                      │                  │
│  │ info()                      │                  │
│  └────────────────────────────┘                   │
│                                                   │
│  Instance: dog1          Instance: dog2           │
│  ┌──────────────────┐   ┌──────────────────┐     │
│  │ name = "Buddy"   │   │ name = "Max"     │     │
│  │ age = 3          │   │ age = 5          │     │
│  └──────────────────┘   └──────────────────┘     │
└──────────────────────────────────────────────────┘
```

---

## 10.3 Constructor (__init__)

### Definition
`__init__` is a special method (dunder method) called automatically when an object is created.

```python
class Student:
    def __init__(self, name, grade, gpa=0.0):
        self.name = name
        self.grade = grade
        self.gpa = gpa
        print(f"Student {name} created!")
    
    def __str__(self):
        return f"Student({self.name}, Grade: {self.grade}, GPA: {self.gpa})"
    
    def __repr__(self):
        return f"Student('{self.name}', '{self.grade}', {self.gpa})"

s = Student("Alice", "A", 3.8)
# Output: Student Alice created!

print(s)       # Student(Alice, Grade: A, GPA: 3.8) — calls __str__
print(repr(s)) # Student('Alice', 'A', 3.8) — calls __repr__
```

### `self` Explained
- `self` refers to the **current instance** of the class
- It's always the first parameter of instance methods
- Python passes it automatically when you call a method

```python
class Counter:
    def __init__(self):
        self.count = 0  # Each instance has its own count
    
    def increment(self):
        self.count += 1
        return self
    
    def get_count(self):
        return self.count

c1 = Counter()
c2 = Counter()
c1.increment()
c1.increment()
c2.increment()
print(c1.get_count())  # 2
print(c2.get_count())  # 1 (separate instances!)
```

---

## 10.4 Instance vs Class Variables

```python
class Employee:
    # Class variable — shared by ALL instances
    company = "TechCorp"
    employee_count = 0
    
    def __init__(self, name, salary):
        # Instance variables — unique to each object
        self.name = name
        self.salary = salary
        Employee.employee_count += 1  # Modify class variable
    
    def __del__(self):
        Employee.employee_count -= 1

e1 = Employee("Alice", 50000)
e2 = Employee("Bob", 60000)

print(e1.company)              # TechCorp
print(e2.company)              # TechCorp
print(Employee.employee_count) # 2

# Changing class variable affects all
Employee.company = "NewCorp"
print(e1.company)  # NewCorp
print(e2.company)  # NewCorp

# But assigning to instance creates instance variable!
e1.company = "MyCompany"
print(e1.company)  # MyCompany (instance variable)
print(e2.company)  # NewCorp (still class variable)
```

---

## 10.5 Methods (Types)

### Three Types of Methods

| Type | Decorator | First Param | Access |
|------|-----------|-------------|--------|
| Instance method | None | `self` | Instance + class attrs |
| Class method | `@classmethod` | `cls` | Only class attrs |
| Static method | `@staticmethod` | None | No access to class/instance |

```python
class Pizza:
    # Class variable
    base_price = 10
    
    def __init__(self, size, toppings):
        self.size = size
        self.toppings = toppings
    
    # Instance method — operates on instance data
    def get_price(self):
        return Pizza.base_price + len(self.toppings) * 2
    
    # Class method — operates on class data, alternative constructor
    @classmethod
    def margherita(cls):
        """Factory method — creates a specific Pizza."""
        return cls("Medium", ["mozzarella", "tomato"])
    
    @classmethod
    def set_base_price(cls, price):
        cls.base_price = price
    
    # Static method — utility function (no access to self or cls)
    @staticmethod
    def validate_topping(topping):
        valid = ["mozzarella", "pepperoni", "mushroom", "tomato", "olive"]
        return topping.lower() in valid

# Instance method
p = Pizza("Large", ["pepperoni", "mushroom", "olive"])
print(p.get_price())  # 16

# Class method (factory)
m = Pizza.margherita()
print(m.toppings)  # ['mozzarella', 'tomato']

# Static method
print(Pizza.validate_topping("pepperoni"))  # True
print(Pizza.validate_topping("pineapple"))  # False
```

---

## 10.6 Encapsulation

### Definition
**Encapsulation** = bundling data with methods + restricting direct access to internal data.

### Access Levels in Python

| Convention | Syntax | Meaning |
|-----------|--------|---------|
| Public | `self.name` | Accessible everywhere |
| Protected | `self._name` | Convention: internal use (still accessible) |
| Private | `self.__name` | Name mangling (harder to access) |

```python
class BankAccount:
    def __init__(self, owner, balance):
        self.owner = owner          # Public
        self._account_type = "Savings"  # Protected (convention)
        self.__balance = balance    # Private (name mangled)
    
    # Getter
    @property
    def balance(self):
        return self.__balance
    
    # Setter with validation
    @balance.setter
    def balance(self, amount):
        if amount < 0:
            raise ValueError("Balance cannot be negative!")
        self.__balance = amount
    
    def deposit(self, amount):
        if amount <= 0:
            raise ValueError("Deposit must be positive!")
        self.__balance += amount
        return self.__balance
    
    def withdraw(self, amount):
        if amount > self.__balance:
            raise ValueError("Insufficient funds!")
        self.__balance -= amount
        return self.__balance

# Usage
acc = BankAccount("Alice", 1000)
print(acc.owner)         # Alice (public — OK)
print(acc._account_type) # Savings (protected — accessible but not recommended)
# print(acc.__balance)   # AttributeError! (private)
print(acc.balance)       # 1000 (via property getter)

acc.deposit(500)
print(acc.balance)       # 1500

# acc.balance = -100     # ValueError: Balance cannot be negative!
```

### Property Decorator

```python
class Circle:
    def __init__(self, radius):
        self._radius = radius
    
    @property
    def radius(self):
        """Getter — called when accessing obj.radius"""
        return self._radius
    
    @radius.setter
    def radius(self, value):
        """Setter — called when assigning obj.radius = value"""
        if value <= 0:
            raise ValueError("Radius must be positive!")
        self._radius = value
    
    @property
    def area(self):
        """Read-only property (no setter)"""
        return 3.14159 * self._radius ** 2

c = Circle(5)
print(c.radius)  # 5 (calls getter)
print(c.area)    # 78.54 (computed property)

c.radius = 10    # Calls setter
print(c.area)    # 314.159

# c.area = 100   # AttributeError: can't set (no setter!)
```

---

## 10.7 Practice & Assessment

### MCQs

**Q1.** What does `self` refer to?
- A) The class itself
- B) The current instance
- C) The parent class
- D) A global variable

**Answer:** B

---

**Q2.** What is the output?
```python
class A:
    x = 10
a = A()
b = A()
a.x = 20
print(b.x)
```
- A) 20
- B) 10
- C) Error
- D) None

**Answer:** B — `a.x = 20` creates an instance variable on `a`. `b` still uses the class variable (10).

---

**Q3.** Which decorator creates a class method?
- A) `@staticmethod`
- B) `@classmethod`
- C) `@property`
- D) `@abstract`

**Answer:** B

---

### Coding Task

**Task:** Create a `Rectangle` class with properties for width, height, area, and perimeter.

```python
class Rectangle:
    def __init__(self, width, height):
        self.width = width
        self.height = height
    
    @property
    def area(self):
        return self.width * self.height
    
    @property
    def perimeter(self):
        return 2 * (self.width + self.height)
    
    def __str__(self):
        return f"Rectangle({self.width}x{self.height})"

r = Rectangle(5, 3)
print(r)           # Rectangle(5x3)
print(r.area)      # 15
print(r.perimeter) # 16
```

---

> **Next Topic:** [11 - OOP Advanced](11-oop-advanced.md)
