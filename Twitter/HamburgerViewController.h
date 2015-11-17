//
//  HamburgerViewController.h
//  Twitter
//
//  Created by Jiheng Lu on 11/16/15.
//  Copyright © 2015 Jiheng Lu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetsViewController.h"

@interface HamburgerViewController : UIViewController

@property (strong, nonatomic) UIViewController *menuViewController;
@property (strong, nonatomic) UIViewController *contentViewController;
@property (strong, nonatomic) UINavigationController *tweetsVC;

@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

- (void)closeMenu;

@end
