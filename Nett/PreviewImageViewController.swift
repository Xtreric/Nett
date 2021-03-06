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

let drawNormal = UIImage(named: "draw_icon")! as UIImage
let drawHighlight = UIImage(named: "drawBlue_icon")! as UIImage

class PreviewImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    
    @IBOutlet weak var imageView: PhotoView!
    @IBOutlet weak var signatureView: SignatureView!
    @IBOutlet weak var mergeView: PhotoView!

    @IBOutlet weak var saveImageBtn: UIButton!
    @IBOutlet weak var clearSignatureViewBtn: UIButton!
    @IBOutlet weak var retakeBtn: UIButton!
    
    @IBOutlet weak var drawBtn: UIButton!
    @IBOutlet weak var recordSoundBtn: UIButton!
    @IBOutlet weak var playSoundBtn: UIButton!
    @IBOutlet weak var saveSoundBtn: UIButton!
    
    @IBOutlet weak var colorChangeBtn: UIButton!

    
    var albumFound : Bool = false
    var assetCollection: PHAssetCollection = PHAssetCollection()
    var photosAsset: PHFetchResult!
    var assetThumbnailSize:CGSize!
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // GET IMAGE FROM CAMERA
        imageView.image = image
        
        // RECORD SOUND
        setupRecorder()
        
        
        
        // CREATE THE PHOTO FOLDER
        
        //Check if the folder exists, if not, create it
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
        if let first_Obj:AnyObject = collection.firstObject{
            //found the album
            self.albumFound = true
            self.assetCollection = first_Obj as! PHAssetCollection
        }else{
            // Album placeholder for the asset collection, used to reference collection in completion handler
            var albumPlaceholder:PHObjectPlaceholder!
            // create the folder
            NSLog("\nFolder \"%@\" does not exist\nCreating now...", albumName)
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(albumName)
                albumPlaceholder = request.placeholderForCreatedAssetCollection
                },
                completionHandler: {(success:Bool, error:NSError?)in
                    if(success){
                        print("Successfully created folder")
                        self.albumFound = true
                        let collection = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([albumPlaceholder.localIdentifier], options: nil)
                        self.assetCollection = collection.firstObject as! PHAssetCollection
                    }else{
                        print("Error creating folder")
                        self.albumFound = false
                }
            })
        }
    }
    
    


    
    let picker = UIImagePickerController()
    var selectedImage:UIImage?{
        didSet{
            imageView.image = selectedImage
        }
    }
    
    

    // HIDE STATUS BAR ----------------
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    // HIDE STATUS BAR ----------------
    
    
    
    // SAVE IMAGE ----------------
    @IBAction func saveImageBtn_Click(sender: AnyObject) {
        // hide all buttons
        hideButtons()

        // screenshot
        let layer = UIApplication.sharedApplication().keyWindow!.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale); // reconsider size property for your screenshot
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageJPEGRepresentation(screenshot, 0.5)

        //set finalImage to IBOulet UIImageView
        mergeView.image = screenshot
        
        // save original image
        UIImageWriteToSavedPhotosAlbum(self.imageView.getSignatureImage(), nil, nil, nil)
        // save merge image
        if signatureView.hidden == true {
            print("signatureView = hidden, do not save")
        } else {
            print("signatureView = hidden, save")
            UIImageWriteToSavedPhotosAlbum(self.mergeView.getSignatureImage(), nil, nil, nil)
        }
        
        // show all buttons
        showButtons()
        
        // Show alert message: Image Saved
        let alert = UIAlertController(title: "Image Saved", message: "Successful!", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    // DRAWING SIGNATURE ----------------
    @IBAction func drawBtn_Click(sender: AnyObject) {
        if signatureView.hidden == true{
            signatureView.hidden = false
            sender.setImage(drawHighlight,forState: UIControlState.Normal)
        } else {
            signatureView.hidden = true
            sender.setImage(drawNormal,forState: UIControlState.Normal)
        }
    }
    // DRAWING SIGNATURE ----------------
    
    
    
    // CLEAR SIGNATURE VIEW ----------------
    @IBAction func clearSignatureViewBtn_Click(sender: AnyObject) {
        if signatureView.hidden == true {
            print("signatureView = hidden, do not clear")
        } else {
            self.signatureView.clearSignature()
        }
    }
    // CLEAR SIGNATURE VIEW ----------------
    
    
        
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
        }else{
            soundPlayer.stop()
            sender.setTitle("Play", forState: .Normal)
        }
    }
    
    // SAVE SOUND ----------------
    @IBAction func saveSoundBtn_Click(sender: AnyObject) {
        print("saveSoundBtn_Click")
        shakeRecordSoundButton()
    }
    
    // CHANGE COLOR ----------------
    @IBAction func colorChangeBtn_Click(sender: AnyObject) {
        print("colorChangeBtn_Click")
        //self.signatureView.defaultColor = UIColor.cyanColor()
        
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

    
    // HIDE BUTTONS ----------------
    func hideButtons() {
        saveImageBtn.hidden = true
        clearSignatureViewBtn.hidden = true
        retakeBtn.hidden = true
        recordSoundBtn.hidden = true
        playSoundBtn.hidden = true
        //saveSoundBtn.hidden = true
        //colorChangeBtn.hidden = true
        drawBtn.hidden = true
    }
    // HIDE BUTTONS ----------------
    
    
    // SHOW BUTTONS ----------------
    func showButtons() {
        saveImageBtn.hidden = false
        clearSignatureViewBtn.hidden = false
        retakeBtn.hidden = false
        recordSoundBtn.hidden = false
        playSoundBtn.hidden = false
        //saveSoundBtn.hidden = false
        //colorChangeBtn.hidden = false
        drawBtn.hidden = false
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

    
    // SHAKE BUTTON: PLAY SOUND BUTTON ----------------
    func shakePlaySoundButton() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(playSoundBtn.center.x - 10, playSoundBtn.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(playSoundBtn.center.x + 10, playSoundBtn.center.y))
        playSoundBtn.layer.addAnimation(animation, forKey: "position")
    }
    // SHAKE BUTTON: PLAY SOUND BUTTON ----------------
    
    // SHAKE BUTTON: SAVE SOUND BUTTON ----------------
    func shakeRecordSoundButton() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(saveSoundBtn.center.x - 10, saveSoundBtn.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(saveSoundBtn.center.x + 10, saveSoundBtn.center.y))
        saveSoundBtn.layer.addAnimation(animation, forKey: "position")
    }
    // SHAKE BUTTON: SAVE SOUND BUTTON ----------------
    
    

    
    

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

