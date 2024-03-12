b = Buffer.read(s, "/Users/cooper/e.wav");
(
{
	var n;
	n=Mix.ar(PlayBuf.ar(2,b,[0.5,1,1.2,1.5],0,[0,60000,0,5000],1));
    Out.ar(0,n);
}.play;
)
play{LFCub.ar(LFSaw.kr(LFPulse.kr(1/4,1/4,1/4)*2+2,1,-20,50))+(WhiteNoise.ar(LFPulse.kr(4,0,LFPulse.kr(1,3/4)/4+0.05))/8)!2}

play{LFPulse.ar(LFPulse.kr(20,1,0.5,57,220),1,0.25,0.5)!2}

play{LFPulse.ar(LFPulse.kr(20,1,0.5,57,220),1,0.25,LFPulse.kr(1)*0.5)!2}


play{f=LFNoise1.kr(1,210,320);LFPulse.ar(LFPulse.kr(20,1,0.5,f*0.19,f),1,0.25,0.5)!2}

play{f=LFPulse.kr(1,1/3,1/3,110,220);LFPulse.ar(LFPulse.kr(13,1,1/3,f*0.19,f),1,0.25,1/3)!2}

play{LFPulse.ar(Stepper.kr(LFPulse.kr(42),0,4,8,1)*55,1,1/3,0.2)!2}

play{f=LFPulse.kr(1/2,1/3,1/3,77,220);LFPulse.ar(Stepper.kr(LFPulse.kr(42),0,4,8,1)*(f/4),1,1/3,0.2)!2}

play{f=LFPulse.kr(1/2,1/3,1/3,77,220);LFPulse.ar(Stepper.kr(LFPulse.kr(42),0,4,8,1)*(f/4),1,1/3,0.2)+(LFCub.ar(f/4,1,0.3))!2}

play{f=LFPulse.kr(1/2,1/3,1/3,77,220);LFPulse.ar(Stepper.kr(LFPulse.kr(42),0,4,8,1)*(f/4),1,1/3,0.2)+(LFCub.ar(f/4,1,0.3))+(WhiteNoise.ar(LFPulse.kr(6,0,LFPulse.kr(2,1/4)/2+0.1)/8))!2}

play{f=LFPulse.kr(1/2,1/3,1/3,77,220);LFPulse.ar(Stepper.kr(LFPulse.kr(42),0,4,8,1)*(f/4),1,1/3,0.2)+(LFCub.ar(f/4,1,LFPulse.kr(3)*0.4))!2}

play{LFSaw.ar(55,1,0.3)}

play{LFPulse.ar(Stepper.kr(LFPulse.kr(30),0,4,8,1)*55,0,1/4,1/3)!2}

(
{
	LFNoise0.kr(100,110,220)
}.plot(0.1)
)
(
SynthDef("help-Stepper",{ arg out=0;
    Out.ar(out,
        SinOsc.ar(
            Stepper.kr(Impulse.kr(10), 0, 4, 16, 1) * 100,
            0, 0.05
        )
    )
}).play;
)