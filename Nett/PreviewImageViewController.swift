//
//  PreviewImageViewController.swift
//  Nett
//
//  Created by WeBIM RD on 2016/6/27.
//  Copyright © 2016 WeBIM Services. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

let albumName = "Nett"

class PreviewImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var drawImageView: UIImageView!
    
    
    
    // HIDE STATUS BAR
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // GET IMAGE FROM CAMERA ----------------
    var image: UIImage!
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // GET IMAGE FROM CAMERA ----------------
    
    
    
    // DRAWING FUNCTION ----------------
    var start: CGPoint?
    
    // 觸控開始
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        start = touch.locationInView(self.drawImageView)
    }
    // 觸控移動
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let end = touch.locationInView(self.drawImageView)
        
        if let s = self.start {
            draw(s, end: end)
        }
        self.start = end
    }
    
    func draw(start: CGPoint, end: CGPoint) {
        UIGraphicsBeginImageContext(self.drawImageView.frame.size)
        //初始化
        let context = UIGraphicsGetCurrentContext()
        
        drawImageView?.image?.drawInRect(CGRect(x: 0, y: 0, width: drawImageView.frame.width, height: drawImageView.frame.height))
        
        // 圓滑線型
        CGContextSetLineCap(context, CGLineCap.Round)
        // 線寬
        CGContextSetLineWidth(context, 8)
        // 描繪線顏色
        CGContextSetRGBStrokeColor(context, 255, 251, 0, 1)
        // 獲取觸控點座標
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, start.x, start.y)
        CGContextAddLineToPoint(context, end.x, end.y)
        // 將Path描繪出
        CGContextStrokePath(context)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        drawImageView.image = newImage
    }
    // DRAWING FUNCTION ----------------
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // GET IMAGE FROM CAMERA
        imageView.image = image
        
        
        
        
    }
    
    
    
    

}
