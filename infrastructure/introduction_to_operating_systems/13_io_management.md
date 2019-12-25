# IO Management

1. lesson preview
    1. OS support for IO devices
    2. block device stack
    3. file system architecture
2. visual metaphor
    1. making toys is abstracted from the shipping process
    2. have protocols
        1. interfaces for device IO
    3. have dedicated handlers
        1. device drivers, interrupt handlers
    4. decouple i/o details from core processing
        1. abstract IO device detail from upperl evel components
3. i/o devices
4. quiz: i/o devices
5. i/o device features
    1. microcontroller == device's CPU
6. cpu device interconnect
    1. PCI (peripheral component interconnect)
    2. way that devices interconnect to CPU
    3. other types of interconnects
        1. SCSI bus
        2. peripheral bus
        3. brdiges handle differences between interconnects
7. device drivers
    1. per each device types
    2. responsible for device access, management, and control
    3. provided by device manufacturers per OS / verson
    4. each OS standardizes interfaces
8. types of devices
    1. block: disk
        1. read/write blocks of data
        2. direct access to arbitrary block of data
    2. character: keyboard
        1. get/put character
    3. network devices
        1. stream of data of different sizes
    4. OS representation of a device == special device file
9. quiz: i/o devices as files
10. quiz: pseudo devices
11. quiz: looking at /dev quiz
12. cpu device interactions
13. device access PIO
14. device access dma
15. quiz: DMA vs PIO
16. typical device access
17. OS bypass
18. sync vs. async access
19. block device stack
20. quiz: block device
21. virtual file system
22. virtual file system abstractions
23. VFS on disk
24. ext2 second extended filesystem
25. inodes
26. inodes with indirect pointers
27. quiz: inode
28. disk access optimizations
29. lesson summary
30. quiz: lesson review
