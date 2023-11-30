s.options.blockSize = 16;
s.reboot;
// Izhikevich Model of Neurons
(
Fb1_ODEdef(\izhikevich, { |t, y, a=0.02, b=0.2, i=0|
    [
		{ y[0] * (0.04 * y[0] + 5.0) + 140 - y[1] + i },
		{ a * (b * y[0] - y[1]) }
    ]
}, 0, [-50.0, 1.0], 1, 1);
)

// Single IZ unit
(
SynthDef(\izunit, {
	var env = EnvGate.new;
	var inleft = \inleft.ar(0.0, 0.0);
	var inright = \inright.ar(0.0, 0.0);
	var a = \a.kr(0.02, 0.05, spec: [0.0, 1.0, \lin, 0, 0.02]);
	var b = \b.kr(0.2, 0.05, spec: [0.0, 1.0, \lin, 0, 0.2]);
	var c = \c.kr(-65.0, 0.05, spec: [-70, -30.0, \lin, 0, -65]);
	var d = \d.kr(8.0, 0.05, spec: [0.0, 10.0, \lin, 0, 8.0]);
	var alpha = \alpha.kr(0.0, 0.05, spec: [-1.0, 1.0, \lin, 0, 0.0]);
	var beta = \beta.kr(0.0, 0.05, spec: [-1.0, 1.0, \lin, 0, 0.0]);
	var i0 = \i0.kr(3.0, 0.05, spec: [0.0, 10.0, \lin, 0, 3.0]);
	var tm = \tm.kr(1000, 0.1, spec: [1, 4000, \lin, 0, 1000]);
	var eq = Fb1_ODE.ar(\izhikevich,
		[a, b,(inleft*alpha)+(inright*beta)+i0],tm, 0, [-50.0, 2.0],
			compose: { |y| Select.kr(y[0] > 30.0, [y, [c, y[1]+d]]);}
		);
	Out.ar(\out.kr, eq[0]*0.01)
}).add;
)

// Array of N units

~units = { NodeProxy.audio(s, 1) } ! 16;

~units.do {|x| x.source = \izunit};

~units.do {|x, i| x.set(\inleft,~units.wrapAt(i-1),\inright,~units.wrapAt(i+1))};

(
Ndef(\mix, {
	var neurons = ~units.collect{|x| x.ar(1)};
	var allunits = neurons.collect {|x, i|
		//var freq = i.linexp(0,8,300,3000);
		var freq = (i + 1) * 200;
		var decay = 30.0/freq;
		x = x.clip2 * 0.1;
		Ringz.ar(x,freq,decay);
	};
	//Splay.ar(allunits)*0.03
	allunits * 0.1;
}).play;
)


~units.do {|x| x.set(\tm,150)};

// Parameter values for the different regimes

// Regular spiking with spread in current (supra threshold)
~units.do {|x, i| x.set(\a,0.02,\b,0.2,\c,-65,\d,8.0,\i0,i.linlin(0,8,3.8,4.0))};
~units.do {|x, i| x.set(\a,0.02,\b,0.2,\c,-65,\d,8.0,\i0,i.linlin(0,8,3.8,4.0))};

~units.do {|x| x.set(\alpha, 0.0)};
~units.do {|x| x.set(\beta, 0.0)};

~units.do {|x| x.set(\beta, 30.0) };
~units.do {|x| x.set(\alpha, 30.0) };

~units.do {|x| x.set(\beta, 50.0) };
~units.do {|x| x.set(\alpha, 50.0) };

~units.do {|x| x.set(\beta, 60.0) };
~units.do {|x| x.set(\alpha, 60.0) };


~units.do {|x| x.set(\beta,10.0)};
~units.do {|x| x.set(\alpha,10.0)};

~scope = Ndef(\mix).scope
