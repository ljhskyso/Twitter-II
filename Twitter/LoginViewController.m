//
//  LoginViewController.m
//  Twitter
//
//  Created by Jiheng Lu on 11/8/15.
//  Copyright © 2015 Jiheng Lu. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"
#import "HamburgerViewController.h"
#import "MenuViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (IBAction)onLogin:(id)sender {
    [self startLogin];
}

- (IBAction)onLogo:(id)sender {
    [self startLogin];
}

- (void)startLogin {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            // Modally present tweets view
            NSLog(@"Welcome to %@", user.name);
//            UIViewController *nvc = [[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]];

            HamburgerViewController *hamburgerVC = [[HamburgerViewController alloc] init];
            [self presentViewController:hamburgerVC animated:YES completion:nil];
//            [self presentViewController:nvc animated:YES completion:nil];
        } else {
            // Present error view
        }
    }];
}

// ---------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
