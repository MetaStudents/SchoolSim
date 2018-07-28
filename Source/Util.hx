package;

class Util {
    public static function splitAndParseInt(str:String, delim:String){
		var result:Array<Int> = new Array();
		for (x in str.split(delim)){
			result.push(Std.parseInt(x));
		}
		return result;
    }
    public static function jsonTimeToDate (gameDate:Date, jsonTime:String) {
		var nums = splitAndParseInt(jsonTime, "/");
		var weeks = nums[0];//Std.parseInt(nums[0]);
		var days = nums[1];//Std.parseInt(nums[1]);
		var hours = nums[2];//Std.parseInt(nums[2]);
		var minutes = nums[3];//Std.parseInt(nums[3]);
		return DateTools.delta(gameDate, 1000*60*(minutes+60*(hours+24*(days+7*weeks))));
    }
}
