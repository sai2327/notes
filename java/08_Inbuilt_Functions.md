# 08 – Java Inbuilt Functions – Complete Reference

---

## 1. Number Parsing & Conversion

### Integer

```java
// --- Integer Parsing & Conversion ---

int a = Integer.parseInt("123");              // Convert decimal string → int          → 123
int b = Integer.parseInt("1010", 2);          // Convert binary string → int           → 10
int c = Integer.parseInt("ff", 16);           // Convert hex string → int              → 255

Integer obj = Integer.valueOf("42");          // String → Integer object               → 42
String s1   = Integer.toString(255);          // int → String                          → "255"
String bin  = Integer.toBinaryString(10);     // int → binary string                   → "1010"
String oct  = Integer.toOctalString(10);      // int → octal string                    → "12"
String hex  = Integer.toHexString(255);       // int → hex string                      → "ff"

int max = Integer.MAX_VALUE;                  // Max int constant                      → 2147483647
int min = Integer.MIN_VALUE;                  // Min int constant                      → -2147483648

int bits    = Integer.bitCount(7);            // Count 1-bits in binary of 7 (=111)   → 3
int rev     = Integer.reverse(2);             // Reverse bits of int                   → 1073741824
int revB    = Integer.reverseBytes(0x12345678); // Reverse bytes                       → 0x78563412
int high    = Integer.highestOneBit(10);      // Highest set bit value of 10 (=1010)  → 8
int low     = Integer.lowestOneBit(10);       // Lowest set bit value                  → 2
int lead    = Integer.numberOfLeadingZeros(1);  // Leading zero count                  → 31
int trail   = Integer.numberOfTrailingZeros(8); // Trailing zero count of 8 (=1000)   → 3
int sign    = Integer.signum(-5);             // Sign: -1, 0, or 1                    → -1
int cmp     = Integer.compare(3, 5);          // Compare two ints                      → -1
int imax    = Integer.max(3, 7);              // Max of two ints                       → 7
int imin    = Integer.min(3, 7);              // Min of two ints                       → 3
int isum    = Integer.sum(3, 7);              // Sum of two ints                       → 10
```

### Long

```java
// --- Long Parsing & Conversion ---

long l1  = Long.parseLong("123456789");       // String → long                         → 123456789
long l2  = Long.parseLong("ff", 16);          // Hex string → long                     → 255
String ls = Long.toString(100L);              // long → String                         → "100"
String lb = Long.toBinaryString(1024L);       // long → binary string                  → "10000000000"
String lh = Long.toHexString(255L);           // long → hex string                     → "ff"
String lo = Long.toOctalString(8L);           // long → octal string                   → "10"

long lmax  = Long.MAX_VALUE;                  // Max long                              → 9223372036854775807
long lmin  = Long.MIN_VALUE;                  // Min long                              → -9223372036854775808
int  lbits = Long.bitCount(7L);              // Count 1-bits                          → 3
int  lcmp  = Long.compare(3L, 5L);           // Compare two longs                     → -1
long lmx   = Long.max(10L, 20L);             // Max                                   → 20
long lmn   = Long.min(10L, 20L);             // Min                                   → 10
long lsm   = Long.sum(10L, 20L);             // Sum                                   → 30
long lrv   = Long.reverse(1L);               // Reverse bits
int  lsgn  = Long.signum(-5L);               // Sign                                  → -1
```

### Double & Float

```java
// --- Double & Float ---

double d1 = Double.parseDouble("12.34");      // String → double                       → 12.34
String ds = Double.toString(3.14);            // double → String                       → "3.14"
Double dv = Double.valueOf("1.5");            // String → Double object                → 1.5
boolean nan  = Double.isNaN(0.0 / 0.0);      // Check NaN                             → true
boolean inf  = Double.isInfinite(1.0 / 0.0); // Check Infinite                        → true
int    dcmp  = Double.compare(1.0, 2.0);      // Compare doubles                       → -1
double dmx   = Double.max(3.0, 7.0);          // Max                                   → 7.0
double dmn   = Double.min(3.0, 7.0);          // Min                                   → 3.0
double dmax  = Double.MAX_VALUE;              // Max double                            → 1.79...E308
double dmin  = Double.MIN_VALUE;              // Smallest positive double              → 5E-324

float  f1   = Float.parseFloat("3.14");       // String → float                        → 3.14
int    fcmp = Float.compare(1.0f, 2.0f);      // Compare floats                        → -1
```

---

## 2. Math Functions

```java
// --- Math Functions ---

double pow   = Math.pow(2, 3);               // a^b                                   → 8.0
double sqrt  = Math.sqrt(16);                // Square root                            → 4.0
double cbrt  = Math.cbrt(27);                // Cube root                              → 3.0
int    absi  = Math.abs(-5);                 // Absolute value (int)                   → 5
double absd  = Math.abs(-3.14);              // Absolute value (double)                → 3.14
int    mx    = Math.max(10, 20);             // Maximum                                → 20
int    mn    = Math.min(10, 20);             // Minimum                                → 10
double ceil  = Math.ceil(4.2);               // Smallest integer >= x                  → 5.0
double floor = Math.floor(4.8);              // Largest integer <= x                   → 4.0
long   rnd   = Math.round(4.5);              // Round to nearest integer               → 5
double rint  = Math.rint(4.5);               // Round to nearest (banker's rounding)   → 4.0
double rand  = Math.random();                // Random double in [0.0, 1.0)

double logn  = Math.log(Math.E);             // Natural log (ln)                       → 1.0
double log10 = Math.log10(1000);             // Log base 10                            → 3.0
double exp   = Math.exp(1);                  // e^x                                    → 2.718...
double sin   = Math.sin(Math.PI / 2);        // Sine (radians)                         → 1.0
double cos   = Math.cos(0);                  // Cosine (radians)                       → 1.0
double tan   = Math.tan(Math.PI / 4);        // Tangent (radians)                      → 1.0
double asin  = Math.asin(1.0);               // Arc sine                               → PI/2
double acos  = Math.acos(1.0);               // Arc cosine                             → 0.0
double atan  = Math.atan(1.0);               // Arc tangent                            → PI/4
double atan2 = Math.atan2(1, 1);             // Angle from (x,y) in radians            → PI/4
double hyp   = Math.hypot(3, 4);             // sqrt(x^2 + y^2)                        → 5.0
double sgn   = Math.signum(-5.0);            // Sign as double                         → -1.0

double deg   = Math.toRadians(180);          // Degrees to radians                     → PI
double rad   = Math.toDegrees(Math.PI);      // Radians to degrees                     → 180.0

int  fdiv    = Math.floorDiv(-7, 2);         // Floor division                         → -4
int  fmod    = Math.floorMod(-7, 2);         // Floor modulo                           → 1
int  addEx   = Math.addExact(1, 2);          // Add, throws ArithmeticException on overflow → 3
int  subEx   = Math.subtractExact(5, 3);     // Subtract, throws on overflow           → 2
int  mulEx   = Math.multiplyExact(3, 4);     // Multiply, throws on overflow           → 12

double pi    = Math.PI;                      // PI constant                            → 3.141592653589793
double e     = Math.E;                       // e constant                             → 2.718281828459045
```

---

## 3. String Functions

```java
// --- String Functions ---
String s = "Hello, World!";

int    len   = s.length();                   // Length of string                       → 13
char   ch    = s.charAt(1);                  // Char at index 1                        → 'e'
int    idx   = s.indexOf('l');               // First index of char                    → 2
int    idxs  = s.indexOf("World");           // First index of substring               → 7
int    lidx  = s.lastIndexOf('l');           // Last index of char                     → 10
int    lidxs = s.lastIndexOf("o");           // Last index of substring                → 8

String sub1  = s.substring(7);              // Substring from index 7                 → "World!"
String sub2  = s.substring(0, 5);           // Substring [0, 5)                       → "Hello"

boolean has  = s.contains("World");          // Contains substring                     → true
boolean sw   = s.startsWith("Hello");        // Starts with                            → true
boolean ew   = s.endsWith("!");              // Ends with                              → true

boolean eq   = "abc".equals("abc");          // Exact equality                         → true
boolean eqi  = "abc".equalsIgnoreCase("ABC");// Case-insensitive equal                 → true
int     cmp  = "abc".compareTo("abd");       // Lexicographic compare                  → -1
int     cmpi = "abc".compareToIgnoreCase("ABC"); // Case-insensitive compare           → 0

String lower = s.toLowerCase();              // To lowercase                           → "hello, world!"
String upper = s.toUpperCase();              // To uppercase                           → "HELLO, WORLD!"
String trim  = "  hi  ".trim();              // Remove leading/trailing spaces         → "hi"
String strip = "  hi  ".strip();             // Unicode-aware trim (Java 11+)          → "hi"
String sl    = "  hi".stripLeading();        // Remove leading spaces (Java 11+)       → "hi"
String st    = "hi  ".stripTrailing();       // Remove trailing spaces (Java 11+)      → "hi"

String rep1  = "hello".replace('l', 'r');    // Replace char                           → "herro"
String rep2  = "hello".replace("ll", "LL");  // Replace substring                      → "heLLo"
String repA  = "a1b2".replaceAll("[0-9]","#");    // Replace all using regex           → "a#b#"
String repF  = "a1b2".replaceFirst("[0-9]","#");  // Replace first regex match         → "a#b2"

String[] arr = "a,b,c".split(",");           // Split into array                       → ["a","b","c"]
String[] arr2= "a,b,c".split(",", 2);        // Split with limit                       → ["a","b,c"]

char[]  ca   = "abc".toCharArray();          // String to char[]                       → ['a','b','c']
boolean emp  = "".isEmpty();                 // Check empty                            → true
boolean blank= "  ".isBlank();               // Check blank (Java 11+)                 → true
boolean mat  = "abc123".matches("[a-z]+[0-9]+"); // Full regex match                   → true

String cat   = "hello".concat(" world");     // Concatenate                            → "hello world"
String rep3  = "ab".repeat(3);               // Repeat n times (Java 11+)              → "ababab"
String fmt1  = "Hi %s".formatted("Java");    // Format string (Java 15+)              → "Hi Java"
String fmt2  = String.format("%d+%d=%d",1,2,3); // Static formatted string            → "1+2=3"
String joined= String.join("-","a","b","c"); // Join with delimiter                    → "a-b-c"
String sv    = String.valueOf(123);          // Convert number to String               → "123"
String cv    = String.copyValueOf(new char[]{'a','b'}); // char[] to String           → "ab"
String intern= "hello".intern();             // Return canonical interned form

// IntStream of char codes
"abc".chars().forEach(c2 -> System.out.print((char)c2 + " ")); // Output: a b c

int cp = "A".codePointAt(0);                // Unicode code point of 'A'              → 65
int hc = "hello".hashCode();                // Hash code of string
```

---

## 4. Character Functions

```java
// --- Character Functions ---

boolean isD  = Character.isDigit('5');           // Is digit?                          → true
boolean isL  = Character.isLetter('a');           // Is letter?                        → true
boolean isLD = Character.isLetterOrDigit('3');    // Is letter or digit?               → true
boolean isU  = Character.isUpperCase('A');        // Is uppercase?                     → true
boolean isLo = Character.isLowerCase('a');        // Is lowercase?                     → true
boolean isWS = Character.isWhitespace(' ');       // Is whitespace?                    → true
boolean isAl = Character.isAlphabetic('a');       // Is alphabetic?                    → true

char toU  = Character.toUpperCase('a');           // To uppercase                      → 'A'
char toLo = Character.toLowerCase('A');           // To lowercase                      → 'a'

int  numV = Character.getNumericValue('9');       // Numeric value                     → 9
int  type = Character.getType('A');               // Unicode category type             → 1 (UPPERCASE_LETTER)
boolean ctrl = Character.isISOControl('\n');      // Is control char?                  → true

int  dig  = Character.digit('f', 16);             // Char to digit in given radix      → 15
char fdig = Character.forDigit(15, 16);           // Digit to char in given radix      → 'f'
int  cmp  = Character.compare('a', 'b');          // Compare two chars                 → -1

char cmax = Character.MAX_VALUE;                  // Max char (\uFFFF)                 → 65535
char cmin = Character.MIN_VALUE;                  // Min char (\u0000)                 → 0
```

---

## 5. StringBuffer Functions

```java
// Thread-safe mutable string — use when multiple threads modify a string.

StringBuffer sb = new StringBuffer("Hello");

sb.append(" World");            // Append any type           → "Hello World"
sb.insert(5, "!");              // Insert at index 5         → "Hello! World"
sb.delete(5, 6);                // Delete range [5,6)        → "Hello World"
sb.deleteCharAt(0);             // Delete char at index 0    → "ello World"
sb.replace(0, 4, "Hi");         // Replace [0,4)             → "Hi World"
sb.reverse();                   // Reverse string            → "dlroW iH"

int    fi  = sb.indexOf("W");   // First index of "W"
int    li  = sb.lastIndexOf("o"); // Last index of "o"
char   c   = sb.charAt(1);      // Char at index             → 'l'
sb.setCharAt(0, 'h');           // Set char at index 0

String s1  = sb.substring(3);   // Substring from index 3
String s2  = sb.substring(0, 2); // Substring [0, 2)

int    len = sb.length();       // Current length
int    cap = sb.capacity();     // Current capacity (default 16 + initial length)
sb.ensureCapacity(50);          // Ensure minimum capacity >= 50
sb.trimToSize();                // Trim internal capacity to actual size
sb.setLength(5);                // Truncate or pad to length 5

int    cp  = sb.codePointAt(0); // Unicode code point at index 0
String str = sb.toString();     // Convert StringBuffer to String
```

---

## 6. StringBuilder Functions

```java
// NOT thread-safe, but faster than StringBuffer. Preferred for single-threaded use.

StringBuilder sb = new StringBuilder("Hello");

sb.append(" World");            // Append                    → "Hello World"
sb.insert(5, "!");              // Insert at index 5         → "Hello! World"
sb.delete(5, 6);                // Delete range [5,6)        → "Hello World"
sb.deleteCharAt(0);             // Delete char at index 0    → "ello World"
sb.replace(0, 4, "Hi");         // Replace range             → "Hi World"
sb.reverse();                   // Reverse                   → "dlroW iH"

int    fi  = sb.indexOf("W");   // First index of "W"
int    li  = sb.lastIndexOf("o"); // Last index of "o"
char   c   = sb.charAt(0);      // Get char at index
sb.setCharAt(0, 'h');           // Set char at index

String s1  = sb.substring(3);   // Substring from index
String s2  = sb.substring(0, 2); // Substring range

int    len = sb.length();       // Length
int    cap = sb.capacity();     // Capacity
sb.setLength(5);                // Set/truncate length

String str = sb.toString();     // StringBuilder to String

// KEY DIFFERENCE:
// StringBuffer  → synchronized (thread-safe), slower
// StringBuilder → not synchronized (not thread-safe), faster
```

---

## 7. Arrays Functions

```java
import java.util.Arrays;

int[] arr = {5, 3, 1, 4, 2};

Arrays.sort(arr);                             // Sort ascending (in-place)             → [1,2,3,4,5]
Arrays.sort(arr, 1, 4);                       // Sort only subarray [1,4)

String[] strArr = {"banana","apple","cherry"};
Arrays.sort(strArr, Comparator.reverseOrder()); // Sort with comparator (descending)   → [cherry,banana,apple]

int idx  = Arrays.binarySearch(arr, 3);       // Binary search (array must be sorted)  → index of 3
int idx2 = Arrays.binarySearch(arr, 0, 3, 2); // Binary search in range [0,3)

Arrays.fill(arr, 0);                          // Fill entire array with 0              → [0,0,0,0,0]
Arrays.fill(arr, 1, 4, -1);                   // Fill range [1,4) with -1

int[] copy1 = Arrays.copyOf(arr, 3);          // Copy first 3 elements                 → [0,0,0]
int[] copy2 = Arrays.copyOfRange(arr, 1, 4);  // Copy range [1,4)

boolean eq   = Arrays.equals(arr, copy1);     // Array equality check
boolean deq  = Arrays.deepEquals(            // Multi-dimensional array equality
                 new int[][]{{1,2},{3,4}},
                 new int[][]{{1,2},{3,4}});    // Output: true

String ts  = Arrays.toString(arr);            // Readable 1D string                   → "[0, 0, 0, 0, 0]"
String dts = Arrays.deepToString(            // Readable multi-dim string
               new int[][]{{1,2},{3,4}});      // Output: "[[1, 2], [3, 4]]"

java.util.List<String> list = Arrays.asList("a","b","c"); // Array to fixed-size List

int sum = Arrays.stream(arr).sum();           // Array to IntStream, then sum
int[] partial = Arrays.stream(arr,0,3).toArray(); // Range to IntStream to array

Arrays.parallelSort(arr);                     // Parallel sort (faster for large arrays)
Arrays.parallelSetAll(arr, i -> i * 2);       // Set each element via index function   → [0,2,4,6,8]

int mis = Arrays.mismatch(arr, copy1);        // First mismatch index (Java 9+)        → -1 if equal
int cmp = Arrays.compare(arr, copy1);         // Lexicographic comparison (Java 9+)
```

---

## 8. ArrayList Functions

```java
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;

ArrayList<Integer> list = new ArrayList<>();

list.add(10);                                 // Append element                        → [10]
list.add(0, 5);                               // Insert at index 0                     → [5, 10]
int val = list.get(0);                        // Get element at index                  → 5
list.set(0, 99);                              // Replace element at index 0            → [99, 10]
list.remove(0);                               // Remove by index 0                     → [10]
list.remove(Integer.valueOf(10));             // Remove first occurrence of value 10   → []

list.add(1); list.add(2); list.add(3);
int  sz   = list.size();                      // Size                                  → 3
boolean emp = list.isEmpty();                 // Check empty                           → false
boolean has = list.contains(2);               // Contains element?                     → true
int  fi   = list.indexOf(2);                  // First index of 2                      → 1
int  li   = list.lastIndexOf(2);              // Last index of 2                       → 1

list.clear();                                 // Remove all elements                   → []
list.add(1); list.add(2); list.add(3);

ArrayList<Integer> other = new ArrayList<>(Arrays.asList(4, 5));
list.addAll(other);                           // Add all from other collection          → [1,2,3,4,5]
list.addAll(0, other);                        // Insert collection at index 0          → [4,5,1,2,3,4,5]
list.removeAll(Arrays.asList(4, 5));          // Remove all matching elements
list.retainAll(Arrays.asList(1, 2));          // Keep only matching elements
boolean all = list.containsAll(Arrays.asList(1, 2)); // Contains all?                 → true

java.util.List<Integer> sub = list.subList(0, 2); // Sub-list view [0,2)

Object[]  oa = list.toArray();                // Convert to Object[]
Integer[] ia = list.toArray(new Integer[0]); // Convert to typed array

list.sort(Comparator.naturalOrder());         // Sort ascending
list.forEach(System.out::println);            // For-each with lambda
list.removeIf(x -> x > 5);                   // Remove elements matching predicate
list.replaceAll(x -> x * 2);                 // Transform every element

list.stream().filter(x -> x > 2).forEach(System.out::println); // Stream pipeline

list.trimToSize();                            // Trim internal capacity to actual size
list.ensureCapacity(100);                     // Ensure capacity >= 100

Collections.sort(list);                       // Sort ascending
Collections.reverse(list);                    // Reverse list
Collections.shuffle(list);                    // Shuffle randomly
int cmin = Collections.min(list);             // Minimum element
int cmax = Collections.max(list);             // Maximum element
int freq = Collections.frequency(list, 2);    // Count occurrences of 2
java.util.List<String> copies = Collections.nCopies(3,"x"); // ["x","x","x"]
```

---

## 9. LinkedList Functions

```java
import java.util.LinkedList;

// LinkedList implements both List and Deque
LinkedList<Integer> ll = new LinkedList<>();

ll.add(10); ll.add(20); ll.add(30);

ll.addFirst(0);                               // Add element at front                  → [0,10,20,30]
ll.addLast(40);                               // Add element at end                    → [0,10,20,30,40]

int first = ll.getFirst();                    // Get first element (throws if empty)   → 0
int last  = ll.getLast();                     // Get last element (throws if empty)    → 40

ll.removeFirst();                             // Remove first (throws if empty)        → [10,20,30,40]
ll.removeLast();                              // Remove last (throws if empty)         → [10,20,30]

int pk   = ll.peek();                         // Peek front without removing (null if empty) → 10
int pkF  = ll.peekFirst();                    // Peek front                            → 10
int pkL  = ll.peekLast();                     // Peek back                             → 30

int pl   = ll.poll();                         // Remove and return front (null if empty) → 10
int plF  = ll.pollFirst();                    // Remove and return front               → 20
int plL  = ll.pollLast();                     // Remove and return back                → 30

ll.add(1); ll.add(2); ll.add(3);
ll.offer(9);                                  // Add to tail (Queue style)
ll.offerFirst(0);                             // Add to head
ll.offerLast(99);                             // Add to tail

ll.push(5);                                   // Stack push (same as addFirst)
int top = ll.pop();                           // Stack pop (same as removeFirst)       → 5

java.util.Iterator<Integer> di = ll.descendingIterator(); // Reverse order iterator
while (di.hasNext()) System.out.print(di.next() + " ");   // Prints in reverse order
```

---

## 10. HashMap Functions

```java
import java.util.HashMap;

HashMap<String, Integer> map = new HashMap<>();

map.put("a", 1);                              // Insert / update key-value pair
map.put("b", 2);
map.put("c", 3);

int v1  = map.get("a");                       // Get value by key                      → 1
int v2  = map.getOrDefault("z", 0);           // Get or return default if absent       → 0
boolean ck = map.containsKey("a");            // Key exists?                           → true
boolean cv = map.containsValue(2);            // Value exists?                         → true

map.remove("a");                              // Remove by key
map.put("a", 1);
map.remove("a", 1);                           // Remove only if key maps to value 1

int sz   = map.size();                        // Number of entries                     → 2
boolean emp = map.isEmpty();                  // Check empty                           → false
map.clear();                                  // Remove all entries

map.put("a",1); map.put("b",2);
java.util.Set<String>             ks = map.keySet();    // Set of keys
java.util.Collection<Integer>     vs = map.values();    // Collection of values
java.util.Set<java.util.Map.Entry<String,Integer>> es = map.entrySet(); // Key-value pairs

map.putIfAbsent("c", 3);                      // Insert only if key is absent
map.putAll(new HashMap<>());                  // Copy all entries from another map

map.replace("a", 99);                         // Replace value for key "a"             → a=99
map.replace("a", 99, 1);                      // Replace only if current value matches → a=1

// merge: if key absent -> put val; else -> apply function(existing, val)
map.merge("a", 10, Integer::sum);             // a: 1 + 10 = 11

// compute: apply function(key, currentValue) -> store result
map.compute("a", (k, v) -> v == null ? 1 : v + 1); // a: 11 + 1 = 12

// computeIfAbsent: only compute and store if key is absent
map.computeIfAbsent("d", k -> k.length());    // d: length of "d" = 1

// computeIfPresent: only compute and store if key is present
map.computeIfPresent("a", (k, v) -> v * 2);  // a: 12 * 2 = 24

map.forEach((k, v) -> System.out.println(k + ":" + v)); // Iterate all entries
map.replaceAll((k, v) -> v + 100);            // Replace all values using function
```

---

## 11. TreeMap Functions

```java
import java.util.TreeMap;

// TreeMap: sorted by key (natural order or custom Comparator)
TreeMap<String, Integer> tm = new TreeMap<>();
tm.put("banana", 2); tm.put("apple", 1); tm.put("cherry", 3); tm.put("date", 4);

// All HashMap methods apply, PLUS navigation methods:

String fk  = tm.firstKey();                   // Smallest key                          → "apple"
String lk  = tm.lastKey();                    // Largest key                           → "date"
String flk = tm.floorKey("c");               // Greatest key <= "c"                   → "cherry"
String clk = tm.ceilingKey("c");             // Smallest key >= "c"                   → "cherry"
String lok = tm.lowerKey("c");               // Greatest key strictly < "c"           → "banana"
String hik = tm.higherKey("c");              // Smallest key strictly > "c"           → "cherry"

java.util.Map.Entry<String,Integer> fe  = tm.firstEntry();       // Smallest entry
java.util.Map.Entry<String,Integer> le  = tm.lastEntry();        // Largest entry
java.util.Map.Entry<String,Integer> fle = tm.floorEntry("c");    // Entry <= "c"
java.util.Map.Entry<String,Integer> cle = tm.ceilingEntry("c");  // Entry >= "c"

java.util.SortedMap<String,Integer> hm  = tm.headMap("c");       // Keys strictly < "c"
java.util.SortedMap<String,Integer> tlm = tm.tailMap("c");       // Keys >= "c"
java.util.SortedMap<String,Integer> sm  = tm.subMap("b","d");    // Keys in ["b","d")

java.util.Set<String>                dk  = tm.descendingKeySet();  // Keys in reverse order
java.util.NavigableMap<String,Integer> dm = tm.descendingMap();   // Map in reverse order

java.util.Map.Entry<String,Integer> pfe = tm.pollFirstEntry(); // Remove + return smallest
java.util.Map.Entry<String,Integer> ple = tm.pollLastEntry();  // Remove + return largest

java.util.NavigableSet<String> nks = tm.navigableKeySet();     // NavigableSet of keys
```

---

## 12. LinkedHashMap Functions

```java
import java.util.LinkedHashMap;

// Maintains INSERTION ORDER. All HashMap methods apply.
LinkedHashMap<String, Integer> lhm = new LinkedHashMap<>();
lhm.put("first", 1);
lhm.put("second", 2);
lhm.put("third", 3);
lhm.forEach((k, v) -> System.out.println(k + "=" + v)); // Prints in insertion order

// ACCESS-ORDER mode (LRU cache style): recently accessed entries move to end
LinkedHashMap<String, Integer> lru = new LinkedHashMap<>(16, 0.75f, true);
lru.put("a", 1); lru.put("b", 2); lru.put("c", 3);
lru.get("a");   // "a" moves to end (most recently accessed)
lru.forEach((k, v) -> System.out.print(k + " ")); // Output: b c a

// Override removeEldestEntry to create a fixed-size LRU cache:
LinkedHashMap<String, Integer> cache = new LinkedHashMap<>(16, 0.75f, true) {
    protected boolean removeEldestEntry(java.util.Map.Entry<String,Integer> eldest) {
        return size() > 3; // Keep at most 3 entries
    }
};
```

---

## 13. HashSet Functions

```java
import java.util.HashSet;
import java.util.Arrays;

HashSet<Integer> set = new HashSet<>();

boolean added = set.add(10);                  // Add element; returns false if already present → true
set.add(20); set.add(30);
set.remove(10);                               // Remove element
set.add(10);

boolean has  = set.contains(10);              // Check presence?                       → true
int     sz   = set.size();                    // Number of elements                    → 3
boolean emp  = set.isEmpty();                 // Check empty?                          → false
set.clear();                                  // Remove all elements

set.add(1); set.add(2); set.add(3);
HashSet<Integer> other = new HashSet<>(Arrays.asList(3, 4, 5));

set.addAll(other);                            // UNION: set now has {1,2,3,4,5}
set.retainAll(other);                         // INTERSECTION: keep only common {3,4,5}
set.removeAll(other);                         // DIFFERENCE: remove other's elements

set.add(1); set.add(2); set.add(3);
boolean sub = set.containsAll(Arrays.asList(1, 2)); // Is {1,2} a subset?             → true

Object[]  arr = set.toArray();                // Set to Object array
java.util.Iterator<Integer> it = set.iterator(); // Get iterator

set.forEach(x -> System.out.print(x + " ")); // For-each with lambda
set.stream().filter(x -> x > 1).forEach(System.out::println); // Stream pipeline
```

---

## 14. TreeSet Functions

```java
import java.util.TreeSet;

// SORTED, no duplicates. Has all HashSet methods PLUS navigation:
TreeSet<Integer> ts = new TreeSet<>();
ts.add(5); ts.add(1); ts.add(8); ts.add(3); ts.add(10);
// Internally stored as: [1, 3, 5, 8, 10]

int first = ts.first();                       // Smallest element                      → 1
int last  = ts.last();                        // Largest element                       → 10

Integer fl = ts.floor(5);                     // Greatest element <= 5                 → 5
Integer cl = ts.ceiling(5);                   // Smallest element >= 5                 → 5
Integer lo = ts.lower(5);                     // Greatest element strictly < 5         → 3
Integer hi = ts.higher(5);                    // Smallest element strictly > 5         → 8

java.util.SortedSet<Integer> hs  = ts.headSet(5);    // Elements strictly < 5         → [1,3]
java.util.SortedSet<Integer> tls = ts.tailSet(5);    // Elements >= 5                  → [5,8,10]
java.util.SortedSet<Integer> ss  = ts.subSet(3, 9);  // Elements in [3,9)             → [3,5,8]

java.util.NavigableSet<Integer> ds = ts.descendingSet(); // Reverse order set          → [10,8,5,3,1]

int pf = ts.pollFirst();                      // Remove + return smallest element      → 1
int pl = ts.pollLast();                       // Remove + return largest element       → 10

java.util.Iterator<Integer> di = ts.descendingIterator(); // Iterator in reverse order
while (di.hasNext()) System.out.print(di.next() + " ");   // Output: 8 5 3
```

---

## 15. LinkedHashSet Functions

```java
import java.util.LinkedHashSet;

// Maintains INSERTION ORDER + no duplicates. All HashSet methods apply.
LinkedHashSet<Integer> lhs = new LinkedHashSet<>();
lhs.add(30);
lhs.add(10);
lhs.add(20);
// Iteration order matches insertion: 30, 10, 20 (NOT sorted)
lhs.forEach(x -> System.out.print(x + " ")); // Output: 30 10 20

lhs.remove(10);         // Remove element
lhs.contains(20);       // Check presence    → true
lhs.size();             // Size              → 2
lhs.isEmpty();          // Empty?            → false
lhs.toArray();          // To array
lhs.clear();            // Remove all
```

---

## 16. Stack Functions

```java
import java.util.Stack;

Stack<Integer> stack = new Stack<>();

stack.push(10);                               // Push onto stack (add to top)          → [10]
stack.push(20);                               // Push                                  → [10, 20]
stack.push(30);                               // Push                                  → [10, 20, 30]

int top  = stack.peek();                      // View top without removing             → 30
int pop  = stack.pop();                       // Remove and return top                 → 30

boolean emp = stack.isEmpty();                // Check if stack is empty               → false
int     sz  = stack.size();                   // Size                                  → 2

int pos  = stack.search(10);                  // 1-based position from top             → 2
boolean has = stack.contains(20);             // Contains element?                     → true
stack.clear();                                // Remove all elements

// MODERN ALTERNATIVE: ArrayDeque is faster and preferred
java.util.ArrayDeque<Integer> dstack = new java.util.ArrayDeque<>();
dstack.push(1); dstack.push(2); dstack.push(3);
int dtop = dstack.peek();                     // Output: 3
int dpop = dstack.pop();                      // Output: 3
```

---

## 17. Queue & Deque Functions

```java
import java.util.Queue;
import java.util.LinkedList;
import java.util.ArrayDeque;

// ==========================
//  QUEUE (FIFO: First In First Out)
// ==========================
Queue<Integer> q = new LinkedList<>();

q.offer(10);                                  // Enqueue; returns false if capacity exceeded
q.offer(20); q.offer(30);
q.add(40);                                    // Enqueue; throws exception if capacity exceeded

int front1 = q.peek();                        // View front element (null if empty)    → 10
int front2 = q.element();                     // View front element (throws if empty)  → 10

int out1 = q.poll();                          // Dequeue: remove and return front (null if empty) → 10
int out2 = q.remove();                        // Dequeue: remove and return front (throws if empty) → 20

boolean emp = q.isEmpty();                    // Check empty                           → false
int     sz  = q.size();                       // Size                                  → 2

// ==========================
//  DEQUE (Double-Ended Queue) — acts as both Stack and Queue
// ==========================
ArrayDeque<Integer> deque = new ArrayDeque<>();

deque.addFirst(1);                            // Add at front                          → [1]
deque.addLast(9);                             // Add at back                           → [1, 9]
deque.offerFirst(0);                          // Add at front (safe, no exception)     → [0, 1, 9]
deque.offerLast(10);                          // Add at back (safe)                    → [0, 1, 9, 10]

deque.removeFirst();                          // Remove front (throws if empty)        → [1, 9, 10]
deque.removeLast();                           // Remove back (throws if empty)         → [1, 9]
int pf = deque.pollFirst();                   // Remove front (null if empty)          → 1
int pl = deque.pollLast();                    // Remove back (null if empty)           → 9

deque.addFirst(5); deque.addLast(15);
int pkF = deque.peekFirst();                  // View front (null if empty)            → 5
int pkL = deque.peekLast();                   // View back (null if empty)             → 15

deque.push(99);                               // Stack-style push (addFirst)           → [99, 5, 15]
int pk = deque.peek();                        // Stack-style peek (peekFirst)          → 99
int po = deque.pop();                         // Stack-style pop (removeFirst)         → 99

boolean has = deque.contains(5);              // Contains?                             → true
int     dsz = deque.size();                   // Size
boolean dem = deque.isEmpty();                // Empty?
deque.clear();                                // Clear all

Object[] da = deque.toArray();                // To array
java.util.Iterator<Integer> dit  = deque.iterator();           // Forward iterator
java.util.Iterator<Integer> ddit = deque.descendingIterator(); // Reverse iterator
```

---

## 18. PriorityQueue Functions

```java
import java.util.PriorityQueue;
import java.util.Collections;

// MIN-HEAP by default (smallest element at head)
PriorityQueue<Integer> pq = new PriorityQueue<>();

pq.offer(5); pq.offer(1); pq.offer(3);       // Insert elements
pq.add(2);                                    // Insert (throws if size restricted)

int head1 = pq.peek();                        // View minimum (null if empty)          → 1
int head2 = pq.element();                     // View minimum (throws if empty)        → 1

int out1 = pq.poll();                         // Remove + return minimum (null if empty) → 1
int out2 = pq.remove();                       // Remove minimum (throws if empty)      → 2

pq.remove(Integer.valueOf(3));                // Remove specific element
boolean has = pq.contains(5);                 // Contains?                             → true
int     sz  = pq.size();                      // Size
boolean emp = pq.isEmpty();                   // Empty?
pq.clear();                                   // Clear all

Object[] arr = pq.toArray();                  // To array (NOT in sorted order!)
pq.addAll(java.util.List.of(7, 8, 9));        // Add all from collection

// MAX-HEAP: use Collections.reverseOrder()
PriorityQueue<Integer> maxPq = new PriorityQueue<>(Collections.reverseOrder());
maxPq.offer(5); maxPq.offer(1); maxPq.offer(3);
int maxHead = maxPq.peek();                   // Largest element at head               → 5
int maxOut  = maxPq.poll();                   // Remove + return largest               → 5

// Custom Comparator example (shortest string first)
PriorityQueue<String> strPq = new PriorityQueue<>(Comparator.comparingInt(String::length));
strPq.offer("banana"); strPq.offer("fig"); strPq.offer("apple");
System.out.println(strPq.poll());             // Shortest string first                 → "fig"
```

---

## 19. Collections Utility Functions

```java
import java.util.Collections;
import java.util.ArrayList;
import java.util.Arrays;

ArrayList<Integer> list = new ArrayList<>(Arrays.asList(3,1,4,1,5,9,2,6));

Collections.sort(list);                       // Sort ascending                        → [1,1,2,3,4,5,6,9]
Collections.sort(list, Comparator.reverseOrder()); // Sort descending                  → [9,6,5,4,3,2,1,1]
Collections.reverse(list);                    // Reverse order of list
Collections.shuffle(list);                    // Shuffle randomly

int mn = Collections.min(list);               // Minimum element
int mx = Collections.max(list);               // Maximum element
int mn2 = Collections.min(list, Comparator.naturalOrder()); // Min with comparator
int mx2 = Collections.max(list, Comparator.naturalOrder()); // Max with comparator

int freq = Collections.frequency(list, 1);    // Count occurrences of 1               → 2
Collections.swap(list, 0, 1);                 // Swap elements at index 0 and 1
Collections.fill(list, 0);                    // Fill all elements with 0

ArrayList<Integer> dest = new ArrayList<>(Arrays.asList(0,0,0,0,0,0,0,0));
Collections.copy(dest, list);                 // Copy src into dest (dest.size >= src.size)

java.util.List<String> copies = Collections.nCopies(3, "x"); // Immutable ["x","x","x"]

Collections.sort(list);
int bidx = Collections.binarySearch(list, 0); // Binary search (list must be sorted)

boolean dis = Collections.disjoint(list, Arrays.asList(100,200)); // No common elements? → true
Collections.addAll(list, 10, 20, 30);         // Add multiple elements at once

// Immutable (read-only) wrappers
java.util.List<Integer>          ulist = Collections.unmodifiableList(list);
java.util.Map<String,Integer>    umap  = Collections.unmodifiableMap(new java.util.HashMap<>());
java.util.Set<Integer>           uset  = Collections.unmodifiableSet(new java.util.HashSet<>());

// Thread-safe wrappers
java.util.List<Integer>          slist = Collections.synchronizedList(list);
java.util.Map<String,Integer>    smap  = Collections.synchronizedMap(new java.util.HashMap<>());

// Single-element immutable collections
java.util.List<Integer>           one  = Collections.singletonList(5);         // [5]
java.util.Set<Integer>            ones = Collections.singleton(5);             // {5}
java.util.Map<String,Integer>     onem = Collections.singletonMap("k", 1);    // {k=1}

// Empty immutable collections
java.util.List<Integer>        el = Collections.emptyList();                   // []
java.util.Map<String,Integer>  em = Collections.emptyMap();                    // {}
java.util.Set<Integer>         es = Collections.emptySet();                    // {}

Comparator<Integer> rev = Collections.reverseOrder();   // Reverse comparator

java.util.List<Integer>  cl = Collections.checkedList(list, Integer.class);   // Type-safe wrapper
Collections.replaceAll(list, 0, -1);          // Replace all occurrences of 0 with -1

java.util.List<Integer>  sub = Arrays.asList(1, 2);
int isl  = Collections.indexOfSubList(list, sub);     // First index of sublist
int lisl = Collections.lastIndexOfSubList(list, sub); // Last index of sublist

Collections.rotate(list, 2);                  // Rotate list right by 2 positions
```

---

## 20. List.of / Map.of / Set.of (Java 9+ Immutable Factories)

```java
// IMMUTABLE collections — add/remove/set throws UnsupportedOperationException

java.util.List<String>    imList = java.util.List.of("a", "b", "c");        // ["a","b","c"]
java.util.Set<Integer>    imSet  = java.util.Set.of(1, 2, 3);               // {1,2,3}
java.util.Map<String,Integer> imMap = java.util.Map.of("a",1, "b",2);       // {a=1, b=2}

// Map.ofEntries for more than 10 entries:
java.util.Map<String,Integer> bigMap = java.util.Map.ofEntries(
    java.util.Map.entry("a", 1),
    java.util.Map.entry("b", 2),
    java.util.Map.entry("c", 3)
);

// Copy factories (also immutable):
java.util.List<String>        copyList = java.util.List.copyOf(imList);     // Copy of list
java.util.Set<Integer>        copySet  = java.util.Set.copyOf(imSet);       // Copy of set
java.util.Map<String,Integer> copyMap  = java.util.Map.copyOf(imMap);       // Copy of map

// imList.add("d");    // throws UnsupportedOperationException
// imSet.remove(1);    // throws UnsupportedOperationException
// imMap.put("x", 9);  // throws UnsupportedOperationException
```

---

## 21. Iterator & ListIterator

```java
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.ListIterator;

ArrayList<Integer> list = new ArrayList<>(Arrays.asList(1, 2, 3, 4, 5));

// --- Iterator (forward only, supports remove) ---
Iterator<Integer> it = list.iterator();
while (it.hasNext()) {             // Has more elements?
    int val = it.next();           // Get next element
    if (val % 2 == 0)
        it.remove();               // Safe remove — removes last element returned by next()
}
// list is now [1, 3, 5]

// --- ListIterator (bidirectional, supports add/set too) ---
list = new ArrayList<>(Arrays.asList(1, 2, 3, 4, 5));
ListIterator<Integer> lit = list.listIterator();

while (lit.hasNext()) {            // Has more elements going forward?
    int v = lit.next();            // Get next element (moves cursor forward)
    lit.set(v * 10);               // Replace last returned element with v*10
}
// list is now [10, 20, 30, 40, 50]

while (lit.hasPrevious()) {        // Has elements going backward?
    int v = lit.previous();        // Get previous element (moves cursor backward)
    System.out.print(v + " ");     // Prints in reverse: 50 40 30 20 10
}

int ni = lit.nextIndex();          // Index of element that next() would return
int pi = lit.previousIndex();      // Index of element that previous() would return

lit.add(99);                       // Insert 99 at current cursor position
```

---

## 22. Comparator Functions

```java
import java.util.Comparator;
import java.util.Arrays;
import java.util.ArrayList;

ArrayList<String> words = new ArrayList<>(Arrays.asList("banana","fig","apple","cherry","kiwi"));
ArrayList<Integer> nums = new ArrayList<>(Arrays.asList(3, 1, 4, 1, 5, 9));

nums.sort(Comparator.naturalOrder());           // Sort ascending (natural order)      → [1,1,3,4,5,9]
nums.sort(Comparator.reverseOrder());           // Sort descending                     → [9,5,4,3,1,1]

words.sort(Comparator.comparing(String::length));            // Sort by string length  → [fig,kiwi,apple,banana,cherry]
words.sort(Comparator.comparingInt(String::length));         // Sort by int key (length)
words.sort(Comparator.comparingDouble(s -> (double)s.length())); // Sort by double key
words.sort(Comparator.comparingLong(s -> (long)s.length())); // Sort by long key

// Reverse a comparator
words.sort(Comparator.comparing(String::length).reversed()); // Longest first         → [banana,cherry,apple,kiwi,fig]

// Chain comparators: sort by length, then alphabetically as tiebreaker
words.sort(Comparator.comparingInt(String::length)
           .thenComparing(Comparator.naturalOrder()));        // length asc, then alpha

words.sort(Comparator.comparingInt(String::length)
           .thenComparingInt(String::hashCode));             // Secondary int comparison

// Handle null values
ArrayList<String> withNulls = new ArrayList<>(Arrays.asList("b", null, "a", null, "c"));
withNulls.sort(Comparator.nullsFirst(Comparator.naturalOrder()));  // nulls at start  → [null,null,a,b,c]
withNulls.sort(Comparator.nullsLast(Comparator.naturalOrder()));   // nulls at end    → [a,b,c,null,null]
```

---

## 23. Stream API

```java
import java.util.*;
import java.util.stream.*;

List<Integer> nums = List.of(1, 2, 3, 4, 5, 6);

// --- Intermediate operations (lazy — no work until a terminal is called) ---
nums.stream().filter(x -> x % 2 == 0);         // Keep even numbers                  → [2,4,6]
nums.stream().map(x -> x * 2);                  // Transform each element             → [2,4,6,8,10,12]
nums.stream().mapToInt(Integer::intValue);       // Map to primitive IntStream
nums.stream().flatMap(x -> Stream.of(x, x*10)); // Each element becomes a stream      → [1,10,2,20,3,30...]
nums.stream().sorted();                          // Sort natural order
nums.stream().sorted(Comparator.reverseOrder()); // Sort custom order
nums.stream().distinct();                        // Remove duplicates
nums.stream().limit(3);                          // Take first 3 elements              → [1,2,3]
nums.stream().skip(2);                           // Skip first 2 elements              → [3,4,5,6]
nums.stream().peek(x -> System.out.print(x+" ")); // Inspect without changing (debug)

// --- Collectors ---
List<Integer>         list  = nums.stream().collect(Collectors.toList());             // to List
Set<Integer>          set   = nums.stream().collect(Collectors.toSet());              // to Set
Map<Integer,Integer>  map   = nums.stream().collect(Collectors.toMap(x->x, x->x*x)); // num -> num^2

List<String> words = List.of("hello","world","java");
String joined  = words.stream().collect(Collectors.joining(", "));          // "hello, world, java"
String joined2 = words.stream().collect(Collectors.joining(", ","[","]")); // "[hello, world, java]"

// Group by even (0) or odd (1)
Map<Integer,List<Integer>> grouped = nums.stream()
    .collect(Collectors.groupingBy(x -> x % 2)); // {0=[2,4,6], 1=[1,3,5]}

long cnt2 = nums.stream().collect(Collectors.counting());                   // 6

List<Integer> imList = nums.stream().toList();   // Unmodifiable List (Java 16+)

// --- Terminal operations ---
nums.stream().forEach(System.out::println);      // Print each (returns void)
int  total = nums.stream().reduce(0, Integer::sum);  // Reduce to sum                 → 21
long cnt   = nums.stream().count();              // Count elements                     → 6

int    sum  = nums.stream().mapToInt(i->i).sum();           // Sum (IntStream)        → 21
double avg  = nums.stream().mapToInt(i->i).average().getAsDouble(); // Average        → 3.5
Optional<Integer> mn = nums.stream().min(Comparator.naturalOrder()); // Min           → Optional[1]
Optional<Integer> mx = nums.stream().max(Comparator.naturalOrder()); // Max           → Optional[6]

Optional<Integer> first = nums.stream().findFirst(); // First element                 → Optional[1]
Optional<Integer> any   = nums.stream().findAny();   // Any element (useful in parallel streams)

boolean any2  = nums.stream().anyMatch(x -> x > 5);  // Any element > 5?             → true
boolean all2  = nums.stream().allMatch(x -> x > 0);  // All elements > 0?            → true
boolean none2 = nums.stream().noneMatch(x -> x < 0); // No element < 0?              → true

Object[] arr  = nums.stream().toArray();             // Stream to array

// --- Stream creation ---
Stream<Integer>  s1  = Stream.of(1, 2, 3);           // From values
Stream<Object>   s2  = Stream.empty();                // Empty stream
IntStream rng        = IntStream.range(0, 5);         // [0,1,2,3,4]
IntStream rngC       = IntStream.rangeClosed(1, 5);   // [1,2,3,4,5]
Stream<String>   gen = Stream.generate(() -> "x").limit(3);           // ["x","x","x"]
Stream<Integer>  itr = Stream.iterate(1, x -> x * 2).limit(5);       // [1,2,4,8,16]
```

---

## 24. Optional Functions

```java
import java.util.Optional;

// --- Creating Optionals ---
Optional<String> opt   = Optional.of("hello");        // Wrap non-null (NPE if null passed)
Optional<String> maybe = Optional.ofNullable(null);   // Wrap any value (null becomes empty)
Optional<String> empty = Optional.empty();             // Explicitly empty optional

// --- Checking presence ---
boolean present = opt.isPresent();                     // Value exists?                → true
boolean absent  = opt.isEmpty();                       // No value? (Java 11+)         → false

// --- Getting values ---
String val   = opt.get();                              // Get value (throws NoSuchElementException if empty) → "hello"
String deflt = empty.orElse("default");                // Get or return default         → "default"
String cmptd = empty.orElseGet(() -> "computed");      // Get or compute lazily         → "computed"
String safe1 = opt.orElseThrow();                      // Get or throw (Java 10+)       → "hello"
// empty.orElseThrow(() -> new RuntimeException("No value")); // Get or custom exception

// --- Transforming ---
Optional<String> upper = opt.map(String::toUpperCase); // Transform if present          → Optional["HELLO"]
Optional<String> flat  = opt.flatMap(s -> Optional.of(s + s)); // FlatMap if present   → Optional["hellohello"]
Optional<String> filt  = opt.filter(s -> s.length() > 3);      // Keep if predicate    → Optional["hello"]

// --- Actions ---
opt.ifPresent(System.out::println);                    // Run action if value present   → prints "hello"
empty.ifPresent(System.out::println);                  // Does nothing

// Java 9+: run one of two actions
opt.ifPresentOrElse(
    System.out::println,
    () -> System.out.println("No value present")
);                                                     // Output: "hello"

// Java 9+: chaining fallback Optionals
Optional<String> res = empty.or(() -> Optional.of("fallback")); // → Optional["fallback"]
```

---

## 25. Miscellaneous Useful Functions

### Objects Class

```java
import java.util.Objects;

String a = "hello";
String b = null;

boolean eq   = Objects.equals(a, b);          // Null-safe equality check             → false
boolean eq2  = Objects.equals(null, null);     // Both null                            → true
int     hc   = Objects.hash(a, 42, true);      // Combined hash for multiple fields
String  str  = Objects.toString(b, "default"); // Null-safe toString                  → "default"
String  nn   = Objects.requireNonNull(a);      // Assert non-null (NPE if null)        → "hello"
// Objects.requireNonNull(b, "b must not be null"); // With custom message

boolean isnl = Objects.isNull(b);              // Is null?                             → true
boolean notnl= Objects.nonNull(a);             // Is non-null?                         → true
String  rtn  = Objects.requireNonNullElse(b,"fallback"); // Non-null or else (Java 9+)  → "fallback"
String  rtn2 = Objects.requireNonNullElseGet(b, () -> "lazy"); // Non-null or compute  → "lazy"
```

### System Class

```java
long   timeMs = System.currentTimeMillis();    // Current time in milliseconds since epoch
long   timeNs = System.nanoTime();             // High-resolution time (use for measuring intervals)

// Fast native array copy: src[0..4] copied into dst starting at dst[2]
int[] src = {1, 2, 3, 4, 5};
int[] dst = new int[8];
System.arraycopy(src, 0, dst, 2, 5);          // dst = [0, 0, 1, 2, 3, 4, 5, 0]

System.exit(0);                               // Exit JVM with status code 0 (normal exit)
System.gc();                                  // Suggest garbage collection (not guaranteed)

System.out.println("Hello");                  // Print with newline
System.out.print("Hello");                    // Print without newline
System.out.printf("Pi = %.2f%n", Math.PI);    // Formatted print                      → Pi = 3.14
System.err.println("Error!");                 // Print to stderr

String path    = System.getenv("PATH");        // Get OS environment variable
String javaVer = System.getProperty("java.version");  // JVM system property          → e.g. "17.0.2"
String os      = System.getProperty("os.name");        // OS name                     → "Windows 11"
System.setProperty("my.key", "my.value");     // Set a custom system property
```

---

## 26. Quick Collections Cheat Sheet

```
┌──────────────────────────────────────────┬──────────────────────────────────────┐
│  NEED                                    │  USE                                 │
├──────────────────────────────────────────┼──────────────────────────────────────┤
│  Fast random access (get by index)       │  ArrayList                           │
│  Fast insert/delete at ends              │  LinkedList / ArrayDeque             │
│  Unique elements, O(1) ops               │  HashSet                             │
│  Unique + sorted order                   │  TreeSet                             │
│  Unique + insertion order                │  LinkedHashSet                       │
│  Key-value, O(1) ops                     │  HashMap                             │
│  Key-value + sorted by key               │  TreeMap                             │
│  Key-value + insertion order             │  LinkedHashMap                       │
│  LIFO (stack)                            │  ArrayDeque  (or Stack)              │
│  FIFO (queue)                            │  ArrayDeque / LinkedList             │
│  Priority / min-max heap                 │  PriorityQueue                       │
│  Thread-safe list                        │  CopyOnWriteArrayList                │
│  Thread-safe map                         │  ConcurrentHashMap                   │
│  Immutable list/set/map                  │  List.of / Set.of / Map.of           │
└──────────────────────────────────────────┴──────────────────────────────────────┘

TIME COMPLEXITY SUMMARY
┌──────────────────┬──────────┬──────────┬──────────┬──────────┐
│  Collection      │  get     │  add     │  remove  │  search  │
├──────────────────┼──────────┼──────────┼──────────┼──────────┤
│  ArrayList       │  O(1)    │  O(1)*   │  O(n)    │  O(n)    │
│  LinkedList      │  O(n)    │  O(1)    │  O(1)    │  O(n)    │
│  HashMap         │  O(1)    │  O(1)    │  O(1)    │  O(1)    │
│  TreeMap         │  O(logn) │  O(logn) │  O(logn) │  O(logn) │
│  HashSet         │  -       │  O(1)    │  O(1)    │  O(1)    │
│  TreeSet         │  -       │  O(logn) │  O(logn) │  O(logn) │
│  ArrayDeque      │  O(1)    │  O(1)    │  O(1)    │  O(n)    │
│  PriorityQueue   │  O(logn) │  O(logn) │  O(logn) │  O(n)    │
└──────────────────┴──────────┴──────────┴──────────┴──────────┘
  * O(1) amortized for ArrayList.add()
```
