#import "../auto-util.typ": *

#auton(
  "Far Autonomous Win Point",
  datetime(year: 2024, month: 2, day: 25),
  "sixBall.cpp",
  [
    AWP for the far side requires that we score the alliance triball into our goal
    and touch the horizontal elevation bar. This is the code that accomplishes that.
  ],
)[

```cpp
void run6Ball() {
  // front left corner of the drivetrain aligned with the inside of the puzzling
  // with alliance triball in intake
  Robot::chassis->setPose(
      {MAX_X - TILE_LENGTH - Robot::Dimensions::drivetrainLength / 2,
       MIN_Y + TILE_LENGTH - Robot::Dimensions::drivetrainWidth / 2, RIGHT},
      false);

  // keep alliance triball in intake
  Robot::Actions::intake();

  // go into goal
  Robot::chassis->moveToPose(
      MAX_X - TILE_RADIUS,
      0 - TILE_LENGTH - Robot::Dimensions::drivetrainLength, UP, 3000);

  // once near the goal stop intaking
  Robot::chassis->waitUntil(20);
  Robot::Actions::stopIntake();

  Robot::chassis->waitUntilDone();

  // make sure triball goes into goal
  Robot::Actions::outtake();
  tank(127, 127, 500, 0);

  // back out of goal
  tank(-127, -127, 400, 0);
  Robot::Actions::stopIntake();

  // touch horizontal elevation bar
  Robot::chassis->moveToPose(0 + Robot::Dimensions::drivetrainLength / 2 + 1.5,
                             MIN_Y + TILE_RADIUS - 0.5, LEFT, 4000, {.maxSpeed =
64});

  // intake ball under elevation bar
  Robot::Actions::intake();
}
```
]