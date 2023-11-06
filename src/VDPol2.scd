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


// couple both ways

(
Ndef(\vdp1, {|mu1=1, mu2=1, tm=300, k12=0.0|
	var other = Ndef.ar(\vdp2);
	Fb1_ODE.ar(\Vanderpol2, [mu2, k12 * other.sum], tm, 0, [0, 1])
});
Ndef(\vdp2, {|mu1=1, mu2=1, tm=300, k12=0.0|
	var other = Ndef.ar(\vdp1);
	Fb1_ODE.ar(\Vanderpol2, [mu2, k12 * other.sum], tm, 0, [0, 1])
});
Ndef(\mix, { |amp = 0.1|
	[Ndef.ar(\vdp1), Ndef.ar(\vdp2)].sum * amp
}).play
)

Ndef(\vdp1).xset(\k12, 0.3)
Ndef(\vdp2).xset(\k12, 0.3)
Ndef(\vdp1).xset(\tm, 130)
Ndef(\vdp1).xset(\tm, 350)
Ndef(\vdp1).xset(\tm, rrand(300.0, 500))
Ndef(\vdp2).xset(\tm, rrand(300.0, 500))

Ndef(\modx, { MouseX.kr(0, 1000) });
Ndef(\vdp1).xset(\tm, Ndef(\modx));



// 8 coupled vanderpols

~all = { NodeProxy.audio(s, 2) } ! 8;
(
~all.do { |x, i|
	x.source = {|mu1=1, mu2=1, tm=300, k12=0.0|
		var other = ~all.wrapAt(i - 1).ar;
		i.postln;
		Fb1_ODE.ar(\Vanderpol2, [mu2, k12 * other.sum], tm, 0, [0, 1])
	}
};

Ndef(\mix, { |amp = 0.1|
	Splay.ar(~all.collect { |x| x.ar }).flat * amp
}).play
)

~all.do { |x| x.xset(\tm, exprand(10.0, 1500)) };


Ndef(\modx, { MouseX.kr(0, 1000) });
~all.do { |x| x.xset(\tm, Ndef(\modx)) };



