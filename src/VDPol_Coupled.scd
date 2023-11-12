(
Fb1_ODEdef(\Vanderpol2, { |t, y, mu = 1.0, input=0.0|
    [
		{ y[1] },
		{ mu * y[1] * (1 - y[0].squared) - y[0] + input}
    ]
}, 0, [0, 1], 1, 1);
)


// Three oscillators

(
Ndef(\vdp1, {|mu=1.0, tm=300, k21=0.0, k31=0.0|
	var input = (k21*Ndef.ar(\vdp2)[0])+(k31*Ndef.ar(\vdp3)[0]);
	Fb1_ODE.ar(\Vanderpol2, [mu, input], tm, 0, [0, 1])
});
Ndef(\vdp2, {|mu=1.0, tm=300, k12=0.0, k32=0.0|
	var input = (k12*Ndef.ar(\vdp1)[0])+(k32*Ndef.ar(\vdp3)[0]);
	Fb1_ODE.ar(\Vanderpol2, [mu, input], tm, 0, [0, 1])
});
Ndef(\vdp3, {|mu=1.0, tm=300, k13=0.0, k23=0.0|
	var input = (k13*Ndef.ar(\vdp1)[0])+(k23*Ndef.ar(\vdp2)[0]);
	Fb1_ODE.ar(\Vanderpol2, [mu, input], tm, 0, [0, 1])
});
)


(
Ndef(\mix, { |amp = 0.1|
	[Ndef.ar(\vdp1)[0], Ndef.ar(\vdp2)[0], Ndef.ar(\vdp3)[0]] * amp;
}).play;
)

Ndef(\vdp1).gui;
Ndef(\vdp2).gui;
Ndef(\vdp3).gui;