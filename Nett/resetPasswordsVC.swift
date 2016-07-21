//
//  resetPasswordsVC.swift
//  Nett
//
//  Created by WeBIM RD on 2016/6/27.
//  Copyright © 2016 WeBIM Services. All rights reserved.
//

import UIKit

class resetPasswordsVC: UIViewController, UITextFieldDelegate {


    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        shouldAutorotate()
        supportedInterfaceOrientations()
        
        // Press “Return” on the keyboard, then hide keyboard
        textFieldInitial()
        
        // Hide keyboard when tap anywhere
        self.hideKeyboardWhenTappedAround()
        
    }
    
    
    @IBAction func resetBtn_Click(sender: AnyObject) {
        // hide keyboard
        self.view.endEditing(true)
        
        // validate email format
        if(emailTxt.text!.isEmail){
            print("This is an email type")
            //*********************************************
            //*********************************************
            //*********************************************
            // show alert message (信箱正確)
            let alert = UIAlertController(title: "信箱正確", message: "使用者密碼已傳至指定信箱", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            // show alert message (信箱有誤)
            let alert = UIAlertController(title: "信箱有誤", message: "請輸入註冊信箱", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        // if email field is empty (信箱欄位空白)
        if emailTxt.text!.isEmpty {
            // show alert message
            let alert = UIAlertController(title: "信箱欄位空白", message: "請輸入註冊信箱", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }
    
    
    @IBAction func cancelBtn_Click(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        let dyTextField: UITextField = emailTxt
        // Delegate
        dyTextField.delegate = self
        // 框線樣式
        //dyTextField.borderStyle = UITextBorderStyle.RoundedRect
        // 將TextField加入View
        self.view.addSubview(dyTextField)
    }
    // press "RETURN"
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    // TextField clicked, move up UI
    func textFieldDidBeginEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 250), animated: true)
    }
    // TextField clicked, move down UI
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    


    
}

