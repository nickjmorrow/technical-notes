# Thread Design Considerations

1. lesson preview
    1. threads can be implemented at the kernel level, the user level, or both
    2. threads and interrupts
    3. signals and interrupts
2. kernel vs. user level threads
3. thread data structures: single CPU
4. thread data structures: at scale
5. hard and light process state
    1. hard process state relevant to all user level threads. virtual address mapping
    2. light process state. signal mask, sys call args.
6. rationale for data structures
    1. single PCB
        1. large continuous data structure
        2. private for each entity
        3. save d and restored on each context switch
        4. update for any changes.
        5. cons: sclaability, overheads, performance, flexibility
    2. multiple data structures
        1. smaller data strucutres
        2. easier to share
        3. on context switch only save and restore what needst ochange
        4. user-level library need only update portion of the state
7. quiz: thread structures
8. user level structures in solaris 2.0
    1. not pthreads, but similar
    2. thread creation => threadId (tId)
        1. tId => index into table of pointers
        2. table pointers point to per thread data structure
        3. stack growth can be dangerous
            1. solution: separate info about different threads with "red zone", portion of virtual address space that is not allocated. ensures that when thread writes to red zone, immediately faults, and is obvious what thread did that.
9. kernel level structures in solaris 2.0
10. basic thread management interaction
11. quiz: pthread concurrency
12. thread management visibility and design
    1. user-level library sees:
        1. user-level threads (ULTs)
        2. availabel KLTs
    2. kernel sees
        1. kernel-level threads (KLTs)
        2. CPUs
        3. KL scheduler
    3. process jumpts to ULlibrary scheduler when:
        1. ULTs explicitly yield
        2. timer set by ULlibrary expires
        3. ULTs call library functions like lock/unlock
        4. blocked threads become runnable
    4. UL library shceduler
        1. runs on ULT operatoins
        2. runs on signals from timer or kernel
13. issues on multiple CPUs
    1. in multi-CPU, kernel-level threads may be running on multiple CPUs. so user-level library threads might need to impact a kernel-level thread running on a different CPU.
    2. in other words, we need to signal a kernel thread on a another CPU.
14. synchronization-related issues
    1. ataptive mutexes: if critical section is short, then don't block, and instead spin. for long critical sections, use default blocking behavior.
    2. destroying threads: not destroying, actually reusing. when a thread exits, it's "put on death row", periodically destroyed by reaper thread that frees up all data structures associated with thread.
15. quiz: number of threads
16. interrupts and signals intro

    1. interrupts: events generated externally by components other than the CPU (I/O devices, timers, other CPUs)
        1. determined based on the physical platform
        2. appear asynchronously
    2. signals
        1. events triggered by the CPU and software running on it
        2. determined based on the operating system
        3. appear synchronously or asynchronously
    3. similariries

        1. have a uniqueId depending on the hardware or OS
        2. can be masekd and disabled / suspended via corresponding mask
            1. per-CPU interrupt mask, per-process signal mask
        3. if enabled, trigger corresponding handler
            1. interrupt handler set for entire system by OS
            2. signal handlers set on per process basis, by process

17. visual metaphor
    1. an interrupt is like a snowstorm warning
    2. a signal is like a battery is low warning
        1. handled in specific ways
            1. safety protocols, hazard plans
        2. can be ignored
            1. continue working
        3. expeced or unexpected
            1. happen regularly or irregularly
18. interrupt handling
    1. get interrupt, get an id associated with the interrupt, and use a mapping table which tells you where in the code to begin executing to handle the interrupt
19. signal handling
    1. remember - signal does not come from an external component, it comes from within
    2.
20. why disable interrupts or signals
    1. useful to disable interrupts / signals to prevent deadlocks. if a signal occurs and we lock a mutex, then the same signal occurs, we'll hit a deadlock. so now when a signal occurs we can disable it, so that we know when we're using the mutex, hitting the same signal again won't cause a deadlock.
21. more on signal masks
    1. interrupt masks are per CPU
        1. if mask idsables interrupt => hardware interrupt routing mechanism will not deliver interrupt to CPU
    1. signal masks are per execution context (ULT on top of KLT)
        1. if mask disabeld signal => kernel sees mask and will not interrupt corresponding execution context
22. interrupts on multicore systems
    1. interrupts can be directed to any CPU that has them enabled
    2. may set interrupt on just a single core
        1. avoids overheads & perturbations on all other cores
23. types of signals
    1. one shot signals
        1. n signals pending == 1 signal pending : at least once
        2. handling routine must be explicitly re-enabled
    1. real time siganls
        1. if n signals raised, then handler is called n times
24. quiz: signals
    1. using the most recent POSIXX standard indicate the correct signal names for the following events:
        1. terminal interrupt signal: SIGINT
        2. high bandwidth data is available on a socket: SIGURG
        3. background process attempting write: SIGTTOU
        4. file size limit exceeded: SIGXFSZ
25. interrupts as threads
    1. can elevate interrupts to "full-fledged threads" with their own context and data structure, this will allow them to handle the mutex / deadlock issue
    2. dynamic thread creation is expensive
    3. dynamic decision
        1. if handler doesn't lock => execute on interrupted thead's stack
        2. if handler can block => turn into real thread
    4. optimization
        1. precreate and preinitialize thread structures for interrupt routines
26. interrupts: top vs. bottom half
    1. if you want to incorporate arbitrary functionality to be incorporated in the interrupt-handling operations, then you really need to make sure that handling routine is executed by another thead that you can potentially synchronize with and that thread is allowed to block.
27. performance of threads as interrupts
    1. overhead of 40 sparc instructions per interrupt
    2. saving of 12 instructions epr mutex
        1. no changes in interrupt mask, level...
    3. fewer interrupts htan mutex lock/unlock interruptions
    4. It's a win! Optimize for the common case. Optimize for mutex lock/unlock operations.
28. threads and signal handling
    1. disbale => clear signal mask
    2. signal occurs - what should kernel do with signal? kernel-mask not visible to user level and vice-versa.
29. threads and signal handling: case 1
    1. ULT mask = 1, KLT mask = 1. no problem, kernel encounters signal, it's enabled at kernel level, tells user-level, ULT also has signal enabled, all good.
30. threads and signal handling: case 2
    1. KLT mask = 1, ULT mask = 0. another ULT in run queue that has mask = 1.
31. threads and signal handling: case 3
32. threads and signal handling: case 4
    1. signals less frequent than signal mask updates
    2. system calls avoided - cheaper to update UL mask
    3. signal handling more expensive
33. tasks in linux
    1. main execution abstraction => task
        1. kernel-level thread
    2. single-threaded process => 1 task
    3. multi-threaded process => many tasks
34. lesson summary
35. quiz: lesson review

what is a signal mask?
