package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import Note.HeldNote;

class PlayState extends FlxState
{
	var chart:Chart;
	var pStrum:Strums;
	var conductor:Conductor;

	var judgementList:Array<{name:String, window:Int}> = [
		{name: "perfect", window: 10},
	    {name: "awesome", window: 45},
	    {name: "ok", window: 90},
	    {name: "bad", window: 160}
	];

	override public function create()
	{
		super.create();

		chart = new Chart('level-one');

		trace(chart.chartData.bpm);
		conductor = new Conductor(chart.chartData.bpm);
		add(conductor);

		conductor.onBeatHit.add(() -> {
			//flixel.FlxG.sound.play(AssetPaths.metronome__ogg);
			//trace('a');
		});

		//trace(chart.notes);

		pStrum = new Strums(chart.notes);
		add(pStrum);

		flixel.FlxG.sound.playMusic(AssetPaths.level_one__ogg);
	}

	var heldNotes:Array<HeldNote> = [];

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		//TODO: Note activity/visibility when offscreen
		for(note in pStrum.notes)
		{
			var timeDiff = (note.time - conductor.songPosition);
			note.y = (!note.gotHit) ? (((note.isLeft) ? pStrum.leftStrum.y : pStrum.rightStrum.y) + timeDiff * note.speed) : ((note.isLeft) ? pStrum.leftStrum.y : pStrum.rightStrum.y);
			note.x = (note.isLeft) ? pStrum.leftStrum.x : pStrum.rightStrum.x;
			note.visible = note.active = note.isOnScreen();
		}

		if (leftKeyPressed())
            checkHit(true);
        if (rightKeyPressed())
            checkHit(false);

       	for (held in heldNotes.copy())
		{
		    var noteEnd = held.note.time + held.note.length;
		    if (conductor.songPosition >= noteEnd)
		    {
		        //trace('gg from ${held.note.time} to $noteEnd');
		        heldNotes.remove(held);
		        pStrum.remove(held.note, true);
		    }
		    else
		    {
		        var keyHeld = held.note.isLeft ? leftKeyDown() : rightKeyDown();
		        if (!keyHeld)
		        {
		            //trace('MISSED TOO EARLY RELEASED IDK');
		            heldNotes.remove(held);
		            pStrum.remove(held.note, true);
		        }
		        else
		        {
		            held.note.heldTime = conductor.songPosition - held.note.time;
		        }
		    }
		}
	}

	function checkHit(isLeft:Bool):Void
	{
	    var currentTime = conductor.songPosition;
	    var closestNote:Note = null;
	    var smallestDiff = 99999.0;

	    for (note in pStrum.notes)
	    {
	        if (note.isLeft != isLeft) continue;

	        var diff = Math.abs(note.time - currentTime);
	        if (diff < smallestDiff)
	        {
	            smallestDiff = diff;
	            closestNote = note;
	        }
	    }

	    if (closestNote == null)
	        return;

	    for (entry in judgementList)
	    {
	        if (smallestDiff <= entry.window)
	        {
	            hitNote(closestNote, entry.name);
	            return;
	        }
	    }

	    missNote();
	}

	function hitNote(note:Note, judgement:String):Void
	{
		if(note.length <= 0) {
			var glow = (note.isLeft) ? pStrum.lGlow : pStrum.rGlow;
			glow.alpha = 0.75;
			glow.scale.set(1.6, 1.6);
			pStrum.remove(note, true);
		}
		note.gotHit = true;
	    //trace('Hit $judgement on note at time ${note.time}');

        if (note.length > 0)
	    {
	        heldNotes.push(new HeldNote(note, conductor.songPosition));
	    }
	}

	function missNote(note:Note = null):Void
	{
	    trace('Missed!');

	    if(note != null && note.alpha > 0.3)
	    	note.alpha = 0.3;
	}

	function leftKeyPressed():Bool
	    return FlxG.keys.justPressed.A || FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.Z || FlxG.keys.justPressed.K;

	function rightKeyPressed():Bool
	    return FlxG.keys.justPressed.D || FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.X || FlxG.keys.justPressed.L;

	function leftKeyDown():Bool
	    return FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT || FlxG.keys.pressed.Z || FlxG.keys.pressed.K;

	function rightKeyDown():Bool
	    return FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.X || FlxG.keys.pressed.L;
}
