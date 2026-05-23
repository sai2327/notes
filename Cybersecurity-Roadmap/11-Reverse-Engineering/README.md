# 🔍 Reverse Engineering

## Understanding Binaries — From Assembly to Analysis

---

## Overview

Reverse engineering is the process of analyzing software to understand how it works without access to source code. Essential for malware analysis, vulnerability research, and exploit development.

---

## Prerequisites

- Understanding of C programming
- Computer architecture (CPU, memory, stack)
- Number systems (hex, binary)
- Basic operating system concepts

---

## Assembly Language Fundamentals

### x86-64 Registers

| Register | Purpose | Description |
|----------|---------|-------------|
| RAX | Accumulator | Return values, arithmetic |
| RBX | Base | General purpose |
| RCX | Counter | Loop counter, function arg 4 (Windows) |
| RDX | Data | Function arg 3 (Linux), I/O |
| RSI | Source | Function arg 2 (Linux), string source |
| RDI | Destination | Function arg 1 (Linux), string dest |
| RSP | Stack Pointer | Top of stack (current position) |
| RBP | Base Pointer | Bottom of current stack frame |
| RIP | Instruction Pointer | Next instruction to execute |
| R8-R15 | General | Additional registers (x64 only) |

### Essential Instructions

```nasm
; Data Movement
mov rax, rbx          ; Copy rbx to rax
mov rax, [rbx]        ; Load value at address in rbx
mov [rax], rbx        ; Store rbx at address in rax
lea rax, [rbx+4]      ; Load effective address (calculate address)
push rax              ; Push rax onto stack (RSP decreases)
pop rax               ; Pop top of stack into rax (RSP increases)

; Arithmetic
add rax, rbx          ; rax = rax + rbx
sub rax, rbx          ; rax = rax - rbx
mul rbx               ; rax = rax * rbx
div rbx               ; rax = rax / rbx
inc rax               ; rax++
dec rax               ; rax--
xor rax, rax          ; rax = 0 (common way to zero a register)

; Comparison and Jumps
cmp rax, rbx          ; Compare (sets flags, doesn't store result)
test rax, rax         ; AND without storing (check if zero)
jmp label             ; Unconditional jump
je/jz label           ; Jump if equal/zero
jne/jnz label         ; Jump if not equal/not zero
jg/jl label           ; Jump if greater/less (signed)
ja/jb label           ; Jump if above/below (unsigned)

; Function Calls
call function         ; Push return address, jump to function
ret                   ; Pop return address, jump back
nop                   ; No operation (NOP sled in exploits)
```

### Stack Frame Layout

```
High Address
┌─────────────────────────┐
│  Function arguments      │  (pushed by caller)
├─────────────────────────┤
│  Return address          │  ← Where to go after function returns
├─────────────────────────┤ ← RBP (Base Pointer)
│  Saved RBP              │
├─────────────────────────┤
│  Local variables         │
│  (buffer, integers, etc)│
├─────────────────────────┤ ← RSP (Stack Pointer)
│  ...                     │
└─────────────────────────┘
Low Address

Stack grows DOWNWARD (toward lower addresses)
```

---

## Tools for Reverse Engineering

| Tool | Type | Platform | Cost |
|------|------|----------|------|
| **Ghidra** | Disassembler/Decompiler | All | Free (NSA) |
| **IDA Pro** | Disassembler/Decompiler | All | Expensive |
| **IDA Free** | Disassembler | Windows/Linux | Free |
| **GDB** | Debugger | Linux | Free |
| **x64dbg** | Debugger | Windows | Free |
| **radare2/rizin** | Framework | All | Free |
| **Binary Ninja** | Disassembler | All | Paid |
| **Cutter** | GUI for rizin | All | Free |

---

## GDB (GNU Debugger)

```bash
# Start debugging
gdb ./binary

# Run the program
(gdb) run
(gdb) run arg1 arg2

# Set breakpoints
(gdb) break main              # Break at main function
(gdb) break *0x401234         # Break at address
(gdb) break function_name     # Break at function

# Step through code
(gdb) step                    # Step into functions
(gdb) next                    # Step over functions
(gdb) stepi                   # Single instruction step
(gdb) continue                # Continue to next breakpoint

# Examine memory/registers
(gdb) info registers          # All registers
(gdb) print $rax              # Specific register
(gdb) x/20x $rsp             # Examine 20 hex words at stack pointer
(gdb) x/s 0x401234           # Examine as string
(gdb) x/10i $rip             # Examine 10 instructions at RIP

# Stack
(gdb) backtrace               # Show call stack
(gdb) frame N                 # Switch to frame N

# Useful for exploit development
(gdb) pattern create 200      # Create cyclic pattern
(gdb) pattern offset 0x41414141  # Find offset

# GEF/PEDA extensions (install for better experience!)
# pip install gef
```

---

## Ghidra Quick Start

```
1. Create new project
2. Import binary (File → Import)
3. Double-click to open in CodeBrowser
4. Auto-analysis will run
5. Navigate to main() in Symbol Tree
6. View disassembly (left) and decompiled C (right)
7. Rename variables and functions for clarity
8. Add comments to document your analysis
```

### Key Ghidra Features

- **Decompiler** — Converts assembly back to C-like pseudocode
- **Cross-references** — Where is a function/variable used?
- **String search** — Find interesting strings (passwords, URLs)
- **Function graph** — Visual control flow
- **Patch instructions** — Modify binary behavior

---

## Common RE Patterns

### Identifying Function Prologues

```nasm
; Standard function prologue
push rbp              ; Save old base pointer
mov rbp, rsp          ; Set new base pointer
sub rsp, 0x20         ; Allocate local variables (32 bytes)

; Function epilogue
mov rsp, rbp          ; Restore stack pointer
pop rbp               ; Restore old base pointer
ret                   ; Return to caller
```

### Identifying Loops

```nasm
; for(int i=0; i<10; i++)
    mov ecx, 0        ; i = 0
loop_start:
    cmp ecx, 10       ; i < 10?
    jge loop_end      ; if i >= 10, exit loop
    ; ... loop body ...
    inc ecx           ; i++
    jmp loop_start
loop_end:
```

### Identifying If-Else

```nasm
; if (x == 5) { ... } else { ... }
    cmp eax, 5
    jne else_block     ; if not equal, jump to else
    ; ... if body ...
    jmp end_if
else_block:
    ; ... else body ...
end_if:
```

---

## Practical RE Exercises

### Exercise 1: CrackMe
Reverse engineer a binary to find the correct password without running it.

### Exercise 2: Key Generator
Understand the key validation algorithm and write a keygen.

### Exercise 3: Anti-Debugging
Identify and bypass anti-debugging techniques (ptrace checks, timing checks).

### Exercise 4: Packed Binary
Identify the packer, unpack the binary, then analyze.

---

## Practice Platforms

| Platform | Focus | Level |
|----------|-------|-------|
| crackmes.one | CrackMe challenges | All |
| reversing.kr | RE challenges | Intermediate |
| challenges.re | Dennis Yurichev's challenges | All |
| Microcorruption | Embedded RE (MSP430) | Beginner |
| PicoCTF (RE category) | CTF-style RE | Beginner |

---

**Next:** → [12-Malware-Analysis](../12-Malware-Analysis/README.md)

*"Reverse engineering is reading the story the machine tells, one instruction at a time."*
