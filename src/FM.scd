s.options.blockSize = 16;
s.reboot;

///////////////////////////////////////////////////

// following the paper by XYZ


// 2 oscillators
(
Fb1_ODEdef(\FM4, { |t, state, a11, a12, a21, a22, omega1, omega2|
	var ld1, ld2, c1, c2, x, y;

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
		\tm.kr(700), t0: 0,y0:  [0, 1, 1, 0]
	);
	eq.clump(2).sum * 0.1
}).play
)



// display parameters and signals
(
[\a11, \a12, \a21, \a22, \omega1, \omega2].do { |x| ControlSpec.add(x, [-2, 2, \lin]) };
Ndef(\fm).gui;
s.scope.style_(2);
)