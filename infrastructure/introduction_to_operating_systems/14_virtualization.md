# Virtualization

1. lesson preview
2. what is virtualization
    1. virtualization allows concurrent execution of multiple OSs (and their applications) on the same physical machine
    2. virtual resources == each OS thinks that it "owns" hardware resources
    3. virtual machine (VM) == OS + applications + virtual resources (guest domain)
3. defining virtualization
    1. virtual machine is an efficient, isolated duplicate of the real machine
    2. when supported by VM
        1. provides environment essentially identical with the original machine
        2. programs that run in env only show minor decrease in speed
4. quiz: virtualization tech
5. benefits of virtualization
    1. consolidation: decrease cost, improve manageability
    2. migration: availability, reliability
    3. security, debugging, support for legacy OSs
6. quiz: benefits of virtualization 1
7. quiz: benefits of virtualization 2
8. virtualization models bare metal
    1. hypervisor-based, or type 1
    2. hypervisor manages all hardware resources and supports execution of VMs
    3. integrates privileges, service VM to deal with devices and other configuration and management tasks
9. virtualization models hosted
    1. type 2
    2. host owns all hardware
    3. special VMM (virtual machine monitor) module provides hardware interfaces to VMs and deals with VM context switching
10. quiz: bare metal or hosted
11. quiz: virtualization requirements
12. hardware protection levels
    1. commodity hardware has more than 2 protection levels
    2. xx86 has 4 protection levels, or rings
        1. ring 3: lowest privilege (apps)
        2. ring 0: highest privilege (OS)
13. processor virtualization
    1. guest instructions
        1. exxecuted directly by hardware
        2. for non-privileged oeprations: hardware speeds => efficiency
        3. for privileged operations: trap to hypervisor
    1. hypervisor determines what needs to be done
        1. if illegal op: terminate VM
        2. if legal op: emulate the behavior the guest OS was expecting from the hardware
14. x86 virtualization in the past
15. quiz: problematic instructions
16. binary translation
17. paravirtualization
18. quiz: BT and PV
19. memory virtualization full
20. memory virtualization paravirtualization
21. device virtualization
22. passthrough model
    1. appraoch: VMM-level driver configures device access permissions
        1. pros
            1. VM provided with exxclusive access to the device
            2. VM can directly access the device (VMM bypass)
        2. cons: device sharing difficult
23. hypervisor direct model
    1. approach
        1. VMM intercepts all device accesses
        2. emulate device opeartion
            1. translate to generic IO op
            2. traverse VMM-resident IO stack
            3. invoke VMM-resident driver
    1. pros
        1. VM decoupled from physical device
        2. sharing, migration, dealing with device specifics become simpler
    1. cons: latency of device operations, device driver ecosystem complexxities in hypervisor
24. split device driver model
    1. approach: device access control split between
        1. front end driver in guest VM (device API)
        2. back end driver in service VM (or host)
25. hardware virtualization
26. quiz: hardware virtualization
27. quiz: x86 VT resolution
28. lesson summary
29. quiz: lesson review
