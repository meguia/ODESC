
///////////////////////////////////////////////////
/// FORCED DUFFING

(
Fb1_ODEdef(\FDuffing, { |t, y, mu = 0.1, beta= 1.0, omega = 0, a = 1|
    [
        { y[1] },
		{ y[1] * mu.neg + (y[0] * (beta - y[0].squared)) + (a * cos(omega * t)) }
    ]
}, 0, [0, 0], 1, 1);
)


(
Ndef(\FD, {|mu = 1, beta = 1.0, omega = 0.1, a = 0.1,amp = 0.2, tm = 1000|
	var sig = Fb1_ODE.ar(\FDuffing, [mu, beta, omega, a], tm, 0, [0, 1]);
	sig * amp
}).play;
)



(
~scope = Stethoscope();
~scope.style = 2;
)

Ndef(\FD).fadeTime = 10

Ndef(\FD).xset(\mu, 0.03, \beta, 0.7, \a, 1.4,\omega,1.1, \tm,104, \amp, 0.2)

Ndef(\FD).gui