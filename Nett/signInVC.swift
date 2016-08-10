//
//  signInVC.swift
//  Nett
//
//  Created by WeBIM RD on 2016/6/23.
//  Copyright © 2016 WeBIM Services. All rights reserved.
//

import UIKit

class signInVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    @IBOutlet weak var memoryUserBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginActivity: UIActivityIndicatorView!

    let memoryChecked = UIImage(named: "checkbox-checked")
    let memoryUnchecked = UIImage(named: "checkbox-unchecked")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide activity indicator view
        loginActivity.hidden = true
        
        loginActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        loginActivity.color = UIColor.purpleColor()
        
        memoryUserBtn.setImage(memoryUnchecked, forState: .Normal)
        memoryUserBtn.setImage(memoryChecked, forState: .Highlighted)

        shouldAutorotate()
        supportedInterfaceOrientations()
        
        // Press “Return” on the keyboard, then hide keyboard
        textFieldInitial()
        
        // Hide keyboard when tap anywhere
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // activity indicator view play
        activityStop()
        // hide activity indicator view
        loginActivity.hidden = true
    }
    

    @IBAction func memoryUserBtn_Click(sender: AnyObject) {
        print("memory User button clicked")
    }
    
    
    @IBAction func forgetPasswordBtn_Click(sender: AnyObject) {
        print("forget password button clicked")
    }
    
    @IBAction func loginBtn_Click(sender: AnyObject) {
        loginActivity.hidden = false
        // activity indicator view play
        activityPlay()
        
        
        // hide keyboard
        self.view.endEditing(true)
        // if textfields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            // show alert message
            let alert = UIAlertController(title: "Please", message: "fill in fields", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        // 儲存資料 - defaultsKeys的UserTokenJson
        defaults.setValue("", forKey: defaultsKeys.UserTokenJson)
        
        let pfd = getToken { (jsonString) in
            defaults.setValue(jsonString, forKey: defaultsKeys.UserTokenJson)
            
            let pfd1 = self.getUserData { (jsonString1) in
                let jsonUserData = jsonString1.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
                do {
                    let objects = try NSJSONSerialization.JSONObjectWithData(jsonUserData, options: []) as! NSArray
                    for obj in objects {
                        guard let jsonUserID = obj["UserID"] as? Int,
                            let jsonName = obj["Name"] as? String,
                            let jsonUnit = obj["Unit"] as? String,
                            let jsonTitle = obj["Title"] as? String,
                            let jsonCompanyID = obj["CompanyID"] as? Int,
                            let jsonEmail = obj["Email"] as? String
                            else { return }
                        // 存每一項到curUserData變數的項目當中
                        curUserData.UserID = jsonUserID
                        curUserData.Name = jsonName
                        curUserData.Unit = jsonUnit
                        curUserData.Title = jsonTitle
                        curUserData.CompanyID  = jsonCompanyID
                        curUserData.Email  = jsonEmail
                    }
                    // 透過performSegueWithIdentifier切換到HomeVC
                    self.performSegueWithIdentifier("toHomeVC", sender: self)
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        }
    }

    // POST-bodyStr至myURL，得到Token資料
    func getToken(completion: (NSString) -> ()) {
        let username: String = (usernameTxt.text?.URLEncoded)!
        let password: String = (passwordTxt.text?.URLEncoded)!
        
        let bodyStr: String = "grant_type=password&username=" + username + "&password=" + password
        let myURL = NSURL(string: "http://webim.com.tw/webimcloud/token")!
        let request = NSMutableURLRequest(URL: myURL)
        request.HTTPMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)!
        
        // 以Token的資料撈出相關資料
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if let data = data,
                jsonString = NSString(data: data, encoding: NSUTF8StringEncoding)
                where error == nil {
                completion(jsonString)
            } else {
                print("error=\(error!.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
    func getUserData(completion: (NSString) -> ()) {
        // 讀取資料
        let defaults = NSUserDefaults.standardUserDefaults()
        if let userTokenString = defaults.stringForKey(defaultsKeys.UserTokenJson) {
            let userTokenData = userTokenString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
            do {
                let object = try NSJSONSerialization.JSONObjectWithData(userTokenData, options: []) as! [String: AnyObject]
                guard let jsonToken = object["access_token"] as? String,
                      let jsonUserName = object["userName"] as? String
                else { return }
                curUserData.AccessToken = jsonToken
                curUserData.Name = jsonUserName
                //print("token: \(curUserData.AccessToken)")
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
            // Setup the request
            let pars: String = "email=" + curUserData.Name!.URLEncoded
            let myURL = NSURL(string: "http://webim.com.tw/webimcloud/api/UsersAPI?" + pars)!
            let request = NSMutableURLRequest(URL: myURL)
            request.HTTPMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer " + curUserData.AccessToken!, forHTTPHeaderField: "Authorization")
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                if let data = data,
                    jsonString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    where error == nil {
                    completion(jsonString)
                } else {
                    print("error=\(error!.localizedDescription)")
                    
                }
            }
            task.resume()
        }
        
    }
    
    
    // 進度條開始轉動
    func activityPlay() {
        loginActivity.startAnimating()
    }
    
    // 進度條停止轉動
    func activityStop() {
        loginActivity.stopAnimating()
    }
    
    
    // unable AUTO-ROTATE
    override func shouldAutorotate() -> Bool {
        return false
    }
    // only support PORTRAIT monitor
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    
    // function of press “Return” then hide keyboard
    func textFieldInitial() {
        // UITextField初始化
        let dyTextFieldUsername: UITextField = usernameTxt
        let dyTextFieldPassword: UITextField = passwordTxt
        // Delegate
        dyTextFieldUsername.delegate = self
        dyTextFieldPassword.delegate = self
        // 框線樣式
        //dyTextField.borderStyle = UITextBorderStyle.RoundedRect
        // 將TextField加入View
        self.view.addSubview(dyTextFieldUsername)
        self.view.addSubview(dyTextFieldPassword)
    }
    // press "RETURN"
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // TextField clicked, move up UI
    func textFieldDidBeginEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 180), animated: true)
    }
    // TextField clicked, move down UI
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    
    
    





}
