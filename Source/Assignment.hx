package;

import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.text.TextField;
import openfl.events.MouseEvent;

class Assignment extends Sprite {
    private var rect:Shape;
    private var workRect:Shape;
    private var workSize:Float;
    private var workRate:Float;
    private var color:Int;
    private var barWidth:Int;
    private var working:Bool;
    private var size:Float;
    private var interestRate:Float;

    public function new(size:Float, height:Float, color:Int, barWidth:Int, interestRate:Float, workRate:Float) {
        super();

        this.color = color;
        this.barWidth = barWidth;
        this.size = size;
        this.interestRate = interestRate;
        this.workRate = workRate;
        this.y = -height;

        working = false;

        rect = new Shape();
        workRect = new Shape();
        workSize = 0;
        drawRectangle(rect, size, color);
        addChild(rect);
        addChild(workRect);

        this.addEventListener(MouseEvent.MOUSE_DOWN,
        function(e:MouseEvent) {working = true;});
        this.addEventListener(MouseEvent.MOUSE_UP,
        function(e:MouseEvent) {working = false;});
        this.addEventListener(MouseEvent.MOUSE_OUT,
        function(e:MouseEvent) {working = false;});
    }

    private function drawRectangle(shape:Shape, size:Float, color:Int) {
        shape.graphics.clear();
        shape.graphics.lineStyle(0);
        shape.graphics.beginFill(color, 1);
        shape.graphics.drawRect(-Math.round(barWidth / 2), -size, barWidth, size);
        shape.graphics.endFill();
    }

    public function update(gameDate:Date, delta:Float, height:Float):Float {//returns size
        accrueInterest(delta);
        this.y = -height;
        if (working) {
            work(delta);
            if (workSize >= size) {
                size = 0; // This is an indication that the assignment is done
            }
        }
        return size;
    }

    private function accrueInterest(delta:Float) {
        size += interestRate * (delta / (3600 * 24)) * (size - workSize); // only get interest on part that you didn't do yet
        drawRectangle(rect, size, color);
    }

    private function work(delta:Float) {
        workSize += workRate * delta / (3600 * 24);
        drawRectangle(workRect, workSize, 0x555555);
    }
}
