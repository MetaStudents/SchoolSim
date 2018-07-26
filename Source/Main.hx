package;


import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.events.Event;
import haxe.Json;
import haxe.Timer;

class Main extends Sprite {
    public static inline var m = 10;
    public static inline var s1 = 150;
    public static inline var s2 = 250;
    public static inline var xM = m;
    public static inline var yM = m;
    public static inline var x1 = s1;
    public static inline var x2 = 800-4*m-s1-s2;
    public static inline var x3 = s2;
    public static inline var y1 = s1;
    public static inline var y2 = 600-3*m-s1;

    public var timeScale:Float = 3600*12; // sec to half-day (for now)
    public var gameDate:Date; // must be a Sunday
    public var mscheduleSpr:Calendar;
    public var wscheduleSpr:Schedule;
    public var bar1:Bar;
    public var bar2:Bar;
    public var bar3:Bar;
    public var bar4:Bar;
    public var bar5:Bar;
    public var bar6:Bar;
    public var initialTimestamp:Float;
    public var initialGameTimestamp:Float;
    public var scheduleObject:Array<Array<Lecture>>;
    public var colors:Array<Int>;
    
    public function new () {
	
	super ();
	
	var scheduleJson = Assets.getText("assets/schedule.json");
	scheduleObject = Json.parse(scheduleJson);

	colors = [0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0xFF00FF, 0x00FFFF];

	/*
	  var bitmapData = Assets.getBitmapData ("assets/openfl.png");
	  var bitmap = new Bitmap (bitmapData);
	  addChild (bitmap);
	  
	  bitmap.x = (stage.stageWidth - bitmap.width) / 2;
	  bitmap.y = (stage.stageHeight - bitmap.height) / 2;
	*/
        gameDate = new Date(2018, 9, 28, 0, 0, 0);
	//trace(gameDate.getDay()); //Should be 0
	initialTimestamp = Timer.stamp();
	initialGameTimestamp = gameDate.getTime()/1000;
	//trace(gameDate.getTime());
	trace(initialTimestamp);
	trace(Date.now().getTime()/1000);
	trace(Timer.stamp());
	mscheduleSpr = new Calendar(x2,y1, gameDate);
	mscheduleSpr.x=2*xM+x1;
	mscheduleSpr.y=yM;
	var avatarSpr = new Sprite();
	avatarSpr.x=xM;
	avatarSpr.y=2*yM+y1;
	var classesSpr = new Sprite();
	classesSpr.x=2*xM+x1;
	classesSpr.y=2*yM+y1;
	wscheduleSpr = new Schedule(x3,y2, gameDate, scheduleObject, colors);
	wscheduleSpr.x=3*xM+x1+x2;
	wscheduleSpr.y=2*yM+y1;
	
	//	var rectangle1 = new Shape();
	var rectangle2 = new Shape();
	var rectangle3 = new Shape();
	//var rectangle4 = new Shape();
	//rectangle1.graphics.lineStyle(2);
	rectangle2.graphics.lineStyle(2);
	rectangle3.graphics.lineStyle(2);
	//rectangle4.graphics.lineStyle(2);
	
	//rectangle1.graphics.drawRect(0,0, x2, y1); 
	rectangle2.graphics.drawRect(0,0, x1, y2); 
	rectangle3.graphics.drawRect(0,0, x2, y2);
	//	rectangle4.graphics.drawRect(0,0, x3, y2); 

	//mscheduleSpr.addChild(rectangle1);
	avatarSpr.addChild(rectangle2);
	classesSpr.addChild(rectangle3);
	//wscheduleSpr.addChild(rectangle4);
	
	this.addChild(mscheduleSpr);
	this.addChild(avatarSpr);
	this.addChild(classesSpr);
	this.addChild(wscheduleSpr);

	bar1 = new Bar(0.01, 100, 50, "Drawing", scheduleObject[0], gameDate, colors[0]);
	bar1.x = Math.round(x2/7);
	bar1.y = y2;
	bar2 = new Bar(0.04, 100, 50, "Evolution and Ecology", scheduleObject[1], gameDate, colors[1]);
	bar2.x = Math.round(2*x2/7);
	bar2.y = y2;
	bar3 = new Bar(0.04, 100, 50, "EE Lab", scheduleObject[2], gameDate, colors[2]);
	bar3.x = Math.round(3*x2/7);
	bar3.y = y2;
	bar4 = new Bar(0.04, 100, 50, "Chem", scheduleObject[3], gameDate, colors[3]);
	bar4.x = Math.round(4*x2/7);
	bar4.y = y2;
	bar5 = new Bar(0.04, 100, 50, "Chem Lab", scheduleObject[4], gameDate, colors[4]);
	bar5.x = Math.round(5*x2/7);
	bar5.y = y2;
	bar6 = new Bar(0.01, 100, 50, "How Things Work", scheduleObject[5], gameDate, colors[5]);
	bar6.x = Math.round(6*x2/7);
	bar6.y = y2;
	classesSpr.addChild(bar1);
	classesSpr.addChild(bar2);
	classesSpr.addChild(bar3);
	classesSpr.addChild(bar4);
	classesSpr.addChild(bar5);
	classesSpr.addChild(bar6);

       	stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);

    }

    private function onEnterFrame (e:Event){
	//initialTimeStamp is in seconds, but Date.fromTime takes milliseconds
	var newGameDate = Date.fromTime(1000*(initialGameTimestamp+timeScale*(Timer.stamp()-initialTimestamp)));
	//	trace(timeScale*(wut-initialTimeStamp));
	var delta = (newGameDate.getTime() - gameDate.getTime())/1000;
	gameDate = newGameDate;
	mscheduleSpr.update(gameDate);
	wscheduleSpr.update(gameDate);
	bar1.update(gameDate, delta);
	bar2.update(gameDate, delta);
	bar3.update(gameDate, delta);
	bar4.update(gameDate, delta);
	bar5.update(gameDate, delta);
	bar6.update(gameDate, delta);
    }
	
}
