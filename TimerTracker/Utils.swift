//
//  utils.swift
//  TimerTracker
//
//  Created by Richard Li on 16/9/19.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

import Foundation

func formatTimeInterval(time:NSTimeInterval) -> String {
    return formatTimeInterval(time, format: "%02i:%02i:%02i") as String
}

func formatTimeInterval(time:NSTimeInterval, format:String) -> NSString {
    let minutes = Int(time) / 60
    let seconds = time - Double(minutes) * 60
    let secondsFraction = seconds - Double(Int(seconds))
    return String(format:format,minutes,Int(seconds),Int(secondsFraction*100))
}
func formatTimeInSeconds(seconds:Int, format:String, shortFormat:String) -> NSString {
    var formatedStr:String = ""
    let minutes = seconds / 60
    let seconds = seconds % 60
    //        let secondsFraction = seconds - Double(Int(seconds))
    if minutes == 0 {
        formatedStr = String(format:shortFormat, Int(seconds))
    }else{
        formatedStr = String(format:format,minutes,Int(seconds))
    }
    
    return formatedStr
}

func getDatebyString(dateString:NSString) -> NSDate {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    return formatter.dateFromString(dateString as String)!
}

func getDateStringByFormat(date:NSDate, format:String) -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = format
    let DateInFormat = dateFormatter.stringFromDate(date)
    
    return DateInFormat
}


func getDateFormatString(date:NSDate) -> String {
    //        var todaysDate = NSDate().dateFromString("2015-02-04 23:29:28", format:  "yyyy-MM-dd HH:mm:ss")
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    let DateInFormat = dateFormatter.stringFromDate(date)
    
    return DateInFormat
}

func localizedString(key:String, comment:String) -> String {
    return NSLocalizedString(key, comment: comment)
}
