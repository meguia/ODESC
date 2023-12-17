(
Fb1_ODEdef(\Bautin, { |t, y, mu = -0.3, sigma = 0.3, k = 10.0, a=0.0|
	var r2 = y[0].squared + y[1].squared ;
    [
        { y[1] + a },
		{ (( mu + (sigma * r2) + (0.5 * r2.squared)) * y[1].neg) + (k*y[0].neg)}
    ]
}, 0, [1, 1], 1, 1);
)


// Three oscillators

(
Ndef(\bt1, {|mu = -0.3, sigma = 0.3, k = 10.0, tm=300, k21=0.0, k31=0.0|
	var input = (k21*Ndef.ar(\bt2)[0])+(k31*Ndef.ar(\bt3)[0]);
	Fb1_ODE.ar(\Bautin, [mu, sigma, k, input], tm, 0, [0, 1])
});
Ndef(\bt2, {|mu = -0.3, sigma = 0.3, k = 10.0, tm=300, k12=0.0, k32=0.0|
	var input = (k12*Ndef.ar(\bt1)[0])+(k32*Ndef.ar(\bt3)[0]);
	Fb1_ODE.ar(\Bautin, [mu, sigma, k, input], tm, 0, [0, 1])
});
Ndef(\bt3, {|mu = -0.3, sigma = 0.3, k = 10.0, tm=300, k13=0.0, k23=0.0|
	var input = (k13*Ndef.ar(\bt1)[0])+(k23*Ndef.ar(\bt2)[0]);
	Fb1_ODE.ar(\Bautin, [mu, sigma, k, input], tm, 0, [0, 1])
});
)


(
Ndef(\mix, { |amp = 0.1|
	[Ndef.ar(\bt1)[0], Ndef.ar(\bt2)[0], Ndef.ar(\bt3)[0]] * amp;
}).play;
)

Ndef(\vdp1).gui;
Ndef(\vdp2).gui;
Ndef(\vdp3).gui;