//
//  Event.swift
//  Radijo App
//
//  Created by Mark Reiff on 10/11/15.
//  Copyright © 2015 Mark Reiff. All rights reserved.
//

import UIKit

class Event: NSObject {
        
    var eventName:String = ""
    var startTime:String = ""
    var endTime:String = ""
    var startDate:NSDate = NSDate()
    var endDate:NSDate = NSDate()
    var nowPlaying:Bool = false
    var firstEventOfDay:Bool = false
    var showEvent:Bool = false
    var daysFromNow:Int = 0
    
    }


