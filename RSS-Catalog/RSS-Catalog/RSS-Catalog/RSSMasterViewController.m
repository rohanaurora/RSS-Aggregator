//
//  RSSMasterViewController.m
//  RSS-Catalog
//
//  Created by Rohan Aurora on 4/3/15.
//  Copyright (c) 2015 Rohan Aurora. All rights reserved.
//

#import "RSSMasterViewController.h"
#import "RSSAddViewController.h"
#import "RSSItemsViewController.h"

@interface RSSMasterViewController ()

@property (nonatomic, strong) NSArray *feedIDs;
@property (nonatomic, strong) NSDictionary *newsFeed;
@property (nonatomic, strong) RSSDB *rssDB;
@property (nonatomic, assign) BOOL isPad;

@end

@implementation RSSMasterViewController

#pragma - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:67.0 / 255.0 green:104.0 / 255.0 blue:208.0 / 255.0 alpha:1.0f];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.title = @"RSS Catalog";
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.isPad = (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) ? YES:NO;
    [self loadFeedIDs];
    [self.tableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if (self.newsFeed) {
        [self loadNewFeed];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    // allow upside-down orientation
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Segue delegate

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"feedDetails"]) {
        RSSItemsViewController * itemsTableViewController = [segue destinationViewController];
        NSIndexPath * path = [self.tableView indexPathForSelectedRow];
        NSNumber * feedID = self.feedIDs[path.row];
        
        // setup some context
        itemsTableViewController.currentFeedID = feedID;
        itemsTableViewController.rssDB = self.rssDB;
//    } else if([segue.identifier isEqualToString:@"ToAddView"]) {
//        RSSAddViewController *rssAddViewController = [segue destinationViewController];
//        rssAddViewController.delegate = self;
    }
}

#pragma mark - RSSAddViewControllerDelegate delegate methods

-(void) haveAddViewRecord:(NSDictionary *) avRecord {
    self.newsFeed = avRecord;
    if (self.isPad) [self loadNewFeed];
}

-(void) haveAddViewError:(NSError *) error {
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"URL Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

-(void) haveAddViewMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RSS Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self loadFeedIDs];     // this gets called on reloadData so we must get a new count every time
    return [self.feedIDs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RSSCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    [self loadFeedIDsIfEmpty];
    
    // Configure the cell
    NSDictionary * feedRow = [self.rssDB getFeedRow:self.feedIDs[indexPath.row]];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    [cell.textLabel setText: feedRow[@"title"]];
    [cell.detailTextLabel setText: feedRow[@"desc"]];
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self loadFeedIDsIfEmpty];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // must update the database before updating the tableView
        // so that the tableView never has a row that's missing from the database
        [self.rssDB deleteFeedRow:self.feedIDs[indexPath.row]];
        [self loadFeedIDs];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Database methods

- (void) loadNewFeed {
    if (!self.newsFeed) return;
    
    NSDictionary * newsFeed = self.newsFeed;
    newsFeed = nil;
    
    NSNumber * rc = [_rssDB addFeedRow:newsFeed];
    NSIndexPath * idx = [self indexPathForDBRec:newsFeed];
    if (rc == nil) {    // inserted row in DB
        [self.tableView insertRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationLeft];
    }
    [self.tableView scrollToRowAtIndexPath:idx atScrollPosition:UITableViewScrollPositionNone animated:YES];
    if (rc != nil) {    // updated existing row in DB
        [self.tableView reloadRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (NSIndexPath *) indexPathForDBRec:(NSDictionary *) dbRec {
    NSNumber * rowID = [self.rssDB valueFromQuery:@"SELECT id FROM feed WHERE url = ?", dbRec[@"url"]];
    if (rowID) {
        NSArray * tempFeedIDs = [_rssDB getFeedIDs];
        return [NSIndexPath indexPathForRow:[tempFeedIDs indexOfObject:rowID] inSection:0];
    } else {
        return nil;
    }
}

- (NSArray *) loadFeedIDs {
    if (!self.rssDB) {
        [self loadFeedDB];
    }
    self.feedIDs = [self.rssDB getFeedIDs];
    return self.feedIDs;
}

- (NSArray *) loadFeedIDsIfEmpty {
    if (!self.rssDB) {
        [self loadFeedDB];
    }
    
    if (!self.feedIDs || ![self.feedIDs count]) {
        self.feedIDs = [self.rssDB getFeedIDs];
    }
    return self.feedIDs;
}

- (RSSDB *) loadFeedDB {
    if (!self.rssDB) {
        self.rssDB = [[RSSDB alloc] initWithRSSDBFilename:@"bwrss.db"];
    }
    return self.rssDB;
}



@end
