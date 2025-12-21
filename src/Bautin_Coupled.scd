(
Fb1_ODEdef(\Bautin, { |t, y, mu = -0.3, sigma = 0.3, k = 10.0, a=0.0, s=0.0|
	var r2 = y[0].squared + y[1].squared ;
    [
        { y[1] },
		{(k*y[0].neg) + (mu*y[1])  +(sigma*y[1]*y[0].squared) + (a*y[1]) + (0.1*r2.squared*y[1].neg) + s}
    ]
}, 0, [1, 1], 1, 1);
)


// Two oscillators

(
Ndef(\bt1, {|mu = -0.3, sigma = 0.3, k = 10.0, tm=300, k21=0.0, s1=0.0|
	var input = (k21*Ndef.ar(\r2));
	var noise =  BrownNoise.ar(s1);
	Fb1_ODE.ar(\Bautin, [mu, sigma, k, input, noise], tm, 0, [0, 1])
});
)

(
Ndef(\bt2, {|mu = -0.3, sigma = 0.3, k = 10.0, tm=300, k12=0.0, s1=0.0|
	var input = (k12*Ndef.ar(\r1));
	var noise =  BrownNoise.ar(s1);
	Fb1_ODE.ar(\Bautin, [mu, sigma, k, input, noise], tm, 0, [0, 1])
});
)

(
Ndef(\r1).mold(1);
Ndef(\r2).mold(1);
Ndef(\r1, {Ndef.ar(\bt1)[0].squared+Ndef.ar(\bt1)[1].squared});
Ndef(\r2, {Ndef.ar(\bt2)[0].squared+Ndef.ar(\bt2)[1].squared});
)

(
Ndef(\mix, { |amp = 0.1|
	[2*Ndef.ar(\bt1)[0] , 2*Ndef.ar(\bt2)[0]] * amp;
}).play;
)

(
Spec.add(\mu,[-1.0,2.0,\lin, 0.0, -0.05]);
Spec.add(\sigma,[-0.4,1.0,\lin, 0.0, -0.1]);
)

Ndef(\bt1).gui;
Ndef(\bt2).gui;

