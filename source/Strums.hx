package;

import flixel.FlxSprite;
import flixel.FlxG;
import Chart.NoteData;
import flixel.group.FlxGroup;

import flixel.math.FlxMath;

class Strums extends FlxGroup
{
    public var notes:Array<Note> = [];

    public var leftStrum:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.strum__png);
    public var rightStrum:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.strum__png);
    public var lCopy:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.strum__png);
    public var rCopy:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.strum__png);

    public var lGlow:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.strumGlow__png);
    public var rGlow:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.strumGlow__png);
    public function new(chartNotes:Array<NoteData>)
    {
        super();
        _setNotes(chartNotes);

        add(leftStrum);
        add(rightStrum);

        lGlow.blend = rGlow.blend = lCopy.blend = rCopy.blend = ADD;
        add(lGlow);
        add(rGlow);

        add(lCopy);
        add(rCopy);

        lCopy.alpha = rCopy.alpha = 0.0001;
        rGlow.alpha = lGlow.alpha = 0.0001;

        final owo = 116;
        leftStrum.x = owo; 
        rightStrum.x = FlxG.width - rightStrum.width - owo;

        rightStrum.y = leftStrum.y = 64;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        final lx = leftStrum.x + leftStrum.width / 2;
        final ly = leftStrum.y + leftStrum.height / 2;

        lGlow.setPosition(lx - lGlow.width / 2, ly - lGlow.height / 2);

        final rx = rightStrum.x + rightStrum.width / 2;
        final ry = rightStrum.y + rightStrum.height / 2;

        rGlow.setPosition(rx - rGlow.width / 2, ry - lGlow.height / 2);
        lCopy.setPosition(lx - lCopy.width / 2, ly - lCopy.height / 2);
        rCopy.setPosition(rx - rCopy.width / 2, ry - rCopy.height / 2);

        lGlow.scale.x = lGlow.scale.y = FlxMath.lerp(lGlow.scale.x, 0.8, elapsed * 7);
        rGlow.scale.x = rGlow.scale.y = FlxMath.lerp(rGlow.scale.x, 0.8, elapsed * 7);

        lCopy.scale.x = lCopy.scale.y = FlxMath.lerp(lCopy.scale.x, 2.2, elapsed * 9);
        rCopy.scale.x = rCopy.scale.y = FlxMath.lerp(rCopy.scale.x, 2.2, elapsed * 9);
        lCopy.alpha = FlxMath.lerp(lCopy.alpha, 0.0001, elapsed * 6);
        rCopy.alpha = FlxMath.lerp(rCopy.alpha, 0.0001, elapsed * 6);

        rGlow.alpha = FlxMath.lerp(rGlow.alpha, 0.0001, elapsed * 6);
        lGlow.alpha = FlxMath.lerp(lGlow.alpha, 0.0001, elapsed * 6);
    }

    private function _setNotes(chnotes:Array<NoteData>)
    {
        for(n in chnotes)
        {
            var note = new Note(0, 2000, n.time, n.isLeft, n.length);
            add(note);
            note.speed = n.speed;
            note.x = (n.isLeft) ? leftStrum.x : rightStrum.x;
            notes.push(note);
        }
    }
}