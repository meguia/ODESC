
(
Fb1_ODEdef(\Dhopf, { |t, y, p1=1.8, p2=1.5, p3=0.7|
    [
		{ p1*((0.5*y[0])+y[1]-y[3]-(y[0]*y[0]*(0.6+y[0])))},
		{ -1.0*p3*y[0]},
		{ 2.4*y[3]},
		{ 0.6*(y[0]-y[2]-(p2*y[3])) }
    ]
}, 0, [0.1, 0.1, 0.1, 0.1], 1, 1);
)



(
SynthDef(\VDhopf, {
	var sig = Fb1_ODE.ar(\Dhopf, [\p1.kr(1.8), \p2.kr(1.6), \p3.kr(0.7)],\tm.kr(1000), 0, [0.5, 0.5, 0.5, 0.5]);
	Out.ar(0, sig*\amp.kr(0.1))
}, metadata: (specs: (
	p1: [0.1, 3.0, \lin, 0, 1.8],
	p2: [0.1, 3.0, \lin, 0, 1.5],
	p3: [0.3, 0.9, \lin, 0, 0.7],
	amp: [0.001, 0.5, \exp, 0, 0.1],
	tm: [1,1000, \lin, 0, 100]
)
)).add;
)


(
~scope = QStethoscope();
~scope.scopeView.style = 2;
SynthDescLib.global[\VDhopf].makeGui;
)

4.224**2