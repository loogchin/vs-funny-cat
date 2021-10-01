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

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFF11316b);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0.5;
		add(bgFade);

		box = new FlxSprite(0, 0);
		
		var hasDialog = false;
		hasDialog = true;
		box.frames = Paths.getSparrowAtlas('dialogueBox-pixel');
		box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
		box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		portraitLeft = new FlxSprite(0, 160);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/kapi');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 1));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(940, 250);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/portraits');
		portraitRight.animation.addByPrefix('kauan confident', 'kauan confident', 24, false);
		portraitRight.animation.addByPrefix('kauan>:3', 'kauan>:3', 24, false);
		portraitRight.animation.addByPrefix('kauanconfused', 'kauanconfused', 24, false);
		portraitRight.animation.addByPrefix('kauancry', 'kauancry', 24, false);
		portraitRight.animation.addByPrefix('kauanhapi', 'kauanhapi', 24, false);
		portraitRight.animation.addByPrefix('kauanhappy', 'kauanhappy', 24, false);
		portraitRight.animation.addByPrefix('kauannotamused', 'kauannotamused', 24, false);
		portraitRight.animation.addByPrefix('kauanpleading', 'kauanpleading', 24, false);
		portraitRight.animation.addByPrefix('kauanreallynotamused', 'kauanreallynotamused', 24, false);
		portraitRight.animation.addByPrefix('kauanrelief', 'kauanrelief', 24, false);
		portraitRight.animation.addByPrefix('kauansmug', 'kauansmug', 24, false);
		portraitRight.animation.addByPrefix('kauanworry', 'kauanworry', 24, false);
		portraitRight.animation.addByPrefix('troll', 'troll', 24, false);
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		portraitRight.setGraphicSize(Std.int(portraitRight.width * 1.6));
		portraitRight.antialiasing = true;
		add(portraitRight);
		portraitRight.visible = false;

		box.animation.play('normalOpen');
		box.scale.set(1.28,1);
		box.updateHitbox();
		add(box);

		box.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		
		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(75, 500, Std.int(FlxG.width * 0.8), "", 42);
		dropText.font = 'Delfino';
		dropText.color = 0x00000000;
		add(dropText);

		swagDialogue = new FlxTypeText(72, 497, Std.int(FlxG.width * 0.8), "", 42);
		swagDialogue.font = 'Delfino';
		swagDialogue.color = 0xFFFFFFFF;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 20, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

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

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 10;
						bgFade.alpha -= 1 / 10 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 10;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(.5, function(tmr:FlxTimer)
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

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/kapi');
				portraitLeft.visible = true;
				portraitLeft.animation.play('enter');
			case 'kapimad':
				portraitRight.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/kapimad');
				portraitLeft.visible = true;
				portraitLeft.animation.play('enter');
			case 'kapiconfused':
				portraitRight.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/kapiconfused');
				portraitLeft.visible = true;
				portraitLeft.animation.play('enter');
			case 'kapicute':
				portraitRight.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/kapicute');
				portraitLeft.visible = true;
				portraitLeft.animation.play('enter');
			case 'kapistare':
				portraitRight.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/kapistare');
				portraitLeft.visible = true;
				portraitLeft.animation.play('enter');
			case 'wap':
				portraitRight.visible = false;
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/wap');
				portraitLeft.visible = true;
				portraitLeft.animation.play('enter');
			case 'kauan confident':
				portraitRight.visible = true;
				portraitLeft.visible = false;
				portraitRight.animation.play('kauan confident');
			case 'kauan>3':
				portraitRight.visible = true;
				portraitLeft.visible = false;
				portraitRight.animation.play('kauan>:3');
			case 'kauanconfused':
				portraitRight.visible = true;
				portraitLeft.visible = false;
				portraitRight.animation.play('kauanconfused');
			case 'kauancry':
				portraitRight.visible = true;
				portraitLeft.visible = false;
				portraitRight.animation.play('kauancry');
			case 'kauanhapi':
				portraitRight.visible = true;
				portraitLeft.visible = false;
				portraitRight.animation.play('kauanhapi');
			case 'kauanhappy':
				portraitRight.visible = true;
				portraitLeft.visible = false;
				portraitRight.animation.play('kauanhappy');
			case 'kauannotamused':
				portraitRight.visible = true;
				portraitLeft.visible = false;
				portraitRight.animation.play('kauannotamused');
			case 'kauanpleading':
				portraitRight.visible = true;
				portraitLeft.visible = false;
				portraitRight.animation.play('kauanpleading');
			case 'kauanreallynotamused':
				portraitRight.visible = true;
				portraitLeft.visible = false;
				portraitRight.animation.play('kauanreallynotamused');
			case 'kauanrelief':
				portraitRight.visible = true;
				portraitLeft.visible = false;
				portraitRight.animation.play('kauanrelief');
			case 'kauansmug':
				portraitRight.visible = true;
				portraitLeft.visible = false;
				portraitRight.animation.play('kauansmug');
			case 'kauanworry':
				portraitRight.visible = true;
				portraitLeft.visible = false;
				portraitRight.animation.play('kauanworry');
			case 'troll':
				portraitRight.visible = true;
				portraitLeft.visible = false;
				portraitRight.animation.play('troll');
			case 'nar':
				portraitRight.visible = false;
				portraitLeft.visible = false;
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
