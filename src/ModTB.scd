
/////////////////////////////////////////////////////////
/// MODULATED BOGDANOV TAKENS WITH CUBIC UNFOLDING

(
Fb1_ODEdef(\Bogdanov, { |t, y, mu1 = 0.1, mu2 = 0.0|
    [
        { y[1] },
		{ y[0] * (mu2 - y[1] + (y[0] * (1 - y[0] - y[1]))) + mu1}
    ]
}, 0, [0, 0], 1, 1);
)

(
SynthDef(\FBT, { |m1 = -0.02, m2 = -0.2, f1 = 0.1, f2 = 0.1, a1 = 0.01, a2 = 0.03, amp = 0.2,tm = 1000|
	var sig, mu1, mu2,fc,fa,fb;
	fc= [800,1150,2900,3900,4950]; //centre frequencies of formants
	fa= ([0 ,-6,-32,-20,-50]-6).dbamp; //peaks of formants
	fb=[80,90,120,130,140];  //bandwidths
	mu1 = SinOsc.ar(f1).range(m1-a1,m1+a1);
	mu2 = SinOsc.ar(f2).range(m2-a2,m2+a2);
	sig = Fb1_ODE.ar(\Bogdanov, [mu1, mu2],tm, 0, [1, 1]);
	sig = [Mix(BPF.ar(sig[0],fc,fb/fc,fa)),Mix(BPF.ar(sig[1],fc,fb/fc,fa))];
	Out.ar(0, sig*amp*10)
}, metadata: (specs: (
	m1: [-0.1, 0.1, \lin, 0, -0.02],
	m2: [-0.4, 0.3, \lin, 0, -0.2],
	f1: [0.01,10.0, \exp, 0, 0.1],
	f2: [0.01,10.0, \exp, 0, 0.1],
	a1: [0,0.3,\lin, 0, 0.0],
	a2: [0,0.3,\lin, 0, 0.0],
	amp: [0.001, 1.0, \exp, 0, 0.2],
	tm: [1000,8000, \lin, 0, 2000]
)
)).add;
)

(
~scope = Stethoscope();
~scope.style = 2;
SynthDescLib.global[\FBT].makeGui;
)

