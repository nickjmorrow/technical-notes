# Threads and Concurrency

    1. Visual metaphor
        1. Thread like a worker in a toyshop
        2. Works simultaneously with others
        3. Requires coordination when working with others at the same time towards the same goal
    2. Process vs. thread
        1. Single-threaded process represented by address space (code, data, files, registers, stack pointer, program counter, all represented in PCB)
        2. Threads share (code, data, files) but have different execution contexts. Different data structures to represent different states.
    3. Benefits of multithreading
        1. Give higher priority to threads that handle more important tasks or customers
        2. Can parallelize threads
        3. Specialization -> hotter cache, as each thread now has its own cache
        4. Threads share an address space when multithreaded. More memory-efficient than a multi-process alternative. More likely to fit in memory.
        5. Synchronizing among processes is costly. But sharing variables among threads in a single process is not as costly.
        6. More efficient in resource requirements and incur lower overheads than hteir inter-process alternatives.
    4. Beneits of multithreading: single CPU
        1. Are threads useful when # threads > # CPUs? When context-switching maong threads, no need o recreate address space, as it is shared. Context switching among threads << switching between processes. Multithreading is useful because it allows us to hide latency.
    5. Benefits of multithreading: Apps and OS
        1. Allow OS to suppport multiple-execution context. Multiple CPUs. OS sys threads run on behalf of certain apps or OS-level services.
    6. Quiz: Process vs. Threads
    7. Threads can share a virtual address space. Processes take longer to context switch. Both threads and processes have na execution context. Threads usually result in hotter caches when multiple exist. OS supports inter-process communication, and we'll see that there are similar mechanisms for thread communication.
    8. Basic thread mechanisms
        1. what do we need to support threads?
            1. thread data structure: identity threads, keep track of resource usage
            2. mechanisms to create an manage threads
            3. mechanisms to safely coordinate among threads running concurrently in the same address space
        2. threads and concurrency
            1. how to prevent threads from both updating data at same time? race conditions.
            2. mutual exlusion - exclusive access to only one thread at a time.
            3. must be able to waiting on other threads, and specific condition before proceeding. e.g. wait for all items to be processed before shipping. thread must wait until notified. "condition variable".
                1. waking up other threads from a wait state
        3. synchronization mechanisms: "mutual exclusion" and "condition variables"
    9. Thread creation
        1. thread type - data structure that describes a thread
            1. thread ID
            2. register values
            3. program counter (PC)
            4. stack of the thread
            5. attributes, like priority
        2. fork is used to create a thread (not UNIX fork). executes (proc, arg), procedure with arguments
        3. upon fork, program counter = proc, stack = arguments
    10. Thread creation example
    11. Mutexes
        1.  Like a lock whenever accessing state shared among threads. "acquire lock, acquire mutex". Suspended until mutex owner releases the lock / mutex. Mutex has { locked, owner, blocked_threads }.
        2.  Upon acquiring a mutex, thread enters the "critical section".
    12. Mutual exclusion
    13. Mutex example
    14. Quiz: Mutx
    15. Producer and consumer example
        1.  several producer threads that populate list, consuemr thread that consumes list once list is full.
    16. Condition variables
        1.  producers check if list is full after insertion, and if so, update condition variable so that consumer may consume
    17. Condition variable API
        1.  need reference to mutex
        2.  list of waiting threads
    18. Quiz: Condition variable
    19. Reader/writer problem
        1.  Multiple reader threads. One writer thread. Reading and writing cannot happen at same time. But multiple readers is fine - so need something more sophisticated than just a mutex. Use a resource_counter to denote what actions are currently being performed on the resource.
    20. Readers and writers example part 1
    21. Readers and writers example part 2
    22. Readers and writers example part 3
    23. Critical section structure
    24. Critical section structure with proxy
    25. Common pitfalls
        1.  Keep track of mutex / condition variabels used with a resource
        2.  Check that you are always ( and coorectly) using lock & unlock. Use same mutex everywhere for same resource. Dont forget to lock and unlock.
        3.  Use only a single mutex to access a single resource.
        4.  Check that you are signaling correct condition
        5.  Check that you aren ot using signal when broadcast is needed.
            1.  Singal: only 1 thread will proceed, remaining threads will continue to wait, possibly indefinitely.
        6.  ask yourself: do you need priority guarantees?
    26. Spurious wake ups
        1.  When we wake up threads that end up only waiting. Waking up thraeds knowing they may not be able to proceed.
        2.  To fix, unlock mutex and then broadcast/signal. This works for writers, but does not work for readers. Readers need to check locked resource to see if it can unlock resource / no other readers are using it.
    27. Deadlocks introduction
        1.  Definition: Two or more competing threads are waiting on each other to complete, but none of them ever do.
    28. Deadlocks
        1.  To avoid, Maintain lock order: first m_A, then m_B. This will prevent a cycle of T1 wanting m_A and T2 wanting m_B.
    29. Deadlocks summary
        1.  A cycle in the wait graph is necessary and sufficient for a deadlock to occur. In other words, edges from thread waiting on a resource to thread owning a resource.
        2.  What can do we do about it?
            1.  deadlock prevention (expensive)
            2.  deadlock detection and recovery (rollback)
    30. Quiz: Critical section
    31. Kernel vs. user-level threads
        1.  OS scheduler determines kernel-level threads. Kernel threads can support uesr-level threads.
        2.  user-level thread must be associated with kernel-level thread.
    32. Multithreading models
        1.  one-to-one-model for kernel to user-level thread. OS can see all the user-level threads. user-level processes can benefit from support available at kernel. downside - must go to OS for all operations (expensive). OS has limits on policies supported at kernel level (like # threads that can be supported). Poorer portability due to coupling to OS policies.
        2.  many to one model, many user level threads to kernel thread. Totally portable, doesn't depend on OS limits and policies. Don't have ot make system calls / no reliance on OS. Problems - OS has no insights into application needs. OS may block entire process if one uesr-level thread blocks on I/O.
        3.  many to many. Some user level threads go to one ekrnel thread, others have a many-to-one. Can be best of both worlds. Can have bound (one to one) or unbound threads (many to one). Can prioritize certain threads.
    33. Scope of multithreading
        1.  Different levels of multithreading. At system scope: system-wide thread management by OS-level thread managers (CPU scheudler). process scope: user-level lirbnary manages threads within a single process.
    34. Multithreading patterns
    35. Boss/workers pattern
        1.  One boss thread, some number of worker threads. Boss assigns work to the workers. Boss thread must execute on every piece of work coming in. Thourghput of system limited by boss thread. Boss thread should immediately pass work onto workers. Boss passes work by keeping track of which workers are free. This means that boss has to do more work. The pro is that workers don't need to synchronize amongst themselves.
        2.  Another option is to establish a queue between the boss and the workers. Boss just places work into shared queue. When worker becomes free, it checks queue. Pro - boss doesn't need to know details about workers. Downside - queue synchronization.
    36. How many workers?
        1.  Can add more workers on demand. Can be inefficient if we need to wait for worker, so instead we create a pool of workers upfront. How do we know how many threads to create in a pool? We allow pool to dynamically increase in size. Pros - simple. Cons - thread pool management, and locality. If a worker just completed a task, it will probably be better at performing that kind of task in the future, but we can't optimize for that here.
    37. Boss/workers variants
        1.  All workers created equal vs. workers specialized for certain tasks. Pros - better locality, QoS (quality of service) management. Con - more complicated load balancing.
    38. Pipeline pattern
        1.  Every single worker assigned one step of hte process. Mutliple tasks concurrently in the systme, in different pipeline stages.
        2.  Throughput dependent on weakest link.
        3.  If one stage takes a longer time, then assign more threads to taht stage (use a thread pool).
        4.  Use shared-buffer based communcation between stages.
        5.  Pros - allows for specialization and locality. Cons - balancing and synchronization overheads.
    39. Layered pattern
        1.  Each layer group of related tasks. End-to-end task must pass up and down through all layers.
        2.  Pro - specialization, less fine-grained pipeline. Cons - not suitable for all applications. Synchronization more complex.
    40. Quiz: Multithreading patterns
        1.  6-step toy order application. We have a boss-workers solution and a pipeline solution. 6 threads total for each solution.
        2.  In boss-workers, a worker processes a toy order in 120ms
        3.  In pipeline, each of hte 6 stages take 20ms.
            1.  Boss-workers
                1.  10 orders takes 240ms
                2.  11 orders takes 360ms
            2.  Pipeline
                1.  10 orders takes 300ms
                2.  11 orders takes 320ms
