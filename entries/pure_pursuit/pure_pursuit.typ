#import "/packages.typ": notebookinator, gentle-clues
#import notebookinator: *
#import themes.radial.components: *
#import gentle-clues: *

#import "/util.typ": qrlink

#show: create-body-entry.with(
  title: "Concept: Pure Pursuit",
  type: "concept",
  date: datetime(year: 2023, month: 11, day: 28), // TODO: fix date
  author: "Andrew Curtis",
)

= Pure Pursuit
Pure pursuit is an algorithm for making a robot follow predetermined curves. To
do this, the algorithm takes a list of points that form our curve and some
lookahead distance. Then, the robot tries to follow the curve by steering
towards the point furthest along the path but within a circle whose radius of is
the lookahead distance.

= Lookahead
== Analogy
Imagine you're mountain biking up a really annoying rocky uphill. You can't just
go straight, because the rocks will push you around. If you attempt to look
right in front of your front tire you'll end up doing a wobbly zigzag up the
trail. But if you instead focus on a point in the distance, then you're not
correcting for little changes caused by the rocks, and thus you will take a much
smoother path.

Same thing goes for robots, but for robots the “rocks” are anything from field
tile variance, to hot motors, to a low battery.

== So just make it big?
In the analogy, we saw that a small lookahead can be problematic, but what about
a large lookahead?
// excalidraw: https://excalidraw.com/#json=epm3bvKs1YoqG6nPTF_6t,njizcY1d2WAajrVdqjtZww
#figure(
  image("./lookahead.svg", width: 100%),
  caption: [
    Example illustration of the effect of lookahead on the actual path the robot
    takes.
  ],
)
Here we see that any amount of lookahead causes the robot to cut the corners of
the path and thus never actually follows our path. As lookahead increases, the
robot follows less and less closely to the path, until eventually it just goes
straight. This illustrates (quite literally) that there is a balance to be
struck between too much lookahead, and too little.

But how do we get the path to follow in the first place? This is where Bézier
curves come in.

= Bézier Curve
A Bézier curve is a method of taking a list of points and forming a curve
between them.
#figure(
  stack(
    dir: ltr, // left-to-right
    spacing: 2mm, // space between contents
    {
      set align(horizon)
      box(image("./cubic-Bézier.svg", width: 70%), height: 37%, clip: true)
    },
    {
      set align(horizon)
      figure(
        qrlink("https://www.desmos.com/calculator/mm72eduq5w", size: 0.25em),
        caption: [
          interactive desmos
        ],
      )
    },
  ),
  caption: [
    A cubic Bézier
  ],
)
== Linear Interpolation
A Bézier curve is a method of taking a list of points to form a curve. Its
simplest form uses an algorithm known as linear interpolation or lerp for short.
A lerp takes a time between 0 and 1, $t$ and two values $a$ and $b$ to lerp
between. At $t=0$, the lerp function's output should equal $a$ and at $t=1$, the
output is $b$. But what happens between $t=0$ and $t=1$? In between these two
times, we linearly interpolate between $a$ and $b$. For example at $t=0.1$, the
output is expected to be 90% $a$ and 10% $b$.

#grid(
  columns: 2,
  gutter: 2mm,
  [
    The awesome thing about lerps is that we are not limited to normal numbers for $a$ and $b$,
    we can also use points. For example, if you take 2 points and find all points
    output by our function lerp over the entire domain of $t$, you will have found
    all points on the line between $a$ and $b$. This is what we would call a linear
    Bézier curve in the world Béziers.
  ],
  figure({
    image("./lerp.png", width: 100%)
  }, caption: [
    A linear Bézier curve. $t$ is represented by color
  ]),
)
== Quadratic Bézier
#grid(
  columns: 2,
  gutter: 2mm,
  [
    Hey thats not a curve, thats a line!! Well, yes, but this is the simplest form
    of a Bézier curve, but we can make it more interesting by adding more points. We
    will start with a quadratic Bézier curve which requires 3 points. To do this we
    make two lerps, one between $a$ and $b$, and one between $b$ and $c$. We then
    take a lerp between these two curves to form our quadratic Bézier curve.
  ],
  figure({
    image("./lerp.png", width: 100%)
  }, caption: [
    A linear Bézier curve. $t$ is represented by color
  ]),
)

=== Tooling
To easily create and visualize our paths and put them into a machine readable
format, we use #link("path.jerryio.com").