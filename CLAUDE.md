# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**LimitTheory** ([DieSlower/LimitTheory](https://github.com/DieSlower/LimitTheory)) — builds and extends the open-source Limit Theory game ([JoshParnell/ltheory](https://github.com/JoshParnell/ltheory), game scripts in Lua) on its C engine/library [libphx](https://github.com/JoshParnell/libphx) (C/C++, exposed to Lua via LuaJIT FFI). Windows, MSVC, CMake.

The cross-cutting design decisions are in [`Docs/SDDs/`](Docs/SDDs/), and the roadmap is in [`Docs/Plans/`](Docs/Plans/). Read the relevant ones before designing anything.

## Workflow rules

- **Always invoke the `grill-me` skill before starting any new feature or any large change to existing functionality.** "Large change" means anything that touches multiple files or modules, alters the contract of a public C++ API or exported type, modifies persisted data (a file format, save schema or config/settings layout), or changes user-visible behavior in a non-trivial way. Trivial bug fixes, typo corrections, and one-line tweaks are exempt.
- Run `grill-me` *after* `superpowers:brainstorming` (if brainstorming applies) and *before* writing any implementation code or a written SDD. Use it to stress-test the design by walking down each branch of the decision tree one question at a time, with a recommended answer attached to each question.
- **`grill-me` MUST run before the SDD is drafted, and every resolved decision from `grill-me` MUST be incorporated into that SDD.** Do not commit a design to disk until grilling is complete. If a grill-me question was deferred rather than answered, call that out explicitly in the SDD as an open question.
- **When `grill-me` is running, every decision the user has not concretely specified MUST be put to the user — never decided unilaterally.** If there is a decision to be made and the user has not already given an explicit answer to it, ask. Attach a recommended answer to each question, but the user makes the call. "Sensible default", "obvious choice", and "I'll just pick the common one" are not grounds to skip asking during a grill — surface the decision and let the user decide.
- If the user explicitly says "skip grilling" or "don't grill me" for a specific task, honor that — user instructions take precedence over this rule.
- **Ask every question through the `AskUserQuestion` tool (the GUI question widget), never as plain text in a reply.** This applies to all questions to the user, not just `grill-me` ones: design choices, "which way do you want it?" after a finding, confirmations, anything. Put the recommended answer first, labeled "(Recommended)".
- **Never answer a question on the user's behalf, and never carry on as if it were answered.** When a question to the user is open, stop and wait for their reply; do not time out, guess, or keep working past it. This rule is only about questions. Resuming already-approved work after a usage-limit pause (via a one-shot `CronCreate`, per the global CLAUDE.md) is still allowed, but never past a pending question.
- **Build each roadmap part with its own subagent, and keep that subagent's context under ~35%.** If it runs over, continue with a fresh subagent that reads the SDD, plan and progress notes cold. Parts must be small enough for Claude to verify without the user; the user tests only the finished product.
- **Pause points while building (context and usage limits):**
  - **Context above 35%:** when the main session's context passes 35%, stop at the next good breakpoint (a finished task or part, never mid-edit or mid-subagent-dispatch). Save resume state (task list, files mid-edit, exact next step) in the plan/progress notes so a fresh context can continue cold. Ask the user to run /compact.
  - **On a usage-limit error:** save resume state (task list, files mid-edit, exact next step), read the reset time from the error message (fallback: +5h10m for the 5-hour window, +7d10m for the weekly one), and schedule a one-shot `CronCreate` resume. There is no reliable way to poll usage, so do not run a "usage checker" agent. Make sure CLAUDE.md is reread after compaction.
  - **70% of the 7-day limit:** pause proactively at a good breakpoint when 70% of the 7-day limit is used and do not resume until the 7-day window resets. Fallback to +7d10m for the weekly use limit, and schedule a one-shot `CronCreate` resume. Do not run a "usage checker" agent. Read the figure from `~/.claude/rate-limits-cache.json` (`seven_day_used_pct`, `seven_day_resets_at`; check `written_at` for freshness) before starting and after finishing each task.
  - As above, none of this authorizes proceeding past an open question to the user or the need for using the `grill-me` skill. If there are outstanding questions, or grill-me need, you must pause. Otherwise do not stop, for any other reason (from the ones mentioned above), continue working, taking on new tasks as the old ones get completed and pushed to the repo.

## Subagents — model selection

- **Always evaluate which model a newly dispatched subagent needs, and assign the best model for that specific job — never dispatch on autopilot.** Subagent model selection follows the precedence override > agent-definition frontmatter > inherit-from-parent; passing the `model` field on the `Agent` call is the per-dispatch override and is the lever to use here. The goal is to match capability to task, not to default everything to the parent's model.
- **Subagent version** — Before dispatching a subagent, check which versions of the model you are planning to use are available, and use the latest version of that model.
- **Hard / reasoning-heavy work gets the smartest model.** Code design, architecture, multi-file refactors, logic-dense implementation, test authoring against a contract (TDD), and adversarial performance/style reviews are reasoning jobs — dispatch these on the strongest tier, `opus`. Do not dispatch `fable`: it is not usable as a subagent model here and silently falls back to a lesser tier.
- **Moderate implementation work** — straightforward single-file changes, routine wiring, ordinary code edits — fits a mid tier: `sonnet`.
- **Simple / mechanical work gets a cheaper, faster model.** Finding a string across files, listing where a symbol is used, fetching/searching the web for a fact, dumping a value, or other low-judgment lookups don't need a frontier model — dispatch these on `haiku` to save cost and latency.
- **Apply best judgment to the task in front of you.** These are guidelines, not a fixed table — weigh how much reasoning, code understanding, and design judgment the task actually demands, and pick the cheapest model that will still do the job well. When genuinely unsure, err toward the more capable model so quality isn't sacrificed.

## Build & Run

- **Documentation:** index in [`Docs/README.md`](Docs/README.md) — build/run/controls, engine (`Docs/Engine/`) and game (`Docs/Game/`) docs.
- **Layout:** the game (`ltheory`) is the repo root; the engine `libphx` is **vendored** into `libphx/` as ordinary tracked files (no submodule; the game's `CMakeLists.txt` pulls it in via `add_subdirectory`). Assets in `res/` are Git LFS.
- **Toolchain:** MSVC (Visual Studio 2022 Community, x64), CMake 4.x (verified with 4.4.4), Python 3 (only for the `configure.py` helper), Git + Git LFS.
- **Fresh checkout** (run once, from the repo root): `git lfs install`, `git clone https://github.com/DieSlower/LimitTheory.git`, then `git lfs pull` if assets are still pointers. If a checkout fails with LFS smudge errors, use `GIT_LFS_SKIP_SMUDGE=1 git checkout ...` and then `git lfs pull`.
- **Configure:** `cmake -S . -B build -G "Visual Studio 17 2022" -A x64 -DCMAKE_POLICY_VERSION_MINIMUM=3.5` (the policy flag is required: the project declares `cmake_minimum_required(VERSION 3.0.2)`, which CMake 4 rejects).
- **Build:** `cmake --build build --config RelWithDebInfo` (the Lua scripts load `libphx64.dll`, which only the `RelWithDebInfo` config produces — `Release` yields `libphx64r.dll` and the game fails to start). No source patches are needed with the VS generator. Full details: [`Docs/BUILDING.md`](Docs/BUILDING.md).
- **Verified:** this configure + build sequence produces `bin\lt64.exe` and `bin\libphx64.dll`; the exe launches a window.
- **Run (from the repo root, which must be the working directory):** `bin\lt64.exe` for the default `LTheory` script, or `bin\lt64.exe <ScriptName>` for any script in `script\App\` (name without extension).
- **Clean:** delete `build/` and `bin/`.
- **Shell note:** the Bash tool's sandbox may block Git LFS network access; if a command fails with a socket "forbidden by its access permissions" error, retry it.
- **Run the tests from a terminal:** `<command>`; see [Testing](#testing).
- `Docs/` and `Tools/` sit outside the shipped artifacts.

## Architecture

**[`Docs/ARCHITECTURE.md`](Docs/ARCHITECTURE.md) is the living high-level map** of modules, update/data flow, key types and dependencies — read it before working across more than one feature folder. The *why* behind each decision lives in the SDDs under [`Docs/SDDs/`](Docs/SDDs/). Module and file layout rules are in [`Docs/STYLE_GUIDE.md`](Docs/STYLE_GUIDE.md).

**Keep `Docs/ARCHITECTURE.md` in sync**, per its own "Keeping this document in sync" section: whenever a module/subsystem/major class is added or removed, a class's responsibility or a module dependency changes, or a command-line flag changes.

**Read [`Docs/STYLE_GUIDE.md`](Docs/STYLE_GUIDE.md) before writing or refactoring any C++.** Where the guide is unsettled or silent, follow the surrounding code and ask the user.

## Persistence — minimize disk traffic

**Standard for all persistence code (save files, settings, config files): keep disk reads and writes to the minimum that still preserves the user's data.**

- **Mutate in memory freely; write at lifecycle boundaries.** A setter changes the in-memory value only. The write happens once at a natural boundary (dialog close, session end, app shutdown), not per keystroke or per frame.
- **Skip the write when nothing changed.** Compare against the stored value first.
- **Batch.** If several values change in one visit, they go out in a single save.
- **Read once.** Load at startup; everything afterwards reads the in-memory copy.
- **Prefer async saves** so a save never stalls the main thread.
- **Accepted trade-off:** a change made and not yet flushed is lost if the OS kills the app before the boundary.
- When the persisted schema changes incompatibly, version it and migrate rather than silently discarding the user's data.

## Software design documents (SDDs)

Every **new feature** or **major change** (the same trigger that requires TDD — a new system, module or subsystem, or a substantive multi-file refactor or behavior change) is designed against a written **SDD**. Save it under [`Docs/SDDs/`](Docs/SDDs/) so the design is versioned alongside the code and can be diffed against the implementation during the [performance review](#performance-review--required-after-code-changes).

**Naming:** `<issue-number>-<short-content-slug>.md`, where `<issue-number>` is the GitHub issue number and the slug summarizes what the ticket delivers. One SDD per ticket; keep it updated if the design shifts during implementation so the "compare against the SDD" step stays meaningful. See [`Docs/SDDs/README.md`](Docs/SDDs/README.md).

**A written plan is required alongside the SDD — both are saved to disk, neither is optional.** Once the SDD is agreed, save the implementation plan under [`Docs/Plans/`](Docs/Plans/) named `<issue-number>-<slug>-plan.md`. Like the SDD, the plan is a living document: keep it in sync as steps get done or reordered. **Do not skip either artifact on your own judgment** — if you think a change is too small to warrant an SDD and a plan, ask the user first and get explicit confirmation before proceeding without them.

## Research and future work

- [`Docs/Research/`](Docs/Research/) holds research reports that support decisions.
- Ideas and follow-up work that are identified but not yet scheduled as a ticket live under [`Docs/ToDo/`](Docs/ToDo/), one file per item, no issue number (see [`Docs/ToDo/README.md`](Docs/ToDo/README.md)). This is distinct from **Known tech debt to revisit** below: tech debt is imperfections in code that already exists, ToDo items are new capabilities that haven't been built. When an item is picked up, it graduates into a normal ticket — write its SDD as usual (`grill-me` still applies) — and the ToDo file is deleted.

## Testing

<!-- TODO: name the test framework (e.g. GoogleTest, Catch2, doctest) and runner once chosen. -->
Tests use **<test framework>**:

- Test source lives under `Tests/`, one file per topic (`<Topic>Test.cpp`). Test names are `<Topic>.<Case>` so a filter on `<Topic>` runs one topic.
- **Command-line runner:** `<command>`. It prints a pass/fail summary and exits 0 (all passed), 1 (failures) or 2 (could not run / no results).
- **Read results from the runner's report/log output** instead of asking the user to relay them.

### Required: tests for new and modified code

- **New features.** Plan the test file alongside the implementation.
- **Modified classes.** Any change — refactor, behavior change, bug fix — requires either adding tests covering the change or extending existing ones.
- **Re-validate the existing test file when modifying a tested class.** Walk every existing test, confirm it still reflects the current contract, add tests for new code paths, and delete tests whose target no longer exists. A green run alone is not sufficient — stale tests that happen to pass are a regression risk.

### Test-Driven Development for new features and large changes

Whenever you build a **new feature** (a new system, module or subsystem) or make a **large change** (substantive refactors, new public API on an existing class, behavior changes spanning multiple files), use **TDD**:

1. **Write the failing test first** in the appropriate `Tests/<Topic>Test.cpp`. State the expected behavior as assertions before the production code exists.
2. **Build and run it** and confirm it fails for the right reason (missing function, wrong value), not a typo or build error.
3. **Write the minimum implementation** to make it pass.
4. **Re-run** and confirm green, then refactor with the test as a safety net.

**The test file in step 1 must be authored by a dispatched subagent, not inline in the main session.** Brief the subagent with the contract under test (inputs, outputs, edge cases), the target test file path, and the test-framework macros in use. Do NOT show it the production implementation — the tests must be written against the spec, not retrofitted to whatever the code does. The main session then handles steps 2–4. The same rule applies when *extending* an existing test file as part of a large change. Small bug fixes and trivial tweaks may use test-after.

## Performance review — required after code changes

Once code is written, it **must be reviewed by a fresh, adversarial `opus` subagent — a separate context from the one that wrote the code — for performance/optimization _and_ style-guide conformance** before the change is considered done. Brief the subagent with the changed files, the SDD, [`Docs/STYLE_GUIDE.md`](Docs/STYLE_GUIDE.md), and any performance guidelines under [`Docs/Research/`](Docs/Research/); have it report findings rather than edit, so the main session applies fixes.

The review must check at least the following:

1. **Hot-path cost.** No per-frame/per-iteration work that could be event-driven, cached or batched.
2. **Allocation.** No heap allocation, string building, or container growth inside hot loops; `reserve` up front; prefer stack/arena/pool allocation where lifetimes allow.
3. **Data layout.** Cache-friendly iteration, structure-of-arrays where it pays off, no pointer-chasing in hot loops, no needless copies (pass by reference, use move semantics).
4. **Ownership and lifetime.** RAII throughout; smart pointers or value semantics instead of raw owning pointers; no leaks, dangling references or use-after-free; callbacks and subscriptions are unregistered at teardown.
5. **Threading.** Parallelizable work is parallelized; shared state is correctly synchronized; no data races or lock-order hazards.
6. **Const-correctness and API hygiene.** `const`, `noexcept`, `[[nodiscard]]` and `explicit` used where appropriate; minimal includes and forward declarations; no ODR or ABI surprises.
7. **Numerics.** Appropriate precision for the domain; no silent narrowing conversions, overflow or float-equality bugs.
8. **Profiling evidence.** Claims about cost are backed by a profiler or benchmark, not guesses.
9. **Style-guide conformance.** New and changed code follows every applicable rule in `Docs/STYLE_GUIDE.md`. Flag deviations in new/changed code; don't require rewriting untouched legacy code.

**When the review finds something below this bar, fix it, then close the loop:** re-check the change against its SDD to confirm the fix didn't change intended behavior, then **re-run the full test suite** and confirm every test still passes before treating the work as complete.

## Git

**Commit and push once a part is done.** Once a roadmap part is implemented, its tests pass, and the required adversarial performance/style review's findings are fixed (or explicitly accepted as tech debt), stage the part's changes, commit, and push to `origin`. Commit message convention: `Issue #<N>: <short description>` (`<N>` is the GitHub issue number). End the message with the attribution line the session's own system reminder specifies.

Read-only git operations (`git status`, `git diff`, `git log`, `git show`, `git branch`) may be run freely, by the main session or a dispatched subagent. Destructive/history-rewriting operations (force-push, reset --hard past a shared commit, rebase of pushed history) still require asking first.

## Conventions

- **Copyright header:** every new source file starts with the banner defined in `Docs/STYLE_GUIDE.md` (project name and copyright line); docs use the HTML-comment equivalent.
- **Comments:** every function (including file-local helpers) gets a single-line `//` header above it describing what it does. Any non-trivial block longer than ~5 lines inside a function also gets a brief inline comment.
- **Constants and paths:** file paths, resource names and magic numbers are never hardcoded at call sites; they live in one central place (a constants header or data/config file), per `Docs/STYLE_GUIDE.md`.
- **Tests required for changes** — see [Testing](#testing).
- **SDD and plan for new features and major changes** — see [Software design documents (SDDs)](#software-design-documents-sdds).
- **TDD for new features and large changes** — see [Test-Driven Development](#test-driven-development-for-new-features-and-large-changes).
- **Performance review after code changes** — see [Performance review](#performance-review--required-after-code-changes).

## Known tech debt to revisit

Items the team is aware of but hasn't scheduled yet. Don't treat as blockers, but keep in mind when working in the area:

- *(none yet)*

Add new items here as they're discovered rather than letting them live only in commit messages or memory.

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
