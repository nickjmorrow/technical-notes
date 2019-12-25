# Midterm Questions

1. Process Creation: How is a new process created?

A: fork starts a new process which is a copy of the one that calls it, while exec replaces the current process image with another (different) one.

2. Is there a benefit of multithreading on 1 CPU?

A: The main reason is to hide the latency associated with code that blocks processing (such as a disk I/O request).

3. If the kernel cannot see user-level signal masks, then how is a signal delivered to a user-level thread (where the signal can be handled)?

A: Recall that all signals are intercepted by a user-level threading library handler, and the user-level threading library installs a handler. This handler determines which user-level thread, if any, the signal be delivered to, and then it takes the appropriate steps to deliver the signal.

Note: If all user-level threads have the signal mask disabled and the kernel-level signal mask is updated, then and the signal remains pending to the process.
