package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import Note.HeldNote;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class PlayState extends FlxState
{
	var chart:Chart;
	var pStrum:Strums;
	var conductor:Conductor;
	var stats:FlxText = new FlxText();

	var judgementList:Array<{name:String, window:Int}> = [
		{name: "perfect", window: 20},
	    {name: "awesome", window: 50},
	    {name: "ok", window: 120},
	    {name: "bad", window: 199}
	];

	var colors:Map<String, FlxColor> = [
		'perfect' => 0xFFffcf3b,
		"awesome" => 0xFF3bf6b3,
		'ok' => 0xFF960fee,
		"bad" => 0xFFec0364
	];

	public var combo:Int = 0;

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

		stats.setFormat(AssetPaths.Karma_Future__otf, 32, CENTER);
		stats.text ='';
		stats.origin.y = stats.height;
		stats.textField.antiAliasType = ADVANCED;
		stats.textField.sharpness = 200;
		add(stats);

		pStrum = new Strums(chart.notes);
		add(pStrum);

		flixel.FlxG.sound.playMusic(AssetPaths.level_one__ogg);
	}

	var heldNotes:Array<HeldNote> = [];

	var ltwn:FlxTween;
	var rtwn:FlxTween;
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

		var missWindow = judgementList[judgementList.length - 1].window;

		for (note in pStrum.notes.copy())
		{
			if (!note.gotHit && (conductor.songPosition - note.time) > missWindow && note.alive)
			{
				missNote(note, note.isLeft);
				note.kill();
				pStrum.remove(note, true);
			}
		}

		if (leftKeyPressed())
            checkHit(true);
        if (rightKeyPressed())
            checkHit(false);

        if(leftKeyReleased())
        {
        	if(ltwn != null && ltwn.active)
        		ltwn.cancel();

        	ltwn = FlxTween.tween(pStrum.leftStrum.scale, {x:1,y:1}, 0.35, {ease: FlxEase.circOut});
        }
        if(rightKeyReleased())
        {
        	if(rtwn != null && rtwn.active)
        		rtwn.cancel();

        	rtwn = FlxTween.tween(pStrum.rightStrum.scale, {x:1,y:1}, 0.35, {ease: FlxEase.circOut});
        }

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
		        	if(held.note.hitJudgement == 'perfect' || held.note.hitJudgement == 'awesome')
		        	{
			        	var strCopy = (held.note.isLeft) ? pStrum.lCopy : pStrum.rCopy;
						strCopy.alpha = 1;
						strCopy.scale.set(1.5, 1.5);
						strCopy.angle += 0.8;
					}

		            held.note.heldTime = conductor.songPosition - held.note.time;
		        }
		    }
		}

		// TODO: see if its pausing correctly (can't do it right nyaw since im in school!!)
		if(FlxG.keys.justPressed.ESCAPE||FlxG.keys.justPressed.ENTER||FlxG.keys.justPressed.BACKSPACE)
			openSubState(new Pause());
	}

	function checkHit(isLeft:Bool):Void
	{
	    var currentTime = conductor.songPosition;
	    var closestNote:Note = null;
	    var smallestDiff = 99999.0;

	    //visual thing
	    var strum = (isLeft) ? pStrum.leftStrum : pStrum.rightStrum;
	    var tween = (isLeft) ? ltwn : rtwn;
	    if(tween != null && tween.active)
    		tween.cancel();

	    strum.scale.set(1.2, 1.2);

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

	    missNote(null, isLeft);
	}

	var statTwn:FlxTween;
	function hitNote(note:Note, judgement:String):Void
	{
		note.hitJudgement = judgement;
		
		if(statTwn != null && statTwn.active) statTwn.cancel();
		var glow = (note.isLeft) ? pStrum.lGlow : pStrum.rGlow;
		glow.angle = 0;
		glow.alpha = 0.75;
		glow.scale.set(1.3, 1.3);

		if(note.length <= 0)
			pStrum.remove(note, true);

		glow.color = colors.get(judgement);

		combo++;
		stats.text = '${judgement.toUpperCase()}!\n$combo';
		stats.color = colors.get(judgement);
		stats.screenCenter(X);
		stats.y += 3;
		stats.alpha = 1;
		stats.scale.set(0.9, 0.9);
		stats.origin.y = stats.height;
		statTwn = FlxTween.tween(stats, {"scale.x":1,'scale.y':1, y: pStrum.leftStrum.y}, 0.4, {ease:FlxEase.circOut,onComplete:(_)->{
			statTwn = FlxTween.tween(stats, {"scale.x": 0.6, "scale.y": 0.6, alpha: 0.0001}, 1, {ease:FlxEase.circIn, startDelay: 0.7});
		}});

	    var strCopy = (note.isLeft) ? pStrum.lCopy : pStrum.rCopy;
	    strCopy.color = stats.color;
	    if((judgement == 'perfect'||judgement == 'awesome') && note.length <= 0)
	    {
	    	strCopy.angle = 0;
	    	strCopy.alpha = 1;
	    	strCopy.scale.set(1, 1);
	    }

		note.gotHit = true;
	    //trace('Hit $judgement on note at time ${note.time}');

        if (note.length > 0)
	        heldNotes.push(new HeldNote(note, conductor.songPosition));
	}

	var lshTwn:FlxTween;
	var rshTwn:FlxTween;
	function missNote(note:Note = null, isLeft:Bool = false):Void
	{
	    //trace('Missed!');
	    var glow = (isLeft) ? pStrum.lGlow : pStrum.rGlow;
	    if(statTwn != null && statTwn.active) statTwn.cancel();
	    combo = 0;

	    if(note != null && note.alpha > 0.3)
	    	note.alpha = 0.3;

	    var twn:FlxTween = (isLeft)?lshTwn:rshTwn;
	    if(twn!=null && twn.active) twn.cancel();
	    var strum = (isLeft) ? pStrum.leftStrum : pStrum.rightStrum;
	    strum.offset.set(0, 0);
	    twn = FlxTween.shake(strum, 0.06, 0.1, XY);

		stats.text = 'MISS!!!\n$combo...';
		stats.color = 0xFF8f2c3f;
		stats.screenCenter(X);
		stats.y = pStrum.leftStrum.y;
		stats.scale.set(1, 1);
		stats.alpha = 1;
		stats.origin.y = stats.height;
		glow.color = 0xFF8f2c3f;

		statTwn = FlxTween.shake(stats, 0.06, 0.16, {onComplete:(_)->{
			statTwn = FlxTween.tween(stats, {"scale.x": 1.2, "scale.y": 0.1, alpha: 0.0001}, 1, {ease:FlxEase.bounceOut , startDelay: 0.3});
		}});
	}

	function leftKeyReleased():Bool
    	return FlxG.keys.justReleased.A || FlxG.keys.justReleased.LEFT || FlxG.keys.justReleased.Z || FlxG.keys.justReleased.K || FlxG.keys.justReleased.Q;

	function rightKeyReleased():Bool
	    return FlxG.keys.justReleased.D || FlxG.keys.justReleased.RIGHT || FlxG.keys.justReleased.X || FlxG.keys.justReleased.L || FlxG.keys.justReleased.E;

	function leftKeyPressed():Bool
	    return FlxG.keys.justPressed.A || FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.Z || FlxG.keys.justPressed.K || FlxG.keys.justPressed.Q;

	function rightKeyPressed():Bool
	    return FlxG.keys.justPressed.D || FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.X || FlxG.keys.justPressed.L || FlxG.keys.justPressed.E;

	function leftKeyDown():Bool
	    return FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT || FlxG.keys.pressed.Z || FlxG.keys.pressed.K || FlxG.keys.pressed.Q;

	function rightKeyDown():Bool
	    return FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.X || FlxG.keys.pressed.L || FlxG.keys.pressed.E;
}
