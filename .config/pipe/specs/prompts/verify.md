Verify the work in this repository against {{join .Inputs ", "}}.

{{if .Feedback}}
A previous attempt was rejected. Address this feedback:

{{.Feedback}}
{{end}}

You are working on one step of an engineer's pipeline, on your own.
Nobody is at the terminal: there is no one to ask, and nobody will read your replies.
The file you write is the whole output of this step, so don't stop before it is written and don't leave anything important out of it.

If subagents are available, spin up one subagent for each:

## Correctness

Review the change for correctness: does it do what it is supposed to do, in every case it will meet?

Look for:

- logic that doesn't do what the code around it, or its own name and comments, say it does;
- edge cases left unhandled: empty, zero, one, many, absent, duplicate, out of order, already done, cancelled, concurrent;
- errors swallowed, turned into success, or wrapped until the caller can't act on them; error paths that leave something half-changed;
- APIs used against their contract: the wrong lock or the wrong lifetime, an ignored return value, a value assumed non-nil, a parameter read in the wrong unit or order;
- state that can be observed between two steps that were meant to be one;
- assumptions about ordering or timing: a map written while it is being ranged over, a goroutine reading what another is still writing, a value cached across a change that invalidates it;
- behaviour that contradicts the RFD or the plan, or that quietly changes what an existing caller gets.

## Quality

Review the change for quality: whether the next person to touch this code will be able to, and whether the tests would notice if it broke.

Look for:

- dead code: a branch that can't be reached, a parameter nobody passes, an exported name nothing uses, a flag left behind by the change;
- duplication: the same logic added beside something that already does it, or copied between files where one of the copies will be forgotten. For each new function, type or block of logic, search the whole repository, not just the files around the diff, for something that already does it;
- needless complexity: indirection with one implementation, a configuration knob nobody will turn, a general mechanism for a single case, layers a reader has to hold in their head to follow one call;
- changed behaviour with no test, and new behaviour whose test only covers the happy path;
- tests that don't assert what they claim: an assertion that passes whatever the code does, a mock asserting against itself, a test named for a case it doesn't exercise, an error ignored so a failure reads as a pass;
- a test that would still pass if this change were reverted. Revert it in your head, or read the test without the diff: if nothing in it fails, it isn't testing the change, whatever its name says;
- tests that reach into unexported state where the behaviour could be exercised through the interface, so they break on every refactor and catch nothing;
- resource leaks and unbounded growth: something opened and not closed on every path, a goroutine or timer with no way to stop, a map or slice that only grows, a retry with no limit;
- what the change left behind: debugging output, commented-out code, a stray file, a `.only` or a skipped test, a dependency added for one use;
- inconsistency with the conventions of the surrounding code and of `AGENTS.md`: names, error wrapping, logging, where a thing belongs;
- nits: style and idiomatic use of language features;
- comments and documentation that the change has made untrue.

## Security

Review the change for security: what an attacker, or a mistake, could do with it that the engineer didn't intend.

Look for:

- authentication and authorization gaps: a check missing on one path, a check on the wrong subject, a decision made from data the caller supplies, an identity that widens as it is passed along;
- injection: SQL, shell and argument lists, templates, YAML and JSON, log forging, anything built by concatenating a string that came from outside;
- path traversal and symlink following; files created world-readable or outside the directory they were meant for;
- SSRF and request forgery: a URL, host or port taken from input; redirects followed; internal endpoints reachable from an external path;
- secrets in code, in logs, in error messages, in command lines and process environments, or written into a file that isn't meant to hold them;
- crypto and TLS misuse: verification disabled, a weak or homemade construction, a predictable value where randomness is needed, a comparison that leaks timing;
- validation missing at a trust boundary, or done twice and inconsistently, so the two answers can disagree;
- races and deadlocks with security consequences: a check separated from the use it protects, a lock not held for the whole decision, a cancelled operation that leaves access granted;
- resource exhaustion reachable from outside: unbounded reads, allocations sized by input, work started per request with no limit;
- supply chain: a dependency added, removed or version-bumped, and what it now does with the data; a lockfile or vendored copy that moved;
- build and deployment surface: a workflow, a container image, a script or a permission mode the change touches. These run with more privilege than the code around them, and are the least examined part of a change.


Check every finding against the code before you write it down, and say what you checked. If you can't confirm it, leave it out. An empty report is a valid answer and better than a padded one.

Only report what this change introduced, made worse, or now depends on. A problem in the surrounding code that the change neither causes nor worsens is worth one line, not a finding.

Write `verify.json` in the repository root with an overall `"pass"` of `true` or `false` and one entry in `"reasons"` for each of the findings:

Only findings of **critical** and **high** severity should result in `"pass": false`.
Findings of only **medium**, **low**, and **nit** severity are informational only and should result in `"pass": true`.

```json
{
    "pass": true or false,
    "reasons": [
        {
            "location": "path:line",
            "comment": "what's wrong in 1-2 sentences",
            "evidence": "how to reproduce",
            "severity": "critical|high|medium|low|nit",
            "suggestion": "what to do instead - with enough specificity to act on without further context"
        }
    ]
}
```

Do not change any files except `verify.json`.

