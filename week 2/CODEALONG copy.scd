/*
rachel's recommended UGens for output
Pan2
Out
Mix
Splay
Pan4
*/
(
x={
	arg freq=220, amp=0.5;
	var snd;
	snd=SinOsc.ar(freq:[freq,freq*2,freq*4],mul:[amp,amp/2,amp/8]);
	snd=Mix.ar(snd); // mixes the three channels into 1
	snd=Splay.ar(snd);
	Out.ar(0,snd);
}.play;
)


// free it when done or press <Ctrl>+.
x.free;

/*
rachel interlude on SynthDef
- a class which pre-compiles multiple unit generators together on to the audio server
- greaaat for reuse!
*/

//////// 16 ////////
// lets define a synth to use multiple times
// using a "SynthDef"

(
SynthDef("coolsynth",{ // add SynthDef here, with a name
	arg freq=220, amp=0.1;
	var snd;
	snd=SinOsc.ar(freq:[freq,freq*2,freq*4],mul:[amp,amp/2,amp/8]);
	snd=Mix.ar(snd);
	snd=Splay.ar(snd);
	Out.ar(0,snd);
}).add; // use "add" instead of play
)

// now you can create multiple instances of them!
(
x = Synth("coolsynth",[\freq,60.midicps]);
y = Synth("coolsynth",[\freq,65.midicps]);
z = Synth("coolsynth",[\freq,70.midicps]);
w = Synth("coolsynth",[\freq,62.midicps]);
)

// and each can be set later!
(
x.set(\freq,58.midicps);
y.set(\freq,63.midicps);
z.set(\freq,68.midicps);
w.set(\freq,61.midicps);
)
(
x.set(\freq,60.midicps);
y.set(\freq,65.midicps);
z.set(\freq,58.midicps);
w.set(\freq,62.midicps);
)

// set them all free!
(
x.free;
y.free;
z.free;
w.free;
)


s.scope;

//////// 17 ////////
// you can treat UGens like numbers /* BECAUSE OF OOP*/
// let's add them together and make a new oscillator
// famous oscillators to play with:
// SinOsc, LFSaw, Tri
(
SynthDef("coolsynth",{
	arg freq=110, width=0.0625, amp=0.5;
	var snd;
	// you can directly Mix
	snd=Mix.ar(
		Pulse.ar(freq:[freq,freq*2,freq*4],width:[width*2,width*3,width*4],mul:[amp/2,amp/2,amp/4])
	);
	// lets add some harmonic from a saw wave
	snd=snd+(0.1*Mix.ar(
		LFTri.ar(freq:[freq,freq*2,freq*3,freq*4],mul:[amp,amp/2,amp/3,amp/4]))
	);
	snd=Splay.ar(snd);
	Out.ar(0,snd);
}).add;
)

/*
rachel interlude on arrays vs lists
  - Array: fixed size collection (most common)
  - List: variable size collection
  - What are tuning systems but arrays and lists?*/
m = Scale.minor.degrees; // Scale class returns the degrees of the minor scale

// rachel end interlude

//////// 18 ////////
// fancy multiexpansion
// use Array.fill(<num>,{arg i; <code>})
// to easily create an additive synth
// this is same as 17
(
SynthDef("coolsynth",{
	arg freq=110, amp=0.5;
	var snd;
	// you can directly Mix
	snd=Mix.ar(
		Array.fill(5,{arg i; LFCub.ar(freq:freq*(2**i),mul:amp/(2**i))})
	);
	// lets add some harmonic from a saw wave
	snd=snd+(1.2*Mix.ar(
		Array.fill(4,{arg i; Pulse.ar(freq:freq*(i+1),mul:amp/(i+1))}))
	);
	snd = snd * (-12.dbamp);
	snd=Pan2.ar(snd);
	Out.ar(0,snd);
}).play;
)




//////// 19 ////////
// your turn!
// take the synth in #18 and try changing things, including:
// - try changing the oscillators (try VarSaw, SinOsc, Pulse, LFTri, Saw, ..)
// - try changing the frequency
// - try changing the number of oscillators (instead of 3, do 1, 2, ..)






//////// 20 ////////
// filtering
// LPF, RLPF, HPF, RHPF, BPF
// MoogLadder, MoogVCF, MoogFF
(
{
	arg freq=220;
	var snd;
	var lpf, res;
	snd = Saw.ar([freq,freq+2]); // create a saw wave
	snd = snd * (-6.dbamp); // decrease volume by 6 dB

	lpf = Clip.kr(MouseX.kr(20,20000,1),20,20000); // add mouse modulation to lpf
	res = Clip.kr(MouseY.kr(1,0.02),0.1,1); // add mouse modulation to resonance
	snd = RLPF.ar(snd,lpf,res); // resonant low-pass filter
	Out.ar(0,snd); // output the send
}.play; // .play will play it
)



//////// 21 ////////
// modulation
(
{
	[LFNoise0.kr(100),LFNoise1.kr(100),LFNoise2.kr(100)]
}.plot(0.1)
)
s.scope;



//////// 22 ////////
// combining modulation + filter
(
{
	arg freq = 110;
	var snd;
	var lpf, res;
	snd = Saw.ar([freq,freq-1]); // create a saw wave

	snd = snd * -12.dbamp; // reduce volume by 12 dB

	lpf = LFNoise2.kr(1).range(freq,4000);
	res = LFNoise2.kr(1).range(0.5,1);
	snd = RLPF.ar(snd,lpf, res); // resonant low-pass filter

	Out.ar(0,snd); // output the send
}.play; // .play will play it
)



//////// 23 ////////
// more synths!
(
{
	arg note=32;
	var detune=0.1;
	var snd;
	var lpf, res;
	snd = {
		var freq = (note+LFNoise0.kr(1).range(detune.neg,detune)).midicps; // add detuning to note and then convert to midi
		var snd_ = Pulse.ar(freq,LFNoise2.kr(3).range(0.2,0.8)); // create a pulse wave with pwm
		snd_ = snd_ * -6.dbamp; // reduce volume by 12 dB
		lpf = LFNoise2.kr(1).exprange(100,Rand(1000,5000));
		res = LFNoise2.kr(1).range(0.1,1);
		snd_ = RLPF.ar(snd_,lpf, res); // resonant low-pass filter
		snd_ // return sound
	}!8;

	snd = Splay.ar(snd); // make a stereo field out of all the channels

	Out.ar(0,snd); // output the send
}.play; // .play will play it
)


/*
<3 Rachel <3 Libraries <3
Building out SC Lang to our Liking!
Quarks: https://doc.sccode.org/Guides/UsingQuarks.html
(SuperDirt is a Quark)
They are HARD to install on M1s
*/


//////// 20 ////////
// before running this you must first save `Sun.sc` to the extensions directory.
// open `Sun.sc` in SuperCollider.
// now save it by doing `File -> Save As Extension...` and type `Sun.sc`.

/* THEN go to Language>Reboot Interpreter */

(
s.waitForBoot({
	var scale;

	SynthDef("padVoice",{
		// ARGUMENTS (leave this as is)
		arg note=60,amp=0.5,out=0,attack=1,decay=1;
		var snd = Silent.ar(2); // initialize the sound to silence
		var freq = note.midicps; // midi note converts to frequency using .midicps
		var env = EnvGen.ar(Env.perc(attack,decay,amp,[4,4]),doneAction:2); // envelope
		var pan = LFNoise2.kr(1/Rand(3,6)).range(-0.5,0.5); // random modulation for panning
		var detune = LFNoise2.kr(1/Rand(1,5)).range(-0.1,0.1); // random modulation for detuning or anything



		//////////////////////////////////////////////////
		// ----- START ADDING YOUR OWN SYNTH HERE ----- //
		//////////////////////////////////////////////////

		// note contains the midi note
		// freq contains the frequency

		// simple sine wave
		snd = SinOsc.ar(freq);

		// filtered detuned saw wave
		// with opening filter
		// snd = Saw.ar([note-detune,note+detune].midicps);
		// snd = MoogFF.ar(snd,
		// 	LinExp.kr(0.01+EnvGen.kr(Env.perc(attack,decay)),0.01,1.01,freq,ExpRand(freq*2,20000)));

		// simple filtered saw wave
		// snd = Saw.ar(freq);
		// snd = LPF.ar(snd, freq*8);

		// sine with phase modulation feedack
		// feedback is randomly modulated
		// snd = SinOscFB.ar(freq, LFNoise2.kr(1/3).range(0,1));

		// a switch can randomly switch between
		// snd = SelectX.ar(LFNoise2.kr(1).range(0,1),[
		// 	LFTri.ar(freq),
		// 	SinOsc.ar(freq),
		// ]);


		//////////////////////////////////////////////////
		// ------ DONE ADDING YOUR OWN SYNTH HERE ----- //
		//////////////////////////////////////////////////



		// panning
		snd=snd!2;
		snd = Balance2.ar(snd[0],snd[1],pan);

		// send data to the GUI
		SendReply.kr(Impulse.kr(25),"/sunposition",[\sector.kr(0),note,env,pan,detune.abs]);

		// final output
		Out.ar(out,snd*env/12);
	}).send(s);

	// effects
	SynthDef("padOutput",{
		arg amp=1.0;

		// collect the sound coming from the bus "0" on 2 channels (stereo)
		var snd=In.ar(0,2);

		// replace the output with the effected output /*RACHEL EDITS*/
		ReplaceOut.ar(0,snd*Lag.kr(amp));
	}).send(s);


	// CHANGE THIS!
	// set the scale
	scale = Scale.major;
	// scale = Scale.minor;
	// scale = Scale.dorian;
	// ... see more at ScaleLP

	// set the four

	// the Sun plays random notes from the scale
	b=Sun.new(s,
		argSynName:"padVoice",
		argSynOutput:"padOutput",
		argScale:scale,
		argTimes:[10,7,5,2], // <--- CHANGE THIS! these numbers correspond to the durations for the south, east, west, and north sectors
		argNums:[1,2,3,1] // <--- CHANGE THIS! these numbers correspond to the number of voices for the south, east, west, and north sectors
	);
	b.gui;
})
)