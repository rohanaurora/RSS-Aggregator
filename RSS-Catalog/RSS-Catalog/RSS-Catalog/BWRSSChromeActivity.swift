//
//  BWRSSChromeActivity.swift
//  BWRSS
//
//  Created by Bill Weinman on 2015-01-02.
//  Copyright (c) 2015 Bill Weinman. All rights reserved.
//

import UIKit

class BWRSSChromeActivity: UIActivity {

    var _url : NSURL?
    
    override func activityType() -> String? {
        return NSStringFromClass(BWRSSSafariActivity)
    }
    
    override func activityTitle() -> String? {
        return "Open in Chrome"
    }
    
    override func activityImage() -> UIImage? {
        return UIImage(named: "ChromeIcon")
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        for item in activityItems {
            if item.isKindOfClass(NSURL) && UIApplication.sharedApplication().canOpenURL(NSURL(string: "googlechrome://")!) {
                let url = (item as NSURL)
                if url.scheme == "http" || url.scheme == "https" {
                    return true
                }
            }
        }
        return false
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        for item in activityItems {
            if item.isKindOfClass(NSURL) {
                _url = (item as NSURL)
            }
        }
    }
    
    override func performActivity() {
        if let url = _url {
            let absurl : NSString = url.absoluteString!
            var chromeabsurl : NSString
            
            if url.scheme == "https" {
                chromeabsurl = absurl.stringByReplacingCharactersInRange(NSRange(location: 0, length: 5), withString: "googlechromes")
            } else {
                chromeabsurl = absurl.stringByReplacingCharactersInRange(NSRange(location: 0, length: 4), withString: "googlechrome")
            }
            
            if let chromeurl = NSURL(string: chromeabsurl) {
                let completed = UIApplication.sharedApplication().openURL(chromeurl)
                self.activityDidFinish(completed)
            }

        }
    }

}
