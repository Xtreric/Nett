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
    
    
    @IBOutlet weak var imageView: PhotoView!
    @IBOutlet weak var signatureView: SignatureView!
    @IBOutlet weak var mergeView: SignatureView!

    @IBOutlet weak var saveImageBtn: UIButton!
    @IBOutlet weak var clearSignatureViewBtn: UIButton!
    @IBOutlet weak var retakeBtn: UIButton!
    
    @IBOutlet weak var recordSoundBtn: UIButton!
    @IBOutlet weak var playSoundBtn: UIButton!
    @IBOutlet weak var saveSoundBtn: UIButton!
    

    
    // HIDE STATUS BAR
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


    let picker = UIImagePickerController()
    var selectedImage:UIImage?{
        didSet{
            imageView.image = selectedImage
        }
    }
    
    
    // SAVE IMAGE ----------------
    @IBAction func saveImageBtn_Click(sender: AnyObject) {
        print("drawBtn_Click")
        
        // hide all buttons
        hideButtons()

        
        let layer = UIApplication.sharedApplication().keyWindow!.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale); // reconsider size property for your screenshot
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        //set finalImage to IBOulet UIImageView
        mergeView.image = screenshot
        
        
        // save original image
        UIImageWriteToSavedPhotosAlbum(self.imageView.getSignatureImage(), nil, nil, nil)
        // save merge image
        UIImageWriteToSavedPhotosAlbum(self.mergeView.getSignatureImage(), nil, nil, nil)
        
        
        // show all buttons
        showButtons()
        
        // Show alert message: Image Saved
        let alert = UIAlertController(title: "Image Saved", message: "Successful!", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    // CLEAR SIGNATURE VIEW ----------------
    @IBAction func clearSignatureViewBtn_Click(sender: AnyObject) {
        print("clearSignatureViewBtn_Click")
        signatureView.image = nil
    }
    
    // RETAKE ----------------
    @IBAction func retakeBtn_Click(sender: AnyObject) {
        print("retakeBtn_Click")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // RECORD SOUND ----------------
    @IBAction func recordSoundBtn_Click(sender: AnyObject) {
        if sender.titleLabel?!.text == "Record"{
            soundRecorder.record()
            sender.setTitle("Stop", forState: .Normal)
            playSoundBtn.enabled = false
        } else {
            soundRecorder.stop()
            sender.setTitle("Record", forState: .Normal)
            playSoundBtn.enabled = true
        }
    }

    // PLAY SOUND ----------------
    @IBAction func playSoundBtn_Click(sender: AnyObject) {
        if sender.titleLabel?!.text == "Play" {
            recordSoundBtn.enabled = false
            sender.setTitle("Stop", forState: .Normal)
            preparePlayer()
            soundPlayer.play()
        } else{
            soundPlayer.stop()
            sender.setTitle("Play", forState: .Normal)
        }
    }
    
    // SAVE SOUND ----------------
    @IBAction func saveSoundBtn_Click(sender: AnyObject) {
        print("saveSoundBtn_Click")
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
        start = touch.locationInView(self.signatureView)
    }
    // 觸控移動
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let end = touch.locationInView(self.signatureView)
        
        if let s = self.start {
            draw(s, end: end)
        }
        self.start = end
    }
    
    func draw(start: CGPoint, end: CGPoint) {
        UIGraphicsBeginImageContext(self.signatureView.frame.size)
        //初始化
        let context = UIGraphicsGetCurrentContext()
        
        signatureView?.image?.drawInRect(CGRect(x: 0, y: 0, width: signatureView.frame.width, height: signatureView.frame.height))
        
        // 圓滑線型
        CGContextSetLineCap(context, CGLineCap.Round)
        // 線寬
        CGContextSetLineWidth(context, 4)
        // 描繪線顏色
        CGContextSetRGBStrokeColor(context, 255, 251, 0, 1)
        // 獲取觸控點座標
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, start.x, start.y)
        CGContextAddLineToPoint(context, end.x, end.y)
        // 將Path描繪出
        CGContextStrokePath(context)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        signatureView.image = newImage
        
    }
    // DRAWING FUNCTION ----------------


    
    // HIDE BUTTONS ----------------
    func hideButtons() {
        saveImageBtn.hidden = true
        clearSignatureViewBtn.hidden = true
        retakeBtn.hidden = true
        recordSoundBtn.hidden = true
        playSoundBtn.hidden = true
        saveSoundBtn.hidden = true
    }
    // HIDE BUTTONS ----------------
    
    // SHOW BUTTONS ----------------
    func showButtons() {
        saveImageBtn.hidden = false
        clearSignatureViewBtn.hidden = false
        retakeBtn.hidden = false
        recordSoundBtn.hidden = false
        playSoundBtn.hidden = false
        saveSoundBtn.hidden = false
    }
    // SHOW BUTTONS ----------------
    
    
    
    
    // SOUND RECORDER ----------------
    // audio record n play
    var soundRecorder : AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
    var AudioFileName = "sound.m4a"
    
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
                          AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
                          AVNumberOfChannelsKey : NSNumber(int: 1),
                          AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]

    //HELPERS
    func preparePlayer(){
        do {
            try soundPlayer = AVAudioPlayer(contentsOfURL: directoryURL()!)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        } catch {
            print("Error playing")
        }
    }
    
    func directoryURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent("sound.m4a")
        return soundURL
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        playSoundBtn.enabled = true
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        recordSoundBtn.enabled = true
        playSoundBtn.setTitle("Play", forState: .Normal)
    }
    
    func setupRecorder(){
        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        
        //ask for permission
        if (audioSession.respondsToSelector(#selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("granted")
                    //set category and activate recorder session
                    do {
                        try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                        try self.soundRecorder = AVAudioRecorder(URL: self.directoryURL()!, settings: self.recordSettings)
                        self.soundRecorder.prepareToRecord()
                    } catch {
                        print("Error Recording");
                    }
                }
            })
        }
    }
    // SOUND RECORDER ----------------
    
    
    

    
    
/*
     func saveImage (image: UIImage, path: String ) -> Bool{
     
     let pngImageData = UIImagePNGRepresentation(drawImageView.image!)
     //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
     
     print("!!!saving image at:  \(path)")
     
     let result = pngImageData!.writeToFile(path, atomically: true)
     
     return result
     }
*/
    
    

/*
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>){
        guard error == nil else{
            showAlertWithTitle("Error", message: error!.localizedDescription)
            return
        }
        showAlertWithTitle(nil, message: "Image Saved")
    }

    func showAlertWithTitle(title:String?, message:String?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
*/
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // GET IMAGE FROM CAMERA
        imageView.image = image
        
        // RECORD SOUND
        setupRecorder()
        
        
    }
    
    
    
    //Mark: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.selectedImage = selectedImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

}
