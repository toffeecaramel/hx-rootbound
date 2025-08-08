package;

import flixel.math.FlxPoint;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileCircle;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileSquare;
import flixel.addons.transition.TransitionData;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxRect;
import flixel.graphics.FlxGraphic;

class Init extends FlxTransitionableState
{
    static var initialized:Bool = false;
    override public function create()
    {
        super.create();
        if (!initialized)
        {
            initialized = true;

            var transitionGraphic:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
            transitionGraphic.persist = true;
            transitionGraphic.destroyOnNoUse = false;

            var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
            diamond.persist = true;
            diamond.destroyOnNoUse = false;

            FlxTransitionableState.defaultTransIn = new TransitionData(TILES, FlxColor.BLACK, 0.5, 
                new FlxPoint(-2, -1), {asset: diamond, width: 32, height: 32},
                new FlxRect(-1, 0, FlxG.width, FlxG.height));
            FlxTransitionableState.defaultTransOut = new TransitionData(TILES, FlxColor.BLACK, 0.5, 
                new FlxPoint(2, -1), {asset: diamond, width: 32, height: 32}, 
                new FlxRect(-1, 0, FlxG.width, FlxG.height));
                
            FlxTransitionableState.defaultTransIn.cameraMode = NEW;
            FlxTransitionableState.defaultTransOut.cameraMode = NEW;

            transIn = FlxTransitionableState.defaultTransIn;
            transOut = FlxTransitionableState.defaultTransOut;
        }

        FlxG.switchState(()->new PlayState());
    }
}