//
//  Tweet.m
//  Twitter
//
//  Created by Jiheng Lu on 11/8/15.
//  Copyright © 2015 Jiheng Lu. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.text = dictionary[@"text"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];

        NSDateFormatter *fromTwitter = [[NSDateFormatter alloc] init];
        [fromTwitter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
        [fromTwitter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
        NSString *dateString = [dictionary objectForKey:@"created_at"];
        self.createdAt = [fromTwitter dateFromString:dateString];



        self.id = dictionary[@"id"];
        self.favorited = [dictionary[@"favorited"] intValue] == 1;
        self.retweeted = [dictionary[@"retweeted"] intValue] == 1;

//        NSLog(@"%@", dictionary);
    }

    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }

    return tweets;
}

@end
