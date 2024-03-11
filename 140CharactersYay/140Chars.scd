b = Buffer.read(s, "/Users/cooper/e.wav");
(
{
    var n;
	n=Mix.ar(PlayBuf.ar(2,b,[0.5,1,1.2,1.5],0,[0,60000,0,5000],1));
    Out.ar(0,n);
}.play;
)