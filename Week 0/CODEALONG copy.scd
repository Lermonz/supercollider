// slightly edited from https://github.com/schollz/workshops


//////// 1 ////////
// this is a comment! it is valid code but doesn't do anything

/*this is a...
multi-line comment, multi-line comments here are rachel's*/


//////// 2 ////////
// now, this is a line of code that does something!
// this line prints something in the window over there ->
// run any line of code by putting your cursor on it and then
// press <Shift>+<Enter>

"peepeepoopoo".postln;// <- make sure to always have a ";" after code




//////// 3 ////////
// parentheses make it easy to
// run multiple lines of code

(
"wubbadubbadub is that true?".postln;
"yeh".postln;
)




//////// 4 ////////
// disorder of operations!
// there is no order of operations in SuperCollider!
// beware beware beware beware

(
(100+2/2).postln; // what does this equal?
(100+(2/2)).postln; // force order of operations using parentheses
)




//////// 5 ////////
// semicolons make functions
// you can assign variables using letters a-z or with ~variableName
// execute each step, incrementally

// step 1: create functions stored in a variable

(
b={"bababooey".postln;};

~someVariable={"yoobydooby".postln;};
)

// step 2a: run the first function

b.value; // .value evaluates the function stored in "a"

// step 2b: run the second function

~someVariable.value;





//////// 6 ////////
// functions can have arguments and variables!
// arguments and variables are similar, except that arguments can be passed into functions when the function is called.
// step 1: create a function that contains arguments and variable
(
a={
	arg name; // arguments must be defined first
	var something="it here"; // then variables must be defined next
	// variables can be assigned later
	(name++", do you like "++something++"?").postln;
};
)

// step 2: execute the function
a.value("Heyfvgbfhbfvjfgy");

/*
rachel interlude on variables
- they're containers of a value
- you need to declare them but not their type (which is good and bad...)
- local variables work like this*/
a = 1;
(
var a;
a = 3;
);
a
/*
rachel interlude on arguments
- declared one of two ways: */
arg //old school like above
| | //"pipe notation"
/*
IMPORTANT DISTINCTION: arguments you can change on the fly, variables can be assigned later but you have to reup the synth to the server

rachel interlude on objects and messages.
- We can assign objects to variables, then send messages to those objects with the syntax `object.message`*/
f = { "eggs".scramble };
f.value;
f.value;
"eggs".scramble.value;
/*
- .value means evaluate the function `f`
- Each message executes a particular method
- Different objects share methods with the same name, but because they're different objects, they execute the same message differently a la polymorphism (you down with OOP?)

rachel interlude on the server
- The audio engine!
- 's' stands for server! Don't assign things to it
- useful **s.** commands*/
 s.makeWindow;
 s.record;
 s.stopRecording;
 s.scope;
 s.addr // the address of the server (IP address and Port)
 s.name // the localhost server is the default server (see Main.scd file)
 s.serverRunning // is it running?
 s.avgCPU // how much CPU is it using right now?

// end rachel interludes

//////// 7 ////////
// let's get into the music now!
// we need to boot the server to start music making:
// goto Server -> Boot Server





//////// 8 ////////
// lets make a function that generates a Sine wave
// SuperCollider generates things with a "UGen"
// the UGen for Sine waves is called "SinOsc"

(
{
	SinOsc.ar(freq:220);
}.plot(10/220); // .plot(x) will plot it for x seconds
)




//////// 9 ////////
// finally lets make a sound!
// just add .play to our function
// instead of .plot
(
{
	SinOsc.ar(freq:220);
}.play; // .play will play it
)


/* rachel interlude
let's use
s.scope;
and see how mono it is
remember that everything is mono by default, which is annoying now but
will facilitate fun later

COMMAND, PERIOD KILLS WHAT'S ON THE SERVER */




//////// 10  ////////
// lets have the synth make another sound
// by adding an argument (see 6)
// and also save it to a variable (see 5)

// save a variable and a Sine UGen to the "x" variable
(
x={
	arg freq=220;
	SinOsc.ar(freq:freq);
}.play; // .play will play it
)

// now you can run each of these lines to change it!
x.set(\freq,440);

x.set(\freq,60.midicps); // .midicps converts midi note to frequency (cycles per second)

// free it when done or press <Ctrl>+.
x.free; // we can stop the synth running this line

/* rachel interlude on UGens
- Many classes of them (inheritance...you down with OOP?)
- Modular building blocks of synthesis systems
- Think of them like modules in your synthesizer
  - They make a waveform, a filter, etc.
- In SC they're actually written in C/C++ and are a plugin to the SC Server, but most come standard with download
  - Most UGen classes have Audio Rate **.ar** and Control Rate **.kr** signal methods internal to the language.
- AR = sends 44.1k values per second; KR = sends 7,350 values per second (1/6th as many as ar. Just saves CPU this way!...like difference between VCO and LFO modules in a modular synth).
- Let's get out of mono with Pan2:*/
{Pan2.ar(SinOsc.ar(440))}.play;
{Pan2.ar(SinOsc.ar(440), SinOsc.kr(44))}.play

// end rachel interlude

//////// 11 ////////
// UGens constantly generate numbers
// but they can also be treated like numbers,
// you can multiply them (or add or subtract...)
// for instance, we can increase volume:

(
x={
	arg freq=220, amp=0.5;
	SinOsc.ar(freq:freq)*amp;
}.play;
)

// lowers the volume
x.set(\amp,0.1);

// raise the volume and set the frequency (you can do multiple things)
x.set(\amp,0.7,\freq,440);

// free it when done
x.free;




//////// 12 ////////
// UGens have all sorts of parameters
// SinOsc happens to have one that gets multiplied, call "mul".
// highlight "SinOsc" and press <<command>+D [mac] to see the parameters

(
x={
	arg freq=220, amp=0.5;
	SinOsc.ar(freq:freq,mul:amp);
}.play; // .play will play it
)

// free it when done
x.free;

// note: this is exactly the same as in 11
// in SuperCollider there are always many ways to do the same thing


/*
rachel interlude on busses
your analog meaning of busses mostly make sense here
there are ar and kr methods on bus classes just as described earlier
ar bus methods are kind of confusing in sc sometimes because there are sometimes private busses that work more like effects sends and aren't explicitly declared.
a good explanation of this can be found here:
https://doc.sccode.org/Tutorials/Getting-Started/11-Busses.html
*/


//////// 13 ////////
// lets use Out.ar to specify the sound
// Out will output the result to the "bus"
// bus "0" is the audio out
(
x={
	arg freq=220, amp=0.5;
	var snd;
	snd=SinOsc.ar(freq:freq,mul:amp);
	Out.ar(0,snd);
}.play;
)

// free it when done
x.free;
// note: this is exactly the same as 11 and 12
// in 11 and 12, SuperCollider assumed this is what
// we wanted


/* RACHEL STOP HERE IF YOU HAVE GOTTEN HERE WEEK ONE */



//////// 14 ////////
// "multichannel expansion" is SuperCollider's secret sauce.
// "multichannel expansion" also sounds cool to drop in conversation.
// "multichannel expansion" means that SuperCollider will automatically
// generate multiple UGens for you when a parameter has an array
// and assign each UGen to an audio channel (e.g. left and right speakers).

(
x={
	arg freq=220, amp=0.5;
	var snd;
	snd=SinOsc.ar(freq:[freq,freq*2],mul:[amp,amp/2]);
	Out.ar(0,snd);
}.play;
)

// you should hear
// lower frequency at higher volume in left ear
// higher frequency at lower volume in right ear

// free it when done or press <Ctrl>+.
x.free;




//////// 15 ////////
// sometimes you don't want multichannel expansion
// so you can mix it down to a single channel using the
// Mix.ar UGen
// then you can split it across the left/right using Splay

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
- a class which pre-compiles multiple unit generators together
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
y = Synth("coolsynth",[\freq,62.midicps]);
z = Synth("coolsynth",[\freq,65.midicps]);
)

// and each can be set later!
(
x.set(\freq,58.midicps);
y.set(\freq,62.midicps);
z.set(\freq,67.midicps);
)
(
x.set(\freq,60.midicps);
y.set(\freq,62.midicps);
z.set(\freq,65.midicps);
)

// set them all free!
(
x.free;
y.free;
z.free;
)




//////// 17 ////////
// you can treat UGens like numbers
// lets add them together and make a new oscillator
// famous oscillators to play with:
// SinOsc, LFSaw, Tri
(
SynthDef("coolsynth",{
	arg freq=110, amp=0.5;
	var snd;
	// you can directly Mix
	snd=Mix.ar(
		SinOsc.ar(freq:[freq,freq*2,freq*4],mul:[amp,amp/2,amp/4])
	);
	// lets add some harmonic from a saw wave
	snd=snd+(0.1*Mix.ar(
		Saw.ar(freq:[freq,freq*2,freq*3,freq*4],mul:[amp,amp/2,amp/3,amp/4]))
	);
	// note: the following doesn't work, why not?
	// snd=snd+0.5*Mix.ar(Saw.ar(freq:[freq,freq*2],mul:[amp,amp/2]));
	snd=Splay.ar(snd);
	Out.ar(0,snd);
}).play;
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
		Array.fill(2,{arg i; SinOsc.ar(freq:freq*(2**i),mul:amp/(2**i))})
	);
	// lets add some harmonic from a saw wave
	snd=snd+(0.1*Mix.ar(
		Array.fill(4,{arg i; Saw.ar(freq:freq*(i+1),mul:amp/(i+1))}))
	);
	snd=Splay.ar(snd);
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
	res = Clip.kr(MouseY.kr(0.02,1),0.1,1); // add mouse modulation to resonance
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


/* TODO RACHEL INTERLUDE ON EXTENSIONS VS QUARKS <<<<<<<<<<<<<<<


//////// 20 ////////
// before running this you must first save `Sun.sc` to the extensions directory.
// open `Sun.sc` in SuperCollider.
// now save it by doing `File -> Save As Extension...` and type `Sun.sc`.

// to run this code, but a cursor anywhere in the code block (a code block is enclosed in parentheses)
// and hit <Ctrl>+Enter
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

		///////////////////////////////////////////////////////
		// ----- START ADDING YOUR GLOBAL EFFECTS HERE ----- //
		///////////////////////////////////////////////////////

		// add some nice tape compression
		snd = AnalogTape.ar(snd,0.9,0.8,0.9,2);

		// add some reverb
		snd = SelectX.ar(LFNoise2.kr(1/3).range(0.1,0.5),[
			snd,
			Fverb.ar(snd[0],snd[1],50,decay:LFNoise2.kr(1/3).range(70,90))
		]);

		///////////////////////////////////////////////////////
		// ----- DONE ADDING YOUR GLOBAL EFFECTS HERE ------ //
		///////////////////////////////////////////////////////

		// replace the output with the effected output
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
