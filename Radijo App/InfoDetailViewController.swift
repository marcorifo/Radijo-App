//
//  InfoDetailViewController.swift
//  Radijo App
//
//  Created by Mark Reiff on 21/10/15.
//  Copyright © 2015 Mark Reiff. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadImageWithURL(url: NSURL, callback:(UIImage) -> ()) -> NSURLSessionDownloadTask {
        let session = NSURLSession.sharedSession()
        
        let downloadTask = session.downloadTaskWithURL(url, completionHandler: {
            [weak self] url, response, error in
            
            if error == nil && url != nil {
                if let data = NSData(contentsOfURL: url!) {
                    if let image = UIImage(data: data) {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            if let strongSelf = self {
                                strongSelf.image = image
                                callback(image)
                            }
                        }
                    }
                }
            }
            })
        
        downloadTask.resume()
        return downloadTask
    }
}


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */


