package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;

class Cutscene extends FlxState
{
	var bg:BG = new BG('default');
	var text:FlxText;
	override public function create()
	{
		add(bg);

		FlxTween.tween(FlxG.camera, {zoom: 0.8, "scroll.x": 400, "scroll.y": 100}, 3, {startDelay: 3});
	}
}