package;

import flixel.FlxG;

class Credits extends flixel.FlxSubState
{
	public function new()
	{
		super();

		FlxG.sound.music.pause();

		var bg = new flixel.FlxSprite().makeGraphic(FlxG.width + 16, FlxG.height + 16, flixel.util.FlxColor.BLACK);
		bg.screenCenter();
		add(bg);

		var me = new flixel.FlxSprite().loadGraphic(AssetPaths.me__png);
		add(me);

		me.screenCenter();

		FlxG.sound.play(AssetPaths.alone__ogg);
		flixel.tweens.FlxTween.tween(me.scale, {x: 5}, 5.28, {onComplete: (_)->{
			FlxG.sound.music.play();
			close();
		}});
	}
}