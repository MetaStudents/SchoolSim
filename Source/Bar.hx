package;

import DateTools;
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.text.TextField;
import openfl.events.MouseEvent;

class Bar extends Sprite {
	private var nameHeight = 15;
	private var barWidth = 20;
	private var assignments:Array<Assignment>;
	private var heights:Array<Float>;
	private var numAssignments:Int;
	//    private var nameField:TextField;
	private var interestRate:Float;
	private var workRate:Float;
	private var lectures:Lecture.LectureObject;
	private var lectureEndDate:Date;
	private var initGameDate:Date;
	private var color:Int;
	private var currentHomework:Int;

	// interestRate is the proportion of the total that increases per day

	public function new(interestRate:Float, workRate:Float, startHeight:Int, nameStr:String, lectures:Lecture.LectureObject, gameDate:Date, color:Int = 0x000000) {
		super();

		this.color = color;

		assignments = new Array();
		heights = new Array();
		heights.push(0);
		numAssignments = 0;

		this.interestRate = interestRate;
		this.workRate = workRate;
		this.lectures = lectures;
		initGameDate = gameDate;

		lectureEndDate = new Date(lectures.startDate.getFullYear(), lectures.startDate.getMonth(), lectures.startDate.getDate(),
		    lectures.times[0].end[0], lectures.times[0].end[1], 0);
		currentHomework = 0;
	}

	public function update(gameDate:Date, delta:Float) {
		var i:Int = 0;
		var size:Float;
		// We need a while loop instead of a for loop because numAssignments can change during, and a for loop converts it to a number at the outset
		while (i < numAssignments) {
			size = assignments[i].update(gameDate, delta, heights[i]);
			if (size == 0) {
				removeChild(assignments[i]);
				assignments = assignments.slice(0, i).concat(assignments.slice(i + 1));
				numAssignments--;
			} else {
				heights[i + 1] = heights[i] + size;
			}
			i++;
		}
		getHomework(gameDate);
	}

	private function getHomework(gameDate:Date) {
		if (lectureEndDate == null) return;
		if (currentHomework < lectures.homework.length) {
			if (gameDate.getTime() < lectures.endDate.getTime() && gameDate.getTime() > lectureEndDate.getTime()) {
				lectures.homework[currentHomework][1]--;
				lectureEndDate = nextHomework(gameDate);

				if (lectures.exceptions.indexOf(lectures.curLectureNum++) != -1) return;

				var size = lectures.homework[currentHomework][0];
				var assignment = new Assignment(size, heights[numAssignments], color, barWidth, interestRate, workRate);
				assignments.push(assignment);
				this.addChild(assignment);
				numAssignments++;
				if (lectures.homework[currentHomework][1] == 0)
					currentHomework++;
			}
		}
	}

	//Returns the next date that a homwork will be due/lecture will occur
	private function nextHomework(gameDate:Date):Date {
		var nextIndex = (lectures.curLectureNum + 1) % lectures.weekdays.length;
		var next = lectures.weekdays[nextIndex];
		var nextStart = lectures.times[nextIndex].end;

		var delta:Float = next - gameDate.getDay();
		
		if (delta < 0 || lectures.weekdays.length == 1) {
			delta = 7 + delta;
		}
		delta = DateTools.days(delta) + DateTools.hours(nextStart[0] - gameDate.getHours()) + DateTools.minutes(nextStart[1] - gameDate.getMinutes());

		var nextDate = DateTools.delta(gameDate, delta);
		if (Util.DayinRange(lectures.startDate, lectures.endDate, nextDate))
			return nextDate;
		return null;
	}
}
