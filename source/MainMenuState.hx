package;

import flixel.FlxBasic;
import flixel.math.FlxRect;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.geom.Point;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import io.newgrounds.NG;
import lime.app.Application;
import flixel.math.FlxMath;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var character:Character;
	var startTimer:FlxTimer;
	var logoBl:FlxSprite;
	var c:FlxSprite;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.6" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var blacka:FlxSprite;
	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;
	public static var timer:Bool = true;
	public static var credits:Bool = false;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		if(FlxG.save.data.antialiasing)
			{
				bg.antialiasing = true;
			}
		add(bg);

		blacka = new FlxSprite(-500,-100).loadGraphic(Paths.image('black'));
		blacka.scrollFactor.x = 0;
		blacka.scrollFactor.y = 0.10;
		if(FlxG.save.data.antialiasing)
			{
				blacka.antialiasing = true;
			}
		add(blacka);
		if (firstStart)
			FlxTween.tween(blacka,{x: -185},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
				{ 
				}});
			else 
				FlxTween.tween(blacka,{x: -185},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
					}});


		var menu:FlxSprite = new FlxSprite(-260,20).loadGraphic(Paths.image('menuthing'));
		menu.scrollFactor.x = 0;
		menu.scrollFactor.y = 0.10;
		if(FlxG.save.data.antialiasing)
			{
				menu.antialiasing = true;
			}
		if (firstStart)
			FlxTween.tween(menu,{x: 5},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
				{ 
				}});
			else 
				FlxTween.tween(menu,{x: 5},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
					}});

		character = new Character(-400, 330, 'bf');
		character.debugMode = true;
		character.scale.set(0.8, 0.8);
		character.scrollFactor.set(0, 0);
		add(character);
		if (firstStart)
			FlxTween.tween(character,{x: -35},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
				{ 
				}});
			else 
				FlxTween.tween(character,{x: -35},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
					}});

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		if(FlxG.save.data.antialiasing)
			{
				magenta.antialiasing = true;
			}
		magenta.color = 0xFFfd719b;
		// magenta.scrollFactor.set();

		if (Main.watermarks) {
			logoBl = new FlxSprite(-2300, -300);
			logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		} else {
			logoBl = new FlxSprite(-150, -100);
			logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		}
		if(FlxG.save.data.antialiasing)
			{
				logoBl.antialiasing = true;
			}
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.updateHitbox();
		logoBl.scale.set(0.39, 0.38);
		add(logoBl);
		FlxTween.tween(logoBl, {y: logoBl.y + 10 ,alpha: 1}, 3, {type: FlxTweenType.PINGPONG});
		if (firstStart)
			FlxTween.tween(logoBl,{x: -320},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
				{ 
					logoBl.angle = -3;
					

					new FlxTimer().start(0.01, function(tmr:FlxTimer)
						{
							if(logoBl.angle == -3) 
								FlxTween.angle(logoBl, logoBl.angle, 3, 2, {ease: FlxEase.quartInOut});
							if (logoBl.angle == 3) 
								FlxTween.angle(logoBl, logoBl.angle, -3,2, {ease: FlxEase.quartInOut});
						}, 0);
				}});
			else 
				FlxTween.tween(logoBl,{x: -320},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
						logoBl.angle = -3;

						new FlxTimer().start(0.01, function(tmr:FlxTimer)
							{
								if(logoBl.angle == -3) 
									FlxTween.angle(logoBl, logoBl.angle, 3, 1, {ease: FlxEase.quartInOut});
								if (logoBl.angle == 3) 
									FlxTween.angle(logoBl, logoBl.angle, -3, 1, {ease: FlxEase.quartInOut});
							}, 0);
					}});


		c = new FlxSprite(80,1000).loadGraphic(Paths.image('transparent_credit'));
		c.scrollFactor.x = 0;
		c.scrollFactor.y = 0.10;
		c.scale.set(0.7, 0.7);
		c.updateHitbox();
		if(FlxG.save.data.antialiasing)
			{
				c.antialiasing = true;
			}
		add(c);

		c.angle = -4;

		new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				if(c.angle == -4) 
					FlxTween.angle(c, c.angle, 4, 0.8, {ease: FlxEase.quartInOut});
				if (c.angle == 4) 
					FlxTween.angle(c, c.angle, -4, 0.8, {ease: FlxEase.quartInOut});
			}, 0);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(-500, 60);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.scale.set(0.5, 0.5);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			if(FlxG.save.data.antialiasing)
				{
					menuItem.antialiasing = true;
				}
			if (firstStart)
				FlxTween.tween(menuItem,{y: 60 + (i * 160),x: 700},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
						finishedFunnyMove = true; 
						changeItem();
					}});
			else
				FlxTween.tween(menuItem,{y: 60 + (i * 160),x: 700},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
						finishedFunnyMove = true; 
						changeItem();
					}});
		}


		firstStart = false;


		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;
	var idk:Bool = true;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (controls.BACK && credits)
			{
				credits = false;
				new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						selectedSomethin = false;
					});
					
				FlxTween.tween(c, {y: 1500,alpha: 1}, 2, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween)
					{
					}
				});	
				FlxTween.tween(blacka,{x: -185},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
					}});
					menuItems.forEach(function(spr:FlxSprite)
						{
								FlxTween.tween(spr, {y: spr.y - 800,alpha: 1}, 1.3, {
									ease: FlxEase.quadOut,
									onComplete: function(twn:FlxTween)
									{
									}
								});
							});
				FlxTween.tween(logoBl,{x: -320},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
					}});

				FlxTween.tween(character,{x: -35},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
						{ 
						}});
				
			}

		if (!selectedSomethin)
		{

			if (FlxG.keys.justPressed.UP)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (FlxG.keys.justPressed.DOWN)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK && !credits)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] != 'donate')
					{
				idk = false;
				startTimer.cancel();
				character.playAnim('hey', true);
			        }
				else
					{		
						credits = true;
						FlxTween.tween(c, {y: 10,alpha: 1}, 2, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
							}
						});		
					}
				FlxG.sound.play(Paths.sound('confirmMenu'));

				new FlxTimer().start(0.4, function(tmr:FlxTimer)
					{
						FlxTween.tween(logoBl,{x: -820},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
							{
							}});
						FlxTween.tween(blacka,{x: -820},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween)
							{
							}});
						FlxTween.tween(character,{x: -820},1,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween)
							{
							}});
						
							selectedSomethin = true;
							
							menuItems.forEach(function(spr:FlxSprite)
							{
								if (curSelected != spr.ID)
								{
									FlxTween.tween(spr, {y: spr.y + 800,alpha: 1}, 1.3, {
										ease: FlxEase.quadOut,
										onComplete: function(twn:FlxTween)
										{
										}
									});
								}
								else
								{
									if (FlxG.save.data.flashing)
									{
											goToState();
										FlxTween.tween(spr, {y: spr.y + 800,alpha: 1}, 1.3, {
											ease: FlxEase.quadOut,
											onComplete: function(twn:FlxTween)
											{
											}
										});
									}
									else
									{
										new FlxTimer().start(1, function(tmr:FlxTimer)
										{
											goToState();
										});
										FlxTween.tween(spr, {y: spr.y + 800,alpha: 1}, 1.3, {
											ease: FlxEase.quadOut,
											onComplete: function(twn:FlxTween)
											{
											}
										});
									}
								}
							});
					});
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
		});
	}

	override function beatHit()
		{
			super.beatHit();

					startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
						{
							
							bop();
						}, 100000000);
		}
	
		function bop()
		 {
			if (idk)
			{			
					character.playAnim('idle', true);
					logoBl.animation.play('bump', true);
			}
		}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
