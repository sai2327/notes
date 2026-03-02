# 📘 Chapter 7: File System

> **"A file system organizes and manages how data is stored and retrieved on a storage device."**

---

## 📑 Table of Contents

| # | Topic |
|---|-------|
| 1 | [File Concepts](#1-file-concepts) |
| 2 | [File Access Methods](#2-file-access-methods) |
| 3 | [Directory Structure](#3-directory-structure) |
| 4 | [File Allocation Methods](#4-file-allocation-methods) |
| 5 | [Free Space Management](#5-free-space-management) |
| 6 | [File System Implementation](#6-file-system-implementation) |
| 7 | [Quick Summary](#7-quick-summary) |
| 8 | [Practice Questions](#-practice-questions) |

---

## 1. File Concepts

### 📖 What is a File?

A **file** is a named collection of related data recorded on secondary storage. It is the smallest unit of storage visible to the user.

```
    FILE ATTRIBUTES:
    ┌──────────────────────────────────────────────┐
    │  Name        → Human-readable identifier     │
    │  Identifier  → Unique tag (inode number)      │
    │  Type        → .txt, .exe, .c, .pdf, etc.    │
    │  Location    → Pointer to file on disk        │
    │  Size        → Current size in bytes          │
    │  Protection  → Read/Write/Execute permissions │
    │  Timestamps  → Created, Modified, Accessed    │
    │  Owner       → User who created the file      │
    └──────────────────────────────────────────────┘
    
    FILE OPERATIONS:
    ┌────────────────────────────────────────┐
    │  Create  → Allocate space, add entry   │
    │  Open    → Get file descriptor/handle  │
    │  Read    → Transfer data to memory     │
    │  Write   → Transfer data to disk       │
    │  Seek    → Move read/write pointer     │
    │  Delete  → Free space, remove entry    │
    │  Truncate → Erase contents, keep attrs │
    │  Close   → Release file descriptor     │
    └────────────────────────────────────────┘
```

### File Types

```
    ┌──────────────┬────────────┬───────────────────────────┐
    │  File Type   │ Extension  │ Description                │
    ├──────────────┼────────────┼───────────────────────────┤
    │ Executable   │ .exe, .out │ Ready-to-run program       │
    │ Object       │ .obj, .o   │ Compiled, not linked       │
    │ Source Code  │ .c, .cpp   │ Human-readable code        │
    │ Text         │ .txt       │ Plain text data            │
    │ Library      │ .lib, .so  │ Bundled object files       │
    │ Archive      │ .zip, .tar │ Compressed file groups     │
    │ Multimedia   │ .mp3, .mp4 │ Audio/Video files          │
    └──────────────┴────────────┴───────────────────────────┘
```

### 🏠 Real-World Analogy

| Concept | Analogy |
|---------|---------|
| File | A document/paper |
| Directory | A folder in a filing cabinet |
| File System | The entire filing cabinet and organization method |
| File Name | Label on the document |
| File Extension | Type of document (invoice, letter, report) |
| Permissions | Lock on the drawer (who can access) |

---

## 2. File Access Methods

```
    ┌──────────────────────────────────────────────────────────────┐
    │                    FILE ACCESS METHODS                        │
    ├────────────────────────┬─────────────────────────────────────┤
    │   SEQUENTIAL ACCESS    │   DIRECT (RANDOM) ACCESS           │
    │                        │                                     │
    │   Read/write in order  │   Access any record directly       │
    │   one record at a time │   using record number              │
    │                        │                                     │
    │   ┌───┬───┬───┬───┐   │   ┌───┬───┬───┬───┐               │
    │   │ 1 │ 2 │ 3 │ 4 │   │   │ 1 │ 2 │ 3 │ 4 │               │
    │   └─┬─┴───┴───┴───┘   │   └───┴─┬─┴───┴───┘               │
    │     │                  │         │                           │
    │     ▼                  │     Jump directly to record 2      │
    │   Read 1, then 2,     │                                     │
    │   then 3...            │   read(record_number)              │
    │                        │                                     │
    │   Like a cassette tape │   Like a vinyl record/CD           │
    │                        │                                     │
    │   ★ Simple             │   ★ Fast for lookups               │
    │   ★ Most common        │   ★ Used for databases             │
    │   ★ Tapes, log files   │   ★ Needs fixed-size records       │
    └────────────────────────┴─────────────────────────────────────┤
    │                                                              │
    │   INDEXED ACCESS                                             │
    │                                                              │
    │   Uses an index to find records                              │
    │                                                              │
    │   Index:                     File:                           │
    │   ┌──────┬─────┐            ┌──────────────┐                │
    │   │ Key  │ Ptr │──────────► │ Record data  │                │
    │   ├──────┼─────┤            ├──────────────┤                │
    │   │ Key  │ Ptr │──────────► │ Record data  │                │
    │   └──────┴─────┘            └──────────────┘                │
    │                                                              │
    │   Like a book's index → find page by topic                   │
    └──────────────────────────────────────────────────────────────┘
```

---

## 3. Directory Structure

### 📖 Directory

A **directory** is a special file that contains a list of file names and their associated metadata (like pointers to inodes).

### Single-Level Directory

```
    SINGLE-LEVEL DIRECTORY:
    All files in ONE directory (like a single folder)
    
    ┌──────────────────────────────────────┐
    │              DIRECTORY                │
    ├──────┬──────┬──────┬──────┬──────────┤
    │ cat  │ bo   │ test │ hex  │ records  │
    └──────┴──────┴──────┴──────┴──────────┘
    
    ★ Simple implementation
    ✗ Naming conflicts (can't have two files with same name)
    ✗ No grouping/organization
    ✗ Impractical for many files
```

### Two-Level Directory

```
    TWO-LEVEL DIRECTORY:
    Each user gets their own directory
    
    ┌───────────────────────────────────┐
    │         MASTER DIRECTORY          │
    ├───────────────┬───────────────────┤
    │    User 1     │     User 2        │
    ├───────────────┼───────────────────┤
    │ ┌────┬──────┐ │ ┌──────┬────────┐ │
    │ │cat │ test │ │ │ test │ records│ │
    │ └────┴──────┘ │ └──────┴────────┘ │
    └───────────────┴───────────────────┘
    
    ★ Different users can have same filenames
    ★ Efficient searching within one user directory
    ✗ No sub-grouping within a user
    ✗ No sharing between users
```

### Tree-Structured Directory

```
    TREE-STRUCTURED DIRECTORY (Hierarchical):
    
                        / (root)
                       / \
                      /   \
                   bin     home
                   /       / \
                  /       /   \
               ls      alice   bob
               cp      / \      \
                      /   \      \
                   docs  code   notes.txt
                   /      |
                  /       |
            report.txt  main.c
    
    PATH EXAMPLES:
    ─────────────
    /home/alice/docs/report.txt    (Absolute Path — from root)
    ./docs/report.txt              (Relative Path — from alice/)
    ../bob/notes.txt               (Relative — go up, then to bob/)
    
    ★ Logical grouping of files
    ★ Full path names prevent naming conflicts
    ★ Most widely used (Unix, Linux, Windows)
    ✗ Searching can be slow in deep trees
```

### Acyclic Graph Directory

```
    ACYCLIC GRAPH DIRECTORY:
    Allows SHARING of files/directories (but NO cycles)
    
                        / (root)
                       / \
                      /   \
                   alice   bob
                   / \      |
                  /   \     |
               docs  shared ◄──┘   (bob also points to shared)
               /      |
              /       |
         report.txt  data.csv
    
    Both /alice/shared/data.csv and /bob/shared/data.csv 
    refer to the SAME file!
    
    Implementation:
    • Hard Links: Multiple directory entries → same inode
    • Symbolic Links: Special file containing path to target
    
    ★ Efficient file sharing
    ★ Saves disk space (no duplicate copies)
    ✗ Deletion is complex (dangling pointers)
    ✗ Must prevent cycles (would cause infinite loops)
```

---

## 4. File Allocation Methods

How does the OS allocate disk blocks to files?

### 4.1 Contiguous Allocation

Each file occupies a **contiguous** (continuous) set of blocks on disk.

```
    CONTIGUOUS ALLOCATION:
    
    Directory Entry:
    ┌───────────┬───────┬────────┐
    │ File Name │ Start │ Length │
    ├───────────┼───────┼────────┤
    │ file_a    │   2   │   4   │ ← blocks 2,3,4,5
    │ file_b    │   9   │   3   │ ← blocks 9,10,11
    │ file_c    │  15   │   2   │ ← blocks 15,16
    └───────────┴───────┴────────┘
    
    DISK BLOCKS:
    ┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐
    │ 0 │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │ 8 │ 9 │10 │11 │12 │13 │14 │15 │16 │
    │   │   │ A │ A │ A │ A │   │   │   │ B │ B │ B │   │   │   │ C │ C │
    └───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┘
    
    To read block i of file_a: disk_block = start + i = 2 + i
    
    ✅ Simple to implement
    ✅ Excellent READ performance (sequential disk access)
    ✅ Supports both sequential and direct access
    ✗ External fragmentation (holes between files)
    ✗ File SIZE must be known at creation time
    ✗ Growing files is difficult/impossible
```

### 4.2 Linked Allocation

Each file is a **linked list** of disk blocks. Blocks can be scattered anywhere.

```
    LINKED ALLOCATION:
    
    Directory Entry:
    ┌───────────┬───────┬─────┐
    │ File Name │ Start │ End │
    ├───────────┼───────┼─────┤
    │ file_a    │   2   │  11 │
    └───────────┴───────┴─────┘
    
    Block 2          Block 6          Block 9          Block 11
    ┌──────┬────┐   ┌──────┬────┐   ┌──────┬────┐   ┌──────┬──────┐
    │ data │ →6 │──►│ data │ →9 │──►│ data │→11 │──►│ data │ NULL │
    └──────┴────┘   └──────┴────┘   └──────┴────┘   └──────┴──────┘
    
    Each block contains:
    • Data portion
    • Pointer to NEXT block
    
    ✅ No external fragmentation
    ✅ No need to know file size in advance
    ✅ File can grow easily
    ✗ Only SEQUENTIAL access (must follow chain)
    ✗ Direct access is very slow (must traverse list)
    ✗ Pointer space overhead in each block
    ✗ If one pointer breaks → rest of file is lost!
```

### FAT (File Allocation Table)

```
    FAT: Variation of linked allocation using a TABLE
    
    File: Start = 2
    
    FAT TABLE (stored in memory):
    ┌───────┬──────────┐
    │ Block │ Next Blk │
    ├───────┼──────────┤
    │   0   │    -     │
    │   1   │    -     │
    │   2   │    6     │ ◄── file_a starts here
    │   3   │    -     │
    │   4   │    -     │
    │   5   │    -     │
    │   6   │    9     │ ◄── next block
    │   7   │    -     │
    │   8   │    -     │
    │   9   │   11     │ ◄── next block
    │  10   │    -     │
    │  11   │   EOF    │ ◄── end of file
    └───────┴──────────┘
    
    Chain: 2 → 6 → 9 → 11 → EOF
    
    ★ FAT is kept in memory → faster traversal
    ★ Used by FAT12, FAT16, FAT32 file systems
    ✗ FAT table itself takes memory
```

### 4.3 Indexed Allocation

Each file has an **index block** that contains pointers to all its data blocks.

```
    INDEXED ALLOCATION:
    
    Directory Entry:
    ┌───────────┬─────────────┐
    │ File Name │ Index Block │
    ├───────────┼─────────────┤
    │ file_a    │      5      │
    └───────────┴─────────────┘
    
    Index Block (Block 5):         Data Blocks:
    ┌─────┬──────────┐             ┌──────────────┐
    │  0  │  → 2     │────────────►│ Block 2 data │
    │  1  │  → 8     │────────────►│ Block 8 data │
    │  2  │  → 14    │────────────►│ Block 14 data│
    │  3  │  → 22    │────────────►│ Block 22 data│
    │  4  │  → NULL  │             │              │
    │ ... │  → NULL  │             └──────────────┘
    └─────┴──────────┘
    
    To access block i of file → index_block[i] → disk block number
    
    ✅ Supports DIRECT access (go to index → find block)
    ✅ No external fragmentation
    ✅ File can grow dynamically
    ✗ Index block wastes space for small files
    ✗ Index block has limited entries → max file size limited
```

### Multi-Level Index (for larger files)

```
    MULTI-LEVEL INDEXED ALLOCATION (UNIX inode style):
    
    INODE:
    ┌────────────────────────┐
    │  File metadata         │
    ├────────────────────────┤
    │ Direct Block 0 ──────────► Data Block
    │ Direct Block 1 ──────────► Data Block
    │ ...                    │
    │ Direct Block 11 ─────────► Data Block
    ├────────────────────────┤
    │ Single Indirect ──────────► ┌─────────┐
    │                        │    │ ptr → DB │
    │                        │    │ ptr → DB │
    │                        │    │ ...      │
    │                        │    └─────────┘
    ├────────────────────────┤
    │ Double Indirect ──────────► ┌─────────┐     ┌─────────┐
    │                        │    │ ptr ──────────►│ ptr → DB│
    │                        │    │ ptr ──────────►│ ptr → DB│
    │                        │    └─────────┘     └─────────┘
    ├────────────────────────┤
    │ Triple Indirect ──────────► (3 levels of indirection)
    └────────────────────────┘
    
    UNIX Example (4 KB blocks, 4-byte pointers):
    ─────────────────────────────────────────────
    Pointers per block = 4096 / 4 = 1024
    
    Direct:          12 × 4 KB = 48 KB
    Single Indirect: 1024 × 4 KB = 4 MB
    Double Indirect: 1024 × 1024 × 4 KB = 4 GB
    Triple Indirect: 1024³ × 4 KB = 4 TB
    
    Total max file size ≈ 4 TB!
```

### Allocation Method Comparison

| Feature | Contiguous | Linked | Indexed |
|---------|-----------|--------|---------|
| **Sequential Access** | ✅ Excellent | ✅ Good | ✅ Good |
| **Direct Access** | ✅ Yes | ❌ No | ✅ Yes |
| **External Fragmentation** | ❌ Yes | ✅ No | ✅ No |
| **File Growth** | ❌ Difficult | ✅ Easy | ✅ Easy |
| **Space Overhead** | ✅ Minimal | ❌ Pointers | ❌ Index blocks |
| **Reliability** | ✅ Good | ❌ One bad ptr → file lost | ✅ Good |
| **Example** | CD-ROM, DVDs | FAT | UNIX (inode) |

---

## 5. Free Space Management

How does the OS track which disk blocks are free?

```
    ┌──────────────────────────────────────────────────────────┐
    │              FREE SPACE MANAGEMENT METHODS                │
    ├──────────────────────────────────────────────────────────┤
    │                                                          │
    │  1. BIT VECTOR (Bitmap)                                  │
    │     Each block = 1 bit (0=free, 1=allocated)             │
    │                                                          │
    │     Block:  0  1  2  3  4  5  6  7  8  9  10 11         │
    │     Bitmap: 0  0  1  1  1  1  0  0  0  1  1  1          │
    │                  (blocks 2-5, 9-11 are in use)           │
    │                                                          │
    │     ✅ Simple and efficient for finding contiguous free   │
    │     ✗ Requires extra space (1 bit per block)             │
    │     Example: 1 TB disk, 4 KB blocks → 32 MB bitmap      │
    │                                                          │
    ├──────────────────────────────────────────────────────────┤
    │                                                          │
    │  2. LINKED LIST                                          │
    │     Free blocks are linked together                      │
    │                                                          │
    │     Head → [Block 0|→] → [Block 1|→] → [Block 6|→] →   │
    │            [Block 7|→] → [Block 8|NULL]                  │
    │                                                          │
    │     ✗ Not efficient for traversal                        │
    │     ✗ Hard to find contiguous blocks                     │
    │     ✅ No wasted space (uses free blocks themselves)     │
    │                                                          │
    ├──────────────────────────────────────────────────────────┤
    │                                                          │
    │  3. GROUPING                                             │
    │     First free block stores n free block addresses       │
    │     Last address points to another group                 │
    │                                                          │
    │     [0: addr1, addr2, ..., addr_n → next group]          │
    │                                                          │
    ├──────────────────────────────────────────────────────────┤
    │                                                          │
    │  4. COUNTING                                             │
    │     Store (start_block, count) pairs for free regions    │
    │                                                          │
    │     (0, 2)  → blocks 0-1 free                            │
    │     (6, 3)  → blocks 6-8 free                            │
    │                                                          │
    │     ✅ Very efficient when free blocks are contiguous    │
    │                                                          │
    └──────────────────────────────────────────────────────────┘
```

---

## 6. File System Implementation

### Layered File System Architecture

```
    ┌──────────────────────────────────┐
    │      APPLICATION PROGRAM         │
    ├──────────────────────────────────┤
    │     LOGICAL FILE SYSTEM          │  ← Manages metadata, directories
    │     (file names, permissions)    │     protection checks
    ├──────────────────────────────────┤
    │   FILE-ORGANIZATION MODULE       │  ← Translates logical block →
    │   (logical ↔ physical blocks)    │     physical block address
    ├──────────────────────────────────┤
    │     BASIC FILE SYSTEM            │  ← Issues commands to device
    │   (generic block I/O commands)   │     driver: "read block 1234"
    ├──────────────────────────────────┤
    │      I/O CONTROL                 │  ← Device drivers, interrupt
    │   (device drivers, interrupts)   │     handlers
    ├──────────────────────────────────┤
    │       HARDWARE (DISK)            │  ← Physical storage device
    └──────────────────────────────────┘
```

### Common File Systems

```
    ┌────────────┬──────────────────────────────────────────────┐
    │    FS      │ Description                                  │
    ├────────────┼──────────────────────────────────────────────┤
    │ FAT32      │ Simple, widely compatible, max 4 GB file     │
    │ NTFS       │ Windows default, journaling, large files     │
    │ ext4       │ Linux default, journaling, large volumes     │
    │ XFS        │ High-performance, scalable (Linux)           │
    │ Btrfs      │ Copy-on-write, snapshots (modern Linux)      │
    │ APFS       │ Apple's modern FS, encryption, snapshots     │
    │ ZFS        │ Enterprise, data integrity, RAID built-in    │
    └────────────┴──────────────────────────────────────────────┘
```

---

## 7. Quick Summary

```
┌────────────────────────────────────────────────────────────────┐
│                 CHAPTER 7: QUICK REVISION                       │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  ★ File: Named collection of data on secondary storage        │
│  ★ Attributes: Name, type, size, location, protection, time   │
│                                                                │
│  ACCESS METHODS:                                               │
│  ★ Sequential: Read in order (tape-like)                      │
│  ★ Direct: Jump to any record by number (CD-like)             │
│  ★ Indexed: Use index to find records                         │
│                                                                │
│  DIRECTORY STRUCTURES:                                         │
│  ★ Single-level → Two-level → Tree → Acyclic Graph            │
│  ★ Tree is most common (Unix/Linux/Windows)                    │
│                                                                │
│  ALLOCATION METHODS:                                           │
│  ★ Contiguous: Fast, but external fragmentation               │
│  ★ Linked: No fragmentation, but no direct access             │
│  ★ Indexed: Direct access, index block overhead (used in UNIX)│
│                                                                │
│  FREE SPACE:                                                   │
│  ★ Bitmap: 1 bit per block (simple, needs space)              │
│  ★ Linked List: Chain of free blocks                          │
│  ★ Counting: (start, count) pairs                             │
│                                                                │
│  ★ Unix uses inode-based indexed allocation with              │
│    multi-level indexing for large files                        │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## 📝 Practice Questions

### 🟢 Level 1: One-Line Answer Questions

| # | Question | Answer |
|---|----------|--------|
| 1 | What is a file? | A named collection of related data stored on secondary storage. |
| 2 | Name the three file allocation methods. | Contiguous, Linked, and Indexed allocation. |
| 3 | What is FAT? | File Allocation Table — a table that tracks linked chains of disk blocks for each file. |
| 4 | Which allocation method supports direct access best? | Indexed allocation (and Contiguous). |
| 5 | What is an inode in Unix? | An index node that stores file metadata and pointers to data blocks. |
| 6 | What is the advantage of contiguous allocation? | Excellent sequential and direct access performance due to locality. |
| 7 | What causes external fragmentation in file allocation? | Contiguous allocation — when files are deleted, gaps form between allocated blocks. |
| 8 | What is a directory? | A special file that contains a list of filenames and their metadata/pointers. |
| 9 | What is a hard link? | Multiple directory entries pointing to the same inode (same file on disk). |
| 10 | What does bitmap free-space management use? | One bit per disk block (0=free, 1=allocated) to track free space. |

---

### 🟡 Level 2: Multiple Choice Questions

| # | Question | Options | Answer |
|---|----------|---------|--------|
| 1 | Contiguous allocation suffers from: | A) Internal fragmentation B) **External fragmentation** C) No fragmentation D) Paging | **B** |
| 2 | In linked allocation, each block contains: | A) File name B) **Data and next block pointer** C) Index D) Inode | **B** |
| 3 | Which directory structure allows sharing without duplication? | A) Single-level B) Two-level C) Tree D) **Acyclic Graph** | **D** |
| 4 | Indexed allocation is similar to: | A) Linked list B) **Paging** C) Contiguous D) Stack | **B** |
| 5 | The Unix inode does NOT store: | A) File size B) **File name** C) Block pointers D) Permissions | **B** |
| 6 | Which allocation allows random access? | A) **Contiguous and Indexed** B) Linked only C) Contiguous only D) None | **A** |
| 7 | FAT file system uses which allocation method? | A) Contiguous B) **Linked** C) Indexed D) Hybrid | **B** |
| 8 | Maximum file size with 12 direct blocks (4KB each) and single indirect (1024 pointers): | A) 48 KB B) 4 MB C) **4 MB + 48 KB** D) 4 GB | **C** |
| 9 | Free space management using bitmap for 2TB disk, 4KB blocks requires: | A) 32 MB B) **64 MB** C) 128 MB D) 256 MB | **B** (2TB/4KB = 2^29 blocks, 2^29 bits = 64 MB) |
| 10 | Which access method requires reading all records before the desired one? | A) Direct B) Indexed C) **Sequential** D) Random | **C** |

---

### 🔴 Level 3: Tricky Conceptual MCQs

| # | Question | Options | Answer | Explanation |
|---|----------|---------|--------|-------------|
| 1 | A file of 20 blocks uses indexed allocation with block size of 512 bytes and pointer size of 4 bytes. How many index blocks needed? | A) 1 B) **1** C) 2 D) 20 | **A** | 512/4 = 128 pointers per index block. 20 < 128, so 1 index block suffices. |
| 2 | In linked allocation, to access block 100 of a file, how many blocks must be read? | A) 1 B) 2 C) 50 D) **100** | **D** | Must traverse blocks 0,1,2...99 to reach block 100 (linked list traversal). |
| 3 | Deleting a file in contiguous allocation requires: | A) Compaction B) **Marking blocks free** C) Rebuilding index D) Unlinking | **B** | Simply mark blocks as free in the free-space list. Compaction is optional optimization. |
| 4 | Which is true about symbolic links? | A) Share inode B) **Can point across file systems** C) Same as hard link D) Prevent deletion | **B** | Symbolic links store a path, so they can span file systems unlike hard links. |
| 5 | Journaling in file systems like ext4/NTFS helps with: | A) Speed B) Compression C) **Crash recovery** D) Encryption | **C** | Journaling logs transactions before applying, enabling recovery after crashes. |

---

### 🔵 Level 4: True / False

| # | Statement | Answer | Explanation |
|---|-----------|--------|-------------|
| 1 | Linked allocation supports efficient direct access. | **False** | Linked allocation only supports sequential access; must traverse chain for direct access. |
| 2 | An inode in Unix stores the filename. | **False** | Filenames are stored in the directory, not the inode. The inode stores metadata and block pointers. |
| 3 | Contiguous allocation requires knowing file size at creation. | **True** | Must allocate continuous blocks, so size must be known upfront. |
| 4 | A hard link and the original file share the same inode. | **True** | Hard links are just additional directory entries pointing to the same inode. |
| 5 | Bitmap free-space management is memory-efficient for large disks. | **False** | Bitmap requires 1 bit per block — for very large disks, it can consume significant memory. |
| 6 | Tree-structured directories allow files with the same name in different directories. | **True** | Different directories can contain files with identical names without conflict. |
| 7 | FAT stores block pointers within data blocks. | **False** | FAT stores all pointers in a separate File Allocation Table, not within data blocks. |
| 8 | Indexed allocation wastes space for very small files. | **True** | Even tiny files need an entire index block. |
| 9 | Deleting a hard link always deletes the file data. | **False** | Data is only deleted when the last hard link (link count = 0) is removed. |
| 10 | ext4 is a journaling file system. | **True** | ext4 supports journaling for crash recovery. |

---

### 🟣 Level 5: Scenario-Based Questions

**Scenario 1:**
> A file system uses contiguous allocation. Files A(size 4), B(size 3), C(size 5) are stored starting at blocks 0, 10, 20. File B is deleted. A new file D(size 6) arrives. Can it be allocated? Where?

**Answer:**
After deleting B, free blocks = {4-9} (6 blocks), {13-19} (7 blocks). File D needs 6 blocks contiguously. Block range 4-9 has exactly 6 free blocks, so D can be allocated starting at block 4. Alternatively, blocks 13-18 would also work.

---

**Scenario 2:**
> In an indexed file system with 4 KB block size and 4-byte pointers: A file has 12 direct pointers, 1 single indirect, and 1 double indirect in its inode. What is the maximum file size?

**Answer:**
```
Pointers per block = 4096 / 4 = 1024

Direct:          12 × 4 KB = 48 KB
Single Indirect: 1024 × 4 KB = 4,096 KB = 4 MB
Double Indirect: 1024 × 1024 × 4 KB = 4,194,304 KB ≈ 4 GB

Maximum file size = 48 KB + 4 MB + 4 GB ≈ 4 GB (approx)
```

---

**Scenario 3:**
> A system uses FAT with 1024 blocks. File X starts at block 3. The FAT entries are: FAT[3]=7, FAT[7]=12, FAT[12]=25, FAT[25]=EOF. How many blocks does file X occupy? To read the 3rd block, which disk block is accessed?

**Answer:**
- Chain: 3 → 7 → 12 → 25 → EOF
- File X occupies **4 blocks** (3, 7, 12, 25)
- 3rd block (index 2, zero-based): Follow chain: block 0 = 3, block 1 = 7, block 2 = **12**

---

**Scenario 4:**
> Compare the disk I/O needed to read a file's 500th block under: (a) Contiguous allocation, (b) Linked allocation, (c) Indexed allocation with single indirect.

**Answer:**
- **(a) Contiguous**: 1 disk read. Direct address: start + 500.
- **(b) Linked**: ~500 disk reads (must traverse 500 blocks sequentially to find the pointer to block 500).
- **(c) Indexed (single indirect)**: 2 disk reads (1 read for index block to get pointer, 1 read for the data block).

---

**Scenario 5:**
> A disk has 1 million blocks. Compare the space overhead of bitmap vs. linked list for free-space management if 30% of blocks are free.

**Answer:**
- **Bitmap**: 1 million bits = 125 KB (regardless of how many are free)
- **Linked list**: 300,000 free blocks × 4 bytes (pointer per block) = ~1.2 MB of pointers
- Bitmap is more space-efficient in this case.
- However, linked list uses the free blocks themselves for storage, so no "extra" space is needed on disk.

---

### 🟤 Level 6: Advanced Real-World Application Questions

**Q1. How does the ext4 file system (used in most Linux systems) implement the inode structure in production?**

**Answer:**

```
ext4 inode structure (256 bytes):
┌─────────────────────────────────────────────────────────────┐
│  Mode (permissions)    │ UID (owner)      │ GID (group)     │
│  Size (lower 32 bits)  │ Access time      │ Creation time   │
│  Modification time     │ Deletion time    │ Link count      │
│  Block count           │ Flags            │ ...             │
├─────────────────────────────────────────────────────────────┤
│  BLOCK POINTERS (60 bytes for i_block):                     │
│  ├── 12 direct block pointers (4 bytes each = 48 bytes)     │
│  ├── 1 single indirect pointer (4 KB → 1024 pointers)       │
│  ├── 1 double indirect pointer (1024² = 1M blocks)          │
│  └── 1 triple indirect pointer (1024³ = 1B blocks)          │
│                                                             │
│  OR in ext4: extents (ranges of contiguous blocks)          │
│  └── 4 extent entries directly in inode (no indirection!)   │
└─────────────────────────────────────────────────────────────┘
```

**ext4 extents** (instead of block pointers):
- An extent = `(start_block, length)` — describes **contiguous** run of blocks
- A 1 GB file: 1 extent `(block 50000, length 262144)` vs 262,144 individual block pointers
- **Huge performance gain**: Large files use far fewer metadata lookups
- **Max file size in ext4**: ~16 TB (with 4KB blocks)

---

**Q2. Compare Windows NTFS and Linux ext4 for handling the same file operations.**

| Operation | ext4 (Linux) | NTFS (Windows) |
|-----------|-------------|----------------|
| **Metadata structure** | inode + directory entry | MFT (Master File Table) record |
| **Max filename length** | 255 bytes | 255 UTF-16 chars |
| **Max file size** | ~16 TB | ~16 EB (exabytes) |
| **Max volume size** | 1 EB | 256 TB |
| **Journaling** | Yes (3 modes: journal/ordered/writeback) | Yes (metadata journaling always on) |
| **File permissions** | POSIX (rwxrwxrwx) | ACLs (Access Control Lists) |
| **Symbolic links** | Hard + Soft links | Junctions (directories), Reparse Points |
| **Compression** | Not built-in (use btrfs) | Built-in, per-file |
| **Encryption** | Not built-in (use LUKS) | EFS (Encrypting File System) |
| **Defragmentation** | Rarely needed (extents + delayed alloc) | Common (block-based allocation) |
| **Timestamps** | 3 (atime, mtime, ctime) | 4 (creation, modification, access, MFT change) |

**Real-world implication**: When you plug a USB drive formatted as NTFS into Linux, the kernel uses its NTFS driver. Ext4 drives on Windows require third-party drivers (ext4Fsd) — this is why cross-platform file systems like exFAT/FAT32 remain popular for USB drives.

---

**Q3. A company stores 5 files with sizes: 1 KB, 100 KB, 1 MB, 10 MB, 1 GB. Which allocation strategy is best for each and why?**

**Answer:**

| File Size | Best Allocation | Reason |
|-----------|-----------------|--------|
| 1 KB (config file) | **Contiguous** | Small file fits in 1-2 blocks; contiguous avoids overhead of index block |
| 100 KB (log file) | **Linked (FAT)** | Growing file — FAT allows easy extension without reallocation |
| 1 MB (image file) | **Indexed** | Medium size; needs direct access; indexed gives random access without traversal |
| 10 MB (database) | **Indexed with extents** | Requires both random and sequential access efficiently |
| 1 GB (video file) | **Contiguous or extents** | Sequential access pattern; contiguous gives best read speed; extents if contiguous block unavailable |

**Real systems**:
- FAT32 (USB drives): Linked allocation (FAT table)
- NTFS/ext4: Indexed with extents for best of both worlds
- HDFS (Hadoop): 128 MB blocks, replicated 3×, sequential access only

---

**Q4. Explain what happens at the OS level when you do `git clone https://github.com/repo.git`.**

**Answer:**

```
Step-by-step OS file system interactions:
1. DNS lookup: getaddrinfo() system call → network
2. TCP connection: socket(), connect() system calls
3. HTTPS handshake: read()/write() on socket
4. Create directory: mkdir() system call
   └── OS allocates new inode for .git/ directory
   └── Directory entry added to parent directory
5. Receive data: read() from network socket
6. Write each file:
   └── open() → creates inode, returns file descriptor
   └── write() → OS buffers in page cache
   └── close() → flush to disk (or stays in page cache)
7. Create symlinks: symlink() system call (e.g., HEAD → refs/heads/main)
8. Set permissions: chmod() system call on executable files
9. fsync() → ensure critical git metadata written to disk

OS resources used:
• ~100-1000 system calls per repository file
• Multiple inodes created (1 per file/directory)
• Disk I/O batched through page cache (write-back policy)
• File descriptor table grows then shrinks per-file
```

---

**Q5. RAID levels use file-system concepts. Map RAID 0, 1, 5, and 6 to file system concepts.**

| RAID | Level | OS/FS Concept | How it works | Use Case |
|------|-------|---------------|--------------|----------|
| **RAID 0** | Striping | Distributed file storage | Data split across N disks; no redundancy | Max performance, no fault tolerance |
| **RAID 1** | Mirroring | File backup/replication | Every write goes to 2 disks; reads from either | Critical data (OS drive) |
| **RAID 5** | Striping + parity | Error correction codes | Data + parity distributed across 3+ disks; 1 disk failure tolerant | Balanced performance + redundancy |
| **RAID 6** | Double parity | Extended error correction | Like RAID 5 but 2 parity blocks; 2 disk failures tolerant | Large arrays where disk failure is common |
| **RAID 10** | Mirroring + Striping | Hybrid | RAID 1 pairs, then striped; 50% capacity | High performance + redundancy (databases) |

**Real production example**: Netflix uses **RAID 6** for cold storage (infrequently accessed video archives) — tolerates 2 simultaneous disk failures in large drive arrays. AWS EBS uses a custom RAID-like distributed storage system across multiple physical disks.

---

**Q6. What is journaling in file systems and how does it protect against data corruption during a crash?**

**Answer:**

**Without journaling** (scenario of power failure mid-write):
```
Writing a new file:
1. Update inode (allocate blocks)         ← CRASH HERE!
2. Write data to blocks
3. Update directory entry
4. Update free space bitmap

Result: Inode points to blocks, but directory never updated.
        Orphaned inode — disk space lost. No fsck fix possible reliably.
```

**With journaling** (ext4 default — ordered mode):
```
Journal (circular log on disk):
1. Write "transaction start" to journal
2. Write all metadata changes to journal (not to actual location yet)
3. Write "transaction commit" to journal  ← CRASH before this = no change made
4. Apply changes to actual disk locations (checkpoint)
5. Mark journal space as free

If crash after step 3: Journal is replayed at boot → all changes applied consistently
If crash before step 3: Journal not committed → all changes abandoned → filesystem clean
```

**Three journaling modes** in ext4:

| Mode | What's Journaled | Performance | Safety |
|------|-----------------|-------------|--------|
| **Writeback** | Metadata only (order not guaranteed) | Fastest | Lowest |
| **Ordered** (default) | Metadata only, data written first | Good | Good |
| **Journal** | Both data and metadata | Slowest | Highest |

**ext4 mount with full journaling**: `mount -o data=journal /dev/sda1 /mnt` — used for databases where every byte of data corruption is unacceptable.

---

> **← [Previous: 06 - Memory Management](06_Memory_Management.md) | [Next: 08 - Disk Scheduling →](08_Disk_Scheduling.md)**
