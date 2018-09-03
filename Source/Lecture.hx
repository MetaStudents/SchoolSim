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

class LectureIterator {
    private var startDate:Date;
    private var endDate:Date;
    private var weekdays:Array<Int>;
    private var times:Array<Time>;
    private var homework:Array<Array<Int>>;
    private var exceptions:Array<Int>;

    public var project:Int;
    public var title:String;

    private var curLecture:LectureObject;
    private var curLectureNum:Int;
    private var curHW:Int;
    private var nextLecDate:Date;


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
            trace(lecture.title,time.start, time.end,i);
            times.push(time);
            weekdays.push(i.weekday);
        }

        this.endDate = new Date(lecture.end.year, lecture.end.month, lecture.end.day, 0, 0, 0);
        this.homework = lecture.homework;
        this.title = lecture.title;
        this.exceptions = lecture.exception;
        this.curLectureNum = 0;
        this.curHW = 0;
        this.project = lecture.project;
        this.nextLecDate = startDate;
    }

    public function getCurLecture():LectureObject {
        return curLecture;
    }

    //TODO spontaneous
    public function next():LectureObject {
        while (exceptions.indexOf(curLectureNum) != -1) {
            nextDate();
            curLectureNum++;
        }
        if (nextLecDate == null) return null;

        var index = curLectureNum % times.length;
        var delta:Float = DateTools.hours(times[index].end[0] - nextLecDate.getHours()) +
            DateTools.minutes(times[index].end[1]) - nextLecDate.getMinutes();
        var endTime = DateTools.delta(nextLecDate, delta);
        var hw:Bool = false;
        var weight:Int = 0;
        if (curHW < homework.length) {
            hw = homework[curHW][0] != 0;
            weight = homework[curHW][0];
            homework[curHW][1]--;
            if (homework[curHW][1] == 0) curHW++;
        }

        curLecture = {startTime: nextLecDate, endTime: endTime, hw: hw};
        if (hw) curLecture.weight = weight;

        nextDate();
        curLectureNum++;
        trace(curLecture.startTime);
        return curLecture;
    }

    public function hasNext():Bool {
        return nextLecDate != null;
    }

    private function nextDate() {
        var nextIndex = (curLectureNum + 1) % weekdays.length;
        var next = weekdays[nextIndex];
        var nextStart = times[nextIndex].start;
        var curLecDate = curLecture.startTime;

        var delta:Float = DateTools.days(next - curLecDate.getDay()) + DateTools.hours(nextStart[0] - curLecDate.getHours())
            + DateTools.minutes(nextStart[1] - curLecDate.getMinutes());

        if (delta <= 0)
            delta += DateTools.days(7);

        var nextDate = DateTools.delta(curLecDate, delta);
        if (Util.DayinRange(startDate, endDate, nextDate))
            nextLecDate = nextDate;
        else nextLecDate = null;
    }
}

typedef LectureObject = {
    public var startTime:Date;
    public var endTime:Date;
    @:optional public var hwDueTime:Date;
    @:optional public var weight:Int;
    public var hw:Bool;
}

class Time {
    public var start:Array<Int>;
    public var end:Array<Int>;

    public function new(start, end) {this.start = start; this.end = end;}
}
