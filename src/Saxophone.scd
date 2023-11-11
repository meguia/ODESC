s.options.blockSize = 16;
s.reboot;

///////////////////////////////////////////////////

(
Fb1_ODEdef(\saxophone, { |t, y, gamma, zeta| // blow, lip pressue
	var omega0 = 4.224;
	var omega = [1.195,2.483,3.727,4.405,5.153,6.177,6.749,7.987];
	var alpha = [0.0176,0.0355,0.0653,0.2693,0.0703,0.166,0.0945,0.1165];
	var c = [0.1761,0.4705,0.6494,0.328,0.541,0.2249,0.3822,0.4099];
	var pressures = y[2,4..];
	var velocities = y[3,5..];
	var equations, u;

    equations = [
		{ y[1] },
		{
			var pressure = pressures.sum;
			var contactForce = 100 * min(y[0]+1, 0).squared * (1-y[1]);
			var forces = omega0.squared * (contactForce + pressure - gamma - y[0]);
			var dissipativeForce = omega0.neg * y[1];
			dissipativeForce + forces
		},
    ];

	u = { // velocity of air flux
		var pressure = pressures.sum;
		zeta * max(y[0]+1, 0) * sign(gamma - pressure) * (gamma - pressure).abs.sqrt
	};

	8.do { |i|
		equations = equations.add({
			(neg(alpha[i]) * pressures[i]) - (2 * omega[i] * velocities[i]) + (2 * c[i] * u.value)
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

Ndef(\saxophone, \saxophone).play;

(
~scope = Ndef(\saxophone).scope;
~scope.style = 2;
Ndef(\saxophone).gui;
)
