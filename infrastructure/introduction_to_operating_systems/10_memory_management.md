# Memory Management

1. lesson preview
    1. physical and virtual memory management
    2. review of memory management mechanisms
2. visual metaphor
    1. use intelligently sized containers
    2. not all parts are needed at once - can move memory onto disc
    3. optimized for performance - store memory that is frequently accessed closer than memory that is not as frequently accessed
3. memory management: goals
    1. manage physical resources
    2. virtual vs physical memory
    3. virtual memory >> physical memory
    4. virtual memory may not be in physical memory - it may instead be on disc
    5. there exists a dynamic component to decide what should be stored on disc
    6. allocate memory from virtual to a physical location
    7. arbitrate - validate that address allocation is correct / makes sense (more details below)
    8. map pages from virtual to page frames on physical
    9. page-based memory management
        1. allocate => pages -> page frames
        2. arbitrate => page tables
    10. segment-based memory management
        1. allocate segments
        2. arbitrate segment registers
    11. paging is dominant in modern OSs
4. memory management: hardware support
    1. memory management unit (mmu)
        1. translate virtual to physical addresses
        2. reports faults: illegal access, inadequate permissions, not present in memory
    2. registers
        1. pointers to page table
        2. base and limit size, number of segments
    3. cache - translation lookaside buffer (TLB)
        1. valid VA-PA translations: TLB
    4. translation
        1. actual PA generation done in hardware
5. page tables
    1. pages are more popular method for memory management
    2. holds mapping of virtual (pages) to physical (DRAM)
    3. VPN: virtual page number
    4. PFN: physical frame number
    5. OS creates page table for every process that it runs
    6. on context switch, use page table of newly switched to process
6. page table entry
    1. page frame number (PFN)
    2. flags
        1. present (valid/invalid)
        2. dirty (written to)
        3. accessed (for read or write)
        4. protection bits => RWX
    3. page fault handler: determines action based on error code and fauling address
        1. bring page from disc to memory
        2. protection error (SIGSEGV)
7. page table size
    1. page table entry (PTE)
    2. process doesn't use entire address space
    3. even on 32-bit arch will not always usse 4GB
    4. BUT page table assumes an entry per VPN, regardless of whether corresponding ivrtual memory is needed or not.
8. multi level page tables
    1. not flat, more hierarchical
    2. outer page table or top page table == page table directory
    3. internal page table == only for valid virtual memory regions
9. quiz: multi level page table
10. speeding up translation tlb
11. inversed page tables
12. segmentation
    1. segments == arbitrary granularity
    2. address = segment selector + offset
    3. semgnet == contiguous portion of physical mmeory
        1. segment size == segment base + limit registers
    4. segmentation + paging used together
13. page size
14. quiz: page table size
15. memory allocation
    1. how to allocate memory to a process
    2. determines VA to PA mapping
    3. address translation, page tbales => determine PA from VA and check validity / permissions
    4. can exist at user level and kernel level
16. memory allocation challenges
17. linux kernel allocators
18. demand paging
19. page replacement
    1. which pages should be swapped out?
        1. pages that won't be used
        2. history-based prediction
            1. least-recently used (LRU policy)
            2. access bit to track if page is referenced
        3. pages that dont need to be written out
            1. dirty bit to track if modified
        4. avoid non-swappable pages
20. quiz: least recently used (lru) cache
21. copy on write
    1. on process creation
        1. map new VA to original page
        2. write protect original page
        3. if only read
            1. save memory and time to copy
    1. on write
        1. page fault and copy
        2. pay copy cost only if necessary
    1. copy cost only paid on needing to perform a write
22. failure management checkpointing
    1. failure & recovery management technique
    2. periodically save process state
    3. simple approach
        1. pause and copy
    4. better approach:
        1. write-protect and copy everythin once
        2. copy diffs of "dirtied pages" for incremental checkpoints
            1. rebuild from multiple diffs, or in background
    5. debugging
        1. rewind-replay (RR)
        2. rewind == restart from checkpoint
        3. gradually go back to older checkpoints until error found
    6. migration
        1. continue on another machine
        2. disaster recovery
        3. consolidation
    7. repeated checkpoints in a fast loop until pause-and-copy becomes acceptable (or unavoidable)
23. quiz: checkpointing
24. lesson summary
25. quiz: lesson review
