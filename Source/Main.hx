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
	var wscheduleSpr = new Sprite();
	wscheduleSpr.x=3*xM+x1+x2;
	wscheduleSpr.y=2*yM+y1;
	
	//	var rectangle1 = new Shape();
	var rectangle2 = new Shape();
	var rectangle3 = new Shape();
	var rectangle4 = new Shape();
	//rectangle1.graphics.lineStyle(2);
	rectangle2.graphics.lineStyle(2);
	rectangle3.graphics.lineStyle(2);
	rectangle4.graphics.lineStyle(2);
	
	//rectangle1.graphics.drawRect(0,0, x2, y1); 
	rectangle2.graphics.drawRect(0,0, x1, y2); 
	rectangle3.graphics.drawRect(0,0, x2, y2);
	rectangle4.graphics.drawRect(0,0, x3, y2); 

	//mscheduleSpr.addChild(rectangle1);
	avatarSpr.addChild(rectangle2);
	classesSpr.addChild(rectangle3);
	wscheduleSpr.addChild(rectangle4);
	
	this.addChild(mscheduleSpr);
	this.addChild(avatarSpr);
	this.addChild(classesSpr);
	this.addChild(wscheduleSpr);

       	stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
    }

    private function onEnterFrame (e:Event){
	//initialTimeStamp is in seconds, but Date.fromTime takes milliseconds
	gameDate = Date.fromTime(1000*(initialTimeStamp+timeScale*(Sys.time()-initialTimeStamp)));
	//	trace(timeScale*(wut-initialTimeStamp));
	mscheduleSpr.update(gameDate);
    }
	
}
