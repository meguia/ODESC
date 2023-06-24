
s.options.blockSize = 64;
s.reboot;

///////////////////////////////////////////////////
/// FORCED DUFFING

(
Fb1_ODEdef(\FDuffing, { |t, y, mu = 0.1, beta= 1.0, omega = 0, a = 1|
    [
        { y[1] },
		{ y[1] * mu.neg + (y[0]*(beta-y[0]*y[0])) +  (a * cos(omega * t)) }
    ]
}, 0, [0, 0], 1, 1);
)

Fb1_ODEdef.keys;

Fb1_ODEdef.postAll;

(
SynthDef(\FD, { |mu = 1, beta = 1.0, omega = 0.1, a = 0.1,amp = 0.2,tm = 1000|
	var sig = Fb1_ODE.ar(\FDuffing, [mu, beta, omega, a],tm, 0, [0, 1]);
	Out.ar(0,FreeVerb.ar(HPF.ar(sig,20.0)*amp))
}, metadata: (specs: (
	mu: [0.0, 1.0, \lin, 0, 0.1],
	beta: [0.0, 2.0, \lin, 0, 0.1],
	omega: [0.1, 1.0, \exp, 0, 1.0],
	a: [0, 2.0, \lin, 0, 0.1],
	amp: [0.001, 1.0, \exp, 0, 0.2],
	tm: [1,4000, \lin, 0, 1000]
)
)).add;
)

(
~scope = QStethoscope();
~scope.scopeView.style = 2;
SynthDescLib.global[\FD].makeGui;
)