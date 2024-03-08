#import "/packages.typ": notebookinator, gentle-clues
#import notebookinator: *
#import themes.radial.components: *
#import gentle-clues: *

#import "/util.typ": qrlink

#show: create-body-entry.with(
  title: "Concept: Pure Pursuit",
  type: "concept",
  date: datetime(year: 2024, month: 3, day: 6),
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
  figure({
    image("./quadratic.png", width: 100%)
  }, caption: [
    A quadratic Bézier curve. $t$ is represented by color
  ]),
  [
    Hey thats not a curve, thats a line!! Well, yes, but this is the simplest form
    of a Bézier curve, but we can make it more interesting by adding more points. We
    will start with a quadratic Bézier curve which requires 3 points. To do this we
    make two lerps, one between $a$ and $b$, and one between $b$ and $c$. We then
    take a lerp between these two curves to form our quadratic Bézier curve.
  ],
)
== Recursive Bézier
OK, but what if we want to make a Bézier curve with more than 3 points? Well, we
can form a recursive process to create n-degree Bézier. In our quadratic
(2-degree) Bézier example, we took two linear Béziers (1-degree) and lerped
between them. We can do the same thing for a cubic (3-degree) Bézier, but
instead of lerping between two linear Béziers (1), we lerp between two quadratic
Béziers(2).

Hopefully this helps you to see how a general recursive n-Bézier curve can be
formed. But, just to drive the point home, to create a n-degree Bézier curve, we
take two (n-1)-degree Bézier curves and lerp between them. And if you have a
0-degree Bézier curve, you just have a point.

#grid(
  columns: 2,
  gutter: 2mm,
  [
    = Tooling
    Now we have a way to form a curve, but we don't wanna manually generate each
    path. Luckily we have amazing tooling like #link("path.jerryio.com"). This tool
    allows us to visualize, create, and modify a path. This path is then exported as
    a list of points which we can then put in our code. What is this path formed by?
    Splines!

    Splines are simply just multiple Bézier curves put together. There's many
    special types of splines, but thats another subject that we will not be getting
    into. In the case of #link("path.jerryio.com"), we use cubic Bézier curves and
    lines/linear Bézier curves to form the spline.
  ],
  figure(
    {
      image("./path.jerryio.png", width: 80%)
    },
    caption: [
      A screenshot of path.jerryio.com showing a path for an old six ball. The intent
      of this path is to remove the triball in the matchload zone.
    ],
  ),
)
