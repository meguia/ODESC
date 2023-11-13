
//////////////////////////////////////////////////////////////////////
/// Chen Lee ATTRACTOR


(
Fb1_ODEdef(\Chenlee, { |t, y, a = 5.0, b = -10.0, d = -0.38|
    [
		{ (a*y[0]) - (y[1]*y[2]) },
		{ (b*y[1]) + (y[0]*y[2]) },
		{ (d*y[2]) + (y[0]*y[1])/3 }
    ]
}, 0, [0, 0, 0], 1, 1);

SynthDef(\VChenlee, {
	var sig = Fb1_ODE.ar(\Chenlee, [\a.kr(5.0), \b.kr(-10.0), \d.kr(-0.38)], \tm.kr(100), 0, [0, 1, 1]);
	Out.ar(\out.kr , sig*\amp.kr(0.1))

}, metadata: (specs: (
	a: [3.0, 6.0, \lin, 0, 0.01],
	b: [-15, -5.0, \lin, 0, 0.1],
	d: [-1.5, 0.0, \lin, 0, 0.01],
	amp: [0.001, 0.5, \exp, 0, 0.1],
	tm: [1,1000, \lin, 0, 100]
)
)).add;
)

Ndef(\VChenlee, \VChenlee);
Ndef(\VChenlee).gui;


(
SynthDef(\VChenlee2, {
	var env, sig;
	env = Fb1_ODE.ar(\Chenlee, [\a.kr(5.0), \b.kr(-6.24), \d.kr(-0.76)], \tm.kr(85), 0, [0, 1, 1]);
	sig = SinOsc.ar(\freq.kr(400) * [1, 1.03]);
	Out.ar(\out.kr, sig * env * \amp.kr(0.1))
}, metadata: (specs: (
	a: [3.0, 6.0, \lin, 0, 0.01],
	b: [-15, -5.0, \lin, 0, 0.1],
	d: [-1.5, 0.0, \lin, 0, 0.01],
	amp: [0.001, 0.5, \exp, 0, 0.1],
	freq: [80, 2800, \exp, 0, 0.1],
	tm: [1,1000, \lin, 0, 100]
)
)).add;
)

Ndef(\VChenlee, \VChenlee2);

(
~scope = Stethoscope();
~scope.style = 2;
SynthDescLib.global[\VChenlee2].makeGui;
)


///////////////////////////////////////////////////////
// ChenLee & VanderPol


(
Fb1_ODEdef(\Vanderpol, { |t, y, mu = 1.0, tau=1.0|
    [
		{ y[1] * tau },
		{ tau * (mu * y[1] * (1 - y[0].squared)) - (tau * y[0]) }
    ]
}, 0, [0, 1], 1, 1);
)

(
SynthDef(\Vvanderpol, {
	var sig;
	sig = Fb1_ODE.ar(\Vanderpol, [\mu.kr(1.0), \tau.kr(1.0)], \tm.kr(85), 0, [0, 1]);
	Out.ar(\out.kr, sig * \amp.kr(0.1))
}, metadata: (specs: (
	mu: [0.0, 3.0, \lin, 0, 0.01],
	tau: [0.1, 20.0, \lin, 0, 0.1],
	amp: [0.001, 0.5, \exp, 0, 0.1],
	tm: [1,400, \lin, 0, 100]
)
)).add;
)

Ndef(\VChenlee, \Vvanderpol);

(
SynthDef(\VChenleeVdp, {
	var env, sig;
	env = Fb1_ODE.ar(\Chenlee, [\a.kr(5.0), \b.kr(-6.24),\d.kr(-0.76)],\tm.kr(85), 0, [0, 1, 1]);
	sig = Fb1_ODE.ar(\Vanderpol, [\mu.kr(1.0), \tau.kr(1.0)],\tm.kr(85), 0, [0, 1]);
	Out.ar(\out.kr, sig * env * \amp.kr(0.1))
}, metadata: (specs: (
	a: [3.0, 6.0, \lin, 0, 0.01],
	b: [-15, -5.0, \lin, 0, 0.1],
	d: [-1.5, 0.0, \lin, 0, 0.01],
	mu: [0.0, 3.0, \lin, 0, 0.01],
	tau: [0.1, 20.0, \lin, 0, 0.1],
	amp: [0.001, 0.5, \exp, 0, 0.1],
	tm: [1,400, \lin, 0, 100]
)
)).add;
)

Ndef(\VChenlee, \VChenleeVdp);

(
~scope = QStethoscope();
~scope.scopeView.style = 2;
Ndef(\VChenlee).gui;
)


////////////////////////////////////////////////