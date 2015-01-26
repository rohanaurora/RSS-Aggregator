//
//  MasterViewController.h
//  RSS-Aggregator
//
//  Created by Rohan Aurora on 1/25/15.
//  Copyright (c) 2015 Rohan Aurora. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <UISplitViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

