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
  show strong: it => {
    show emph: set text(font: "Libertinus Serif")
    it
  }

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
    CSE Request System
  ],
  authors: (
    (
      name: "DING, Yuyi",
      email: "ydingbj@connect.ust.hk",
      affiliation: [
      ]
    ),
    (
      name: "LI, Yu Hong Harry",
      email: "yhliaf@connect.ust.hk",
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
  abstract: lorem(120)
)

// Automatic figure placement, 
// allowing figures to float to the most appropriate location.
#set figure(placement: auto)

// Link styling
#show link: underline
#show link: set text(fill: navy)

#import "@preview/fletcher:0.5.8": diagram, node, edge

= Introduction

This report is for the Independent Work project _CSE Request System_, abbreviated *CRS*. This project was developed by Yuyi Ding and Harry Li under the supervision of Dr. Yau Chat Tsoi.

== Overview

CRS is a system to streamline and manage students' course administrative requests for courses offered by the Computer Science and Engineering (CSE) department, such as swapping lab sections, excused absence from lab sessions, extending assignment deadlines, and appealing assignment grades. The system aims to provide a user-friendly interface for both students and instructors to facilitate efficient request--response handling and record-keeping.

The system is available at https://crs.cse.ust.hk/. Anyone with an HKUST account ending with either `@connect.ust.hk` or `@ust.hk` can access the system. However, only those who are granted access to a specific course can operate the system.

#figure(
  placement: bottom,
  caption: [
    A screenshot of CRS' main interface (the students' view).
  ]
)[
  #block(
    inset: (x: 1cm, y: 0.5cm),
    image("figure/crs-students-view.png")
  )
]

== Objectives

We gathered the current pain points and requirements from both students and instructors through discussion. Based on the information collected, we defined the following functional objectives for the CRS project:

+ CRS should provide an interface that allows students to submit various types of requests to the course, including but not limited to requests regarding lab sections, assignments, exams, and grades. 

+ CRS should provide an interface that allows instructors to view and manage the requests submitted by students, and allows instructors to submit responses to requests by either approving or rejecting them, along with optional comments.

+ CRS' workflow should be user-friendly. It should not impose additional overhead on students and instructors; instead, it should streamline the process. Therefore, the workflow should be at least as efficient as the current manual process through email communication.

+ CRS should provide an interface, the admin panel, that allows course administrators to manage and configure the system, including managing and configuring the enrollment of students and instructors in the course, the types of requests that are supported by the system, the concrete setup of each type of request (e.g., the available lab sections, the deadlines and maximum extension time for assignments).

All of the above objectives have been implemented in the first release of the system.

In later project meetings, we further discovered the requirement that, at the beginning of each semester, there should be an administrator account that initializes the system for different courses, such as creating the courses and assigning initial instructors to the courses. This objective will be implemented in future releases of the system.

== Literature Survey

The current process of handling students' course administrative requests is highly customized and ad hoc. We did not find any existing system that provides a complete solution to this problem. However, we did find some existing systems that provide solutions to similar problems.

The _class enrollment request system_ as part of the HKUST Student Center provides a solution to students' requests regarding course/class enrollment. The types of requests supported by the system include _Requisite Waiver_, _Cross-career Enrollment_, _Instructor's Consent_ (to enroll in some courses that require special approval), _Credit Overload_, and _Drop Required Course_. CRS is inspired by this system to some extent, including the UI/UX and the workflow design.

@fig-enrollment-request-system-1 and @fig-enrollment-request-system-2 show the interface of the class enrollment request system. Although the exact UI/UX design of CRS is different from this system, the use of design elements, such as the table listing requests and the form for submitting new requests, is similar.

The workflow of CRS is also similar to that of the class enrollment request system. In both systems, students submit requests through a web interface. Both systems redirect the requests to the appropriate instructors for their review and response, and then notify the students of the response. Both systems notify users through email to keep them updated on the status, and to keep a record of the requests and responses.

Nevertheless, there are also some important improvements of CRS over the class enrollment request system. The two most important ones are as follows:

+ The request types in the class enrollment request system are _isomorphic;_ that is, all of them have the same structure and form fields. Most special information required by different request types is collected through a generic text area field, which is likely to lead to incomplete or ambiguous information, especially for new students. In contrast, the request types in CRS are _heterogeneous;_ that is, different request types can have different structures and form fields. This allows CRS to collect more complete, specific, and precise information for each request type.

+ The conversation of requests in the class enrollment request system is limited to the student and the instructor. Although this is sufficient for the case of class enrollment, it is not sufficient for complex course administrative requests, which may involve multiple instructors and teaching assistants. In contrast, CRS supports having multiple participants in the conversation of a request, including one student who submits the request, possibly multiple instructors who are eligible to view and submit responses, and possibly multiple teaching assistants who are eligible to view requests but not submit responses. This makes CRS suitable for complex scenarios in which multiple instructors and teaching assistants are involved.

Other improvements include, for example, the better and more modern UI/UX design of CRS, the support for email notifications that notify involved students, instructors, and teaching assistants, and the support for detailed management and configuration of each request type through the admin panel.

#figure(
  caption: [
    A screenshot of the HKUST class enrollment request system. It shows the main interface that lists the existing requests.
  ]
)[
  #image("figure/class-enrollment-request-system-1.png")
] <fig-enrollment-request-system-1>

#figure(
  caption: [
    A screenshot of the HKUST class enrollment request system. It shows the form for submitting new requests.
  ]
)[
  #image("figure/class-enrollment-request-system-2.png")
] <fig-enrollment-request-system-2>

= Methodology

We want to uphold the following goals in the design and implementation of CRS:

- The development of CRS should follow the best practices in software engineering.
  - It should not be an ad hoc effort that produces a one-off solution.

- The development of CRS should follow modern principles.
  - This is beneficial both for system development and for our learning experience.

- The development of CRS should be open-source.
  - The system's security should not rely on the obscurity of its source code.
  - The system can become a future reference for similar systems.
  - This also forces us to maintain reasonably clear documentation.

Based on the above goals, the system was developed using *TypeScript* #footnote[https://www.typescriptlang.org/] as the main programming language. The tech stack includes *Bun* #footnote[https://bun.sh/] as the runtime and package manager, *Zod* #footnote[https://zod.dev/] as the data modelling library, *tRPC* #footnote[https://trpc.io/] as the frontend--backend communication protocol library, *MongoDB* #footnote[https://www.mongodb.com/] as the persistent data storage, and *React* #footnote[https://react.dev/] with *Next.js* #footnote[https://nextjs.org/], *shadcn/ui* #footnote[https://ui.shadcn.com/], and *Tailwind CSS* #footnote[https://tailwindcss.com/] as the frontend development stack.

The source code of CRS is available on GitHub #underline[HKUST-CRS/crs] #footnote[https://github.com/HKUST-CRS/crs], licensed under the MIT License.

== Design

#quote(block: true)[
  An important development goal of CRS is to follow the best practices and modern principles in software engineering. 
]

We chose TypeScript as the main programming language. By leveraging TypeScript's powerful type system, we believe it is easier to define complex data models --- especially complex form models --- and to preserve runtime type safety in communication between the backend and the frontend. To share a single set of data models across the backend and the frontend, we developed both in TypeScript and organized them in the same Git repository as a _monorepo_ #footnote[https://bun.com/guides/install/workspaces], which allows different parts of the system to cross-reference each other while preserving modularity.

The system is organized into three main modules (referred to as _packages_ in JavaScript terms): 

/ Service: This package is the basis of the system. It defines the data models of the system, including the schemas of requests, responses, users, courses, and sections. It also provides an implementation of the data models and business logic of the system, including the core request--response logic (with authorization support), the notification logic, and the admin panel logic. This package does not depend on any specific backend or frontend framework, and is designed to be used by the other two packages.

/ Server: This package defines the backend _server_ of the system. It abstracts over concrete Internet protocols using a technique called _Remote Procedure Call_ (RPC), which preserves type safety naturally without manually serializing/deserializing data. It also provides the authentication logic that allows users to access the system via their HKUST account.

/ Site: This package defines the frontend web#emph[site] of the system. It utilizes popular frameworks to provide a modern and user-friendly interface.

@fig-crs-architecture illustrates the relationship between the modules and libraries.

#figure(
  caption: [
    The high-level architecture of CRS, including the three main modules: *Service*, *Server*, and *Site*. The dashed lines represent dependency relationships. The dotted line represents user interaction. The solid line represents communication between *Server* and *Site* via the Internet.
  ],
)[
  #block(inset: 5mm)[
    #diagram(
      spacing: (10mm, 10mm), // wide columns, narrow rows
      node((0, 0), [Zod]),
      node((0, 1), [MongoDB]),
      node((2, 0.5), [*Service*]),
      edge((0, 0), (2, 0.5), "<--",),
      edge((0, 1), (2, 0.5), "<--",),

      node((1, 2), [*Server*]),
      node((3, 2), [*Site*]),
      edge((1, 2), (2, 0.5), "-->"),
      edge((3, 2), (2, 0.5), "-->"),

      edge((1, 2), (3, 2), "<|-|>", [tRPC]),

      node((0, 3.5), [React]),
      node((1, 3.5), [Next.js]),
      node((2, 3.5), [shad/cn]),
      node((3, 3.5), [Tailwind CSS]),
      edge((0, 3.5), (3, 2), "<--"),
      edge((1, 3.5), (3, 2), "<--"),
      edge((2, 3.5), (3, 2), "<--"),
      edge((3, 3.5), (3, 2), "<--"),

      node((4, 0), [CSE Admins], stroke: none),
      node((4, 1), [Students], stroke: none),
      node((4, 2), [Instructors], stroke: none),
      node((4, 3), [Teaching Assistants], stroke: none),
      edge((3, 2), (4, 0), "..", bend: 30deg),
      edge((3, 2), (4, 1), "..", bend: 15deg),
      edge((3, 2), (4, 2), "..", bend: 0deg),
      edge((3, 2), (4, 3), "..", bend: -15deg),
    )
  ]
] <fig-crs-architecture>

== Implementation

=== Service

The service module has four major parts: `db`, `models`, `repos`, and `lib`.

/ `db`: 

  This part provides utility functions for connecting to the database and creating indexes. They are used in both testing and production. In addition, a type for the database collections is defined here. Later parts use this type to access the database in a type-safe way, without repeating boilerplate such as connecting to the database and retrieving collection handles.

/ `models`: 

  This part defines all data models used across the system. The three main models are _user_, _course_, and _request_. The _user_ and _course_ models are kept simple, following the data format in the ITSO system. For example, a user's ITSO email is used as their unique ID, and terms are denoted using a 4-digit code --- the first two digits denote the academic year, and the last two digits denote the term (Fall, Winter, Spring, and Summer). For instance, `2510` denotes 2025-26 Fall. In this way, data sharing between CRS and the ITSO system can be done more smoothly.

  The _request_ model is more complex. All requests are expected to share some common information (e.g., request type, status, and timestamps), while different request types may contain different fields. To provide a unified request interface while allowing new request types to be added in the future, we first define a `BaseRequest` schema that contains common request information. Specific request types, such as `SwapSectionRequest` and `DeadlineExtensionRequest`, extend this base schema with additional fields. Finally, we define a discriminated union `Request` schema by combining all request types.

/ `repos`: 

  This layer implements most of the system's logic without considering authorization. It interacts with the database directly (via queries) to implement operations such as retrieving requests and creating responses. All repos are implemented in a modular way so they can be easily reused by other repos or layers in the _service_ module.

/ `lib`: 

  This layer is built on top of the `repos` layer and is intended to be used directly by the `server` module. It implements authorization checks for different user roles, as well as a notification service. Authorization is enforced via two helper functions, `assertCourseRole` and `assertClassRole`, whose arguments are set to different values for different purposes. After verifying permissions, the corresponding underlying `repos` are called.

In the initial design of the system, authorization was done in the `server` module. The `service` module only contained the `repos` layer, which was named `lib` at that time. However, we later decided to move authorization into the `service` module for the following reasons:

- The `service` module is supposed to contain all core logic of the system, which means that public functions in the module should encapsulate the full logic, including authorization. This ensures that changing the backend framework from `tRPC` to something else will not affect the permission system, which is considered a better modular design.
- Putting authorization and other logic together in the `service` module makes it easier to write unit tests, where we care not only about the correctness of database interactions, but also about comprehensive coverage of permission cases.

Moreover, the `repos` and `lib` layers are intentionally separated. This keeps the organization simpler and cleaner, and also allows internal components to call `repos` directly without going through authorization.

@fig-service-structure illustrates the relationship of service modules.

#figure(
  caption: [
    The internal architecture of the *Service* package.
  ],
)[
  #block(inset: 5mm)[
    #diagram(
      spacing: (9mm, 6mm),

      node((-0.7, 1.5), [MongoDB], name: <mongodb>),
      node((-0.7, 2.5), [Zod], name: <zod>),
      node((0.5, 1.5), `db`, stroke: 1pt, name: <dbconn>),
      node((0.5, 2.5), `models`, stroke: 1pt, name: <models>),

      edge(<mongodb>, <dbconn>, "<-"),
      edge(<zod>, <models>, "<-"),
      edge(<models>, <dbconn>, "<--"),

      let repoNode = (idx, label) => node(idx, label, width: 75pt, stroke: 1pt),

      repoNode((2, 0.5), `UserRepo`),
      repoNode((2, 1.5), `CourseRepo`),
      repoNode((2, 2.5), `RequestRepo`),
      node(enclose: ((2, 0.5), (2, 1.5), (2, 2.5)), stroke: black, inset: 10pt, snap: false, name: <repos>),
      node((2, 3.5), `repos`),

      edge(<dbconn>, (2, 0.5), "<--"),
      edge(<dbconn>, (2, 1.5), "<--"),
      edge(<dbconn>, (2, 2.5), "<--"),

      let serviceNode = (idx, label) => node(idx, label, width: 95pt, stroke: 1pt),

      serviceNode((4, 0), `UserService`),
      serviceNode((4, 1), `CourseService`),
      serviceNode((4, 2), `RequestService`),
      node((4, 3), `NotificationService`, stroke: 1pt),
      node(enclose: ((4, 0), (4, 1), (4, 2), (4, 3)), stroke: black, inset: 10pt, snap: false, name: <service>),
      node((4, 4), `lib`),

      edge(<repos>, (4, 0), "<--"),
      edge(<repos>, (4, 1), "<--"),
      edge(<repos>, (4, 2), "<--"),
      edge(<repos>, (4, 3), "<--"),

      node((5.2, 1.5), [(Server)]),
      edge(<service>, (5.2, 1.5), "<.."),
    )
  ]
] <fig-service-structure>

=== Server

=== Site

== Testing

Testing is an essential part of the software development lifecycle. It helps ensure the correctness, reliability, and robustness of the system. We performed unit testing and integration testing on the *Service* package, and we planned to perform system testing on the whole system, including the *Server* and *Site* packages, in the future.

=== Service

We implemented comprehensive tests using Bun's test framework. In tests, service instances are created similarly to the production environment. The key difference is that the tests use an in-memory MongoDB server rather than an external one. The tests cover all major APIs in the `lib` layer, including creating requests, responding to requests, and managing courses and users. Different user roles and permission cases are also tested to ensure users cannot access unauthorized data.

=== Server and Site

Because the *Server* package is essentially a thin wrapper around the *Service* package that exposes its functionality via tRPC, we did not perform separate unit or integration testing on the *Server* package. The *Site* package is primarily a user interface, so unit and integration testing are less suitable there as well. We planned to perform system testing using an automated browser testing framework to test the *Server* and *Site* packages together in the future.

== Evaluation

We evaluated the system through demonstrations at the end of each development iteration for our supervisor, Dr. Desmond Tsoi, and, when appropriate, invited guests. These demonstrations took the form of face-to-face meetings, where we showcased the system's functionality and workflow and collected feedback from the attendees.

For details of the demonstration sessions, please refer to @sec-planning.

= Planning <sec-planning>

We planned the project's first iteration in several stages:

+ *Requirement Capturing*. This stage involved capturing the requirements of the system from our prospective users. We captured the instructor-side requirements from our supervisor, Dr. Desmond Tsoi, and the student-side requirements from ourselves as students. This stage lasted about one week (Aug 24--Aug 31). #footnote[All dates mentioned in this section are in 2025.]

+ *Design and Analysis.* This stage involved designing the architecture of the system and analyzing the feasibility of the design choices. We carried out this stage by creating prototypes for each module (*Service*, *Server*, and *Site*) and performing peer review on them. This stage, together with the next stage, lasted about one month (Sep 1--Sep 30).

+ *Implementation and Testing.* This stage involved implementing the system based on the design and analysis from the previous stage. We carried out this stage through iterative development: we implemented a feature, tested it, and then refined it based on feedback.

After the first iteration, we were ready to deliver the first release of the system, which contained all the core functionalities based on the requirements captured in the first stage. We then deployed the system to a production server for real-world usage and evaluation. We conducted a software evaluation on Oct 9 to demonstrate the core system functionalities to our supervisor, Dr. Desmond Tsoi. The feedback collected from the evaluation was positive, and a few suggestions were made for future improvements.

Next, in the second iteration, we planned to improve the core functionalities based on feedback from our supervisor and potential users, and to implement additional features that were not included in the first iteration due to time constraints. The tasks include:

+ *Admin Panel.* There should be a panel that allows course instructors to manage and configure the system, including managing and configuring the enrollment of students, instructors, and teaching assistants in the course, the types of requests that are supported by the system, and the concrete setup of each type of request (e.g., the available lab sections, the deadlines, and the maximum extension time for assignments).

+ *Email Refinement.* The email notification system should be refined to provide more informative content, such as a summary of the request and response, and to improve the email formatting.

+ *Permission System.* The permission system should be improved to support more fine-grained access control. Users who do not have permission to view certain requests should not be able to see them in the request list and should not be able to access them via direct URL access. Users who do not have permission to submit responses to certain requests should not be able to submit responses to them.

All tasks in the second iteration were completed. Development lasted about two months (Oct 1--Nov 30). In the meantime, we were also fixing minor bugs and improving the UI/UX design.

We conducted a software evaluation near the end of the second iteration on Nov 27. The evaluation involved demonstrating the system to our supervisor, Dr. Desmond Tsoi, and a few invited guests. The feedback collected from the evaluation was positive, and a few suggestions were made for future improvements. We concluded that the system had met the initial objectives and was ready for its first production deployment.

There are still feature requests and improvement suggestions recorded for future releases of the system. We plan to continue the development of the system in the future.

The feature requests and improvement suggestions of the system are tracked in GitHub Issues: https://github.com/HKUST-CRS/crs/issues. The development progress and history of the system are recorded in GitHub Pull Requests: https://github.com/HKUST-CRS/crs/pulls.

The project development plan is recorded and maintained in GitHub Projects: https://github.com/orgs/HKUST-CRS/projects/2.

= Conclusion

== Acknowledgements

We would like to extend our sincere gratitude to our advisor, Dr. Yau Chat Tsoi, whose support and guidance have been fundamental to us.

We would also like to thank Mr. Henry Wong, whose support on the server setup, including the setup of the virtual machine, project account, domain name, and email server, has been invaluable to the success of our project.

Finally, we thank Tsz Chou Chui (Sunny) and Wai Hin Lam (Kris) for their suggestions and feedback during the development of this project.