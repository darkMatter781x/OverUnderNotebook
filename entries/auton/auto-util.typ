#import "/packages.typ": notebookinator, gentle-clues
#import notebookinator: *
#import themes.radial.components: *
#import gentle-clues: *

#import "/util.typ": qrlink

#let auton(title, date, filename, description, body) = {
  show: create-body-entry.with(
    title: "Auton: " + title,
    type: "program",
    date: date,
    author: "Andrew Curtis",
  )

  grid(
    columns: 2,
    gutter: 2mm,
    {
      heading(title)
      description
    },
    {
      set align(horizon)
      figure(
        qrlink(
          "https://github.com/meiszwflz/OverUnder781X/tree/master/src/auton/autons/" + filename,
          width: 9em,
        ),
        caption: "Source Code on Github",
      )
    },
  )

  body
}