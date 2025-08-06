package;

import flixel.FlxG;
import flixel.util.FlxSignal;
import flixel.FlxBasic;

class Conductor extends FlxBasic
{
    public var bpm(default, set):Float = 120;
    public var songPosition:Float = 0;
    public var songOffset:Float = 0;

    public var beatLength:Float;
    public var crochet:Float;
    public var stepLength:Float; 

    public var onBeatHit:FlxSignal = new FlxSignal();
    public var onStepHit:FlxSignal = new FlxSignal();

    public var curBeat:Int = 0;
    public var curStep:Int = 0;

    public function new(bpm:Float = 120)
    {
        super();
        this.bpm = bpm;
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if(FlxG.sound.music != null && FlxG.sound.music.playing)
        	songPosition = FlxG.sound.music.time + songOffset;

		while (curStep < Math.floor(songPosition / stepLength))
		{
		    curStep++;
		    onStepHit.dispatch();
		}

		while (curBeat < Math.floor(songPosition / beatLength))
		{
		    curBeat++;
		    onBeatHit.dispatch();
		}
    }

    public function reset(songStartTime:Float = 0):Void
    {
        songPosition = songStartTime;
        curStep = 0;
        curBeat = 0;
    }

    public function set_bpm(newBPM:Float):Float
    {
        bpm = newBPM;
        crochet = beatLength = (60 / bpm) * 1000;
        stepLength = crochet / 4;

        return bpm;
    }
}
