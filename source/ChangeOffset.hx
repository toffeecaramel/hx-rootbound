package;

import flixel.FlxG;
import flixel.text.FlxText;

class ChangeOffset extends flixel.FlxSubState
{
	public var text:FlxText;
	public function new(?camera:flixel.FlxCamera)
	{
		super();
		if(camera == null)
			camera = FlxG.camera;

		this.camera = camera;

		var bg = new flixel.FlxSprite().makeGraphic(FlxG.width + 32, FlxG.height + 32, flixel.util.FlxColor.BLACK);
		bg.screenCenter();
		bg.alpha = 0.7;
		add(bg);

		text = new FlxText();
		text.setFormat(null, 16, CENTER);
		text.fieldWidth = FlxG.width;
		add(text);

		var oldOffset = FlxG.save.data.offset;
		FlxG.save.data.offset = Std.int(oldOffset);
		FlxG.save.flush();

		updateText();
	}

	override public function update(elapsed)
	{
		super.update(elapsed);
		final minus = (FlxG.keys.pressed.SHIFT) ? 4 : 0;
		if(FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A)
		{
			FlxG.save.data.offset -= 5 - minus;
			FlxG.save.flush();
			updateText();
		}
		if(FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D)
		{
			FlxG.save.data.offset += 5 - minus;
			FlxG.save.flush();
			updateText();
		}

		if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.BACKSPACE)
			close();
	}

	function updateText()
	{
		text.text = 'Offset: ${FlxG.save.data.offset}\nHold SHIFT for precision.\nLeft = Earlier.\nRight = Later.';
		text.screenCenter();
	}
}