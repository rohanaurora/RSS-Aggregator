//
//  DetailViewController.h
//  RSS-Catalog
//
//  Created by Rohan Aurora on 4/3/15.
//  Copyright (c) 2015 Rohan Aurora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

