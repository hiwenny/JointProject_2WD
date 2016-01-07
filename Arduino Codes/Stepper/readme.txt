This is a Library for Wiring or Arduino that drives a unipolar or bipolar stepper motor.

This is based on an example C++ library for Arduino 0004+, based on one created by 
Nicholas Zambetti for Wiring 0006+

Installation
--------------------------------------------------------------------------------

To install this library, just place this entire folder as a subfolder in your
Arduino/lib/targets/libraries folder.

When installed, this library should look like:

Arduino/lib/targets/libraries/Stepper              (this library's folder)
Arduino/lib/targets/libraries/Stepper/Stepper.cpp  (the library implementation file)
Arduino/lib/targets/libraries/Stepper/Stepper.h    (the library description file)
Arduino/lib/targets/libraries/Stepper/keywords.txt (the syntax coloring file)
Arduino/lib/targets/libraries/Stepper/examples     (the examples in the "open" menu)
Arduino/lib/targets/libraries/Stepper/readme.txt   (this file)

Building
--------------------------------------------------------------------------------

After this library is installed, you just have to start the Arduino application.
You may see a few warning messages as it's built.

To use this library in a sketch, go to the Sketch | Import Library menu and
select Stepper.  This will add a corresponding line to the top of your sketch:
#include <Stepper.h>

To stop using this library, delete that line from your sketch.

Geeky information:
After a successful build of this library, a new file named "Stepper.o" will appear
in "Arduino/lib/targets/libraries/Stepper". This file is the built/compiled library
code.

If you choose to modify the code for this library (i.e. "Stepper.cpp" or "Stepper.h"),
then you must first 'unbuild' this library by deleting the "Stepper.o" file. The
new "Stepper.o" with your code will appear after the next press of "verify"

