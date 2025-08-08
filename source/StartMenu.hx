package;

import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxColor;

class StartMenu extends FlxState
{
    // owo self note: settings might not be added on time, so I'll stick out with freeplay.
    final menuItems:Array<String> = ['Start!', 'Freeplay', 'Credits'#if !html5,'Exit'#end];
    var texts:Array<FlxText> = [];
    public var selectedIndex:Int = 0;

    override public function create()
    {
        super.create();
        for(i in 0...menuItems.length)
        {
            final text = new FlxText();
            text.setFormat(AssetPaths.Karma_Future__otf, 44, CENTER);
            text.text = menuItems[i];
			text.screenCenter();
			text.textField.antiAliasType = ADVANCED;
			text.textField.sharpness = 400;
            add(text);
            texts.push(text);
            text.y += 56 * i;
        }

        updateSelection();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W)
		{
			selectedIndex = (selectedIndex + menuItems.length - 1) % menuItems.length;
			updateSelection();
		}
		else if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S)
		{
			selectedIndex = (selectedIndex + 1) % menuItems.length;
			updateSelection();
		}
        else if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
        {
            switch(menuItems[selectedIndex].toLowerCase())
            {
                case 'start!': PlayState.nextLevel = 'level-one';
                FlxG.switchState(()-> new PlayState());
            }
        }
    }

    private function updateSelection():Void
	{
		for (i in 0...texts.length)
		{
			texts[i].color = (i == selectedIndex) ? 0xff00ffa6 : FlxColor.WHITE;
			texts[i].scale.set((i == selectedIndex) ? 1.2 : 1.0, (i == selectedIndex) ? 1.2 : 1.0);
		}
	}
}