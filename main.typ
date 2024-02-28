#import "/packages.typ": notebookinator, codly
#import notebookinator: *
#import codly: *
#import themes.radial: radial-theme, components

#show: notebook.with(theme: radial-theme, cover: align(center)[
  #text(size: 24pt, font: "Tele-Marines")[
    #v(3em)
    #text(size: 28pt)[
      Code Notebook
    ]

    #image("./assets/781X-logo.png", height: 60%)

    2023 - 2024
    #line(length: 50%, stroke: (thickness: 2.5pt, cap: "round"))
    Over Under

  ]
], team-name: "781X")

#create-frontmatter-entry(title: "Table of Contents")[
  #components.toc()
]

#include "entries/entries.typ"

// #include "./appendix.typ"