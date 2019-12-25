# Inter-Process Communication

1. lesson preview
    1. shared memory and shared memory APIs
2. visual metaphor
    1. workers share work area
        1. parts and tools on table
        2. processes share memory
            1. data in shared memory
    2. workers call each other
        1. expxlicit requests and responses
        2. processes exchange messages
            1. message passing via sockets
    3. requires synchronization
        1. i'll start when you finish
        2. mutexes, waiting
3. inter process communication
    1. definition: OS-supported mechanisms for itneraction among processes (coordination & communication)
        1. message passing
            1. sockets, pipes, message queues
        2. memory-based IPC
            1. shared memory, memory mapped files
        3. high-level semantics
            1. files, RPC (remote procedure calls)
        4. synchronization primitives
4. message based IPC
    1. message passing
        1. send/receive of messages
        2. OS creates and maintains a channel
            1. buffer, FIFO queue
        3. OS provides interface to processes - a port
        4. processes send/write messages to a port
        5. processes receive/read messages from a port
    2. kernel required to
        1. establish communicaiton
        2. perform each IPC operation
        3. send: system call + data copy
        4. receive: system call + data copy
    3. cons
        1. overheads of copying to and from the channel
    4. pros
        1. simplicity: kernel does channel management and synchronization
5. forms of message passing
    1. pipes
        1. carry byte stream between 2 processes
    1. message queues
        1. carry "messages" among processes
        2. OS management includes priorities, scheduling of msg delivery
    1. sockets
        1. send(), recv() == pass message buffers
        2. socket() == create kernel-level socket buffer
        3. associate necessary kernel-level processesing
6. shared memory IPC
    1. read and write to shared memory region
        1. OS established shared channel between hte processes
            1. physical pages mapped into virtual address space
            2. VA (PI) and VA (P2) map to the same physical address
            3. VA(PI) != VA(P2)
            4. physical memory doesn't need to be contiguous
    1. pros
        1. system calls only for setup data copies potentially reduced (but not eliminated)
    1. cons
        1. explicit syncrhonization
        2. communication protocol
        3. shared buffer management
        4. programming responsibility
7. quiz: IPC comparison
    1. message-passing must perform multiple copies
    2. shared memory => must establish all mappings among processes' address spaces and shared memory pages
8. copy vs. map
    1. goal: transfer data from one into target address space
    2. copy
        1. CPU cycles to copy data to/from port
    3. map
        1. cpu cycles to map memory into address space
        2. CPU to copy data to channel
        3. pros
            1. set up once use many times => good payoff
            2. can perform well for 1-time use
    4. if data is small, then copy. large data: t(copy) >> t(map)
9. SysV shared memory
    1. "segments" of shared memory => not necessarily contiugous physical pages
    2. shared memory is system-wide => system limits on number of segments and total size
10. SysV shared memory API
    1. create
        1. OS assigns unique key
    2. attach
        1. map virtual => physical addresses
    3. detach
        1. invalid mappings
    4. destory
        1. only remove when explicitly deleted (or reboot)
11. POSIX shared memory API
12. shared memory and synchronization
    1. "like threads accessing shared state in a single address space, but for processes"
    2. synch method
        1. mechanisms supported by process threading library (pthreads)
        2. OS-supported IPC for sync
    3. either method must coordinate
        1. number of concurrent accesses to sahred segment (mutexes)
        2. when data is available and ready for consumption (condition variables)
13. PThreads sync for IPC
14. sync for other IPC
    1. message queues
        1. implement mutual exclusion via send/recv
            1. can be done through "ready" messages
    2. semaphores
        1. OS-supported synch construct
        2. binary semaphore <=> mutex
            1. if value == 0 => stop
            2. if value == 1 => lock
15. quiz: message queue
16. IPC command line tools
17. shared memory design considerations
18. how many segments?
    1. if one larged segment, need to manage allocation
    2. many small segments => use pool of segments, queue of segmentIds
        1. need to also communicate among processes
19. design considerations?
    1. how large should a segment be?
    2. what if data doesn't fit?
    3. segment size == data size => works for well-known static sizes
    4. segment size < message size => transfer data in rounds; include protocol to track progress
20. lesson summary
21. quiz: lesson review
