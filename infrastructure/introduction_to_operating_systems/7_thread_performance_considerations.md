# Thread Performance Considerations

1. Lesson Preview
2. Which threading model is better?
    1. boss-worker vs pipeline
    2. boss-worker
        1. orders completed in shorter amount of time
    3. pipeline
        1. completes the most orders in a long enough amount of time
3. are threads useful?
    1. yes
        1. parallelization
        2. specializtaion -> hot cache
        3. efficiency, lower memory requirement and cheap synchr
    2. threads hide latency of I/O operations
4. visual metaphor
5. performance metrics intro
    1. execution time
    2. software implementation of a problem
    3. its improvement compared to other implementations
6. performance metrics
    1. wait time
    2. execution time
    3. throughput
    4. request rate
    5. CPU utilization
    6. platform efficiency
7. performance metrics summary
    1. obtaining metrics by running experiments
8. really...are threads useful?
    1. depends on metrics
    2. depends on workload
9. multi process vs. multi threaded
    1. how to best provide concurrency?
    2. ex: concurrency processing of client requests on a web server
    3. multiple threads
    4. multiple processes
10. multi process web server
    1. simple programming
    2. many processes => high memory usage, costly context switching, hard/costly to maintain shared state (tricky port setup)
11. multi threaded web server
    1. pros
        1. shared address space
        2. shared state
        3. cheap context switch
    2. cons
        1. not simple implementation
        2. resuires synchronization
        3. underlying support for threads
12. event-driven model
13. concurrency in the event driven model
14. event-driven model: why
15. event-driven model: how
    1. single address space, single flow of control
    2. smaller memory requirement
    3. no context switching
    4. no synchronization
16. helper threads and processes
    1. pros
        1. resolves portability limitations of basic event-driven model
        2. smaller footprint than regular worker thread
    2. cons
        1. applicability to certain classes of applications
        2. event routing on events of multi-cpu systems
17. quiz: models and memory quiz
    1. event-driven uses less memory in comparison to the pipeline or boss-worker thread driven models
18. flash web server
19. apache web server
20. experimental methodology
    1. what systems are you comparing? define comparison points
    2. what workloads will be used? define inputs
    3. how will you measure performance? define metrics
21. experimental results
22. summary of performance benefits
23. quiz: performance observation
24. advice on designing experiments
25. advice on running experiments
26. quiz: experimental design quiz
27. lesson summary
