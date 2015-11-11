//
//  FeedModel.swift
//  Radijo App
//
//  Created by Mark Reiff on 01/10/15.
//  Copyright (c) 2015 Mark Reiff. All rights reserved.
//
//TODO show schedule radio stations
//TODO BLoglike post circulating background
//TODO add audioPlott to detailViewController
//TODO enable radio to play in background
//TODO make sure playbutton appears in status screen IOS


import UIKit

class FeedModel: NSObject {
    
    var radioStations:[Article] = [Article]()
    
    func getRadioStations(callback: [Article] -> ())    {
        
        //TODO: Donwload feed and parse out articles
        
        // Array of Article objects
        
        // Get Json array of dictionairies
        
        let jsonObjects:[NSDictionary] = self.getLocalJsonFile()
        
         // Loop through each dictionary and assign values to our question objects
        
        var index:Int
        for index = 0; index < jsonObjects.count; index++ {
            
            // Current JSON file
            
            let jsonDictionary:NSDictionary = jsonObjects[index]
            
            // Create a radio station object
            
            let q:Article = Article()
            
            // Assign the values of each key value pair to the question object
            
            q.radioName = jsonDictionary["radioName"] as! String
            q.logoURL = jsonDictionary["logoURL"] as! String
            q.radioFeed = jsonDictionary["radioFeedURL"] as! String
            q.backgroundURL = jsonDictionary["backgroundURL"] as! String
            
            // Add the data to the radioStations array
            
            radioStations.append(q)
            
        }
        
        // Return list of radioStation (Article) objects
        // self.doemar moet eigenlijk getriggerd worden na return radioStations
        // Maar hoe?
        //self.doemar()
        callback(radioStations)
        
        
    }
    
    func getLocalJsonFile() -> [NSDictionary] {
        
            // Path exists
            let urlPath:NSURL? = NSURL(string: "http://demo2827744.mockable.io/markreiff")
            
            if let actualURLPath = urlPath {
                
                //NSURL obj was created
                
                let jsonData:NSData? = NSData(contentsOfURL: actualURLPath)
                
                if let actualJsonData = jsonData {
                    
                    // NSData exists, use the NSJSONSerialization classes to parse the data and create the dictionaries
                    do {
                        
                        let arrayOfDictionaries: [NSDictionary] = try NSJSONSerialization.JSONObjectWithData(actualJsonData, options: NSJSONReadingOptions.MutableContainers) as! [NSDictionary]
                        
                        // Succesfully parsed out array of dictionaries
                        return arrayOfDictionaries
                        
                    }
                    
                    catch {
                        //this code is run if an error is thrown
                    
                }
                
            }
           
        }
        
    
        return [NSDictionary]()
    
    }
    
}

