s.options.blockSize = 64;
s.reboot;
////////////////////////////////////////////////////////////////////////
/// COUPLED DUFFING AND VAN DER POL OSCILLATORS

(
Fb1_ODEdef(\Vanderpol, { |t, y, mu = 1.0, tau=1.0|
    [
		{ y[1]*tau },
		{ tau*(mu*y[1]*(1-(y[0]*y[0]))) - (tau*y[0]) }
    ]
}, 0, [0, 1], 1, 1);
)

(
Fb1_ODEdef(\Duff, { |t, y, mu = 0.1, beta= 1.0, input = 0|
    [
        { y[1] },
		{ (y[1] * mu.neg) + (y[0]*(beta-y[0]*y[0])) +  input }
    ]
}, 0, [0, 0], 1, 1);
)


(
Ndef(\Dvdp, {|mu1=0.1, tau=0.1, mu=1, beta=1.0, amp1=0.1, amp2=0.2, tm1=1000, tm2=1000|
	var vdp,duf;
	vdp = Fb1_ODE.ar(\Vanderpol, [mu1, tau],tm1, 0, [0, 1]);
	duf = Fb1_ODE.ar(\Duff, [mu, beta,amp1*vdp.sum],tm2, 0, [0, 1]);
	duf*amp2;
}).play;
)

(
~scope = QStethoscope();
~scope.scopeView.style = 2;
)

FreqScope.new(600, 300, 0);
s.plotTree;
m = ServerMeter(s)
///////////////////////////////////////////////////////////////////////////////

Ndef(\Dvdp).fadeTime = 3

Ndef(\Dvdp).xset(\mu1,0.1,\tau,0.3,\mu,0.06,\beta,0.6,\tm1,500,\tm2,300,\amp1,0.3,\amp2,0.4) //QUIET START

Ndef(\Dvdp).xset(\tau,0.7,\mu,0.12,\beta,0.9,\tm1,400,\tm2,700,\amp1,0.2,\amp2,0.3) // MILD CHAOS

Ndef(\Dvdp).xset(\amp1,0.15) // STABILIZATION

Ndef(\Dvdp).xset(\mu,0.08,\beta,0.9,\tm2,700,\amp2,0.4) // SLIGHTLY UNSTABLE

Ndef(\Dvdp).xset(\tau,0.2,\amp1,0.15,\tm1,1700) // STABILIZATION

Ndef(\Dvdp).xset(\mu,0.02,\beta,0.5,\tm2,800) // STABLE
Ndef(\Dvdp).xset(\mu,0.02,\beta,-0.5) // ROTATION

Ndef(\Dvdp).fadeTime = 10
Ndef(\Dvdp).xset(\mu,0.1,\beta,0.5,\tm2,2500,\amp2,0.3) // CYCLES

Ndef(\Dvdp).xset(\tau,0.1,\amp1,1.2,\tm1,1700) // HARMONICS

Ndef(\Dvdp).xset(\mu,0.1,\beta,0.5,\tm2,1200) // LESS CYCLES

Ndef(\Dvdp).xset(\tau,0.1,\amp1,0.1,\tm1,1200)
Ndef(\Dvdp).xset(\mu,0.1,\beta,0.2,\tm1,600) // INVERSE HARMONICS

/////////////////////////////////////

Ndef(\Dvdp).clear










