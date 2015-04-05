//
//  NavigationViewControllerWithProgress.swift
//  TestProject
//
//  Created by Bill Weinman on 2014-12-10.
//  Copyright (c) 2014 Bill Weinman. All rights reserved.
//

import UIKit

class NavigationViewControllerWithProgress: UINavigationController {
    
    var progress = UIProgressView(progressViewStyle: UIProgressViewStyle.Bar)
    
    func addProgressBar() {
        self.view.addSubview(progress)
        
        var toolBar = self.toolbar
        toolBar.tintColor = globalTint
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[progress(==1)]-0-[toolBar]", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["progress": progress, "toolBar": toolbar]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[progress]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["progress": progress]))
        
        //        // navbar version -- doesn't work in portrait?
        //        var navBar = self.navigationBar
        //        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[navBar]-0-[progress(==1)]", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["progress": progress, "navBar": navBar]))
        //        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[progress]|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: nil, views: ["progress": progress]))
        
        progress.setTranslatesAutoresizingMaskIntoConstraints(false)
        progress.hidden = true
        progress.progress = 0
        progress.tintColor = globalTint
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.tintColor = globalTint
        let items = self.navigationBar.items
        for i in items {
            if let title = (i as UINavigationItem).title {
                if title == "Detail" {
                    (i as UINavigationItem).title = nil
                }
            }
        }
        addProgressBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
