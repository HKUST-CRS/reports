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
// GH Commit Shorthand
#let commit(sha) = {
  link("https://github.com/HKUST-CRS/crs/commit/" + str(sha))[#raw(str(sha))]
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
    This report documents the Independent Work project _Even Further Development of CRS_, where CRS stands for the _CSE Request System_ --- a web-based platform that streamlines course administrative requests for courses offered by the Computer Science and Engineering (CSE) department at HKUST. Building upon the initial version of the system and the further development carried out in the previous Independent Work projects, this term continued the development of CRS with a team of five developers. The main deliverable is a thread-based conversation system for requests (#pr(134)), which replaces the previous binary request--response model with an append-only activity thread and a normalized request lifecycle. The project also delivered automatic course setup from the UST Archive schedule (#pr(137)), stronger request validation and user-interface refinements (#pr(139)), and a reproducible local MongoDB and development-authentication environment (#pr(140)). Additional site-facing work included request-form UX fixes for assessment due times and deadline-extension calendars (#pr(108), #pr(119)), and an About page with project introduction, developer credits, and a downloadable third-party license notice (#pr(142)). In addition to implementing these enhancements, Harry coordinated the project and provided the architectural and code reviews that led the thread system to use monomorphic entries, MongoDB GridFS, and an explicit database migration.
  ]
)

// Automatic figure placement, 
// allowing figures to float to the most appropriate location.
#set figure(placement: auto)

// Keep paired application screenshots large enough to read while fitting both
// full, tightly framed captures on one page.
#let ux-shot(path, width: 70%) = align(center)[
  #image(path, width: width)
]

#import "@preview/fletcher:0.5.8": diagram, node, edge

= Introduction

This report is for the Independent Work project _Even Further Development of CRS_, where CRS is an abbreviation for the _CSE Request System_. This project was developed by LI, Yu Hong Harry (Harry), NG, Yat Fei, SHAH, Dhairya Pankaj (Dhairya), WAN, Chi Chung (Roger), and WAN, Yiu Wai (Simon) under the supervision of Dr. Yau Chat Tsoi (Desmond).

== Overview

CRS is a system to streamline and manage students' course administrative requests for courses offered by the Computer Science and Engineering (CSE) department, such as swapping lab sections, excused absence from lab sessions, extending assignment deadlines, and appealing assignment grades. The system aims to provide a user-friendly interface for both students and instructors to facilitate efficient request--response handling and record-keeping.

Continuing the previous Independent Work projects, which developed the initial version of CRS (2025-26 Fall), further developed it with enhancements and bug fixes (2025-26 Winter), and continued its development (2025-26 Spring), this Independent Work project focused on the even further development of CRS. The team consisted of Harry, the lead developer and one of the original developers of CRS, together with Yat Fei, Roger, and Simon from the previous term's team, and Dhairya, who newly joined the project this term.

From January to May, Harry continued maintaining the deployed system through changes to its permission model (#pr(69)), request types and data export (#pr(76), #pr(81)), authentication and time-zone handling (#pr(114), #pr(116), #pr(120)), and request search and transfer size (#pr(127), #pr(128)). After June, his role shifted towards project coordination, technical direction, and integration: he assigned the summer tasks, reviewed the thread-system design and implementation, and implemented three follow-up enhancements (#pr(137), #pr(139), #pr(140)).

Simon contributed request-form and calendar UX improvements during the Spring term (#pr(108), #pr(119)), reducing incorrect default months and inconsistent due-date mapping when configuring assignments or requesting deadline extensions. In the current term he implemented the site About page (#pr(142)), including MDX-based content, developer attribution, a link to the public GitHub repository, and a scripted third-party license dump for open-source compliance.

Since Dhairya was new to the project, a significant portion of his work in this term involved familiarizing himself with the codebase and the technologies used by the system. To get familiar with the project, Dhairya first studied the repository starting from the commit #commit("d52cec2e"), which closed issue #issue(68) by fixing the CI build for pull requests authored by developers without write permission to the repository (#pr(129)). He then set up the local development environment and wrote a seeding script that bootstraps a test course and users into the local database, which allowed him to host the system locally for testing and understand how CRS works under the hood.

After the familiarization phase, Dhairya implemented his main deliverable, a thread-based conversation system for requests, tracked in Pull Request _Threads in CRS!_ (#pr(134)). The thread system addresses the _Conversation System_ future work item identified in the conclusion of the 2025-26 Winter report, which noted that students currently cannot provide additional information on an existing request, and instructors cannot ask for clarification without rejecting the request and asking the student to submit a new one.

The objectives of this Independent Work project were as follows:

- Implementing enhancements to the existing CRS system tracked in the issue tracker and the project's roadmap.
- Fixing bugs in the existing CRS system tracked in the issue tracker.
- Onboarding a new developer (Dhairya) to the project and helping him gain experience in web development.

= Methodology

This section introduces the methodologies in the Independent Work, including the tasks and workflow for designing and implementing the enhancements. For enhancements and bug fixes that are associated with a GitHub issue or PR, the number is linked in parentheses for reference.

== Architecture and Technical Direction

CRS is organized as a monorepo with three main modules. The *Site* module is the browser-facing interface, the *Server* module exposes tRPC procedures and authentication, and the *Service* module owns the domain models, authorization rules, request invariants, and persistence. This makes *Service* a relatively deep module: callers use a small set of request and course operations while their validation, authorization, transactions, and MongoDB queries remain local to one implementation.

Harry's work in this term extended the system at these existing seams instead of introducing parallel paths. The schedule importer is a small adapter inside *Site*, keeping the external schedule away from the server and service interfaces. The invariants of request types remain in *Service* even when the corresponding form already validates them in the browser. The development user is accepted at both authentication seams, while the production guard prevents the bypass from being enabled in a deployed build. @fig-crs-architecture summarizes these relationships and the storage split introduced by the thread review.

#figure(
  placement: none,
  caption: [
    The architecture of CRS and the main seams affected by the summer work. Arrows show application or setup flow; the development-only inputs are placed at the outer edges.
  ],
)[
  #block(inset: 5mm)[
    #set text(size: 9pt)
    #diagram(
      spacing: (7mm, 7mm),
      node((0, 0), [UST Archive\ Parquet], width: 65pt, name: <archive>),
      node((1.5, 0), [`ust-archive`\ adapter], width: 70pt, name: <adapter>),
      node((3, 0), [*Site*\ forms], width: 65pt, name: <site>),
      node((3, 1.5), [*Server*\ tRPC routers], width: 70pt, name: <server>),
      node((3, 3), [*Service*\ models/services], width: 75pt, name: <service>),
      node((2, 4.5), [MongoDB\ documents], width: 70pt, name: <mongodb>),
      node((4, 4.5), [GridFS\ proof files], width: 65pt, name: <gridfs>),

      edge(<archive>, <adapter>, "-|>"),
      edge(<adapter>, <site>, "-|>"),
      edge(<site>, <server>, "<|-|>", [tRPC]),
      edge(<server>, <service>, "-|>"),
      edge(<service>, <mongodb>, "<|-|>"),
      edge(<service>, <gridfs>, "<|-|>"),

      node((4.8, 0), [`CRS_DEV_USER`], width: 75pt, name: <dev-user>),
      node((0.5, 4.5), [`compose.yaml`], width: 70pt, name: <compose>),
      edge(<dev-user>, <site>, "-|>"),
      edge(<dev-user>, <server>, "-|>", bend: -20deg),
      edge(<compose>, <mongodb>, "-|>"),
    )
  ]
] <fig-crs-architecture>

== Thread System (#pr(134))

The _thread system_, introduces a thread-based conversation model for requests, replacing the previous binary request/response model.

In the old model, a request was created once and could receive at most one response (approve or reject with optional remarks) from an instructor. This was restrictive in several ways: a student could not provide additional information on an existing request, an instructor could not ask for clarification or change a decision after submitting it, and there was no built-in notion of cancelling a request or appealing a decision. These limitations were identified as future work (_Conversation System_) in the 2025-26 Winter report.

@fig-thread-before-after contrasts the two interactions on the same kind of request. Before #pr(134), an instructor responded on a separate response page that combined a decision dropdown, free-form remarks, and a submit button. After #pr(134), the request page itself carries an append-only thread and a persistent composer whose actions depend on the viewer's role and the current status of the request.

#figure(
  placement: none,
  caption: [
    Handling a request before and after #pr(134). The upper page shows the legacy response form: a decision dropdown with remarks and a submit button. The lower page shows the thread view with a persistent composer whose actions depend on the role and the current status.
  ]
)[
  #grid(
    columns: 1fr,
    gutter: 4mm,
    align: top,
    [
      #ux-shot("figure/thread-before.png")
    ],
    [
      #ux-shot("figure/thread-after.png")
    ],
  )
] <fig-thread-before-after>

=== Design

The thread system models all activity on a request as an _append-only thread_ of entries stored on the request document, together with a normalized _status_ field that tracks the lifecycle of the request.

The initial design, which introduced the thread-style lifecycle with comments, cancellations, and appeals (commits #commit("78baa84") and #commit("09226b4")), defined four kinds of thread entries: a comment entry, a response entry, a cancel entry, and an appeal entry, with a three-state status (_open_, _resolved_, or _cancelled_). The legacy response router was kept during the migration, forwarding to the new thread-based logic for compatibility.

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

Following the review, the response model was folded into the thread lifecycle (commit #commit("8922590")). This was a major refactor across all three packages of the monorepo (22 files, +1392/-2641 lines), which removed the separate `Response` and `ResponseDecision` models, the legacy response router, and the response-only form, and simplified the model to two kinds of thread entries:

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
- Email notifications for thread updates are _best-effort_: a notification transport failure can no longer reject an already-committed database mutation, which previously could cause duplicate entries or conflicting status changes when a client retried (commit #commit("ea3166f")).
- Legacy, pre-thread request documents are normalized on read into synthetic thread entries, so that the new UI works transparently on existing data.
- A development seed script (`bun run --filter=server seed`) was added to quickly set up a test course and user in the local database (commit #commit("128a0a1")).
- Tests for the request service were reworked to cover thread mutations, status transitions, and legacy normalization.

== Attachments in GridFS

In the second round of review, Harry raised two concerns about the internal design and implementation of the thread system:

1. An adapter layer to keep the old and new schemas in sync is unnecessary and only creates a maintenance burden; the database should be migrated to match the thread schema instead.
2. Because attachments now live on thread comments rather than on the request itself, a request can carry an unbounded number of attachments. Storing them as inline base64 in the document can exceed the maximum size of a MongoDB document, so attachments should be moved to MongoDB GridFS, storing a reference in the thread entries instead of the raw bytes, and the per-file size limit can be increased (for example, to 4 MiB).

In response, the update was implemented and pushed to the pull request itself (commit #commit("9ab5aa7"), with a follow-up fix in #commit("f457689")):

- The `ProofFile` model now stores a GridFS object id together with the size and a SHA-256 hash of the file, instead of inline base64 content; the size and hash are derived server-side from the decoded bytes, the per-file size limit was raised from 2 MiB to 4 MiB and is enforced on the actual content, and the request signature commits to the file content via the stored hash. A separate `ProofUpload` type is used for input, and a `proofs` GridFS bucket was added to the database connections.
- Proof content is fetched on demand by clients through a new `proofContent` query on the server, gated by ownership and class-view authorization. Uploads use a two-phase commit that rolls back partial writes if a later step fails, and the server's body size limit was raised to 64 MiB so that oversized payloads are rejected with a 413 during streaming.
- The legacy adapter layer was dropped entirely: the repository now returns documents as-is with a simplified status guard, and legacy normalization (status values, entry shapes, and the old `details` field rewritten into an opening comment) moved into the migration.
- A one-time, idempotent database migration (`migrateRequests`) rewrites legacy request documents into the thread schema: it converts old response, cancel, and appeal entries into monomorphic comment and status entries, moves inline base64 proof bytes into GridFS, and --- after rewriting --- deletes any GridFS file that no document references, so an interrupted run no longer accumulates orphans (commit #commit("f457689")). Already-migrated documents are skipped, so the migration is safe to re-run.
- The same update also addressed the inline UI review comments: a selection-token guard for asynchronous file reads that clears the previously accepted proof as soon as a new selection starts (including on validation and read failures), composer inputs disabled while a mutation is pending, superseded rows kept at full contrast, dark-mode contrast for the cancelled status, the "Decision" column and filter renamed to "Status", and status actions that attach proof without a remark now rejected explicitly instead of being silently discarded.
- A richer development seed script creates two users (a student and an instructor) and seeds requests covering every lifecycle state (_open_, _approved_, _rejected_, _appealed_, and _cancelled_) with realistic thread entries, using the real request service API.

Deploying the update has a strict ordering --- stop the old server, run the migration once (`cd packages/service && bun run scripts/migrate.ts`), then start the new server --- and a mongodump is recommended beforehand as a precaution. The update was verified by typechecking, linting, and the service test suite (96 tests), and was merged on August 18 after Harry's re-review.

== Automatic Course Schedule Setup (#issue(75), #pr(137))

Creating a course previously required an instructor to enter its title and every section schedule manually. Harry implemented an optional _Import Schedule_ path in the existing course-creation form. Given a term and a course code, a browser-side adapter reads the schedule from HKUST website, selects the latest active course and class records, and converts the title, sections, meeting times, and instructor names into the CRS course model. Manual creation remains available in the same form.

@fig-course-import-entry shows the first step of the change. Before #pr(137), the instructor had to supply the course title and could only create the empty course. After the change, the same dialog retains manual creation but adds _Import Schedule_ after the instructor identifies the course offering. A short guide in the dialog explains what the import supplies and why the instructor email addresses still have to be entered explicitly.

#figure(
  placement: none,
  caption: [
    Course creation before and after #pr(137). The upper dialog supports manual creation only. The lower dialog starts from the same code and term fields, adds _Import Schedule_, and leaves manual creation available as a fallback.
  ]
)[
  #grid(
    columns: 1fr,
    gutter: 4mm,
    align: top,
    [
      #ux-shot("figure/course-creation-before.png")
    ],
    [
      #ux-shot("figure/course-import-step-1.png")
    ],
  )
] <fig-course-import-entry>

The archive does not provide the instructors' HKUST email addresses, which CRS uses as user identifiers. Therefore, the imported schedule is shown for review and the instructor creating the course supplies a validated email address for each imported instructor. After the course is created, CRS creates the corresponding section enrollments and records the imported names as suggestions. Partial enrollment failures are reported without hiding the successfully created course.

@fig-course-import-review shows the second step. The imported title and section meetings are presented before submission, followed by one email field per instructor and the sections to which that instructor will be enrolled. This makes the automatic data visible and correctable before CRS creates the course.

#figure(
  placement: none,
  caption: [
    After importing `COMP 1021` for 2025-26 Spring, CRS previews the title and section meetings and asks for the missing HKUST email of each instructor before creation.
  ]
)[
  #align(center)[
    #image("figure/course-import-step-2.png", width: 65%)
  ]
] <fig-course-import-review>

The external data handling is deliberately localized in a lazy-loaded `ust-archive` adapter. Only the requested course is converted into the CRS model, and the server interface is unchanged. Unit tests cover active-record selection, course conversion, time conversion, section ordering, and normalization of instructor names. Together with typechecking, linting, and a production build, 90 tests passed before #pr(137) was merged on August 18.

== Request Validation and User Experience (#pr(139))

Harry then reviewed the production request and course-administration flows and implemented a combined set of validation and user-interface fixes. The visible changes include a compact Shadcn-style time picker for section and assignment configuration, optimistic updates for the effective-request-type switches, and resetting a request form when changing course makes the selected request type invalid.

=== Date and Time Input

The previous section form delegated time entry directly to the browser's native input. The replacement uses the shared compact time control and normalizes both stored and displayed form values to minute precision. @fig-section-time-picker compares the same `09:00`--`10:20` meeting in both interfaces.

#figure(
  placement: none,
  caption: [
    Section scheduling before and after #pr(139). The upper form delegates the two values to the browser's native time fields; the lower form uses the shared compact control and presents both values consistently in `HH:mm` format.
  ]
)[
  #grid(
    columns: 1fr,
    gutter: 4mm,
    align: top,
    [
      #ux-shot("figure/time-picker-before.png")
    ],
    [
      #ux-shot("figure/time-picker-after.png")
    ],
  )
] <fig-section-time-picker>

The assignment form uses the same control and separates the date and time consistently for both the due date and the latest extension. A newly selected date defaults to `23:59`, avoiding an accidental start-of-day deadline. @fig-assignment-time-picker shows that the maximum-extension field is no longer a single opaque date-time button.

#figure(
  placement: none,
  caption: [
    Assignment configuration before and after #pr(139). The upper form mixes a separate due-time field with a single date-time button for the latest extension. The lower form aligns both rows and makes each `23:59` value visible.
  ]
)[
  #grid(
    columns: 1fr,
    gutter: 4mm,
    align: top,
    [
      #ux-shot("figure/assignment-time-before.png")
    ],
    [
      #ux-shot("figure/assignment-time-after.png")
    ],
  )
] <fig-assignment-time-picker>

=== Request-Type Controls

The effective request types were previously implicit in the headings of the sections and assignments they affected. The revised course-administration page exposes them as a stable three-column control at the top of the page, as shown in @fig-effective-request-types. Each checkbox updates optimistically, so it remains in the chosen state while the mutation is saved instead of blinking back to the stale server value.

#figure(
  placement: none,
  caption: [
    Course administration before and after #pr(139). In the upper view, the effective request types are only implied by the configuration headings. The lower view makes them explicit with three stable controls at the top of the page.
  ]
)[
  #grid(
    columns: 1fr,
    gutter: 4mm,
    align: top,
    [
      #ux-shot("figure/request-types-before.png", width: 90%)
    ],
    [
      #ux-shot("figure/request-types-after.png", width: 90%)
    ],
  )
] <fig-effective-request-types>

=== Course-Sensitive Request Form

Changing the selected course used to retain the request type and its fields even when the new course disabled that type. @fig-request-course-reset reproduces the problem with _Deadline Extension_ and a course that enables only _Swap Section_. The fixed form clears the invalid selection, removes its stale fields, and offers only the request types enabled by the new course.

#figure(
  placement: none,
  caption: [
    Changing to a course that enables only _Swap Section_. In the upper form, the invalid _Deadline Extension_ selection and its fields remain. In the lower form, the selection is cleared and the open menu contains only the valid request type.
  ]
)[
  #grid(
    columns: 1fr,
    gutter: 4mm,
    align: top,
    [
      #ux-shot("figure/request-course-reset-before.png", width: 90%)
    ],
    [
      #ux-shot("figure/request-course-reset-after.png", width: 90%)
    ],
  )
] <fig-request-course-reset>

More importantly, the corresponding invariants are enforced in *Service* instead of relying on the browser form. A request type must be enabled for the course; swap-section and absent-from-section requests must refer to existing sections and dates on which those sections actually meet; and a deadline extension must fall between the assignment due time and its configured maximum extension. The request-specific checks remain with their respective request models, while the request service supplies the course context and authorization.

The test suite was expanded to cover valid submissions and each failure mode for all current request types. The change passed typechecking, a production site build, and 96 service tests before #pr(139) was merged on August 19.

== Local Development Environment (#issue(67), #pr(140))

Local development previously required contributors to assemble MongoDB manually and complete Microsoft authentication before they could exercise an authenticated workflow. Harry added a canonical `compose.yaml` that runs a persistent, loopback-only MongoDB 8.0 replica set, while keeping *Site* and *Server* on the host for a short edit--run cycle.

An optional `CRS_DEV_USER` provides an explicit authentication adapter at the existing site and server seams. The value must be a valid email, must match on both sides, and is rejected whenever `NODE_ENV` is `production`. The seed command accepts the same email and creates the development user and test course, making the setup reproducible without weakening production authentication. The workflow is documented in the README, environment examples, and the agent instructions.

The change passed the full 94-test suite, typechecking, linting, a production site build, Compose validation, and a live MongoDB smoke test that reached a writable replica-set primary. It was merged as #pr(140) on August 19.

== Technical Leadership and Project Coordination

Besides implementing the three enhancements above, Harry acted as the lead developer and project manager. After discussing the summer requirements with Desmond, he divided the planned work among the developers, adjusted the scope of the exam-appeal task when its routing requirements became substantially larger, invited new developers into the organization, and clarified that the thread feature should be an append-only update system rather than direct editing of submitted requests.

The work was managed through milestones rather than a single final hand-off. Harry checked progress in July, set an early-August target for opening pull requests so that review time remained before enrollment, confirmed the final report deadline with Desmond, created the shared report branch, and took over the schedule-import task when it became unlikely to finish before the deadline. He also specified the durable, idempotent notification follow-up (#issue(136)) so that failed email delivery can be retried instead of silently lost.

The thread-system review was the main technical coordination task. The first round changed both the interaction model and the domain model; the second required GridFS and an explicit migration. The inline review then covered asynchronous file-selection races, edits during pending mutations, proof-only status actions, dark-mode contrast, readable audit history, and consistent status terminology. These findings were resolved in #pr(134) before it was merged.

== CI Build Fix (#issue(68), #pr(129))

The first contribution of this term, and the starting point for getting familiar with the project, was a fix for issue #issue(68), _CI Build Fails_, opened by Harry. The CI build failed when the author of a pull request did not have write permission to the repository: the Docker login step of the build workflow attempted to authenticate on every event, including pull requests from forks, where the required secrets are not available.

The fix (commit #commit("d52cec2e"), merged as #pr(129)) gates the Docker login step and the push/provenance options of the build step on push events to the `main` branch only. Images are still built for every pull request, but they are no longer pushed to the registry, so the build succeeds for fork-based pull requests.

== Onboarding New Developers

As part of the project, significant effort was dedicated to onboarding the new developer, Dhairya, and helping him gain experience in web development. The experience can be organized into three phases: Initial Learning, Exploration, and Contribution.

=== Dhairya's Experience

/ Phase 1\: Initial Learning:

  To get familiar with the project, Dhairya started with the commit #commit("d52cec2e"), which closed issue #issue(68) by fixing the CI build for pull requests from contributors without write permission (#pr(129)). Working through this issue required understanding how the project is built, how its CI workflow is structured, and how contributions flow from a fork through a pull request into the main repository.

/ Phase 2\: Exploration:

  Next, Dhairya set up the local development environment and hosted it locally for testing, so that he could run the system end to end and experiment with changes safely. He then read through the code line by line, following a request from the site form through the server router into the service layer and the database. To make this workflow faster and repeatable, he also wrote a seeding script that bootstraps a test course and users into the local database, which doubled as a hands-on way to understand how CRS works under the hood.

/ Phase 3\: Contribution:

  In this phase, Dhairya implemented the main deliverable of the term, the thread system (#pr(134)). The work started with the initial thread-style lifecycle and its UI (commits #commit("78baa84") and #commit("09226b4")), followed by fixes and a development seed script, and was reviewed by Harry in two rounds. Addressing the design review required a major refactor that folded the response model into the thread lifecycle (commit #commit("8922590")), simplifying the data model to monomorphic comment and status entries with a five-state lifecycle, and reworking the request thread UI accordingly. Addressing the internal design review led to the update that moves proof attachments into GridFS and migrates the database to the thread schema (commits #commit("9ab5aa7") and #commit("f457689")). Throughout the review process, Dhairya also triaged the findings of GitHub's Copilot code review, fixing the valid findings (for example, an unstable table sort comparator) and evaluating the false positives. The pull request was merged on August 18, completing the main deliverable of the term.

== Request Form UX Improvements (#pr(108), #pr(119))

Two Spring-term fixes delivered by Simon improved how dates are presented and validated in the Site package. Assessment due time (#pr(108), resolving #issue(99)). When instructors added or edited assignments, the due-date controls did not reliably map the chosen calendar month and day onto existing assignment objects, and secondary fields could be filled before a due date was set. The change requires selecting the due date first, then maps dates to the correct month and day for existing objects, with checking logic aligned to that order. Deadline-extension calendar default (#pr(119), resolving #issue(49)). The deadline-extension request form opened the date picker on a default month that often did not match the assignment under request, forcing extra navigation. The form now defaults the calendar to the relevant month for the selected assignment, so students can pick an extension date with less friction.Both changes sit in the Site forms layer and complement the later service-side validation work in #pr(139) by improving the interactive path before submission.

== About Page and Third-party Licenses (#pr(142))

To make the public site self-describing and to support open-source attribution, an About page was added by Simon under the Site app router.The page is authored primarily in MDX and rendered through _Next.js_ MDX support (`@next/mdx`, `remark-gfm`), with shared visual styling via `mdx-components.tsx` so headings, links, and code blocks follow the same theme as the rest of the site. Content covers an introduction to CRS, the project MIT license, optional short notes on developers, and a link to the GitHub repository. For third-party packages, a root `licenses` script invokes `generate-license-file` across the monorepo package manifests and writes `packages/site/public/THIRD-PARTY-LICENSES.txt`. The About page exposes a download link to that file. Under Bun workspaces the generated list may still be incomplete relative to the full production dependency set; the page therefore states the main stack explicitly and treats the generated file as a best-effort notice to be refreshed when dependencies change (`bun run licenses`).

= Planning

The work on the thread system was planned in several stages, which are reflected in the commit history of #pr(134) and its review history:  

+ *Familiarization and First Contribution* (June). Dhairya studied the codebase starting from the CI build fix (commit #commit("d52cec2e"), #pr(129), closing #issue(68)) and set up his local development environment with the seed scripts.

+ *Initial Implementation* (July). The thread-style request lifecycle was implemented across the service and server packages together with the request thread view and composer in the site package (commits #commit("78baa84") and #commit("09226b4")), followed by fixes and a development seed script (commits #commit("4956159"), #commit("128a0a1"), and #commit("338a8b9")), and the branch was prepared for review through a fork-internal merge.

+ *Review and Refactor* (August). Two review rounds from Harry led to the fix commits addressing review findings (#commit("ea3166f"), #commit("ff9700c")) and the major refactor that folded the response model into the thread lifecycle (#commit("8922590")), followed by UI improvements for status changes (#commit("cbd2c86")).

+ *Follow-up and Integration* (August). The remaining review comments were addressed directly in the pull request: the GridFS attachments update and the database migration (commit #commit("9ab5aa7")), followed by a fix for stale proof selection and orphaned GridFS sweeping (#commit("f457689")). Harry completed the final review, merged #pr(134), and then merged the schedule import, request validation and user-interface fixes, and local development environment (#pr(137), #pr(139), #pr(140)).

= Conclusion

In this Independent Work project, the team continued the even further development of CRS. The main deliverable of the term was the thread system (#pr(134)), which replaced the binary request--response model with an append-only conversation thread, monomorphic comment and status entries, and a normalized five-state request lifecycle. The review also moved proof attachments into GridFS and replaced compatibility adapters with an explicit database migration. The completed system was merged on August 18.

For Dhairya, this term was also a first experience of working on a real-world codebase with an active upstream and a proper review culture. Starting from a small CI fix (commit #commit("d52cec2e")), he became comfortable with the system by reading the code line by line and hosting it locally for testing, and went on to design, implement, and iterate on the thread system through two rounds of detailed code review, learning a great deal about full-stack web development, data modeling, and maintaining backward compatibility along the way.

Harry's additional work reduced the manual effort of setting up courses, moved request-type invariants into the service layer, and made the local environment reproducible for contributors. Future work includes deploying the thread migration with its strict ordering, completing the assignment-appeal and durable-notification work, and gathering feedback from students and instructors on the new conversation workflow.

On the Site side, Simon’s form UX fixes improved date handling for assignments and deadline extensions, and the About page made project purpose, licensing, and repository links visible to end users while providing a path to third-party license notices.

== Acknowledgements

We would like to extend our sincere gratitude to our advisor, Dr. Yau Chat Tsoi, whose support and guidance have been invaluable to us.

We (except for Harry Li himself!) would also like to thank Harry Li, the lead developer of CRS, for his detailed code reviews and guidance throughout the development of the thread system.
