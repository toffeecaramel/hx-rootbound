package;

import flixel.FlxSprite;

class Player extends FlxSprite
{
    public var glow:FlxSprite;
    public var float:Bool = true;
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        loadGraphic(AssetPaths.playerv2__png, true, 84, 53);
        final framerate = 10;
        animation.add('sad', [0], framerate, true);
        animation.add('unhappy', [1], framerate, true);
        animation.add('happy', [2], framerate, true);
        animation.add('happier', [3], framerate, true);
        animation.add('purify', [4, 5, 6], framerate, false);
        animation.add('miss', [7], framerate, false);
        animation.add('sleep', [8, 9], framerate, true);
        animation.add('wake', [10, 11, 12, 13, 13, 13, 13, 13, 14, 15, 16, 17], framerate, false);
        animation.add('fly', [18, 19, 20], framerate, false);
        animation.add('phew', [21], framerate, false);

        glow = new FlxSprite(x, y);
        // todo: glow have its own graphic.
        glow.loadGraphic(AssetPaths.playerv2__png, true, 84, 53);
        glow.setGraphicSize(Std.int(width * 1.2), Std.int(height * 1.2));
        glow.color = 0xFF4FFFC4;
        glow.alpha = 0.5;
        glow.blend = ADD;
    }

    var floatTimer:Float = 0; //unintentional pun xD
    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        glow.x = this.x;
        glow.y = this.y;
        glow.animation.frameIndex = this.animation.frameIndex;
        glow.visible = this.visible;
        glow.offset.y = offset.y;
        glow.scale.set(
            1.2 + Math.sin(floatTimer * 2) * 0.05,
            1.2 + Math.sin(floatTimer * 2) * 0.05
        );
        glow.alpha = 0.4 + Math.sin(floatTimer * 2) * 0.2;
        glow.camera = this.camera;

        if(float)
        {
            floatTimer += elapsed;
            
            // note, speed is the firstvalue and the amplitude is the second valuee
            offset.y = Math.sin(floatTimer * 10) * 15;
        }
    }
}