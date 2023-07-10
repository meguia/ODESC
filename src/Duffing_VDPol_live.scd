
s.options.blockSize = 128;
s.reboot;
r = Recorder(s);
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
Ndef(\Dvdp, {|mu = 1, beta = 1.0, in1=0.0, amp = 0.2,tm = 1000|
	var sig = Fb1_ODE.ar(\Duff, [mu, beta, in1],tm, 0, [0, 1]);
	LPF.ar(sig,500.0)*amp;
}).play;
)

(
Ndef(\VDP, {|mu = 0.1, tau=0.2, amp = 0.02,tm = 1000|
	var sig = Fb1_ODE.ar(\Vanderpol, [mu, tau],tm, 0, [0, 1]);
	sig *amp;
});
)

Ndef(\Dvdp) <<>.in1 Ndef(\VDP);

(
~scope = QStethoscope();
~scope.scopeView.style = 2;
)

FreqScope.new(600, 300, 0);
s.plotTree;

///////////////////////////////////////////////////////////////////////////////
r.record(numChannels:2);

Ndef(\Dvdp).fadeTime = 10
Ndef(\VDP).fadeTime = 5

Ndef(\Dvdp).xset(\mu,0.06,\beta,0.6,\tm,300,\amp,0.06)
Ndef(\VDP).xset(\tau,0.3,\amp,0.3,\tm,500) //QUIET START

Ndef(\Dvdp).xset(\mu,0.12,\beta,0.9,\tm,700,\amp,0.06)
Ndef(\VDP).xset(\tau,0.7,\amp,0.1,\tm,400) // MILD CHAOS

Ndef(\VDP).xset(\tau,0.7,\amp,0.1,\tm,1200) // STABILIZATION

Ndef(\Dvdp).xset(\mu,0.1,\beta,0.9,\tm,700,\amp,0.06) // SLIGHTLY UNSTABLE

Ndef(\VDP).xset(\tau,0.2,\amp,0.1,\tm,1700) // STABILIZATION
Ndef(\VDP).xset(\tau,0.1,\amp,0.1,\tm,1700) // DES ''

Ndef(\Dvdp).xset(\mu,0.1,\beta,0.5,\tm,500,\amp,0.1) // STABLE
Ndef(\Dvdp).fadeTime = 3
Ndef(\Dvdp).xset(\mu,0.1,\beta,-0.5,\tm,500,\amp,0.1) // ROTATION

Ndef(\Dvdp).fadeTime = 10
Ndef(\Dvdp).xset(\mu,0.1,\beta,0.5,\tm,2500,\amp,0.06) // CYCLES

Ndef(\VDP).xset(\tau,0.1,\amp,1.2,\tm,1700) // HARMONICS

Ndef(\Dvdp).xset(\mu,0.1,\beta,0.5,\tm,1200,\amp,0.04) // LESS CYCLES

Ndef(\VDP).xset(\tau,0.1,\amp,0.1,\tm,1200)
Ndef(\Dvdp).xset(\mu,0.1,\beta,0.2,\tm,600,\amp,0.06) // INVERSE HARMONICS

/////////////////////////////////////
r.stopRecording;
Ndef(\Dvdp).clear
Ndef(\VDP).clear









