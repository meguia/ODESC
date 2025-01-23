s.options.blockSize = 4;
s.options.sampleRate = 48000;
s.reboot;


///////////////////////////////////////////////////

/*

Dynamical Systems for Audio Synthesis: Embracing Nonlinearities and Delay-Free Loops (David Medine).
this is a 2-oscillator model that could be extended to more easily.

The 2-dimensional systems can, however, be refactored into 1-dimensional systems
in a circle, which makes it easier to interpret their behaviour.


*/


// 2 oscillators
(
Fb1_ODEdef(\FM4, { |t, state, a11, a12, a21, a22, omega1, omega2|
	var ld1, ld2, c1, c2, x, y;

	state = state.drop(-1); // drop the last element, which is time.

	x = state[0,2..];
	y = state[1,3..];

	ld1 = (a11 * x[0]) + (a12 * x[1]);
	ld2 = (a21 * x[0]) + (a22 * x[1]);

	c1 = omega1 + ld1;
	c2 = omega2 + ld2;

	[
		{ c1 * y[0] },
		{ c1.neg * x[0] },
		{ c2 * y[1] },
		{ c2.neg * x[1] },

	]
}, y0: [1, 1, 1, 1]);
)


(
Ndef(\fm, {
	var eq, l = \lag.kr(0.2);
	eq = Fb1_ODE.ar(\FM4,
		[\a11.kr(0.02, l), \a12.kr(0.5, l), \a21.kr(0.1, l), \a22.kr(0.1, l), \omega1.kr(0.5, l), \omega2.kr(0.2, l)],
		\tm.kr(700), t0: 0, y0:  [0, 1, 1, 0]
	);
	eq * 0.1
}).play
)



// display parameters and signals
(
[\a11, \a12, \a21, \a22, \omega1, \omega2].do { |x| ControlSpec.add(x, [-2, 2, \lin]) };
Ndef(\fm).gui;
s.scope.style_(2);
)


/*

N Oscillators

*/


// THERE IS STILL A SHAPE PROBLEM WITH ARRAYS, CHECK AGAIN.
// Buffer UGen channel mismatch: expected 2, yet buffer has 1 channels

(
f = { |name, n|

	Fb1_ODEdef(name, { |t, state ... args|
		var ld, c, x, y, a, omega, eq, n2;

		state = state.drop(-1); // drop the last element, which is time.


		n2 = n.squared;
		a = args[0..n2-1];//\a.kr(0.5 ! n.squared);
		omega = args[n2..n2+n]; //\omega.kr(0.5 ! n);


		state = state.unbubble;
		x = state[0,2..];
		y = state[1,3..];

		ld = { |i| ({ |j| a[i*n+j] * x[j] } ! n).sum } ! n;
		c = omega * ld;

		eq = { |i|
			[
				{ c[i] * y[i] },
				{ c[i].neg * x[i] }
			]
		} ! n;
		eq.flat

	}, y0: 1 ! (2 * n));

};

)



(
var n = 4;
f.(\fmN, 4);
"this may take a while ....".postln;
Ndef(\fmN).clear;
Ndef(\fmN, {
	var eq;
	var l = \lag.kr(0.4);

	var a = \a.kr({1.0.rand} ! n.squared round: 0.1, l);
	var omega = \omega.kr({1.0.rand} ! n round: 0.1, l);

	//var a = { 1.0.rand } ! n.squared;
	//var omega =  { 1.0.rand } ! n;


	eq = Fb1_ODE.ar(\fmN, argList:  a ++ omega, tMul: \tm.kr(700), t0: 0, y0:  1 ! (2 * n));
	Splay.ar(eq.flat) * 0.1
}).play;
"---- ok, done! ----".postln;
)


// display parameters and signals
(
Ndef(\fmN).gui;
s.scope.style_(2);
)


Ndef(\fmN).set(\a, { 1.0.rand2 } ! 4);
Ndef(\fmN).set(\omega, { 1.0.rand2 } ! 2);

// randomise every second
Tdef(\x, { loop { 1.wait; Ndef(\fmN).set(\a, { 1.0.rand2 } ! 4) } }).play;




