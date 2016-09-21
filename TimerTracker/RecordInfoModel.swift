//
//  RecordInfoModel.swift
//  TimerTracker
//
//  Created by Richard Li on 16/9/17.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

import Foundation

class RecordInfoModel: NSObject {
    var startTime:String = ""
    var startTimeDisplayStr:String = ""
    var infoId:Int = 0
    var duration = 0
    var durationDisplayStr:String = ""
    var recordInterval = 0
    var recordIntervalDisplayStr:String = ""
    var isDurationNormal:Bool = true
    var isRecordIntervalNormal:Bool = true
    
    
    required init(diction: NSDictionary) {
        if diction.count > 0 {
            infoId = (diction.objectForKey("id")?.integerValue)!
            let _startTime = diction.objectForKey("startTime") as! String
            startTime = getDateStringByFormat(getDatebyString(_startTime), format: "HH:mm:ss")
            duration = (diction.objectForKey("intervalTime")?.integerValue)!
            durationDisplayStr = String.init(format: "%d 秒", duration)
            isDurationNormal = (duration <= 30)
            recordInterval = (diction.objectForKey("recordInterval")?.integerValue)!
            recordIntervalDisplayStr = recordInterval == 0 ? "--":formatTimeInSeconds(recordInterval, format: "%02i分%02i秒") as String
            isRecordIntervalNormal = (recordInterval <= 600)
        }
    }
    
}
