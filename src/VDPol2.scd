// Two Coupled Van der Pol Oscillators

(
Fb1_ODEdef(\Vanderpol2, { |t, y, mu = 1.0, input=0.0|
    [
		{ y[1] },
		{ mu * y[1] * (1 - y[0].squared) - y[0] + input}
    ]
}, 0, [0, 1], 1, 1);
)

// Synth

(
Ndef(\vdp, {|mu1=1, mu2=1, tm1=300, tm2=300, k12=0.0, amp=0.1|
	var vdp1, vdp2;
	vdp1 = Fb1_ODE.ar(\Vanderpol2, [mu1, 0],tm1, 0, [0, 1]);
	vdp2 = Fb1_ODE.ar(\Vanderpol2, [mu2, k12*vdp1.sum],tm2, 0, [0, 1]);
	(vdp1+vdp2)*amp;
}).play;
)

Ndef(\vdp).fadeTime = 5

Ndef(\vdp).xset(\tm1,400)

Ndef(\vdp).xset(\tm2,500)

Ndef(\vdp).xset(\k12,0.1)

