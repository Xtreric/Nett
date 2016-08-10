//
//  MapDetailViewController.swift
//  Nett
//
//  Created by Eric Huang on 2016/8/8.
//  Copyright © 2016年 WeBIM. All rights reserved.
//

import UIKit

class MapDetailViewController: UIViewController {
    
    
    @IBOutlet weak var backMapBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func backMapBtn_Click(sender: AnyObject) {
        print("backMapBtn_Click")
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    
    
}
