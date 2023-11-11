// Two Coupled Van der Pol Oscillators (Unidirectionally) a -> b

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
	vdp2*amp;
}).play;
)

Ndef(\vdp).fadeTime = 5

Ndef(\vdp).xset(\tm1,766)
Ndef(\vdp).xset(\tm2,600)

Ndef(\vdp).xset(\mu2,1.1)
Ndef(\vdp).xset(\mu1,1.0)


Ndef(\vdp).xset(\k12,0.15)


// Bidirectional coupling

(
Ndef(\vdp1, {|mu=1.0, tm=300, k12=0.0|
	var other = Ndef.ar(\vdp2);
	Fb1_ODE.ar(\Vanderpol2, [mu, k12 * other.sum], tm, 0, [0, 1])
});
Ndef(\vdp2, {|mu=1.0, tm=300, k12=0.0|
	var other = Ndef.ar(\vdp1);
	Fb1_ODE.ar(\Vanderpol2, [mu, k12 * other.sum], tm, 0, [0, 1])
});
Ndef(\mix, { |amp = 0.1|
	[Ndef.ar(\vdp1), Ndef.ar(\vdp2)].sum * amp
}).play;
)

//


(
~scope = Stethoscope();
~scope.style = 2;
)


//
Ndef(\vdp1).set(\k12, 0.0)
Ndef(\vdp2).set(\k12, 0.0)
Ndef(\vdp1).set(\tm, 400)
Ndef(\vdp2).set(\tm, 400)



Ndef(\vdp1).gui;
Ndef(\vdp2).gui;

// Three oscillators

(
Ndef(\vdp1, {|mu=1.0, tm=300, k12=0.0, k13=0.0|
	var input = (k12*Ndef.ar(\vdp2).sum)+(k13*Ndef.ar(\vdp3).sum);
	Fb1_ODE.ar(\Vanderpol2, [mu, input], tm, 0, [0, 1])
});
Ndef(\vdp2, {|mu=1.0, tm=300, k12=0.0, k23=0.0|
	var input = (k12*Ndef.ar(\vdp1).sum)+(k23*Ndef.ar(\vdp3).sum);
	Fb1_ODE.ar(\Vanderpol2, [mu, input], tm, 0, [0, 1])
});
Ndef(\vdp3, {|mu=1.0, tm=300, k13=0.0, k23=0.0|
	var input = (k13*Ndef.ar(\vdp1).sum)+(k23*Ndef.ar(\vdp2).sum);
	Fb1_ODE.ar(\Vanderpol2, [mu, input], tm, 0, [0, 1])
});
)

Ndef(\vdp1).gui;
Ndef(\vdp2).gui;
Ndef(\vdp3).gui;



// 8 coupled vanderpols

~all = { NodeProxy.audio(s, 2) } ! 8;
(
~all.do { |x, i|
	x.source = {|mu=1, tm=300, k12=0.0|
		var other = ~all.wrapAt(i - 1).ar;
		i.postln;
		Fb1_ODE.ar(\Vanderpol2, [mu, k12 * other.sum], tm, 0, [0, 1])
	}
};

Ndef(\mix, { |amp = 0.1|
	Splay.ar(~all.collect { |x| x.ar }).flat * amp
}).play
)

~all.do { |x| x.xset(\tm, exprand(600.0, 900.0)) };


Ndef(\modx, { MouseX.kr(0, 1000) });
~all.do { |x| x.xset(\tm, Ndef(\modx)) };



