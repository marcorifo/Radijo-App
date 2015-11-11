//
//  ViewController.swift
//  Radijo App
//
//  Created by Mark Reiff on 01/10/15.
//  Copyright (c) 2015 Mark Reiff. All rights reserved.
//

import UIKit
import AVFoundation
import MessageUI

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    
    let feedModel:FeedModel = FeedModel()
    var radioStations:[Article] = [Article]()
    let messageController = MFMailComposeViewController() // init here so that it loads as fast as possible

    var selectedArticle:Article?
    var downloadTask: NSURLSessionDownloadTask?
    
    let refreshControl = UIRefreshControl()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Override point for customization after application launch.
        // set delegates of tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        }
        
        self.title = "Stations"
        
        // Set itself as the delegate for the feedmodel
        
        // Fire of request to download articles in the background        
        feedModel.getRadioStations() { articles in
            self.articlesReady()
        }
        
        /* Check if there's at least 1 radioStation
        if (self.radioStations.count > 0) {
                
            // Set current radioStation to first radioStation
            self.currentRadioStation = self.radioStations[0]
            
            // Call the get usefull data method
            self.getData()

            
        }
        */
        
    }
    
    
    @IBAction func requestStation() {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            
            self.messageController.mailComposeDelegate = self
            self.messageController.setToRecipients(["mark.reiff@gmail.com"])
            self.messageController.setSubject("I'd like to request a new station")
            self.messageController.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
            self.presentViewController(self.messageController, animated: true, completion: {
                completion in

                
                
            });
            
        }

    }
    
    /*
    func getData() {
        
        if let actualCurrentRadioStation = self.currentRadioStation {
            
            radioName = self.currentRadioStation?.radioName
            
        }

        
    }
     */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    // Feed Model Delegate Methods
    func articlesReady() {
        
        // Feed model has notified view controller that articles are ready
        self.radioStations = self.feedModel.radioStations
        
        // Display articles in tableview
        self.tableView.reloadData()
        
    }
    
    // Tabelview Delegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.radioStations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let currentArticleToDisplay:Article = self.radioStations[indexPath.row]
        
        // Try to get a cell to reuse
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Tablecell") as UITableViewCell!
        
        // Grab the elements using the tag
        
        let imageView:UIImageView? = cell.viewWithTag(1) as! UIImageView?
        
        
        
        
        // Set cell properties
        
        if let actualImageView = imageView {
            
            // Imageview actually exists
            
            if currentArticleToDisplay.logoURL != "" {
                
                let imageURL = currentArticleToDisplay.logoURL as NSString
                
                if imageURL.containsString("http") {
                            // station image loaded
                    
                    if let hoi = NSURL(string: currentArticleToDisplay.logoURL) { downloadTask = imageView!.loadImageWithURL(hoi) {_ in}
                    }
                }
                    
                else if imageURL != "" {
                    actualImageView.image = UIImage(named: imageURL as String)
                    
                } else {
                    actualImageView.image = UIImage(named: "stationImage")
                }

                
                /*let url:NSURL? = NSURL(string: currentArticleToDisplay.logoURL)
                let imageRequest = NSURLRequest(URL: url!)
                
                // Fire off request to download it
                
               // NSURLConnection.sendAsynchronousRequest(imageRequest, queue: NSOperationQueue.mainQueue(), completionHandler:  {(response, data, error) in
                    
                   // actualImageView.image? = UIImage(data: data!)!}
                
                let session = NSURLSession.sharedSession()
                
                let dataTask1 = session.dataTaskWithRequest(imageRequest) { (data:NSData?, response:NSURLResponse?, error:NSError?) in
                    
                    actualImageView.image = UIImage(data:data!)
                    
                
                
                
                }
                
            */
            }
        
        cell.textLabel!.text = currentArticleToDisplay.radioName
        cell.selectionStyle = UITableViewCellSelectionStyle.Blue
        
        // Return the cell
        
        
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Keep track of which article the user selected
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.selectedArticle = self.radioStations[indexPath.row]
        
        
        // trigger the segue to go to the detail view
        self.performSegueWithIdentifier("toDetailSegue", sender: self)
        
        
    }
    
    
    
//    // Reload Data code
//    
//    func refresh(refreshControl: UIRefreshControl) {
//        feedModel.getRadioStations() { articles in
//            self.tableView.reloadData()
//        }
//        refreshControl.endRefreshing()
//    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender:AnyObject?) {
        
        // get reference to destination view controller
        
        let detailVC = segue.destinationViewController as! DetailViewController
        
        // pass along the selected article
        
        detailVC.radioStationToDisplay = self.selectedArticle

    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

}
