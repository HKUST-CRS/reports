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
    Further Development of CRS
  ],
  authors: (
    (
      name: "LI, Yu Hong Harry",
      email: "yhliaf@connect.ust.hk",
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
    #lorem(200)
  ]
)

// Automatic figure placement, 
// allowing figures to float to the most appropriate location.
#set figure(placement: auto)

// Link styling
#show link: underline
#show link: set text(fill: navy)

#import "@preview/fletcher:0.5.8": diagram, node, edge

= Introduction

This report is for the Independent Work project _Further Development of CRS_, where CRS is an abbreviation for the _CSE Request System_. This project was developed by LI, Yu Hong Harry, WAN, Yiu Wai (Simon), and WAN, Chi Chung (Roger) under the supervision of Dr. Yau Chat Tsoi (Desmond).

== Overview

CRS is a system to streamline and manage students' course administrative requests for courses offered by the Computer Science and Engineering (CSE) department, such as swapping lab sections, excused absence from lab sessions, extending assignment deadlines, and appealing assignment grades. The system aims to provide a user-friendly interface for both students and instructors to facilitate efficient request--response handling and record-keeping.

Continuing the last Independent Work project that developed the initial version of CRS, this Independent Work project focused on the further development of CRS. Two new developers, Simon and Roger, joined the team. They are new to the project and worked alongside Harry, who was one of the original developers of CRS. 

Since Simon and Roger are new to the project and have no prior experience with web development, a significant portion of the project involved familiarizing themselves with web development technologies and practices. This included learning about front-end and back-end development.

The objectives of this Independent Work project were as follows:

- Implementing enhancements to the existing CRS system tracked in the issue tracker.
- Fixing bugs in the existing CRS system tracked in the issue tracker.
- Onboarding new developers (Simon and Roger) to the project and helping them gain experience in web development.

The objectives were successfully achieved, with several enhancements and bug fixes implemented in the CRS system. Additionally, Simon and Roger gained valuable experience in web development through their involvement in the project.

= Methodology

== Enhancements

== Bugs

== Onboarding New Developers

As part of the project, significant effort was dedicated to onboarding the new developers, Simon and Roger. This involved several activities. Initially, Harry provided an overview of the CRS system, and provided a set of TODOs for Simon and Roger to get started.

- Run the project locally by cloning the repository and setting up the environment.
- Study Node.js and Bun. 
- Study TypeScript. 
- Study HTTP protocol. 
- Study HTML and CSS. 

Both Simon and Roger actively engaged in these activities, which helped them gain a foundational understanding of web developement. In addition, we set up a weekly report schedule to track their progress and address challenges they encountered.

=== Simon's Experience

/ 1st week: 
  
  Simon studied the key differences between TypeScript and JavaScript, focusing on static versus dynamic type checking. TypeScript detects errors such as type mismatches, spelling mistakes, and undefined properties at compile time or during development, while JavaScript identifies them only at runtime. Bun was explored as an all-in-one JavaScript/TypeScript toolkit that executes `.ts` files directly without generating `.js` files and supports npm-compatible module installation.

  Simon also learned Docker fundamentals and applied them to resolve a local CRS project issue caused by a missing MongoDB instance. Running MongoDB via a Docker container enabled successful execution, though a minor hydration mismatch warning remains. Fundamental HTML and CSS syntax was also revised to reinforce front-end basics.

/ 2nd week: 
  
  Simon continued advancing his TypeScript knowledge by exploring type constraints, interfaces, and their integration with functions, with a particular emphasis on web development scenarios. He also reviewed core JavaScript syntax, its interaction with the browser environment, fundamental HTTP methods (e.g., GET, POST), and common status codes (e.g., 200, 404). Additionally, Simon revised essential Git commands (e.g., init, branch, push) and their workflow with GitHub for effective version control.

  In practice, Simon tried to address a dark mode display inconsistency by applying theme-adaptive variables across the relevant elements. This change resolved the visual bug in the local display. 

/ 3rd week:

  Simon advanced his TypeScript proficiency by studying type narrowing techniques and generics, gaining a deeper understanding of how to create flexible and type-safe code structures. He also explored callback functions, Promises, and asynchronous functions in both JavaScript and TypeScript, focusing on handling asynchronous operations effectively in modern web development.

  In practice, Simon experimented with TypeScript by writing simple functions and using live-server to run them locally, observing their interactions with the browser environment. He then progressed to building a practice meeting arrangement web application by following a tutorial, incorporating TypeScript, React, Tailwind CSS, Next.js, shadcn/ui, basic routing concepts, and database integration with Neon DB for data storage and retrieval. Throughout these projects, he adopted GitHub Workflow to simulate an actual development process, uploading all work to GitHub for version control and collaboration. This ongoing project specifically serves to deepen his practical understanding of the components and workflows used in the actual CRS project.

/ 4th week:

  Simon was a bit sick this week, so he did not do much study. He tried to fix a visual bug in the CRS system, and tried to study `.map`, `.filter`, and `.reduce` functions in JavaScript.

=== Roger's Experience
/ 1st week:

  Roger studied the core features of Node.js to gain a deeper understanding of the CRS framework's architecture. Given that Javascript orginally could only be excuted with browser, Node.js is a JavaScript runtime environment enables the execution of JavaScript on a local machine, facilitating server-side logic and development workflows.
  
  During this process, he explored the basic concept of Modules in Node.js by following online tutorial, which are crucial for maintaining a clean and scalable codebase. He learned how modularity allows developers to split code into distinct files using ES Modules (import/export), ensuring that different parts of the system, such as API routes and database logic, remain decoupled and reusable.
  
  Although Roger initially explored Node.js to solve the "how-to-run" issues, he found that extensive knowledge of module systems was not required for the initial setup.

  Furthermore, Roger began learning TypeScript, a typed superset of JavaScript. Unlike JavaScript, TypeScript enforces Static Type Checking, catching type mismatches or spelling errors during the development phase before the code is compiled into .js files. This approach greatly enhances long-term maintainability; by strictly defining data structures and variable types, developers can prevent a wide range of runtime errors, making the CRS project more robust and easier for team members to collaborate on and refactor.

/ 2nd week:




/ 3rd week:

  Roger decide to focus on the dark theme display issue of Dark Theme Mode posted in project's Github repo.

  Roger's progress during this period can be broken down into three phases: configuration, understanding, and study.

  In the first phase, Roger configured the development environment with Simon's guidance. This included learning and setting up GitHub, Bun, Docker, and MongoDB. Roger can now successfully run the system on a localhost using dummy data.

  In the second phase, Roger started the codebase exploration of the project and analyzed Simon's Pull Requests to understand the project's architecture and implementation patterns. He identified the core tech stack that he should carefully study: TailwindCSS for styling and React for UI logic. To practice, Roger implemented a manual dark theme toggle and began addressing the new request type issue. To practice, Roger intended to implement a manual dark theme toggle after addressing the new request type issue.

  In the final phase, Roger completed a React fundamentals tutorial (by Youtube channel, Programming with Mosh). He can now understand .tsx file structures without the intensive use of Gemini.

  The goal of the upcoming days is to complete the new dark theme feature and resolve the new request issues within the next few days.

= Conclusion

== Acknowledgements

We would like to extend our sincere gratitude to our advisor, Dr. Yau Chat Tsoi, whose support and guidance have been fundamental to us.
