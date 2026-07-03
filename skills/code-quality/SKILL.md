---
name: code-quality
description: 'Universal code-quality rules that apply whenever production code is written or changed: document every type and public member, honor DRY absolutely, one top-level type definition per file, and uphold strong idiomatic maintainable code. Primarily loaded by other skills (e.g. spec-exec) that drive implementation; use directly when writing or reviewing production code outside a spec-driven workflow.'
---

# code-quality — the rules for production code

These rules govern **all production code**, in any project and any language.
They are workflow-independent: other skills (such as `spec-exec`) load this
skill and enforce these rules during implementation and review, but they apply
just as well to a one-off change.

## The rules

1. **Document all types and public methods.** Every class, record, struct,
   enum, interface, and every public method/property has a doc comment (e.g.
   `///` XML docs in C#) that concisely explains what it does. This applies to
   production code; test code is exempt. Document complex flows narratively
   too.

2. **Honor DRY absolutely.** Do not duplicate logic, boilerplate, or query
   patterns across handlers, repositories, or tests. Abstract repetition into
   reusable helpers, extension methods, or shared classes. Do not copy-paste
   code blocks.

3. **One top-level type definition per file.** For programming languages (eg,
   C#), each code file declares at most one top-level type (eg,
   `class`/`struct`/`record`/`interface`/`enum`); an interface and its
   implementation must not share a file, and the file name matches the type.
   Nested types, constructs like C#'s `partial` types across files, and
   top-level statements in program entry files (eg, `Program.cs`) are allowed;
   For C#, generated EF migration `*.Designer.cs`/snapshot and `obj/`/`bin/`
   are exempt. Where possible, there must be an automated architecture test to
   validate these rules.

4. **Uphold the highest coding standards.** Write strong, idiomatic,
   maintainable code for the language and framework at hand. Prefer clarity
   over cleverness; keep functions and types focused.

## For skills that load this one

When another skill (e.g. `spec-exec`) references these rules, treat them as
active constraints for every code change made under that skill — restate them
when re-anchoring, and check code against them before declaring any work
complete.
