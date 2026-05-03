# 11. Object-Oriented Programming — Advanced

## Table of Contents
- [11.1 Inheritance](#111-inheritance)
- [11.2 Polymorphism](#112-polymorphism)
- [11.3 Abstraction](#113-abstraction)
- [11.4 Magic/Dunder Methods](#114-magicdunder-methods)
- [11.5 Multiple Inheritance and MRO](#115-multiple-inheritance-and-mro)
- [11.6 Practice & Assessment](#116-practice--assessment)

---

## 11.1 Inheritance

### Definition
**Inheritance** allows a class (child) to inherit attributes and methods from another class (parent).

```
┌─────────────────────────────────────────────────┐
│  INHERITANCE TYPES                               │
│                                                 │
│  Single:    Animal → Dog                        │
│  Multi-level: Animal → Dog → GoldenRetriever    │
│  Multiple:  Flyable + Swimmable → Duck          │
│  Hierarchical: Shape → Circle                   │
│                     → Rectangle                 │
└─────────────────────────────────────────────────┘
```

### Single Inheritance

```python
class Animal:
    def __init__(self, name, sound):
        self.name = name
        self.sound = sound
    
    def speak(self):
        return f"{self.name} says {self.sound}!"
    
    def info(self):
        return f"I am {self.name}"

class Dog(Animal):  # Dog inherits from Animal
    def __init__(self, name, breed):
        super().__init__(name, "Woof")  # Call parent constructor
        self.breed = breed
    
    def fetch(self):
        return f"{self.name} fetches the ball!"

class Cat(Animal):
    def __init__(self, name):
        super().__init__(name, "Meow")
    
    def purr(self):
        return f"{self.name} is purring..."

# Usage
dog = Dog("Buddy", "Labrador")
cat = Cat("Whiskers")

print(dog.speak())    # Buddy says Woof! (inherited)
print(dog.fetch())    # Buddy fetches the ball! (own method)
print(cat.speak())    # Whiskers says Meow! (inherited)
print(cat.purr())     # Whiskers is purring... (own method)

print(isinstance(dog, Animal))  # True
print(isinstance(dog, Dog))     # True
```

### Method Overriding

```python
class Shape:
    def area(self):
        return 0
    
    def __str__(self):
        return f"{self.__class__.__name__}: area = {self.area():.2f}"

class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius
    
    def area(self):  # Override parent method
        return 3.14159 * self.radius ** 2

class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height
    
    def area(self):  # Override parent method
        return self.width * self.height

shapes = [Circle(5), Rectangle(4, 6), Circle(3)]
for shape in shapes:
    print(shape)

# Output:
# Circle: area = 78.54
# Rectangle: area = 24.00
# Circle: area = 28.27
```

---

## 11.2 Polymorphism

### Definition
**Polymorphism** = "many forms" — same interface, different behaviors.

### Duck Typing

```python
# "If it walks like a duck and quacks like a duck, it's a duck"
class Duck:
    def speak(self):
        return "Quack!"

class Dog:
    def speak(self):
        return "Woof!"

class Cat:
    def speak(self):
        return "Meow!"

# Polymorphism — same method name, different classes
def animal_sound(animal):
    print(animal.speak())  # Works for ANY object with speak()

animal_sound(Duck())  # Quack!
animal_sound(Dog())   # Woof!
animal_sound(Cat())   # Meow!
```

### Operator Overloading

```python
class Vector:
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def __add__(self, other):
        return Vector(self.x + other.x, self.y + other.y)
    
    def __sub__(self, other):
        return Vector(self.x - other.x, self.y - other.y)
    
    def __mul__(self, scalar):
        return Vector(self.x * scalar, self.y * scalar)
    
    def __eq__(self, other):
        return self.x == other.x and self.y == other.y
    
    def __str__(self):
        return f"Vector({self.x}, {self.y})"

v1 = Vector(2, 3)
v2 = Vector(1, 4)

print(v1 + v2)   # Vector(3, 7)
print(v1 - v2)   # Vector(1, -1)
print(v1 * 3)    # Vector(6, 9)
print(v1 == v2)  # False
```

---

## 11.3 Abstraction

### Definition
**Abstraction** = hiding complex implementation details and showing only the essential interface.

```python
from abc import ABC, abstractmethod

class Shape(ABC):  # Abstract Base Class
    @abstractmethod
    def area(self):
        """Must be implemented by all subclasses."""
        pass
    
    @abstractmethod
    def perimeter(self):
        pass
    
    # Concrete method (can be inherited as-is)
    def description(self):
        return f"{self.__class__.__name__}: area={self.area():.2f}"

# shape = Shape()  → TypeError: Can't instantiate abstract class!

class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius
    
    def area(self):
        return 3.14159 * self.radius ** 2
    
    def perimeter(self):
        return 2 * 3.14159 * self.radius

class Square(Shape):
    def __init__(self, side):
        self.side = side
    
    def area(self):
        return self.side ** 2
    
    def perimeter(self):
        return 4 * self.side

c = Circle(5)
s = Square(4)
print(c.description())  # Circle: area=78.54
print(s.perimeter())    # 16
```

---

## 11.4 Magic/Dunder Methods

### Common Dunder Methods

| Method | Triggered By | Purpose |
|--------|-------------|---------|
| `__init__` | `obj = Class()` | Constructor |
| `__str__` | `str(obj)`, `print(obj)` | Human-readable string |
| `__repr__` | `repr(obj)` | Developer string |
| `__len__` | `len(obj)` | Length |
| `__getitem__` | `obj[key]` | Indexing |
| `__setitem__` | `obj[key] = val` | Assignment |
| `__contains__` | `x in obj` | Membership |
| `__iter__` | `for x in obj` | Iteration |
| `__add__` | `obj + other` | Addition |
| `__eq__` | `obj == other` | Equality |
| `__lt__` | `obj < other` | Less than |
| `__call__` | `obj()` | Make callable |

### Example: Custom List

```python
class Playlist:
    def __init__(self, name):
        self.name = name
        self._songs = []
    
    def add(self, song):
        self._songs.append(song)
    
    def __len__(self):
        return len(self._songs)
    
    def __getitem__(self, index):
        return self._songs[index]
    
    def __contains__(self, song):
        return song in self._songs
    
    def __iter__(self):
        return iter(self._songs)
    
    def __str__(self):
        return f"Playlist '{self.name}' ({len(self)} songs)"

p = Playlist("Rock Classics")
p.add("Bohemian Rhapsody")
p.add("Stairway to Heaven")
p.add("Hotel California")

print(len(p))                       # 3
print(p[0])                         # Bohemian Rhapsody
print("Hotel California" in p)      # True
print(p)                            # Playlist 'Rock Classics' (3 songs)

for song in p:
    print(f"  ♪ {song}")
```

---

## 11.5 Multiple Inheritance and MRO

### Multiple Inheritance

```python
class Flyable:
    def fly(self):
        return "Flying!"

class Swimmable:
    def swim(self):
        return "Swimming!"

class Duck(Flyable, Swimmable):
    def quack(self):
        return "Quack!"

d = Duck()
print(d.fly())    # Flying!
print(d.swim())   # Swimming!
print(d.quack())  # Quack!
```

### Method Resolution Order (MRO)

```python
class A:
    def greet(self):
        return "Hello from A"

class B(A):
    def greet(self):
        return "Hello from B"

class C(A):
    def greet(self):
        return "Hello from C"

class D(B, C):
    pass

d = D()
print(d.greet())  # Hello from B

# MRO — check resolution order
print(D.__mro__)
# (<class 'D'>, <class 'B'>, <class 'C'>, <class 'A'>, <class 'object'>)
# Python uses C3 Linearization algorithm
```

### Mixins Pattern

```python
class JsonMixin:
    """Mixin that adds JSON serialization."""
    def to_json(self):
        import json
        return json.dumps(self.__dict__, indent=2)

class LogMixin:
    """Mixin that adds logging."""
    def log(self, message):
        print(f"[{self.__class__.__name__}] {message}")

class User(JsonMixin, LogMixin):
    def __init__(self, name, email):
        self.name = name
        self.email = email

u = User("Alice", "alice@example.com")
print(u.to_json())  # {"name": "Alice", "email": "alice@example.com"}
u.log("User created")  # [User] User created
```

---

## 11.6 Practice & Assessment

### MCQs

**Q1.** What does `super()` do?
- A) Creates a new class
- B) Calls the parent class method
- C) Makes a method static
- D) Deletes parent attributes

**Answer:** B

---

**Q2.** Can you instantiate an abstract class?
- A) Yes
- B) No

**Answer:** B — Abstract classes with `@abstractmethod` cannot be instantiated.

---

**Q3.** What is the output?
```python
class A:
    def show(self):
        print("A")
class B(A):
    def show(self):
        print("B")
b = B()
b.show()
```
- A) A
- B) B
- C) A B
- D) Error

**Answer:** B — Method overriding; child's method is called.

---

### Coding Task

**Task:** Create a `Shape` hierarchy with abstract base class.

```python
from abc import ABC, abstractmethod
import math

class Shape(ABC):
    @abstractmethod
    def area(self):
        pass
    
    @abstractmethod
    def perimeter(self):
        pass

class Triangle(Shape):
    def __init__(self, a, b, c):
        self.a, self.b, self.c = a, b, c
    
    def perimeter(self):
        return self.a + self.b + self.c
    
    def area(self):
        s = self.perimeter() / 2
        return math.sqrt(s * (s-self.a) * (s-self.b) * (s-self.c))

t = Triangle(3, 4, 5)
print(f"Area: {t.area():.2f}")      # Area: 6.00
print(f"Perimeter: {t.perimeter()}") # Perimeter: 12
```

---

> **Next Topic:** [12 - Advanced Python](12-advanced-python.md)
