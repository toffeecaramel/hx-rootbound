package;

import flixel.FlxG;
import flixel.FlxState;

class StateYouSeeWhenPlayingForTheFirstTime extends FlxState
{
	private var allowPress:Bool = false;
	private var totalBeats:Int = 0;
	private var cumulativeOffset:Float = 0;
	private var averageOffset:Float = 0;
	private var conductor:Conductor;
	private var squareGraphic:flixel.FlxSprite;

	var subtitles:flixel.text.FlxText;
	var bg:flixel.FlxSprite;
	override public function create()
	{
		super.create();
		FlxG.sound.playMusic(AssetPaths.menu__ogg);
		if(FlxG.save.data.offset != null)FlxG.switchState(()-> new StartMenu());

		conductor = new Conductor(150);
		conductor.onBeatHit.add(()->{
			if(conductor.curBeat >= 32 && conductor.curBeat < 64)
			{
				allowPress = true;
				FlxG.camera.zoom += 0.02;
				subtitles.text = '(Press on the BEAT!)\nOffset: $averageOffset';
			}
			else
				allowPress = false;

			switch(conductor.curBeat)
			{
				case 8: subtitles.text = 'Before we can continue,\nwe must setup your OFFSET.';
				case 16: subtitles.text = 'Dont worry! ^^\nAll you gotta do is press ANY key on the beat!';
				case 24: subtitles.text = 'Ready?';
				case 28: subtitles.text = '3';
				case 29: subtitles.text = '2';
				case 30: subtitles.text = '1';
				case 31: subtitles.text = 'GO!';
				case 32: 
				subtitles.color = flixel.util.FlxColor.GRAY;
				subtitles.text = '(Press on the BEAT!)';
				case 64:
					FlxG.save.data.offset = averageOffset;
					trace(FlxG.save.data.offset);
					FlxG.save.flush();
					flixel.tweens.FlxTween.tween(FlxG.camera.scroll, {y: -700}, conductor.crochet / 1000 * 2, {ease: flixel.tweens.FlxEase.circIn, onComplete: (_)-> FlxG.switchState(()-> new StartMenu())});
			}
		});
		add(conductor);

		bg = new flixel.FlxSprite().loadGraphic(AssetPaths.menuBG__png);
		add(bg);
		bg.flipY = true;
		bg.alpha = 0.0001;
		flixel.tweens.FlxTween.tween(bg, {alpha: 1}, 2);

		squareGraphic = new flixel.FlxSprite().loadGraphic(AssetPaths.strumGlow__png);
		squareGraphic.blend = ADD;
		squareGraphic.alpha = 0.0001;
		add(squareGraphic);

		subtitles = new flixel.text.FlxText();
		subtitles.setFormat(null, 16, CENTER);
		subtitles.blend = ADD;
		add(subtitles);
		subtitles.alpha = 0.0001;
		subtitles.text = 'Hello there!';
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (allowPress && FlxG.keys.justPressed.ANY)
			calculateOffset();

		squareGraphic.scale.x = squareGraphic.scale.y = flixel.math.FlxMath.lerp(squareGraphic.scale.x, 2, elapsed * 10);
		squareGraphic.alpha = flixel.math.FlxMath.lerp(squareGraphic.alpha, 0.0001, elapsed * 5);
		FlxG.camera.zoom = flixel.math.FlxMath.lerp(FlxG.camera.zoom, 1, elapsed * 12);
		subtitles.alpha = bg.alpha - 0.3;
		subtitles.x = flixel.math.FlxMath.lerp(subtitles.x, FlxG.width / 2 - subtitles.width / 2, elapsed * 32);
		subtitles.y = flixel.math.FlxMath.lerp(subtitles.y, FlxG.height / 2 - subtitles.height / 2, elapsed * 32);
	}

	function calculateOffset():Void
	{
		totalBeats++;

		final currentTime = conductor.songPosition;
		final beatLength = 60000 / conductor.bpm;
		final nearestBeatTime = Math.round(currentTime / beatLength) * beatLength;
		var offset = currentTime - nearestBeatTime;

		if (offset > beatLength / 2) offset -= beatLength;
		else if (offset < -beatLength / 2) offset += beatLength;

		cumulativeOffset += offset;
		averageOffset = cumulativeOffset / totalBeats;

		trace("Offset: " + offset + "\nCumulative Offset: " + cumulativeOffset + "\nAverage Offset: " + averageOffset);
		squareGraphic.setPosition(FlxG.random.int(0, 550), FlxG.random.int(0, 400));
		squareGraphic.alpha = 1;
		squareGraphic.scale.set(0.2, 0.2);
	}
}