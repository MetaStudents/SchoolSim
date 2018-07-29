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
    private var lectures:Lecture.LectureObject;
    private var lectureNum:Int;
    private var lectureEndDate:Date;
    private var initGameDate:Date;
    // interestRate is the proportion of the total that increases per day

    public function new(interestRate:Float, workRate:Float, startHeight:Int, nameStr:String, lectures:Lecture.LectureObject, gameDate:Date, color:Int=0x000000) {
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
		lectureEndDate = lectures.startDate;
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
		if (gameDate.getTime() < lectures.endDate.getTime() && gameDate.getTime() > lectureEndDate.getTime()){
			movable.y -= lectures.size;
			lectureNum++;
			lectureEndDate = nextHomework(gameDate);
		}
	}
	
	//Returns the next date that a homwork will be due/lecture will occur
	private function nextHomework(gameDate:Date) : Date {
		var nextDate = DateTools.delta(gameDate, DateTools.days(1));
		while (Util.DayinRange(lectures.startDate, lectures.endDate, nextDate)){
			trace(nextDate);
			if (((lectures.days >> (6 - nextDate.getDay())) & 1) == 1){
				trace("found");
				return nextDate;
			}
			nextDate = DateTools.delta(nextDate, DateTools.days(1));
		}
		return null; 
	}
}
