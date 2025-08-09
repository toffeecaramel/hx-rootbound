package;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.FlxState;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxCamera;

class Pause extends FlxSubState
{
	public var options:Array<String> = ["Resume", "Restart","Restart Campaign", "Change Offset", "Exit"];
	public var selectedIndex:Int = 0;
	private var optionTexts:Array<FlxText> = [];
	private var wasCamVisible:Bool = true;
	private var applyChanges:FlxText;

	public function new(camera:FlxCamera)
	{
		super();
		this.camera = camera;
		wasCamVisible = camera.visible;

		if(!wasCamVisible)
			camera.visible = true;
		FlxG.sound.music.pause();
        var bg = new FlxSprite().makeGraphic(FlxG.width + 64, FlxG.height + 64, FlxColor.BLACK);
        bg.alpha = 0.5;
        bg.screenCenter();
        add(bg);

		var spacing = 40;
		for (i in 0...options.length)
		{
			var txt = new FlxText(0, 150 + i * spacing, FlxG.width, options[i]);
			txt.setFormat(AssetPaths.Karma_Future__otf, 32, FlxColor.WHITE, CENTER);
			txt.screenCenter(X);
			txt.textField.antiAliasType = ADVANCED;
			txt.textField.sharpness = 400;
			optionTexts.push(txt);
			add(txt);
		}

		applyChanges = new FlxText();
		applyChanges.setFormat(null, 16, CENTER);
		applyChanges.text = 'Restart to apply changes.';
		applyChanges.screenCenter(X);
		add(applyChanges);
		applyChanges.y = FlxG.height - applyChanges.height - 16;
		applyChanges.alpha = 0.8;
		applyChanges.visible = false;
		updateSelection();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W)
		{
			selectedIndex = (selectedIndex + options.length - 1) % options.length;
			updateSelection();
		}
		else if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S)
		{
			selectedIndex = (selectedIndex + 1) % options.length;
			updateSelection();
		}
        else if(FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE){
			this.camera.visible = wasCamVisible;
			close();
			FlxG.sound.music.play();
		}
		else if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
		{
			switch(options[selectedIndex].toLowerCase())
            {
                case 'resume':
                	this.camera.visible = wasCamVisible;
                	close();
                	FlxG.sound.music.play();
                case 'restart': FlxG.resetState(); close();
                case 'restart campaign': PlayState.nextLevel = 'level-one'; FlxG.resetState(); close(); PlayState.curSong = 0;
                case 'change offset': openSubState(new ChangeOffset(this.camera)); optionTexts[1].color = FlxColor.RED; optionTexts[1].ID = 99; applyChanges.visible = true;
                case 'exit': FlxG.switchState(()-> new StateYouSeeWhenPlayingForTheFirstTime());

            }
		}
	}

	private function updateSelection():Void
	{
		for (i in 0...optionTexts.length)
		{
			optionTexts[i].color = (i == selectedIndex && optionTexts[i].ID != 99) ? 0xFF3bf6b3 : (optionTexts[i].ID == 99 || (i == selectedIndex && optionTexts[i].ID == 99)) ? FlxColor.RED : FlxColor.WHITE;
			optionTexts[i].scale.set((i == selectedIndex) ? 1.2 : 1.0, (i == selectedIndex) ? 1.2 : 1.0);
		}
	}
}
