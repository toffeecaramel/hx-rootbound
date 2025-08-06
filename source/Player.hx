package;

import flixel.FlxSprite;

class Player extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
        loadGraphic(AssetPaths.playerv2__png, true, 84, 53);
        final framerate = 14;
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
    }

    var floatTimer:Float = 0; //unintentional pun xD
    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        floatTimer += elapsed;
        offset.y = Math.sin(floatTimer * 2) * 4;
    }
}