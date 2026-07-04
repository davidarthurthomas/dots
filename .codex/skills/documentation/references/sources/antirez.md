# Source material: Salvatore Sanfilippo (antirez), "Writing system software: code comments"

From antirez.com/news/124, derived from reading random parts of the Redis source and classifying every comment found. Quotes are verbatim. The essay's core: comments carry what the code cannot, and even comments that add no information can earn their place by lowering the reader's cognitive load.

> Many comments don't explain what the code is doing. They explain what you can't understand just from what the code does.

## The six comment types worth writing

1. **Function comments.** Above a function, so the reader never has to enter it.

   > The goal of a function comment is to prevent the reader from reading code in the first place.

   They double as the API reference: docs that live in the code change in the same edit as the code, so they never go stale, and whoever changes the function owns the comment.

2. **Design comments.** At the top of a file: the algorithm, the techniques, the rationale, one level above the functions. They also signal to the reader that a deliberate design process happened.

3. **Why comments.** They "explain the reason why the code is doing something, even if what the code is doing is crystal clear," and especially why the code avoids the thing that would feel more natural. His example is a protocol-level constraint (replication IDs must change when the backlog is freed) that no amount of clean code could make visible.

4. **Teacher comments.** They teach the domain the code operates in (the math, the protocol, the algorithm) rather than the code itself, so readers outside the domain don't have to context-switch to a textbook. Judgment required: worth it for parametric equations, absurd for a linked list.

5. **Checklist comments.** Change-this-touch-that reminders, a workaround for concerns the language won't let you centralize: "When implementing a new type of blocking operation, the implementation should modify unblockClient() and replyToBlockedClientTimedOut()."

6. **Guide comments.** The contested one. They add no information; they "babysit the reader ... by providing clear division, rhythm, and introducing what you are going to read." He defends them as most of Redis's comments and part of why Redis is considered readable, and notes that writing them pushes the author toward better logical organization. Partly personal taste; their failure mode is the trivial comment.

## The three to avoid

7. **Trivial comments.**

   > A trivial comment is a guide comment where the cognitive load of reading the comment is the same or higher than just reading the associated code.

   The canonical example: incrementing a counter, commented "increment the counter."

8. **Debt comments.** TODO, FIXME, XXX hard-coded in the source. Grep for them periodically; relocate the note somewhere better, fix the issue, or delete it. A design comment explaining why something isn't implemented beats a bare TODO.

9. **Backup comments.** Commented-out old code.

   > Source code is not for making backups. If you want to save an older version of a function or code part, your work is not finished and cannot be committed.

## Comments as design verification

Writing the comment is how you test the design before it ships:

> Comments are rubber duck debugging on steroids, except you are not talking with a rubber duck, but with the future reader of the code, which is more intimidating than a rubber duck, and can use Twitter.

Stating what the code does, in prose addressed to a real future reader, forces you to check whether what you're stating is acceptable. His demonstration of the cognitive-load claim is a block of Lua C-API calls annotated line by line with the current stack state: without the comments the reader simulates the stack mentally at every call; with them, "reading this code is now trivial."
