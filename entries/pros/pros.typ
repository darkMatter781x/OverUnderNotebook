#import "/packages.typ": notebookinator, gentle-clues
#import notebookinator: *
#import themes.radial.components: *
#import gentle-clues: *

#import "/util.typ": qrlink

#show: create-body-entry.with(
  title: "Decide: PROS",
  type: "decide",
  date: datetime(year: 2024, month: 1, day: 15),
  author: "Andrew Curtis",
)

= PROS
PROS is an open source operating system for the v5 brain.

== Benefits
- Allows us to utilize modern development tools like Visual Studio Code (VSCode)
  - Builtin integration with git and github
  - VSCode permits our team to use extensions that enhance our workflow. These
    include:
    - #link(
        "https://marketplace.visualstudio.com/items?itemName=sigbots.pros",
      )[PROS]: automatically installs the pros toolchain and provides a gui and
      commands to use it
    - #link(
        "https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.vscode-clangd",
      )[clangd]: advanced intellisense engine for c++ using the open source clang
      compiler
    - #link(
        "https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker",
      )[Code Spell Checker]: prevents spelling mistakes
    - #link(
        "https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph",
      )[Git Graph]: provides a visualization of the git commit history
    - #link(
        "https://marketplace.visualstudio.com/items?itemName=cschlosser.doxdocgen",
      )[Doxygen Documentation Generator]: aides in documenting code
    - #link(
        "https://marketplace.visualstudio.com/items?itemName=GitHub.copilot",
      )[Github Copilot]: provides ai autocomplete and aides in documenting code
    - and many others
  #info[
    VEX does have an vexcode extension for vscode, but it is still in beta and it is
    not yet as sophisticated as PROS.
  ]
- Enables the use of libraries like:
  - #link("https://github.com/LemLib/LemLib")[LemLib] - an open source library with
    a focus on odometry and motion algorithms.
    - Odometry: enables tracking the robot's location local to the field
    - Boomerang: efficient algorithm to a move robot to a point and a heading
    - Pure Pursuit: algorithm to follow a complex path
    - Move to Point: algorithm to move the robot to a point
- Hot / Cold linking: Pros downloads two different binaries to the brain which are
  then linked on the brain.
  - Cold package: Includes pros's builtin library and other libraries like LemLib
    that will be infrequently modified
  - Hot package: contains frequently modified code like user code.
  -
  By segmenting these binaries, it makes uploading an updated hot package code
  significantly quicker and saves valuable time when performing iterative testing.
