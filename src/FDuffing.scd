
///////////////////////////////////////////////////
/// FORCED DUFFING

(
Fb1_ODEdef(\ForcedDuffing, { |t, y, mu = 0.1, beta= 1.0, omega = 0, a = 1|
    [
        { y[1] },
		{ y[1] * mu.neg + (y[0] * (beta - y[0].squared)) + (a * cos(omega * t)) }
    ]
}, 0, [0, 0], 1, 1);

SynthDef(\ForcedDuffing, {
	var mu = \mu.kr(0.1, spec: [0.0, 1.0, \lin, 0, 0.1]);
	var beta = \beta.kr(0.1, spec: [0.0, 2.0, \lin, 0, 0.1]);
	var omega = \omega.kr(1.0, spec: [0.1, 1.0, \exp, 0, 1.0]);
	var a = \a.kr(0.1, spec: [0, 2.0, \lin, 0, 0.1]);
	var tm = \tm.kr(1000, spec: [1,4000, \lin, 0, 1000]);
	var eq = Fb1_ODE.ar(\ForcedDuffing, [mu, beta, omega, a], tm, 0, [0, 1]);
	Out.ar(\out.kr, eq)
}).add;

Ndef(\ForcedDuffing, \ForcedDuffing);
)

(
~scope = Ndef(\ForcedDuffing).scope;
~scope.style = 2;
Ndef(\ForcedDuffing).gui;
)

Ndef(\ForcedDuffing).set(\mu, 0.29);
Ndef(\ForcedDuffing).set(\mu, 0.281);
Ndef(\ForcedDuffing).set(\mu, 0.29);
Ndef(\ForcedDuffing).set(\mu, 0.29);


// sound examples

(
Ndef(\x, {

	var sig = Ndef.ar(\ForcedDuffing) * 0.8;
	Limiter.ar(sig)

}).play

)


(
Ndef(\x, {
var sig, freq;
	sig = Ndef.ar(\ForcedDuffing) * 0.8;
	freq = sig * 2000 + 300;
	SinOsc.ar(freq) * 0.1
}).play
)



// force the duffing by an input
(
Fb1_ODEdef(\ForcedDuffingIn, { |t, y, mu = 0.1, beta= 1.0, a = 1, input|
    [
        { y[1] },
		{ y[1] * mu.neg + (y[0] * (beta - y[0].squared)) + (a * input) }
    ]
}, 0, [0, 0], 1, 1);
)

(
Ndef(\x, {
	var sig, freq, eq;
	sig = LFPulse.ar(MouseX.kr(1, 100, 1)) * SinOsc.ar(MouseY.kr(1, 400, 1));
	eq = Fb1_ODE.ar(\ForcedDuffingIn, [\mu.kr(0.02), \beta.kr(0.5), \a.kr(0.1), sig], \tm.kr(700), 0, [0, 1]);
	freq = eq * 8000 + 300;
	SinOsc.ar(freq) * 0.1
}).play
)
