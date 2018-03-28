Hello D
-------

[![Build Status](https://travis-ci.org/wilzbach/d-bootstrap.svg?branch=master)](https://travis-ci.org/wilzbach/d-bootstrap)
[![Code coverage](https://img.shields.io/codecov/c/github/wilzbach/d-bootstrap.svg?maxAge=86400)](https://codecov.io/gh/wilzbach/d-bootstrap)

To get you started with D, this is a small hello world application.
The Makefile will automatically download a D compiler - no installation necessary:

    make
    ./bin/hello

You can use LDC as well:

    make bin/hello_opt
    ./bin/hello_opt

I'm sure you can take it from there. It's all up to you!
Happy coding!


I don't like Make
-----------------

Instead of a Makefile, you can of course always use
[the install script](https://dlang.org/install.html) to setup a D compiler:

    source $(curl https://dlang.org/install.sh | bash -s dmd)

Or maybe you have a D compiler already installed on your system?
You can use this Makefile for bootstrapping your D compiler
and making sure the same compiler is used on all systems:

    make setup-dmd
    ./bin/dmd

Analogous the command `make setup-ldc` makes sure `ldc` is installed locally and available
via `bin/ldc` (LLVM-like interface) and `bin/ldmd` (DMD-like interface).

I want to use package X
-----------------------

For more advanced projects, usage of [DUB](https://code.dlang.org/getting_started)
- D's package manager - is recommended.
If you work in a environment where a D compiler isn't easily available or you
simply want to lock your project to a specific compiler version,
you can use the packaged `dub` for your scripts:

    ./bin/dub

Of course, you can also call `dub` from Make and integrate dub with other build steps:

    make dub

I want to use Travis for my project
-----------------------------------

Simply [enable the project on Travis](https://docs.travis-ci.com/user/getting-started).

I want to use Continuous Integration service X for my project
-------------------------------------------------------------

The D compiler bootstrapping in `make` will _auto-magically_ work.
Alternatively, use [the install script](dlang.org/install.html).

I want to have nice documentation for my project
------------------------------------------------

The easiest way to get started, is to use `ddox`:

    dub -b ddox

Have a look at [veelo's gist](https://gist.github.com/veelo/f7668510bad2e8c9212ab66104541fcc)
to see how it can be setup to automatically publish the latest documentation to
your GitHub pages.

You might also want to try [dpldocs.info's automatic generation](https://forum.dlang.org/thread/qeiapxuoamaumtggpqxl@forum.dlang.org).

I want to have tests and code coverage for my project
-----------------------------------------------------

First, add a unittests:

```d
unittest
{
    assert(1 == 1, "D math works as expected.");
}
```

All tests can be executed with:

    dub test

To generate coverage listing too, use the `unittest-cov` build mode:

    dub test -b unittest-cov

You can browse the `.lst` files manually, but if you use GitHub or BitBucket,
usage of the [CodeCov app](https://codecov.io/gh) is recommended.

I want to have static code analysis and linting
-----------------------------------------------

[D-Scanner](https://github.com/dlang-community/D-Scanner) is the swiss-army knife
for D source code:

    dub fetch dscanner
    dub run dscanner -- --styleCheck source

Add a custom configuration:

    dub run dscanner -- --defaultConfig
    mv ~/.config/dscanner/dscanner.ini .dscanner.ini
    dub run dscanner -- --styleCheck source --config .dscanner.ini

I want to have automatic source formatting
-----------------------------------------

[dfmt](https://github.com/dlang-community/dfmt) is a source code formatter for D:

    dub fetch dfmt
    dub run dfmt

Why don't you use Docker?
-------------------------

Docker is typically used to allow a consistent work environment, but in my use cases Docker isn't available.
If you want to use Docker, check out the [D docker images](https://hub.docker.com/r/dlanguage/dmd/).

What are the other Makefile targets?
------------------------------------

Target         | Description
---------------|-------------
bin/hello      | A normal build with DMD
bin/hello_opt  | An optimized build with LDC
bin/hello_lto  | An optimized build with LDC and link-time optimization (LTO)
dub            | Runs the application via DUB
dub_opt        | Runs the application via DUB with LDC
test           | Runs all unittests
style          | Runs static code analysis and style checking
format         | Reformats all code
clean          | Removes all generated data

I have more questions
---------------------

Feel to ask them at the [D: Learn Forum](https://forum.dlang.org/group/learn).
