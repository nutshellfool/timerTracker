//
//  ViewController.swift
//  TimerTracker
//
//  Created by Richard Li on 16/9/7.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

import UIKit
import FMDB

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var mainTableview: UITableView!
    @IBOutlet weak var timerDisplayLable: UILabel!
    @IBOutlet weak var recordIntervalLable: UILabel!
    
    var dbAgent : MBFDBAgent = MBFDBAgent.sharedInstance();
    
    var timer = NSTimer()
    // timerStatus
    // 0.timer off
    // 1.timer on
    var timerStatus = 0
    let timeInterval:NSTimeInterval = 0.05
    var timeCount:NSTimeInterval = 0.0
    var timeStartTime:NSDate? = nil
    var timeEndTime:NSDate? = nil
    
    var recordInfos:Array<RecordInfoModel>? = nil;
    
    @IBAction func onButtonClicked(sender: AnyObject) {
        
    }
    
    @IBAction func onTimerButtonClicked(sender: AnyObject) {
        if timerStatus == 0 {
            timerStatus = 1
            actionButton.setTitle("结束", forState: UIControlState.Normal)
            if !timer.valid {
                timeStartTime = NSDate()
                timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector:#selector(ViewController.onTimerUpaded), userInfo: nil, repeats: true)
                
                //
                //let delay = 10*Double(NSEC_PER_SEC)
                let delay = 1800*Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {
                    //
                    // timeout stop the timer
                    //
                    self.timerStatus = 0
                    // stop the timer
                    self.timer.invalidate();
                    self.actionButton.setTitle("开始", forState: UIControlState.Normal)
                    self.timerDisplayLable.text = formatTimeInterval(0) as String
                }
            }
            
        }else{
            timerStatus = 0
            // stop the timer
            timer.invalidate();
            actionButton.setTitle("开始", forState: UIControlState.Normal)
            timeEndTime = NSDate()
            
            // 保存计时记录
            let latestRecord: NSDictionary = dbAgent.queryLatestRecord()
            let insertResult:Bool = dbAgent.insertTimeRecords(getDateFormatString(timeStartTime!) as String, withEndTime: getDateFormatString(timeEndTime!) as String)
            if insertResult {
                var recordInterval:NSString = "0";
                if latestRecord.count > 0 {
                    let latestEndtimeString : NSString = latestRecord.objectForKey("endTime") as! NSString;
                    let latestRecordDate:NSDate = getDatebyString(latestEndtimeString)
                    let recordIntervalValue :Int = secondsBetweenDates(latestRecordDate, endDate: timeEndTime!)
                    recordInterval = String(format: "%d", recordIntervalValue)
                    recordIntervalLable.text = formatTimeInSeconds(recordIntervalValue, format: "间隔　%02i分%02i秒") as String
                }
                dbAgent.insertRecordInfos(getDateFormatString(timeStartTime!), withEndTime: getDateFormatString(timeEndTime!), withInterval:NSString(format:"%f", timeCount) as String , withRecordInterval: recordInterval as String)
                loadRecordInfos()
                mainTableview.reloadData()
                
            }
            
            
            timeStartTime = nil
            timeEndTime = nil
            timeCount = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        actionButton.layer.cornerRadius = 10
        actionButton.layer.borderWidth = 1.0
        actionButton.layer.borderColor = UIColor.blueColor().CGColor
        
        loadRecordInfos()
        mainTableview.allowsMultipleSelectionDuringEditing = false;
        mainTableview.tableFooterView = UIView(frame: .zero);
        recordIntervalLable.text = "--"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        loadRecordInfos()
        mainTableview.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadRecordInfos(){
        let recordRawData = dbAgent.queryRecordInfos();
        var recordArray:Array<RecordInfoModel> = Array()
        var modelItem:RecordInfoModel;
        for recordDict in recordRawData {
            modelItem = RecordInfoModel(diction: recordDict as! NSDictionary)
            recordArray.append(modelItem)
        }
        recordInfos = recordArray
    }
    
    func onTimerUpaded() {
        timeCount += timeInterval
        timerDisplayLable.text = formatTimeInterval(timeCount) as String
    }
    
    
    
    func secondsBetweenDates(startDate: NSDate, endDate: NSDate) -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Second], fromDate: startDate, toDate: endDate, options: [])
        return components.second
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordInfos!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! RecordInfoTableviewCell
        let infoData:RecordInfoModel = recordInfos![indexPath.row]
        
        cell.leftLable.text = infoData.startTime
        cell.centerLable.text = infoData.durationDisplayStr
        cell.rightLable.text = infoData.recordIntervalDisplayStr
        
        if infoData.isDurationNormal {
            cell.centerLable.textColor = UIColor.redColor()
        }else{
            cell.centerLable.textColor = UIColor.blackColor()
        }
        
        
        if infoData.isRecordIntervalNormal {
            cell.rightLable.textColor = UIColor.redColor()
        }else{
            cell.rightLable.textColor = UIColor.blackColor()
        }

        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID") as! RecordInfoTableviewCell
        cell.leftLable.text = "时间"
        cell.centerLable.text = "持续"
        cell.rightLable.text = "间隔"
        return cell;
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let infoData:RecordInfoModel = recordInfos![indexPath.row]
            let infoId:Int = infoData.infoId
            
            let success:Bool = dbAgent.deleteRecordByRecordId(infoId);
            if success {
                loadRecordInfos()
                tableView.reloadData()
            }
        }
    }
}

