Beginning: Copy over a synthdef from the codealong we've been using. Specifically the SynthDef"coolsynth" under section 16. This one: 
```
(
SynthDef("coolsynth",{ 
	arg freq=220, amp=0.1;
	var snd;
	snd=SinOsc.ar(freq:[freq,freq*2,freq*4],mul:[amp,amp/2,amp/8]);
	snd=Mix.ar(snd);
	snd=Splay.ar(snd);
	Out.ar(0,snd);
}).add;
)
```
^ 190 characters

and did a few simple things to cut down the number of characters being used, like renaming variables to shorter names (fq instead of freq, sd instead of snd), moving all methods around snd (now sd) to being within one line instead of redefining it with the new methods added. And ended up with this.
```
(
SynthDef("sy",{
    arg fq=220;
    var sn;
    sn=Pan2.ar(Mix.ar(Saw.ar(freq:[fq,fq*2,fq*4])));   
    Out.ar(0,sn);
}).play;
)
```
^ 118 characters

this was too loud and harsh so i switched it back to a SinOsc and brought an amplitude definition, but assigned it with a magic number instead of an arg.


Then i realized that i realistically didn't need it to be a synthdef, so i changed it to just be a playable letter (idr what the real term is, it's defined with a single letter tho which is nice)

and because i wanted it to sound like a chord so i changed the multipliers on the freqs to natively make a minor 7th chord instead of being harmonics (which works better with all channels being assigned the same amplitude anyway) and although this isn't code help, i did use a [website](https://mixbutton.com/mixing-articles/music-note-to-frequency-chart/
) to get the specific frequencies of the notes to make a minor 7th so i could get the ratios relative to the root freq. Obviously the ratios were irrational, so i simplified them to the nearest tenth to save character space:
```
(
x={
    arg fq=220;
    var sn;
    sn=Pan2.ar(Mix.ar(SinOsc.ar(freq:[fq,fq*1.2,fq*1.5,fq*1.8],mul:0.2)));   
    Out.ar(0,sn);
}.play;
)
```
^ 120 characters (AN INCREASE??? this is because of cool chord, i will prob drop the 5)

I will be taking a break now but the current thoughts about making it cooler are to either somehow implement  Pbind to this, or add one line of a mixing thing to be able to change the frequency or something idk. i want some MOVEMENT in this.

### few days later now 
i want to add a sample cuz that can be limitless once i make it short (also i realized i didn't need to assign it to be x, that was pointless lol)

the way we added samples in class took up a lot of characters tho, so i wanted to find a shorter way to do it, and put the sample in the most easily accessible path possible. 

I wasn't exactly sure i knew how supercollider tracks paths and stuff, so i looked up a tutorial for buffers and the very first thing [this guy does in his tutorial video](https://www.youtube.com/watch?v=_GZmuvmgtUc) is show exactly that

(for a while i accidentally had User instead of Users as the start of my directory so it kept saying it didn't exist and i took a while to catch the typo)

so same deal i cut down any unnecessary letters to have as much room as possible while literally just playing a sample, and ended up with this
```
~b = Buffer.read(s, "/Users/cooper/d.wav");
(
{
	var sn;
	sn=PlayBuf.ar(2,~b,1,loop:1);
	Out.ar(0,sn);
}.play;
)
```
^111 characters

accidentally forgot to rename one of the variable references once

didn't think enough was going on here, so i decided to make an array of the rates the same way i did for the frequency in the original one i had to do both a polyrhythm and cool chord stuff all at once !!!!

```
~b = Buffer.read(s, "/Users/cooper/e.wav");
(
{
    var sn;
    sn=Mix.ar(PlayBuf.ar(2,~b,[0.5,1,1.2,1.5],loop:1));
    Out.ar(0,sn);
}.play;
)
```
^136 characters
i also messed around with not using Mix so that it will play different things from different speakers, but then that's limited by how many speakers you have (which for me is 2, so i ended up preferring to use it and just have a cacophany of noises)


the trouble with this technique is that i can't make the polyrhythm more interesting without also messing with the harmony...

actually...

what if i make them start at positions so offset from each other that they'll always be interesting...

attempting this was difficult cuz idk of startPos even responds to an array the same way, and idk how far in to start them to make them interesting (or even how many frames long the sample is). lotsa trial and error with this one

got one that im satisfied with (only possible with the realization that i could still cut down variable names down to one letter all the time)

```
b = Buffer.read(s, "/Users/cooper/e.wav");
(
{
    var n;
	n=Mix.ar(PlayBuf.ar(2,b,[0.5,1,1.2,1.5],0,[0,60000,0,5000],1));
    Out.ar(0,n);
}.play;
)
```
^ 139 characters (a bit of wiggle room to mess with numbers while under the limit)

assigning an unused trigger used less characters than typing out startPos lmao