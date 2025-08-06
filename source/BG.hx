package;

import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;

using StringTools;
class BG extends FlxGroup
{
	public var objects:Map<String, FlxSprite> = [];
	public var bg:String = '';
	public var playerSpawn:FlxPoint;
	public function new(bg:String)
	{
		super();
		this.bg = bg;

		switch(bg)
		{
			default:
				var back = new FlxSprite().loadGraphic(AssetPaths.nightbg__png);
				back.scrollFactor.set(0, 0);
				add(back);
				back.screenCenter();
				objects.set('bg', back);

				var stars = new FlxBackdrop(null, XY);
				stars.loadGraphic(AssetPaths.stars__png);
				stars.scrollFactor.set(0.2, 0.2);
				stars.velocity.set(2);
				add(stars);
				objects.set('stars', stars);

				if(!bg.endsWith('-noTree'))
				{
					var tree = new FlxSprite();
					tree.frames = FlxAtlasFrames.fromSparrow(AssetPaths.tree__png, AssetPaths.tree__xml);
					tree.animation.addByPrefix('loop', 'loop0', 24, true);
					tree.animation.addByPrefix('loop-without', 'loop-without0');
					tree.animation.play('loop');
					tree.x = 670;
					add(tree);
					objects.set('tree', tree);
				}

				var ground = new FlxBackdrop(null, X);
				ground.loadGraphic(AssetPaths.ground__png);
				ground.y = 500;
				add(ground);
				objects.set('ground', ground);
		}
	}

	override public function update(elapsed)
	{
		super.update(elapsed);
	}
}