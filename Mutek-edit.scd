// INTRO TO LIVE CODING IN SUPERCOLLIDER
// MUTEK / MONTREAL
// 23-08-18
// SHELLY KNOTTS

// to run a line of code, put you cursor on the right line and hit shift + return

// try running this:
"Supercollider".postln;

// Boot server
s.boot; // alternatively cmd + B or Language > Boot Server
s.quit;

p = ProxySpace.push; // if we want to live code we need to run this piece of code. we'll come back to what it does later.
().play // run this to make your first sound with SuperCollider!

//when we want to make sound we normally need to use the METHOD .play. Like .postln above this tells supercollider what to do with the information you give it.
// if you don't give it any information about what to play it will just play the default sound, which is what we just heard.
// usually we want to give the sounds that we make names so we can find them again later.
// we write the names like this:

~alice = { }
// anything between the curly brackets is now called ~alice.
// lets make a new name with some parameters:

~alicia = { SinOsc.ar }

~alicia.play // now we can start...
~alicia.stop // ... and stop our new sound called ~alicia
~alicia.clear // ... and if we want to remove all the information attached to that name.



// SinOsc is a type of waveform, other waveforms include:

~amelia = { Saw.ar }; ~amelia.play
~anne = { PinkNoise.ar }; ~anne.play
~aphrodite = { Pulse.ar }; ~aphrodite.play

//we can see the different shapes of our waves forms by running this line of code:
s.scope(2)

// see if you can work out what code you need to write to stop ~amelia, ~anne and ~aphrodite again ;)
// because we only told supercollider which type of wave we want to hear it used default values for frequency (pitch) and amplitude (volume).

// to add our own values we need to add a new bit of code called ARGUMENTS.

~alicia = { SinOsc.ar(freq: 700, phase: 0, mul: 0.3 )  }; ~alicia.play
// try changing the numbers after 'freq:' and 'mul:' to turn ~alice into a
// No interprelation
// 'mul' is short for multiplication, or computer speak for volume.
//don't worry about 'phase:' that's not important for now, but supercollider needs the information in the right order to understand what to do with it.
// notice that we put a comma (,) after each argument to tell supercollider we're about to give it a new piece of information.

// right now the sound changes a soon as you execute the sound, but you might want to fade from one sound to the other.

p.fadeTime = 2; // this will make all of your sounds take 2 seconds to change to the new version.

// we can also set the fade time for individual sounds

~alicia.fadeTime = 0.5;
~andrea.fadeTime = 0.3;

// writing the argument names is good for remembering what the numbers mean, but we can also write the same thing like this:
~alicia = { SinOsc.ar(600, 0, 0.2) }; ~alicia.play

// you can also find out what arguments a waveform needs by looking at the helpfile - highlight SinOsc and hit cmd + D.
//or if you start typing the arguments should appear in a pop up box as you type the first bracket.
// try adding your own arguments to ~andrea ~anne:

~andrea = { Saw.ar(freq: 500, mul: 0.1) }; ~andrea.play
~anne = { PinkNoise.ar(0.2) }; ~anne.play



// now that we've got a few sounds with different names running we might want to use the handy little mixer that appears when you run this line:

ProxyMixer.new(p); // automatic mixer for the sounds you make

// this gives you a nice way to start and stop sounds and to change the volume of the sounds that are running.

// if we make a new sound now it'll appear in the mixer

~beatrice = { Impulse.ar(freq: 5) }

s.meter

// we might want to play more than 1 pitch at a time. we can use [] to tell Supercollider we want to give it more than 1 piece of information. e.g.:

~andrea = { Saw.ar([700, 800, 900, 600], 0.1) }; ~andrea.play

// this is where things get weird and a bit confusing...

// now try running ~betty

~betty = { Saw.ar([700, 800], 0.1) }; ~betty.stop
// Twelve years
// the sounds that we're writing keep the same number of channels as when we first run them.
// normally SuperCollider would see [700, 800] as making a 2 channel sound with frequency of 700 in the left (1st) channel and frequency 800 in the right (2nd) channel.
// so if we add more pitches to ~andrea now it'll keep adding them to the first channel - as we only had 1 channel when we ran it the first time. and if we add more pitches to ~betty it'll keep alternating the pitches between left and right channels.
// try adding some more numbers between the [] now. make sure to put a comma between each number.

// if we're making a new sound which has a lot of pitches though we would use Mix.new to tell SuperCollider we want to hear all of the pitches in 1 channel.

~boudica = { Mix.new( SinOsc.ar([70, 75, 100].midicps) ) }
~boudica_2 = { Splay.ar( SinOsc.ar([500, 700, 1234, 288, 359, 1000.01, 4000]) ) }

~boudica_2 = { Splay.ar( SinOsc.ar(Array.fill(5, { rrand(50, 5000) } )) ) }

Array.fill(5, { rrand(50, 5000) } )

// the first argument of Mix is the thing you want to Mix, so we can just drop our SinOsc right in there.

// WELL DONE! NOW YOU CAN DO ADDITIVE SYNTHESIS. (a fancy term for adding lots of sounds together)



// Another easy type of synthesis is SUBTRACTIVE SYNTHESIS. This means using filters to get rid of some of the sounds.

~filter_betty = { RLPF.ar(Saw.ar([700, 800], 0.1), 800, 0.2, 1)  } // RLPF is a type of Low Pass filter - it cuts out all the frequencies above the 'Cutoff frequency'.

~filter_betty = { RHPF.ar(~betty.ar, 800, 0.2, 1)  } // here's another example with a high pass filter.

// we've replaced our 'Saw.ar([700, 800], 0.1)' with a reference to ~betty. This tells supercollider to use whatever code is called ~betty as the input.

// a third type of synthesis which is useful for making more complex sounds is MODULATION. This means using a second waveform to change or 'modulate' the first. The most simple type of modulation is Amplitude modulation.


~catherine = { Pulse.ar([100, 120], 0.5, SinOsc.kr(10, 0, 0.5, 0.5))  }   // KONTROL RATE TO SAVE CPU

~catherine = { Pulse.ar([100, 120], 0.5, 1)  }// the SinOsc's frequency is how quickly the amplitude changes and the mul and add arguments are how much it changes.

~catherine = { Pulse.ar([100, 120], 0.5, SinOsc.kr(10).range(0, 2))  }
// sometimes it's easier to specify the modulation amount with the range method. Here we specify the upper and lower limits of the amplitude modulation.

// you can use other waveforms to modulate the amplitude. e.g.:

~catherine = { Pulse.ar([100, 120], 0.5, Saw.kr(1).range(0, 1))  }
~catherine = { Pulse.ar([100, 120], 0.5, LFNoise1.kr(100).range(0, 1))  }


// another type of modulation is FREQUENCY MODULATION. Here we multiply a base frequency with another waveform.

~cleopatra = { SinOsc.ar([300, 310] + SinOsc.ar(20, 0, 10), 0, 1 ) } // try different values for the frequency and mul arguments of the modulator to get different sounds.

~cleopatra = { SinOsc.ar([300, 350] + ~catherine.ar, 0, 1 ) } // we can also use the other sounds that we've made as modulators. Using Catherine as a modulator



// we can add other effects to our sounds like Reverb and Comb filters.


~daphne = { GVerb.ar(~cleopatra.ar, 10, 0.1) } // you can find out what each of the arguments are by opening the helpfile. BE CAREFUL as very large room sizes or reverb times can crash SuperCollider.

~delia = { CombC.ar(~catherine.ar, 1, 0.05)  }    // Compressor

~dolores = { Decimator.ar(~alicia.ar, 44100 * 1, 2) }

~dorothy = { DFM1.ar(BPF.ar(~anne.ar, 600, 0.3), 600, 0.99) }  // Resonent filter




// start combining things to make more complex sounds.

~laurie = { (SinOsc.ar([440, 442] + 1000 * LFSaw.kr(10).range(1, 0.9), 0, LFSaw.kr(15).range(1, 0)) * LFSaw.kr(1).range(SinOsc.ar(0.1).range(1, 6), 0) ).tanh}
~filter_laurie = {  (CombC.ar(~laurie.ar, 1, LFNoise0.kr(20).range(0.01, 0.1).round(0.01)) * LFSaw.kr(0.3).range(0, 2)).tanh }
~filter_laurie_2 = { GVerb.ar(DFM1.ar(~filter_laurie.ar, 500, 0.99), 10, 4) * 2 }


// synthdefs
// a synth def is a recipe for making sound with which is stored in the program memory. Like a recipe we can use it again and again to make similar sounds. We can give ourselves paramatres that we can change later. e.g. frequency/pitch, amplitude, etc.

(
SynthDef(\sn, { |out=0,amp=0.1,sustain=0.1,freq=440|
	var snd, env;

	snd = SinOsc.ar(freq, 0.5pi, 3).tanh;

	env = EnvGen.ar(Env.perc(0.01,sustain),doneAction:2);
	OffsetOut.ar(out, snd * env * amp);
}).add;

SynthDef(\sn, { |out=0,amp=0.1,sustain=0.1,freq=440|
	var snd, env;

	snd = // change here for different sound.

	env = EnvGen.ar(Env.perc(0.01,sustain),doneAction:2);
	OffsetOut.ar(out, snd * env * amp);
}).add;

)

x = Synth(\sn); // to trigger one sound we just make a synth with the same name as the pattern we've just made.
x = Synth(\sn, [\freq, 800, \sustain, 5]);


Pdef(\pattern_1,
	Pbind(
		\amp, 1,
		\instrument, \sn,
		\dur, 0.5,
		\degree, 1, //degree is analagous to 'freq' but lets us use scales instead of frequencies.
		\octave, 4,
		\out, 0,
	)
);

Pdef(\pattern_1).stop


// what about if we want to play the whole scale?
Pdef(\pattern_2,
	Pbind(
		\amp, Pseq([1, 0.5, 0.2], inf),
		\instrument, \sn,
		\dur, Pseq([0.5, 0.5, 1], inf),
		\degree, Prand([0, 5, 3], inf), // patterns let us use lists of numbers to specify parametres. Pseq tells the pattern to play through the list in order. In this case we just play through it once, but we can also use 'inf' to tell it to repeat the pattern forever.
		\out, 0,
	)
);

Pdef(\pattern_2).stop


Pdef(\pattern_2,
	Pbind(
		\amp, 1,
		\instrument, \sn,
		\dur, 0.5,
		\degree, Prand([0, 1, 2, 3, 4, 5, 6, 7], 3), // we can also use Prand to choose from the list at random.
		\octave, Prand([4, 5, 6, 7], 3),
		\out, 0,
	)
);

Pdef(\pattern_2).play


Pdef(\pattern_3,
	Pbind(
		\amp, Pwhite(0.0, 1.0),
		\instrument, \sn,
		\dur, 0.1,
		\degree, Pwhite(0, 7), // or Pwhite to choose between a range of numbers.
		\out, 0,
	)
);

Pdef(\pattern_3).stop

// try making a new pattern which uses Pseq/Prand or Pwhite to set the amplitude, and duration.


// more synth def examples

SynthDef(\dr, { |out=0,amp=0.1,sustain=0.01,freq=440, noise = 0.1, line=0.1|
	var snd, env, ctrl;  // Initial parameters, variables

	//ctrl = ;
	snd = SinOsc.ar([freq, freq + 10] * XLine.kr(1, 0.001, line), 0.5pi, 3).tanh;
	snd = snd + BrownNoise.ar(noise * XLine.kr(1, 0.001, 0.05));
	snd = BPF.ar(snd, freq + 50, 0.9);
	snd = LeakDC.ar(snd);
	env = EnvGen.ar(Env.perc(0.01,sustain),doneAction:2);
	OffsetOut.ar(out, snd * env * amp);   // Send sound out
}).add;


SynthDef(\nz, { |out=0,amp=0.1,sustain=0.01,freq=440, noise = 0.1, q = 0.5|
	var snd, env, ctrl;

	//ctrl = ;
	snd = (PinkNoise.ar(noise)).tanh;
	snd = BPF.ar(snd, freq, q);
	env = EnvGen.ar(Env.perc(0.01,sustain),doneAction:2);
	OffsetOut.ar(out, snd * env * amp);
}).add;


Pdef(\drum_pattern_1, // basic bass drum
	Pbind(
		\amp, 4,
		\instrument, \dr,
		\dur, 0.5,
		\freq, Pwhite(80, 120),
		\out, 0,
	)
);

Pdef(\drum_pattern_1).play

Pdef(\drum_pattern_2, //hi tom
	Pseq([
		Pbind(
			\amp, 4,
			\instrument, \dr,
			\dur, 0.5,
			\freq, Pwhite(80, 120, 4),
			\out, 0,
		),
		Pbind(
			\amp, Pseq([0, 2], inf),
			\instrument, \dr,
			\dur, 0.5,
			\legato, 0.1,
			//\noise, 0.9,
			\freq, Pwhite(680, 720, 4),
			//\line, 0.07,
			\out, 0,
		)
	], 2)
);

Pseq([Pdef(\drum_pattern_2), Pdef(\pattern_3)], inf).stop

Pdef(\drum_pattern_2).stop


Pdef(\noise_pattern_1, //snare
	Pbind(
		\amp, Pseq([3, 5, 4, 4, 2], inf),
		\instrument, \nz,
		\dur, Pseq([0.125, 0.25, 0.25, 0.25, 0.125], inf),
		\legato, 0.1,
		\noise, 4,
		\q, 0.99,
		\freq, Pwhite(1280, 1220),
		\out, Pseq([0, 6, 8], inf),// [0,6,8]
	)
);

Pdef(\noise_pattern_1).stop

PdefAllGui.new

// adding effects

Ndef(\a, { Out.ar(0, GVerb.ar(InFeedback.ar(6), 10, 0.1 )  )  });
Ndef(\a).stop

Ndef(\b, { Out.ar(0, CombC.ar(InFeedback.ar(8), 1, 0.1 )  )  });
Ndef(\b).stop

// mic input

~in = { SoundIn.ar(0).scope }
~in.clear

// scheduling

t = Task{

	{

		~laurie.play;

		4.wait;

		~laurie.stop;

		4.wait;

	}.loop

}

t.stop;

// recording

s.makeWindow



