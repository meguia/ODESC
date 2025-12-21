s.reboot;
/////////////////////////////////////////////////////////

(
Fb1_ODEdef(\sdelay, { |t, y, mu = 0.0, h=0.0|
	h + h.squared.neg - (mu*y)
}, 0, 0.1, 1, 1);
)

(
Ndef(\Sdelay, {|tau=0.1, mu=0.0, amp=0.2, tm=1000, pan=0.0|
	var input;
	//input = DelayN.ar(Ndef.ar(\self),tau,tau);
	input = BrownNoise(0.3);
	//sig = Fb1_ODE.ar(\sdelay, [mu, input],tm, 0, 0.1);
	input*amp;
});
)

Ndef(\self, {Ndef.ar(\Sdelay)}).play;


(
Spec.add(\mu,[0.0,1.0,\lin, 0.0, 0.0]);
Spec.add(\tau,[0.0,1.7,\lin, 0.0, 0.1]);
)

Ndef(\Sdelay).gui;

