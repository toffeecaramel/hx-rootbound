package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSort;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

import Chart.NoteData;

// won't ever be user friendly (unless I decide to make a full game)
// need this done asap just so I can make the charts.

class ChartEditor extends FlxState
{
    var conductor:Conductor;
    var chart:Chart;
    var notes:FlxGroup;

    var snapDivisions:Array<Int> = [1, 2, 4, 8, 16];
    var currentSnapIndex:Int = 2;
    var holdLine:FlxSprite;
    var lastPlacedNote:Note = null;
    var previewNote:Note;
    var previewLane:Bool = true;

    final level:String = 'testLevel';

    override public function create():Void
    {
        super.create();

        conductor = new Conductor(135);
        add(conductor);

        chart = new Chart(level);
        notes = new FlxGroup();
        add(notes);

        for (noteData in chart.notes)
        {
            var note = new Note(noteData.isLeft ? 200 : 400, getNoteY(noteData.time), noteData.time, noteData.isLeft, noteData.length);
            notes.add(note);
        }

        var hitLine = new FlxSprite(0, 300).makeGraphic(FlxG.width, 2, FlxColor.RED);
        add(hitLine);

        previewNote = new Note(0, 0, 0, true, 0);
        previewNote.alpha = 0.5;
        notes.add(previewNote);

        holdLine = new FlxSprite().makeGraphic(4, 1, FlxColor.WHITE);
        holdLine.visible = false;
        add(holdLine);

        FlxG.sound.playMusic(AssetPaths.Inst_erect__ogg);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        for (note in notes.members)
        {
            var n = cast(note, Note);
            n.scale.set(0.7, 0.7);
            n.y = getNoteY(n.time);
        }
        
        if (FlxG.keys.justPressed.SPACE)
            (FlxG.sound.music.playing) ? FlxG.sound.music.pause() : FlxG.sound.music.play();

        var step:Float = 800; // milliseconds
        if (FlxG.keys.justPressed.LEFT)
        {
            var newTime = Math.max(FlxG.sound.music.time - step, 0);
            FlxG.sound.music.time = newTime;
            conductor.reset(newTime);
        }
        if (FlxG.keys.justPressed.RIGHT)
        {
            var newTime = Math.min(FlxG.sound.music.time + step, FlxG.sound.music.length);
            FlxG.sound.music.time = newTime;
            conductor.reset(newTime);
        }
        
        var snappedTime = snapTime(conductor.songPosition);
                
        if (FlxG.keys.justPressed.A) {
            previewLane = true;        
            placeNote(true, snappedTime);
        }
        if (FlxG.keys.justPressed.D) {
            previewLane = false;
            placeNote(false, snappedTime);
        }

        if (FlxG.keys.justPressed.DELETE || FlxG.keys.justPressed.BACKSPACE)
        {
            if (lastPlacedNote != null)
            {
                notes.remove(lastPlacedNote, true);
                chart.notes.pop();

                //trace('Deleted last placed note');
                lastPlacedNote = null;
            }
        }

        if (FlxG.keys.justPressed.Q)
        {
            currentSnapIndex = (currentSnapIndex + snapDivisions.length - 1) % snapDivisions.length;
            trace('Snap: 1/${snapDivisions[currentSnapIndex]}');
        }
        if (FlxG.keys.justPressed.E)
        {
            currentSnapIndex = (currentSnapIndex + 1) % snapDivisions.length;
            trace('Snap: 1/${snapDivisions[currentSnapIndex]}');
        }

        if (lastPlacedNote != null)
        {
            var noteData = chart.notes[chart.notes.length - 1];
            if (FlxG.keys.pressed.UP)
            {
                lastPlacedNote.length += 50;
                noteData.length = lastPlacedNote.length;
            }
            if (FlxG.keys.pressed.DOWN)
            {
                lastPlacedNote.length = Math.max(0, lastPlacedNote.length - 50);
                noteData.length = lastPlacedNote.length;
            }
        }

        previewNote.setPosition(previewLane ? 200 : 400, getNoteY(snappedTime));
        previewNote.isLeft = previewLane;
        previewNote.time = snappedTime;
        previewNote.length = 0;

        if (lastPlacedNote != null && lastPlacedNote.length > 0)
        {
            var startY = getNoteY(lastPlacedNote.time);
            var endY = getNoteY(lastPlacedNote.time + lastPlacedNote.length);

            var lineHeight = Math.abs(endY - startY);
            holdLine.visible = true;
            holdLine.x = lastPlacedNote.x + lastPlacedNote.width / 2 - 2;
            holdLine.y = Math.min(startY, endY);
            holdLine.makeGraphic(4, Math.ceil(lineHeight), FlxColor.WHITE);
        }
        else
            holdLine.visible = false;

        #if sys
        if(FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.S)
        {
            File.saveContent('assets/data/$level.json', haxe.Json.stringify(chart.chartData));
            trace('Level $level saved!!!');
        }
        #end
    }

    function placeNote(isLeft:Bool, snappedTime:Float):Void
    {
        //trace('Placing note: ' + (isLeft ? 'Left' : 'Right') + ' - $snappedTime');
        var newNote = new Note(isLeft ? 200 : 400, getNoteY(snappedTime), snappedTime, isLeft, 0);

        notes.add(newNote);
        lastPlacedNote = newNote;

        final noteData:NoteData = {
            isLeft: isLeft,
            time: snappedTime,
            length: 0,
            speed: 0.4
        };
        chart.notes.push(noteData);
    }

    function getNoteY(strumTime:Float):Float
    {
        var offset = strumTime - conductor.songPosition;
        return 300 - (offset * 0.2);
    }

    function snapTime(time:Float):Float {
        var snapMs = conductor.crochet / snapDivisions[currentSnapIndex];
        return Std.int((time + 0.01) / snapMs) * snapMs;
    }
}