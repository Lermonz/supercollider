// QUICK CODE DUE March 5!

// highly, highly edited from: https://doc.sccode.org/Tutorials/A-Practical-Guide/PG_01_Introduction.html

/*
Busses
Generally your analog definition works: how we route audio to new places, but they're actually a little more complicated than that.

When we boot the audio server and see the I/O we see something like:
"MacBook Pro Speakers" Output Device
   Streams: 1
      0  channels 2

This means that there is a STEREO bus called "0" on the server RECEIVING 1 STREAM which is sending stereo out to our hardware output device.

So, what's a Stream?

SC puts abstract objects (meaning we don't necessarily explicitly declare them) on busses on the server that wait to receive messages. Nodes are the most common of these types of objects (related to the "Node Not Found" error message we got last week). Messages travel to Nodes and other abstract objects on Streams.

There is a special type of Stream called an Event Stream which basically allows the Stream to continue to deliver messages but Nodes can start and stop doing the things ON the messages.

PBind is the most common UGen that uses this Stream/Event Stream feature.

[example below from PBind help file]
*/

(
SynthDef(\cfstring1, { arg i_out, freq = 360, gate = 1, pan, amp=0.1;
    var out, eg, fc, osc, a, b, w;
    fc = LinExp.kr(LFNoise1.kr(Rand(0.25, 0.4)), -1, 1, 500, 2000);
    osc = Mix.fill(8, {LFSaw.ar(freq * [Rand(0.99, 1.01), Rand(0.99, 1.01)], 0, amp) }).distort * 0.2;
    eg = EnvGen.kr(Env.asr(1, 1, 1), gate, doneAction: Done.freeSelf);
    out = eg * RLPF.ar(osc, fc, 0.1);
    #a, b = out;
    Out.ar(i_out, Mix.ar(PanAz.ar(4, [a, b], [pan, pan+0.3])));
}).add;

e = Pbind(
    \degree, Pseq((0..12), inf),
    \dur, 0.2,
    \instrument, \cfstring1
).play; // returns an EventStream
)

( // an interactive session
e.stop
e.play
e.reset

e.mute; // keeps playing, but replaces notes with rests

e.unmute;

e.reset; // reset the stream.
e.reset; // reset the stream.
e.reset; // reset the stream.
e.reset; // reset the stream.

e.pause; // will resume where paused.

e.play;

e.stop; // will reset before resume.

e.play;
)

/*Simple Pattern UGens to go with PBind from https://doc.sccode.org/Browse.html#Streams-Patterns-Events
  - **Pseq**
  - Goes through sequence */

(
p = Pbind(
    \degree, Pseq(#[0, 0, 4, 4, 5, 5, 4], 1),
    \dur, Pseq(#[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1], 1)
).play;
)
p.stop;
/*
  - **Pseries**
  - Arithmetic
  - **Pgeom**
  - Geometry*/
(
p = Pbind(
    \degree, Pseries(-7, 1, 15),
    \dur, Pgeom(0.5, 0.89140193218427, 15)
).play;
)

/*
  - **Prand**
- "Randomly" chooses from array */

(
p = Pbind(
    \degree, Prand([0, 1, 2, 4, 5], inf),
    \dur, 0.25
).play;
)
/*
  - **Pxrand**
  - "Randomly" chooses but never twice in a row*/

(
p = Pbind(
    \degree, Pxrand([0, 1, 2, 4, 5], inf),
    \dur, 0.25
).play;
)
/*
  - **Pshuf**
  - Shuffles the list in random order but then uses the same random order*/

(
p = Pbind(
    \degree, Pshuf([0, 1, 2, 4, 5], inf),
    \dur, 0.25
).play;
)
/*
  - **Pwrand**
  - Chooses "randomly" according to weighted probabilities*/

(
p = Pbind(
    \degree, Pwrand((0..7), [4, 1, 3, 1, 3, 2, 1].normalizeSum, inf),
    \dur, 0.25
).play;
)

/*
## Probability
Pwhite(lo, hi, length)
Produces length random numbers with equal distribution ('white' refers to white noise).
Pexprand(lo, hi, length)
Same, but the random numbers have an exponential distribution, favoring lower numbers. This is good for frequencies, and also durations (because you need more notes with a shorter duration to balance the weight of longer notes).
Pbrown(lo, hi, step, length)
Brownian motion. Each value adds a random step to the previous value, where the step has an equal distribution between -step and +step.
Pgbrown(lo, hi, step, length)
Brownian motion on a geometric scale. Each value multiplies a random step factor to the previous value.
Pbeta(lo, hi, prob1, prob2, length)
Beta distribution, where prob1 = α (alpha) and prob2 = β (beta).
Pcauchy(mean, spread, length)
Cauchy distribution.
Pgauss(mean, dev, length)
Gaussian (normal) distribution.
Phprand(lo, hi, length)
Returns the greater of two equal-distribution random numbers.
Plprand(lo, hi, length)
Returns the lesser of two equal-distribution random numbers.
Pmeanrand(lo, hi, length)
Returns the average of two equal-distribution random numbers, i.e., (x + y) / 2.
Ppoisson(mean, length)
Poisson distribution.
Pprob(distribution, lo, hi, length, tableSize)
Given an array of relative probabilities across the desired range (a histogram) representing an arbitrary distribution, generates random numbers corresponding to that distribution.
*/

/*Envelopes
  - Envelopes wrap around a sound to start and stop it
  - Attack, Decay, Sustain, and Release most common type across electronic music
  - SC can do sustaining (untimed) and un-sustaining envelopes (timed)
    - sustaining: we don't know how it is going to end when it starts
    - un-sustaining: we have to know how it is going to end when it starts
    - Gates control sustaining envelopes (they can open and close)
    - Triggers instigate un-sustaining envelopes
  - **EnvGen** is the UGen to make envelopes (Envelope Generator!)*/

//Shapes:

Env.linen(1, 2, 3, 0.6).test.plot;
Env.triangle(1, 1).test.plot;
Env.sine(1, 1).test.plot;
Env.perc(0.05, 1, 1, -4).test.plot;
Env.asr(0.2, 0.5, 1, 1).test.plot;
Env.adsr(0.2, 0.2, 0.5, 1, 1, 1).test.plot;
Env.cutoff(1, 1).test(2).plot;
Env.new([0, 1, 0.3, 0.8, 0], [2, 3, 1, 4],'sine').test.plot; //DIY shape

// Done Actions:

0 - Do nothing when the envelope has ended.
1 - Pause the synth running, it is still resident.
2 - Remove the synth and deallocate it.
3 - Remove and deallocate both this synth and the preceding node.
4 - Remove and deallocate both this synth and the following node.
5 - Same as 3. If the preceding node is a group then free all members of the group.
6 - Same as 4. If the following node is a group then free all members of the group.
7 - Same as 3. If the synth is part of a group, free all preceding nodes in the group.
8 - Same as 4. If the synth is part of a group, free all following nodes in the group.
9 - Same as 2, but pause the preceding node.
10 - Same as 2, but pause the following node.
11 - Same as 2, but if the preceding node is a group then free its synths.
12 - Same as 2, but if the following node is a group then free its synths.
13 - Frees the synth and all preceding and following nodes.

(
SynthDef("envSynth", {var env;
	env = EnvGen.kr(Env.sine(1, 3), doneAction:2);
	Out.ar(0, SinOsc.ar(200))}).add;
)
d= Synth("envSynth");

/* Let's hook up Scale with PBind and TUNING systems! */

Tuning.directory

t = Tuning.harrison;
t.semitones;
t.ratios.collect(_.round(0.001));

Pbind(\scale, Scale.minor(t), \degree, Pxrand((0..15), inf), \dur, 0.25).play;

/*
Routines & Tasks:
  - Pattern-less passing of messages to streams
  - Need to sync things with clocks?
    - SystemClock: Most reliable
    - TempoClock: Best for beats
  - Need to start and stop full iterations with clocks?
    - **Routine**
  - Need to start, stop, and pause iterations without clocks?
    - **Task**
https://doc.sccode.org/Tutorials/Getting-Started/15-Sequencing-with-Routines-and-Tasks.html
WAIT == YIELD
*/
(
SynthDef(\bleep,{ arg out=0, note=60, amp=0.5, pan=0.0;
	var freq, env;
	freq = note.midicps;
	env = EnvGen.ar(
					Env([0,1,1,0],[0.01, 0.1, 0.2]),
					levelScale:amp,
					doneAction:2
				);
	Out.ar(out,
		Pan2.ar(Blip.ar(freq) * env, pan)
	)
}).add;
)
/// SystemClock
(

SystemClock.sched(0.0,//start at 0.0 sec from now, i.e. immediately

	{//a function which states what you wish to schedule

		Synth(\bleep);

		1		//repeat every second

	}

))
/// TempoClock
(
var t;
t = TempoClock(2); // 120 bpm = 2 beats per second
t.schedAbs(0, { arg ... args;
				args.postln;
				Synth(\bleep);// make a bleep
				1.0	// reschedule every beat
}))
/// Simple Routine
(
r = Routine({
		1.wait;
		Synth(\bleep);
		2.wait;
		Synth(\bleep);
	});
)
///
r.play;
/// Simple Task
(
t = Task({
    loop {
        [60, 62, 64, 65, 67, 69, 71, 72].do({ |midi|
            Synth(\singrain, [freq: midi.midicps, amp: 0.2, sustain: 0.1]);
            0.125.wait;
        });
    }
}).play;
)

// probably stops in the middle of the scale
t.stop;

t.play;    // should pick up with the next note

t.stop;

/***Forks**
    - Routine shortcut. Wraps routine into .play and allows you to pass a clock into it.
    - Because SC is totally OOP, have to use an object method to iterate
    - **.do** is the most common*/

(3.do({ "threescrambledeggs".scramble.postln; }))

(
{16.do{arg i; Synth(\bleep, [\note,rrand(48,84) ,\amp, rrand(0.0,0.125)]); 2.wait} }.fork(TempoClock(2))
)
