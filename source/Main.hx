package;

import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;

class Main extends Sprite
{
	public function new()
	{
		super();
		flixel.FlxSprite.defaultAntialiasing = false;
		FlxG.stage.quality = HIGH;

		addChild(new FlxGame(0, 0, StateYouSeeWhenPlayingForTheFirstTime));
		FlxG.mouse.visible = false;
		FlxG.save.bind('Rootbound');
		FlxG.save.flush();

		// for debug purposes
		//PlayState.nextLevel = 'level-four';
		//FlxG.switchState(()-> new PlayState());
	}
}
