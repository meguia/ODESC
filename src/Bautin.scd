(
Fb1_ODEdef(\Bautin, { |t, y, mu = -0.3, sigma = 0.3, k = 10.0|
	var r2 = y[0].squared + y[1].squared ;
    [
        { y[1] },
		{ (k*y[0].neg) + (mu*y[1]) + (sigma*y[1]*y[0].squared) + (0.1*r2.squared*y[1].neg)}
    ]
}, 0, [1, 1], 1, 1);
)


(
Ndef(\bt, {|mu = -0.03, sigma = -0.3, k = 10.0, amp=0.1, tm=300|
	Fb1_ODE.ar(\Bautin, [mu, sigma, k], tm, 0, [0, 1])*amp
}).play;
)


(
Spec.add(\mu,[-1.0,2.0,\lin, 0.0, -0.05]);
Spec.add(\sigma,[-0.4,1.0,\lin, 0.0, -0.1]);
Ndef(\bt).play.gui;
)
