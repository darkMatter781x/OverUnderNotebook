#import "../auto-util.typ": *

#auton(
  "Programming Skills",
  datetime(year: 2024, month: 2, day: 25),
  "skills.cpp",
  [
    This code attempts to score as many points as possible in the 60-second skills
    period. We do this by first matchloading, then crossing under the elevation bar
    to make 2 rams into the right side of the goal. Then we go around the center
    triballs and make 2 rams into the front side of the goal. Next, we sweep the
    triballs in the barrier corner and matchload zone and make 2 rams into the left
    side of the goal. Finally we elevate on the blue elevation bar and retract the
    lift with 2 seconds left in the period to gain 10 points.

    This auto skills route consistently scores 170+ points.
  ],
)[
// https://excalidraw.com/#json=MVPLeZyU88mukurW_liIF,i0q5jTXChyP0Dsze-3bwcw
#figure(image("./route.svg", width: 100%), caption: [ auton route ])

```cpp
  void runSkills() {
  lemlib::Timer timer {60000};
  matchload(2, INT_MAX);
  // matchload();

  // set slew to 5 for skills
  Robot::chassis->lateralSettings.slew = 5;

  // intake matchload for jumping over bar
  Robot::Actions::intake();

  // go down elevation alley
  // make sure we don't hit short barrier
  Robot::chassis->moveToPoint(-TILE_LENGTH * .75, -TILE_LENGTH * 2.65, 5000,
                              {.minSpeed = 127});
  pros::delay(500);
  // wait until the robot's y position is past the short barrier
  waitUntil([] {
    return Robot::chassis->getPose().y < -TILE_LENGTH * 2.3 ||
           !isMotionRunning();
  });
  Robot::chassis->cancelMotion();

  // get past second short barrier
  Robot::chassis->moveToPoint(TILE_LENGTH, -TILE_LENGTH * 2.5, 5000,
                              {.minSpeed = 127});

  // time catapult retract as we go under elevation bar
  waitUntil([] {
    return Robot::chassis->getPose().x > -TILE_LENGTH * .75 ||
           !isMotionRunning();
  });
  printf("fire\n");
  Robot::Subsystems::catapult->fire();

  // wait until the robot's x position is past the elevation bar
  waitUntil([] {
    return Robot::chassis->getPose().x > -TILE_LENGTH * .5 ||
           !isMotionRunning();
  });
  Robot::chassis->cancelMotion();
  Robot::chassis->setPose(Robot::chassis->getPose() + lemlib::Pose {0, -3},
                          false);

  // go to the right side of the goal
  Robot::chassis->moveToPose(TILE_LENGTH * 2.5, -TILE_LENGTH, UP, 5000);
  // wait until facing towards goal
  waitUntil([] { return robotAngDist(UP) < 15 || !isMotionRunning(); });
  // give a bit of time to ram
  Robot::chassis->cancelMotion();
  Robot::chassis->moveToPoint(TILE_LENGTH * 2.5, 0, 700, {.minSpeed = 127});
  Robot::chassis->waitUntilDone();
  printf("ram!!!\n");

  // remove triball from intake
  Robot::Actions::outtake();
  // second ram
  // back out of goal
  tank(-127, -127, 300, 3);
  tank(127,127,150,3);
  // ram into goal
  Robot::chassis->moveToPoint(0, 100000000, 600, {.minSpeed = 127});
  Robot::chassis->waitUntilDone();
  // adjust y a bit: y = y + 4
  Robot::chassis->setPose(Robot::chassis->getPose().x,
                          Robot::chassis->getPose().y + 4,
                          Robot::chassis->getPose().theta);
  // back out of goal
  tank(-127, -127, 400, 0);

  // go around center triballs
  lemlib::Pose aroundFrontTriballsTarget {TILE_LENGTH * .75,
                                          -TILE_LENGTH * 1.35};
  Robot::chassis->moveToPoint(aroundFrontTriballsTarget.x,
                              aroundFrontTriballsTarget.y, 5000,
                              {.minSpeed = 127});
  // wait until having gone around center triballs
  waitUntilDistToPose(aroundFrontTriballsTarget, 12, 100, true);
  Robot::chassis->cancelMotion();

  // prevent sudden jolt
  tank(96,96,0,0);
  tank(64,-64,600, 5);

  // face towards center triballs
  Robot::chassis->moveToPose(TILE_LENGTH * 1.75, -TILE_LENGTH * .75, RIGHT,
                             2000, {.minSpeed = 64});
  // wait until facing towards center triballs
  waitUntil([] { return robotAngDist(RIGHT) < 10 || !isMotionRunning(); });
  Robot::chassis->cancelMotion();

  // expand the wings in preparation for ram into center
  Robot::Actions::expandBothWings();
  Robot::chassis->moveToPoint(MAX_X, -TILE_RADIUS, 800, {.minSpeed = 127});
  Robot::chassis->waitUntilDone();

  //adjust odom
  Robot::chassis->setPose(Robot::chassis->getPose() + lemlib::Pose {-4, 2},
                          false);

  // get out of goal
  Robot::Actions::retractBothWings();
  Robot::chassis->moveToPoint(TILE_LENGTH * .75, Robot::chassis->getPose().y,
                              5000, {.forwards = false, .minSpeed = 64});

  // second center ram
  // face towards center triballs
  Robot::chassis->moveToPose(TILE_LENGTH * 1.75, TILE_LENGTH * .6, RIGHT, 2000,
                             {.minSpeed = 64});
  pros::delay(500);
  // wait until facing towards center triballs
  waitUntil([] { return robotAngDist(RIGHT) < 10 || !isMotionRunning(); });
  Robot::chassis->cancelMotion();

  // expand the wings in preparation for ram into center
  Robot::Actions::expandBothWings();

  // ram into center second time
  Robot::chassis->moveToPoint(MAX_X, TILE_RADIUS, 1100, {.minSpeed = 127});
  Robot::chassis->waitUntilDone();
  Robot::Actions::retractBothWings();

  // get out of goal
  lemlib::Pose outOfTheGoalTarget {Robot::Dimensions::drivetrainLength / 2 + 2,
                                   TILE_LENGTH};
  Robot::chassis->moveToPoint(outOfTheGoalTarget.x, outOfTheGoalTarget.y, 1000,
                              {.forwards = true, .minSpeed = 127});
  // wait near pose
  waitUntilDistToPose(outOfTheGoalTarget, 9, 100, true);

  // then face up
  Robot::chassis->turnTo(0, 10000000, 1000);
  // wait until facing up
  waitUntil([] { return robotAngDist(UP) < 30 || !isMotionRunning(); });
  Robot::chassis->cancelMotion();

  // sweep triballs in barrier corner
  lemlib::Pose barrierCornerSweepTarget {TILE_LENGTH * 1.6,
                                         TILE_LENGTH * 1.5 - 2};
  Robot::chassis->moveToPose(barrierCornerSweepTarget.x,
                             barrierCornerSweepTarget.y, RIGHT, 2000,
                             {.minSpeed = 64});
  // wait until near pose
  waitUntilDistToPose(barrierCornerSweepTarget, 8, 100, true);
  Robot::chassis->cancelMotion();

  // sweep triballs next to matchload zone
  lemlib::Pose matchloadZoneSweepTarget {TILE_LENGTH * 1.5, TILE_LENGTH * 2.7};
  Robot::chassis->moveToPoint(matchloadZoneSweepTarget.x,
                              matchloadZoneSweepTarget.y, 1500,
                              {.minSpeed = 64});
  // wait until near pose
  waitUntilDistToPose(matchloadZoneSweepTarget, 9, 100, true);
  Robot::chassis->cancelMotion();

  // ram into left side of goal
  Robot::chassis->moveToPose(TILE_LENGTH * 2.6, TILE_LENGTH, DOWN, 2200,
                             {.minSpeed = 64});
  Robot::chassis->waitUntilDone();

  // second ram
  // back out of goal
  tank(-127, -127, 300, 3);
  // ram into goal
  Robot::chassis->moveToPoint(0, -10000000, 700, {.minSpeed = 127});
  Robot::chassis->waitUntilDone();
  // back out of goal
  tank(-127, -64, 400, 0);

  // elevation
  Robot::chassis->moveToPose(-TILE_LENGTH, TILE_LENGTH * 2.5, LEFT, 5000);
  Robot::chassis->waitUntil(12);
  Robot::Subsystems::lift->extend();

  // wait until 2 seconds left in auton to retract the lift
  waitUntil(
      [&timer] { return !isMotionRunning() || timer.getTimeLeft() < 2000; });
  Robot::chassis->cancelMotion();
  Robot::Subsystems::lift->retract();
}
```
]