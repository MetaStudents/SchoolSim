package;

typedef Lecture = {
	var days:Array<LectureDay>;
	var start:SSDate;
	var end:SSDate;
    var size:Int;
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
	public var times:Array<String>;
	public var size:Int;
	public var title:String;
	
	public function new (lecture:Lecture){
		var start = Util.splitAndParseInt(lecture.days[0].time.split("-")[0], ":");
		
		this.startDate = new Date(lecture.start.year, lecture.start.month, lecture.start.day, start[0], start[1], 0);
		var delta = lecture.days[0].weekday - startDate.getDay();
		
		startDate = DateTools.delta(this.startDate, DateTools.days(delta));
		
		this.times = new Array<String>();
		this.weekdays = new Array<Int>();
		for (i in lecture.days) {
			times.push(i.time);
			weekdays.push(i.weekday);
		}
		this.endDate = new Date(lecture.end.year, lecture.end.month, lecture.end.day, 0, 0, 0);
		this.size = lecture.size;
		this.title = lecture.title;
	}
}