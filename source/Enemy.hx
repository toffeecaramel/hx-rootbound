//enemy or sum shit
package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Enemy extends FlxSprite
{
    public var speed:Float = 690;
    public var hasBeenHit:Bool = false;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        frames = FlxAtlasFrames.fromSparrow(AssetPaths.idkenemy__png, AssetPaths.idkenemy__xml);

        animation.addByPrefix('walk', 'walkcycle0', 24, true);
        animation.addByPrefix('transform', 'transform0', 24, false);
        animation.play("walk");
    }

    var ok:Bool = false;
    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        x -= speed * elapsed;
        //this.visible = this.active = this.isOnScreen();
        if(hasBeenHit)
        {
        	if(!ok)
        	{
        		ok = true;
        		animation.play('transform', true);
        		//flixel.tweens.FlxTween.tween(this, {y: -600, alpha: 0}, 1, {ease: flixel.tweens.FlxEase.circIn, onComplete: (_)-> this.kill()});
        	}
        }
    }
}
