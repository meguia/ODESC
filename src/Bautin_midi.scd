///////////////////////////////////////////////////
/// BAUTIn (Generalized Hopf) with noise


n = NanoKontrol2();

(
Fb1_ODEdef(\Bautin, { |t, y, mu = 0.1, sigma = 0, k = 10.0, a=0.01|
	var r2 = y[0].squared + y[1].squared ;
    [
        { y[1] + a },
		{ (( mu + (sigma * r2) + (0.5 * r2.squared)) * y[1].neg) + (k*y[0].neg) }
    ]
}, 0, [1, 1], 1, 1);
)


(
SynthDef(\SBautin, { |mu = -0.3, sigma = 0.3, k = 10.0, a=0.001, rev=0.5, amp = 0.2, tm = 1000|
	var pert = WhiteNoise.kr(a);
	var sig = Fb1_ODE.ar(\Bautin, [mu, sigma, k, pert],tm, 0, [1, 1]);
	Out.ar(0,FreeVerb.ar(HPF.ar(sig,30.0)*amp,room:rev))
}, metadata: (specs: (
	mu: [-1.0, 1.0, \lin, 0, -0.3],
	sigma: [-1.0, 1.0, \lin, 0, 0.3],
	k: [0.1, 20.0, \exp, 0, 1.0],
	a: [0.0001, 0.1, \exp, 0, 0.001],
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

x = Synth.new(\SBautin);

(
n.knob1.onChange = {|val| x.set(\mu,val.linlin(0,127,-1.0,1.0));};
n.knob2.onChange = {|val| x.set(\sigma,val.linlin(0,127,-1.0,1.0));};
n.knob3.onChange = {|val| x.set(\k,val.linexp(0,127,0.1,20.0));};
n.knob4.onChange = {|val| x.set(\a,val.linexp(0,127,0.0001,0.1));};
n.knob5.onChange = {|val| x.set(\rev,val.linlin(0,127,0.0,1.0));};
n.fader1.onChange = {|val| x.set(\amp,val.linexp(0,127,0.001,1.0));};
n.fader2.onChange = {|val| x.set(\tm,val.linlin(0,127,1,2000));};
)
