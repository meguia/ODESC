///////////////////////////////////////////
// Introductory material for the session //
// at the IMM,  November 2023            //
///////////////////////////////////////////


// A Dynamical Dystem can be defined by a set on N variables that evolve in time
// Y(t) = [y[0], y[1], ... y[N-1]], and a fixed rule for this its evolution.
// For a continuous dynamical system this rule is given by a system  of N ordinary
// differential equations (ODE). Each ODE expresses the time derivative
// (the instataneous rate of change) of each variable as a function of the other variables.

// In order to solve this ODEs and find the time evolution of the dynamical system,
// an algorithm is used that integrates them approximately. There are many methods for this.
// we use the Fb1_ODE classes by Daniel Mayer to trace it out in real time audio.


// -- harmonic oscillator
// The time derivative af the first variable (here, the position) is equal to the second variable that
// we associate with the velocity. This can be seen as the deffinition of the velocity.
// The rate of change of the second variable (the velocity) physically corresponds to the acceleration
// and then by the second Newton's law must be proportional to the forces. For an HO there are two forces:
// 1. a linear elastic force that is proportional to the displacement (position) but opposite in sign (y[0].neg)
// 2. a dissipation force that is proportional to the velocity and also opposite in sign
// we consider first the case without dissipation:

(
a = Fb1_ODEdef(\x, { |t, y|
	[
		{ y[1] },
		{ y[0].neg }
	]
}, y0: [0,0])
)

// with nextN, we can calculate a series of states from the Fb1_ODEdef directly
// get 2000 values, starting from time 0, and with a position 1.7, and 0 velocity, 0.01 timestep

x = a.nextN(2000, \sym2, 0, [1.7, 0], 0.01); // the values come in pairs
x.flop; // swapping rows and cols
x.flop.plot // plot the values


// adding the dissipation term into the oscillator

(
a = Fb1_ODEdef(\x, { |t, y|
	[
		{ y[1] },
		{ y[0].neg - (0.2 * y[1]) }
	]
}, y0: [0,0])
)

a.nextN(2000, \sym2, 0, [1, 0], 0.01).flop.plot;


// -- parameters
// parameters are values that are not changed by the system itself
// they can be set externally
// here we pass k, the stiffness, and gamma, the damping parameter (friction)

(
a = Fb1_ODEdef(\x, { |t, y, k = 1, gamma = 0.2|
	[
		{ y[1] },
		{ (k * y[0]).neg - (gamma * y[1]) }
	]
}, y0: [0,0])
)

a.nextN(2000, \sym2, 0, [1, 0], 0.01, [1, 0.2]).flop.plot; // the same behaviour as above
a.nextN(2000, \sym2, 0, [1, 0], 0.01, [16, 0.2]).flop.plot; // higher stiffness
a.nextN(2000, \sym2, 0, [1, 0], 0.01, [16, 0.8]).flop.plot; // higher friction


// to be able to run an Fb1_ODEdef as an audio process, we use the Fb1_ODE class
// the server should be booted with a small blockSize for efficiency (see Fb1_ODE doc)

s.options.blockSize = 8;
s.reboot;
Ndef.defaultReshaping = \elastic; // for automatic channel adjustment


// this shows the x-y-coordinates:
Ndef(\a, { Fb1_ODE.ar(\x, [20, 0.004], tMul: 100, y0: [1, 0]) * 0.5 }).scope.style_(2);

(
Ndef(\a, { |k = 200, mu = 0.01|
	var a = Fb1_ODE.ar(\x, [k, mu], tMul: 100, y0:[1,0]);
	a[0] * 0.1 // use the first variable as output and scale it

}).play;
)

// try different variants of systems, with k and mu
Ndef(\a).send([\k, 250, \mu, 0.1]);
Ndef(\a).send([\k, 350, \mu, 0.05]);
Ndef(\a).send([\k, 305, \mu, 0.2]);

// or set them as it runs. Start with zero damping, so it maintains the oscillation
Ndef(\a).send([\k, 250, \mu, 0]);
Ndef(\a).set(\k, 152);
Ndef(\a).set(\k, 252);
fork { 100.do { Ndef(\a).set(\k, 100.0.rand + 200); 0.01.wait } };





