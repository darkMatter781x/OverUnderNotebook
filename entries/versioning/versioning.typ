#import "/packages.typ": notebookinator, gentle-clues
#import notebookinator: *
#import themes.radial.components: *
#import gentle-clues: *

#import "/util.typ": qrlink

#show: create-body-entry.with(
  title: "Decide: Version Control",
  type: "decide",
  date: datetime(year: 2024, month: 3, day: 5),
  author: "Andrew Curtis",
)

= Git
To maintain and organize code, our team uses a tool called Git. This tool keeps
a history of all changes made to the program, allowing the code to be reverted.
The image below is one of these Git commit histories. In Git, there are multiple
branches of code. There is a master version and smaller branches where testing
and prototyping can be done and merged into the master.

#figure(image("./history.png"), caption: [
  Example git commit history
])

= Commit Styling
You'll notice that each commit has a weird commit message. This is a convention
that we use to keep our commits organized and visually grepable. We use a mix of
conventional commits and gitmoji to create this convention: ```
<type>: <gitmoji> <description>
```= GitHub GitHub is a web-based platform that hosts Git repositories. It
allows for collaboration and sharing of code between team members. It also
enables us to easily open source our code so that other teams can use it as a
reference. You can see our git repository here:

#set align(center)
#qrlink("https://github.com/meiszwflz/OverUnder781X", width: 9em)
