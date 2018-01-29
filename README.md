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
[the install script](dlang.org/install.html) to setup a D compiler:

    source $(curl https://dlang.org/install.sh | bash -s dmd)

Or maybe you have a DMD compiler already installed on your system?

I want to use package X
-----------------------

For more advanced projects, usage of [DUB](https://code.dlang.org/getting_started)
- D's package manager - is recommended.
You can still use the Makefile for bootstrapping:

    make dub

I want to use Travis for my project
-----------------------------------

Simply enable the project on Travis.

I want to use Continuous Integration service X for my project
-------------------------------------------------------------

The D compiler bootstrapping in `make` will automagically work.
Alternatively, use [the install script](dlang.org/install.html).

I want to have nice documentation for my project
------------------------------------------------

The easiest way to get started, is to use `ddox`:

    dub -b ddox

Have a look at [veelo's gist](https://gist.github.com/veelo/f7668510bad2e8c9212ab66104541fcc)
to see how it can be setup to automatically publish the latest documentation to
your GitHub pages.

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

Why don't you use Docker?
-------------------------

Docker is typically used to allow a consistent work environment, but in my use cases Docker isn't available.
If you want to use Docker, check out the [D docker images](https://hub.docker.com/r/dlanguage/dmd/).

I have more questions
---------------------

Feel to ask them at the [D: Learn Forum](https://forum.dlang.org/group/learn).
