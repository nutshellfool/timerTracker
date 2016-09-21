//
//  SettingsViewController.swift
//  TimerTracker
//
//  Created by Richard Li on 16/9/17.
//  Copyright © 2016年 lirui.me. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    
    var dbAgent : MBFDBAgent = MBFDBAgent.sharedInstance();
    
    @IBAction func onCloseButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.row == 1  {
            let success = dbAgent.deleteAll();
            if success {
                let alert = UIAlertController(title: "提示", message: "清除成功", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "好", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}
