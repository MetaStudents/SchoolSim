package;


import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.events.Event;
import haxe.Json;

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
    public var initialTimestamp:Float;
    public var initialGameTimestamp:Float;
    public var scheduleObject:Array<Array<Lecture>>;
    //YYYY-MM-DD hh:mm:ss
    
    public function new () {
	
	super ();
	
	var scheduleJson = Assets.getText("assets/schedule.json");
	trace(scheduleJson);
	scheduleObject = Json.parse(scheduleJson);
	trace(scheduleObject);

	/*
	  var bitmapData = Assets.getBitmapData ("assets/openfl.png");
	  var bitmap = new Bitmap (bitmapData);
	  addChild (bitmap);
	  
	  bitmap.x = (stage.stageWidth - bitmap.width) / 2;
	  bitmap.y = (stage.stageHeight - bitmap.height) / 2;
	*/
        gameDate = new Date(2018, 8, 23, 0, 0, 0);
	//trace(gameDate.getDay()); //Should be 0
	initialTimestamp = Sys.time();
	initialGameTimestamp = gameDate.getTime()/1000;
	//trace(gameDate.getTime());
	//trace(initialTimestamp);
	mscheduleSpr = new Calendar(x2,y1, gameDate);
	mscheduleSpr.x=2*xM+x1;
	mscheduleSpr.y=yM;
	var avatarSpr = new Sprite();
	avatarSpr.x=xM;
	avatarSpr.y=2*yM+y1;
	var classesSpr = new Sprite();
	classesSpr.x=2*xM+x1;
	classesSpr.y=2*yM+y1;
	wscheduleSpr = new Schedule(x3,y2, gameDate, scheduleObject);
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

	bar1 = new Bar(0.3, 60, 50, "class 1", scheduleObject[0], gameDate);
	bar1.x = Math.round(x2/5);
	bar1.y = y2;
	bar2 = new Bar(0.5, 200, 50, "class 2", scheduleObject[1], gameDate);
	bar2.x = Math.round(2*x2/5);
	bar2.y = y2;
	bar3 = new Bar(0.8, 400, 50, "class 3", scheduleObject[2], gameDate);
	bar3.x = Math.round(3*x2/5);
	bar3.y = y2;
	classesSpr.addChild(bar1);
	classesSpr.addChild(bar2);
	classesSpr.addChild(bar3);

       	stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);

    }

    private function onEnterFrame (e:Event){
	//initialTimeStamp is in seconds, but Date.fromTime takes milliseconds
	var newGameDate = Date.fromTime(1000*(initialGameTimestamp+timeScale*(Sys.time()-initialTimestamp)));
	//	trace(timeScale*(wut-initialTimeStamp));
	var delta = (newGameDate.getTime() - gameDate.getTime())/1000;
	gameDate = newGameDate;
	mscheduleSpr.update(gameDate);
	wscheduleSpr.update(gameDate);
	bar1.update(gameDate, delta);
	bar2.update(gameDate, delta);
	bar3.update(gameDate, delta);
    }
	
}
