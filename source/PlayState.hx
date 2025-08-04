package;

import flixel.FlxState;
import flixel.FlxSprite;

class PlayState extends FlxState
{
	var chart:Chart;
	var pStrum:Strums;
	var conductor:Conductor;
	override public function create()
	{
		super.create();

		flixel.FlxG.sound.playMusic(AssetPaths.Inst_erect__ogg);
		conductor = new Conductor(135);
		add(conductor);

		conductor.onBeatHit.add(() -> {
			flixel.FlxG.sound.play(AssetPaths.metronome__ogg);
			trace('a');
		});

		chart = new Chart('aa');
		trace(chart.notes);

		pStrum = new Strums(chart.notes);
		add(pStrum);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		for(note in pStrum.notes)
		{
			var timeDiff = (note.time - conductor.songPosition);

			// 0 is where the receptor.y will be.!
			note.y = 0 + timeDiff * note.speed;
		}
	}
}
