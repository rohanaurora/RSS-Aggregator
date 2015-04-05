//
//  RSSItemsViewController.h
//  RSS-Catalog
//
//  Created by Rohan Aurora on 4/4/15.
//  Copyright (c) 2015 Rohan Aurora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSDB.h"

@interface RSSItemsViewController : UITableViewController <NSXMLParserDelegate>

@property (nonatomic, strong) RSSDB *rssDB;
@property (nonatomic, strong) NSNumber * currentFeedID;

@end
