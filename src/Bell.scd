
//////////////////////////////////////////////////
/// Bouncing Ball (elastic surface)
(
Fb1_ODEdef(\Ball, { |t, y, g = -9.8, k = 1000, mu = 1.0|
    [
        { y[1] },
		{ (y[0]<0)*((k.neg*y[0])+(mu.neg*y[1]))  + g }
    ]
}, 0, [0, 0], 1, 1);
)


(
Ndef(\BALL, {
	var sig = Fb1_ODE.ar(\Ball, [\g.kr(-9.8), \k.kr(100),\mu.kr(0.0)],\tm.kr(1000), 0, [1, 0],'sym12');
	sig *\amp.kr(1);
});
)


~scope = Stethoscope();
~scope.style = 2;


Ndef(\BALL).clear;
Ndef(\BALL).play;
Ndef(\BALL).stop;


Ndef(\BALL).set(\mu,0.01)

Ndef(\BALL).set(\amp,1.0)

Ndef(\BALL).set(\tm,1000)


Ndef(\BALL).scope


///////////////////////////////////////////////////
/// Bell and Clapper

(
Fb1_ODEdef(\Bell, { |t, y, r = 0.4, lb= 1.6, k = 1000, mu=1.0, ymax = 0.45|
    [
        { y[1] },
		{ (-1)*sin(y[0])  },
		{ y[3] },
		{ (sin(y[0])*(1.0 + (r*cos(y[2])))) - (r*sin(y[2])*y[1].squared) - (lb*sin(y[0]+y[2])) - ((y[2]>ymax)*k*((y[2]-ymax).squared + (mu*y[3])))   + ((y[2]<ymax.neg)*k*((y[2]+ymax).squared - (mu*y[3])))}
    ]
}, 0, [0, 0, 0, 0], 1, 1);
)





(
Fb1_ODEdef(\Bell, { |t, y, r = 0.4, lb= 1.6, k = 1000, mu=1.0, ymax = 0.45|
	var bellAngle = y[0];
	var bellVelocity = y[1];
	var clapperAngle = y[2];
	var clapperVelocity = y[3];

	[
        { bellVelocity },
		{ bellAngle.sin.neg  },
		{ clapperVelocity },
		{
			var contactTerm =
			((clapperAngle < ymax.neg)*((clapperAngle+ymax).squared * k - (mu*clapperVelocity)))
			- ((clapperAngle > ymax) * ((clapperAngle-ymax).squared * k + (mu*clapperVelocity)));

			(sin(bellAngle) * (1.0 + (r * cos(clapperAngle))))
			- (r * sin(clapperAngle) * bellVelocity.squared)
			- (lb * sin(bellAngle + clapperAngle))
			+ contactTerm
		}
    ]
}, 0, [0, 0, 0, 0], 1, 1);
)





(
Fb1_ODEdef(\Bell, { |t, y, r = 0.4, lb= 1.6, k = 1000, mu=1.0, ymax = 0.45|
	var bellAngle = y[0];
	var bellVelocity = y[1];
	var clapperAngle = y[2];
	var clapperVelocity = y[3];

	[
        { bellVelocity },
		{ bellAngle.sin.neg  },
		{ clapperVelocity },
		{
			var contactTerm =
			((clapperAngle < ymax.neg)*((clapperAngle+ymax).squared * k - (mu*clapperVelocity)))
			- ((clapperAngle > ymax) * ((clapperAngle-ymax).squared * k + (mu*clapperVelocity)));

			(sin(bellAngle) * (1.0 + (r * cos(clapperAngle))))
			- (r * sin(clapperAngle) * bellVelocity.squared)
			- (lb * sin(bellAngle + clapperAngle))
			+ contactTerm
		}
    ]
}, 0, [0, 0, 0, 0], 1, 1);
)


(
Ndef(\BELL, {
	Fb1_ODE.kr(\Bell,
		[
			\r.kr(0.4),
			\lb.kr(1.6),
			\k.kr(100),
			\mu.kr(0.0)
		],
		tMul: \tm.kr(30), t0: 0, y0: [3.1, 0, 0, 0], intType: 'sym12', leakDC: false
	)
});

Ndef(\BELL_clapper, {

	var y = Ndef.kr(\BELL, 4);
	var bellAngle = y[0];
	var bellVelocity = y[1];
	var clapperAngle = y[2];
	var clapperVelocity = y[3];
	var touching;

	touching = (clapperAngle.abs - bellAngle.abs).max(0);
	[touching, clapperVelocity, clapperAngle]

})
)



Ndef(\BELL).set(\tm, 4.3);
Ndef(\BELL).set(\tm, 140.3);
Ndef(\BELL).set(\k, 300);
Ndef(\BELL).set(\k, 1000);
Ndef(\BELL).set(\mu, 0.15);
Ndef(\BELL).set(\lb, 0.4);
Ndef(\BELL).set(\r, 1.8);
Ndef(\BELL).set(\r, 0.08);

Ndef(\BELL).set(\tm, 6);

Ndef(\BELL_clapper).scope
Ndef(\BELL).scope

// listen to clapper
(
Ndef(\clapper, {
	var trig = Ndef.kr(\BELL_clapper, 1, 0);
	var vel = Ndef.kr(\BELL_clapper, 1, 1);
	var exc = K2A.ar(trig);
	var freqs = { exprand(100, 12000) } ! 47;
	exc = exc + Decay.ar(exc > 0, 0.01, RLPF.ar(WhiteNoise.ar(0.002), 400, 0.2));
	Klank.ar(`[freqs, 1/freqs, 300/freqs], exc)
}).play
)

Ndef(\BELL).set(\tm, 4.3);

Ndef(\BELL).clear;
