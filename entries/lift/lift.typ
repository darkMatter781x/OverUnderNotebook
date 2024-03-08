#import "/packages.typ": notebookinator, gentle-clues
#import notebookinator: *
#import themes.radial.components: *
#import gentle-clues: *

#import "/util.typ": qrlink

#show: create-body-entry.with(
  title: "Lift State Machine",
  type: "program",
  date: datetime(year: 2024, month: 3, day: 7),
  author: "Andrew Curtis",
)
#grid(
  columns: 2,
  [
    = The Problem

    Our lift is unique in that if something goes wrong in code, it may cause
    irreparable damage to the lift. This is due to our use of two different
    solenoids, pneumatic valves which can be opened and closed with code, to control
    the retraction and expansion of the lift.

    If both solenoids are ever on, it is likely that the high pressure on both sides
    of the piston would cause the pistons to break. This is a very dire outcome as
    we lack any replacement pistons.

    To prevent any such situation is critical that the code be designed carefully
    and thoughtfully.
  ],
  // https://excalidraw.com/#json=5tTmPjl8nvGiVHXY5FSPx,VjuV-gwW6WdZQqIxjrqF6g
  figure(image("./schematic.svg"), caption: "Diagram of lift input and output"),
)
#grid(
  columns: 2,
  // https://excalidraw.com/#json=E5oITFqHUf3MkGYk6sDaI,mgigMblr2EqmSkHtE6R-og
  figure(
    image("./state-machine.svg", height: 50%),
    caption: "State Diagram of lift",
  ),
  [
  = The Solution

  To satisfy these constraints we decided to use a state machine. A state machine
  is essentially something that does a different thing depending on what state it
  is in. In our case, the state machine will be in one of three states:
  `retracted`, `extended`, or `idle`.

  State machines also have a concept of state transitions, in our case that is the
  driver's button presses. When the driver presses the button, the state machine
  will transition to a new state. For example, if the lift is currently retracted
  and the driver presses the up button, the state machine will transition to the
  `extended` state.

  = The Code
  In the code below, we define a class `LiftArmStateMachine` which has three
  states:
  - `IDLE`
  - `RETRACTING`
  - `EXTENDING`
  Then we define the methods `retract`, `release`, and `extend` which change the
  state. Finally, we define the `update` method which runs every 10ms and changes
  the state of the solenoids to match that of the state machine.
  ],
)
#par(
  )[
  #set align(center)
  #grid(
    columns: 3,
    figure(
      qrlink(
        "https://github.com/meisZWFLZ/OverUnder781X/blob/master/src/subsystems/lift.cpp",
        width: 10em,
      ),
      caption: "lift.cpp",
    ),
    figure(
      qrlink(
        "https://github.com/meisZWFLZ/OverUnder781X/blob/master/include/lift.h",
        width: 10em,
      ),
      caption: "lift.h",
    ),
    figure(
      qrlink(
        "https://github.com/meisZWFLZ/OverUnder781X/blob/ee42206c2cbc1b4a4e523d76857823313b6e9964/src/main.cpp#L409C1-L437C6",
        width: 10em,
      ),
      caption: "driver control code",
    ),
  )
]
```cpp
// include/lift.h
#pragma once

#include "pros/adi.hpp"

class LiftArmStateMachine {
 public:
 // our possible states
 enum STATE { IDLE, RETRACTING, EXTENDING };

 // initializes state machine object and gives the machine the solenoids
 LiftArmStateMachine(pros::ADIDigitalOut* retract,
 pros::ADIDigitalOut* extend);

 // retrieve the current state of the state machine
 STATE getState() const;

 // state changes
 // set the state to retracting
 void retract();
 // set the state to idle
 void release();
 // set the state to extending
 void extend();

 // run every 10 ms
 void update();

 // these members cannot be accessed from outside the class
 private:
 // the solenoids
 pros::ADIDigitalOut* retractPiston;
 pros::ADIDigitalOut* extendPiston;
 // the current state
 STATE state = IDLE;
};
``` ```cpp
// src/subsytstems/lift.cpp
// construct the lift arm state machine
LiftArmStateMachine::LiftArmStateMachine(pros::ADIDigitalOut* retract,
 pros::ADIDigitalOut* extend)
 : retractPiston(retract), extendPiston(extend) {
 this->retractPiston->set_value(false);
 this->extendPiston->set_value(false);
};

// run every 10 ms
void LiftArmStateMachine::update() {
 switch (this->state) {
 // when in the idle state:
 case IDLE:
 // set both to false (ie: close the valves)
 this->retractPiston->set_value(false);
 this->extendPiston->set_value(false);
 break;

 // when in the retracting state:
 case RETRACTING:
 // only set retractPiston to true (ie: only open the retract valve)
 this->retractPiston->set_value(true);
 this->extendPiston->set_value(false);
 break;

 // when in the extended state:
 case EXTENDING:
 // only set extendPiston to true (ie: only open the expand valve)
 this->retractPiston->set_value(false);
 this->extendPiston->set_value(true);
 break;
 }
}

// extend the pistons
void LiftArmStateMachine::extend() { this->state = EXTENDING; }

// retract the pistons
void LiftArmStateMachine::retract() { this->state = RETRACTING; }

// stop sending air to the pistons
void LiftArmStateMachine::release() { this->state = IDLE; }

// get the current state of the lift arm state machine
LiftArmStateMachine::STATE LiftArmStateMachine::getState() const {
 return this->state;
}
```
This code handles our state transitions in driver mode://typstfmt::off
```cpp
// excerpt from driver control code in main.cpp:
// if up is pressed
if (!up && prevUp) {
  switch (Robot::Subsystems::lift->getState()) {
    // if the current state is retracting, then stop retracting
    case LiftArmStateMachine::STATE::RETRACTING:
      Robot::Subsystems::lift->release();
      break;
    // if the current state is idle, then extend the lift
    case LiftArmStateMachine::STATE::IDLE:
      Robot::Subsystems::lift->extend();
      break;
    // if the current state is extending the do nothing
    case LiftArmStateMachine::STATE::EXTENDING: break;
  }
}
// if down is pressed
if (!down && prevDown) {
  switch (Robot::Subsystems::lift->getState()) {
    // if the current state is retracting, then do nothing
    case LiftArmStateMachine::STATE::RETRACTING: break;
    // if the current state is idle, then retract the lift
    case LiftArmStateMachine::STATE::IDLE:
      Robot::Subsystems::lift->retract();
      break;
    // if the current state is extending, then stop extending
    case LiftArmStateMachine::STATE::EXTENDING:
      Robot::Subsystems::lift->release();
      break;
  }
}
```
//typstfmt::on