API/Language Usage Issues
MC1001 Use Throw.If(Null) for ArgumentValidation
Throw.If throws ArgumentException and Throw.IfNull throws ArgumentNullException. Therefore, these methods should only be used for validating arguments. For other types of invariant-checking, consider Throw.InvalidIf() or Throw<TException>.If().

MC1002 Always pass both arguments to Throw.If
Unfortunately, Throw.If's second parameter (the parameter name / message) is optional. However, we should always supply it to ensure that error messages are readable.

MC1003 Do not construct dynamic error messages in a success case
A common problematic construct is:

Throw.If(condition, $"Something happened with {value}");
The reason this is problematic is that the error message is constructed every time, regardless of condition. In the best case, this makes performance a bit slower. In the worst case, this can lead to bugs when the error message construction actually fails in the success case. For example:

Throw.If(list.Count > 1, $"{nameof(list)} must have only one element, but found [{list[0]}, {list[1]}, ...]");
To work around this, either use a regular if (condition ) { throw } construct or use the overload of Throw<TException>.If that takes a lambda for the message:

// this is fine
Throw<ArgumentException>.If(list.Count > 1, () => $"{nameof(list)} must have only one element, but found [{list[0]}, {list[1]}, ...]");
Note that concatenating (not interpolating) string constants (consts, literals, and nameofs) happens at compile time, so this is fine:

// this is fine because all are CONSTANTS
Throw.If(!collection.Any(), nameof(collection) + ": may not be empty");
MC1004 Use TryGetValue to avoid redundant key lookups
In .NET, we can write faster and more concise code by avoiding double lookups in dictionaries:

// bad
if (dictionary.ContainsKey(key))
{
    DoStuff(dictionary[key]);
}
 
 
// good
if (dictionary.TryGetValue(key, out var value))
{
    DoStuff(value);
}
MC1005 Do not catch exceptions for control flow
try / catch blocks should only appear rarely in code, and should never be used for logical code flow except in the most desperate of circumstances. For example, we should not use exception handling to validate that an argument is invalid. Either the invalid argument should lead to an exception bubbling all the way up, or the argument should be validated directly. The problems with over-use of exception handling are primarily:

Exception handling almost always is set up to catch more errors than what is intended. As a result it can easily mask programmer errors (bugs) that result in thrown exceptions
Throwing and catching exceptions is many orders of magnitude slower than other control flow methods, like if-statements
// bad
try { return ComputeThing(arg); }
catch (Exception ex) { return null; }
 
 
// good
return IsValid(arg) ? ComputeThing(arg) : null;
There are valid cases for catching exceptions, but all are fairly uncommon:

Top-level catch block in a system that logs errors rather than letting them crash the program
Catching an exception and re-throwing it wrapped in another exception that provides more context
Catching a specific exception type from a 3rd-party API that only communicates certain problems through exceptions (e. g. there is no MailAddress.TryParse, so the only way to validate an email address is to catch the FormatException thrown by MailAddress's constructor).
MC1006 Prefer the Count/Length properties over the Count() extension method where available
All IEnumerables can leverage the Count() extension method, which will be either O(1) or O(N) depending on the specific type of IEnumerable. Collections (e. g. implementers of ICollection<T> or IReadOnlyCollection<T>) implement a Count property which will pretty much always be O(1). Similarly, arrays have a Length property.

For readability and conciseness, use the property when available. This clearly communicates to the reader that no work is being done, whereas calling .Count() requires the reader to go back and figure out what the runtime type of the enumerable will be to understand the implications.

int[] a = new[] { 1, 2, 3 };
List<int> b = new List<int> { 1, 2, 3 };
IEnumerable<int> c = Enumerable.Range(1, 3);
 
 
// bad
a.Count();
b.Count();
 
 
// good
a.Length
b.Count
c.Count()
MC1007 Do not conflate null with empty
When dealing with collections (or strings which can be considered collections of characters), it is important to maintain a clear distinction between null and empty. In many real cases, there is no meaningful distinction in which case empty should generally be preferred.

An example of a case where a distinction could be needed would be assigning task lists to workers, since in this case we may want to distinguish between workers who have explicitly been assigned no work (empty list) vs. workers who have yet to receive an assignment.

Another common example is a string value which is expected to have a certain format (e. g. JSON). In this case, you would use null to indicate the absence of a value, whereas empty should be treated just like any other malformed value (e. g. for JSON the strings " " or "a" are also malformed).

Avoiding conflation between null and empty greatly simplifies downstream code by making it clear when null checks are required.

MC1008 Leading/trailing .* in regex are often unnecessary
In regex, a string is considered to match the regex if it contains the pattern. Because of this, a regex should not have leading or trailing .* unless it is important that this segment be included in the captured value. In fact, having these in place makes the regex engine run slowly (much more slowly in the case of leading .*).

// bad
Regex.IsMatch(input, @".*apple);
Regex.IsMatch(input, @"apple.*);
 
 
// ok
var appleToTheEnd = Regex.Match(input, @"apple.*").Value;
MC1009 Release notes should be consumer-facing
The idea of "release notes", whether for a library or other contexts, is to convey what changed to the consumer. Therefore, the content of release notes should be fully-consumer facing and should not include irrelevant internal details. Release notes are not commit messages!

// bad
Refactored internals of DataContextFactory
 
 
// good
Improved handling of XYZ in DataContextFactory API
MC1010 Use the Path API to manipulate file and directory paths
.NET provides the System.IO.Path API which provides robust utilities for working with paths. Use this API where possible instead of raw string manipulation to manipulate file paths. Some of the most common operations:

Path.GetDirectoryName(path) // c:\dev\foo\bar.js => c:\dev\foo, also works for getting the parent of a directory
Path.GetFileName(path) // c:\dev\foo\bar.js => bar.js
Path.GetFileNameWithoutExtension(path) // c:\dev\foo\bar.js => bar
Path.GetExtension(path) // c:\dev\foo\bar.js => .js
Path.Combine(path1, path2, ...) // c:\dev, foo, bar.js => c\dev\foo\bar.js
A few notes:

These APIs work for relative and absolute paths
Path.Combine is not the same as just concatenating paths and adding \ separators as needed. It's actually doing relative path semantics. So combining a\b and \c gives \c, not a\b\c
MC1011 Make static classes static
C# provides the ability to create a "static" class which cannot be instantiated. This should be used for any class which has only static methods since it helps readers understand the content of the class and ensures that consumers use it correctly.

// bad (allows new StringHelper())
class StringHelper
{
    public static string Reverse(string text) { ... }
}
 
 
// good
static class StringHelper
{
    public static string Reverse(string text) { ... }  
}


MC1012 Take in read-only collections interfaces where possible
When a method or constructor takes in a collection, it generally will not modify that collection. You can and should communicate this to the caller by taking in a read-only collections interface such as IReadOnlyCollection<T>, IReadOnlyDictionary<K, V>, IReadOnlyList<T>, or IEnumerable<T> in .NET or ReadonlyArray<T> or ReadonlyMap<K, V> in TypeScript. Taking in a read-only type also makes your method easier to call since consumers who have a read-only collection type can still use it.

The IEnumerable<T> type is the most generic collection type which makes it great for this. However, if your method is immediately going to materialize the enumerable (e. g. by calling ToArray()) to avoid multiple enumeration then you should consider whether taking in a materialized type like IReadOnlyCollection<T> would be more appropriate (since it avoids the extra copy). There isn't an obvious answer here: public APIs will probably prefer IEnumerable<T> in most cases, while internal APIs might go either way depending on how they expect to be called.

For more, see: https://confluence.predictivetechnologies.com/x/fCGhB

MC1013 Avoid a.Equals(b) in .NET
.NET provides the Equals(object) method which you can override on a type to implement custom equality. However, when testing two objects for equality this is not the best option because a.Equals(b) will fail if a is null. This makes the code harder to verify because equality is expected to be a commutative operator and yet a.Equals(b) is non-commutative because "x".Equals(null) returns false and null.Equals("x") throws an exception:

// bad
a.Equals(b)
 
 
// good
a == b // only for types which override ==, namely most built-in simple types like primitives, DateTime, and string
Equals(a, b)
EqualityComparer<T>.Default.Equals(a, b) // faster for value types and also let's the compiler verify that a and b have the same static type
The one main case where you would use a.Equals(b) is when comparing two ValueTuples. ValueTuples don't support == (yet) and since they are value types they don't suffer from the null issue. When we move to C# 8 and have non-nullable reference types, then we should use a.Equals(b) for non-nullable types and Equals(a, b) for nullable types.

MC1014 Use built-in APIs for case-insensitive comparison
When comparing strings case-insensitively, a common mistake is to use ToLower() or similar on both strings before comparing. Not only is this slow (since it may construct up to two new strings), but in some cases it actually gives the wrong result. In most languages, you can dodge these issues simply by using provided APIs for this purpose.

// worst (culture-sensitive, additional allocations)
a?.ToLower() == b?.ToLower()
a?.ToUpper() == b?.ToUpper()
 
 
// bad (using the invariant culture will fix some issues)
a?.ToLowerInvariant() == b?.ToLowerInvariant()
 
 
// better (see https://docs.microsoft.com/en-us/visualstudio/code-quality/ca1308-normalize-strings-to-uppercase?view=vs-2017)
a?.ToUpperInvariant() == b?.ToUpperInvariant()
 
 
// best (fully correct result, no additional allocations)
StringComparer.OrdinalIgnoreCase.Equals(a, b)
In some application contexts (e. g. processing user text), you may actually want to use culture-specific comparisons. In this case, use StringComparer.CurrentCultureIgnoreCase.

Sometimes, you need to do a case-insensitive operation which is not an equality check. Luckily, .NET has overloads of most string APIs which take in a StringComparison enum:

a.StartsWith(b, StringComparison.OrdinalIgnoreCase)
a.EndsWith(b, StringComparison.OrdinalIgnoreCase)
a.IndexOf(b, StringComparison.OrdinalIgnoreCase)
Regex.IsMatch(input, pattern, RegexOptions.IgnoreCase)
...
MC1015 Use ConfigureAwait(false) for awaits when appropriate
ConfigureAwait(false) is generally only necessary in contexts when someone might be calling .Result/.Wait() on the returned Task instead of awaiting it in a project with a single-threaded synchronization context. This is always a possibility in library code, since you don't know who your ultimate caller will be. In Web or desktop GUI projects, such a synchronization context does exist and thus you do have to consider this case. However, in those projects there are also cases (e. g. controllers) where you don't want ConfigureAwait(false) because you want to take advantage of the single-threaded resource on both sides of the await (in web projects this is the HTTP context). In summary:

In library code, always ConfigureAwait(false)
In Web (or desktop GUI) code, decide on a convention with your team (e. g. never use it and never do .Result, or always use it outside controllers and only touch HttpContext in controllers).
In other contexts (e. g. Tests, Console Apps, LinqPad scripts), do not ConfigureAwait(false)
See Async/Await Usage Recommendations for more information.

MC1016 Prefer to return concrete collection types when transferring object ownership
When writing a function that returns a collection type, it can be hard to know whether to return a read-only interface type or a concrete (and typically mutable) type. In most cases, the function in question is transferring ownership of the returned object to the caller. In other words, no one else is holding onto the object. An example of where ownership is not transferred is if the function returning the collection is also holding onto it as a cache for future calls.

When transferring ownership, it is preferable to return a simple concrete collection type like List<T> or Dictionary<K, V> in .NET or T[] in TypeScript. This allows the consumer to take full advantage of the collection's capabilities without having to "jailbreak" their object. It also gives the caller confidence that they now have ownership of the object (important if they want to cache it, for example). Examples from the framework that illustrate this are ToList(), ToArray(), and ToDictionary() in Linq.

Obviously, there are exceptions:

You are writing a function where the concrete returned type is unusual (e. g. Dictionary<string, string>.KeyCollection)
You are writing a performance-critical library API and you think you may want to change the underlying type or stop transferring ownership in the future
MC1017 Use named capture groups for Regex
In regular expressions, you can access not only the value of a match but also the value of any part of the match surrounded by parentheses. These pieces of the overall pattern are known as "capture groups" and each time they match it is known as a "capture". In .NET, you can access the value of capturing groups either by the index of the group or by the name of the group (if a name is specified). Using the name is greatly preferred because it makes the code more readable and much less sensitive to small changes in the pattern.

// bad
Regex.Match(url, @"(http(s?))://").Groups[1].Value
 
 
// good
Regex.Match(url, @"(?<protocol>http(s?))://").Groups["protocol"].Value
For more, see https://docs.microsoft.com/en-us/dotnet/standard/base-types/grouping-constructs-in-regular-expressions#named_matched_subexpression

MC1018 Use type-safe casts when possible
There are two types of casts in statically-typed languages: "upcasts" are casting an object to its base type. Such casts are guaranteed to succeed. In contrast, "downcasts" attempt to convert an object to a more specific derived type. Such casts may fail at runtime: the compiler cannot guarantee success. In practice, downcasts are needed much more commonly than upcasts, because most of the time due to polymorphism you can simply use an object as its base type. However, upcasts are somtimes needed, for instance to access an explicitly-implemented interface in C# or to infer a specific type for an outer expression. In upcast scenarios, you can make your code more readable by clearly differentiating the safe upcast from the unsafe downcast:

// bad: looks like downcast
var baseObject = (Base)derivedObject;
 
 
// good
Base baseObject = derivedObject;
 
 
// good (using Apt.Core)
var baseObject = derivedObject.As<Base>();
MC1019 Examine the return value of "Try" methods in .NET
A common .NET idiom is for a method to return a bool indicating success and also out a value which is only well-defined in the success (or error) case. Callers should examine the returned bool rather than making assumptions about what the out variable will be set to in the undefined case.

// bad (this assumes that value will be null if the key isn't present, and is outright broken when the key is present but the value is null)
dictionary.TryGetValue(key, out var value);
if (value != null)
{
    DoSomething(value);
}
 
 
// good
if (dictionary.TryGetValue(key, out var value))
{
    DoSomething(value);
}
MC1020 Use "strongly typed" doc comments where possible
.NET doc comments allow for "strongly typed" references to members and parameters. This is useful because it allows for smart linking in intellisense and also ensures that the comment gets updated if the referenced member is renamed.

// bad
 
 
/// <summary>
/// Created a Foo with length bar.
/// </summary>
Foo Create(int bar);
 
 
// good
 
 
/// <summary>
/// Created a <see cref="Foo"/> with length <paramref name="bar"/>.
/// </summary>
Foo Create(int bar);
MC1021 Use strong types where possible
When a type is available to represent the specific concept we are working with, we should use that type. For example, use types like DateTime (Date in JS), TimeSpan and Guid rather than strings or numbers to represent those concepts. This has several advantages:

Makes the code more robust by ensuring that the values being used are valid ones for the particular concept (e. g. "hello" is not a valid GUID) and allowing the compiler to detect more issues
Makes the code more readable
Minimizes issues with units (is this int in seconds or milliseconds?)
Often helps performance by avoiding repeated parsing
Note that there are some cases where you will have to use a more weakly-typed representation, for example during some types of serialization. This is fine: the goal is just to spend as little time as possible with the data weakly-typed. When forced to use weak typing, use naming to convey type information.

// bad
void Sleep(int time);
 
 
// better, but still bad
void Sleep(int timeMilliseconds)
 
 
// good
void Sleep(TimeSpan time);
MC1022 Use visibility modifiers in the context of declaring members
In C#, a member's visibility is determined not only by it's visibility modifier (e. g. "internal") but also by the visibility of the member that declares it. For example, a public method in an internal class is effectively internal. Given this, choose member visibilities to communicate the maximum amount of information to readers. For example:

Public method in public type: public API
Public method in internal type: internal API
Internal method in public type: likely exposed for "friend access" within the library, also could be exposed for testing access. Use with caution, and consider naming to disambiguate (e. g. "InternalXXX" for exposed-to-testing methods)
Internal method in internal type: likely exposed as internal rather than private for testing; should not be used by other types
MC1023 Prefer concrete collection types over mutable collection interfaces unless there is a good reason to use the interface
C# exposes both IList<T> and List<T> as well as IDictionary<T> and Dictionary<T>. It may seem like a good idea to use the interface to "abstract away" the implementation when working with collection types. However, in almost all cases uses the concrete type is preferred. Here's why:

Concrete types can be passed to functions requiring any of the mutable interface, the read-only interface, and the concrete type, while the mutable interface can be used only with functions accepting the mutable interface.
The concrete types have additional methods that the interfaces lack, since interfaces cannot be added to backwards-compatibly and since MSFT wants the interfaces to be implementable by third parties. These methods can be useful.
For lists, there is no compelling alternative algorithm. For dictionaries, the alternative (SortedDictionary) has uses, but in those cases you'll typically want consumers to know that the dictionary has the sorted property.
Knowing the specific type makes it easier to reason about the program's behavior.
Calls through interfaces are marginally slower
// bad
class Foo { public IDictionary<string, object> Values { get; set; } }
 
 
// good
class Foo { public Dictionary<string, object> Values { get; set; } }
Some good reasons to use the mutable interface:

You have a use-case where you actually are leveraging interface polymorphism.
In a library, you have a custom implementation of the interface but you do not want to expose it as public. For example, you might have a custom IList<T> implementation that rejects nulls.
In a library, you are writing a general-purpose utility method that works on any collection supporting the interface.
MC1024 Release notes should be consumer facing
Release notes are intended to inform consumers about what has changed between versions of a library. Therefore, they should be written from the perspective of a consumer and not from the perspective of a library owner.

// bad
1.2.3 Error throttling in InternalQueryTimeoutHandler, refactored to use C# 7 features
 
 
// good
1.2.3 Improved error handling so that SQL query timeout conditions will not result in a huge volume of reported errors (APT-12345)
MC1025 Use assertive casts unless you expect and handle the cast failure case
C# offers two types of casts. (TypeName)expression will throw InvalidCastException if the cast does not succeed. expression as TypeName will return null if the cast does not succeed. Code should always use the exception-throwing version unless it expects failure and handles that failure. Otherwise, we defer bugs and make them harder to diagnose:

Code example Expand source


Style Issues
MC2001 Put all parameters on one line or each on its own line
This also goes for collection literals.

// bad
DoStuff(a,
    b);
DoStuff(aaaaaaa
   .bbb());
 
// good
DoStuff(a, b);
DoStuff(
    a,
    b
);
DoStuff(
    aaaaaaa
        .bbbb()
);
 
// bad
new[] { a,
   b };
 
 
// good
new[] { a, b }
new[]
{
    a,
    b
}
Following this consistently improves readability

MC2002 Remove TODO comments from code destined for master
I do not believe that TODO comments add value once code reaches master. Such comments are rarely cleaned up after the fact. They are often out-of-date, and they leave the reader concerned as to the code's quality. If there are issues worth fixing, we should fix them. If there are potential areas for improvement that we do not want to undertake, then we should file issues for those and in some cases note them in the comments (still it's not TODO since we might never do it).

MC2003 Provide parameter names for literal arguments
Code like the following is very difficult to read:

CreateCustomer("Mike", false); // can't tell what false means here...
Better would be to do:

CreateCustomer("Mike", isGold: false);
In general, any argument being passed true, false, null, undefined, or in some cases a number should probably include a parameter name annotation to clarify. An exception is if the value's meaning is obvious from context:

var list = new List<bool>();
list.Add(true); // ok; list.Add(item: true) is not any clearer
MC2004 "BusinessLogic" should not appear in namespaces
At APT, we have a convention of creating a BusinessLogic folder to help separate out the logical guts of a project from scaffolding and other project-specific foldering conventions (e. g. Scripts in Web projects). However, this is merely a form of physical organization and thus should not appear in the logical hierarchy represented by namespaces.

MC2005 Minimize re-assignment
Local variables in C# can be re-assigned, but minimizing this can help produce more readable and verifiable code. A particularly common case where this comes up is initializing something which may be a default value or some other value:

// bad
var value = someDefault;
if (condition) { value = ... }
 
 
// good
string value;
if (condition) { value = ... }
else { value = someDefault; }
 
 
// best (but won't fit all situations)
var value = condition ? ... : someDefault;
Here, one reason to avoid re-assignment is that it allows the compiler to verify for us that value is assigned on all paths. For example, if we were to add another else if condition and forgot to assign value in it, then the "bad" code above would compile but the "good" code would not. 

Another reason to avoid re-assignment is that it makes the code easier to reason about and understand without digging through every line.

MC2006 Use the "Async" suffix for most .NET async methods
.NET convention is to use the "Async" suffix when naming methods that return Task. Following this convention means that our code matches the idioms of the framework, improves readability, and helps detect bugs.

// bad
async Task DoStuff() { ... await ... }
 
 
// good
async Task DoStuffAsync() { ... await ... }
 
 
// helps catch bugs
Log.Current.Info("result", data: GetResult()); // lack of naming convention hides the fact we are logging a Task here, not the result
Log.Current.Info("result": data: GetResultAsync()); // immediate flag that await is missing
The one very rare exception to this rule is when you are writing a method where the name is more about the Task instance you are creating than it is about the asynchronous operation you are performing. Examples from the framework include Task.Run(), Task.Delay(), and Task.WhenAll().

MC2007 Start single-line comments with a space
Style single-line comments so as to clearly differentiate them from commented out code. This also makes the comment text more readable generally.

// bad
 
 
//this is commented-out code
 
 
// good
 
 
// this is a comment
MC2008 Prefer paramref to param tags in doc comments
C# doc comments allow each parameter to be documented in it's own param tag. Unfortunately, this frequently leads to noisy, low-value comments for those parameters. Furthermore, the parameters aren't as visible in intellisense as the summary is. While param tags can sometimes be useful (do you have something interesting to say about EACH parameter?), most of the time the documentation ends up cleaner by dropping param / return tags and instead documenting behavior in the summary.

// bad
 
 
/// <summary>
/// Performs exponentiation
/// </summary>
/// <param name="base">the base</param>
/// <param name="exponent">the exponent</param>
static double Pow(double @base, double exponent);
 
 
// good
 
 
/// <summary>
/// Computes <paramref name="base" /> raised to the <paramref name="exponent" /> power
/// </summary>
static double Pow(double @base, double exponent);
MC2009 Exclude "BusinessLogic" from namespaces
Many of our .NET apps have a "BusinessLogic" folder at the top level. The purpose of this folder is to avoid having too many top-level files (makes for easier navigation) while also providing a clear home for the core application logic files (things that aren't assets, views, controllers, etc). However, there is no need to namespace these classes with "BusinessLogic"; that just adds another set of required imports and makes files more verbose.

To have R# warn about this and suggest a fix, right click on the folder in solution explorer and select "Properties". In the properties pane, set "Namespace Provider" to false.

// good
namespace Apt.Platform.MyApp
 
 
// bad
namespace Apt.Platform.MyApp.BusinessLogic


Common Bugs
MC3001 File paths are case-insensitive
In windows, file and directory names are case-insensitive, so robust code should assume this.

MC3002 Handle newline characters correctly
On windows, newlines are \r\n rather than just \n. So, when writing newline characters in C# it's best to use Environment.NewLine or one of the built-in WriteLine/AppendLine methods (these should all return \n on Mac/Linux). 

When reading/parsing text, it is best to be forgiving and accept either \r\n or \n. Built-in methods like TextReader.ReadLine() will do this for you. When splitting on new line, use something like:

text.Split('\n').Select(l => l.TrimEnd('\r'));
MC3003 rethrow exceptions correctly
In C#, throwing a connection with a "throw ex;" statement causes the exception's stack trace to be set as starting from the throw statement. When re-throwing an exception, this is undesirable since it loses any existing stack context for the exception. Alternatives exist that do not have this flaw.

// bad
try { DoStuff(); }
catch (Exception ex)
{
   SomeLogic();
   throw ex; // loses stack context from within DoStuff()
}
 
 
// good (only works in catch blocks)
try { DoStuff(); }
catch (Exception ex)
{
   SomeLogic();
   throw;
}
 
 
// good (changes exception type)
try { DoStuff(); }
catch (Exception ex)
{
   SomeLogic();
   throw new SomeOtherExceptionType("message", ex);
}
 
// good (most useful outside of catch blocks)
ExceptionDispatchInfo.Capture(ex).Throw();
MC3004 Do not validate attribute parameters at construction-time in library code
For an arbitrary .NET class, it is good practice to validate constructor parameters in the constructor and property values in the setter so that the code fails as quickly as possible.

However, this practice is problematic when authoring attributes that will be shipped in NuGet packages. 

The reason is that attributes are constructed and have there processes set as part of reflecting over the attribute. Because of this, an attribute that "fails fast" can actually fail too fast and get in the way of someone trying to do something unrelated. For example, when NUnit is spinning up a test project it will reflect over all class and method attributes in the assembly in order to discover test cases. If your unrelated attribute throws an exception during this step, it can lead to the entire NUnit spinup process failing!

Obviously, we still want to provide some form of validation for attribute parameters and properties. The easiest way to safely provide this is to put it where the values are used:

Code example Expand source
MC3005 Prefer CultureInfo.GetCultureInfo over new CultureInfo()
When getting a CultureInfo object from a culture name, the GetCultureInfo function is preferred in most cases because it returns a cached, read-only version of the culture object.

Code example Expand source
MC3006 Minimize the scope of try-catch constructs
A common bug is to have too many lines of code inside a try-catch, when in fact only one or a handful of those lines are expected to result in exceptions. This can lead to exceptions that are due to programmer bugs rather than exceptional circumstances being caught and swallowed. This can be fixed by moving most code out of the try block. Additionally, limiting what exceptions can be caught may be helpful.

// bad
try
{
   CodeThatShouldNotFail();
   CodeThatMightFail();
}
catch (Exception ex)
{
    Log.Current.Error(ex);
}
 
 
// good
CodeThatShouldNotFail();
try
{
   CodeThatMightFail();
}
catch (Exception ex)
{
    Log.Current.Error(ex);
}