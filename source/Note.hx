package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Note extends FlxSprite
{
    public var length:Float = 0;
    public var isLeft:Bool = false;
    public var time:Float = 0;
    public var speed:Float = 0.4;

    var baseWidth:Int = 64;
    var baseHeight:Int = 64;

    public function new(x:Float, y:Float, time:Float, isLeft:Bool, length:Float)
    {
        this.isLeft = isLeft;
        this.time = time;
        this.length = length;

        super(x, y);

        makeGraphic(baseWidth, baseHeight, FlxColor.WHITE);
        updateSustainVisual();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        updateSustainVisual();
    }

    function updateSustainVisual():Void
    {
        final visualHeight:Int = getVisualHeight(length, speed);

        if (height != visualHeight)
            setGraphicSize(baseWidth, visualHeight);
    }

    function getVisualHeight(length:Float, speed:Float):Int
    {
        // thingy: how many pixels per millisecond * speed
        var pixelsPerMs = 0.2;
        return (length > 0) ? Std.int(baseHeight + (length * speed * pixelsPerMs)) : baseHeight;
    }
}
