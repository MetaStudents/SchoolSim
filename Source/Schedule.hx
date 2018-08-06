package;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.text.TextFormat;
import openfl.text.TextField;
import haxe.ds.HashMap;

class Schedule extends Sprite {

	private var cols:HashMap<Day, TextField> = new HashMap();
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

	private var scheduleObject:Array<Lecture.LectureObject>;
	private var colors:Array<Int>;

	private var textHeight:Int;
	private var format:TextFormat;

	public function new(width, height, date:Date, scheduleObject:Array<Lecture.LectureObject>, colors:Array<Int> = null) {
		super();

		this.scheduleObject = scheduleObject;
		this.colors = colors;

		if (colors == null || colors.length < scheduleObject.length) {
			colors = new Array();
			for (i in 0...scheduleObject.length) {
				colors.push(0x000000);
			}
		}

		today = Day.fromDate(date);
		//round down to nearest Sunday to get endDate because nothing in schedule yet
		endDate = DateTools.delta(date, -DateTools.days(date.getDay()));

		xOffset = 40;
		yOffset = weekdayHeight;
		colWidth = Math.round((width - xOffset) / 7);
		colHeight = height - weekdayHeight;
		textHeight = 10;
		format = new TextFormat(textHeight);

		cursor = new Shape();
		cursor.graphics.lineStyle(0);
		cursor.graphics.beginFill(0x00FF00, 1);
		cursor.graphics.drawRect(0, 0, colWidth, 5);
		cursor.graphics.endFill();
		cursor.x = xOffset + colWidth * date.getDay();
		cursor.y = yOffset + colHeight * modDay(date);
		this.addChild(cursor);

		week = -1;
		makeCols();
		makeWeekdays();
		makeTimes();
		cols.get(today).backgroundColor = 0x55FFFF;
	}

	private function modDay(date:Date):Float {
		return (date.getHours() + (date.getMinutes() + (date.getSeconds()) / 60) / 60) / 24;
	}

	private function makeCols() {
		week++;

		for (j in 0...7) {
			var col:TextField = new TextField();
			addChild(col);

			col.x = xOffset + j * colWidth;
			col.y = yOffset;
			col.text = Std.string(endDate.getDate());

			col.background = true;
			col.backgroundColor = 0xFFFFFF;
			col.border = true;
			col.borderColor = 0x000000;
			col.width = colWidth;
			col.height = colHeight;

			cols.set(Day.fromDate(endDate), col);
			endDate = DateTools.delta(endDate, DateTools.days(1));
		}

		var sunday = DateTools.delta(endDate, -DateTools.days(7));
		for (lecture in scheduleObject) {
			var lecCursor:Int = lecture.curLectureNum;
			do {
				// If lecture is not held on that day continue to next lecture
				if (lecture.exceptions.indexOf(lecCursor) != -1) {
					lecCursor++;
					continue;
				}
				var index = lecCursor % lecture.weekdays.length;
				var weekday = lecture.weekdays[index];
				var start = lecture.times[index].start;
				var date = DateTools.delta(sunday, DateTools.days(weekday) + DateTools.hours(start[0]) + DateTools.minutes(start[1]));

				// If lecture is not held within the range of this week
				if (!Util.DayinRange(lecture.startDate, lecture.endDate, date))
					continue;
				// Lecture will be added since it is on this day in range

				var end = lecture.times[index].end;
				var startFrac = (start[0] + start[1] / 60) / 24;
				var yPos = yOffset + colHeight * startFrac;
				var xPos = xOffset + weekday * colWidth;

				var endFrac = (end[0] + end[1] / 60) / 24;
				var h = colHeight * (endFrac - startFrac);
				var lectureCol = new TextField();
				addChild(lectureCol);

				lectureCol.x = xPos;
				lectureCol.y = yPos;
				lectureCol.text = lecture.title;

				lectureCol.background = true;
				lectureCol.backgroundColor = colors[scheduleObject.indexOf(lecture)];
				lectureCol.border = true;
				lectureCol.borderColor = 0x000000;
				lectureCol.width = colWidth;
				lectureCol.height = h;
				lecCursor++;

				lectureCols.push(lectureCol);
				if (lecture.weekdays.length == 1) break;
			} while (lecture.weekdays[lecCursor % lecture.weekdays.length] >= lecture.weekdays[(lecCursor - 1) % lecture.weekdays.length]);
		}
		this.addChild(cursor);
	}

	private function makeWeekdays() {
		var names:Array<String> = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
		for (i in 0...7) {
			var weekday:TextField = new TextField();
			addChild(weekday);

			weekday.text = names[i];
			weekday.setTextFormat(format);
			weekday.x = xOffset + i * colWidth;
			weekday.y = yOffset - 15;
		}
	}


	private function makeTimes() {
		var times:Array<String> = ["12am", "1am", "2am", "3am", "4am", "5am", "6am", "7am", "8am", "9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm", "7pm", "8pm", "9pm", "10pm", "11pm", "12am"];
		for (i in 0...25) {
			var time:TextField = new TextField();
			addChild(time);

			time.text = times[i];
			time.setTextFormat(format);
			time.x = 0;
			time.y = yOffset - (textHeight) + i * colHeight / 24;
		}
	}

	private function advanceCols() {
		for (col in cols) {
			removeChild(col);
		}
		for (lectureCol in lectureCols) {
			removeChild(lectureCol);
		}
		makeCols();
	}

	public function update(gameDate:Date) {
		//	trace("hi");
		var day = Day.fromDate(gameDate);
		//	trace(today.month+" "+today.day);
		//	trace(day.month+" "+day.day);
		if (!today.equals(day)) {
			if (gameDate.getDay() == 0) {
				advanceCols();
			}
			cols.get(day).backgroundColor = 0x55FFFF;
			cols.get(today).backgroundColor = 0xFFFFFF;
			today = day;
		}
		cursor.x = xOffset + colWidth * gameDate.getDay();
		cursor.y = yOffset + colHeight * modDay(gameDate);
	}
}
