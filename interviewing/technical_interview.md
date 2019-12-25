# Technical Interview

TODO:

- Clean this document up and move out information that isn't related to technical interviews
- Build a "framework" for solving technical problems during an interview (e.g. first ensure understanding, then write the question down, then write base cases)
- Link to a list of questions I can ask the interviewer afterwards

[Coding interviews for dummies](https://medium.freecodecamp.org/coding-interviews-for-dummies-5e048933b82b)

Do around 100 to 200 LeetCode questions, and you should be good.

questions to ask about the quetsion:

- How big is the size of the input?
- How big is the range of values?
- What kind of values are there? Are there negative numbers? Floating points? Will there be empty inputs?
- Are there duplicates within the input?
- What are some extreme cases of the input?
- How is the input stored? If you are given a dictionary of words, is it a list of strings or a trie?

Ask to start coding - focus heavily on psuedocode, design, and validating with the interviewer.

Don't announce you're done - look for optimizations and testing.

Come up with test cases. Start small. Step through the actual code.

It is also common that the interviewer asks you extension questions, such as how you would handle the problem if the whole input is too large to fit into memory, or if the input arrives as a stream. This is a common follow-up question at Google, where they care a lot about scale. The answer is usually a divide-and-conquer approach — perform distributed processing of the data and only read certain chunks of the input from disk into memory, write the output back to disk and combine them later.

A great resource for preparing for coding interviews is interviewing.io

Some of the questions are only available with a paid subscription to LeetCode, which in my opinion is absolutely worth the money if it lands you a job.

Always validate inputs first. Check with interviewer whether you can assume a valid input.

Jot down the time and space complexity for parts of the algorithm.

Check for off-by-one errors.

Use pure functions as much as possible.

Avoid mutating parameters passed into function, especially if they are passed by reference.

Data structures can be augmented to achieve efficient time complexity across different operations. For example, a HashMap can be used together with a doubly-linked list to achieve O(1) time complexity for both the get and put operation in an LRU cache.
