//We will not be using Pbinds... Pbinds generate events. We can send different types of events.
//You can see all the different types of event that you can send by searching for PG_08 in the Help browser—>
MIDIClient.init
~mysynth = MIDIOut(1);

(
~s1_p1 = Pbind(
	\type, \midi,
	\midicmd, \noteOn, //noteOn is the default so only necessary if you are sending CC messages etc.
	\midiout, ~mysynth,
	\chan, 0,
	\dur, 0.5,
	//\midinote, 60 //+ Pwrand.new([0, 7, 9], [1, 3, 5].reverse.normalizeSum, inf),
	//\amp, Pwhite(0, 1.0) //This may not work on your synth!
	\sustain, Prand([0.02, 1], inf)
).play;
)

~s1_p1.play


//Control changes in Pbinds

(
~s1_20 = Pbind(
	\type, \midi,
	\midicmd, \control,
	\midiout, ~mysynth,
	\chan, 0,
	\ctlNum, 20,
	\control, Pexprand(1, 127, inf).round,
	\dur, 0.5
).play;
)

~s1_20.stop

//So this is great, but we can do BETTER! If you run the code multiple times without stopping the Pbind, you lays er the pattern. This is not so great for live performance as you lose an element of control. There are ways that we can fix this though to allow us to live code.

p = ProxySpace.push;

//Or we can use a Pdef, which is my preffered method of working live. A Pdef keeps reference to a stream that can be replaced while playing. One pattern may be used in many streams in different places. A change in the pattern definition propagates through all streams. No disruption! Edit and reevaluate.

//First we should set the tempo
t=TempoClock.new(127/60);

//update the tempo like this
t.tempo = 80/60

//Here's a Pdef
(
Pdef(\s1_p1, Pbind(
	\type, \midi,
	\midicmd, \noteOn, //noteOn is the default so only necessary if you are sending CC messages etc.
	\midiout, ~mysynth,
	\chan, 0,
	\dur, 0.5,
	\midinote, 60,
	\sustain, Prand([0.02, 1], inf)
)).play(t);

)

//Stop the Pdef playing

Pdef(\s1_p1).play(t)

//We can view all the Pdefs we have running using the code below
//This is really useful for live coding because we can
PdefAllGui(16)

//More on patterns..
//Here are some patterns, let's see what they do?

(Pseq([100, 200, 300, 400], 1) + .x Pseq([1,2,3,4], 1)).do { |x| x.postln };

Pser([0,1,2,3,4], 8).do { |x| x.postln };

Pwhite(1, 12, 2).do { |x| x.postln };

//PATTERNS FROM THE PATTERN COOKBOOK
/*http://distractionandnonsense.com/sc/A_Practical_Guide_to_Patterns.pdf
"http://doc.sccode.org/Tutorials/A-Practical-Guide/PG_Cookbook04_Sending_MIDI.html"
"http://danielnouri.org/docs/SuperColliderHelp/Control/MIDIOut.html"
"http://danielnouri.org/docs/SuperColliderHelp/Control/UsingMIDI.html"
"https://www.youtube.com/watch?v=5h1g0hWpU_I"*/

//You can see more information on patterns by searching for 'Streams' in the Help browser.

//We can control tonality in a number of different ways in SuperCollider...
//Rather than setting 'midinote' we can set 'degree' which is the degree of the scale.
//We can see more scales by running the code below
Scale.directory

//Run this patterns and play with the tonality. Find some scales that you liiiiiike.
(
Pdef(\s1_p2,
	Pbind(
		\type, \midi,
		\midiout, ~mysynth,
		\chan, [0],
		//tonality
		\degree, [0,7, 9] + Pseq([0,1,2,3,4,5,6,7], inf),
		//select the scale
		\scale, Scale.gong,
		\root, -12, //The root note of the scale, default is 0 which is middle C
		\dur, 0.25,
		\amp, Pwhite(0.5, 1.0),
	)
).play(t);

)


//You can stop the pattern like this
Pdef(\s1_p2).stop(t)

//We can fade between patterns on updates like this..
Pdef(\s1_p2).fadeTime = 2

//Update a pattern without touching the pattern definition
(
Pbindef(\pat,
	\degree, 4 - Pseq([0,1,5].stutter(4), inf));
)

//
Quarks.install("Bjorklund")
//With my synths, I often find that I want to make changes in



