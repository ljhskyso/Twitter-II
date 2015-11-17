//
//  TwitterClient.h
//  Twitter
//
//  Created by Jiheng Lu on 11/8/15.
//  Copyright © 2015 Jiheng Lu. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;
- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)postNewTweet:(NSDictionary *)params completion:(void (^)(NSError *error))completion;
- (void)createFavorite:(NSString *)status_id completion:(void (^)(NSError *error))completion;
- (void)destroyFavorite:(NSString *)status_id completion:(void (^)(NSError *error))completion;
- (void)postRetweet:(NSString *)status_id completion:(void (^)(NSError *error))completion;
- (void)mentionsTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;

@end
