//
//  RSSSplitViewController.m
//  RSS-Catalog
//
//  Created by Rohan Aurora on 4/4/15.
//  Copyright (c) 2015 Rohan Aurora. All rights reserved.
//

#import "RSSSplitViewController.h"
#import "RSS_Catalog-Swift.h"

@interface RSSSplitViewController ()

@end

@implementation RSSSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Allow all orintations (including upside-down on phone)
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.delegate = nil;
}

#pragma mark - UISplitViewControllerDelegate

// this works for the initial view only
- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[NavigationViewControllerWithProgress class]]) {
        NavigationViewControllerWithProgress * detailViewController = (NavigationViewControllerWithProgress *) secondaryViewController;
        if (detailViewController.title == nil) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

// workaround for bug in new splitView controller ...
// without this the items tableview controller was being presented as the detail view,
// and would cause a crash when rotated on iPhone 6+
- (UIViewController *)splitViewController:(UISplitViewController *)splitViewController
separateSecondaryViewControllerFromPrimaryViewController:(UIViewController *)primaryViewController{
    
    if ([primaryViewController isKindOfClass:[UINavigationController class]]) {
        for (UIViewController *controller in [(UINavigationController *)primaryViewController viewControllers]) {
            if ([controller isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)controller visibleViewController] isKindOfClass:[RSSDetailViewController class]]) {
                return controller;
            }
        }
    }
    
    // No detail view present
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *detailView = [storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    
    return detailView;
}

@end