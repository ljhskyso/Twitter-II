//
//  TweetsViewController.m
//  Twitter
//
//  Created by Jiheng Lu on 11/8/15.
//  Copyright © 2015 Jiheng Lu. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "ComposingViewController.h"
#import "TweetsViewController.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "User.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // fetch timeline tweets from Twitter
    [self fetchData];

    // set up naviagation bar
    self.title = @"Tweets";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(fetchData)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];

    UIImage *img = [UIImage imageNamed:@"logos/Twitter_logo_white_48.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [imgView setImage:img];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imgView;

    // set up table view
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];

    // set up table view cell
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    // set up refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ------------------------ navigation bar ------------------------
- (void)onComposeButton {
    ComposingViewController *vc = [[ComposingViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    nvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nvc animated:YES completion:nil];
}

// ------------------------ table view ------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.tweet = self.tweets[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    vc.tweet = self.tweets[indexPath.row];

    [[self navigationController] pushViewController:vc animated:YES];
}



// ------------------------ refresh control ------------------------
- (void)onRefresh {
    [self fetchData];
    [self.refreshControl endRefreshing];
}


// ------------------------ helper methods ------------------------
- (void)fetchData {
    if (self.isMentionsTimeline == true) {
        [[TwitterClient sharedInstance] mentionsTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
            self.tweets = tweets;
            [self.tableView reloadData];
        }];
    } else {
        [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
            self.tweets = tweets;
            [self.tableView reloadData];
        }];
    }
}

@end