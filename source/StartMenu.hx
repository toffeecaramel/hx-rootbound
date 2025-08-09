package;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

class StartMenu extends FlxState
{
    // owo self note: settings might not be added on time, so I'll stick out with freeplay.
    // MAYBE NOT EVEN FREEPLAY LMAO IM CRYING :sob:
    final menuItems:Array<String> = ['Start!', 'Credits', 'Change Offset'#if !html5,'Exit'#end];
    var texts:Array<MenuButton> = [];
    var ohDiamonds:Array<FlxSprite> = [];
    var diamondFollower:FlxSprite;
    public var selectedIndex:Int = 0;
    private var conductor:Conductor;
    private var canPress:Bool = true;

    override public function create()
    {
        super.create();

        var bg = new FlxSprite().loadGraphic(AssetPaths.menuBG_alt__png);
        bg.screenCenter();
        add(bg);

        var logo = new FlxSprite().loadGraphic(AssetPaths.logov2__png);
        logo.screenCenter();
        add(logo);
        logo.y -= 64;

        conductor = new Conductor(150);
        conductor.onBeatHit.add(()->{
            FlxG.camera.zoom += 0.018;
        });
        add(conductor);

        // i love these diamonds sm <3
        diamondFollower = new FlxSprite().loadGraphic(AssetPaths.diamondList__png);
        diamondFollower.screenCenter();
        add(diamondFollower);
        
        for(i in 0...menuItems.length)
        {
            final text = new MenuButton();
            text.text = menuItems[i];
			text.screenCenter();
            add(text);
            texts.push(text);
            text.y += 56 * i;
            text.updateTxt();
        }

        updateSelection(false);
        FlxG.camera.scroll.y = 1000;
        flixel.tweens.FlxTween.tween(FlxG.camera.scroll, {y: 0}, 0.58, {ease: flixel.tweens.FlxEase.expoOut});
        diamondsOh();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if(canPress)
        {
            if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W)
    		{
    			selectedIndex = (selectedIndex + menuItems.length - 1) % menuItems.length;
    			updateSelection();
    		}
    		else if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S)
    		{
    			selectedIndex = (selectedIndex + 1) % menuItems.length;
    			updateSelection();
    		}
            else if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
            {
                switch(menuItems[selectedIndex].toLowerCase())
                {
                    case 'start!': PlayState.nextLevel = 'level-one';
                    PlayState.curSong = 0;
                        FlxG.sound.music.stop();
                        //done :)
                        FlxG.sound.play(AssetPaths.menuconfirm__ogg);
                        canPress = false;
                        texts[selectedIndex].flicker();
                        new FlxTimer().start(0.6, (_)->{
                            var s = new FlxSprite().makeGraphic(FlxG.width + 32, FlxG.height + 32, FlxColor.BLACK);
                            s.alpha = 0.0001;
                            add(s);
                            s.screenCenter();
                            for(d in ohDiamonds)
                                flixel.tweens.FlxTween.tween(d, {alpha: 0}, 0.8);
                            flixel.tweens.FlxTween.tween(s, {alpha: 1}, 0.9, {onComplete: (_)->FlxG.switchState(()-> new Cutscene())});
                        });

                    case 'change offset': openSubState(new ChangeOffset());

                    case 'credits': openSubState(new Credits());

                    #if !html5
                    case 'exit': Sys.exit(1);
                    #end
                }
            }
        }

        diamondFollower.y = FlxMath.lerp(diamondFollower.y, texts[selectedIndex].y + texts[selectedIndex].height / 2 - diamondFollower.height / 2, elapsed * 12);
        FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, 1, elapsed * 14);
    }

    private function updateSelection(a:Bool = true):Void
	{
		for(i in 0...texts.length)
            texts[i].selected = (i == selectedIndex);

        if(a) FlxG.sound.play(AssetPaths.menu_scroll__ogg, 0.68);
	}

    function diamondsOh()
    {
        final ds = [AssetPaths.diamondone__png, AssetPaths.diamondtwo__png, AssetPaths.diamondthree__png];
        var d = new FlxSprite().loadGraphic(ds[FlxG.random.int(0, 2)]);
        d.angle = FlxG.random.int(-360, 360);
        add(d);
        d.alpha = FlxG.random.float(0.1, 0.5);
        d.blend = ADD;
        d.y = FlxG.height + d.height;
        d.x = FlxG.random.int(0, Std.int(FlxG.width - d.width));
        ohDiamonds.push(d);
        flixel.tweens.FlxTween.tween(d, {angle: d.angle + FlxG.random.int(300, 400), y: -200}, FlxG.random.float(15, 20), {onComplete: (_)->{
            ohDiamonds.remove(d);
            d.destroy();
        }});

        new FlxTimer().start(0.5, (_) -> diamondsOh()); //no more on beat otherwise they stop cause my conductor sucks
    }
}

class MenuButton extends flixel.group.FlxSpriteGroup
{
    public var text:String = '';
    public var selected(default, set):Bool;

    private var back:FlxSprite;
    private var txt:FlxText;
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        back = new FlxSprite();
        add(back);

        txt = new FlxText();
        add(txt);
        selected = false;
    }

    public function updateTxt()
    {
        txt.text = text;
        txt.setFormat(null, 16, CENTER);
        txt.setPosition(back.x + back.width /2 - txt.width / 2, back.y + back.height / 2 - txt.height / 2);
    }

    public function flicker()
    {
        new FlxTimer().start(0.07, (_)->{
            this.selected = !selected;
        }, 16);
    }

    function set_selected(selected:Bool):Bool
    {
        this.selected = selected;

        if(selected)
        {
            back.loadGraphic(AssetPaths.menuitem_selected__png);
            txt.color = FlxColor.BLACK;
        }
        else
        {
            back.loadGraphic(AssetPaths.menuitem_unselected__png);
            txt.color = FlxColor.WHITE;
        }

        return selected;
    }
}