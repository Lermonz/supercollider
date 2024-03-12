//actual one
play{f=LFPulse.kr(1/2,1/3,1/3,77,220);LFPulse.ar(Stepper.kr(LFPulse.kr(42),0,4,8,1)*(f/4),1,1/3,0.2)+(LFCub.ar(f/4,1,LFPulse.kr(3)*0.4))!2}

//original that i thought was bad because i abused the fact i put a very short path on my computer to reach a sample
b = Buffer.read(s, "/Users/cooper/e.wav");
(
{
    var n;
	n=Mix.ar(PlayBuf.ar(2,b,[0.5,1,1.2,1.5],0,[0,60000,0,5000],1));
    Out.ar(0,n);
}.play;
)