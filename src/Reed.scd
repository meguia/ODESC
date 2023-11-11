///////////////////
// Reed Model

// ODE Definition using Fb1

(
Fb1_ODEdef(\Reed, { |t, y, mu = 1.0, k=1.0|
    [
		{ y[1] },
		{ ((mu  - y[1].squared) * y[1]) - (k * y[0]) }
    ]
}, 0, [0, 1], 1, 1);
)

// Synth

(
Ndef(\reed, {|mu=0.1, k=1, amp=0.2, tm=400|
	var r = Fb1_ODE.ar(\Reed, [mu,k],tm, 0, [0, 1]);
	r*amp;
}).play;
)

Ndef(\reed).gui;

////////////////////////////////////////////
// Using SythDef


(
SynthDef(\REED, {
	var sig;
	sig= Fb1_ODE.ar(\Reed, [\mu.kr(0.1), \k.kr(3.0)], \tm.kr(500), 0, [1.0, 0]);
	Out.ar(0, sig*\amp.kr(0.2))
}, metadata: (specs: (
	mu: [0.0, 4.0, \lin, 0, 0.1],
	k: [0.0, 10.0, \lin, 0, 0.1],
	amp: [0.001, 0.5, \exp, 0, 0.2],
	tm: [1,4000, \lin, 0, 1000]
)
)).add;
)

(
~scope = Stethoscope();
~scope.style = 2;
)

SynthDescLib.global[\REED].makeGui;
