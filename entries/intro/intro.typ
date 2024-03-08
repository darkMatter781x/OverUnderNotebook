#import "/packages.typ": notebookinator, gentle-clues
#import notebookinator: *
#import themes.radial.components: *
#import gentle-clues: *
#import themes.radial.components.icons

#import "/util.typ": qrlink

#show: create-body-entry.with(
  title: "Introduction",
  type: "notebook",
  date: datetime(year: 2024, month: 1, day: 15),
  author: "Andrew Curtis",
)

= What is this?
This notebook contains:
#grid(
  columns: 2,
  rows: 4,
  gutter: 2mm,
  image.decode(
    utils.change-icon-color(raw-icon: icons.target, fill: blue),
    height: 6em,
  ),
  [
    == Decide
    What decisions we made regarding the management of the code typically and why we
    made them.
  ],
  image.decode(
    utils.change-icon-color(raw-icon: icons.terminal, fill: purple),
    height: 6em,
  ),
  [
    == Program
    The commented code that we run on our robot along with visuals to aid in
    understanding.
  ],
  image.decode(utils.change-icon-color(raw-icon: icons.page, fill: pink), height: 6em),
  [
    == Concept
    Explanation of algorithms and concepts that we use in our code along with
    resources for further learning.
  ],
  image.decode(utils.change-icon-color(raw-icon: icons.page, fill: gray), height: 6em),
  [
    == Notebook
    Talks about the notebook itself like this entry.
  ],
)

= Formatting
#grid(
  columns: 2,
  rows: 3,
  [
    You'll also notice that the formatting of this notebook is in stark contrast to
    the formatting of the engineering notebook. This is due to to the software
    differences between the two. The engineering notebook is written google slides,
    which gives total control over the formatting of the notebook, whilst still
    being easily and graphically editable, whereas for the code notebook we opted
    for Typst. Typst enables us to write all the notebook with typst code which
    gives us far more control over the formatting of the notebook, and also allows
    us to easily include and format code.
  ],
  figure(
    qrlink("hhttps://github.com/darkMatter781x/OverUnderNotebookr", size: 0.2em),
    caption: [
      source code for notebook
    ],
  ),
  [
    = _The Notebookinator_
    Another benefit of using Typst is that we can use libraries like _The Notebookinator_ which
    provides tools and examples for creating visually appealing notebooks with
    typst.
  ],
  figure(
    qrlink("https://github.com/BattleCh1cken/notebookinator", size: 0.2em),
    caption: [_The Notebookinator_ Github repository],
  ),
  [
    = Inspiration
    A lot of this notebook's formatting was inspired by Felix Hass of 53E's
    notebook, which served as a great example of how to use _The Notebookinator_. He
    was also very willing to answer any questions we had about the notebook, and we
    are very grateful for his help.
  ],
  figure(
    qrlink("https://github.com/Area-53-Robotics/53E-Notebook", size: 0.2em),
    caption: [53E's notebook],
  ),
)
