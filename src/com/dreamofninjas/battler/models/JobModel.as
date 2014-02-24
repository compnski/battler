package com.dreamofninjas.battler.models
{
	import flash.utils.Dictionary;

	public class JobModel extends BaseUnitModel
	{
		public function JobModel(name:String, job:String, properties:Dictionary)
		{
			super(name, job, properties);
		}

		public static function GetJob(job:String, jp:int):JobModel {
			return new JobModel(job, job, new Dictionary({"jp":jp}));
		}
	}
}