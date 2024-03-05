#import "/packages.typ": notebookinator, gentle-clues
#import notebookinator: *
#import themes.radial.components: *
#import gentle-clues: *

#import "/util.typ": qrlink

#show: create-body-entry.with(
  title: "Program: Boomerang",
  type: "program",
  date: datetime(year: 2024, month: 2, day: 28),
  author: "Andrew Curtis",
)

= Boomerang Controller:
So how do you get from point a to point b with a heading of theta? Seems like a
pretty trivial question right? Just drive towards point b, and turn once
reaching point b, but this isn't the most efficient solution. The better
solution would be to take an arc-like path that causes the robot to end with the
target heading. This solution / algorithm is called the boomerang controller.

It works by creating a carrot point for every loop of the controller that the
bot will attempt to go to. The generation of this point is done in such a way
that as the robot nears the target point, it will converge on the target point.
The algorithm and graph for the generation for the carrot point is below.

== Calculations:
The distance between target position and the carrot point:

$h=sqrt(
  (x#sub[current] - x#sub[target])^2 + (y#sub[current] - y#sub[target])^2
)$

The coordinates for the carrot:

$x#sub[carrot]=x#sub[target]-h cos(theta#sub[target]) d#sub[lead]$

$y#sub[carrot]=y#sub[target]-h sin(theta#sub[target]) d#sub[lead]$

== Visualization
#set align(center)
#image("./desmos.png", height: 30%)
=== Interactive Visualization
#qrlink("https://www.desmos.com/calculator/p4aocro3bg", width: 35mm)
