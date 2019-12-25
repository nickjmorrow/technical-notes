# Typescript vs Go

https://medium.com/@amit.bezalel/micro-service-languages-typescript-vs-go-d97a8e70b000

Although TS is single-thread, it's actually more parallel than Java when working with IO, ince all IO tasks are handled by IO threads in the OS, your ocde is only resp for facilitating the needded conns and dispatching tasks to disk or network operations. You do need to avoid any CPU bound ops in your code, so image processing / heavy data restructuring should be done in other processes.

"it requires you to install NodeJS on the target machine, can’t hold CPU intensive tasks, and is completely open on disk, this means that it is optimal for most cloud-native apps use cases, but for some special micro-services and for most client installed components it may not be the best solution."

Go

- Go is a modern compiled lnaguage. Compilation is very fast.
- Built-in parallel framewokr, modeled as a pipeline flow nework. Model includes gorups of same-code parallel workers (go routines) that are interconnected by producer-consumer queues (channels) and is very similar to C# TPL DataFlow. It hides all the internal workings of threads including thread pooling and all thread-per-core dilemmas with some fancy heuristics.
- less object-oriented than current languages (not bad, just different)
- No real NPM for Go yet - find people's packages on their gits

![](2019-04-10-09-48-18.png)

"both languages are cross-platform, fast to compile and have a vibrant community, however, they are different in their orientation. One may even say they are complimentary, so by using NodeTS for most of your services you can gear up fast, and have access to all the npm modules, easy JSON parsing and loose typing that makes server writing extremely easy, and by using Go for implementing client side distributable components, image thumbnailing, video encoding, and all complex data conversions you can create a system that is best suited for the job. All of which is enabled by The polyglot environment created by using the micro-services architecture."
