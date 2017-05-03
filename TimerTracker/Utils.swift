//
//  utils.swift
//  TimerTracker
//
//  Created by Richard Li on 16/9/19.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

import Foundation

func formatTimeInterval(_ time:TimeInterval) -> String {
    return formatTimeInterval(time, format: "%02i:%02i:%02i") as String
}

func formatTimeInterval(_ time:TimeInterval, format:String) -> NSString {
    let minutes = Int(time) / 60
    let seconds = time - Double(minutes) * 60
    let secondsFraction = seconds - Double(Int(seconds))
    return String(format:format,minutes,Int(seconds),Int(secondsFraction*100)) as NSString
}
func formatTimeInSeconds(_ seconds:Int, format:String, shortFormat:String) -> NSString {
    var formatedStr:String = ""
    let minutes = seconds / 60
    let seconds = seconds % 60
    //        let secondsFraction = seconds - Double(Int(seconds))
    if minutes == 0 {
        formatedStr = String(format:shortFormat, Int(seconds))
    }else{
        formatedStr = String(format:format,minutes,Int(seconds))
    }
    
    return formatedStr as NSString
}

func getDatebyString(_ dateString:NSString) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    return formatter.date(from: dateString as String)!
}

func getDateStringByFormat(_ date:Date, format:String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    let DateInFormat = dateFormatter.string(from: date)
    
    return DateInFormat
}


func getDateFormatString(_ date:Date) -> String {
    //        var todaysDate = NSDate().dateFromString("2015-02-04 23:29:28", format:  "yyyy-MM-dd HH:mm:ss")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    let DateInFormat = dateFormatter.string(from: date)
    
    return DateInFormat
}

func localizedString(_ key:String, comment:String) -> String {
    return NSLocalizedString(key, comment: comment)
}
