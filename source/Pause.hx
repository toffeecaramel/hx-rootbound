package;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.FlxState;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Pause extends FlxSubState
{
	public var options:Array<String> = ["Resume", "Restart", "Exit"];
	public var selectedIndex:Int = 0;
	private var optionTexts:Array<FlxText> = [];

	public function new()
	{
		super();
        var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0.5;
        add(bg);

		var spacing = 40;
		for (i in 0...options.length)
		{
			var txt = new FlxText(0, 150 + i * spacing, FlxG.width, options[i]);
			txt.setFormat(null, 32, FlxColor.WHITE, "center");
			txt.screenCenter(X);
			optionTexts.push(txt);
			add(txt);
		}
		updateSelection();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.UP)
		{
			selectedIndex = (selectedIndex + options.length - 1) % options.length;
			updateSelection();
		}
		else if (FlxG.keys.justPressed.DOWN)
		{
			selectedIndex = (selectedIndex + 1) % options.length;
			updateSelection();
		}
        else if(FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE) close();
		else if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
		{
			switch(options[selectedIndex].toLowerCase())
            {
                case 'resume': close();
                case 'restart': FlxG.resetState(); close();

            }
		}
	}

	private function updateSelection():Void
	{
		for (i in 0...optionTexts.length)
		{
			optionTexts[i].color = (i == selectedIndex) ? 0xFF3bf6b3 : FlxColor.WHITE;
			optionTexts[i].scale.set((i == selectedIndex) ? 1.2 : 1.0, (i == selectedIndex) ? 1.2 : 1.0);
		}
	}
}
