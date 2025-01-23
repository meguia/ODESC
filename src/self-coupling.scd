// you may try this if it is not too inefficient
s.options.blockSize = 1;
s.options.sampleRate = 96000;
s.options.outDevice = "External Headphones";
s.reboot;



// or this
s.options.blockSize = 8;
s.options.sampleRate = 48000;
s.reboot;

///////////////////////////////////////////////////

// 1.1. The symmetric oscillator and the oscillation on the circle

// harmonic oscillator
// note, we name "y" to "state",
// the initial conditions y0 are the initial conditions of state.
(
Fb1_ODEdef(\harmonic, { |t, state, omega = 1.0|
	var x = state[0];
	var y = state[1];
	[
		{ y },
		{ omega.squared.neg * x }
	]
}, t0: 0, y0: [1, 0]);
)


(
Ndef(\harmonic, {|omega=0.5|
	var state = Fb1_ODE.ar(\harmonic, [omega], 400, y0:[1,0], leakDC: false);
	state * 0.1
}).play;
)

// ellipse is visible in scope
// display parameters and signals
(
ControlSpec.add(\omega, [0.01, 2, \lin]);
Ndef(\harmonic).gui;
s.scope.style_(2);
)


/*

given the two equations:

x' = v
v' = omega.squared.neg * x

we can factor omega into the coordinates (streching the x axis by omega)
so that we can now write

x' = omega * y
y' = omega.neg * x


*/


// harmonic oscillator with constant radius
(
Fb1_ODEdef(\harmonic, { |t, state, omega = 1.0|
	var x = state[0];
	var v = state[1];
	[
		{ v * omega },
		{ omega.neg * x }
	]
}, t0: 0, y0: [1, 0]);
)


(
Ndef(\harmonic, {|omega=0.5|
	var state = Fb1_ODE.ar(\harmonic, [omega], 400, y0:[1,0], leakDC: false);
	state * 0.2
}).play;
)

// now the shape is independent of omega (which still changes the frequency)
// display parameters and signals
(
ControlSpec.add(\omega, [0.01, 8, \exp]);
Ndef(\harmonic).gui;
s.scope.style_(2);
)



// harmonic oscillator with constant radius in polar coordinates
(
Fb1_ODEdef(\harmonic, { |t, state, omega = 1.0|
	var r = state[0]; // radius
	var theta = state[1]; // angle
	[
		{ 0 }, // we do not change the radius (amplitude)
		{ omega.neg } // the angular frequency is constant: we always multiply by a constant factor
	]
}, t0: 0, y0: [1, 1]);
)


(
Ndef(\harmonic, {|omega=0.5|
	var state = Fb1_ODE.ar(\harmonic,
		argList: [omega].lag,
		tMul: 400,
		y0:[1,1],
		leakDC: false
	);
	var p = Polar(*state); // polar coordinates
	[p.real, p.imag] * 0.2
}).play;
)

// now the shape is independent of omega (which still changes the frequency)
// display parameters and signals
(
ControlSpec.add(\omega, [0.01, 8, \exp]);
Ndef(\harmonic).gui;
s.scope.style_(2);
)

// use a cursor mapping
Ndef(\mouseX, { MouseX.kr(0.01, 8, 1) }); Ndef(\harmonic).set(\omega, Ndef(\mouseX));
Ndef(\harmonic).unset(\omega); // unlink it from the cursor again

// after a short while, we get floating point inaccuracies: theta grows and grows
// but in fact, the angle is a cyclic value, for which any theta + 2pi = theta.
// so we want to numerically keep the angle wrapped into the range [0..2pi[.
// this can be done with theta % 2pi. But we need to be able to filter the state itself
// not just through its derivative.
// This is where the "compose" function in Fb1_ODE is useful:
// here, we keep the radius untouched, but wrap theta in range.

(
Ndef(\harmonic, {|omega=0.5|
	var state = Fb1_ODE.ar(\harmonic,
		argList: [omega].lag,
		tMul: 400,
		y0:[1,1],
		leakDC: false,
		compose: { |state|
			var r = state[0], theta = state[1];
			[r, theta % 2pi]
		}
	);
	var p = Polar(*state); // polar coordinates
	[p.real, p.imag] * 0.2
}).play;
)




// 5a, 5b // FIXME FIXME.


// harmonic oscillator with dissipation in both variables
(
Fb1_ODEdef(\harmonic, { |t, state, omega = 1.0, gamma = 1.0|
	var x = state[0];
	var y = state[1];
	[
		{ (omega * y) - (gamma * x) },
		{ (omega.neg * x) - (gamma * y) }
	]
}, t0: 0, y0: [1, 0]);
)


(
Ndef(\harmonic, {|omega=0.5, gamma = 1|
	var state = Fb1_ODE.ar(\harmonic, [omega, gamma], 400, y0:[1,0], leakDC: false);
	state * 0.2
}).play;
)

// now the shape is independent of omega (which still changes the frequency)
// display parameters and signals
(
ControlSpec.add(\omega, [0.01, 8, \exp]);
ControlSpec.add(\gamma, [0.02, 4, \lin]);
Ndef(\harmonic).gui;
s.scope.style_(2);
)


// 1.2 Revisiting the self-oscillator. Hopf Normal Form

// TODO

// 1.3 The self modulated oscillator and the first derivation of the Adler’s equation


// simplest case: just one oscillator modulating itself

(
Fb1_ODEdef(\selfmodulation, { |t, state, alpha = 0, omega = 0.5|
	var x, y;
	x = state[0];
	y = state[1];

	[
		{  (omega * y) + (alpha * x * y) },
		{ ((omega * x) + (alpha * x * x)).neg },
	]
}, y0: [1, 1]);
)


(
Ndef(\selfmodulation, {
	var l = \lag.kr(0.2);
	var params = [\alpha.kr(0.02, l), \omega.kr(0.5, l)];
	0.1 * Fb1_ODE.ar(\selfmodulation, params, 700, y0:  [0, 1]);
}).play
)



// display parameters and signals
(
ControlSpec.add(\omega, [0.01, 4, \exp]);
ControlSpec.add(\alpha, [0, 10, \lin]);
Ndef(\selfmodulation).gui;
s.scope.style_(2);
)



// we can remap a little:

(
Ndef(\selfmodulation, {
	var l = \lag.kr(0.2);
	var factor = \selfMod.kr(0, l);
	var omega = \omega.kr(0.5, l);
	var alpha = omega * factor;
	var params = [alpha, omega];
	0.1 * Fb1_ODE.ar(\selfmodulation, params, 700, y0:  [0, 1]);
}).play
)



// display parameters and signals
(
ControlSpec.add(\omega, [0.01, 4, \exp]);
ControlSpec.add(\selfMod, [0, 1, \lin]);
Ndef(\selfmodulation).gui;
s.scope.style_(2);
)



// a reparametrisation:

(
Fb1_ODEdef(\selfmodulation, { |t, state, beta = 0, omega = 0.5|
	var x, y;
	x = state[0];
	y = state[1];

	[
		{ omega * (y + (beta * x * y)) },
		{ omega * (x + (beta * x * x)).neg },
	]
}, y0: [1, 1]);
)



/*

1.4

Multiple mutually modulated oscillators

*/

(
~makeDef = { |name, numOscillators|
	Fb1_ODEdef(name, { |t, state, as, oms|
		var ld, x, y, xy, xx, a;
		var n = state.size div: 2;

		oms = oms.asArray;
		a = as.asArray.clump(n);

		x = state[0,2..]; // all even indices are x
		y = state[1,3..]; // all odd indices are y
		xy = x * y;
		xx = x.squared;

		n.collect { |i|
			[
				{ oms[i] * (y[i] + sum(a[i] * xy)) },
				{ oms[i] * (x[i] + sum(a[i] * xx)).neg },
			]
		}.flat


	}, y0: [0, 1].wrapExtend(numOscillators * 2).postln);
};

~makeNdef = { |name, numOscillators|
	Ndef(name, {
		var l = \lag.kr(0.2);
		var eq = Fb1_ODE.ar(name,
			[
				\a.kr(0 ! numOscillators.squared),
				\oms.kr(1 ! numOscillators)
			],
			400,
			y0:  [0, 1].wrapExtend(numOscillators * 2)
		);
		eq
	});
	Ndef(\out, { Splay.ar(Limiter.ar(Ndef.ar(name))) }).play;
	Ndef(name)
};

~makeGUI = { |name, numOscillators|
	var n = numOscillators.squared;
	Ndef(name).scope.style_(2);
	if(numOscillators > 1) {
		ControlSpec.add(\a, [0!n,1!n]);
	} {
		ControlSpec.add(\a, [0, 1])
	};
	Ndef(name).gui;
};

// make an intermapping for exploring different parameter relationships
// whith the xy-cursor movement
~mapAllToCursor = { |name, paramName, numOscillators, strength = 0.1|
	var c = { rrand(0, 2.0) } ! numOscillators;
	Ndef(\ctl, {
		var cursor = [MouseX.kr, MouseY.kr];
		sin(cursor * 2pi + (c * pi)) + 0.3 * strength max: 0
	});
	Ndef(\ctl)[1] = Task {
		loop {
			var a = s.getControlBusValues(Ndef(\ctl).index, numOscillators).round(0.001).postln;
			Ndef(name).set(paramName, a);
			0.1.wait;
		};
	};
	//Ndef(name).set(paramName, Ndef(\ctl)); // this would map continuously.
};

//~unmapCursor = { |name, paramName| Ndef(name).unset(paramName) };
)


~makeDef.(\fm1, 1);
~makeNdef.(\fm1, 1);
~makeGUI.(\fm1, 1);


~makeDef.(\fm2, 2);
~makeNdef.(\fm2, 2);
~makeGUI.(\fm2, 2);

~makeDef.(\fm3, 3);
~makeNdef.(\fm3, 3);
~makeGUI.(\fm3, 3);

~mapAllToCursor.(\fm3, \a, 3, 0.2);
~unmapCursor.(\fm2, \a);


Ndef(\fm3).clear;

// introspection
Ndef(\ctl).scope
Tdef(\resend, { loop { 2.wait; Ndef(\fm2).send } }).play
NdefMixer(s);






/*
2 Coupled Oscillators on the circle

2.1 General formula for coupled oscillators: the Kuramoto Model

*/

(
~makeDef = { |name, numOscillators|
	Fb1_ODEdef(name, { |t, state, oms, k|
		var sys;
		var thetas = state.keep(numOscillators);
		numOscillators.collect { |i|
			{
				oms[i] + (k * sum(sin(thetas - thetas[i])))
			}
		}
	}, y0: 0 ! numOscillators);
};

~makeNdef = { |name, numOscillators|
	Ndef(name, {
		var l = \lag.kr(0.2);
		var oms = \oms.kr(1 ! numOscillators, l);
		var k = \k.kr(1, l);
		var sys = Fb1_ODE.ar(name,
			argList: [oms, k],
			tMul: 400,
			y0:  0.3 ! numOscillators,
			compose: { |state| state.wrap2(2pi * numOscillators) },
			leakDC: false,
			intType: \rk4, // <-- not sure if necessary.
		);

		var val = sys.sin;
		//val - val.rotate(1)
		val
	});
	Ndef(\out, { Splay.ar(Limiter.ar(Ndef.ar(name))) }).play;
	Ndef(name)
};

~makeGUI = { |name|
	Ndef(name).scope.style_(0);
	ControlSpec.add(\k, [0, 1]);
	Ndef(name).gui;
};


)

// 2.2 Two simple coupled oscillators and the second derivation of the Adler’s equation

Ndef(\kuramoto).clear;
~makeDef.(\kuramoto, 2);
~makeNdef.(\kuramoto, 2);
~makeGUI.(\kuramoto);
Ndef(\kuramoto).set(\oms, [0.4, 0.47], \k, 0.05);
Ndef(\kuramoto).set(\oms, [0.4, 0.47], \k, 0.08);
Ndef(\kuramoto).set(\oms, [0.4, 0.47], \k, 0.144);


// 2.3 Three uniformly coupled oscillators

~makeDef.(\kuramoto, 3);
~makeNdef.(\kuramoto, 3);
~makeGUI.(\kuramoto);
Ndef(\kuramoto).set(\oms, [0.4, 0.47, 0.65], \k, 0.05);
Ndef(\kuramoto).set(\oms, [0.4, 0.47, 0.65], \k, 0.08);
Ndef(\kuramoto).set(\oms, [0.4, 0.47, 0.65], \k, 0.144);




~makeDef.(\kuramoto, 8);
~makeNdef.(\kuramoto, 8);
~makeGUI.(\kuramoto);
Ndef(\kuramoto).set(\oms, [0.4, 0.47, 0.65].wrapExtend(8), \k, 0.144);
