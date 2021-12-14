package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

// week trio, dia
class Cutsceneshit extends FlxSpriteGroup
{
	// static inline final I = '[i]';

	public var box:FlxSprite;

    var background:FlxSprite;
	var curBg:String = '';

	// var bgMusic;
	// var curMus:String = '';

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	// var dropText:FlxText;

	public var finishThing:Void->Void;

	var bf:FlxSprite;
    var gf:FlxSprite;
    var k:FlxSprite;
	// var portraitRightNobody:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;
    var black:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		// bgMusic = FlxG.sound.playMusic(Paths.music('silence'));
		// bgMusic.fadeIn(3, 0, 0.7);

        switch (PlayState.SONG.song.toLowerCase())
		{
			case 'claws':
				FlxG.sound.playMusic(Paths.music('new_cutscene_music'), 1);
			case 'fuzzy':
				FlxG.sound.playMusic(Paths.music('new_cutscene_music'), 1);
			case 'catplay':
				FlxG.sound.playMusic(Paths.music('new_cutscene_music'), 1);
		}

        black = new FlxSprite(-500,-500).makeGraphic(9000,9000,FlxColor.BLACK);
		black.scrollFactor.set();
        add(black);

		box = new FlxSprite(90, 438);
		box.frames = Paths.getSparrowAtlas('box', 'shared');
		box.animation.addByPrefix('normalOpen', 'open', 24, false);
		box.animation.addByPrefix('normal', 'still', 24, false);
		// box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
		// box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		// box.animation.addByPrefix('normal', 'speech bubble normal', 24, false);
		
        // box.y = FlxG.height * 0.64;

        this.dialogueList = dialogueList;

		background = new FlxSprite(0,0);
		background.visible = true;
		add(background);

		bf = new FlxSprite(50, 580);
		bf.frames = Paths.getSparrowAtlas('daimages/tags');
		bf.animation.addByPrefix('enter', 'bf', 24, false);
		bf.updateHitbox();
		bf.scrollFactor.set();
		add(bf);
		bf.visible = false;

		gf = new FlxSprite(50, 580);
		gf.frames = Paths.getSparrowAtlas('daimages/tags');
		gf.animation.addByPrefix('enter', 'gf', 24, false);
		gf.updateHitbox();
		gf.scrollFactor.set();
		add(gf);
		gf.visible = false;

		k = new FlxSprite(50, 580);
		k.frames = Paths.getSparrowAtlas('daimages/tags');
		k.animation.addByPrefix('enter', 'kauan', 24, false);
		k.updateHitbox();
		k.scrollFactor.set();
		add(k);
		k.visible = false;

				
		box.animation.play('normalOpen');
		box.updateHitbox();
		add(box);
			
		handSelect = new FlxSprite(FlxG.width * 0.88, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));

		/*dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Candara';
		dropText.bold = true;
		dropText.color = 0xFFD89494;
		add(dropText);*/

		swagDialogue = new FlxTypeText(240, 580, Std.int(FlxG.width * 0.7), "", 41);
		swagDialogue.font = 'dialol';
		swagDialogue.bold = true;
		swagDialogue.color = 0xFFFFFFFF;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.2)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);

        bf.visible = false;
        gf.visible = false;
        k.visible = false;

		// dropText.y -= 15;
		// swagDialogue.y -= 15;
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}
		if (curCharacter == 'bg' && dialogueStarted == true)
		{
			dialogueList.remove(dialogueList[0]);
			startDialogue();
		}

		/*if (cutEl == true && dialogueStarted == true)
		{
			dialogueList.remove(dialogueList[0]);
			startDialogue();
		}*/
		
		#if mobile
		var justTouched:Bool = false;

		for (touch in FlxG.touches.list)
		{
			justTouched = false;
			
			if (touch.justReleased){
				justTouched = true;
			}
		}
		#end

		if (PlayerSettings.player1.controls.ACCEPT #if mobile || FlxG.touches.justStarted().length>0 #end && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.4);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						background.alpha -= 1 / 5;
						black.alpha -= 1 / 5;
						bf.visible = false;
        				gf.visible = false;
        				k.visible = false;
						swagDialogue.alpha -= 1 / 5;
						// dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	// var cutEl = false;

	function startDialogue():Void
	{
		cleanDialog();
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		if (!box.visible)
		{
			box.visible = true;
		}

		switch (curCharacter)
		{
			case 'bf':
				gf.visible = false;
                k.visible = false;
				if (!bf.visible)
				{
					bf.visible = true;
					bf.animation.play('enter');
				}
			case 'gf':
				bf.visible = false;
				k.visible = false;
				if (!gf.visible)
				{
					gf.visible = true;
					gf.animation.play('enter');
				}
			case 'k':
				bf.visible = false;
				gf.visible = false;
				if (!k.visible)
				{
					k.visible = true;
					k.animation.play('enter');
				}
			case 'bg':			
				remove(background);
				background.loadGraphic(Paths.image('daimages/$curBg'));
				add(background);
		}
	}

	function cleanDialog():Void
	{
		var splitData:Array<String> = dialogueList[0].split(":");
		curCharacter = splitData[1];
		dialogueList[0] = dialogueList[0].substr(splitData[1].length + 2).trim();
		
		curBg = dialogueList[0];
	}
}
