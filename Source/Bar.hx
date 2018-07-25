package;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.text.TextField;
import openfl.events.MouseEvent;

class Bar extends Sprite
{
    private var nameHeight = 15;
    private var cursor:Shape;
    private var barWidth = 40;
    private var movable:Sprite;
    private var column:Shape;
    private var nameField:TextField;
    private var interestRate:Float;
    private var workRate:Float;
    private var working:Bool;
    // interestRate is the proportion of the total that increases per day

    public function new(interestRate:Float, workRate:Float, startHeight:Int, nameStr:String) {
	super();

	movable = new Sprite();
	movable.x = movable.y = 0;
	column = new Shape();
	column.graphics.lineStyle(0);
	column.graphics.beginFill(0x000000, 1);
	column.graphics.drawRect(Math.round(barWidth/2),0,barWidth,1000);
	column.graphics.endFill();
	movable.addChild(column);

	nameField = new TextField();
	nameField.text = nameStr;
	nameField.x = Math.round(barWidth/2);
	nameField.y = -nameHeight;
	movable.addChild(nameField);

	addChild(movable);
	movable.x = 0;
	movable.y = -startHeight;
	movable.addEventListener(MouseEvent.MOUSE_DOWN,
				 function (e:MouseEvent)
				 {working=true;});
	movable.addEventListener(MouseEvent.MOUSE_UP,
				 function (e:MouseEvent)
				 {working=false;});
	movable.addEventListener(MouseEvent.MOUSE_OUT,
				 function (e:MouseEvent)
				 {working=false;});

	this.interestRate = interestRate;
	this.workRate = workRate;
    }

    public function update(delta:Float) {
    	accrueInterest(delta);
	if (working){
	    work(delta);
	}
    }

    private function accrueInterest(delta:Float) {
	trace(interestRate+" "+delta/(3600*24)+" "+movable.y);
	movable.y += interestRate*(delta/(3600*24))*movable.y; // make movable.y more negative
    }

    private function work(delta:Float) {
	trace(workRate * delta/(3600*24));
        movable.y += workRate * delta/(3600*24);
    }
}
