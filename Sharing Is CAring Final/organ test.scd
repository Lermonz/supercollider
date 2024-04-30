/*
I have no idea what I'm doing
*/

//boot server
s.boot;

//Essential Variables
(
~bpm = 95;
~step = (60/1)*(1/~bpm)*(1/4);
~scale = Scale.diminished(\young);
)
//Synths
(
SynthDef(\Azu, {
	arg freq=440, amp=1, atk=0.001, rel=0.4;
	var snd, env;
	freq = freq*PinkNoise.kr(1/(freq*2), 1);
	snd = LPF.ar((LFSaw.ar(freq)),freq*4);
	env = EnvGen.kr(Env.new([0,1,0], [atk,rel], [1,-1]), doneAction:2);
	snd = snd*env*amp;
	snd = Pan2.ar(snd);
	Out.ar(0, snd);
}).add;
SynthDef(\Rocker, {
	var snd, env;
	snd = SinOscFB.ar(Stepper.kr(Impulse.kr(20),Impulse.kr(2),4,8,1,4)*110,0.8,0.4);
	env = EnvGen.kr(Env.perc(1,2), doneAction: 2);
	snd = snd*env;
	snd = Pan2.ar(snd);
	Out.ar(0,snd);
}).add;
SynthDef(\Solace, {
	arg freq=440, amp=1, lpf=1200, pan=0;
	var snd, del;
	snd = PSinGrain.ar(freq,0.55);
	snd = LPF.ar(snd+PSinGrain.ar(freq*2,0.4)*Env.perc(0,0.8,1,-8).ar,lpf);
	snd = snd*amp * 15.dbamp;
	snd = Pan2.ar(snd,pan);
	Out.ar(0,snd);
}).add;
SynthDef(\Ender, {
	arg freq=110, amp=1, pan=0;
	var snd, env, del;
	snd = SinOsc.ar(SinOsc.ar(freq*5, 0, 600, freq*8));
	del = DelayN.ar(snd, 1, 0.4);
	snd = snd.blend(del, 0.5);
	env = EnvGen.kr(Env.perc(0,1), doneAction: 2);
	snd = snd*env*amp;
	snd = Pan2.ar(snd,pan);
	Out.ar(0, snd);
}).add;
SynthDef(\Mylky, {
	arg freq=110, amp=1;
	var snd, env;
	freq = SinOsc.kr(9,0,3.69,freq);
	snd = SinOsc.ar(Formant.ar(freq*2, Env.perc(0.02,0.4,1,-14).kr*40+freq*13, freq*6.5, 1350, freq*2));
	env = EnvGen.kr(Env.perc(0.1,1),doneAction: 2);
	snd = snd*env*amp* -6.dbamp;
	snd = Pan2.ar(snd);
	Out.ar(0, snd);
}).add;
SynthDef(\Zashy, { //perfect
	arg freq=110, amp=0.6, atk=1.5, rel=4.5, pan=0;
	var snd, env;
	snd = SinOscFB.ar(Dust.kr(80, 10, freq*4-5), 0.2);
	snd = snd+(LPF.ar(LFCub.ar(SinOsc.ar(freq*4, 0, 500, freq*5)),6000) * -10.dbamp);
	env = EnvGen.kr(Env.new([0,0.3,0.65,0.3,0], [atk*2,atk,1,rel], [5,-3,4,-2]), doneAction:2);
	snd = snd*env*amp;
	pan = SinOsc.kr(0.1,pi*3/2,0.8);
	snd = Pan2.ar(snd,pan);
	Out.ar(0, snd);
}).add;
)
//Drums
(
SynthDef(\kick, {
	arg amp=1;
	var snd;
	snd = SinOsc.ar(60 * (1 + (4*Env.perc(0.001, 0.3, curve:-18).ar)) * XLine.ar(1,0.5,1) * [1,1.3,3.3,4.5]);
	snd = snd * Env.perc(0, [1, 0.3, 0.1, 0.04]).ar;
	snd = snd * [0,-9,-6,-9].dbamp;
	snd = snd.sum;
	//snd = snd + (SinOsc.ar(XLine.ar(3000, 20, 0.01)) * Env.perc(0.001, 0.03).ar);
	snd = snd + (BPF.ar(WhiteNoise.ar,2400,0.5) * Env.perc(0.001, 0.06).ar * -2.dbamp);
	snd = snd*Env.perc(0.001, Rand.new(0.15,0.35)).ar(Done.freeSelf);
	snd = snd*amp* -4.dbamp;
	snd = Pan2.ar(snd);
	Out.ar(0,snd);
}).add;
SynthDef(\snare, {
	arg amp=1;
	var snd;
	snd = LFTri.ar(130 * (1 + (0.75*Env.perc(0, 0.6).ar)) * XLine.ar(1,0.6,0.12) * [1,1.3,1.7]) * -5.dbamp;
	snd = snd * Env.perc(0, [0.15, 0.2, 0.1]).ar;
	snd = snd * [0,-9,-6,-9].dbamp;
	snd = snd.sum * -3.dbamp;
	snd = snd + (LFTri.ar(XLine.ar(500, 20, 0.05)) * Env.perc(0, 0.1).ar * -7.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar,2030,2) * Env.perc(0.03, 0.8).ar  * -3.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar,7200,0.6) * Env.perc(0.001, 0.4).ar * -4.dbamp);
	snd = snd*Env.perc(0.001, 0.6,1,-8).ar(Done.freeSelf);
	snd = snd*amp;
	snd = Pan2.ar(snd);
	Out.ar(0,snd);
}).add;
SynthDef(\hihat, {
	arg amp=1;
	var snd;
	snd = BPF.ar(WhiteNoise.ar,6900,10) * Env.perc(0,0.07).ar(Done.freeSelf);
	snd = snd*amp * -10.dbamp;
	snd = Pan2.ar(snd);
	Out.ar(0,snd);
}).add;
)

//Pdefs
(
Pdef(\Qhords,
	Pbind(
		\instrument, \Azu,
		\octave, 2,
		\lag, 0,
		\degree, Pseq([7,0,0,3, 3,0,2,2],inf),
		\dur, ~step,
		\amp, Pseq([
			1,0,0,0, 1,0,0,0,
			1,0,0,0, 1,0,0,0,
			1,0,0,0, 1,0,0,0,
			1,0,0,1, 0,0,1,0,
		], inf),
	)
);
Pdef(\Dimin,
	Pbind(
		\instrument, \Zashy,
		\octave, 4,
		\degree, [0,3,6]+Pseq([0,0,0,0, 3,3,3,3, 4,4,4,4, 2,2,2,2,], inf),
		\dur, ~step*16,
		\amp, Pseq([
			0.3,0,0,0, 0.2,0,0,0, 0.1,0,0,0, 0.3,0,0,0,
		], inf),
	)
);
Pdef(\ArpSol,
	Pbind(
		\instrument, \Solace,
		\degree, Pseq([0,3,6,9],inf),
		\dur, ~step,
		\amp, Pseq([
			0.1,0.2,0.2,0.3, 0.3,0.4,0.4,0.5,
			0.5,0.6,0.7,0.7, 0.5,0.5,0.4,0.3,
			0.2,0.2,0.1,0.1, 0.03,0.03,0.03,0.03,
			0,0,0,0, 0,0,0,0,
		]*2,inf),
		\pan, Pseq([0.6,0.3,0,-0.3,-0.6,0,0.3],inf),
	)
);
Pdef(\ArpSol2,
	Pbind(
		\instrument, \Solace,
		\degree, 6+Pseq([0,3,6,9],inf),
		\dur, ~step,
		\amp, Pseq([
			0.1,0.2,0.2,0.3, 0.3,0.4,0.4,0.5,
			0.5,0.6,0.7,0.7, 0.5,0.5,0.4,0.3,
			0.2,0.2,0.1,0.1, 0.03,0.03,0.03,0.03,
			0,0,0,0, 0,0,0,0,
		]*2,inf),
		\pan, Pseq([0.6,0.3,0,-0.3,-0.6,0,0.3],inf),
	)
);
Pdef(\marimba,
	Pbind(
		\instrument, \Ender,
		\octave, 4,
		\scale, Scale.locrian,
		\degree, Pseq([
			0,0,1,0, 0,0,1,0,
			0,0,1,0, 0,0,0,0,
			3,0,0,0, 4,0,0,0,
			3,0,0,0, 1,0,0,0,
		],inf),
		\dur, ~step,
		\amp, Pseq([
			0.5,0,0.6,0, 0.7,0,0.4,0,
			0.3,0,0,0, 0.2,0,0,0,
			0,0,0,0, 1,0,0,0,
			1,0,0,0, 1,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0.7,0,0,0, 0.8,0,0,0,
			0.7,0,0,0, 0.7,0,0,0,
		],inf),
		\pan, Pseq([-0.5,0,0.5],inf),
	)
);
Pdef(\mylkimba,
	Pbind(
		\instrument, \Mylky,
		\octave, 5,
		\scale, Scale.locrian,
		\degree, Pseq([
			0,0,1,0, 0,0,1,0,
			0,0,1,0, 0,0,0,0,
			0,0,0,0, 4,0,0,0,
			3,0,0,0, 4,0,0,0,
			3,0,0,0, 4,0,0,0,
			3,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,1,0,
		],inf),
		\dur, ~step,
		\amp, Pseq([
			0.5,0,0.6,0, 0.7,0,0.4,0,
			0.3,0,0,0, 0.2,0,0,0,
			0,0,0,0, 1,0,0,0,
			1,0,0,0, 0.6,0,0,0,
			0.6,0,0,0, 0.2,0,0,0,
			0.2,0,0,0, 0,0,0,0,
			0.7,0,0,0, 0,0,0,0,
			0,0,0,0, 0.4,0,0.4,0,
		],inf),
		\pan, Pseq([-0.5,0,0.5],inf),
	)
);
Pdef(\moctaves,
	Pbind(
		\instrument, \Mylky,
		\octave, 3,
		\degree, Pseq([
			7,0,0,0, 12,0,0,0,
			19,0,0,0, 12,0,0,0,],inf),
		\dur, ~step,
		\amp, Pseq([
			0.8,0,0,0, 0.9,0,0,0,
			1,0,0,0, 0.9,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
		]*0.7,inf),
	)
);
Pdef(\bells,
	Pbind(
		\instrument, \Ender,
		\octave, 2,
		\degree, Pseq([0,Pseq([Pshuf([0,0,7,7,7,2,3,3])],inf)]),
		\dur, ~step*8,
		\amp, Pseq([
			1,0,0,0, 0.7,0,0,0],inf),
	)
);
Pdef(\kicks1,
	Pbind(
		\instrument, \kick,
		\dur, ~step,
		\amp, Pseq([
			1,0,0,0, 1,0,0,0,
			1,0,0,1, 0,0,1,0,
			1,0,0,0, 1,0,0,0,
			0,0,Pshuf([1,0,0,0]),0,0,
		],inf)
	)
);
Pdef(\kicks2,
	Pbind(
		\instrument, \kick,
		\dur, ~step,
		\amp, Pseq([
			1,0,0,1, 0,0,1,0,
			0,0,1,0, 0,0,1,0,
			1,0,0,1, 0,0,1,0,
			0,1,0,1, 0,Pshuf([0.1,0.5,1]),
		],inf)
	)
);
Pdef(\snares,
	Pbind(
		\instrument, \snare,
		\dur, ~step,
		\amp, Pseq([
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,Pshuf([0,0.5]),
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
		]*0.8,inf)
	)
);
Pdef(\hihats,
	Pbind(
		\instrument, \hihat,
		\dur, ~step,
		\amp, Pseq([
			0.2,0.3,0.4,0.5, 0.7,0.6,0.5,0.4,
			0,0,0,0, 0,0,0,0,
		],inf)
	)
);
)

//this is where the music will start
(
t = TempoClock(~bpm/60);
t.schedAbs(t.nextBar,{
	t.beatsPerBar_(16);
});
t.schedAbs(t.nextBar, {
	Pdef(\Dimin).play(quant: 0.1);
	(
		w={
			arg amp = 0;
			var snd;
			amp = amp.varlag(10, 1);
			snd = HPF.ar(BrownNoise.ar(LFNoise2.ar(4,0.6,1.1)),LFNoise2.kr(SinOsc.kr(1,0,0.3,0.7),500,750));
			snd = Pan2.ar(snd)*amp;
			Out.ar(0,snd);
		}.play;
	);
	(
	t.sched(0.1, {
		w.set(\amp, 0.07);
	}));
});
t.schedAbs(60, {
	t.playNextBar({
		Pdef(\kicks1).play(quant: 0.1);
		Pdef(\hihats).play(quant: 0.1);
	});
});
)

//wait until percussion comes in, wait 15 seconds, then add
(
t.playNextBar({
	Pdef(\marimba).play(quant: 0.1);
	Pdef(\bells).play(quant: 0.1);
})
)

// wait 20-ish seconds
(
t.playNextBar({
	Pdef(\kicks1).stop;
	Pdef(\hihats).stop;
	Pdef(\marimba).stop;
	Pdef(\bells).stop;

	Pdef(\mylkimba).play(quant: 0.1);
	Pdef(\bells).play(quant: 0.1);
	Pdef(\snares).play(quant: 0.1);
	Pdef(\kicks1).play(quant: 0.1);
	Pdef(\hihats).play(quant: 0.1);
})
)

// wait 20-ish seconds
(
t.playNextBar({
	Pdef(\kicks1).stop;
	Pdef(\bells).stop;
	Pdef(\mylkimba).stop;
	Pdef(\hihats).stop;
	Pdef(\snares).stop;

	Pdef(\Qhords).play(quant: 0.1);
	Pdef(\snares).play(quant: 0.1);
	Pdef(\kicks2).play(quant: 0.1);
	Pdef(\hihats).play(quant: 0.1);
	Pdef(\ArpSol).play(quant: 0.1);
})
)

// wait 20-ish seconds
(
t.playNextBar({
	Pdef(\Qhords).stop;

	Pdef(\Qhords).play(quant: 0.1);
	Pdef(\ArpSol2).play(quant: 0.1);
})
)

// do very soon after triggering prev
(
t.playNextBar({
	Pdef(\ArpSol).stop;
	Pdef(\ArpSol2).stop;

	Pdef(\marimba).play(quant: 0.1);
})
)

// wait 30-ish seconds
(
t.playNextBar({
	Pdef(\snares).stop;
	Pdef(\Qhords).stop;
	Pdef(\kicks2).stop;
	Pdef(\marimba).stop;
	Pdef(\hihats).stop;


	Pdef(\bells).play(quant: 0.1);
	Pdef(\kicks2).play(quant: 0.1);
	Pdef(\hihats).play(quant: 0.1);
	Pdef(\marimba).play(quant: 0.1);
})
)

// wait 15-ish seconds
(
w.set(\amp, 0);
t.sched(60, {w.free;})
)

// wait 20-ish seconds
(
t.playNextBar({
	Pdef(\kicks2).stop;
	Pdef(\marimba).stop;
	Pdef(\hihats).stop;
	Pdef(\bells).stop;
})
)

//once that one has taken effect, apply this routine immediately
(
t.playNextBar({
	Pdef(\Dimin).stop;
})
)
