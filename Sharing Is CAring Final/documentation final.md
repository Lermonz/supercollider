## To Play It
boot the server

follow the comments to initiliaze the necessary variables, synths, drums, and pdefs.

the commented amounts of time to wait are based on when the routines actually start playing sounds 

(so, when it says to wait 20-ish seconds, yo wait for 20 secs after having begun hearing the sounds from the previously played routine)

## Some Stories Behind The Code
most of the organization of this is entirely based on the organization of the piece i analyzed for the midterm, anything could happen. Pretty much the entire structure of it is copy pasted from that. Including: 
- setting some variables at the top and naming the most important one ~step
- separating the synthDefs of regular synths and drums into 2 sections of parentheses to initialize, even tho there's not really a difference here like there was there
- organizing the Pseqs inside my Pdefs as being made of 2 columns of 4 numbers each to make following the music easier
- using (quant:0.1); at the end of each play command for the Pdefs in routines
- stopping and restarting Pdefs in routines to prevent them from getting out of sync with the new ones being added

one issue i had for a while was that the envelopes generators weren't closing after being used, which was causing massive amounts of ghost nodes, it took me several weeks to remember what a doneAction was, so I went back and set the EnvGen to have a doneAction of 2, which finally let me unlock my creativity without fear of using billions of CPU or whatever

I also ended up changing the length of how long supercollider considers a bar to be, so that things could guaranteed be more lined up, since some of my Pdefs had fairly long Pseqs attached to 'em

most of the fun came from designing synths, i made some cool fm stuff cuz that was pretty intuitive to make in scd. I also thought it would be cute to name them all after some of my online friends (it is cute).

### Synth Thoughts:
**Azu:** The first one I made for this song, the idea was to have the frequency be have constant slight randomization so that it wouldn't feel static and boring, but it's still a simple synth

**Rocker:** I wanted to use Stepper again in the same way I did in my 140 character assignement, and this is a fine synth using it, but I ended up not using this in the song, left it int for fun

**Solace:** Took one listen to what PSinGrain sounded like and I became a fan, for a while in the development of this piece it was even simpler, being just a singular PSinGrain UGen and that's it, and it worked great, but I did want it to feel a bit more alive

**Ender:** Was scratching my head over what type of synth I wanted to make next, and once I thought about making an FM one I realized it was perfect. I set the parameters within the synthdef to be very similar to how many FM Modules show the options of making synths with them, so I could play with the frequencies just as easily hear as I could a normal FM synth, ends up sounding like a bell

**Mylky:** Figured making a the modulator waveshape being something other than a Sine wave would be interesting (I was right). It sounds very twangy and silly, so I figured I would give it like, a stupid amount of vibrato, (which I did by just doing more FM lmao).

**Zashy:** Struggled with this one for a while. For most of the development it was both really bland and really harsh somehow. Eventually just restarted the whole synth with the idea of it being a very long dissonant pad. Got wacky with the custom EnvGen to make it feel natural, overall very happy with how it turned out. Ended up making it kinda the most important synth in the piece and gave it some fun panning shtuff.

## Resources Used To Fix Shit
[used this](https://www.youtube.com/watch?v=xYc7_PbbtuE) tutorial to figure out how to make drum sounds. It also helped just get away from the fear of the unfamiliar a bit, oddly enough. Idk, after finally understanding what was going on in this vid I went back to making just synths much easier.

[buh](https://www.youtube.com/watch?v=VjUcklVHPNk) used to find out how delays work in scd. Which I used for 1-2 of my synths to make them feel cooler. 

[tried changing Pbind value patterns on the fly](https://depts.washington.edu/dxscdoc/Help/Tutorials/A-Practical-Guide/PG_Cookbook02_Manipulating_Patterns.html), but i got confused and gave up quick. I wanted to make a linear interpolation thing in order to get a synth to gradually decrease in volume overtime, but i couldn't find i good solution for way too long. I gave up multiple times and eventually settles on triggering chains of t.sched routines to set the amp to gradually decreasing amounts before eventually freeing it. 

BUT LATER, i was looking up what lag was because i saw it in the thing i was analyzing (anything could happen) for the midterm and in my piece i was having issues where some Pdefs would come in slightly off even though i quantized, and i thought "hey maybe that lag thing will help" so i looked it up, found [this tutorial](https://www.youtube.com/watch?v=JCqBPmpj8Gc) and learned this was exactly what i was looking for with my amp issues!!! so i fixed that

And eventually later i realized in order to fix the desyncing of some Pdefs from newer ones, I could just stop them then play them again at the same time as the new ones to guarantee it (which is also something done in anything could happen, go figure).

And I spend a lot of the cmd D-ing any function I didn't know absolutely everything about.