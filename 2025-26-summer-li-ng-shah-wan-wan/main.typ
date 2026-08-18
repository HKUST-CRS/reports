#import "@preview/cuti:0.4.0": fakebold

#let project(
  title: "",
  authors: (),
  date: none,
  logo: none,
  abstract: none,
  body,
) = {
  // Set the document's basic properties.
  set document(author: authors.map(a => a.name), title: title)
  set page(numbering: "1", number-align: center)
  set text(font: "Libertinus Sans", lang: "en", size: 12pt)

  show emph: it => [
    #show strong: fakebold
    #it
  ]

  show strong: it => [
    #show emph: fakebold
    #it
  ]

  show heading: it => [
    #show emph: fakebold
    #it
  ]

  // Title page.
  // The page can contain a logo if you pass one with `logo: "logo.png"`.
  if logo != none {
    align(left, image(logo, width: 50%))
  }
  v(9.6fr)

  text(1.1em, date)
  v(1.2em, weak: true)
  text(2em, weight: 700, title)

  // Author information.
  pad(
    top: 0.7em,
    right: 20%,
    grid(
      gutter: 2em,
      ..authors.map(author => align(start)[
        *#author.name* #{if ("adnomination" in author) { author.adnomination }} \
        #link("mailto:"+author.email)[#author.email] \
        #author.affiliation
      ]),
    ),
  )

  v(2.4fr)
  pagebreak()
  set page(numbering: "1", number-align: center, margin: (rest: 20mm, bottom: 15mm))

  // Main body.
  set par(justify: true)

  if abstract != none {
    // Abstract section.
    [
      #place(
        center+horizon,
        dy: -5em,
        block(
          width: 75%,
          [
            #show heading: set align(center)

            = Abstract
            #v(0.5em)
            #abstract
          ]
        ),
      )
    ]
    pagebreak()
  }

  // Table of contents.
  outline(depth: 3, indent: auto)
  pagebreak()

  show heading: it => {
    if (it.level == 1) {
      pagebreak(weak: true)
    }
    it
  }

  // Heading Numbering
  set heading(numbering: "1.")

  body
}

#show: project.with(
  title: [
    Even Further Development of \ CSE Request System
  ],
  authors: (
    (
      name: "LI, Yu Hong Harry",
      email: "yhliaf@connect.ust.hk",
      affiliation: [
      ]
    ),
    (
      name: "NG, Yat Fei",
      email: "yfngaf@connect.ust.hk",
      affiliation: [
      ]
    ),
    (
      name: "SHAH, Dhairya Pankaj",
      email: "dpshah@connect.ust.hk",
      affiliation: [
      ]
    ),
    (
      name: "WAN, Chi Chung",
      email: "ccwanac@connect.ust.hk",
      affiliation: [
      ]
    ),
    (
      name: "WAN, Yiu Wai",
      email: "ywwanaa@connect.ust.hk",
      affiliation: [
      ]
    ),
    (
      name: "TSOI, Yau Chat",
      email: "desmond@ust.hk",
      affiliation: [
      ],
      adnomination: [
        #footnote(numbering: "*")[
          Supervisor.
        ]
        #counter(footnote).update(0)
      ],
    ),
  ),
  date: datetime.today().display("[month repr:long] [day], [year]"),
  logo: "../COMP_FYP_Logo_transparent_1200dpi.png",
  abstract: [
    This report documents the Independent Work project _Even Further Development of CRS_, where CRS stands for the _CSE Request System_ --- a web-based platform that streamlines course administrative requests for courses offered by the Computer Science and Engineering (CSE) department at HKUST. Building upon the initial version of the system and the further development carried out in the previous Independent Work projects, this term continued the development of CRS with a team of five developers. The main deliverable documented here is a thread-based conversation system for requests, tracked in Pull Request #134 (_Threads in CRS!_), which replaces the previous binary request--response model with an append-only activity thread, a normalized request lifecycle status, and new backend mutations for comments, responses, cancellations, and appeals. A follow-up update, pushed to the same pull request in response to code review, moves proof attachments from inline base64 storage into MongoDB GridFS and adds a one-time database migration to the thread schema.
  ]
)

// Automatic figure placement, 
// allowing figures to float to the most appropriate location.
#set figure(placement: auto)

// Link styling
#show link: underline
#show link: set text(fill: navy)

// GH Issue Shorthand
#let issue(num) = {
  link("https://github.com/HKUST-CRS/crs/issues/" + str(num))[\##num]
}
// GH PR Shorthand
#let pr(num) = {
  link("https://github.com/HKUST-CRS/crs/pull/" + str(num))[\##num]
}

#import "@preview/fletcher:0.5.8": diagram, node, edge

= Introduction

This report is for the Independent Work project _Even Further Development of CRS_, where CRS is an abbreviation for the _CSE Request System_. This project was developed by LI, Yu Hong Harry (Harry), NG, Yat Fei, SHAH, Dhairya Pankaj (Dhairya), WAN, Chi Chung (Roger), and WAN, Yiu Wai (Simon) under the supervision of Dr. Yau Chat Tsoi (Desmond).

== Overview

CRS is a system to streamline and manage students' course administrative requests for courses offered by the Computer Science and Engineering (CSE) department, such as swapping lab sections, excused absence from lab sessions, extending assignment deadlines, and appealing assignment grades. The system aims to provide a user-friendly interface for both students and instructors to facilitate efficient request--response handling and record-keeping.

Continuing the previous Independent Work projects, which developed the initial version of CRS (2025-26 Fall), further developed it with enhancements and bug fixes (2025-26 Winter), and continued its development (2025-26 Spring), this Independent Work project focused on the even further development of CRS. The team consisted of Harry, the lead developer and one of the original developers of CRS, together with Yat Fei, Roger, and Simon from the previous term's team, and Dhairya, who newly joined the project this term.

Since Dhairya was new to the project, a significant portion of his work in this term involved familiarizing himself with the codebase and the technologies used by the system. To get familiar with the project, Dhairya first studied the repository starting from the commit d52cec2e, which closed issue #issue(68) by fixing the CI build for pull requests authored by developers without write permission to the repository (#pr(129)). He then set up the local development environment and wrote a seeding script that bootstraps a test course and users into the local database, which allowed him to host the system locally for testing and understand how CRS works under the hood.

After the familiarization phase, Dhairya implemented the main deliverable documented in this report: a thread-based conversation system for requests, tracked in Pull Request _Threads in CRS!_ (#pr(134)). The thread system addresses the _Conversation System_ future work item identified in the conclusion of the 2025-26 Winter report, which noted that students currently cannot provide additional information on an existing request, and instructors cannot ask for clarification without rejecting the request and asking the student to submit a new one.

The objectives of this Independent Work project were as follows:

- Implementing enhancements to the existing CRS system tracked in the issue tracker and the project's roadmap.
- Fixing bugs in the existing CRS system tracked in the issue tracker.
- Onboarding a new developer (Dhairya) to the project and helping him gain experience in web development.

At the time of writing, the thread system is under review (#pr(134)), and the remaining review comments have been addressed in the same pull request by moving proof attachments into GridFS and adding a database migration to the thread schema.

= Methodology

This section introduces the methodologies in the Independent Work, including the tasks and workflow for designing and implementing the enhancements. For enhancements and bug fixes that are associated with a GitHub issue or PR, the number is linked in parentheses for reference.

== Thread System (#pr(134))

The main deliverable documented in this report is the _thread system_, which introduces a thread-based conversation model for requests, replacing the previous binary request--response model.

In the old model, a request was created once and could receive at most one response (approve or reject with optional remarks) from an instructor. This was restrictive in several ways: a student could not provide additional information on an existing request, an instructor could not ask for clarification or change a decision after submitting it, and there was no built-in notion of cancelling a request or appealing a decision. These limitations were identified as future work (_Conversation System_) in the 2025-26 Winter report.

=== Design

The thread system models all activity on a request as an _append-only thread_ of entries stored on the request document, together with a normalized _status_ field that tracks the lifecycle of the request.

The initial design, which introduced the thread-style lifecycle with comments, cancellations, and appeals (commits 78baa84 and 09226b4), defined four kinds of thread entries: a comment entry, a response entry, a cancel entry, and an appeal entry, with a three-state status (_open_, _resolved_, or _cancelled_). The legacy response router was kept during the migration, forwarding to the new thread-based logic for compatibility.

Harry reviewed this design and suggested a cleaner model:

- The separate "Actions" area with its three buttons ("Add Comment", "Respond", and "Cancel Request") should be removed. Instead, a text box and a file uploader should always be shown under the thread area, and the actions should replace the "Submit" button: "Cancel", "Comment", "Approve", and "Reject" (depending on the role), in the style of GitHub threads where the actions sit under the text box. @fig-pr134-actions-area shows the initial thread view with the separate Actions area, and @fig-pr134-thread-reference shows the GitHub-style layout suggested in the review.
- Thread entries should be _monomorphic_: one kind of entry carries text and proof documents (a comment), and the other kind changes the status of the request. Approving or rejecting a request with a remark then simply means posting a comment entry followed by a status change entry.
- The initial reason and proof of a request should also be a comment entry, reducing the complexity of the data model.
- The thread should not be frozen once a request is cancelled, and an instructor should be able to change a decision after submitting one; with this, an appeal is no different from a comment, though an explicit _appealed_ status is still useful so that instructors can see at a glance which requests are pending their decision.

#figure(
  placement: bottom,
  caption: [
    The initial design of the request thread view: the actions are separated from the thread in an "Actions" area with three buttons.
  ]
)[
  #image("figure/pr134-actions-area.png", width: 100%)
] <fig-pr134-actions-area>

#figure(
  placement: bottom,
  caption: [
    A reference screenshot from the design review, illustrating the suggested GitHub-thread style in which the action buttons sit under a persistent text box.
  ]
)[
  #image("figure/pr134-thread-reference.png", width: 100%)
] <fig-pr134-thread-reference>

=== Implementation

Following the review, the response model was folded into the thread lifecycle (commit 8922590). This was a major refactor across all three packages of the monorepo (22 files, +1392/-2641 lines), which removed the separate `Response` and `ResponseDecision` models, the legacy response router, and the response-only form, and simplified the model to two kinds of thread entries:

- A _comment entry_ carries text and optional proof documents. The initial reason and proof of a request are stored as the first comment entry of the thread.
- A _status entry_ records a status change. The lifecycle status is one of five states: _open_, _approved_, _rejected_, _appealed_, and _cancelled_.

The status of a request is denormalized on the document so that the request list can be queried efficiently, and it is updated atomically together with the append of the corresponding thread entry. Status changes are guarded by role and current state: only instructors can approve or reject, only the requester can cancel or appeal, an appeal is only possible from the _approved_ or _rejected_ states, and instructors may change an earlier decision. In the UI, superseded status entries (for example, a rejection that was later appealed and overturned) are marked by striking through their status label and appending a "superseded" marker, keeping the audit history readable at full contrast. @fig-pr134-improved-ui shows the thread view after addressing the design review.

#figure(
  placement: bottom,
  caption: [
    The request thread view after addressing the design review: a persistent composer with role- and status-dependent action buttons ("Comment", "Approve", "Reject", "Appeal", "Cancel") under the thread.
  ]
)[
  #image("figure/pr134-improved-ui.png", width: 100%)
] <fig-pr134-improved-ui>

Additional changes in the PR include the following:

- Proof (supporting document) validation was refactored into a reusable `Proof` type, shared between the request body and thread entries, and signature hashing was extended to cover the proof files of all thread entries.
- New backend mutations `comment`, `approve`, `reject`, `cancel`, and `appeal` were added to the request router, each appending a thread entry and triggering email notifications; the legacy response router was removed after the migration.
- Email notifications for thread updates are _best-effort_: a notification transport failure can no longer reject an already-committed database mutation, which previously could cause duplicate entries or conflicting status changes when a client retried (commit ea3166f).
- Legacy, pre-thread request documents are normalized on read into synthetic thread entries, so that the new UI works transparently on existing data.
- A development seed script (`pnpm seed`) was added to quickly set up a test course and user in the local database (commit 128a0a1).
- Tests for the request service were reworked to cover thread mutations, status transitions, and legacy normalization.

== Attachments in GridFS — Update to Review

In the second round of review, Harry raised two concerns about the internal design and implementation of the thread system:

1. An adapter layer to keep the old and new schemas in sync is unnecessary and only creates a maintenance burden; the database should be migrated to match the thread schema instead.
2. Because attachments now live on thread comments rather than on the request itself, a request can carry an unbounded number of attachments. Storing them as inline base64 in the document can exceed the maximum size of a MongoDB document, so attachments should be moved to MongoDB GridFS, storing a reference in the thread entries instead of the raw bytes, and the per-file size limit can be increased (for example, to 4 MiB).

In response, the update was implemented and pushed to the pull request itself (commit 9ab5aa7, with a follow-up fix in f457689):

- The `ProofFile` model now stores a GridFS object id together with the size and a SHA-256 hash of the file, instead of inline base64 content; the size and hash are derived server-side from the decoded bytes, the per-file size limit was raised from 2 MiB to 4 MiB and is enforced on the actual content, and the request signature commits to the file content via the stored hash. A separate `ProofUpload` type is used for input, and a `proofs` GridFS bucket was added to the database connections.
- Proof content is fetched on demand by clients through a new `proofContent` query on the server, gated by ownership and class-view authorization. Uploads use a two-phase commit that rolls back partial writes if a later step fails, and the server's body size limit was raised to 32 MiB so that oversized payloads are rejected with a 413 during streaming.
- The legacy adapter layer was dropped entirely: the repository now returns documents as-is with a simplified status guard, and legacy normalization (status values, entry shapes, and the old `details` field rewritten into an opening comment) moved into the migration.
- A one-time, idempotent database migration (`migrateRequests`) rewrites legacy request documents into the thread schema: it converts old response, cancel, and appeal entries into monomorphic comment and status entries, moves inline base64 proof bytes into GridFS, and --- after rewriting --- deletes any GridFS file that no document references, so an interrupted run no longer accumulates orphans (commit f457689). Already-migrated documents are skipped, so the migration is safe to re-run.
- The same update also addressed the inline UI review comments: a selection-token guard for asynchronous file reads that clears the previously accepted proof as soon as a new selection starts (including on validation and read failures), composer inputs disabled while a mutation is pending, superseded rows kept at full contrast, dark-mode contrast for the cancelled status, the "Decision" column and filter renamed to "Status", and status actions that attach proof without a remark now rejected explicitly instead of being silently discarded.
- A richer development seed script creates two users (a student and an instructor) and seeds requests covering every lifecycle state (_open_, _approved_, _rejected_, _appealed_, and _cancelled_) with realistic thread entries, using the real request service API.

Deploying the update has a strict ordering --- stop the old server, run the migration once (`cd packages/service && bun run scripts/migrate.ts`), then start the new server --- and a mongodump is recommended beforehand as a precaution. The update is verified by typechecking, linting, and the service test suite (96 tests), and is awaiting Harry's re-review at the time of writing.

== CI Build Fix (#issue(68), #pr(129))

The first contribution of this term, and the starting point for getting familiar with the project, was a fix for issue #issue(68), _CI Build Fails_, opened by Harry. The CI build failed when the author of a pull request did not have write permission to the repository: the Docker login step of the build workflow attempted to authenticate on every event, including pull requests from forks, where the required secrets are not available.

The fix (commit d52cec2e, merged as #pr(129)) gates the Docker login step and the push/provenance options of the build step on push events to the `main` branch only. Images are still built for every pull request, but they are no longer pushed to the registry, so the build succeeds for fork-based pull requests.

== Onboarding New Developers

As part of the project, significant effort was dedicated to onboarding the new developer, Dhairya, and helping him gain experience in web development. The experience can be organized into three phases: Initial Learning, Exploration, and Contribution.

=== Dhairya's Experience

/ Phase 1\: Initial Learning:

  To get familiar with the project, Dhairya started with the commit d52cec2e, which closed issue #issue(68) by fixing the CI build for pull requests from contributors without write permission (#pr(129)). Working through this issue required understanding how the project is built, how its CI workflow is structured, and how contributions flow from a fork through a pull request into the main repository.

/ Phase 2\: Exploration:

  Next, Dhairya set up the local development environment and hosted it locally for testing, so that he could run the system end to end and experiment with changes safely. He then read through the code line by line, following a request from the site form through the server router into the service layer and the database. To make this workflow faster and repeatable, he also wrote a seeding script that bootstraps a test course and users into the local database, which doubled as a hands-on way to understand how CRS works under the hood.

/ Phase 3\: Contribution:

  In this phase, Dhairya implemented the main deliverable of the term, the thread system (#pr(134)). The work started with the initial thread-style lifecycle and its UI (commits 78baa84 and 09226b4), followed by fixes and a development seed script, and was reviewed by Harry in two rounds. Addressing the design review required a major refactor that folded the response model into the thread lifecycle (commit 8922590), simplifying the data model to monomorphic comment and status entries with a five-state lifecycle, and reworking the request thread UI accordingly. Addressing the internal design review led to the update that moves proof attachments into GridFS and migrates the database to the thread schema (commits 9ab5aa7 and f457689). Throughout the review process, Dhairya also triaged the findings of GitHub's Copilot code review, fixing the valid findings (for example, an unstable table sort comparator) and evaluating the false positives.

= Planning

The work on the thread system was planned in several stages, which are reflected in the commit history of #pr(134) and its review history:

+ *Familiarization and First Contribution* (June). Dhairya studied the codebase starting from the CI build fix (commit d52cec2e, #pr(129), closing #issue(68)) and set up his local development environment with the seed scripts.

+ *Initial Implementation* (July). The thread-style request lifecycle was implemented across the service and server packages together with the request thread view and composer in the site package (commits 78baa84 and 09226b4), followed by fixes and a development seed script (commits 4956159, 128a0a1, and 338a8b9), and the branch was prepared for review through a fork-internal merge.

+ *Review and Refactor* (August). Two review rounds from Harry led to the fix commits addressing review findings (ea3166f, ff9700c) and the major refactor that folded the response model into the thread lifecycle (8922590), followed by UI improvements for status changes (cbd2c86).

+ *Follow-up* (August). The remaining review comments were addressed directly in the pull request: the GridFS attachments update and the database migration (commit 9ab5aa7), followed by a fix for stale proof selection and orphaned GridFS sweeping (f457689). The pull request is awaiting final review.

= Conclusion

In this Independent Work project, the team continued the even further development of CRS. The main deliverable of the term was the thread system (#pr(134)), which replaced the binary request--response model with an append-only conversation thread, monomorphic comment and status entries, and a normalized five-state request lifecycle. The thread system is under review at the time of writing; the review comments have been addressed within the pull request, including the move of proof attachments into GridFS and a database migration to the thread schema.

For Dhairya, this term was also a first experience of working on a real-world codebase with an active upstream and a proper review culture. Starting from a small CI fix (commit d52cec2e), he became comfortable with the system by reading the code line by line and hosting it locally for testing, and went on to design, implement, and iterate on the thread system through two rounds of detailed code review, learning a great deal about full-stack web development, data modeling, and maintaining backward compatibility along the way.

Future work includes merging the thread system after the final review, deploying it (running the database migration with its strict ordering), and gathering feedback from students and instructors on the new conversation workflow.

== Acknowledgements

We would like to extend our sincere gratitude to our advisor, Dr. Yau Chat Tsoi, whose support and guidance have been invaluable to us.

We would also like to thank LI, Yu Hong Harry, the lead developer of CRS, for his detailed code reviews and guidance throughout the development of the thread system.
