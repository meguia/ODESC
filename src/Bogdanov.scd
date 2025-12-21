s.reboot;
s.plotTree;
/////////////////////////////////////////////////////////
/// BOGDANOV TAKENS WITH CUBIC UNFOLDING AND NOISE

// First the ODE System

//This is a posible universal unfolding of the Bogdanov-Takens (BT) codimension 2 bifurcation (that in fact has 2 BT points) with a third parameter controlling the "hardness" of the oscillator and the senistivity to noise.

//We use this system to explore the neighborhoods of a Saddle-Node on a Limit Cycle bifurcation (SNLC) which is a second route to oscillatory behavior in 2D system (if we consider the Hopf bifurcation as the first route). In this route, the oscillations appear with infinite period, and before the bifurcation the system behaves as excitable, that means that a small perturbation (like noise added to a variable) can trigger an amplified response. Also this SN branch (that in turn originates in a cusp bifurcation) can limit some region of bistability between a stationary state and a stable limit cycle. The border between these regions of excitable and bistable behavior is an Homoclinic Bifurcation curve.

//Since the region of interest is narrow zone around that SN bifurcation we will move along that curve in the (μ1,μ2) space. Then we will have three control parameters for the system and one for the noise:

// * μ that controls the position along the SN curve going from the cusp point at μ2=-1/3 and crosses two Hopf bifurcations (the main region of interest is between these two Hopf crossings). Since we are restrictig to this curve the other bifurcation parameter of the system (μ1) is not free.
// * δμ that controls the distance from the SN curve and acts as a correction of the previous μ2 control parameter (μ2=μ-δμ). For positive values we are in the excitable (or bistable) region and for negative values we enter into the periodic regime
// * δ is a third parameter that acts like a nonlinear dissipation and control the "hardness" of the oscillations. For lower values there are many oscillations around the focus point and the system y more senitive to noise. For higher values the oscillations are more like peaks and is less sensitive to noise. Also this parameter controls the second Hopf curve and the Homoclinic curve. Then, for lower values the region that limits the SN is bistable and that region get narrower as δ rises and finally it gets confined only to the higher part of the curve (near the first Hopf curve) and all the rest correspond to the excitable region.
// * η controls the amount of white noise added to the first equation of the system. Whithin the excitable or bistable regions a small amount of noise can trigger pulses or bursts respectively.

// The deterministic part of the system is:
// \dot{x} = y
// \dot{y} = \mu_1 + \mu_2 x - \delta xy + x^2 - x^3 - x^2y

(
Fb1_ODEdef(\Bogdanov, { |t, y, mu1 = 0.1, mu2 = 0.0, delta=1.0, a=0.0|
    [
        { y[1] + a},
		{ y[0] * (mu2 - (delta * y[1]) + (y[0] * (1 - y[0] - y[1]))) + mu1}
    ]
}, 0, [0, 0], 1, 1);
)

// Now we define a Node Proxy that control the Bogdanov system in the neighborhood of the SN bifurcation with the four control parameters mentioned above plus an amplitude (amp), time scale (tm), and pan (pan) parameter. The noise input is given by a Pink Noise with the amplitude conveniently scaled by the square root of the time scale.

(
Ndef(\BT1, {|mu = -0.1, dmu=0.0, delta=1.0, eta=0.0, amp=0.2, tm=1000, pan=0.0|
	var input, sig, mu1, mu2, fc, fa, fb;
	mu1 = ((2.0*mu+(2/3.0))*sqrt(3.0*mu+1.0)+(3.0*mu)+(2/3))/9.0.neg;
	mu2 = mu-dmu;
	input = PinkNoise.ar(mul: eta/sqrt(tm));
	sig = Fb1_ODE.ar(\Bogdanov, [mu1, mu2, delta, input],tm, 0, [1, 1]);
	Pan2.ar(sig[1]*amp,pan);
});
)

// Finally, we can make copies to play with:

Ndef(\BT1).copy(\BT2);

// a simple scope
(
~scope = Stethoscope(bufsize:8192,zoom:0.1);
~scope.style = 0;
~scope.yZoom = 0.1;
~scope.window.name = 'Bogdanov x2';
~scope.window.bounds = Rect(20,650,1800,400);
)


// And now, let the fun begin!
Ndef(\BT1).fadeTime = 5
Ndef(\BT2).fadeTime = 5
Ndef(\BT1).play.xset(\pan,-1.0);
Ndef(\BT2).play.xset(\pan,1.0);

// Silent Start
Ndef(\BT1).xset(\mu,0.24,\dmu,-0.001,\delta,2.0,\eta,0.0,\amp,1.0,\tm,300);
Ndef(\BT2).xset(\mu,0.24,\dmu,-0.001,\delta,2.0,\eta,0.0,\amp,1.0,\tm,300);

// Initial deterministic pulses
Ndef(\BT1).xset(\mu,0.24,\dmu,0.0001,\eta,0.0,\amp,3.0,\tm,500,\delta,2.0);
Ndef(\BT2).xset(\mu,0.24,\dmu,0.0001,\eta,0.0,\amp,3.0,\tm,500,\delta,2.0);

// some randomness within the excitable region
(
Ndef(\BT1).xset(\dmu,-0.0001,\eta,2.0,\amp,3.0,\delta,2.0,\tm,600);
Ndef(\BT2).xset(\dmu,-0.0001,\eta,2.0,\amp,3.0,\delta,2.0,\tm,600);
)

// some randomness within the bistable region generating bursts
(
Ndef(\BT1).xset(\delta,0.9,\eta,3.0,\tm,700);
Ndef(\BT2).xset(\delta,0.9,\eta,3.0,\tm,700);
)

// moving up near the Hopf
(
Ndef(\BT1).xset(\mu,0.01,\amp,5.0,\delta,0.9,\dmu,-0.0001);
Ndef(\BT2).xset(\mu,0.01,\amp,5.0,\delta,0.9,\dmu,-0.0001);
)

// coming back to the periodic behavior
Ndef(\BT1).xset(\amp,3,\dmu,0.016,\eta,1.0);
Ndef(\BT2).xset(\amp,3,\dmu,0.01,\eta,1.0);

// and now with softer oscillations
Ndef(\BT1).xset(\delta,0.6);
Ndef(\BT2).xset(\delta,0.6);

Ndef(\BT1).xset(\delta,0.9,\eta,10.0);
Ndef(\BT2).xset(\delta,0.9,\eta,10.0);
Ndef(\BT1).xset(\tm,750,\mu,0.5);
Ndef(\BT2).xset(\tm,700,\mu,0.5);

// moving away from the Hopf the noise filterd
Ndef(\BT1).xset(\delta,0.5);
Ndef(\BT2).xset(\delta,0.5);

// Higher mountain
Ndef(\BT1).xset(\tm,1000,\amp,1.0,\eta,15.0);
Ndef(\BT2).xset(\tm,950,\amp,1.0,\eta,15.0);

// pulses again
Ndef(\BT1).xset(\dmu,-0.0001,\amp,0.5,\eta,3.0,\delta,3.0);
Ndef(\BT2).xset(\dmu,-0.0001,\amp,0.5,\eta,3.0,\delta,3.0);

// play with the following back and forth
Ndef(\BT1).xset(\dmu,0.001,\eta,0.5,\amp,0.7,\delta,3.0)
Ndef(\BT2).xset(\dmu,0.001,\eta,0.5,\amp,0.7,\delta,3.0)

Ndef(\BT1).xset(\tm,1200,\dmu,0.03,\eta,0.1,\amp,0.8,\delta,1.5)
Ndef(\BT2).xset(\tm,1200,\dmu,0.025,\eta,0.1,\amp,0.8,\delta,1.4)

Ndef(\BT1).xset(\dmu,0.02,\eta,0.1,\amp,1.5,\delta,1.0)
Ndef(\BT2).xset(\dmu,0.023,\eta,0.1,\amp,1.5,\delta,1.1)

Ndef(\BT1).xset(\dmu,0.015,\eta,0.1,\amp,1.0,\delta,0.9)
Ndef(\BT2).xset(\dmu,0.013,\eta,0.1,\amp,1.0,\delta,1.1)

Ndef(\BT1).xset(\dmu,0.1,\eta,0.1,\amp,1.0,\delta,1.2)
Ndef(\BT2).xset(\dmu,0.1,\eta,0.1,\amp,1.0,\delta,0.8)

Ndef(\BT1).xset(\dmu,0.04,\eta,0.1,\amp,1.0,\delta,0.75)
Ndef(\BT2).xset(\dmu,0.05,\eta,0.1,\amp,1.0,\delta,0.86)









