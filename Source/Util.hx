package;

class Util {
    public static function jsonTimeToDate (gameDate:Date, jsonTime:String) {
	var nums = jsonTime.split("/");
	var weeks = Std.parseInt(nums[0]);
	var days = Std.parseInt(nums[1]);
	var hours = Std.parseInt(nums[2]);
	var minutes = Std.parseInt(nums[3]);
	return DateTools.delta(gameDate, 1000*60*(minutes+60*(hours+24*(days+7*weeks))));
    }
}
