package;

import openfl.utils.Assets;
import haxe.Json;

typedef NoteData = {
    var isLeft:Bool;
    var time:Float;
    var length:Float;
    var speed:Float;
};

typedef ChartData = {
    var notes:Array<NoteData>;
    var bpm:Float;
}

class Chart 
{
    public var notes:Array<NoteData> = [];
    public var chartData:ChartData;
    public function new(name:String = 'test')
    {
        final jsonString:String = Assets.getText('assets/data/$name.json');

        chartData = Json.parse(jsonString);
        notes = chartData.notes;
    }
}