//
//  TweetDetailViewController.m
//  Twitter
//
//  Created by Jiheng Lu on 11/9/15.
//  Copyright © 2015 Jiheng Lu. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ComposingViewController.h"
#import "TwitterClient.h"

@interface TweetDetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *screennameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tweetTextLabel;

@property (strong, nonatomic) IBOutlet UIImageView *replyImageView;
@property (strong, nonatomic) IBOutlet UIImageView *retweetImageView;
@property (strong, nonatomic) IBOutlet UIImageView *likeImageView;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // set up navigation bar
    self.navigationItem.title = @"Tweet";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReplyButton)];

    // set up xib elements
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    self.thumbImageView.layer.cornerRadius = 3;
    self.thumbImageView.clipsToBounds = YES;
    [self.thumbImageView setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];

    self.nameLabel.text = self.tweet.user.name;
    self.screennameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenname];
    self.tweetTextLabel.text = self.tweet.text;
    [self.tweetTextLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:18]];

    [self setUpReply];
    [self setUpLike];
    [self setUpRetweet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onReplyButton {
    ComposingViewController *vc = [[ComposingViewController alloc] init];
    vc.tweet = self.tweet;

    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    nvc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:nvc animated:YES completion:nil];
}

// set up like
- (void)onLike {
    [[TwitterClient sharedInstance] createFavorite:self.tweet.id completion:^(NSError *error) {
        if (error) {
            NSLog(@"failed to like the tweet.");
        } else {
            NSLog(@"succeeded to like the tweet.");
            self.tweet.favorited = true;
            [self setUpLike];
        }
    }];
}

- (void)onDisLike {
    [[TwitterClient sharedInstance] destroyFavorite:self.tweet.id completion:^(NSError *error) {
        if (error) {
            NSLog(@"failed to dislike the tweet.");
        } else {
            NSLog(@"succeeded to dislike the tweet.");
            self.tweet.favorited = false;
            [self setUpLike];
        }
    }];
}

- (void)setUpLike {
    self.likeImageView.userInteractionEnabled = YES;
    self.likeImageView.image = self.tweet.favorited ? [UIImage imageNamed:@"twitter_action_icons/like-action-on.png"] : [UIImage imageNamed:@"twitter_action_icons/like-action.png"];
    [UIView transitionWithView:self.likeImageView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
    UITapGestureRecognizer *likeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:self.tweet.favorited ? @selector(onDisLike) : @selector(onLike)];
    likeGesture.numberOfTapsRequired = 1;
    [self.likeImageView addGestureRecognizer:likeGesture];
}

// set up retweet
- (void)onRetweet {
    [self pushAlertWithTitleAndMessage:@"Retweet?" message:nil];
}

- (void)confirmedToRetweet {
    [[TwitterClient sharedInstance] postRetweet:self.tweet.id completion:^(NSError *error) {
        if (error) {
            NSLog(@"failed to retweet the tweet.");
        } else {
            NSLog(@"succeeded to retweet the tweet.");
            self.tweet.retweeted = true;
            [self setUpRetweet];
        }
    }];
}

- (void)setUpRetweet {
    self.retweetImageView.userInteractionEnabled = YES;
    self.retweetImageView.image = self.tweet.retweeted ? [UIImage imageNamed:@"twitter_action_icons/retweet-action-on.png"] : [UIImage imageNamed:@"twitter_action_icons/retweet-action.png"];
    [UIView transitionWithView:self.retweetImageView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom animations:nil completion:nil];
    UITapGestureRecognizer *retweetGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(onRetweet)];
    retweetGesture.numberOfTapsRequired = 1;
    [self.retweetImageView addGestureRecognizer:retweetGesture];
}

- (void)pushAlertWithTitleAndMessage:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes!", @"OK action") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"OK pressed");
        [self confirmedToRetweet];
    }];
    [alertController addAction:okAction];

    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:cancel];

    [self presentViewController:alertController animated:YES completion:nil];
}

// set up reply
- (void)setUpReply {
    self.replyImageView.userInteractionEnabled = YES;
    self.replyImageView.image = [UIImage imageNamed:@"twitter_action_icons/reply-action_0.png"];
    self.replyImageView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.replyImageView.alpha = 1;
    }];    UITapGestureRecognizer *replyGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(onReplyButton)];
    replyGesture.numberOfTapsRequired = 1;
    [self.replyImageView addGestureRecognizer:replyGesture];
}

@end
