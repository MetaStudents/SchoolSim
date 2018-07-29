package;

class Day {
    public var month:Int;
    public var day:Int;
	public var year:Int;

    public function new (month:Int, day:Int, year:Int){
		this.month = month;
		this.day = day;
		this.year = year;
    }
    
    public static function fromDate(date:Date){
		return new Day(date.getMonth(), date.getDate(), date.getFullYear());
    }

    public function equals(other:Day){
		return this.hashCode() == other.hashCode();
    }
    
	public function hashCode():Int{
		return month*8+day;
    }

}
