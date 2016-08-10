//
//  CustomInfoWindow.swift
//  Nett
//
//  Created by Eric Huang on 2016/7/27.
//  Copyright © 2016年 WeBIM. All rights reserved.
//

import UIKit

class CustomInfoWindow: UIView {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet var label: UILabel!
    @IBOutlet weak var nextPageBtn: UIButton!
    @IBOutlet weak var infoImage: UIImageView!
    
    
    @IBAction func nextPageBtn_Click(sender: AnyObject) {
        print("hey")
    }
}
