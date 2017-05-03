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
            infoId = ((diction.object(forKey: "id") as AnyObject).intValue)!
            let _startTime = diction.object(forKey: "startTime") as! String
            startTime = getDateStringByFormat(getDatebyString(_startTime as NSString), format: "HH:mm:ss")
            duration = ((diction.object(forKey: "intervalTime") as AnyObject).intValue)!
            durationDisplayStr = formatTimeInSeconds(duration, format: localizedString("VIEWCONTRLLER_CELL_TEXT_FORMAT", comment:"%d分%d秒" ), shortFormat:localizedString("VIEWCONTRLLER_CELL_TEXT_FORMAT_SHORT", comment: "%d秒")) as String
            isDurationNormal = (duration <= 30)
            recordInterval = ((diction.object(forKey: "recordInterval") as AnyObject).intValue)!
            isRecordIntervalNormal = (recordInterval <= 600)
            
            if recordInterval > 3600{
                recordIntervalDisplayStr = localizedString("VIEWCONTRLLER_CELL_OVER_AN_HOUR", comment:"超过1小时")
            }else{
                recordIntervalDisplayStr = recordInterval == 0 ? "--":formatTimeInSeconds(recordInterval, format: localizedString("VIEWCONTRLLER_CELL_TEXT_FORMAT", comment:"%d分%d秒" ), shortFormat:localizedString("VIEWCONTRLLER_CELL_TEXT_FORMAT_SHORT", comment: "%d秒")) as String
            }
        }
    }
}
