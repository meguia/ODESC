/*
nonlinear dynamic systems
modeled with SuperCollider
Manuel Eguia
*/



// Requirements

Quarks.install("miSCellaneous_lib");


/*
Note that the default block size is rather large for these use cases.
The code compiles more quickly if it is reduced.
*/

(
s.options.blockSize = 16;
s.reboot;
)



