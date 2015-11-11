//
//  ScheduleViewController.swift
//  Radijo App
//
//  Created by Mark Reiff on 10/11/15.
//  Copyright © 2015 Mark Reiff. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
   
    @IBOutlet weak var scheduleImage: UIImageView!
    
    @IBOutlet weak var scheduleTableView: UITableView!
    
    let feedModel:EventFeedModel = EventFeedModel()
    var radioEvents:[Event] = [Event]()
    
    var selectedEvent:Event?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        
        feedModel.getEvents() {
            
            radioEvents in self.eventsReady()
            
            self.automaticallyAdjustsScrollViewInsets = false
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    func eventsReady() {
        
        // Feed model has notified view controller that articles are ready
        self.radioEvents = self.feedModel.radioEvents
        
        // Display articles in tableview
        self.scheduleTableView.reloadData()
        
        }
    
    // Tabelview Delegate methods
    func tableView(scheduleTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.radioEvents.count
        
    }
    
    func tableView(scheduleTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let currentEventToDisplay:Event = self.radioEvents[indexPath.row]
        
        // Try to get a cell to reuse
        
        let cell:UITableViewCell = scheduleTableView.dequeueReusableCellWithIdentifier("eventTableCell") as UITableViewCell!
        
        let timeLabel:UILabel? = cell.viewWithTag(2) as! UILabel?
        let descriptionLabel:UILabel? = cell.viewWithTag(3) as! UILabel?
        
        if let actualTimeLabel = timeLabel {
            
            if currentEventToDisplay.startTime != "" {
                
                actualTimeLabel.text = currentEventToDisplay.startTime
                
            }
        }
        
        if let actualDescriptionLabel = descriptionLabel {
            
            if currentEventToDisplay.eventName != "" {
                
                actualDescriptionLabel.text = currentEventToDisplay.eventName
            }
        }
        
        
            
        
        
//        // Grab the elements using the tag
//        
//        let imageView:UIImageView? = cell.viewWithTag(2) as! UIImageView?
//        
//        
//        
//        
////         Set cell properties
////        
////        if let actualImageView = imageView {
////            
////            // Imageview actually exists
////            
////            if currentEventToDisplay.logoURL != "" {
////                
////                let imageURL = currentEventToDisplay.logoURL as NSString
////                
////                if imageURL.containsString("http") {
////                    // station image loaded
////                    
////                    if let hoi = NSURL(string: currentEventToDisplay.logoURL) { downloadTask = imageView!.loadImageWithURL(hoi) {_ in}
////                    }
////                }
////                    
////                else if imageURL != "" {
////                    actualImageView.image = UIImage(named: imageURL as String)
////                    
////                } else {
////                    actualImageView.image = UIImage(named: "stationImage")
////                }
////        
////                
////                /*let url:NSURL? = NSURL(string: currentArticleToDisplay.logoURL)
////                let imageRequest = NSURLRequest(URL: url!)
////                
////                 Fire off request to download it
////                
////                 NSURLConnection.sendAsynchronousRequest(imageRequest, queue: NSOperationQueue.mainQueue(), completionHandler:  {(response, data, error) in
////                
////                 actualImageView.image? = UIImage(data: data!)!}
////                
////                let session = NSURLSession.sharedSession()
////                
////                let dataTask1 = session.dataTaskWithRequest(imageRequest) { (data:NSData?, response:NSURLResponse?, error:NSError?) in
////                
////                actualImageView.image = UIImage(data:data!)
////                
////                
////                
////                
////                }
////                
////                */
////            }
        
//            cell.textLabel!.text = currentEventToDisplay.eventName
            cell.selectionStyle = UITableViewCellSelectionStyle.Blue
            
            // Return the cell
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Keep track of which article the user selected
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.selectedEvent = self.radioEvents[indexPath.row]
        
    }
}



    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
