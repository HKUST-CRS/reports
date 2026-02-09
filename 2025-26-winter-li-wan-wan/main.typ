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

  #figure(
    placement: none,
    caption: [
      Before Fix: The dark theme mode had inconsistencies in the color scheme, where some elements did not switch to dark mode properly.
    ]
  )[
    #image("figure/crs-issue-56.png")
  ] <fig-issue-56>


 The enhancement of this issue can be organized into three phases. The initial and final phases are managed by the new developer, Simon, while the second phase is managed by another new developer, Roger.

/ Phase 1 (Managed by Simon):
For the general theme, Simon tried to synchronize the CSS variables used for `.dark` and `@media (prefers-color-scheme: dark)` selectors in `global.css`. Ensure the CSS variables were consistent across both selectors to maintain a uniform appearance in dark mode. For the `TextType` object which displays 'CRS Request System' with the typing effect, Simon identified that some CSS variables were not being applied correctly in dark mode. He updated the CSS to use theme-adaptive variables -- `var(--foreground)` for all relevant elements in three documents in `packages/site/app`, including `students-view.tsx`, `instructors-view.tsx`, and `./instructor/admin/[cid]/page.tsx`, ensuring a consistent appearance across the application.


    The pull request link of the 1st Trial can be found here: #link("https://github.com/HKUST-CRS/crs/pull/61")[https://github.com/HKUST-CRS/crs/pull/61].

/ Harry's Comment\:: Harry stated that directly editing `global.css` is not a good practice.

/ Phase 2 (Managed by Roger):
To adopted Harry's guide, Roger deleted the  `@media (prefers-color-scheme: dark)` selectors in `global.css` that were used to detect system themes and replaced it with an event listener `window.matchMedia('(prefers-color-scheme: dark)')`. By detecting the system theme, the logic will add a `dark` class list to the root and perform the change of the theme. The logic of theme changing and the event listener is implemented at one signal file called `ThemeProvider.tsx` and embellished in the `layout.tsx` file which is the outermost layer of the whole project. Thus, all pages of CRS could have a correct theme display. 

Given that implementation of a manual theme change button is similar to managing an event handler, the logic of a manual theme change button also including in `ThemeProvider.tsx`. The button is placed at the right-hand side of the header, which allows users to override the system theme preference and switch themes manually.

While the above solution successfully resolved the dark mode display inconsistency issue, it introduced a new issue called FOUC (Flash of Unstyled Content) issue, where the page briefly flashes the light theme before switching to dark mode when the system theme is set to dark. This is because the theme detection and application logic runs after the initial page load, causing a momentary display of the default light theme before applying the correct dark theme. To solve this issue, a blocking status script applied to ensure that the theme detection and application logic runs before the page content is rendered.

In addition, Roger discovered that the `@media` selector in `global.css` have the highest priority in the CSS hierarch, which mean that the CSS variables defined in the `@media` selector will override any other CSS variables defined elsewhere. Thus, the manual theme change button will not work properly because the CSS variables defined in the `@media` selector will always override other CSS variables including those used for manual button. This is the reason why Harry commented that adding `@media` selector into `global.css` is not a good practice.






The pull request link of the Phase 2 and all photos of before and after can be found here:
#link("
https://github.com/HKUST-CRS/crs/pull/64")[https://github.com/HKUST-CRS/crs/pull/64].

The pull request link of the manual theme change button can be found here:
#link("https://github.com/HKUST-CRS/crs/pull/65").[https://github.com/HKUST-CRS/crs/pull/65].

/ Harry's comment\:: There is an external library that implements almost the same. We should avoid re-inventing wheels and use external library. 


/ Phase 3 (Managed by Simon): 
For the general theme, Simon adopted Harry's advice to use the pre-defined shadcn/ui dark mode classes to ensure consistency. By using `<ThemeProvider>` component imported from `next-themes` in `packages/site/app/layout.tsx`, Simon ensured that the dark mode classes were applied consistently across the application. Also, `@media (prefers-color-scheme: dark)` selectors were removed from `global.css` for refactoring. For the `TextType` object, Simon kept the original solution from his 1st Trial. @fig-pr-66 shows the final result after the 2nd Trial, where the dark theme mode is now consistent across the application, with all elements switching to dark mode properly.

    The pull request link of the 2nd Trial can be found here: #link("https://github.com/HKUST-CRS/crs/pull/66")[https://github.com/HKUST-CRS/crs/pull/66].

  // Suggestion: A figure showing After Fix here
  #figure(
    placement: none,
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

Roger’s experience is organized into four main phases: Initial Learning, Exploration, Targeted Skill Development, and Contribution.

/ Pharse 1\: Initial Learning:

In the very first stage, Roger reached out to Harry because he did not know how to start running the whole project. Harry advised a to-do learning list to help him gain the necessary knowledge to solve that problem.

Roger first studied the core features of Node.js and the basic syntax of TypeScript to gain a deeper understanding of the CRS framework's architecture. Secondly, he began learning how to use GitHub to contribute to the project with a manageable workflow.

Node.js is a JavaScript runtime environment that enables the execution of JavaScript on a local machine, as JavaScript was originally designed only for the browser. This facilitates server-side logic and development workflows.

  
During the process of learning Node.js., he also explored Modules in Node.js by following online tutorials, which are crucial for maintaining a clean and scalable codebase. He understood how modularity allows developers to split code into distinct files using ES Modules, ensuring that system parts like API routes or database logic, remain decoupled and reusable.
  During the process of learning Node.js, he also explored Modules by following online tutorials. These modules are crucial for maintaining a clean and scalable codebase. He gained an understanding of how modularity allows developers to split code into distinct files using ES Modules, ensuring that system parts, such as API routes or database logic, remain decoupled and reusable.


Although Roger initially explored Node.js to solve the project's startup issues, he found that extensive knowledge of module systems was not required for the initial configuration.


TypeScript is a typed superset of JavaScript. Unlike JavaScript, TypeScript enforces Static Type Checking, catching type mismatches and spelling errors during the development phase before the code is compiled into .js files. This approach greatly enhances long-term maintainability. By defining data structures and variable types, developers can prevent a wide range of runtime errors, making large-scale projects like CRS easier for team members to collaborate on and refactor.


Roger acquired his knowledge of Node.js and TypeScript from the YouTube tutorials, "Programming with Mosh." He completed the entire series and followed all practice materials to gain the necessary understanding.


Since this was Roger's first intensive use of GitHub during development, he spent a week reading documentation and consulting Gemini about its basic use. GitHub is a platform designed for developers to synchronize their projects and manage a collaborative workflow.


The learning covered the following terminology:
Repository: It can be seen as a single project that contains all relevant files. GitHub provides various features for developers to manage and contribute to these repositories.
Clone: The process of downloading all files contained in the repository to a local machine.
Fork: Allows developers to copy the original repository for their own development and use.
Branch: Within a repository, developers can create a branch to manage features, using commands like pushing, pulling, fetching, and discarding changes, without immediately impacting the main branch.
Merge: Developers within the repository's organization have the access to integrate a suitable development branch into the main branch for project enhancement.
Pull Request: Developers not belonging to the repository's organization can submit a pull request containing a branch (either from a forked or the original repository). Other developers can review the overall changes and provide feedback, and a developer in the organization decides whether the request is suitable for merging.
After reviewing the GitHub documentation, Roger began exploring the project and identified the most effective learning path for his contribution. With Simon's guidance, he first configured the development environment, which involved learning and setting up Bun, Docker, and MongoDB. Following this setup, he was able to successfully run the system on a localhost using dummy data.

/ Phrase 2\: Exploring:
Following his foundational training, Roger began exploring the project's codebase. He analyzed Simon's Pull Requests for the Dark Theme Display Issue (Issue \#56) to better understand the project's architecture and implementation patterns. Subsequently, he identified the key technologies for his next learning phase: TailwindCSS for styling and React for UI logic. He decided to focus his contribution for the winter on resolving this dark theme display issue (Issue \#56).

/ Phrase 3\: Targeted Skill Development:
Having defined TailwindCSS and React as the main technologies to learn, Roger first completed a React fundamentals tutorial (also by the YouTube channel, Programming with Mosh). This allowed him to understand .tsx file structures and develop basic web applications or features without intensive reliance on Gemini. He then studied the documentation for TailwindCSS's basic features, such as modifying fonts, colors, block displays, buttons, and CSS variables. These features were crucial for him to understand how to modify the web page theme selection based on system preference.


Following this progress, Roger realized that the implementation of a user manual theme toggling feature was strongly relevant to the codebase of the automatic theme toggling feature. The goal for the upcoming days became to complete the new manual dark theme toggling feature and resolve the original dark mode display issues.

/ Phrase 4\: Contributing:


This week marks Roger's active development phase, which is divided into three key areas: a practice project, resolving theme display issues, and implementing the manual theme toggling button.


The practice project involved exploring the basic use of React and TailwindCSS. It is a single-page application that features a basic display of text, layout, and a button to change the theme.


The following are some pictures displaying the layout of the practice project:
  #figure(
    placement: none,
    caption: [
      First enter the page (with dark system theme)
    ]
  )[
    #image("figure/chung-1.png")
  ] <chung-1>



  #figure(
    placement: none,
    caption: [
      First enter the page (with light system theme)
    ]
  )[
    #image("figure/chung-2.png")
  ] <chung-2>




  #figure(
    placement: none,
    caption: [
      After pressing manual toggling theme (with dark system theme)

    ]
  )[
    #image("figure/chung-3.png")
  ] <chung-3>

The above picture shows that the elements on the page can display different themes based on the system's preferred theme. The button on the right-hand side overrides the original system preference to achieve a manual theme switching feature.

The project was completed with step-by-step guidance using Gemini's "guided learning mode." By using the prompt, “I am a complete newcomer to React and TailWindCSS. Guide me to make a webpage in order to let me understand key features to build a basic webpage. Do not tell the answer directly, let me explore myself under guidance,” Gemini provided guidance that encouraged Roger to explore different features rather than simply copying and pasting.


Following the practice project, the logic was moved to a branch of the CRS repository to solve (issue #56) and implement the manual theme feature. The detailed solution for (issue #56) is documented in the enhancement section.

  
= Conclusion

== Acknowledgements

We would like to extend our sincere gratitude to our advisor, Dr. Yau Chat Tsoi, whose support and guidance have been fundamental to us.
