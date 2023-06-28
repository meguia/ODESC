Quarks.gui

////////////////////////////////////////////////////////////////////////
/// TWO COUPLED DUFFING VAN DER POL OSCILLATORS

(
Fb1_ODEdef(\Vanderpol, { |t, y, mu = 1.0, tau=1.0|
    [
		{ y[1]*tau },
		{ tau*(mu*y[1]*(1-(y[0]*y[0]))) - (tau*y[0]) }
    ]
}, 0, [0, 1], 1, 1);
)

(
Fb1_ODEdef(\DFVanderpol, { |t, y, mu = 1.0, beta=1.0|
    [
		{ y[1] },
		{ ((mu - y[0]*y[0]) * y[1]) + (y[0]*(beta-y[0]*y[0])) }
    ]
}, 0, [0, 1], 1, 1);
)

(
SynthDef(\VDP, {
	var sig;
	sig= Fb1_ODE.ar(\Vanderpol, [\mu.kr(0.1), \tau.kr(0.1)],\tm.kr(1000), 0, [0, 1]);
	Out.ar(0, sig*\amp.kr(0.2))
}, metadata: (specs: (
	mu: [-0.5, 1.0, \lin, 0, 0.1],
	tau: [0.0, 1.0, \lin, 0, 0.1],
	amp: [0.001, 0.5, \exp, 0, 0.2],
	tm: [1,4000, \lin, 0, 1000]
)
)).add;
)

(
SynthDef(\DVDP, {
	var sig;
	sig= Fb1_ODE.ar(\DFVanderpol, [\mu.kr(0.1), \beta.kr(0.1)],\tm.kr(1000), 0, [0, 1]);
	Out.ar(0, sig*\amp.kr(0.2))
}, metadata: (specs: (
	mu: [-0.5, 1.0, \lin, 0, 0.1],
	beta: [0.0, 1.0, \lin, 0, 0.1],
	amp: [0.001, 0.5, \exp, 0, 0.2],
	tm: [1,4000, \lin, 0, 1000]
)
)).add;
)



(
Fb1_ODEdef(\VDPD2, { |t, y, mu1 = 0.1, beta1= 1.0, mu2 = 0.1, beta2= 1.0, k=0.0|
    [
		{ y[1] + (k*y[2])},
		{ ((mu1 - y[0]*y[0]) * y[1]) + (y[0]*(beta1-y[0]*y[0])) },
		{ y[3] + (k*y[0])},
		{ ((mu2 - y[2]*y[2]) * y[3]) + (y[2]*(beta2-y[2]*y[2])) }
    ]
}, 0, [0, 0, 0, 0], 1, 1);
)

(
SynthDef(\VDPDC, {
	var sig;
	sig= Fb1_ODE.ar(\VDPD2, [\mu1.kr(0.1), \beta1.kr(0.1),\mu2.kr(0.1), \beta2.kr(0.1),\kappa.kr(0.1) ],\tm.kr(1000), 0, [0, 1, 0, 1]);
	Out.ar(0, sig*\amp.kr(0.2))
}, metadata: (specs: (
	mu1: [-0.5, 1.0, \lin, 0, 0.1],
	beta1: [-1.0, 1.0, \lin, 0, 0.1],
	mu2: [-0.5, 1.0, \lin, 0, 0.1],
	beta2: [-1.0, 1.0, \lin, 0, 0.1],
	kappa: [0.0, 1.0, \lin, 0, 0.1],
	amp: [0.001, 0.5, \exp, 0, 0.2],
	tm: [1,4000, \lin, 0, 1000]
)
)).add;
)


(
~scope = QStethoscope();
~scope.scopeView.style = 2;
SynthDescLib.global[\VDPDC].makeGui;
)