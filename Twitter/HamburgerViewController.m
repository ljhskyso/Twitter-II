//
//  HamburgerViewController.m
//  Twitter
//
//  Created by Jiheng Lu on 11/16/15.
//  Copyright © 2015 Jiheng Lu. All rights reserved.
//

#import "HamburgerViewController.h"
#import "MenuViewController.h"
#import "TweetsViewController.h"

@interface HamburgerViewController ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftMarginConstraint;
@property CGFloat originalLeftMargin;

@end

@implementation HamburgerViewController

- (void)viewWillAppear:(BOOL)animated {
    UINavigationController *nTweetsVC = [[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]];
    self.contentViewController = nTweetsVC;
    self.tweetsVC = nTweetsVC;


    MenuViewController *menuVC = [[MenuViewController alloc] init];
    UINavigationController *nMenuVC = [[UINavigationController alloc] initWithRootViewController:menuVC];
    self.menuViewController = nMenuVC;
    menuVC.hamburgerVC = self;
    nMenuVC.navigationBar.barTintColor = [UIColor colorWithRed:238/255.0 green:172/255.0 blue:85/255.0 alpha:1.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ------------------------ hamburger view ------------------------
- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.contentView];
    CGPoint velocity = [sender velocityInView:self.contentView];

    if (sender.state == UIGestureRecognizerStateBegan) {
        self.originalLeftMargin = self.leftMarginConstraint.constant;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        if (self.leftMarginConstraint.constant != 0 || velocity.x > 0) {
            self.leftMarginConstraint.constant = self.originalLeftMargin + translation.x;

        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.5 animations:^{
            if (velocity.x > 0) {
                self.leftMarginConstraint.constant = self.contentView.frame.size.width - 70;
            } else {
                self.leftMarginConstraint.constant = 0;
            }
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)closeMenu {
    [UIView animateWithDuration:0.5 animations:^{
        self.leftMarginConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];

}

- (void)setMenuViewController:(UIViewController *)menuViewController {
    _menuViewController = menuViewController;

    [self.view layoutIfNeeded];
    [self.menuView addSubview:menuViewController.view];
    menuViewController.view.frame = self.menuView.frame;
}

- (void)setContentViewController:(UIViewController *)contentViewController {
    _contentViewController = contentViewController;
    [_contentViewController willMoveToParentViewController:self];
    [_contentViewController didMoveToParentViewController:self];

    [self.view layoutIfNeeded];
    [self.contentView addSubview:contentViewController.view];
    contentViewController.view.frame = self.contentView.bounds;
    [self closeMenu];

//    contentViewController.view.frame = self.contentView.bounds;
//    _contentViewController = contentViewController;
//    [self.view layoutIfNeeded];
//
//    //    if (oldVC != nil) {
//    //        [oldVC willMoveToParentViewController:nil];
//    //        [oldVC.view removeFromSuperview];
//    //        [oldVC didMoveToParentViewController:nil];
//    //    }
//
//    //    [self.contentViewController willMoveToParentViewController:self];
//    [self.contentView addSubview:contentViewController.view];
//    //    [self.contentViewController didMoveToParentViewController:self];
//    
//    [self closeMenu];
}

@end
