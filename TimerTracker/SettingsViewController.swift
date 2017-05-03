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
    
    var dbAgent : MBFDBAgent = MBFDBAgent.sharedInstance()
    
    @IBAction func onCloseButtonClicked(_ sender: AnyObject) {
        self.dismiss(animated: true) { 
            
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row == 1  {
            let  alertView = UIAlertController(title: localizedString("SETTINGSVIEWCONTROLLER_DELETE_ALERT_TITLE", comment:"确认删除记录？" ), message: localizedString("SETTINGSVIEWCONTROLLER_DELETE_ALERT_CONTENT", comment:"确认是否删除所有记录？此操作不可恢复。" ), preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: localizedString("OK", comment:"好"), style: UIAlertActionStyle.default, handler: {  action in
                let success = self.dbAgent.deleteAll()
                if success {
                    let alert = UIAlertController(title: localizedString("SETTINGSVIEWCONTROLLER_DELETE_SUCCESS_ALERT_TITLE", comment:"提示"), message: localizedString("SETTINGSVIEWCONTROLLER_DELETE_SUCCESS_ALERT_CONTENT", comment:"清除成功" ), preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: localizedString("OK", comment:"好"), style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }))
            alertView.addAction(UIAlertAction(title: localizedString("CANCEL", comment:"取消"), style: .cancel, handler:nil))
            self.present(alertView, animated: true, completion: { 
                
            })
        }
    }
}
