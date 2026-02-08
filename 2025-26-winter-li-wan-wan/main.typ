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
// Simon's Question: Should I put the issue numbers here? Should I link to the issues in the Github repo? Should I put these fixes in the Bugs section or Enhancements section?
=== Visual Bugs

/ Request Form Alignment Issue (Issue \#51):

  @fig-issue-51 shows the request form had alignment issues where the "Class" fields were not properly aligned when there are many instructors, leading to a cluttered appearance. @fig-pr-63 shows the form after the fix implemented by Simon, who adjusted the Tailwind CSS classes, i.e., adding `items-start` to the `<Wrapper>`, which aligns all elements to the start of their containers in grid layout; and `row-span-3` to the instructor's shadcn/ui componenet `<FormItem>`, which allows the instructor field to span three rows in the grid, ensuring that it occupies sufficient vertical space and aligns properly with the other fields. This change improved the visual alignment of the form, making it more organized.

  // Suggestion: A figure showing Before Fix here
  #figure(
    placement: bottom,
    caption: [
      Before Fix: The "Class" fields are misaligned when there are many instructors, leading to a cluttered appearance.
    ]
  )[
    #image("figure/crs-issue-51.png")
  ] <fig-issue-51>
  // Suggestion: A figure showing After Fix here
  #figure(
    placement: bottom,
    caption: [
      After Fix: The "Class" fields are properly aligned, improving the visual organization of the form.
    ]
  )[
    #image("figure/crs-pr-63.png")
  ] <fig-pr-63>

  The pull request link for this fix can be found here: #link("https://github.com/HKUST-CRS/crs/pull/63")[https://github.com/HKUST-CRS/crs/pull/63].

/ Dark Theme Mode Inconsistency (Issue \#56):
  
  @fig-issue-56 shows the dark theme mode had inconsistencies in the color scheme, where some elements did not switch to dark mode properly. Both Simon and Roger had tried to address this issue by reviewing the CSS variables.

  - Simon's solution:
   
   / 1st Trial:
    
    For the general theme, Simon tried to sychronize the CSS variables used for `.dark` and `@media (prefers-color-scheme: dark)` selectors in `global.css`. Ensure thed CSS variables were consistent across both selectors to maintain a uniform appearance in dark mode. For the `TextType` object which displays 'CRS Request System' with the typing effect, Simon identified that some CSS variables were not being applied correctly in dark mode. He updated the CSS to use theme-adaptive variables -- `var(--foreground)` for all relevant elements in three documents in `packages/site/app`, including `students-view.tsx`, `instructors-view.tsx`, and `./instructor/admin/[cid]/page.tsx`, ensuring a consistent appearance across the application.

    The pull request link of the 1st Trial can be found here: #link("https://github.com/HKUST-CRS/crs/pull/61")[https://github.com/HKUST-CRS/crs/pull/61].

   / 2nd Trial: 
    
    For the general theme, Simon adopted Harry's advice to use the pre-defined shadcn/ui dark mode classes to ensure consistency. By using `<ThemeProvider>` component imported from `next-themes` in `packages/site/app/layout.tsx`, Simon ensured that the dark mode classes were applied consistently across the application. Also, `@media (prefers-color-scheme: dark)` selectors were removed from `global.css` for refactoring. For the `TextType` object, Simon kept the original solution from his 1st Trial. @fig-pr-66 shows the final result after the 2nd Trial, where the dark theme mode is now consistent across the application, with all elements switching to dark mode properly.

    The pull request link of the 2nd Trial can be found here: #link("https://github.com/HKUST-CRS/crs/pull/66")[https://github.com/HKUST-CRS/crs/pull/66].

  - Roger's solution:
  // Roger's part here
  
  // Suggestion: A figure showing Before Fix here
  #figure(
    placement: bottom,
    caption: [
      Before Fix: The dark theme mode had inconsistencies in the color scheme, where some elements did not switch to dark mode properly.
    ]
  )[
    #image("figure/crs-issue-56.png")
  ] <fig-issue-56>


  // Suggestion: A figure showing After Fix here
  #figure(
    placement: bottom,
    caption: [
      After Fix: The dark theme mode is now consistent across the application, with all elements switching to dark mode properly.
    ]
  )[
    #image("figure/crs-pr-66.png")
  ] <fig-pr-66>

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
  
  Based on the initial checklists, Simon studied the key differences between TypeScript and JavaScript, focusing on static versus dynamic type checking. TypeScript detects errors such as type mismatches, spelling mistakes, and undefined properties at compile time or during development, while JavaScript identifies them only at runtime. 
  
  With the foundation knowledge of TypeScript, Simon studied Bun, which he now understands it as an all-in-one JavaScript/TypeScript toolkit that executes `.ts` files directly without generating `.js` files and supports npm-compatible module installation. He reviewed Node.js fundamentals, including its role as a JavaScript runtime environment that enables server-side execution of JavaScript code outside the browser, which role is similar to Bun in this project.

  In parallel to the above subjects, Simon learned Docker fundamentals and applied them to resolve a local CRS project issue caused by a missing MongoDB instance. Running MongoDB via a Docker container enabled successful execution. He also revised fundamental HTML and CSS syntax to reinforce front-end basics.

/ 2nd week: 
  
  After successfully completing the first week, Simon continued advancing his TypeScript knowledge by exploring type constraints, interfaces, and their integration with functions, with a particular emphasis on web development scenarios. He also reviewed core JavaScript syntax, its interaction with the browser environment, fundamental HTTP methods (e.g., `GET`, `POST`), and common status codes (e.g., `200`, `404`). Additionally, Simon revised essential Git commands (e.g., `init`, `branch`, `push`) and their workflow with GitHub for effective version control.

  In practice, Simon started his first trial on addressing the dark mode display inconsistency (Issue \#56) by applying theme-adaptive variables across the relevant elements. This change resolved the visual bug in the local display. 

/ 3rd week:

  In this week, Simon advanced his TypeScript proficiency by studying type narrowing techniques and generics, gaining a deeper understanding of how to create flexible and type-safe code structures. He also explored callback functions, Promises, and asynchronous functions in both JavaScript and TypeScript, focusing on handling asynchronous operations effectively in modern web development.

  // Simon's Question: For the practice project, I would like to place a link to my github repo, and a figure showing the project here
  In practice, Simon experimented with TypeScript by writing simple functions and using live-server to run them locally, observing their interactions with the browser environment. He then progressed to building a practice meeting arrangement web application by following a tutorial, incorporating TypeScript, React, Tailwind CSS, Next.js, shadcn/ui, basic routing concepts, database integration with Neon DB for data storage and retrieval, Drizzle ORM for database schema creation, migration, and data manipulation, and Clerk for user authentication system. Throughout these projects, he adopted GitHub Workflow to simulate an actual development process, uploading all work to GitHub for version control and collaboration.

  @fig-practice-project-before-login, @fig-practice-project-after-login, and @fig-practice-project-neondb-view show the practice project in different stages, including the initial login page, the event creation form after logging in, and the Neon DB view showing the stored events. The practice project allowed Simon to apply his TypeScript knowledge in a real-world context, gaining hands-on experience with the technologies used in the CRS project and improving his web development skills. These experiences will enable him to contribute more effectively to the CRS project in the future.

  The GitHub repository for Simon's experimentation with TypeScript can be found here: #link("https://github.com/w41z/My-TypeScript-Practice")[https://github.com/w41z/My-TypeScript-Practice].

  The GitHub repository for Simon's practice project can be found here (still in progress): #link("https://github.com/w41z/my-calendra-clone")[https://github.com/w41z/my-calendra-clone].

  #figure(
    placement: bottom,
    caption: [
      Simon's practice project: A meeting arrangement web application built with TypeScript, React, Tailwind CSS, Next.js, shadcn/ui, Neon DB, and Clerk for user authentication.
    ]
  )[
    #image("figure/simon-practice-project-before-login.png")
  ] <fig-practice-project-before-login>

  #figure(
    placement: bottom,
    caption: [
      After logging in, users can create events by filling out a form with details such as event name, date, time, and description.
    ]
  )[
    #image("figure/simon-practice-project-after-login-with-create-event-sheet.png")
  ] <fig-practice-project-after-login>

  #figure(
    placement: bottom,
    caption: [
      The created events are stored in Neon DB.
    ]
  )[
    #image("figure/simon-practice-project-neondb-view.png")
  ] <fig-practice-project-neondb-view>

/ 4th week:

  With the previous experience of the practice project, Simon tried to fix a visual alignment bug (Issue \#51) in the CRS system, and tried to study `.map`, `.filter`, and `.reduce` functions in JavaScript. In addition, Simon addressed the dark mode display inconsistency issue (Issue \#56) with the 2nd trial solution mentioned above.

=== Roger's Experience

Roger’s experience can be distributed to 4 Phrase: Free learning, exploring, targeted learning, and contributing.

[one sub-title say: Phrase1: Free learning]
In the very first stage, Roger reached out to Harry because he does not know how to start “running” the whole project. Harry advised a to-do learning list for him benefiting him to gain the necessary knowledge to solve that problem.

Roger first studied the core features of Node.js and the basic syntax of TypeScript to gain a deeper understanding of the CRS framework's architecture. Secondly, he begans learning how to use Github in order to contribute project with a manageable workflow.

Node.js is a JavaScript runtime environment that enables the execution of JavaScript on a local machine as Javascript originally could only be executed with a browser. This facilitates server-side logic and development workflows.
  
During the process of learning Node.js., he also explored Modules in Node.js by following online tutorials, which are crucial for maintaining a clean and scalable codebase. He understood how modularity allows developers to split code into distinct files using ES Modules, ensuring that system parts like API routes or database logic, remain decoupled and reusable.
  
Although Roger initially explored Node.js to solve the "how-to-run" issues, he found that extensive knowledge of module systems was not required for the initial setup.

TypeScript, a typed superset of JavaScript. Unlike JavaScript, TypeScript enforces Static Type Checking, catching type mismatches or spelling errors during the development phase before the code is compiled into .js files. This approach greatly enhances long-term maintainability. By defining data structures and variable types, developers can prevent a wide range of runtime errors, making the larger scaled project like CRS more easier for team members to collaborate on and refactor.

Roger learned the knowledge of Node.js and TypeScript from Youtube tutorials, "Programming with Mash”. He viewed the series about Node.js and TypeScript and followed all practice material in order to gain the above knowledge.

As this is the first time for Roger to use Github intensively during development, he spent a week reading documents and asking Gemini about the basic use of Github. Basically, Github is a platform for developers to sync their project with a manageable work flow. 

The learning covers the following terminology:

  1. Repository: It can be seem as one "project" that contain all relavant files. Github allows different features for developers to manage and contribute to repositories.
  
  2. Clone: Downloading all file contain in the repository into local machine.

  3. Fork: Develepers could copy the orginal repository for them themselve to use.

  4. Branch: Under one repository, developers could create branch for them to manage the folders, with puching, pulling, fetch, discarging changes features, except of impacting the main branch.

  5. Merch: Developers in the org of the repository have access to merge suitable development branch into the main branch for project's enhancement.

  6. Pull request: Developers who is not in the org of the repository could submit pull request which contain a branch (either under forked repository or orginal repository). The other developers could view the overall changes and give feedback to the pull request. The developer in the org could decide whether the request is suitible to merch.

After reading the above documentation of Github, Roger started to explore the project and found the correct path of learning in order to contribute. He first configured the development environment with Simon's guidance. This included learning and setting up Bun, Docker, and MongoDB. After the configuration, he could successfully run the system on a localhost using dummy data.

[one sub-title say: Phrase 2: Exploring]
After learning some basic tech stack, Roger started the codebase exploration of the project and analyzed Simon's Pull Requests regarding to dark theme display issue (issue\#56, phrase 1) to continually understand the project's architecture and implementation patterns. Then, he identified the core tech stack that he should carefully study in the next learning pharse: TailwindCSS for styling and React for UI logic. He had also decided that his contribution would focus on this dark theme display issue (issue\#56) in this winter.

[one sub-title say: Phrase 3: Targeted learning]
As Roger defined TailwindCSS and React as the main tech stack to learn, Roger first completed a React fundamentals tutorial (also by Youtube channel, Programming with Mosh). This allows him to understand .tsx file structures and develop basic web applications or features without the intensive use of Gemini. Then, he read the documentation about the basic features of TailwindCss, such as, modifying font, different colour, block displays, buttons, and CSS variable. These features are crucial for him to understand how to modify the web page theme selection based on system preference.

After the above progress, Roger found that the implementation of a user manual theme toggling feature is strongly relevant to the codebase of the automatic theme toggling feature base. The goal of the upcoming days becomed to complete the new manual dark theme toggling feature and resolve the original dark mode display issues.
 
[one sub-title say: Phrase 4: Contributing]


This week is the actual development week for Roger. The development can be distributed to three part: Practice project, theme display issues resolving, and manual theme trolling button implementation.

The practice project explored the basic use of React and TailwindCSS. It is a single page that contains a basic display of text, layout, and a button that changes the theme.

The following are some pictures displaying the layout of the practice project.


First enter the page (with dark system theme):


First enter the page (with light system theme):


After pressing manual toggling theme (with dark system theme):
 

The above picture shows the element in the page can display with different themes based on the system preferred theme. The button in the right-hand size will overwrite the origin system preferred theme to achieve a manual switching theme feature.

The project is done by the step-by-step guidance by using the “guided learning mode” of Gemini. By sending a prompt: “I am a complete new-comer to React and TailWindCSS. Guide me to make a webpage in order to let me understand key features to build a basic webpage. Do not tell the answer directly, let me explore myself under guidance”, Gemini can guide me though different features by not just copying and pasting, but attempting to try each feature myself.

After the practice project, the logic is moved to one branch of CRS repository in order to solve the (issue\#56) and the manual theme t feature. The detailed solution to (issue\#56) is stated at the enhancement part. 

  
= Conclusion

== Acknowledgements

We would like to extend our sincere gratitude to our advisor, Dr. Yau Chat Tsoi, whose support and guidance have been fundamental to us.
