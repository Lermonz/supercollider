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

# Fuck

i had a thought hours after submitting this that it won't be able to play on any other device because i didn't include the sample into my github directory to abuse the short path to get there, so i went back into the instructions to see if it was necessary to play on anyone's computer and i finally saw the link in the .md instructions file and it's blowing my mind i feel so fuckign stupid

i am restarting the assignment pretty much.

i spent a while just analyzing how the first example in the tweet scd page works. (it especially took me a while to understand how it got some variation in its rhythm)

had the idea to change the frequency based on an LFPulse to make an interval out of just one channel like how a lot of tracker music does. with my current knowledge from class and the minimal reading i did on the wiki page provided in the instructions i got this
```
play{LFPulse.ar(LFPulse.kr(20,1,0.5,57,220),1,0.25,0.5)!2}
```
which is not great. using a pulse to affect the frequency got kinda the right affect but it could only do 2 notes in the channel, which isn't enough to sound good with this effect all on its own. it reminded me of a telephone, which i then attempted to lean into even more by having the mul be affected by a pulse too, so it'll turn on and off like a landline ringing
```
play{LFPulse.ar(LFPulse.kr(20,1,0.5,57,220),1,0.25,LFPulse.kr(1)*0.5)!2}
```
but i dont really want that!!!

i want movement in either a chord change or a ryhthm (or both if i can fit it)

i tried using what i already knew to do this. by making a variable that is itself a pulse, then multiplying that be the correct ratios within what actually gets played, to allow for a chord change to a rhythm! it actually did work but it still sounds like a telephone

```
play{f=LFPulse.kr(1,1/3,1/3,110,220);LFPulse.ar(LFPulse.kr(13,1,1/3,f*0.19,f),1,0.25,1/3)!2}
```

i want it to sound musical!!! not just like a noise.

attempted using an LFNoise0 for f to get randomness in the same effect but that sounded worse imo (it does sound kinda neat but not enough to replace this idea)
```
play{f=LFNoise0.kr(1,110,220);LFPulse.ar(LFPulse.kr(20,1,0.5,f*0.19,f),1,0.25,0.5)!2}
```
(actually going back to this later, an LFNoise one with this sounds incredibly funny)

later decided that the most important thing is to have more than just 2 notes playing, so i scowered the depths of the SuperCollider Browse UGens page to see if there was anything that could, in a very small amount of text, select between a small set of integers that is not random and not too limited in scope.

the best one i found was Stepper, which i decided to cycle through super fast to do that same arpeggio effect i love but now with as many options as i want!!

```
play{LFPulse.ar(Stepper.kr(LFPulse.kr(42),0,220,440,55),1,1/3,0.2)!2}
```
hey wtf why is it going down (it is doing what i expect generally, but it is drifting downward in frequency overtime before shooting back up to the original)

dont know why that happens, but apparently using smaller numbers inside the stepper then multiplying it outside makes it work properly.
```
play{LFPulse.ar(Stepper.kr(LFPulse.kr(42),0,4,8,1)*55,1,1/3,0.2)!2}
```
^ same thing but now good

but i wanna bring back the variable thing cuz that was cool movement
```
play{f=LFPulse.kr(1/2,1/3,1/3,77,220);LFPulse.ar(Stepper.kr(LFPulse.kr(42),0,4,8,1)*(f/4),1,1/3,0.2)!2}
```
now this is gaming! and only 103 characters? i can add some more stuff with this. 

i wanna be different from the first example in the instructions link tho, so i'll add a bassline instead of a percussion thing and make the frequency based on the same variable to actually use it as a variable lol

```
play{f=LFPulse.kr(1/2,1/3,1/3,77,220);LFPulse.ar(Stepper.kr(LFPulse.kr(42),0,4,8,1)*(f/4),1,1/3,0.2)+(LFCub.ar(f/4,1,0.3))!2}
```
yeah that's pretty good, but i still want *more*

i actually do wanna add a percussion thing just so i can understand it more.

i went back to analyzing the example for a while, and figured out how it works and added my own variation of it
```
play{f=LFPulse.kr(1/2,1/3,1/3,77,220);LFPulse.ar(Stepper.kr(LFPulse.kr(42),0,4,8,1)*(f/4),1,1/3,0.2)+(LFCub.ar(f/4,1,0.3))+(WhiteNoise.ar(LFPulse.kr(6,0,LFPulse.kr(2,1/4)/2+0.1)/8))!2}
```
ah shit

this is 184 characters tho

gotta cut it down (but i dont wanna (but you gotta))

i'd like to keep the noise in some way, but it requires a lot of text in order to be interesting, and i can't just cut the bass cuz that's only 22 characters i'd cut, which isn't enough. i can't cut the variable stuff that makes the chord change cuz that's the only real original thing i did that makes it sound neat.

maybe... i do cut the percussion and just find a way to make the bass more interesting to make up for it.

ugggghhhh i got so many more ideas on how to make the bass more interesting, like maybe turning into a doubling of bass and kick, and using that idea to vary how loud multiply of its mul is which is already affected by a pulse to blah blah blah 

i did not have as much wiggle room as i thought, so i have this, which is fine enough considering its 139 characters
```
play{f=LFPulse.kr(1/2,1/3,1/3,77,220);LFPulse.ar(Stepper.kr(LFPulse.kr(42),0,4,8,1)*(f/4),1,1/3,0.2)+(LFCub.ar(f/4,1,LFPulse.kr(3)*0.4))!2}
```