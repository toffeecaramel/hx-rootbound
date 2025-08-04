package;

import flixel.FlxG;
import Chart.NoteData;
import flixel.group.FlxGroup;

class Strums extends FlxGroup
{
    public var notes:Array<Note> = [];
    public function new(chartNotes:Array<NoteData>)
    {
        super();
        _setNotes(chartNotes);
    }

    private function _setNotes(chnotes:Array<NoteData>)
    {
        for(n in chnotes)
        {
            var note = new Note(0, 2000, n.time, n.isLeft, n.length);
            add(note);
            note.speed = n.speed;
            note.x = (n.isLeft) ? 64 : FlxG.width - note.width - 64;
            notes.push(note);
        }
    }
}