# Threads Case Study: PThreads

1. lesson preview
    1. pthreads = POSIX threads, or "protable operating system interface" threads
2. pthread creation
    1. have an id, executation state, other info necessary for thread
    2. `pthread_create()`, takes in an attribute type, returns a thread and status informaiton on whether thread creation was successful
    3. pthread_join(pthread_t thread, void \*\*status)
    4. pthread attributes, pthread_attr_t
        1. specified in pthread_create
        2. defines features of the new thread - stack size, joinable, priority, inheritance, scheduling policy, system/process scope
    5. detaching pthreads
        1. default: joinable threads. parent htread creates children threads and can join them at a later time. if parent exits early, children "turn into zombies".
        2. in pthreads, children can be "detached", where they continue without parent input.
3. compiling pthreads
4. pthread creation example 1
5. quiz: pthread creation example 1
6. pthread creation example 2
7. quiz: pthread creation example 2
8. pthread creation example 3
9. quiz: pthread creation example 3
10. pthread mutexes
    1. "to solve the mutual exclusion problems among concurrent threads"
    2. access shared state in a controlled manner
    3. pthread_mutex_t // mutex type
    4. mutex safety tips
        1. shared data should always be accessed through a single mutex
        2. mutex scope must be visible to all
        3. globally order locks
            1. for all threads, lock mutexes in order (to prevent deadlocks)
        4. always unlock a mutex. always unlock the correct mutex.
11. pthread condition variables
    1. birrell's mechanisms:
        1. condition: pthread_cond_t aCond;
        2. wait: pthread_cond_wait(pthread_cond_t *cond, pthread_mutex_t *mutex)
        3. signal: int pthread_cond_signal(pthread_cond_t \*cond);
        4. broadcast: int pthraed_cond_broadcast(pthread_cond_t \*cond
    1. condition variable safety tips
        1. do not forget to notify waiting threads
            1. predicate change => signal/broadcast correct condition variable
        2. when in doubt, use broadcast
            1. realize there will be performance loss
        3. you do not need a mutex to signal / broadcast
12. producer and consumer example part 1
13. producer and consumer example part 2
14. producer and consumer example part 3
15. lesson summary
16. quiz: lesson review
