package;

typedef Lecture = {
	var days:Int;
	var interval:String;
	var start:SSDate;
	var end:SSDate;
    var size:Int;
    var title:String;
}

typedef SSDate = {
	var day:Int;
	var month:Int;
	var year:Int;
}

class LectureObject {
	public var startDate:Date;
	public var endDate:Date;
	public var days:Int;
	public var interval:String;
	public var size:Int;
	public var title:String;
	
	public function new (lecture:Lecture){
		var start = Util.splitAndParseInt(lecture.interval.split("-")[0], ":");
		
		this.startDate = new Date(lecture.start.year, lecture.start.month, lecture.start.day, start[0], start[1], 0);
		var delta = 0;
		
		while ((lecture.days >> (6 - delta - startDate.getDay())) & 1 != 1)
			delta++;
		
		startDate = DateTools.delta(this.startDate, DateTools.days(delta));
		
		this.endDate = new Date(lecture.end.year, lecture.end.month, lecture.end.day, 0, 0, 0);
		this.days = lecture.days;
		this.size = lecture.size;
		this.title = lecture.title;
		this.interval = lecture.interval;
	}
}