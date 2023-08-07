
s.options.blockSize = 64;
s.reboot;

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


~scope = QStethoscope();
~scope.scopeView.style = 2;


Ndef(\BALL).clear;
Ndef(\BALL).play;
Ndef(\BALL).stop;


Ndef(\BALL).set(\mu,0.01)

Ndef(\BALL).set(\amp,1.0)

Ndef(\BALL).set(\tm,1000)


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
Ndef(\BELL, {
	var sig = Fb1_ODE.kr(\Bell, [\r.kr(0.4), \lb.kr(1.6),\k.kr(100),\mu.kr(0.0)],\tm.kr(30), 0, [3.1, 0, 0, 0],intType: 'sym12',leakDC: false);
	sig *\amp.kr(1);
});
)

Ndef(\BELL).clear;

Stethoscope.new(s, 4, rate: 'control')

Ndef(\BELL).set(\tm,100)
