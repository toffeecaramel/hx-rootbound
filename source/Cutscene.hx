package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class Cutscene extends FlxState
{
	var bg:BG = new BG('default');
	var text:FlxText;
	var arr:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.arrow__png);

	var t(default, set):String;

	var cHUD:FlxCamera = new FlxCamera();
	var cGAME:FlxCamera = new FlxCamera();

	var cutsceneIdx:Int = 0;
	var canPress:Bool = false;

	override public function create()
	{
		cHUD.bgColor = 0x00000000;
		cGAME.bgColor = 0x00000000;
		FlxG.cameras.add(cGAME, true);
		FlxG.cameras.add(cHUD, false);

		add(bg);

		text = new FlxText();
		text.setFormat(AssetPaths.Karma_Future__otf, 18, CENTER);
		text.text = '';
		text.textField.antiAliasType = ADVANCED;
		text.textField.sharpness = 400;
		text.camera = cHUD;
		add(text);

		arr.camera = cHUD;
		arr.alpha = 0.3;
		add(arr);
		FlxTween.tween(arr, {alpha: 0.8}, 1, {ease: FlxEase.quadInOut, type: PINGPONG});

		// didnt work :/
		// FlxG.camera.fade(FlxColor.BLACK, 3, true, () -> proceed());
		// soo an alternative we go...!
		var a = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(a);
		a.camera = cHUD;
		FlxTween.tween(a, {alpha: 0}, 3, {
			onComplete: (_) ->
			{
				a.destroy();
				proceed();
			}
		});

		FlxG.sound.playMusic(AssetPaths.cutscene__ogg, 0);
		FlxG.sound.music.fadeIn(3, 0, 1);
	}

	override public function update(elapsed)
	{
		super.update(elapsed);

		arr.visible = canPress;
		arr.x = text.x + text.width + 8;
		arr.y = text.y + text.height / 2 - arr.height / 2;

		if ((FlxG.keys.justPressed.Z || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.BACKSPACE
			|| FlxG.keys.justPressed.ESCAPE)
			&& canPress)
		{
			FlxG.sound.play(AssetPaths.enter__ogg, 0.7);
			cutsceneIdx++;
			proceed();
		}
	}

	function proceed()
	{
		switch (cutsceneIdx)
		{
			case 0:
				t = 'Once upon a time, there was a world.';
				canPress = true;
			case 1:
				t = 'A world in which many thought had hope.';
			case 2:
				t = 'Many thought there was a chance, but...';
			case 3:
				canPress = false;
				FlxTween.tween(text, {alpha: 0.0001}, 0.4, {
					onComplete: (_) ->
					{
						FlxTween.tween(cGAME, {"scroll.y": 170, "scroll.x": 110, zoom: 0.85}, 4, {
							ease: FlxEase.quadInOut,
							onComplete: (_) ->
							{
								t = 'It got entirely corrupted.';
								canPress = true;
							}
						});
					}
				});
			case 4:
				t = 'And all the hope that was left...';
			case 5:
				t = 'All the people who believed...';
			case 6:
				t = 'Are now gone.';
			case 7:
				t = 'But... A new spark of hope appears.';
			case 8:
				canPress = false;
				FlxTween.tween(text, {alpha: 0.0001}, 0.4);
				FlxTween.tween(cGAME, {zoom: 1.4, "scroll.x": 590, "scroll.y": 10}, 3, {
					ease: FlxEase.cubeInOut,
					onComplete: (_) ->
					{
						t = 'Heck, maybe not all the hope\nis lost after all!';
						canPress = true;
					}
				});
			case 9:
				t = 'Will this world finally see\nitself shine again?';
			case 10:
				canPress = false;
				var camTween = FlxTween.tween(cGAME, {zoom: 2}, 3.48, {ease: FlxEase.sineIn});
				new FlxTimer().start(1, (_) ->
				{
					var b = new FlxSprite(835, 145).loadGraphic(AssetPaths.reveal__png);
					b.scale.set(0.8, 0.8);
					add(b);
					b.blend = ADD;
					b.alpha = 0.0001;
					// FlxTween.tween(b, {"scale.x": 1.2, "scale.y": 1.2}, 0.4, {ease: FlxEase.quadInOut, type: PINGPONG});
					FlxG.sound.play(AssetPaths.riser__ogg, 0.8);
					FlxTween.tween(b, {alpha: 1}, 2.48, {
						onComplete: (_) ->
						{
							b.destroy();
							bg.objects.get('tree').animation.play('loop-without', true);
							FlxTween.tween(FlxG.sound.music, {pitch: 0}, 0.8, {onComplete: (_) -> FlxG.sound.music.stop()});
							if (camTween != null && camTween.active)
								camTween.cancel();
							cGAME.zoom = 1.35;
						}
					});
				});
		}
	}

	var ew:FlxTween;

	function set_t(t:String):String
	{
		this.t = t;
		if (ew != null && ew.active)
			ew.cancel();
		text.alpha = 1;
		text.text = t;
		text.screenCenter(X);
		text.y = FlxG.height - text.height - 8;
		ew = FlxTween.tween(text, {y: text.y - 8}, 0.2, {ease: FlxEase.circOut});
		return t;
	}
}