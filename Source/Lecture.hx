package;

typedef Lecture = {
	var days:Array<LectureDay>;
	var start:SSDate;
	var end:SSDate;
	var homework:Array<Array<Int>>;
	var project:Int;
	var exception:Array<Int>;
	var title:String;
}

typedef LectureDay = {
	var weekday:Int;
	var time:String;
}

typedef SSDate = {
	var day:Int;
	var month:Int;
	var year:Int;
}

class LectureObject {
	public var startDate:Date;
	public var endDate:Date;
	public var weekdays:Array<Int>;
	public var times:Array<Time>;
	public var homework:Array<Array<Int>>;
	public var title:String;
	public var exceptions:Array<Int>;
	public var curLectureNum:Int;
	public var project:Int;

	public function new(lecture:Lecture) {
		var start = Util.splitAndParseInt(lecture.days[0].time.split("-")[0], ":");

		this.startDate = new Date(lecture.start.year, lecture.start.month, lecture.start.day, start[0], start[1], 0);
		var delta = lecture.days[0].weekday - startDate.getDay();

		if (delta < 0)
			delta += 7;

		startDate = DateTools.delta(this.startDate, DateTools.days(delta));

		this.times = new Array<Time>();
		this.weekdays = new Array<Int>();
		for (i in lecture.days) {
			var start = Util.splitAndParseInt(i.time.split("-")[0], ":");
			var end = Util.splitAndParseInt(i.time.split("-")[1], ":");

			var time:Time = new Time(start, end);
			times.push(time);
			weekdays.push(i.weekday);
		}
		this.endDate = new Date(lecture.end.year, lecture.end.month, lecture.end.day, 0, 0, 0);
		this.homework = lecture.homework;
		this.title = lecture.title;
		this.exceptions = lecture.exception;
		this.curLectureNum = 0;
		this.project = lecture.project;
	}
}

class Time {
	public var start:Array<Int>;
	public var end:Array<Int>;

	public function new(start, end){this.start = start; this.end = end;}
}
