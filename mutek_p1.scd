//MIDIClient is a SuperCollder class that can provide access to the MIDI systems in your computer. It obtains a list of devices including MIDI sources and destinations

//To run a line of code in SuperCollider put you cursor on the right line and hit [CMD] + RTN (mac) OR [CTRL] + RTN (windows and linux). Run the line of code below.

//Whenever we make a change in SuperCollider code, we have to execute the line of code again.

//Everything in brown (on my screen) or with '//' before it is a comment on the code.

MIDIClient.init

MIDIClient.destinations

/*After running this code, you should see something appear in the 'Post Window'

MIDI Sources:
	MIDIEndPoint("IAC Driver", "IAC Bus 1")
MIDI Destinations:
	MIDIEndPoint("IAC Driver", "IAC Bus 1")

MIDI Sources are devices that SuperCollider can receive MIDI from.
MIDI Destinations are devices that SuperCollider can send MIDI to

In most cases, each physical MIDI connection (pair of in/out cables on the MIDI interface) has one MIDIEndPoint object to represent it in the client.

So at this point we can see what are device is physically connected to, but no connections have been made between SuperCollder and the MIDI port itself

To send MIDI OUT of SuperCollder and to our synthesizer we create a MIDIOut instance. We can have multipled MIDIOut objects to send MIDI to different physical devices.

——Warning from SC developers
Many users have reported timing issues with MIDIOut. When the CPU is busy, especially during graphics updates, outgoing MIDI messages may be delayed. Use with caution in a performance situation. (LOL)

*/

~mysynth = MIDIOut(0);

//The '0' in this code refers to a MIDI devices index on the list of destinations.



//We can now start sending MIDI data to our synth.

~mysynth.noteOn(0, 60, 60);

//The code above will send out a note on MIDI channel 1 at middle C (60) at a velocity of 60.
//i.e. noteOn(midichannel, midinote, velocity);
//Note that MIDI channel on your synth is SuperCollder n + 1.
//Try changing the values and seeing what happens. I have included a chart which maps MIDI note values to pitches for your reference. MIDI note and velocity values are an integer between 0–127.
//NB if you can't hear anything, check what channel your synth is on and adjust the code (or your synth settings).
//You can turn off a note below

~mysynth.noteOff(0, 60, 60);

//Turn off all notes on a channel
~mysynth.allNotesOff(0);

//You can set a latency value for the message which adds a delay to the message being send. Default 200ms. This can be used to sychronise multiple devices.

~mysynth.latency = 1; //latency is 1 second

//Spend some time droning with you synth and turning notes on and off. What effects can you create? What is frustrating/opportune?

//We can iterate through an array of note number to create a chord.

(
[42, 48, 56, 63, 70, 79].do{
	arg nn;
	~mysynth.noteOn(0, nn, 25);
}
)

//Using a Task or Routine, we can create pauses between the notes to sequence them.

(
Routine({

		[42, 48, 56, 63, 70, 79].do{
			arg nn;
			~mysynth.noteOn(0, nn, 25);
			1.wait
		}
}).play

)

//Can you hear how the notes stay held? We can turn them off like this
//Here the Array is being randomly shuffled, check the Array help file to see what other methods can be used with arrays.
(
Routine({

		[42, 48, 56, 63, 70, 79].scramble.do{
			arg nn;
			~mysynth.noteOff(0, nn, 25);
			1.wait
		}
}).play

)

//Looking at the above, can you create a routine that plays the next note after the other one has stopped.

//Below we can see that if we place a {}.loop around the contents of the Routine it will run indefinitely
(
r = Routine({
	{
		[42, 48, 56, 63, 70, 79].scramble.do{
			arg nn;
			~mysynth.noteOn(0, nn, 25);
			0.25.wait
		};

		[42, 48, 56, 63, 70, 79].do{
			arg nn;
			~mysynth.noteOff(0, nn, 25);
			0.25.wait
	}}.loop;

}).play

)

//Stop the routine
r.stop

//Hmmmmmm if we stop the Routine some noteOff messages never reach the synth meaning that the note will keep playing FOREVER! We might need to use the all notes off message

~mysynth.allNotesOff(0);

//Sometimes this does not work—the synth you are using needs to be programmed to receive this message. Instead we can send something like this..

(0..127).do{arg n; ~mysynth.noteOff(0, n)};

//We can programme SuperCollider to turn everything off automatically using the CmdPeriod Class. Doesn't work in my version of SuperCollder tho..

CmdPeriod.add({(0..127).do{arg n; ~mysynth.noteOff(0, n)}});

//Control change messages are generated when you turn a knob or a fader. Some controller numbers do certain things about the box. Channel 7 is volume, let's try it out.
//Similar syntax to note on control(channelnumber, controller number, controller value)
~mysynth.noteOn(0, 56, 20)
~mysynth.control(0, 7, 127)

//You may or may not hear a change depending on the synthesizer you are using. They may not use the standard setup.

//What if you want to change something else?
//You can setup control change values as you normally would in your DAW.
//You can look up for a chart of all the MIDI control for your specific hardware.
//If you can't find a chart, use the code in the gather_ur_midi.scd file—remember you will need to switch the direction of your MIDI cable from OUT–IN to IN–OUT

//Find some CC you can connect to!
//Everytime you run the code below it will send a new random control value to your synth.

~mysynth.control(0, 7, rrand(0, 127))

//Try this example, it will

(
r = Routine({
	{
		//var note = rrand(60, 70);

		~mysynth.noteOn(0, 60, 60);
		(0, 15..127).do{ //how could you randomise this?
			arg val;
			~mysynth.control(0, 20, val);
			0.25.wait
		};
		//~mysynth.noteOff(0, note, 60);

	}.loop;


}).play

)

//How could you set a specific series of notes?

r.stop

//This approach doesn't work great for live coding, to manual. You can use patterns to automate this process.
//Sytax is hard and not very good for editing in real time...

//Sooooo... let's do some patterns..!







