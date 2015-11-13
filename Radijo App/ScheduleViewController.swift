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
    
    var radioStationToDisplay:Article?
    let feedModel:EventFeedModel = EventFeedModel()
    var radioEvents:[Event] = [Event]()
    
    var selectedEvent:Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        
        feedModel.getRadioStation(radioStationToDisplay!)
        
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
        var cellChooser:UITableViewCell
        
        // Try to get a cell to reuse
        
        if (currentEventToDisplay.firstEventOfDay == true) {
            
            let cell:UITableViewCell = scheduleTableView.dequeueReusableCellWithIdentifier("dateTableCell") as UITableViewCell!
            let dateLabel:UILabel? = cell.viewWithTag(4) as! UILabel?
            
            if let actualDateLabel = dateLabel {
                
                if currentEventToDisplay.daysFromNow == 0 {
                    
                    actualDateLabel.text = "Today"
                    
                }
                
                else {
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
                dateFormatter.dateFormat = "d MMMM "
                let currentDay = dateFormatter.stringFromDate(currentEventToDisplay.startDate)
                
                
                actualDateLabel.text = currentDay
                
                }
                
            }
            
            cellChooser = cell
        }
        
        else {
        
            let cell:UITableViewCell = scheduleTableView.dequeueReusableCellWithIdentifier("eventTableCell") as UITableViewCell!
            
            let timeLabel:UILabel? = cell.viewWithTag(2) as! UILabel?
            let descriptionLabel:UILabel? = cell.viewWithTag(3) as! UILabel?
            
            
        if let actualTimeLabel = timeLabel {
            
            if let startDate:NSDate = currentEventToDisplay.startDate {
                
                if currentEventToDisplay.nowPlaying == false {
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
                dateFormatter.dateFormat = "HH:mm"
                let startTime = dateFormatter.stringFromDate(startDate)
                
                actualTimeLabel.text = startTime
                }
                else {
                    actualTimeLabel.text = "Now Playing"
                }
            }
            }
        
        
        
        if let actualDescriptionLabel = descriptionLabel {
            
            if currentEventToDisplay.eventName != "" {
                
                actualDescriptionLabel.text = currentEventToDisplay.eventName
            }
            }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.Blue
    
            
        cellChooser = cell
        }
    
        return cellChooser
            
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
