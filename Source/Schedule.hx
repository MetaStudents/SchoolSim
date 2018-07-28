package;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.text.TextFormat;
import openfl.text.TextField;
import haxe.ds.HashMap;

class Schedule extends Sprite {

    private var cols:HashMap<Day,TextField> = new HashMap();
    private var lectureCols:Array<TextField> = new Array();
    private var weekdayHeight = 15;
    private var today:Day;
    
    private var xOffset:Int;
    private var yOffset:Int;
    private var colWidth:Int;
    private var colHeight:Int;
    private var endDate:Date; //first date not in calendar
    private var cursor:Shape;
    private var week:Int;

    private var scheduleObject:Array<Array<Lecture>>;
    private var colors:Array<Int>;
    
    public function new (width, height, date:Date, scheduleObject:Array<Array<Lecture>>, colors:Array<Int>=null){
		super();
		
		this.scheduleObject = scheduleObject;
		this.colors = colors;
		
		if (colors == null || colors.length<scheduleObject.length){
			colors = new Array();
			for (i in 0...scheduleObject.length){
			colors.push(0x000000);
			}
		}
		
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
		
		week = -1;
		makeCols();
		makeWeekdays();
		cols.get(today).backgroundColor = 0xEE5D15;
    }

    private function modDay(date:Date):Float {
		return  (date.getHours() + (date.getMinutes() + (date.getSeconds())/60)/60)/24;
    }
    
    private function makeCols(){
		week++;
		
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
		
		var colorNum = 0;
		for (lectures in scheduleObject){
			for (lecture in lectures){
				var times = lecture.times.split(" ");
				var startNums = Util.splitAndParseInt(times[0], "/");
				//trace("hey");
				if (startNums[0]<week){
					continue;
				} else if(startNums[0]>week){
					break;
				}
				//trace("there");
				var startFrac = (startNums[2]+startNums[3]/60)/24;
				var yPos = yOffset + colHeight*startFrac;
				var xPos = xOffset + startNums[1]*colWidth;
				var endNums = Util.splitAndParseInt(times[1], "/");
				var endFrac = (endNums[2]+endNums[3]/60)/24;
				// We don't look at endNums[0] or endNums[1]
				var h = colHeight*(endFrac-startFrac);
				var lectureCol = new TextField();
				addChild(lectureCol);
				
				lectureCol.x = xPos;
				lectureCol.y = yPos;
				lectureCol.text = lecture.title;
				
				lectureCol.background = true;
				lectureCol.backgroundColor = colors[colorNum];
				lectureCol.border = true;
				lectureCol.borderColor = 0x000000;
				lectureCol.width = colWidth;
				lectureCol.height = h;
				
				lectureCols.push(lectureCol);
			}
			colorNum++;
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
		for (lectureCol in lectureCols){
			removeChild(lectureCol);
		}
		makeCols();
    }

    public function update(gameDate:Date) {
		//	trace("hi");
		var day = Day.fromDate(gameDate);
		//	trace(today.month+" "+today.day);
		//	trace(day.month+" "+day.day);
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
