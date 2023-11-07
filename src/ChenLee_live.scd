

//////////////////////////////////////////////////////////////////////
/// Chen Lee ATTRACTOR


(
Fb1_ODEdef(\Chenlee, { |t, y, a = 5.0, b = -10.0, d = -0.38|
    [
		{ (a*y[0]) - (y[1]*y[2]) },
		{ (b*y[1]) + (y[0]*y[2]) },
		{ (d*y[2]) + (y[0]*y[1])/3 }
    ]
}, 0, [0, 0, 0], 1, 1);
)

(
Fb1_ODEdef(\Vanderpol, { |t, y, mu = 1.0, tau=1.0|
    [
		{ y[1]*tau },
		{ tau*(mu*y[1]*(1-(y[0]*y[0]))) - (tau*y[0]) }
    ]
}, 0, [0, 1], 1, 1);
)


(
Ndef(\CHEN, {
	var env, sig;
	env = Fb1_ODE.ar(\Chenlee, [\a.kr(5.0), \b.kr(-6.24),\d.kr(-0.76)],\tm.kr(85), 0, [0, 1, 1]);
	sig = \input.ar(0);
	LPF.ar(sig*env,2500.0)*\amp.kr(0.1);
});
)

(
Ndef(\VDP, {
	var sig = Fb1_ODE.ar(\Vanderpol, [\mu.kr(0.1), \tau.kr(0.2)],\tm.kr(1000), 0, [0, 1]);
	sig *\amp.kr(0.02);
});
)

s.plotTree;
(
~scope = Stethoscope();
~scope.style = 2;
)

///////////////////////////////////////////////
Ndef(\CHEN) <<>.input Ndef(\VDP);
///////////////////////////////////////////////


Ndef(\CHEN).xset(\a,6.0,\b,-10.0,\d,-0.11,\tm,40,\amp,0.1)
Ndef(\VDP).xset(\tau,1.3,\amp,1.5,\tm,300)
Ndef(\CHEN).play;
Ndef(\CHEN).fadeTime = 10
Ndef(\VDP).fadeTime = 5


Ndef(\CHEN).xset(\a,6.0,\b,-10.0,\d,-0.16,\tm,700,\amp,0.1)
Ndef(\VDP).xset(\tau,1.3,\amp,0.1,\tm,310)


Ndef(\VDP).xset(\tau,1.1,\amp,0.2,\tm,810)
Ndef(\CHEN).xset(\a,1.0,\b,-12.0,\d,-0.11,\tm,53,\amp,0.4)

Ndef(\CHEN).clear
Ndef(\VDP).clear