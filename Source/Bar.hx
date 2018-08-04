package;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.text.TextField;
import openfl.events.MouseEvent;

class Bar extends Sprite
{
    private var nameHeight = 15;
    private var barWidth = 20;
    private var assignments:Array<Assignment>;
    private var heights:Array<Float>;
    private var numAssignments:Int;
    //    private var nameField:TextField;
    private var interestRate:Float;
    private var workRate:Float;
    private var lectures:Array<Lecture>;
    private var lectureNum:Int;
    private var lectureEndDate:Date;
    private var initGameDate:Date;
    private var color:Int;
   
    // interestRate is the proportion of the total that increases per day

    public function new(interestRate:Float, workRate:Float, startHeight:Int, nameStr:String, lectures:Array<Lecture>, gameDate:Date, color:Int=0x000000) {
	super();

	this.color = color;

	assignments = new Array();
	heights = new Array();
	heights.push(0);
	numAssignments = 0;

	this.interestRate = interestRate;
	this.workRate = workRate;
	this.lectures = lectures;
	lectureNum = 0;
	initGameDate = gameDate;
       	lectureEndDate = Util.jsonTimeToDate(initGameDate, lectures[lectureNum].times.split(" ")[1]);
    }

    public function update(gameDate:Date, delta:Float) {
	var i:Int = 0;
	var size:Float;
	// We need a while loop instead of a for loop because numAssignments can change during, and a for loop converts it to a number at the outset
	while (i<numAssignments){
	    size = assignments[i].update(gameDate, delta, heights[i]);
	    if (size == 0){
		removeChild(assignments[i]);
		assignments = assignments.slice(0,i).concat(assignments.slice(i+1));
		numAssignments--;
	    } else {
		heights[i+1] = heights[i] + size;
	    }
	    i++;
	}
	getHomework(gameDate);
    }

    private function getHomework(gameDate:Date){
	if (lectureNum < lectures.length){
	    if (gameDate.getTime() > lectureEndDate.getTime()){
		var size = lectures[lectureNum].size;
		var assignment = new Assignment(size, heights[numAssignments], color, barWidth, interestRate, workRate);
		assignments.push(assignment);
		this.addChild(assignment);
		lectureNum++;
		if (lectureNum < lectures.length){
		    lectureEndDate = Util.jsonTimeToDate(initGameDate, lectures[lectureNum].times.split(" ")[1]);
		}
		numAssignments++;
	    }
	}
    }
}
