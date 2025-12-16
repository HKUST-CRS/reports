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

= Introduction

This report is for the Independent Work project _CSE Request System_, abbreviated *CRS*. This project was developed by Yuyi Ding and Harry Li under the supervision of Dr. Yau Chat Tsoi.

== Overview

CRS is a system designed to streamline and manage students' course administrative requests for courses offered by the Computer Science and Engineering (CSE) department, such as requests to swap lab sections, request an excused absent from lab sessions, extend assignment deadlines, and appeal grades on assignments. The system aims to provide a user-friendly interface for both students and instructors to facilitate efficient request--response handling and record-keeping.

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

== Design

== Implementation

== Testing

== Evaluation

= Planning

= Conclusion

== Acknowledgements

We would like to extend our sincere gratitude to our advisor, Dr. Yau Chat Tsoi, whose support and guidance have been fundamental to us.

We would also like to thank Mr. Henry Wong, whose support on the server setup, including the setup of the virtual machine, project account, domain name, and email server, has been invaluable to the success of our project.

Finally, we thank Tsz Chou Chui (Sunny) and Wai Hin Lam (Kris) for their suggestions and feedback during the development of this project.