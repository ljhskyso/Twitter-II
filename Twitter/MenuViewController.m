//
//  MenuViewController.m
//  Twitter
//
//  Created by Jiheng Lu on 11/16/15.
//  Copyright © 2015 Jiheng Lu. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"
#import "TweetCell.h"
#import "UserProfileViewController.h"
#import "MentionsViewController.h"
#import "TweetsViewController.h"
#import "UserProfileViewController.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property UINavigationController *userProfileVC;
@property UINavigationController *mentionsVC;

@property NSArray *menuList;
@property NSArray *vcs;

@end

@implementation MenuViewController

- (void)viewDidLoad {


    self.userProfileVC = [[UINavigationController alloc] initWithRootViewController:[[UserProfileViewController alloc] init]];
    self.mentionsVC = [[UINavigationController alloc] initWithRootViewController:[[MentionsViewController alloc] init]];
    self.tweetsVC = self.hamburgerVC.tweetsVC;
    self.vcs = @[self.userProfileVC, self.tweetsVC, self.mentionsVC];

    self.menuList = @[@"My Profile", @"My Timelist", @"My Mentions", @"Log out"];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
//    cell.title = self.menuList[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
    cell.textLabel.text = self.menuList[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];


    if (indexPath.row == self.menuList.count - 1) {
        [super dismissViewControllerAnimated:YES completion:nil];
        [User logout];
    } else if (indexPath.row == 0) {
        User *user = [User currentUser];
        UserProfileViewController *userProfileVC = [[UserProfileViewController alloc] init];
        userProfileVC.user = user;
        
        self.hamburgerVC.contentViewController = [[UINavigationController alloc] initWithRootViewController:userProfileVC];
    } else if (indexPath.row == 2) {
        TweetsViewController *vc = [[TweetsViewController alloc] init];
        vc.isMentionsTimeline = true;

        self.hamburgerVC.contentViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    } else {
        self.hamburgerVC.contentViewController = self.vcs[indexPath.row];

    }

//    self.hamburgerVC.contentViewController = self.vcs[indexPath.row];
}

@end
