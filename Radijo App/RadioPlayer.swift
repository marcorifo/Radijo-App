////
////  RadioPlayer.swift
////  Radijo App
////
////  Created by Mark Reiff on 12/11/15.
////  Copyright © 2015 Mark Reiff. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//class RadioPlayer: AVPlayer {
//    
//    // Create Media Player
//    
//    var volume1 = RadioPlayer.volume
//    RadioPlayer.volume = 1.0
//    RadioPlayer.rate = 1.0
//    RadioPlayer.play()
//    
//    
//    
//    // Let AVPlayer play in background
//    do {
//    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//    print("AVAudioSession Category Playback OK")
//    do {
//    try AVAudioSession.sharedInstance().setActive(true)
//    print("AVAudioSession is Active")
//    } catch let error as NSError {
//    print(error.localizedDescription)
//    }
//    } catch let error as NSError {
//    print(error.localizedDescription)
//    }
//    
//    // set Lockscreen Info
//    
//    MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [MPNowPlayingInfoPropertyPlaybackRate: 1.0, MPMediaItemPropertyArtist : "Radio App", MPMediaItemPropertyTitle : (radioStationToDisplay?.radioName)!]
//
//    
//
//}
