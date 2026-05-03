# 07. File System

## Table of Contents
- [7.1 File Concept](#71-file-concept)
- [7.2 Directory Structure](#72-directory-structure)
- [7.3 File Allocation Methods](#73-file-allocation-methods)
- [7.4 Free Space Management](#74-free-space-management)
- [7.5 Common Mistakes & Interview Tips](#75-common-mistakes--interview-tips)
- [7.6 Practice & Assessment](#76-practice--assessment)

---

## 7.1 File Concept

### Definition
A **file** is a named collection of related data stored on secondary storage (disk). The OS provides a uniform logical view of files regardless of physical storage.

### File Attributes

| Attribute | Description |
|-----------|-------------|
| Name | Human-readable identifier (report.pdf) |
| Type | Extension indicating file type (.txt, .exe) |
| Size | Current size in bytes |
| Location | Pointer to file location on disk |
| Protection | Access control (read/write/execute permissions) |
| Timestamps | Created, modified, accessed times |
| Owner | User who owns the file |

### File Operations

```
1. Create    → Allocate space, create directory entry
2. Open      → Find file in directory, load metadata into memory
3. Read      → Copy data from file to process buffer
4. Write     → Copy data from process to file
5. Seek      → Move file pointer to specific position
6. Delete    → Remove directory entry, free disk space
7. Truncate  → Erase contents but keep attributes
8. Close     → Release file from memory
```

---

## 7.2 Directory Structure

### Single-Level Directory

```
┌─────────────────────────────────────────┐
│              DIRECTORY                    │
├──────┬──────┬──────┬──────┬──────┬──────┤
│file1 │file2 │file3 │file4 │file5 │file6 │
└──────┴──────┴──────┴──────┴──────┴──────┘

Problem: Name conflicts (two users can't have same filename)
         No organization (all files in one place)
```

### Two-Level Directory

```
┌──────────────────────────────────┐
│         MASTER DIRECTORY          │
├────────────────┬─────────────────┤
│    User 1      │     User 2      │
├────────────────┼─────────────────┤
│ file1, file2   │ file1, file3    │  ← Same name OK (different users)
└────────────────┴─────────────────┘
```

### Tree-Structured (Hierarchical) Directory

```
                    / (root)
                 /  |   \
              /     |     \
           bin    home     etc
          / \     / \       |
        ls  cat  user1 user2  passwd
              / \
          docs  code
          /       \
      report.txt  main.c

This is what Linux and Windows use!
Allows: Absolute path (/home/user1/docs/report.txt)
        Relative path (./docs/report.txt)
```

---

## 7.3 File Allocation Methods

How does the OS store file blocks on disk?

### 1. Contiguous Allocation

```
Each file occupies a SET OF CONTIGUOUS blocks on disk.

Directory entry: [filename, start_block, length]

Disk:
Block: 0  1  2  3  4  5  6  7  8  9  10 11 12
       ├──file A──┤     ├──file B──────┤  ├─C─┤

File A: start=0, length=3 (blocks 0,1,2)
File B: start=4, length=4 (blocks 4,5,6,7)
File C: start=10, length=2 (blocks 10,11)

Advantages:
  ✓ Fast sequential and random access
  ✓ Simple implementation

Disadvantages:
  ✗ External fragmentation
  ✗ File can't grow easily (next block may be occupied)
  ✗ Need to know file size at creation
```

### 2. Linked Allocation

```
Each file is a LINKED LIST of disk blocks. Blocks can be anywhere.

Directory entry: [filename, start_block, end_block]

Block 5: [data | next→8]
Block 8: [data | next→2]
Block 2: [data | next→11]
Block 11: [data | next→NULL]

File: 5 → 8 → 2 → 11

Advantages:
  ✓ No external fragmentation
  ✓ Files can grow easily (just link another block)

Disadvantages:
  ✗ No random access (must traverse from start)
  ✗ Pointer overhead (each block wastes space for "next" pointer)
  ✗ If one pointer corrupts, rest of file is lost
```

### 3. Indexed Allocation

```
Each file has an INDEX BLOCK containing pointers to all data blocks.

Directory entry: [filename, index_block]

Index Block (block 5):
  ┌────────┐
  │ ptr→ 9 │  ← data block 0
  │ ptr→ 3 │  ← data block 1
  │ ptr→ 7 │  ← data block 2
  │ ptr→ 12│  ← data block 3
  │  NULL  │
  └────────┘

Data blocks: 9, 3, 7, 12 (in logical order)

Advantages:
  ✓ Supports random access (go to index, find block pointer)
  ✓ No external fragmentation
  ✓ Files can grow (add pointer to index)

Disadvantages:
  ✗ Index block wastes space for small files
  ✗ Index block size limits maximum file size
    (Solution: multi-level index, like Unix inodes)
```

### Comparison

| Feature | Contiguous | Linked | Indexed |
|---------|-----------|--------|---------|
| Sequential access | Fast | Slow (follow pointers) | Medium |
| Random access | Fast | Very slow | Fast |
| External fragmentation | Yes | No | No |
| File growth | Difficult | Easy | Easy |
| Space overhead | None | Pointers per block | Index block |
| Used in | CD-ROM, DVD | FAT (with FAT table) | Unix/Linux (inodes) |

---

## 7.4 Free Space Management

### Bitmap (Bit Vector)

```
Each block represented by 1 bit:
  0 = free, 1 = allocated

Bitmap: 1 1 0 0 1 1 1 0 0 0 1 1
Block:  0 1 2 3 4 5 6 7 8 9 10 11

Free blocks: 2, 3, 7, 8, 9

Advantage: Simple, efficient for finding contiguous blocks
Disadvantage: Uses memory (1 bit per block)
```

### Linked List

```
Free blocks form a linked list:
  Head → Block 2 → Block 3 → Block 7 → Block 8 → Block 9 → NULL

Advantage: No extra space needed (uses free blocks themselves)
Disadvantage: Slow traversal to find free space
```

---

## 7.5 Common Mistakes & Interview Tips

### Interview Questions

**Q: What is an inode?**
> An inode (index node) is a data structure in Unix/Linux that stores file metadata (permissions, owner, size, timestamps) and pointers to the file's data blocks. Each file has a unique inode number.

**Q: What is the difference between hard link and soft link?**
> Hard link: Another directory entry pointing to the same inode (same file). Soft link (symbolic link): A file that contains the path to another file (like a shortcut). Deleting original breaks soft link but not hard link.

**Q: Compare contiguous vs indexed allocation.**
> Contiguous: Fast random access but suffers external fragmentation and can't grow easily. Indexed: Supports random access and growth via index block, but wastes space for small files.

---

## 7.6 Practice & Assessment

### MCQs

**Q1.** Which allocation method is used in Unix/Linux file systems?
- A) Contiguous
- B) Linked
- C) Indexed (inodes)
- D) Random

**Answer:** C) Indexed (inodes)

---

**Q2.** Linked allocation does NOT support:
- A) Sequential access
- B) File growth
- C) Random access efficiently
- D) Variable file sizes

**Answer:** C) Random access efficiently

---

**Q3.** A bitmap for free space management uses:
- A) 1 byte per block
- B) 1 bit per block
- C) 1 KB per block
- D) No space at all

**Answer:** B) 1 bit per block

---

> **Next Topic:** [08 - I/O and Virtualization](08-io-and-virtualization.md)
