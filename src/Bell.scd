
//////////////////////////////////////////////////
/// Bouncing Ball (elastic surface)
(
Fb1_ODEdef(\Ball, { |t, y, g = -9.8, k = 1000, mu = 1.0, surfacePosition = 0|
	var position = y[0];
	var velocity = y[1];
	[
		{ velocity },
		{
			var touching = position < surfacePosition;
			var elasticForce = (k.neg * position) + (mu.neg * velocity);
			touching * elasticForce + g
		}
	]
}, 0, [0, 0], 1, 1);
)


(
Ndef(\BALL, {
	Fb1_ODE.ar(\Ball,
		[\g.kr(-9.8), \k.kr(100), \mu.kr(0.0)],
		\tm.kr(1000), 0, [1, 0], 'sym12'
	);
});
)


Ndef(\BALL).scope.style_(2);
Ndef(\BALL).clear;


(
{
	Fb1_ODE.ar(\Ball,
		[-9.8, 100, 0],
		1000, 0, [1, 0], 'sym12'
	)
}.plot
)



// bouncing ball on a surface
// cursor position controls surface frequency and gravity
(
Ndef(\BALL, {
	var surfacePosition = SinOsc.ar(MouseX.kr(0.2, 150, 1), 0, 0.4);
	var gravity = MouseY.kr(-1, -200, 1);
	var eq = Fb1_ODE.ar(\Ball,
		[gravity, \k.kr(100), \mu.kr(0.0), surfacePosition],
		\tm.kr(40), 0, [1, 0], 'sym12'
	);
	var pos = eq[0];
	var trig = HPZ1.ar(pos < 0);
	SinOsc.ar(pos * 600 + 1000) * Decay2.ar(trig, 0.003, 0.4)
}).play;
)




///////////////////////////////////////////////////
/// Bell and Clapper


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
			((clapperAngle < ymax.neg) * ((clapperAngle+ymax).squared * k - (mu*clapperVelocity)))
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
{
	Fb1_ODE.ar(\Bell,
		[0.4, 1.6, 100, 0],
		10000, 0, [3.1, 0, 0, 0], 'sym12'
	)
}.plot
)


(
Ndef(\BELL, {
	Fb1_ODE.kr(\Bell,
		[
			\r.kr(0.4),  // distance of clapper fixing from bell fixing (https://www.hindawi.com/journals/aav/2012/681787/fig6/)
			\lb.kr(1.6), // relation clapper length factor to bell length factor
			\k.kr(100),  // elasticity constant
			\mu.kr(0.0)  // dissipation
		],
		tMul: \tm.kr(30), // time scaling
		t0: 0,
		y0: [3.1, 0, 0, 0], // initial bell velocity, the rest is zero in the beginning
		intType: 'sym12',
		leakDC: false
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

Ndef(\BELL).scope;

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




