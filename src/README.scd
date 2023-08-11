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


/*
The solver uses instances of Fb1_ODEdef:
*/

Fb1_ODEdef.keys;
Fb1_ODEdef.postAll;
