
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
SynthDef(\BT2T, { |nu1 = -0.1, nu2 = -0.14, a1 = 0.001, a2 = 10.0, mu1 = -0.1, mu2 = -0.07, amp = 0.8,tm1=3, tm2 = 6000|
	var sig, mu,fc,fa,fb;
	fc= [800,1150,2900,3900,4950]; //centre frequencies of formants
	fa= ([0 ,-6,-32,-20,-50]-6).dbamp; //peaks of formants
	fb=[80,90,120,130,140];  //bandwidths
	mu = Fb1_ODE.ar(\Bogdanov, [nu1, nu2],tm1, 0, [1, 1]);
	sig = Fb1_ODE.ar(\Bogdanov, [mu1+ (a1* mu[0]), mu2 + (a2*mu[1])],tm2, 0, [1, 1]);
	sig = [Mix(BPF.ar(sig[0],fc,fb/fc,fa)),Mix(BPF.ar(sig[1],fc,fb/fc,fa))];
	Out.ar(0, sig*amp*10)
}, metadata: (specs: (
	nu1: [-0.1, 0.1, \lin, 0, -0.02],
	nu2: [-0.4, 0.3, \lin, 0, -0.2],
	a1: [0.001, 10.0, \exp, 0, 0.2],
	a2: [0.001, 10.0, \exp, 0, 0.2],
	mu1: [-0.1, 0.1, \lin, 0, -0.02],
	mu2: [-0.4, 0.3, \lin, 0, -0.2],
	amp: [0.001, 1.0, \exp, 0, 0.2],
	tm1: [1,80, \lin, 0, 20],
	tm2: [1000,9000, \lin, 0, 2000]
)
)).add;
)

(
~scope = Stethoscope();
~scope.style = 2;
SynthDescLib.global[\BT2T].makeGui;
)




