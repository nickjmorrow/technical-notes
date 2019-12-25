# Remote Procedure Calls

1. lesson preview
2. why RPC?
3. benefits of RPC
    1. simplify the development of cross-machine interactions
    2. high-level interafce for data movement and communication
    3. capture error handling
    4. hiding complexities of cross-machine interactions
4. RPC requirements
    1. client/server interactions
    2. procedure call interface
    3. type checking
    4. cross-machine conversion
    5. higher-level protocol
        1. access control, fault tolerance, different transport protocols
5. structure of rpc
6. steps in rpc
    1. bind: client finds and "binds" to desired server
    2. call: client makes RPC call; control passed to stub, client code blocks
    3. marshal: client stub "marshals" arguments (serialize args into buffer)
    4. send: client sends message to server
    5. receive: server receives messages; passes message to server-stub; access control
    6. unmarshal: server stun "unmarshals" arguments (exxtracts arguments + creates data structures)
    7. actual call: server stub calls local proecure implementaiton
    8. result: server performs operation and ocmputes result of RPC operation
7. interface definition language (IDL)
    1. what can the server do?
    2. what arguments are needed for the various operations?
    3. client-side bind decision
8. specifying an IDL
9. marshalling
10. unmarshalling
11. binding and registry
12. visual metaphor
13. pointers in RPCs
14. handling partial failures
15. quiz: rpc failure
16. rpc design choice summary
    1. binding => how to find the server
    2. IDL => how to talk to the server, how to package data
    3. pointers as arugments => disallow or serialize pointed data
    4. partial failures => special error notifications
17. what is SunRPC?
18. SunRPC overview
19. SunRPC XDR example
20. compiling XDR
21. summarizing XDR compilation
22. quiz: square.x return type
23. SunRPC registry
24. SunRPC binding
25. XDR data types
26. quiz: XDR data types
27. XDR routines
28. encoding
29. XDR encoding
30. quiz: XDR encoding
31. java RMI
32. lesson summary
33. quiz: lesson review
