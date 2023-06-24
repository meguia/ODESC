
s.options.blockSize = 64;
s.reboot;

////////////////////////////////////////////////////////////////////////////////
/// IZHIKEVICH NEURON MODEL WITH RESET


(
Fb1_ODEdef(\izhikevich, { |t, y, a=0.02, b=0.2, i=0|
    [
		{ y[0]*(0.04*y[0]+5.0) +140 - y[1] + i },
		{ a*(b*y[0]-y[1]) }
    ]
}, 0, [-50.0, 1.0], 1, 1);
)

(
SynthDef(\IZH, {
	var sig = Fb1_ODE.ar(\izhikevich,
		[\a.kr(0.02), \b.kr(0.2),\i.kr(0.0)],
		\tm.kr(1000), 0, [-50.0, 2.0],
		compose: { |y| Select.kr(y[0] > 30.0, [y, [\c.kr(-50.0), y[1]+\d.kr(2.0)]]);}
	);
	Out.ar(0, sig*\amp.kr(0.2))
}, metadata: (specs: (
	a: [0.0, 0.15, \lin, 0, 0.02],
	b: [0.0, 0.3, \lin, 0, 0.2],
	c: [-70, -40, \lin, 0, -50],
	d: [0.0, 10, \lin, 0, 2],
	i: [0,40, \lin, 0, 4.0],
	amp: [0.001, 0.5, \exp, 0, 0.2],
	tm: [1,4000, \lin, 0, 1000]
)
)).add;
)


SynthDescLib.global[\IZH].makeGui;


/////////////////////////////////////////////////////////////////
// TAKING THE AMPLITUDE OF THE INPUT AS INJECTED CURRENT

(
SynthDef(\IZHINP, {
	var sig, in;
	in = Amplitude.kr(SoundIn.ar(0),0.02,0.05,\i.kr(0),\i0.kr(3.0));
	sig = Fb1_ODE.ar(\izhikevich,
		[\a.kr(0.02), \b.kr(0.2),in],
		\tm.kr(1000), 0, [-50.0, 2.0],
		compose: { |y| Select.kr(y[0] > 30.0, [y, [\c.kr(-50.0), y[1]+\d.kr(2.0)]]);}
	);
	Out.ar(0, sig*\amp.kr(0.2))
}, metadata: (specs: (
	a: [0.0, 0.15, \lin, 0, 0.02],
	b: [0.0, 0.3, \lin, 0, 0.2],
	c: [-70, -40, \lin, 0, -50],
	d: [0.0, 10, \lin, 0, 2],
	i: [-20,20, \lin, 0, 0.0],
	i0: [0,40, \lin, 0, 3.0],
	amp: [0.001, 0.5, \exp, 0, 0.2],
	tm: [100,8000, \lin, 0, 1000]
)
)).add;
)

SynthDescLib.global[\IZHINP].makeGui;

//////////////////////////////////////////////////////////////////////
/// Connectinv two neurons via a Bus

(
SynthDef(\IZHINP, {
	var sig, in;
	in = Amplitude.kr(SoundIn.ar(0),0.02,0.05,\i.kr(0),\i0.kr(3.0));
	sig = Fb1_ODE.ar(\izhikevich,
		[\a.kr(0.02), \b.kr(0.2),in],
		\tm.kr(1000), 0, [-50.0, 2.0],
		compose: { |y| Select.kr(y[0] > 30.0, [y, [\c.kr(-50.0), y[1]+\d.kr(2.0)]]);}
	);
	Out.ar(0, sig*\amp.kr(0.2))
}, metadata: (specs: (
	a: [0.0, 0.15, \lin, 0, 0.02],
	b: [0.0, 0.3, \lin, 0, 0.2],
	c: [-70, -40, \lin, 0, -50],
	d: [0.0, 10, \lin, 0, 2],
	i: [-20,20, \lin, 0, 0.0],
	i0: [0,40, \lin, 0, 3.0],
	amp: [0.001, 0.5, \exp, 0, 0.2],
	tm: [100,8000, \lin, 0, 1000]
)
)).add;
)


~cBus = Bus.control(s,1);

~cBus.index;

~cBus.scope();

~osc  = {Out.ar(0,Saw.ar(\freq.kr(100)))}.play;

~osc.map(\freq,~cBus.index);

~cBus.set(20);