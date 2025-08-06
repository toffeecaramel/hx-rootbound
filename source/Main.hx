package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		flixel.FlxSprite.defaultAntialiasing = false;
		flixel.FlxG.stage.quality = HIGH;
		addChild(new FlxGame(0, 0, Cutscene));
	}
}
