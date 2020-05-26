# Assignment 2

## Author
Jesse Lee

## Description
A small testing script that aims to simulate the undisclosed Git tests (test 14 - test 16).

### Usage
1. Clone repository
2. Move `httpserver` executable into `asg2` directory
3. `./mintest.sh`
4. Open `mintest.out` to look at test results

### Notes
Some known issues with these tests:
- May have issues if user's logging mechanism is too slow.
- Tests are optimized for asynchronous logging design.
- Testing for files of length 0 are incorrect (if the user chooses to modify file generators).
- Mixed responses where 30% of users state that passing this test script but failing Git tests and vice versa.

### Credits
Huge credit to Aviv Brook for providing a script that outputs the contents of a file into the format specified by the specification.