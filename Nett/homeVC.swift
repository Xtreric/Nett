//
//  homeVC.swift
//  Stage
//
//  Created by WeBIM RD on 2016/6/24.
//  Copyright © 2016 WeBIM Services. All rights reserved.
//

import UIKit

class homeVC: UIViewController {
    
    
    @IBOutlet weak var useridLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var companyidLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBAction func logoutBtn_Click(sender: AnyObject) {
        curUserData.AccessToken = ""
        //print("token: \(curUserData.AccessToken)")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // showUserData founction (user = curUserData)
        showUserData(curUserData)
    }
    
    // 將存在curUserData變數的值讀過來的方法
    func showUserData (user: UserData) {
        // 非同步作業
        dispatch_async(dispatch_get_main_queue()) {
            
            self.useridLbl.text = String(user.UserID)
            self.nameLbl.text = user.Name
            self.unitLbl.text = user.Unit
            self.titleLbl.text = user.Title
            self.emailLbl.text = user.Email
            self.companyidLbl.text = String(user.CompanyID)
            
        }
    }

    
}
