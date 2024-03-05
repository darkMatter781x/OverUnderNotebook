#import "/packages.typ": notebookinator, gentle-clues
#import notebookinator: *
#import themes.radial.components: *
#import gentle-clues: *

#import "/util.typ": qrlink

#show: create-body-entry.with(
  title: "Program: Odometry",
  type: "program",
  date: datetime(year: 2024, month: 1, day: 15),
  author: "Andrew Curtis",
)

= Odometry

Odometry is just a fancy term referring to tracking the position of the robot
relative to the field using a suite of sensors. Tracking wheels are typically
un-powered wheels, to which sensors, that record rotation of an axle, are
attached.

== Calculation
Tracking wheels can be used to record the movement in the direction that they
track, so if you have a tracking wheel orientated vertically and another
horizontally, then you can calculate the position of the robot, assuming the
robot never turns. Sadly the robot turns, and thus we need a third sensor. The
easiest way to do this is with an Inertial Measurement Unit (IMU) which is
capable of measuring the heading of the robot.

If we can measure the change in x and y relative to the robot rapidly (~10ms),
we can then rotate this vector by the current heading and add it to the robot's
previous position. And voila, you know the robot's position!

#info[
  This is a simplification of the complex math behind odometry. For example, we
  assume that the tracking wheels are centered, which can be the case but most
  often is not. You can also use two parallel tracking wheels to measure the
  robot's heading if you prefer. If you'd like to learn some more, check out this
  pdf:

  #set align(center)
  #qrlink(
    "http://thepilons.ca/wp-content/uploads/2018/10/Tracking.pdf",
    width: 30mm,
  )
]
