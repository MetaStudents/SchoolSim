package;


import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.Bitmap;
import openfl.Assets;
import openfl.events.Event;

class Main extends Sprite {
    public static inline var m = 10;
    public static inline var s = 180;
    public static inline var xM = m;
    public static inline var yM = m;
    public static inline var x1 = s;
    public static inline var x2 = 800-4*m-2*s;
    public static inline var x3 = s;
    public static inline var y1 = s;
    public static inline var y2 = 600-3*m-s;

    public var timeScale:Float = 3600*12; // sec to half-day (for now)
    public var gameDate:Date;
    public var mscheduleSpr:Calendar;
    public var wscheduleSpr:Schedule;
    public var bar1:Bar;
    public var bar2:Bar;
    public var bar3:Bar;
    public var initialTimeStamp:Float;

    public function new () {
	
	super ();
	
	/*
	  var bitmapData = Assets.getBitmapData ("assets/openfl.png");
	  var bitmap = new Bitmap (bitmapData);
	  addChild (bitmap);
	  
	  bitmap.x = (stage.stageWidth - bitmap.width) / 2;
	  bitmap.y = (stage.stageHeight - bitmap.height) / 2;
	*/
        gameDate = Date.now();
	initialTimeStamp = Sys.time();
	trace(gameDate.getTime());
	trace(initialTimeStamp);
	mscheduleSpr = new Calendar(x2,y1, gameDate);
	mscheduleSpr.x=2*xM+x1;
	mscheduleSpr.y=yM;
	var avatarSpr = new Sprite();
	avatarSpr.x=xM;
	avatarSpr.y=2*yM+y1;
	var classesSpr = new Sprite();
	classesSpr.x=2*xM+x1;
	classesSpr.y=2*yM+y1;
	wscheduleSpr = new Schedule(x3,y2, gameDate);
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

	bar1 = new Bar(0.3, 60, 50, "class 1");
	bar1.x = Math.round(x2/5);
	bar1.y = y2;
	bar2 = new Bar(0.5, 200, 50, "class 2");
	bar2.x = Math.round(2*x2/5);
	bar2.y = y2;
	bar3 = new Bar(0.8, 400, 50, "class 3");
	bar3.x = Math.round(3*x2/5);
	bar3.y = y2;
	classesSpr.addChild(bar1);
	classesSpr.addChild(bar2);
	classesSpr.addChild(bar3);

       	stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
    }

    private function onEnterFrame (e:Event){
	//initialTimeStamp is in seconds, but Date.fromTime takes milliseconds
	var newGameDate = Date.fromTime(1000*(initialTimeStamp+timeScale*(Sys.time()-initialTimeStamp)));
	//	trace(timeScale*(wut-initialTimeStamp));
	var delta = (newGameDate.getTime() - gameDate.getTime())/1000;
	gameDate = newGameDate;
	mscheduleSpr.update(gameDate);
	wscheduleSpr.update(gameDate);
	bar1.update(delta);
	bar2.update(delta);
	bar3.update(delta);
    }
	
}
