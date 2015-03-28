//
//  MasterViewController.h
//  RSS-Catalog
//
//  Created by Rohan Aurora on 4/3/15.
//  Copyright (c) 2015 Rohan Aurora. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSSDetailViewController;

@interface RSSMasterViewController : UITableViewController

@property (strong, nonatomic) RSSDetailViewController *detailViewController;


@end

