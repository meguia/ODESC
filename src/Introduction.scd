///////////////////////////////////////////
// Introductory material for the session //
// at the IMM,  November 2023            //
///////////////////////////////////////////



// a dynamical system can be described by a series of differential equations
// in a standard form, one equation for each of the variables
// representing the time derivative of that variable, that is its instantaneous change

// in order to find the time evolution of a dynamical system, an algorithm is used
// that integrates it approximately. There are many methods for this.
// we use the Fb1_ODE classes by Daniel Mayer to trace it out in real time audio.


// -- harmonic oscillator
// the rate of change of the first variable (here, the position) is given by the second
// the rate of change of the second variable (here the velocity) is given by the negative of the first

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


// adding a damping term into the oscillator
// damping is depends on the second variable (here velocity)

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





