package;

import flixel.FlxState;
import flixel.FlxSprite;

class PlayState extends FlxState
{
	var chart:Chart;
	override public function create()
	{
		super.create();

		flixel.FlxG.sound.playMusic(AssetPaths.Inst_erect__ogg);
		var conductor = new Conductor(135);
		add(conductor);

		conductor.onBeatHit.add(() -> {
			flixel.FlxG.sound.play(AssetPaths.metronome__ogg);
			trace('a');
		});

		chart = new Chart('aa');
		trace(chart.notes);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
