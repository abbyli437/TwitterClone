//
//  TweetCell.m
//  twitter
//
//  Created by Abby Li on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapFavorite:(id)sender {
    if (self.tweet.favorited == NO) {
        //updates local tweet model
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        
        //udpates cell UI
        [self refreshLikeData];
        
        //sends POST request
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
    }
    //could do unfavorite function in "else" later
}

- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted == NO) {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        
        //updates cell UI
        [self refreshRetweetData];
        
        //sends POST request
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
             }
         }];
    }
}

- (void)refreshLikeData {
    NSString *likeCountString = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    [self.likeButton setTitle:likeCountString forState:UIControlStateNormal];
    [self.likeButton setSelected:true];
}

- (void)refreshRetweetData {
    NSString *retweetCountString = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    [self.retweetButton setTitle:retweetCountString forState:UIControlStateNormal];
    [self.retweetButton setSelected:true];
}

@end
