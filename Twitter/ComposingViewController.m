//
//  ComposingViewController.m
//  Twitter
//
//  Created by Jiheng Lu on 11/9/15.
//  Copyright © 2015 Jiheng Lu. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "ComposingViewController.h"
#import "TweetsViewController.h"
#import "TwitterClient.h"
#import "User.h"


@interface ComposingViewController () <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *screennameLabel;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSString *placeHolderText;

@end

@implementation ComposingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // set up naviagation bar
    self.title = @"Tweets";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton)];

    UIImage *img = [UIImage imageNamed:@"logos/Twitter_logo_white_48.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [imgView setImage:img];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imgView;

    // set up current user info
    User *currentUser = [User currentUser];
    NSLog(@"%@", currentUser.name);

    [self.thumbImageView setImageWithURL:[NSURL URLWithString:currentUser.profileImageUrl]];
    self.nameLabel.text = currentUser.name;
    self.screennameLabel.text = [NSString stringWithFormat:@"@%@", currentUser.screenname];

    self.thumbImageView.layer.cornerRadius = 3;
    self.thumbImageView.clipsToBounds = YES;

    // set up text view
    self.textView.delegate = self;
    self.placeHolderText = @"What's happening...";
    self.textView.text = self.placeHolderText;


    if (self.tweet != nil) {
        self.textView.text = [NSString stringWithFormat:@"@%@ ", self.tweet.user.screenname];
    } else {
        self.textView.textColor = [UIColor lightGrayColor]; //optional
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancelButton {
    NSLog(@"cancel tapped");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTweetButton {
//     self.textView.text
    NSString *reply_to = self.tweet==nil ? @"" : self.tweet.id;
    NSDictionary *params = @{@"status": self.textView.text, @"in_reply_to_status_id": reply_to};

    [[TwitterClient sharedInstance] postNewTweet:params completion:^(NSError *error) {
        if (error) {
            NSLog(@"failed to post the new tweet.");
            NSLog(@"%@", error);
            [self pushAlertWithTitleAndMessage:@"Sorry!" message:@"Failed to post your Tweet! Please try again later!"];
        } else {
            [self pushAlertWithTitleAndMessage:@"Success!" message:@"Successfully post your Tweet!"];
        }
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"text should begin editing");
    return YES;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"text view did begin editing");
    if ([textView.text isEqualToString:self.placeHolderText]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"text did end editing");
    if ([textView.text isEqualToString:@""]) {
        textView.text = self.placeHolderText;
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (void)pushAlertWithTitleAndMessage:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"OK pressed");
        [self onCancelButton];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)buttonOnTap:(id)sender {
    // hacking solution for now
    [self textViewShouldBeginEditing:self.textView];
    [self textViewDidBeginEditing:self.textView];
}

@end
