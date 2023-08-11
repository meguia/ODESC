
///////////////////////////////////////////////////
/// FORCED DUFFING


n = NanoKontrol2();

(
Fb1_ODEdef(\FDuffing, { |t, y, mu = 0.1, beta= 1.0, omega = 0, a = 1|
    [
        { y[1] },
		{ y[1] * mu.neg + (y[0].squared * (beta - y[0])) + (a * cos(omega * t)) }
    ]
}, 0, [0, 0], 1, 1);
)


Fb1_ODEdef.keys;

Fb1_ODEdef.postAll;

(
SynthDef(\FD, { |mu = 1, beta = 1.0, omega = 0.1, a = 0.1,rev=0.5, amp = 0.2,tm = 1000|
	var sig = Fb1_ODE.ar(\FDuffing, [mu, beta, omega, a],tm, 0, [0, 1]);
	Out.ar(0,FreeVerb.ar(HPF.ar(sig,30.0)*amp,room:rev))
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
~scope = Stethoscope();
~scope.style = 2;
//SynthDescLib.global[\FD].makeGui;
)

x = Synth.new(\FD);

(
n.knob1.onChange = {|val| x.set(\mu,val.linlin(0,127,0.01,1.0));};
n.knob2.onChange = {|val| x.set(\beta,val.linlin(0,127,0.0,2.0));};
n.knob3.onChange = {|val| x.set(\omega,val.linexp(0,127,0.1,1.0));};
n.knob4.onChange = {|val| x.set(\a,val.linlin(0,127,0.0,2.0));};
n.knob5.onChange = {|val| x.set(\rev,val.linlin(0,127,0.0,1.0));};
n.fader1.onChange = {|val| x.set(\amp,val.linexp(0,127,0.001,1.0));};
n.fader2.onChange = {|val| x.set(\tm,val.linlin(0,127,1,2000));};
)
