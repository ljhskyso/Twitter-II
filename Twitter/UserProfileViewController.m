//
//  UserProfileViewController.m
//  Twitter
//
//  Created by Jiheng Lu on 11/16/15.
//  Copyright © 2015 Jiheng Lu. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface UserProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel
;
@property (strong, nonatomic) IBOutlet UILabel *screennameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tweetsNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *followingNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *followerNumLabel;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];

    UIImage *img = [UIImage imageNamed:@"logos/Twitter_logo_white_48.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [imgView setImage:img];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imgView;

    self.nameLabel.text = self.user.name;
    self.screennameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenname];
    self.tweetsNumLabel.text = [NSString stringWithFormat:@"%@", self.user.tweets_cnt];
    self.followingNumLabel.text = [NSString stringWithFormat:@"%@", self.user.following_cnt];
    self.followerNumLabel.text = [NSString stringWithFormat:@"%@", self.user.followers_cnt];

    [self.thumbImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    [self.backgroundImageView setImageWithURL:[NSURL URLWithString:self.user.profileBackgroundImageUrl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissView {
    [super dismissViewControllerAnimated:YES completion:nil];
}

@end
