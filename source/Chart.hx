package;

import openfl.utils.Assets;
import haxe.Json;

typedef NoteData = {
    var isLeft:Bool;
    var time:Float;
    var length:Float;
};

typedef ChartData = {
    var notes:Array<NoteData>;
}

class Chart 
{
    public var notes:Array<NoteData> = [];
    public var chartData:ChartData;
    public function new(name:String = 'test')
    {
        final jsonString:String = switch(name) {
            default: Assets.getText("assets/data/testLevel.json");
        };

        chartData = Json.parse(jsonString);
        notes = chartData.notes;
    }
}