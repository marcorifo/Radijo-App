//
//  DetailViewController.swift
//  Radijo App
//
//  Created by Mark Reiff on 01/10/15.
//  Copyright (c) 2015 Mark Reiff. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class DetailViewController: UIViewController {
    
    var radioStationToDisplay:Article?
    var url:NSURL?
    var radioPlayer:AVPlayer = AVPlayer()

    @IBOutlet weak var playPauseButton: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var scheduleButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let titleString = radioStationToDisplay?.radioName {
            
            self.title = titleString
        
        }

//        set navigation controller color to clear
       
//        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
//        navigationController?.navigationBar.translucent = true
//        navigationController?.navigationBar.barStyle = UIBarStyle.Black
//        navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
       

        
        // create a tapgesture recognizer
       
        let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("buttonTapped:"))
        
        let scheduleGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("scheduleTapped:"))
        
        // add tapgesture recognizer to the play/pause button
        
        playPauseButton.addGestureRecognizer(tapGestureRecognizer)
        scheduleButton.addGestureRecognizer(scheduleGestureRecognizer)
        
        // Do any additional setup after loading the view.
        
        // Check if there's an article to display
      
        
        if let actualArticle = self.radioStationToDisplay {
            
            // Create NSURL for the feedURL
            
            url = NSURL(string: actualArticle.radioFeed)
            
            // Create Media Player
            
            self.radioPlayer = AVPlayer(URL: url!)
            radioPlayer.volume = 1.0
            radioPlayer.rate = 1.0
            radioPlayer.play()
            
            
            
            // Let AVPlayer play in background
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                print("AVAudioSession Category Playback OK")
                do {
                    try AVAudioSession.sharedInstance().setActive(true)
                    print("AVAudioSession is Active")
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            // set Lockscreen Info
            
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [MPNowPlayingInfoPropertyPlaybackRate: 1.0, MPMediaItemPropertyArtist : "Radio App", MPMediaItemPropertyTitle : (radioStationToDisplay?.radioName)!]
            
            
            
            
            // set play/pause button to pause image
            
            self.playPauseButton.image = UIImage(named: "Pause")
            
            self.scheduleButton.image = UIImage(named:"White schedule")
            
            let imageView:UIImageView? = backgroundImageView as UIImageView?
            
            // Set cell properties
            
            if let actualImageView = imageView {
                
                // Imageview actually exists
                
                
                
                if actualArticle.backgroundURL != "" {
                    
                    
                    let url:NSURL? = NSURL(string: actualArticle.backgroundURL)
                    let imageRequest = NSURLRequest(URL: url!)
                    
                    
                    
                    // Fire off request to download it
                    
                    let session = NSURLSession.sharedSession()
                    session.dataTaskWithRequest(imageRequest) {(data, response, error) in actualImageView.image? = UIImage(data: data!)!}
                    
                    actualImageView.image = UIImage(data: NSData(contentsOfURL: url!)!)
                    
                    
                    
                }
                
            }
            
        }
       
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Let viewcontroller respond to control center commands
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) { // *
        let rc = event!.subtype
        let p = self.radioPlayer
        print("received remote control \(rc.rawValue)") // 101 = pause, 100 = play
        switch rc {
        case .RemoteControlTogglePlayPause:
            if radioPlayer.rate != 0 { p.pause() } else { p.play() }
        case .RemoteControlPlay:
            p.play()
            self.playPauseButton.image = UIImage(named: "Pause")
        case .RemoteControlPause:
            p.pause()
            self.playPauseButton.image = UIImage(named: "Play")
        default:break
        }
    }
    
    
    
    
    
    func buttonTapped(recognizer:UIGestureRecognizer) {
        
        
        if (radioPlayer.rate != 0 && radioPlayer.error == nil)
        {
            radioPlayer.pause()
            self.playPauseButton.image = UIImage(named: "Play")
        }
        else {
            radioPlayer.play()
            self.playPauseButton.image = UIImage(named: "Pause")
        }
        
    }
    
    func scheduleTapped(recognizer:UIGestureRecognizer) {
        print("schedule tapped")
        self.performSegueWithIdentifier("toSchedule", sender: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

        
    
    


}
