# Scheduling

1. lesson preview
2. visual metaphor
    1. dispatch orders immediately
        1. scheduling is simple (first come, first services)
    2. dispatch simple orders first
        1. maximize throughput
    3. dispatch complex orders first
        1. maximize utilization of CPU, devices, memory
3. scheduling overview
    1. cpu scheduler
        1. chooses one of ready tasks to run on CPU
        2. runs when
            1. cpu becomes idle
            2. new task becomes ready
            3. timeslice experied timeout
4. run to completion scheduling
    1. SJF: shortest job first
5. quiz: sjf performance
6. preemptive scheduilng: sjf + preempt
    1. tasks dont just get the CPU and hog it until they're completed
    2. tasks can stop to better align to the scheduling algorithm
    3. execution time is something we need to estimate, often by previous execution times for similar tasks
7. prempetive scheduling: priority
    1. priority scheduling
        1. tasks have different priority levels
        2. run highest priority task next (preemption)
    2. priority aging: priority = f(actual priority, time spent in run queue). longer task has spent in run queue, higher priority it should become.
    3. eventually task will run. prevents starvation.
8. quiz: preemptive scheduling
9. priority inversion
    1. when a thread acquires a lock, any other (even higher priority) threads that need that lock will be put on a wait queue until that lock is unlocked. as soon as it is, the higher priority thread will be runnable and will take over execution from the lower priority thread that released the lock.
    2. solution is to boost priority of mutex owner, then lower again on release.
10. round robin scheduling
    1. alternative to fcfc, sjf
    2. steps
        1. pick up first task from queue (like FCFS)
        2. task may yield, to wait on i/o (unlike fcfs)
    3. can also interrupt tasks and schedule another, alternating between them / cycling
11. timesharing and timeslices
    1. maximum amount of uninterrupted time given to a task
    2. task can take less time than the timeslice
        1. has to wait on i/o, synchronization
    3. pros
        1. short tasks finish sooner
        2. more responsive
        3. lengthy I/O ops initiated sooner
    4. cons
        1. overheads
12. how long should a timeslice be
13. cpu bound timeslice length
    1. cpu-bound task prefers a larger timeslice
14. i/o bound timeslice length
    1. when a task yields, another task can take over
    2. lets you parallelize more I/O operations
15. summarizing timeslice length
    1. cpu bound tasks prefer long timeslices
        1. limits context switching overheads
        2. keeps CPU utilitization and throughput hihg
    2. I/O bound tasks prefer shorter timeslices
        1. I/O bound tasks can issue I/O ops earlier
        2. keeps CPU and device utilization high
        3. better user-perceived performance
16. quiz: timeslice
17. runqueue data structure
    1. can be multiple queues, ordred by how I/O intensive or CPU intensive the tasks are
    2. pros
        1. timeslicing benefits provided for I/O bound tasks
        2. timeslicing overheads avoided for CPU bound tasks
    3. mutli-level feedback queue
        1. can move tasks across queues as it realizes tasks are more or less cpu-intensive vs. i/o intensive
18. linux O(1) scheduler
19. linux CFS scheduler
    1. issue with O(1)
        1. poor performance of interactive tasks
        2. fairness => in a given amount of time, all tasks should be able to run for an amont of time proportional to its fairness
20. quiz: linux schedulers
    1. O(1) replaced by CFS. because itneracdtive tasks could wait unpredictable amounts of time to be scheduled
    2. O(1) = took constant amount of time to select task based on load
21. scheduling on multiprocessors
    1. last level cache (LLC) not shared between CPUs
    2. memory (DRAM)
    3. all of the memory in the system is shared among multiple CPUs
    4. in multi-core, the LLC is shared
    5. if thread is scheduled on a different CPU, may hit colder cache
    6. schedule thread on CPU that we executed before (cache affinity)
22. hyperthreading
    1. multiple hardware-supported exxecution contexts
    2. still 1 CPU but with _very fast_ context switch
23. scheduling on hyperthreading platforms
    1. co-schedule compute- and memory-bound threads
    2. mixx of CPU and memory-intensive threads
    3. avoid/limit contention on processor pipeline
    4. all components (CPU and memory) well utilized
24. cpu bound or memory bound
    1. use historic implementation to inform whether thread is considered cpu-bound or memory-bound
    2. "sleep time" won't work
        1. the thread is not sleeping when waiting on memory
        2. software takes too much time to compute
    3. need hardware-level information
        1. hardware counters: estimate what kind of resources a thread needs
    4. scheduler can now make informed decisions
        1. typically mulitple counters
        2. models with per architecture thresholds
        3. based on well-understood workloads
25. scheduling with hardware counters
    1. is cycles-per-instruction (CPI) useful?
    2. memory bound => high cpi
    3. cpu-bound => 1 (or low) cpi
26. quiz: cpi experiment
27. cpi experiment results
28. lesson summary
29. quiz: lesson review

0 T3 (4s)
1 T3 (3s)
2 T3 (2s)
3 T2 (4s)
4 T2 (3s)
5 T1 (3s)
6 T1 (2s)
7 T1 (1s)
8 T2 (2s), T1 (0s)
9 T2 (1s)
10 T3 (1s), T2 (0s)
11 T3 (0s)
