# Processes and Process Management

    1. Lesson Preview
        1. Process is an instance of an executing program. Task or job may be used interchangeably.
    2. Visual Metaphor
        1. A process is like an order of toys. It has a state of execution. A parts and temporary holding area. May also need special hardware to create an order of toys.
        2. Process has a state of execution (program counter, stack counter). Has a temporary holding area (data, register state occupies state in memory). Requires special hardware like disks or network devices.
    3. What is a Process?
        1. OS manages hardware on behalf of applications. Application is a program on disk or static memory - it is a static entity.
        2. Process is an active entity. Program can be launched more than once to have multiple processes (with different state).
            1. Ex: Multiple instances of a text editor program. Multiple processes.
        3. Process represents the execution state of an active application.
    4. What Does a Process Look Like?
        1. Process encapsulates code, data, variables of a running application. Every element has an address in an address state. Rnge of addresses from v0 to vMax.
            1. Types of state
                1. text and data: static state when process first loads
                2. Heap: dynamically created during execution
                    1. "Hole" in the address space that holds a variable amount of information
                3. Stack: Grows and shrinks in LIFO queue
                    1. Need to be able to restore state when we move back and forth in parts of the application
                    2. Lots of parts during process application where this kind of traversal is useful.
    5. Process Address Space
        1. This representation is an address space. It has virtual addresses. Address space = 'in memory' representation of a process.
        2. Addresses called virtual because they don't have to correspond to actual physical ocmponents. It contains a mapping to physical addresses, which decouples applications needing to know hwo to manage their physical memory.
        3. When hte process requests some memory to be allocated to it, the address of the physical memory that the OS actually allocates may be totally different. Mapping between virtual and physical addresses that application need not know about.
    6. Address Space and Memory Management
        1. Not all processes require the entirety of the address space from v0 to vMax.
        2. The OS decides which portion of the address space will be present in physical memory. Processes may have portions of their address space swapped temporarily to locations "on disk". Addresses swapped to disk to make room for running processes.
        3. For each process, OS maintains some information regarding the address space. The OS uses this information to make a mapping of virtual to physical space, and to ensure the validity of process memory access (not trying to access location that is not permissioned to process).
    7. Quiz: Virtual Addresses Quiz
        1. Two processes can have the same virtual address space: P1 from 0 - 64,000, and P2 from 0 - 64,000. The mapping will map the processes to different physical addresses, even if they have the same virtual addresses.
    8. Process Execution State
        1. OS must have an idea of what a process was doing so that it can stop and restart processes from the same point.
        2. Apps, before they can execute, must be compiled and produce binary. At any given point, CPU needs to know where in the instruction sequence the application is. The program counter holds CPU registers that carry state of the process.
        3. Another piece of state is the process stack, which has a stack pointer at the top. Stack has LIFO behavior.
        4. There are other bits of informaiton that help an OS know what a process is doing at any given point. It maintains this information in a process control block, or PCB.
    9. Process Control Block
        1. PCB is a data structure that OS maintains for every process.
        2. Created when process is created.
        3. Certain fields are updated when process state changes. Like memory allocation will update memory limits and valid virtual address regions.
        4. Other parts of PCB structure change frequently. Program counter changes on each instruction execution. The CPU has a dedicated register which is uses to track the current instruction on the currently running task. It is hte OS's job to ensure that ifnromation recorded by the CPU is transferred to hte individual PCB for the currently executing task.
        5. PCB Structure
            1. Process state
            2. Process number
            3. Program counter
            4. Registers
            5. Memory limits
            6. List of open files
            7. Priority
            8. Signal mask
            9. CPU scheduling info
    10. How is a PCB Used?
        1. Manages P1 and P2. P1 is currently running, P2 is idle. CPU registers hold state that corresponds to P1. At some point, OS interrupts P1 (it becomes idle). It now saves all the state information in P1 into the PCB block for P1. It now starts P2. It updates CPU registers to hold those that correspond to the PCB of P2. If P2 needs more physical memory, it will allocate that memory and establish mroe virtual -> physical mapping for P2. When OS interrupts P2, it saves information regarding state into PCB for P2. It restores state from PCB for P1. P1 resumes at exact same point because P1's PCB has not changed while it was idle.
    11. Context Switch
        1. OS must swap between P1 and P2. The PCB blocks for hte processes reside in memory.
        2. Context switch is mechanism used by OS to switch execution in context of one process to context of another process.
        3. Operation can be expensive
            1. Direct costs - number of cycles that must be executed to load contents of PCB to and from memory
            2. When P1 is runnign on CPU, it sotres a lot of its data in the processor cache hierarchy. Modern CPUs have a hierarchy of caches, each one larger and slower than the prvious. Accessing hte cache is much faster than accesses to memory. When data is present in cache, we say cache is hot. But when we contexxt switch to P2, some or all of data in the cache is replaced to make space for the data in P2. So when it comes backt o execute P1, it will be running on a cold cache without its previous set of data. We want to limit context switching.
    12. Quiz: Hot Cache Quiz
        1. When a cache is hot...
            1. Most process data is in the cache so the process performance will be at its best
            2. Sometimes we must context switch
    13. Process Life Cycle: States
        1. Can be running or idling. When running, it can be iterrupted and become idle.
        2. Scheduler dispatch can move processes from idle to running.
        3. What other states can it be in?
            1. When process created, it enters 'new' state. OS enters permissions control, OS ensures there are resources for the process.
            2. 'Ready' until scheduler is able to move it to a running state.
            3. 'Running' when scheduler moves it. From here, it can be interrupted (context siwtch), move back to 'ready'.
            4. 'Waiting' when it's waiting for a longer operation like I/O or event completion.
            5. 'Terminated'.
    14. Quiz: Process State Quiz
        1. A CPU is able to execute a process when it is:
            1. Running: A running process is already executing
            2. Ready: CPU is able to execute them, just waiting for scheduler to schedule them.
    15. Process Life Cycle Creation
        1. How are processes created? Process can create child processes. User can also spawn of process, like when they click something.
        2. Mechanisms for process creation
            1. Fork mechanism - OS craetes new PCB for child process, copying PCB values from parent to child PCB. So parent and child begin execution at point immediately after fork.
            2. Replace child image, load new program, PCB will point to new program. Program counter will now point to first instruction in the new program. Actual flow is calling fork to create new process and then exec to replace child image with new image.
    16. Quiz: Parent Process Quiz
        1. On UNIX based OSs, which process is often regarded as 'the parent of all processes'?
            1. 'init' is hte first process that starts after the system boots. All processes can be traced to init.
        2. On the Android OS, which process is regarded as the 'parent of all app processes'?
            1. 'zygote' is the parent. Android forks zygote whenever a new process needs to be created.
    17. Role of the CPU Scheduler
        1. For CPu to execute process, it must be ready first. But multiple ready processes in the "ready queue". How does CPU pick?
        2. A "CPU scheduler" determines which one of the currently ready processes will be dispatched to the CPU to start running and how long it should run for.
        3. CPU Scheduler decides wihch one of the currently ready proesses to be scheduled, and how long it should run for. It can pre-empt / interrupt currently executing process.
        4. Preempt == interrupt and save current context
        5. Schedule == run scheduler to choose next process
        6. Dispatch == dispatch process and switch into its context.
        7. Must minimize amount of time it needs to perform scheduling algorithms.
    18. Length of Process
        1. How long should a process run for? How frequently should we run the scheduler? Longer we run a process, the less frequently we invoke the scheduler.
        2. Total processing time / Total duration of interval == efficiency. Minimize amount of time CPU is doing "systems processing work and scheduling".
        3. Scheduling Design Decisions:
            1. What are appropriate timeslice values?
            2. Metrics to choose next process to run?
    19. What about I/O?
        1. Process remains in IO queue until IO is complete and it can respond to request.
        2. Process can make its way into ready queue in a number of ways. If it was waiting for an IO event. If it was running on CPU but its timeslice expiresd. If its a child that was forked. Or if it was interrupted, can be placed on ready queue.
    20. Quiz: Scheduler Responsibility Quiz
        1. Scheduler has no contorl over when I/O operations occur.
    21. Inter Process Communication (IPC)
        1. OS must provide mechanisms to allow processes to interact with one-another.
        2. IPC mechanisms:
            1. Transfer data/infro between address spaces
            2. Maintain protection and isolation
            3. Provide flexibility and performance
        3. Message-passing
            1. OS provides communication channel, like shared buffer
            2. Processes write (send) / read (recieve) messages to/from channel
        4. Message-passing can be annoying taht we need to copy so much information to and from the chnale.
        5. Shared-memory IPC
            1. OS establishes a shared channel and maps it into each process address space.
            2. Processes directly read/write from this memory.
            3. OS is out of the way!
            4. Con - developers have to re-implement code to use shared area.
    22. Quiz: Shared Memory Quiz
        1. Individual data exchange may be cheap. But mapping memory between two proceses - that oepration is expensive. So setup cost must be appropriately amortized.
    23. Lesson Summary
    24. Quiz: Lesson Review
