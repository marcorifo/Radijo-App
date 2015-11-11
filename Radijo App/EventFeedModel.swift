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
            radioEvents.append(a)
                
            }
            
            else {}
            // Add the data to the radioStations array
            
            
            
        }
        callback(radioEvents)
        
        
    }
    
    // create google Api Url
    
    func createCalendarURL() -> String {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dateString = dateFormatter.stringFromDate(date)
        let date1 = NSDate()
        print(dateString)
        
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "HH:mm:ss"
        let timeString = dateFormatter1.stringFromDate(date1)
        print(timeString)
        
        let currentTime:String = dateString + "T" + timeString + "Z"
        print (currentTime)
        
        let googleAccount:String = "25udqg22v3qjuogv4tqm352v80@group.calendar.google.com"
        
        
        let endDate = "2015-12-01T10:00:00Z"
        
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

    

