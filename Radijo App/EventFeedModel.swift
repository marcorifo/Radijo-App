//
//  eventFeedModel.swift
//  Radijo App
//
//  Created by Mark Reiff on 10/11/15.
//  Copyright © 2015 Mark Reiff. All rights reserved.
//

import UIKit

class EventFeedModel: NSObject {
    
    var radioEvents:[Event] = [Event]()
    let date = NSDate()
    var day:Int = 0
    var googleAccount1:String = ""

    
    func getDictionary () -> [NSDictionary] {
        
        //TODO: Donwload feed and parse out articles
        
        // Array of Article objects
        
        // Get Json array of dictionairies
        
        let jsonObjects:NSDictionary = self.getCalendarJsonFile()
    
            
            // Current JSON file
            
            let jsonDictionary:NSDictionary = jsonObjects
            
            // Create a radio station object
            
            let eventItems = jsonDictionary["items"] as! [NSDictionary]
        
            return eventItems
        
        
        // Return list of radioStation (Article) objects
        // self.doemar moet eigenlijk getriggerd worden na return radioStations
        // Maar hoe?
        //self.doemar()
        
        
        
    }

    
    func getEvents(callback: [Event] -> ())    {
        
        //TODO: Donwload feed and parse out articles
        
        // Array of Article objects
        
        // Get Json array of dictionairies
        
        let jsonObjects:[NSDictionary] = self.getDictionary()
        
        // Loop through each dictionary and assign values to our question objects
        
        var index:Int
        for index = 0; index < jsonObjects.count; index++ {
            
            // Current JSON file
            
            let jsonDictionary:NSDictionary = jsonObjects[index]
            
            // Create a radio station object
            
            let a:Event = Event()
            
            // Assign the values of each key value pair to the question object
            
            let status:String = jsonDictionary["status"] as! String
            
            if status == "confirmed" {
                
            a.eventName = jsonDictionary["summary"] as! String
            let hoi:NSDictionary = jsonDictionary["start"] as! NSDictionary
            let startString:String = hoi["dateTime"] as! String
            a.startTime = startString
            let inEnd:NSDictionary = jsonDictionary["end"] as! NSDictionary
            let endString:String = inEnd["dateTime"] as! String
            a.endTime = endString
                
                let dateFormatter1 = NSDateFormatter()
                dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
                let endDate = dateFormatter1.dateFromString(endString)
                a.endDate = endDate!
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
                let startDate = dateFormatter.dateFromString(startString)
                a.startDate = startDate!
                
                
                if endDate!.compare(date) == NSComparisonResult.OrderedDescending {
                
                if (startDate!.compare(date) == NSComparisonResult.OrderedAscending && endDate!.compare(date) == NSComparisonResult.OrderedDescending) {
                    
                    a.nowPlaying = true
                    
                }
                
                let calendar = NSCalendar.currentCalendar()
                
                let beginningOfDay = calendar.startOfDayForDate(date)
                
                let components = calendar.components([.Day], fromDate: beginningOfDay, toDate: startDate!, options: [])
                
                a.daysFromNow = components.day
                
                if (a.daysFromNow >= day) {
                    
                    day = a.daysFromNow + 1
                    a.firstEventOfDay = true
                    index--
                    
                    }
                
                    print(a.firstEventOfDay)
                    radioEvents.append(a)
                    
                }
                else{}
            
            
            }
            
            else {}
            // Add the data to the radioStations array
            
            
            
        }
        callback(radioEvents)
        
        
    }
    
    // dateformatter from string
    
    
    func getRadioStation (currentRadioStation:Article) -> String {
        
        googleAccount1 = currentRadioStation.googleAccount
        
        return googleAccount1
        
    }
    
    
    // create google Api Url
    
    func createCalendarURL () -> String {
                let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let interval = NSTimeInterval(60 * 60 * 24 * 10)
        let tenDaysFromNow = date.dateByAddingTimeInterval(interval)
        print(tenDaysFromNow)
        let interval2 = NSTimeInterval(60 * 60 * 24 * -1)
        let oneDayAgo = date.dateByAddingTimeInterval(interval2)
        let dateString = dateFormatter.stringFromDate(oneDayAgo)
        let dateStringEnd = dateFormatter.stringFromDate(tenDaysFromNow)
        
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "HH:mm:ss"
        let timeString = dateFormatter1.stringFromDate(oneDayAgo)
        print(timeString)
        let timeStringEnd = dateFormatter1.stringFromDate(tenDaysFromNow)
        
        let currentTime:String = dateString + "T" + timeString + "Z"
        print (currentTime)
        
        let endDate:String = dateStringEnd + "T" + timeStringEnd + "Z"
        print (currentTime)
        
        let googleAccount:String = googleAccount1
        
        let googleUrl:String = "https://www.googleapis.com/calendar/v3/calendars/" + googleAccount + "/events?timeMin=" + currentTime + "&timeMax=" + endDate + "&orderBy=startTime&singleEvents=True&key=AIzaSyD3dKnUmkc0fFlTUAIbUpsQlJ9-R4mXUdM"
        
        print(googleUrl)
        
        return googleUrl
        
        
        
    
    }
    
    func getCalendarJsonFile() -> NSDictionary {
        
        let url:String = createCalendarURL()
        
        let urlPath:NSURL? = NSURL(string: url)
        
        createCalendarURL()
        
        if let actualURLPath = urlPath {
            
            //NSURL obj was created
            
            let jsonData:NSData? = NSData(contentsOfURL: actualURLPath)
            
            if let actualJsonData = jsonData {

                
                // NSData exists, use the NSJSONSerialization classes to parse the data and create the dictionaries
                do {
                    
                    let arrayOfDictionaries: NSDictionary = try NSJSONSerialization.JSONObjectWithData(actualJsonData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    // Succesfully parsed out array of dictionaries
                    return arrayOfDictionaries
                    
                }
                    
                catch {
                    //this code is run if an error is thrown
                    
                }
                
            }
        }
        return NSDictionary()
    }
}

    

