//
//  PreviewVideoViewController.swift
//  SnapchatCamera
//
//  Created by Duc Tran on 4/15/16.
//  Copyright © 2016 Developers Academy. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class PreviewVideoViewController: UIViewController{
    var url: NSURL!
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        
        avPlayer = AVPlayer(URL: url)
        avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(playerItemDidReachEnd(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: avPlayer.currentItem)
        
        let screenRect = UIScreen.mainScreen().bounds
        avPlayerLayer.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)
        self.view.layer.addSublayer(avPlayerLayer)
        
        // cancel button
        self.setUpCancelButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        avPlayer.play()
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        let playerItem = notification.object as! AVPlayerItem
        playerItem.seekToTime(kCMTimeZero)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func setUpCancelButton()
    {
        if cancelButton == nil {
            let cancelImage = UIImage(named: "back_icon")
            let button = UIButton(type: .System)
            button.tintColor = UIColor.whiteColor()
            button.setImage(cancelImage, forState: .Normal)
            button.imageView?.clipsToBounds = false
            button.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
            button.layer.shadowColor = UIColor.blackColor().CGColor
            button.layer.shadowOffset = CGSizeMake(0, 0)
            button.layer.shadowOpacity = 0.4
            button.layer.shadowRadius = 1.0
            button.clipsToBounds = false
            
            cancelButton = button
            
            self.view.addSubview(cancelButton)
            cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), forControlEvents: .TouchUpInside)
            cancelButton.frame = CGRectMake(0, 0, 44, 44)
        }
    }
    
    func cancelButtonTapped(button: UIButton!) {
        print("Cancel button tapped!")
        self.navigationController?.popViewControllerAnimated(true)
    }

}
