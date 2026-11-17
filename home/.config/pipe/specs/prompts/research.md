Research how to implement the brief in {{join .Inputs ", "}}

{{if .Feedback}}
A previous attempt was rejected. Address this feedback:

{{.Feedback}}
{{end}}

Read the brief first, and let it bound what you look at: this step investigates that job, not the codebase as a whole.
Follow the code, its tests and its history (`git log`, `git show`, `git blame`) where the brief leads. Find the files that matter, what depends on them, and how similar changes were made before.

Let the brief bound what you read, not what you search.
For each thing the change needs (a helper, a type, a way of doing I/O, errors, config or tests), search the whole repository for code that already does it or something close, and read only what the search turns up as a real candidate.

Cite the lines you mean, not just the file - `<filepath>:<line_no>`  so the plan can be checked without finding them again.
A fact earns its place here only if it settles a decision the plan has to make; if it settles none, leave it out.
When you looked for something and it isn't there, and the plan would otherwise go looking again, say so: "nothing calls this" and "this was never migrated" are findings.

Code in this repository can be read; the tools and services it talks to can't be run here.
Separate what you read from what you were told or inferred about anything outside the repository, and don't let an inference about outside behaviour pass as a fact: the design will rest on it, and nobody downstream can tell the two apart unless you do.

The engineer is waiting on this to decide how to build something, so leave out what bears on nothing they have to decide.

When you are done, write research.md in the workspace:

When you are done, write `research.md` in the repository root with the following sections.
Keep it short and concrete.

## Summary

What the change touches and where it lands, in a few sentences at most.

## Files involved

A bulleted list of `path:line`, each with one line on its role.

## What this affects

Callers, dependants, configuration, APIs, tests and documentation that would need to change or be checked.

## Existing code to reuse

Code that already does part of what the change needs, with `path:line`, and whether it can be used as it is, needs extending, or doesn't fit, and why.
"None found" is a valid answer, and it means you searched.

## Constraints from the code

The invariants and conventions a change here has to respect: locking and ordering rules, error types and how errors are wrapped, how the tests fake what they depend on, anything `AGENTS.md` or the code around it insists on, and the established way this codebase does each kind of thing the change involves.
Only those a plausible plan could break, each with the `path:line` of an example, or "None."

## Outside behaviour relied on

Each thing the change assumes about a tool, service or runtime outside this repository: how it resolves paths and runs commands, the environment it sets, how it handles arguments, the format of what it prints or accepts, what exists when it starts.
For each: where it came from (a document with its URL and version, the engineer, output the engineer ran and pasted), and whether it is confirmed or assumed.
For an assumed one, the command or document that would confirm it, and what the change loses if it turns out false.
"None." if the change touches nothing outside the repository.

## Prior art

Earlier commits that made a similar change, with commit hashes.
Design documents in the repository (for example under `rfd/` or `docs/`) that constrain this change, with their paths.
"None found" is a valid answer.

## Risks

Risks and unknowns the code shows, and what you couldn't settle from the code, or "None."

Where you had to choose between readings of the code, say which you took and why rather than writing as if there were only one.

Then tell the engineer in one line that it's written and that they can end the session, and stop.
