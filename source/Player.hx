package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Player extends FlxSprite
{
    public var float:Bool = true;
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        frames = FlxAtlasFrames.fromSparrow(AssetPaths.playerv2__png, AssetPaths.playerv2__xml);
        animation.addByPrefix('sad', 'idle-sad', 24, true);
        animation.addByPrefix('unhappy', 'idle-unhappy0', 24, true);
        animation.addByPrefix('happy', 'idle-happy0', 24, true);
        animation.addByPrefix('happier', 'idle-happier0', 24, true);
        animation.addByPrefix('purify', 'purify0', 24, false);
        animation.addByPrefix('miss', 'miss0', 24, false);
        animation.addByPrefix('sleep', 'eepy-loop0', 24, true);
        animation.addByPrefix('wingsgrow', 'wingsgrow0', 24, false);
        animation.addByPrefix('notice', 'wakey0', 24, false);
        animation.addByPrefix('fly', 'scream0', 24, true);
        animation.addByPrefix('phew', 'phew0', 24, false);
        animation.addByPrefix('concentrate1', 'concentrate10', 24, false);
        animation.addByPrefix('concentrate2', 'concentrate20', 24, false);
        animation.addByPrefix('haha', 'haha0', 24, false);
        animation.addByPrefix('idle-soqpica', 'idle-foda', 24, false);
        animation.addByPrefix('hit-1', 'hit-20', 24, false);
        animation.addByPrefix('hit-2', 'hit-10', 24, false);
        animation.addByPrefix('fly-concentrate', 'fly-concentrate0', 24, true);
    }

    var floatTimer:Float = 0; //unintentional pun xD
    public var amplitude:Float = 11;
    public var speed:Float = 6;
    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if(float)
        {
            floatTimer += elapsed;
            
            // note, speed is the firstvalue and the amplitude is the second valuee
            offset.y = Math.sin(floatTimer * speed) * amplitude;
        }
    }
}