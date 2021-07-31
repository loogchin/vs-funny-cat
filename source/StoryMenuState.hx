package;

import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	var difc:Int = 2;

	var bg:FlxSprite;
	var bf:FlxSprite;
	var black:FlxSprite;
	var blue:FlxSprite;
	var curSelected:Int = 0;
	public static var firstStart:Bool = true;
	public static var finishedFunnyMove:Bool = false;

	var difs:FlxGroup;
	var dif:FlxSprite;

	var optionShit:Array<String> = ['tut', 'notut'];

	static function weekData():Array<Dynamic>
	{
		return [
			['Tutorial'],
			['fuzzy', 'claws', 'catplay']
		];
	}
	var curDifficulty:Int = 2;

	public static var weekUnlocked:Array<Bool> = [];

	var weekCharacters:Array<Dynamic> = [
		['', 'bf', 'gf'],
		['dad', 'bf', 'gf']
	];

	var weekNames:Array<String> = CoolUtil.coolTextFile(Paths.txt('data/weekNames'));

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;
	var menuItems:FlxTypedGroup<FlxSprite>;
	var float:FlxTween;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	function unlockWeeks():Array<Bool>
	{
		var weeks:Array<Bool> = [];
		#if debug
		for(i in 0...weekNames.length)
			weeks.push(true);
		return weeks;
		#end
		
		weeks.push(true);

		for(i in 0...FlxG.save.data.weekUnlocked)
			{
				weeks.push(true);
			}
		return weeks;
	}

	override function create()
	{


		
		


		blue = new FlxSprite(-185,-225).loadGraphic(Paths.image('BluMenu'));
		blue.scrollFactor.x = 0;
		blue.scrollFactor.y = 0.10;
		blue.updateHitbox();
		blue.scale.set(0.65, 0.65);
		if(FlxG.save.data.antialiasing)
			{
				blue.antialiasing = true;
			}
		add(blue);

		bg = new FlxSprite(30,-215).loadGraphic(Paths.image('YelloMenuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.updateHitbox();
		bg.scale.set(0.628, 0.628);
		if(FlxG.save.data.antialiasing)
			{
				bg.antialiasing = true;
			}
		add(bg);

		bf = new FlxSprite(-1500,-270).loadGraphic(Paths.image('BFMenu'));
		bf.scrollFactor.x = 0;
		bf.scrollFactor.y = 0.10;
		bf.updateHitbox();
		bf.scale.set(0.5, 0.5);
		if(FlxG.save.data.antialiasing)
			{
				bf.antialiasing = true;
			}
		add(bf);
		FlxTween.tween(bf,{x: -335},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
			{ 
			}});

		black = new FlxSprite(-35,-270).loadGraphic(Paths.image('BlackWeekBar'));
		black.scrollFactor.x = 0;
		black.scrollFactor.y = 0.10;
		black.updateHitbox();
		black.scale.set(0.628, 0.628);
		if(FlxG.save.data.antialiasing)
			{
				black.antialiasing = true;
			}
		add(black);

		weekUnlocked = unlockWeeks();

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				Conductor.changeBPM(102);
			}
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(1000000, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(9000000, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(111111110, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		trace("Line 70");

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('aaaaa');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(-20, FlxG.height * 1.6);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " normal", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " selected", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.5));
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			if (firstStart)
				FlxTween.tween(menuItem,{y: 30 + (i * 170),x: 700 - (i * 120)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
						changeItem();
					}});
			else
				menuItem.y = 30 + (i * 170);
			    menuItem.x = 700 + (i * 120);
			    changeItem();
		}

		for (i in 0...weekData().length)
		{
			var weekThing:MenuItem = new MenuItem(-1000,10);
			FlxTween.tween(weekThing,{y: -300,x: 30000000 - (i * 160)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
				{ 
				}});
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			weekThing.scale.set(0.5, 0.5);
			grpWeekText.add(weekThing);
			if(FlxG.save.data.antialiasing)
				{
					weekThing.antialiasing = true;
				}
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				trace('locking week ' + i);
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				if(FlxG.save.data.antialiasing)
					{
						lock.antialiasing = true;
					}
					
			}
		}

		trace("Line 96");

		grpWeekCharacters.add(new MenuCharacter(0, 100, 0.5, false));
		grpWeekCharacters.add(new MenuCharacter(450, 25, 0.9, true));
		grpWeekCharacters.add(new MenuCharacter(850, 100, 0.5, true));

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');

		sprDifficulty = new FlxSprite(410, 170);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('easy');
		sprDifficulty.scale.set(0.4, 0.4);
		changeDifficulty();
		FlxTween.tween(sprDifficulty,{y: 410},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween)
			{ 
			}});


		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');

		trace("Line 150");


		txtTracklist = new FlxText(100, 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		// add(rankText);

		updateText();

		difs = new FlxGroup();
		add(difs);

		var tex = Paths.getSparrowAtlas('diffs');

		dif = new FlxSprite(500, 2000);
		dif.frames = tex;
		dif.animation.addByPrefix('ez', '1dificulty easy');
		dif.animation.addByPrefix('nrl', '3dificulty medium');
		dif.animation.addByPrefix('hrd', '2dificulty hard');
		dif.scale.set(0.46, 0.46);
		dif.animation.play('hrd');
		changediff();

		dif.angle = -3;

		new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				if(dif.angle == -3) 
					FlxTween.angle(dif, dif.angle, 3, 1, {ease: FlxEase.quartInOut});
				if (dif.angle == 3) 
					FlxTween.angle(dif, dif.angle, -3, 1, {ease: FlxEase.quartInOut});
			}, 0);

		FlxTween.tween(dif,{y: 270},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween)
			{ 
			}});

		difs.add(dif);


		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		trace("Line 165");

		super.create();
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (controls.RIGHT_P)
			{
			changeDifficulty(1);
			changediff(1);
			FlxG.sound.play(Paths.sound('scrollMenu'));
			}
		if (controls.LEFT_P)
			{
			changeDifficulty(-1);
			changediff(-1);
			FlxG.sound.play(Paths.sound('scrollMenu'));
			}

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

				if (gamepad != null)
				{
					if (gamepad.justPressed.DPAD_UP)
					{
						changeWeek(-1);
						changeItem(-1);
						FlxG.sound.play(Paths.sound('scrollMenu'));
						
					}
					if (gamepad.justPressed.DPAD_DOWN)
					{
						changeWeek(1);
						changeItem(1);
						
					}

					if (gamepad.pressed.DPAD_RIGHT)
						rightArrow.animation.play('press')
					else
						rightArrow.animation.play('idle');
					if (gamepad.pressed.DPAD_LEFT)
						leftArrow.animation.play('press');
					else
						leftArrow.animation.play('idle');

					if (gamepad.justPressed.DPAD_RIGHT)
					{
						changeDifficulty(1);
						changediff(1);
					}
					if (gamepad.justPressed.DPAD_LEFT)
					{
						changeDifficulty(-1);
						
					}
				}

				if (FlxG.keys.justPressed.UP)
				{
					changeWeek(-1);
					changeItem(-1);
				}

				if (FlxG.keys.justPressed.DOWN)
				{
					changeWeek(1);
					changeItem(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');
			}

			if (controls.ACCEPT)
			{
				selectWeek();
				aaa();
				menuItems.forEach(function(spr:FlxSprite)
					{
							FlxTween.tween(spr, {y: spr.y + 1600,alpha: 1}, 1, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
								}
							});
					});
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData()[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;


			PlayState.storyDifficulty = curDifficulty;

			// adjusting the song name to be compatible
			var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
			switch (songFormat) {
				case 'Dad-Battle': songFormat = 'Dadbattle';
				case 'Philly-Nice': songFormat = 'Philly';
			}

			var poop:String = Highscore.formatSong(songFormat, curDifficulty);
			PlayState.sicks = 0;
			PlayState.bads = 0;
			PlayState.shits = 0;
			PlayState.goods = 0;
			PlayState.campaignMisses = 0;
			PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
	}

	function changediff(change:Int = 0):Void
		{
			difc += change;
	
			if (difc < 0)
				difc = 2;
			if (difc > 2)
				difc = 0;
	
			switch (difc)
			{
				case 0:
					dif.animation.play('ez');
				case 1:
					dif.animation.play('nrl');
				case 2:
					dif.animation.play('hrd');
	
			 }
		}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
		}

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = 900;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
		FlxTween.tween(sprDifficulty, {y: sprDifficulty.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData().length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData().length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function aaa() {
		FlxTween.tween(bf,{x: -1500},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
			{ 
			}});
		FlxTween.tween(dif,{x: 1500},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween)
			{ 
			}});

	}

	function changeItem(huh:Int = 0)
		{
				curSelected += huh;
	
				if (curSelected >= menuItems.length)
					curSelected = 0;
				if (curSelected < 0)
					curSelected = menuItems.length - 1;
			
			menuItems.forEach(function(spr:FlxSprite)
			{
				spr.animation.play('idle');
	
				if (spr.ID == curSelected)
				{
						spr.animation.play('selected');
								
				}
				spr.updateHitbox();
			});
		}

	function updateText()
	{
		grpWeekCharacters.members[0].setCharacter(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].setCharacter(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].setCharacter(weekCharacters[curWeek][2]);

		txtTracklist.text = "Tracks\n";
		var stringThing:Array<String> = weekData()[curWeek];

		for (i in stringThing)
			txtTracklist.text += "\n" + i;

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		txtTracklist.text += "\n";

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}

	public static function unlockNextWeek(week:Int):Void
	{
		if(week <= weekData().length - 1 && FlxG.save.data.weekUnlocked == week)
		{
			weekUnlocked.push(true);
			trace('Week ' + week + ' beat (Week ' + (week + 1) + ' unlocked)');
		}

		FlxG.save.data.weekUnlocked = weekUnlocked.length - 1;
		FlxG.save.flush();
	}

	override function beatHit()
	{
		super.beatHit();

		grpWeekCharacters.members[0].bopHead();
		grpWeekCharacters.members[1].bopHead();
		grpWeekCharacters.members[2].bopHead();
	}
}
