///
module hello;

version(unittest) {} else
void main()
{
    import std.stdio;
    writeln("Hello D");
}

/**
Two stars will result in a symbol being exposed on the documentation.
Try it: dub -b ddox
*/
auto myFun()
{
    return 1;
}

/// Three backslahes work too
unittest
{
    assert(myFun() == 1, "myFun() returned invalid output.");
}
