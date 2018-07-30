package;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.text.TextField;
import openfl.events.MouseEvent;

class Bar extends Sprite
{
    private var nameHeight = 15;
    private var cursor:Shape;
    private var barWidth = 20;
    private var movable:Sprite;
    private var column:Shape;
    private var nameField:TextField;
    private var interestRate:Float;
    private var workRate:Float;
    private var working:Bool;
    private var lectures:Array<Lecture>;
    private var lectureNum:Int;
    private var lectureEndDate:Date;
    private var initGameDate:Date;
    // interestRate is the proportion of the total that increases per day

    public function new(interestRate:Float, workRate:Float, startHeight:Int, nameStr:String, lectures:Array<Lecture>, gameDate:Date, color:Int=0x000000) {
	super();

	movable = new Sprite();
	movable.x = movable.y = 0;
	column = new Shape();
	column.graphics.lineStyle(0);
	column.graphics.beginFill(color, 1);
	column.graphics.drawRect(Math.round(barWidth/2),0,barWidth,1000);
	column.graphics.endFill();
	movable.addChild(column);

	nameField = new TextField();
	nameField.text = nameStr;
	nameField.x = Math.round(barWidth/2);
	nameField.y = -nameHeight;
	nameField.selectable = false;
	movable.addChild(nameField);

	addChild(movable);
	movable.x = 0;
	movable.y = -startHeight;
	movable.addEventListener(MouseEvent.MOUSE_DOWN,
				 function (e:MouseEvent)
				 {working=true;});
	movable.addEventListener(MouseEvent.MOUSE_UP,
				 function (e:MouseEvent)
				 {working=false;});
	movable.addEventListener(MouseEvent.MOUSE_OUT,
				 function (e:MouseEvent)
				 {working=false;});

	this.interestRate = interestRate;
	this.workRate = workRate;
	this.lectures = lectures;
	lectureNum = 0;
	initGameDate = gameDate;
       	lectureEndDate = Util.jsonTimeToDate(initGameDate, lectures[lectureNum].times.split(" ")[1]);
    }

    public function update(gameDate:Date, delta:Float) {
    	accrueInterest(delta);
	if (working){
 	    work(delta);
	}
	getHomework(gameDate);
    }

    private function accrueInterest(delta:Float) {
	//trace(interestRate+" "+delta/(3600*24)+" "+movable.y);
	movable.y += interestRate*(delta/(3600*24))*movable.y; // make movable.y more negative
    }

    private function work(delta:Float) {
	//trace(workRate * delta/(3600*24));
        movable.y += workRate * delta/(3600*24);
    }

    private function getHomework(gameDate:Date){
	if (lectureNum < lectures.length){
	    if (gameDate.getTime() > lectureEndDate.getTime()){
		movable.y -= lectures[lectureNum].size;
		lectureNum++;
		if (lectureNum < lectures.length){
		    lectureEndDate = Util.jsonTimeToDate(initGameDate, lectures[lectureNum].times.split(" ")[1]);
		}
	    }
	}
    }
}
