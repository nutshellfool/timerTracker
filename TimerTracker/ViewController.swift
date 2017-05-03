//
//  ViewController.swift
//  TimerTracker
//
//  Created by Richard Li on 16/9/7.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

import UIKit
//import FMDB

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var mainTableview: UITableView!
    @IBOutlet weak var timerDisplayLable: UILabel!
    @IBOutlet weak var recordIntervalLable: UILabel!
    
    var dbAgent : MBFDBAgent = MBFDBAgent.sharedInstance();
    
    var timer = Timer()
    // timerStatus
    // 0.timer off
    // 1.timer on
    var timerStatus = 0
    let timeInterval:TimeInterval = 0.05
    var timeCount:TimeInterval = 0.0
    var timeStartTime:Date? = nil
    var timeEndTime:Date? = nil
    
    var recordInfos:Array<RecordInfoModel>? = nil;
    
    @IBAction func onButtonClicked(_ sender: AnyObject) {
        
    }
    
    @IBAction func onTimerButtonClicked(_ sender: AnyObject) {
        if timerStatus == 0 {
            timerStatus = 1
            actionButton.setTitle(localizedString("VIEWCONTRLLER_ACTION_BUTTON_STOP", comment: "结束"), for: UIControlState())
            if !timer.isValid {
                timeStartTime = Date()
                timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector:#selector(ViewController.onTimerUpaded), userInfo: nil, repeats: true)
                RunLoop.current.add(self.timer, forMode: RunLoopMode.commonModes)
                
                recordIntervalLable.text = ""
                //
                //let delay = 10*Double(NSEC_PER_SEC)
                let delay = 1800*Double(NSEC_PER_SEC)
                let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time) {
                    //
                    // timeout stop the timer
                    //
                    self.timerStatus = 0
                    // stop the timer
                    self.timer.invalidate();
                    self.actionButton.setTitle(localizedString("VIEWCONTRLLER_ACTION_BUTTON_START", comment:"开始"), for: UIControlState())
                    self.timerDisplayLable.text = formatTimeInterval(0) as String
                }
            }
            
        }else{
            timerStatus = 0
            // stop the timer
            timer.invalidate();
            actionButton.setTitle(localizedString("VIEWCONTRLLER_ACTION_BUTTON_START", comment:"开始"), for: UIControlState())
            timeEndTime = Date()
            
            // 保存计时记录
            let latestRecord: NSDictionary = dbAgent.queryLatestRecord()! as NSDictionary
            let insertResult:Bool = dbAgent.insertTimeRecords(getDateFormatString(timeStartTime!) as String, withEndTime: getDateFormatString(timeEndTime!) as String)
            if insertResult {
                var recordInterval:NSString = "0";
                if latestRecord.count > 0 {
                    let latestEndtimeString : NSString = latestRecord.object(forKey: "endTime") as! NSString;
                    let latestRecordDate:Date = getDatebyString(latestEndtimeString)
                    let recordIntervalValue :Int = secondsBetweenDates(latestRecordDate, endDate: timeEndTime!)
                    recordInterval = String(format: "%d", recordIntervalValue) as NSString
                    
                    if recordIntervalValue > 3600 {
                        recordIntervalLable.text = localizedString("VIEWCONTRLLER_INTERVALLABLE_OVER_AN_HOUR", comment:"间隔超过1小时") 
                    } else{
                        recordIntervalLable.text = formatTimeInSeconds(recordIntervalValue, format: localizedString("VIEWCONTRLLER_INTERVALLABLE_TEXT_FORMAT", comment:"间隔　%d分%d秒" ),shortFormat:localizedString("VIEWCONTRLLER_INTERVALLABLE_TEXT_FORMAT_SHORT", comment: "间隔　%d分%d秒")) as String
                    }
                    
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
        actionButton.layer.borderColor = UIColor.blue.cgColor
        
        loadRecordInfos()
        mainTableview.allowsMultipleSelectionDuringEditing = false;
        mainTableview.tableFooterView = UIView(frame: .zero);
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        for recordDict in recordRawData! {
            modelItem = RecordInfoModel(diction: recordDict as! NSDictionary)
            recordArray.append(modelItem)
        }
        recordInfos = recordArray
        
        if recordInfos?.count == 0 {
            recordIntervalLable.text = "--"
            timerDisplayLable.text = formatTimeInterval(0) as String
        }
    }
    
    func onTimerUpaded() {
        timeCount += timeInterval
        timerDisplayLable.text = formatTimeInterval(timeCount) as String
    }
    
    
    
    func secondsBetweenDates(_ startDate: Date, endDate: Date) -> Int
    {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.second], from: startDate, to: endDate, options: [])
        return components.second!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordInfos!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! RecordInfoTableviewCell
        let infoData:RecordInfoModel = recordInfos![indexPath.row]
        cell.contentView.backgroundColor = UIColor.clear
        cell.leftLable.font = cell.leftLable.font.withSize(14)
        
        cell.leftLable.text = infoData.startTime
        cell.centerLable.text = infoData.durationDisplayStr
        cell.rightLable.text = infoData.recordIntervalDisplayStr
        
        if infoData.isDurationNormal {
            cell.centerLable.textColor = UIColor.black
        }else{
            cell.centerLable.textColor = UIColor.red
        }
        
        
        if infoData.isRecordIntervalNormal {
            cell.rightLable.textColor = UIColor.black
        }else{
            cell.rightLable.textColor = UIColor.red
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID") as! RecordInfoTableviewCell
        cell.leftLable.text = localizedString("VIEWCONTRLLER_TABLEVIEW_HEADER_TIME", comment: "时间")
        cell.centerLable.text = localizedString("VIEWCONTRLLER_TABLEVIEW_HEADER_DURATION", comment:"持续")
        cell.rightLable.text = localizedString("VIEWCONTRLLER_TABLEVIEW_HEADER_INTERVAL", comment:"间隔")
        return cell.contentView;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let infoData:RecordInfoModel = recordInfos![indexPath.row]
            let infoId:Int = infoData.infoId
            
            let success:Bool = dbAgent.deleteRecord(byRecordId: infoId as NSNumber);
            if success {
                loadRecordInfos()
                tableView.reloadData()
            }
        }
    }
}

