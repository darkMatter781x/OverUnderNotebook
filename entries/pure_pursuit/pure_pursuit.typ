#import "/packages.typ": notebookinator, gentle-clues
#import notebookinator: *
#import themes.radial.components: *
#import gentle-clues: *

#import "/util.typ": qrlink

#show: create-body-entry.with(
  title: "Program: Pure Pursuit",
  type: "program",
  date: datetime(year: 2023, month: 11, day: 28), // TODO: fix date
  author: "Andrew Curtis",
)

= Pure Pursuit
Pure pursuit is an algorithm for making a robot follow predetermined curves. To
do this, the algorithm takes an array of points and a lookahead value.