s.options.blockSize = 16;
s.reboot;

///////////////////////////////////////////////////

(
Fb1_ODEdef(\saxophone, { |t, y, gamma, zeta| // blow, lip pressue
	var omega0 = 4.224;
	var omega = \omega.kr([1.195, 2.483, 3.727, 4.405, 5.153, 6.177, 6.749, 7.987]);
	var alpha = \alpha.kr([0.0176, 0.0355, 0.0653, 0.2693, 0.0703, 0.166, 0.0945, 0.1165]);
	var c = \c.kr([0.1761, 0.4705, 0.6494, 0.328, 0.541, 0.2249, 0.3822, 0.4099]);
	var pressures = y[2,4..];
	var velocities = y[3,5..];
	var equations, u;
	var pressure = pressures.sum;
	var blowPressure = gamma - pressure;
	var fluxVelocity = zeta * max(y[0]+1, 0) * blowPressure.abs.sqrt * blowPressure.sign;

	equations = [
		{ y[1] },
		{
			var contactForce = 100 * min(y[0]+1, 0).squared * (1-y[1]);
			var forces = omega0.squared * (contactForce - blowPressure - y[0]);
			var dissipativeForce = omega0.neg * y[1];
			dissipativeForce + forces
		}
	];

	8.do { |i|
		equations = equations.add({
			(neg(alpha[i]) * pressures[i]) - (2 * omega[i] * velocities[i]) + (2 * c[i] * fluxVelocity)
		});
		equations = equations.add({
			(neg(alpha[i]) * velocities[i]) + (0.5 * omega[i] * pressures[i])
		});
	};

	equations

}, 0, [-0.3, 0] ++ [0, 0.01].dup(8).flat, 1, 1);

SynthDef(\saxophone, {
	var env = EnvGate.new;
	var gamma = \gamma.kr(0.3, 0.05, spec: [0.0, 0.8, \lin, 0, 0.3]);
	var zeta = \zeta.kr(0.6, 0.05, spec: [0.0, 1.0, \lin, 0, 0.6]);
	var tm = \tm.kr(1000, 0.1, spec: [1, 4000, \lin, 0, 1000]);
	var eq = Fb1_ODE.ar(\saxophone, [gamma * env, zeta], tm, 0);
	Out.ar(\out.kr, eq)
}).add;

Ndef(\saxophone, \saxophone);
)

// direct playback
Ndef(\saxophone).set(\tm, 600);
Ndef(\saxophone, \saxophone).play(vol:0.1);


// scoping
(
~scope = Ndef(\saxophone).scope;
~scope.style = 2;
Ndef(\saxophone).gui;
)



// play with cursor
(
Ndef(\gamma,  { MouseX.kr(0, 0.8).poll(3, "gamma") });
Ndef(\zeta, { MouseY.kr(0, 1).poll(3, "zeta") });
Ndef(\saxophone).set(\zeta, Ndef(\zeta), \gamma, Ndef(\gamma));
)


// playback with a bit of space
(
Ndef(\saxophone, \saxophone).stop;
Ndef(\mix, {
	var sig = Ndef.ar(\saxophone).sum;
	var preDelayed = DelayL.ar(sig, 0.03, 0.03);
	sig = FreeVerb.ar(preDelayed, mix: 0.4, room: 0.8, damp: 0.8) + sig;
	sig * 0.3 ! 2
}).play;
)


Ndef(\saxophone).set(\omega,  [1.195, 2.483, 3.727, 4.405, 5.153, 6.177, 6.749, 7.987] + 1);
Ndef(\saxophone).set(\alpha,  [0.0176, 0.0355, 0.0653, 0.2693, 0.0703, 0.166, 0.0945, 0.1165] + 0.04);

Ndef(\saxophone).set(\alpha,  [0.0176, 0.0355, 0.0653, 0.2693, 0.0703, 0.166, 0.0945, 0.1165].scramble); // some random variations
Ndef(\saxophone).set(\c,  [0.1761, 0.4705, 0.6494, 0.328, 0.541, 0.2249, 0.3822,0.4099].scramble); // some random variations


// rough modulations
Ndef(\omega, { [1.195, 2.483, 3.727, 4.405, 5.153, 6.177, 6.749, 7.987] + LFNoise0.kr(2 ! 8).exprange(0.001, 2) });
Ndef(\omega, { [1.195, 2.483, 3.727, 4.405, 5.153, 6.177, 6.749, 7.987] + LFNoise0.kr(SinOsc.kr(0.1).range(1, 9) ! 8).exprange(0.001, 1.5) });
Ndef(\saxophone).set(\omega, Ndef(\omega));

// pressure and blow envelopes

Ndef(\gamma, { MouseX.kr(0, 0.8) + LFNoise1.kr(SinOsc.kr(0.1).range(-2, 9), 1).max(0) });
Ndef(\zeta, { MouseY.kr(0, 1) + LFPulse.kr(SinOsc.kr(0.1).exprange(1, 3), 0, 0.3, 0.3) % 1 });



// // back to default
(
Ndef(\saxophone).set(\omega, [1.195, 2.483, 3.727, 4.405, 5.153, 6.177, 6.749, 7.987]);
Ndef(\saxophone).set(\alpha, [0.0176, 0.0355, 0.0653, 0.2693, 0.0703, 0.166, 0.0945, 0.1165]);
Ndef(\saxophone).set(\c, [0.1761, 0.4705, 0.6494, 0.328, 0.541, 0.2249, 0.3822,0.4099]);
Ndef(\saxophone).set(\zeta, 0.6, \gamma, 0.3);
)


// test if the SynthDef fades out correctly:

a = Synth(\saxophone, [\gamma, 0.3, \zeta, 0.6, \tm, 600]);
a.set(\gamma, 0.5, \zeta, 0.7);
a.set(\gamma, 0.3, \zeta, 0.7);
a.set(\gamma, 0.57, \zeta, 0.29);
a.release(2);


