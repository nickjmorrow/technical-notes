# Synchronization Constructs

1. lesson preview
    1. more sync constructs
    2. hardware level support for those constructs
2. visual metaphor
    1. may repeatedly check to continue: sync using spinlocks
    2. wait for signal to continue: wait for a signal to continue. sync using mutexes and contiion variables
    3. waiting hurts performance: CPUs waste cycles for checking; cache effects
3. more about synchronization
    1. mutexes
    2. condition variables
    3. limitation of mutexes and CV
        1. error prone / correctncess / ease-of-use
        2. lack of expressive power, helper variabels for access or priority control
4. spinlocks
    1. spinlock is like a mutex
        1. mutual exxclusion
        2. lock and unlock (free)
    2. lock doesn't check and hten relinquish if lock is busy. instead, it "spins".
5. semaphores
    1. like a traffic light: STOP and GO
    2. similar to a mutex but more general
    3. represented by an integer value
6. POSIX semaphores
7. quiz: mutex via semaphore
8. reader writer locks
    1. specify type of access, lock behaves accordingly
9. using reader writer locks
10. monitors
11. more synchroniation constructs
12. sync building block spinlock
13. quiz: spinlock 1
14. quiz: spinlock 2
15. need for hardware support
16. atomic instructions
17. shared memory multiprocessors
18. cache coherence
19. cache coherence and atomics
20. spinlock performance metrics
    1. reduce latency
        1. time to acquire a free lock
    2. reduce waiting time (elay)
        1. time to stop spinning and acquirea lock that has been freed
        2. ideally immediately
    3. reduce contention
        1. ideally zero
        2. bus/network I/C traggic
21. quiz: conflicting metrics
    1. 1 conflicts with 3
    2. 2 conflicts with 3
22. test and set spinlock
23. test and test and set spinlock
24. quiz: test and test and set spinlock
25. spinlock "delay" alternatives
26. picking a delay
27. queueing lock
28. queueing lock implementation
29. quiz: queueing lock array
30. spinlock performance comparison
31. lesson summary
32. quiz: lesson review
