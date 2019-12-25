# Overview

[Link to course](https://www.udacity.com/course/introduction-to-operating-systems--ud923)

## introduction to operating systems

- software that manages hardware, software resources, and provides common services for programs
- schedules tasks for efficient use of the system
- manages memory allocation
- executing a program involves the creation of a process by hte operating system kernel which assigns memory space to other resources, establishes a priority for the process, loads program binary code into memory

## kernel

- connects the application software to the hardware of a computer.
- provides most basic level of control over all of the computer's hardware devices.

## processes and process management

- OS maintains a data structure that describes the state and resource ownership of each process
- OS must allocate resources to processes and enable processes to share information

## threads and concurrency

- thread of execution is the smallest sequence of programmed instructions that can be managed independently by a scheduler (OS)
- thread is a component of a process, multiple threads can exist in the same process.

## scheduling

- method by which work is assigned to resources that complete the work

## memory management

- provide ways to dynamically allocate portions of memory to programs at their request, and free it for reuse when no longer needed
- critical when more than a single process might be underway at any time
- virtual memory is kept separate from physical memory (a mapping is used)

## inter-process communication

- mechanisms an OS provides to allow processes to manage shared data

## remote procedure calls

- when a program causes a procedure to execute in a different address space
- programmer writes the same code whether the subroutine is local to hte executing program or remote
- form of inter-process communication

## interrupts

- event-based architecture, prevents having OS have to watch for inputs
- can either come from user-level (executing program) or hardware level (click of the mouse)
- processing of hardware interrupts is done by software called a "device driver"
- progarm may interrupt OS if it wants more memory. control then passed to kernel which can process the request
