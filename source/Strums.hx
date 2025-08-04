package;

import flixel.FlxSprite;
import flixel.FlxG;
import Chart.NoteData;
import flixel.group.FlxGroup;

class Strums extends FlxGroup
{
    public var notes:Array<Note> = [];

    public var leftStrum:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.strum__png);
    public var rightStrum:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.strum__png);
    public function new(chartNotes:Array<NoteData>)
    {
        super();
        _setNotes(chartNotes);

        add(leftStrum);
        add(rightStrum);

        leftStrum.x = 64; 
        rightStrum.x = FlxG.width - rightStrum.width - 64;

        rightStrum.y = leftStrum.y = 64;
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