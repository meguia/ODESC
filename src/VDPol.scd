///////////////////////////////
// Van der Pol Oscillator

// ODE Definition using Fb1

(
Fb1_ODEdef(\Vanderpol, { |t, y, mu = 1.0|
    [
		{ y[1] },
		{ mu * y[1] * (1 - y[0].squared) - y[0] }
    ]
}, 0, [0, 1], 1, 1);
)

// Synth

(
Ndef(\vdp, {|mu=1, amp=0.2, tm=100|
	var vdp = Fb1_ODE.ar(\Vanderpol, [mu],tm, 0, [0, 1]);
	vdp*amp;
}).play;
)

(
~scope = Stethoscope();
~scope.style = 2;
)


Ndef(\vdp).fadeTime = 5

Ndef(\vdp).xset(\tm,700,\amp,0.01)

Ndef(\vdp).xset(\mu,0.9)

////////////////////////////////////////////
// Using SythDef

(
SynthDef(\VDP, {
	var sig;
	sig= Fb1_ODE.ar(\Vanderpol, [\mu.kr(0.1)], \tm.kr(1000), 0, [1.0, 0]);
	Out.ar(0, sig*\amp.kr(0.2))
}, metadata: (specs: (
	mu: [-0.5, 1.0, \lin, 0, 0.1],
	amp: [0.001, 0.5, \exp, 0, 0.2],
	tm: [1,4000, \lin, 0, 1000]
)
)).add;
)

SynthDescLib.global[\VDP].makeGui;