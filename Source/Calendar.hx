package;

import openfl.display.Sprite;
import openfl.text.TextFormat;
import openfl.text.TextField;
import haxe.ds.HashMap;

class Calendar extends Sprite {

    private var cells:HashMap<Day,TextField> = new HashMap();
    private var weekdayHeight = 15;
    private var today:Day;
    
    private var xOffset:Int;
    private var yOffset:Int;
    private var cellWidth:Int;
    private var cellHeight:Int;
    private var rows:Int;
    private var endDate:Date; //first date not in calendar
    
    public function new(width, height, date:Date){
	super();
	today = Day.fromDate(date);
	//round down to nearest Sunday to get endDate because nothing in calendar yet
	endDate = DateTools.delta(date, -DateTools.days(date.getDay()));
	
	xOffset = 0;
	yOffset = weekdayHeight;
	cellWidth = Math.round(width/7);
	cellHeight = Math.round((height-weekdayHeight)/2);
	rows = 2;
	
	makeGrid();
	makeWeekdays();
	cells.get(today).backgroundColor = 0xEE5D15;
    }

    private function makeGrid()
    {
	for (i in 0...rows){
	    for (j in 0...7){
		
		var cell:TextField = new TextField();
		addChild(cell);
		
		cell.x = xOffset + j*cellWidth;
		cell.y = yOffset + i*cellHeight;
		cell.text = Std.string(endDate.getDate());

		cell.background = true;
		cell.backgroundColor = 0xFFFFFF;
		cell.border = true;
		cell.borderColor = 0x000000;
		cell.width = cellWidth;
		cell.height = cellHeight;

		cells.set(Day.fromDate(endDate),cell);
		endDate = DateTools.delta(endDate, DateTools.days(1));
	    }
	}
    }

    private function advanceGrid(){
	for (cell in cells){
	    if (cell.y <= yOffset){
		removeChild(cell);
	    } else {
		cell.y -= cellHeight;
	    }
	}
	for (j in 0...7){
	    var cell:TextField = new TextField();
	    addChild(cell);
		
	    cell.x = xOffset + j*cellWidth;
	    cell.y = yOffset + (rows-1)*cellHeight;
	    cell.text = Std.string(endDate.getDate());

	    cell.background = true;
	    cell.backgroundColor = 0xFFFFFF;
	    cell.border = true;
	    cell.borderColor = 0x000000;
	    cell.width = cellWidth;
	    cell.height = cellHeight;

	    cells.set(Day.fromDate(endDate),cell);
	    endDate = DateTools.delta(endDate, DateTools.days(1));
	}
    }

    private function makeWeekdays() {
	var names:Array<String> = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
	for (i in 0...7) {
	    var weekday:TextField = new TextField();
	    addChild(weekday);

	    weekday.text = names[i];
	    weekday.x = xOffset + i*cellWidth;
	    weekday.y = yOffset - 15;
	}
    }

    public function update(gameDate:Date) {
	//trace("hi");
	var day = Day.fromDate(gameDate);
	//trace(today.month+" "+today.day);
	//trace(day.month+" "+day.day);
	if (!today.equals(day)){
	    if (gameDate.getDay()==0){
		advanceGrid();
	    }
	    cells.get(day).backgroundColor = 0xEE5D15;
	    cells.get(today).backgroundColor = 0xFFFFFF;
	    today=day;
	}
    }
}
