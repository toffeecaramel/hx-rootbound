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

    public var gotHit:Bool = false;
    public var hitJudgement:String = '';

    public function new(x:Float, y:Float, time:Float, isLeft:Bool, length:Float)
    {
        this.isLeft = isLeft;
        this.time = time + flixel.FlxG.save.data.offset;
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
    public var heldTime:Float = 0;

    public function updateSustainVisual():Void
    {
        if (length <= 0) return;

        var remainingLength = Math.max(0, length - heldTime);
        var visualHeight:Int = getVisualHeight(remainingLength);
        var newGraphicHeight = Std.int(visualHeight / scale.y);

        if (height != newGraphicHeight)
        {
            var oldBottom = y + height * scale.y;
            makeGraphic(baseWidth, newGraphicHeight, FlxColor.WHITE);
            y = oldBottom - height * scale.y;
        }
    }
    
    function getVisualHeight(length:Float):Int
    {
        var pixelsPerMs = 0.4;
        return (length > 0) ? Std.int(length * pixelsPerMs) : baseHeight;
    }
}

class HeldNote
{
    public var note:Note;
    public var startHeldTime:Float;

    public function new(note:Note, startTime:Float)
    {
        this.note = note;
        this.startHeldTime = startTime;
    }
}