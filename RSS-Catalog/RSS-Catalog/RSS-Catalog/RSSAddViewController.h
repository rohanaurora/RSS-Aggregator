//
//  RSSAddViewController.h
//  RSS-Catalog
//
//  Created by Rohan Aurora on 4/4/15.
//  Copyright (c) 2015 Rohan Aurora. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RSSAddViewControllerDelegate
-(void) haveAddViewRecord:(NSDictionary *) avRecord;
-(void) haveAddViewError:(NSError *) error;
-(void) haveAddViewMessage:(NSString *) message;
@end

@interface RSSAddViewController : UIViewController <NSURLConnectionDelegate, NSXMLParserDelegate>

@property (nonatomic, weak) id<RSSAddViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *URLTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)cancelAction:(id)sender;
- (IBAction)addAction:(id)sender;
@end
