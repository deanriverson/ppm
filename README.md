## PPM - The Pouder Pit Map Generator

This simple command line utility will (hopefully) generate a reasonable pit map for the Poudre FLL Qualifier.

### Building

This program is written in Dart and can be compiled to a native executable using the `dart2native` compiler.

**Note: Native compilation requires Dart 2.6 or later.**

From the project directory:

```bash
$> dart2native lib/ppm.dart -o ppm
```

### Running

Input is read from the `options.json` file in the current directory.  The JSON format consists of a single
object with a `teamNumbers` property that is an array of numbers.  An example is shown below.

```json
{
  "teamNumbers": [ 10000, 10001, 10002, 10003, ... ]
}
```

The SVG output is written to the `pitmap.svg` file.  There are currently no supported command line
arguments.  You simply invoke the executable you created when building the program from the same
directory that contains the options.json that specifies the team numbers.

```bash
$> ./ppm
ppm: team nums: [10000, 10001, 10002, 10003, ... ]
ppm: writing file "pitmap.svg"
```
