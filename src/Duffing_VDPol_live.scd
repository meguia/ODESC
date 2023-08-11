
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
Ndef(\Dvdp, {|alpha=0.1, tau=0.1, mu=1, beta=1.0, k12=0.1, amp=0.2, tm1=100, tm2=1000|
	var vdp,duf;
	vdp = Fb1_ODE.ar(\Vanderpol, [alpha, tau],tm1, 0, [0, 1]);
	duf = Fb1_ODE.ar(\Duff, [mu, beta,k12*vdp.sum],tm2, 0, [0, 1]);
	duf*amp;
}).play;
)

(
~scope = Stethoscope();
~scope.style = 2;
)

FreqScope.new(600, 300, 0);
s.plotTree;
m = ServerMeter(s)
///////////////////////////////////////////////////////////////////////////////

Ndef(\Dvdp).fadeTime = 5

Ndef(\Dvdp).xset(\alpha,0.1,\tau,0.3,\mu,0.06,\beta,0.6,\k12,0.3,\tm1,500,\tm2,300,\amp,0.4) //QUIET START
Ndef(\Dvdp).fadeTime = 10
Ndef(\Dvdp).xset(\tau,0.7,\mu,0.12,\beta,0.9,\ki12,0.2,\tm1,400,\tm2,700,\amp,0.3) // MILD CHAOS

Ndef(\Dvdp).xset(\k12,0.15) // STABILIZATION

Ndef(\Dvdp).xset(\mu,0.08,\beta,0.9,\tm2,700,\amp,0.4) // SLIGHTLY UNSTABLE

Ndef(\Dvdp).xset(\tau,0.2,\k12,0.15,\tm1,1700) // (DE)STABILIZATION (0.15)

Ndef(\Dvdp).fadeTime = 5
Ndef(\Dvdp).xset(\mu,0.02,\beta,0.5,\tm2,800) // STABLE
Ndef(\Dvdp).xset(\mu,0.02,\beta,-0.5) // ROTATION

Ndef(\Dvdp).fadeTime = 10
Ndef(\Dvdp).xset(\mu,0.1,\beta,0.5,\tm2,2500,\amp,0.3) // CYCLES

Ndef(\Dvdp).xset(\tau,0.1,\k12,1.2,\tm1,1700) // HARMONICS

Ndef(\Dvdp).xset(\mu,0.1,\beta,0.5,\tm2,1200) // LESS CYCLES

Ndef(\Dvdp).xset(\mu,0.02,\tau,0.1,\k12,0.1,\amp,0.4) // STABLE
Ndef(\Dvdp).xset(\k12,0.3) // PULSATING

Ndef(\Dvdp).xset(\tm2,2200)
Ndef(\Dvdp).xset(\tm1,2200)
Ndef(\Dvdp).xset(\tau,0.1,\k12,0.8,\amp,0.3) // PULSATING

Ndef(\Dvdp).xset(\tm2,700,\amp,0.25) // LOWERING
Ndef(\Dvdp).xset(\tm1,450,\amp,0.5) // LOWERING MORE

Ndef(\Dvdp).xset(\alpha,1.9,\amp,0.3) // BEATING
Ndef(\Dvdp).xset(\beta,1.9,\amp,0.25) // BEATING
Ndef(\Dvdp).xset(\alpha,3.9,\k12,0.6,\amp,0.15) // BEATING
Ndef(\Dvdp).xset(\tm1,1100,\amp,0.1) // CONVERSATION

Ndef(\Dvdp).xset(\tm2,300) // CONVERSATION UNDER THE WATER
Ndef(\Dvdp).xset(\tm1,400,\amp,0.1) // RALL

Ndef(\Dvdp).xset(\tm2,100) // BIG MOUTH
Ndef(\Dvdp).fadeTime = 10
Ndef(\Dvdp).xset(\tm2,1) // FADE OUT







/////////////////////////////////////

Ndef(\Dvdp).clear










