# Concurrency and Parallelism

[A gentle introduction to multithreading](https://getpocket.com/redirect?url=https%3A%2F%2Fwww.internalpointers.com%2Fpost%2Fgentle-introduction-multithreading)

TODO: Read^

[Overview of modern concurrency and parallelism concepts](https://nikgrozev.com/2015/07/14/overview-of-modern-concurrency-and-parallelism-concepts/)

## Concurrency vs Parallelism

- Concurrency is about composing independent processes. It is about the design and structure of the application.
- Parallelism is about actually executing multiple processes simultaneously. It is the actual execution.

## Processes and Threads

- Process is an instance of a program being executed
- Processes are isolated from each other
- Threads are lightweight processes
- Each thread in a process has its own stack
- All threads within a process share the same address space, so they can communicate more easily
- Access to shared variables is difficult / must be heavily monitored

## Green Threads

- JVM could not map its threads to OS threads, so they needed ot emulate threads. Enter green threads.
- Run in user space, are shceduled by library of VM.
- OS cannot schedule tem on multiple cores simultaneously.
- Green threads are a concurrency concept, but not a parallel one.
- Java has abandoned green threads in favor of mapping to native OS threads.

## Protothreads

- Stackless threads
- Abstraction for event-driven programming, rather than a true parallelism enabler

## Fibers

- Fibers are lightweight threads
- Cannot be forcefully pre-empted by the OS kernel
- Fiber must voluntarily yield its execution to allow another one to run
- Do not have their own stacks
- Have smaller stacks stored and managed in user space
- Are a concurrency concept, but are not truly paralle
- Need stack to be restored before execution and continue
- Multiple fibers from the same thread cannot run simultaneously
- Shorter-lived in comparison to threads

## Generators, or Semicoroutines

- State is restored and the execution continues from the point of the last yielding until a new yield is encountered
- Subroutines can be thought of as generators which never yield
- Very similar to fibeers. Both run uninterrupted until it voluntarily yields.

## Coroutines

- Can specify a parameter to pass into a generator
- With subroutines (functions), you can divide program into subparts which execute in completion one after another
- With coroutines, you can divide it into prats whose lifecycles may overlap and exchange messages by yielding to each other

## Goroutines

summary: "language manages concurrency, so less pitfalls w.r.t. expensive and naive thread management"

- Threading and concurrency is managed by go runtime
- Creating a goroutine != creatign a thread. Go combines independent coroutines onto a set of threads. \* Upon blocking, coroutines are moved onto a different thread
- Coroutines which can run in parallel
- Go runtime maintains an internal pool of native OS threads
- Each goroutine is assigned to a thread from this pool which executes its logic
- Once a goroutine blocks, the runtime can use its thread for another goroutine
- When a routine resumes, no guarantee to be on same thread
- Go has a segmented stack that grows as needed, whereas threads have a fixed, large stack size. They are "green", so the Go runtime allocates them to OS threads, not the OS itself.
- Goroutines communicate with each other via channels, similar to how coroutines communicate by yielding values to each other \* With channels, only one goroutine has access to the data ay any given time
- Don't communicate by sharing memory, share memory by communicating \* If two goroutines need to share data, they can do so safely over a channel

## Nodejs

summary: "use callback / event loop to mimic concurrency without needing to actually rely on OS to expensively provide concurrency"

- Callback, event-driven
- Non-blocking IO
- Instead of relying on threads for concurrency, we have only one thread coordinating asynchronous work through an event loop
- "dealing with multiple threads is misleaing for devs, results in higher CPU and memory"

## Critique

- I wish I could see a lightweight program implementing all the different async styles and see the pros/cons of each
