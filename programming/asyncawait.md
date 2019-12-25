Since the advent of the new Architecture, APT has steadily grown its usage, understanding, and comfort with C#'s async/await feature. While at first such usage was largely limited to Architecture apps like Gateway and Auth, more recently some teams have been integrating asynchronous programming into product code to address challenges like waiting for long-running jobs. We recently released a new version of Apt.Core.Data which supports EF6's async queries, which has the potential to expand this usage further. Async/await can be a powerful tool for improving performance, but it can be detrimental if employed improperly. For this reason, we wanted to document and share some of the best practices around async/await that we've developed for work on Architecture in hopes that they will help us garner the benefits of this feature while avoiding its pitfalls.

Note that this post is not intended to be a tutorial on asynchronous programming or async/await. For those interested in learning more about these concepts, here are some resources:

This article does a great job of covering asynchronous programming in the context of an ASP.NET web app
This article provides a good overview of async as a language feature
This article shows how to create async controller actions in .NET MVC
This series of articles provides a detailed under-the-hood explanation of how the compiler processes async methods
The Architecture Team has and will continue to run a brown-bag on this topic, and we're always happy to chat with anyone who wants to discuss async/await. Async has also been featured in some of the C# puzzles.
Contents
When Async Matters
Async Best Practices
Follow Naming Conventions
Prefer to Await Immediately
Use ConfigureAwait(false) for All Awaits in Library Code
Use the Async Wrapper Pattern for Argument Validation in Library Code
Learn About Async
Avoid Writing Async Methods Inside Non-Async Entry Points
Avoid Parallelism
Avoid Task.Run()
Specify TransactionScopeAsyncFlowOption.Enabled for all usages of TransactionScope
Never Use "async void"
 
When Async Matters
Asynchronous code is not faster than synchronous code. What asynchronous code does is allow you to handle more load by processing more work (think jobs and/or requests) with the same amount of threads/memory. That means that async is helpful when threads and memory are the bottleneck. Thus, a job or controller method is a good candidate for async if it:

Runs frequently
Performs IO (e. g. HTTP requests, SQL queries)
Another way to think about it is that the total impact a request or job has on the thread pool is the product of the number of times it runs and the amount of time it spends waiting for IO. If this product is low, we likely won't see much benefit from introducing asynchrony.

Fundamentally, what async does is prevent your threads from sitting around waiting for IO-bound work to happen. Instead, those threads are free to go service other requests while the IO is running. This is useful because each thread takes up a non-trivial amount of memory. In addition, threads are expensive to create and destroy, so .NET will automatically maintain a pool of threads and keep re-using them. To avoid thrashing, .NET is rightly hesitant about creating new threads when more work is queued up on the thread pool. However, this can lead to work being delayed if all threads are consumed by waiting for IO operations. With async, we are rarely starved for threads so this hesitancy is unlikely to be a performance bottleneck. This allows applications to handle sudden increases in load smoothly.

However, a corollary to this is that going async doesn't matter unless we go async "all the way down". Imagine we have the following code:

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
    [Route("MyAction")]
    public ActionResult MyAction()
    {
        var content = this._toggleService.IsOn("AwesomeNewAsyncCode")
            ? this.GetContentAsync().Result
            : this.GetContent();
        return this.Content(content);
    }
 
    private async Task<string> GetContentAsync()
    {
        var session = await this._sessionService.GetCurrentSessionAsync().ConfigureAwait(false);
        using (var work = this._unitOfWorkFactory())
        {
            return session.User.Id + ":" + await work.DataContext.Table<Category>().Select(c => c.CategoryName).FirstAsync().ConfigureAwait(false);
        }
    }
 
    private string GetContent()
    {
        var session = this._sessionService.GetCurrentSession();
        using (var work = this._unitOfWorkFactory())
        {
            return session.User.Id + ":" + await work.DataContext.Table<Category>().Select(c => c.CategoryName).First();
        }
    }
}
In the synchronous branch, the request thread will block twice: once when fetching session and once when querying. This keeps it occupied for the whole request. In the async flow, our request thread will return from GetContentAsync as soon as it kicks off the first http request to get session! However, it then calls .Result on the returned Task, which means it ends up blocking until all of GetContentAsync is completed. What's worse is that, while our request thread is sitting there blocking, another thread has to do the CPU work in GetContentAsync (e. g. the string concatenation). Thus, because our code still blocks at the entry point (the action method), switching to async here adds overhead (the fix would be to make the action method itself async and await the Task returned by GetContentAsync). To get the benefit of async, there must be an uninterrupted (non-blocking) path of execution between the entry point and the actual async IO call.

Async Best Practices
These are practices we try to follow in our code. Like all practices, there are times when the right move is to ignore these guidelines. Nonetheless, we find them helpful.

Follow Naming Conventions
Microsoft recommends that any async method be named with the "Async" suffix. This is very helpful as it provides a clear indicator to the user that these methods must be awaited. We recommend following this practice, if for no other reason than it has seen widespread adoption in the .NET community.

Prefer to Await Immediately
Async methods return Task or Task<T>. It's possible to hold onto this task object and await it later. There are some cases where this is a useful technique. However, in the vast majority of cases awaiting the task immediately is preferred since it minimizes the chances of threading errors due to unintended parallelism or lost exceptions:

// possible, but not preferred
var readTask = work.DataContext.Table<Category>().FirstAsync();
...
// code in here runs in-parallel with the read. This just isn't worth it most of the time and
// can lead to real bugs. Furthermore, if we fail out here, we won't see the result of the read.
// This is even more problematic if we have an async write.
...
var firstCategory = await readTask;
 
// preferred
var firstCategory = await work.DataContext.Table<Category>().FirstAsync();
Use ConfigureAwait(false) for All Awaits in Library Code
ConfigureAwait(false) is necessary to prevent deadlocks if an async API is used both synchronously and asynchronously (for more on this, see this post). For this reason, any await statements in library code should include this statement. Await statements within web code can eschew this so long as the relevant code is always consumed asynchronously. Such code can use ConfigureAwait(false), but this will mean that HttpContext.Current and other web-specific thread state will not be available on the other side of the await statement. Our current general practices for web code are:

Awaits in controllers should not use ConfigureAwait(false)
Awaits in other web-tier classes should either consistently use or consistently not use ConfigureAwait(false)
Note that ConfigureAwait(false) is pointless outside of the context of an await. We should never see code like:

DoStuffAsync().ConfigureAwait(false).GetAwaiter().GetResult();
Use the Async Wrapper Pattern for Argument Validation in Library Code
It's a good practice to proactively validate arguments passed to public APIs in NuGet packages. Because of how async exception handling works, it's often better to wrap a public async API with a non-async method so that calling the API throws the validation exception directly rather than returning a faulted task. For more on this pattern see this post.

Learn About Async
Like most technologies, async code becomes easier use correctly, understand, and debug as you become more familiar with the underlying technologies and concepts. We recommend getting familiar with async before trying to use it to write production code. Hopefully, the resources linked in this blog can provide a starting point for anyone looking to read up on this feature.

Avoid Writing Async Methods Inside Non-Async Entry Points
As mentioned previously, there is no benefit to writing async code if the code isn't async "all the way down" it strictly adds overhead, so we should avoid writing such code.

Avoid Parallelism
Async can help enable parallelism within a request, but the biggest benefits of async are unrelated to this. Parallelism on a web server can be problematic since it introduces the potential for threading bugs and limits scalability by allowing one request to take up more resources. In many cases, our production web servers don't have enough CPU resources to get much benefit from parallelizing CPU-bound work. Perhaps most importantly, parallelism requires writing thread-safe code, which is notoriously difficult. Here's an example of the kind of subtle threading bug that can arise in perfectly-safe-looking multi-threaded code. For these reasons, we recommend introducing asynchrony without introducing parallelism.

In particular, look out for code that evaluates a lazy IEnumerable<Task<T>> as it is easy to write code that will execute these tasks in parallel. In particular, any code that evaluates the IEnumerable without awaiting each yielded task will introduce parallelism.

// has type IEnumerable<Task<int>>
var taskEnumerable = Enumerable.Range(1, 10).Select(id => AsyncMethodThatReturnsTaskInt(id));
  
// These all run the tasks in parallel: avoid this unless it is intentional
var resultEnumerable = await Task.WhenAll(taskEnumerable).ConfigureAwait(false);
await Task.WaitAll(taskEnumerable).ConfigureAwait(false);
var taskList = taskEnumerable.ToList();
var taskArray = taskEnumerable.ToArray();
  
// One way to make sure tasks are executed one at a time, sequentially
var resultList = new List<int>();
foreach(var task in taskEnumerable)
{
    var result = await task.ConfigureAwait(false);
    resultList.Add(result);
}
Avoid Task.Run()
Task.Run() is typically used to introduce parallelism, which we've already recommended against. Task.Run() is sometimes used for "fire and forget" logic as well. This is dangerous because Tasks created this way could be aborted without warning at any time due to application pool recycles. Web requests or jobs are alternative approaches to running asynchronous work which do not have this limitation. Another issue with this kind of approach is that it presumes that work running on background threads is free. In reality, taking up thread pool threads this way puts the same sort of load on the server that async/await is designed to avoid!

Finally, avoid code like this:

public async Task<int> DoStuffAsync()
{
    return Task.Run(() => InternalDoStuff());
}
Instead, it's better to let the caller control the threading behavior. For more on this anti-pattern see this post.

Specify TransactionScopeAsyncFlowOption.Enabled for all usages of TransactionScope
The TransactionScope class is a handy way for wrapping EF queries in a transaction and is used occasionally throughout the codebase for this purpose. By default, the ambient transaction scope is thread-local; a special TransactionScopeAsyncFlowOption.Enabled argument must be passed to make it flow with async continuations. As a general rule, if you are using TransactionScopes in the same codebase as async/await, always enable async flow (it's harmless if you don't go async). Note that this requires .NET 4.5.1 or greater.

For more about this, check out this post.

Never Use "async void"
Async void methods are permitted by the framework as a way of adapting from legacy .NET asynchronous programming patterns. Unless you somehow find yourself writing such an adapter layer, you should never use async void methods. In fact, ASP.NET takes some measures designed to explicitly block you if you accidentally use async void. Unlike the other guidelines in this section, we feel pretty confident that this rule should never be violated. For more on async void see this post.

Page viewed 821 times