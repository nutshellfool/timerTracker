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
    
    required init(diction: NSDictionary) {
        if diction.count > 0 {
            infoId = (diction.objectForKey("id")?.integerValue)!
            startTime = diction.objectForKey("startTime") as! String
            duration = (diction.objectForKey("intervalTime")?.integerValue)!
            durationDisplayStr = String.init(format: "%d 秒", duration)
            recordInterval = (diction.objectForKey("recordInterval")?.integerValue)!
            recordIntervalDisplayStr = String.init(format: "%d 秒", recordInterval)
        }
    }
    
}