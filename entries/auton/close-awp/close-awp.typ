#import "../auto-util.typ": *

#auton(
  "Close Autonomous Win Point",
  datetime(year: 2024, month: 2, day: 25),
  "defensive.cpp",
  [AWP for the close side requires that we remove the matchload zone triball and
    touch the horizontal elevation bar. This is the code that accomplishes that.],
)[
```cpp
  void runDefensive() {
  // front right corner of the drivetrain aligned with the inside of the
puzzling facing right
  Robot::chassis->setPose(
      {MIN_X + TILE_LENGTH + Robot::Dimensions::drivetrainLength / 2,
       MIN_Y + TILE_LENGTH - Robot::Dimensions::drivetrainWidth / 2, RIGHT},
      false);

  // back up to get in better position to remove the matchload zone triball
  Robot::chassis->moveToPoint(
      MIN_X + TILE_LENGTH,
      MIN_Y + TILE_LENGTH - Robot::Dimensions::drivetrainWidth / 2, 2000,
      {
          .forwards = false,
          .maxSpeed = 72,
      });
  Robot::chassis->waitUntilDone();

  // turn to be parallel with matchload barrier
  Robot::chassis->turnTo(1000000, -1000000, 2000, true, 48);
  Robot::chassis->waitUntilDone();

  // let wing expand
  Robot::Actions::expandBackWing();
  pros::delay(500);

  // remove the matchload zone triball
  Robot::chassis->turnTo(1000000, 0, 2000);
  Robot::chassis->waitUntilDone();

  // let ball roll away
  pros::delay(1000);

  // retract wing so it doesn't get in the way
  Robot::Actions::retractBackWing();

  // intake any straggler triballs
  Robot::Actions::intake();

  // touch horizontal elevation bar
  Robot::chassis->moveToPose(0 - Robot::Dimensions::drivetrainLength / 2 - 3.5,
                             MIN_Y + TILE_RADIUS, RIGHT, 2000);

  // if a triball enters the intake, outtake it
  while (pros::competition::is_autonomous()) {
    if (isTriballInIntake()) {
      Robot::Actions::outtake();
      pros::delay(500);
    }
    pros::delay(10);
  }
}
```
]