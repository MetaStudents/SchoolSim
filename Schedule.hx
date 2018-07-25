package;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.text.TextFormat;
import openfl.text.TextField;
import haxe.ds.HashMap;

class Schedule extends Sprite {

    private var cols:HashMap<Day,TextField> = new HashMap();
    private var weekdayHeight = 15;
    private var today:Day;
    
    private var xOffset:Int;
    private var yOffset:Int;
    private var colWidth:Int;
    private var colHeight:Int;
    private var endDate:Date; //first date not in calendar
    private var cursor:Shape;
    
    public function new (width, height, date:Date){
	super();
	
	today = Day.fromDate(date);
		//round down to nearest Sunday to get endDate because nothing in schedule yet
	endDate = DateTools.delta(date, -DateTools.days(date.getDay()));
	
	xOffset = 0;
	yOffset = weekdayHeight;
	colWidth = Math.round(width/7);
	colHeight = height-weekdayHeight;

	cursor = new Shape();
	cursor.graphics.lineStyle(0);
	cursor.graphics.beginFill(0x00FF00, 1);
	cursor.graphics.drawRect(0,0,colWidth, 5);
	cursor.graphics.endFill();
	cursor.x = xOffset + colWidth*date.getDay();
	cursor.y = yOffset + colHeight*modDay(date);
	this.addChild(cursor);

	makeCols();
	makeWeekdays();
	cols.get(today).backgroundColor = 0xEE5D15;
	
    }

    private function modDay(date:Date):Float {
	return  (date.getHours() + (date.getMinutes() + (date.getSeconds())/60)/60)/24;
    }
    
    private function makeCols(){
	for (j in 0...7){
	    var col:TextField = new TextField();
	    addChild(col);

	    col.x = xOffset + j*colWidth;
	    col.y = yOffset;
	    col.text = Std.string(endDate.getDate());
	    
	    col.background = true;
	    col.backgroundColor = 0xFFFFFF;
	    col.border = true;
	    col.borderColor = 0x000000;
	    col.width = colWidth;
	    col.height = colHeight;
	    
	    cols.set(Day.fromDate(endDate),col);
	    endDate = DateTools.delta(endDate, DateTools.days(1));
	}
	this.addChild(cursor);
    }

    private function makeWeekdays() {
	var names:Array<String> = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
	for (i in 0...7) {
	    var weekday:TextField = new TextField();
	    addChild(weekday);

	    weekday.text = names[i];
	    weekday.x = xOffset + i*colWidth;
	    weekday.y = yOffset - 15;
	}
    }
    
    private function advanceCols(){
	for (col in cols){
		removeChild(col);
	}
	makeCols();
    }

    public function update(gameDate:Date) {
	trace("hi");
	var day = Day.fromDate(gameDate);
	trace(today.month+" "+today.day);
	trace(day.month+" "+day.day);
	if (!today.equals(day)){
	    if (gameDate.getDay()==0){
		advanceCols();
	    }
	    cols.get(day).backgroundColor = 0xEE5D15;
	    cols.get(today).backgroundColor = 0xFFFFFF;
	    today=day;
	}
	cursor.x = xOffset + colWidth*gameDate.getDay();
	cursor.y = yOffset + colHeight*modDay(gameDate);
    }
}
