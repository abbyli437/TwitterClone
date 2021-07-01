//
//  TweetCell.m
//  twitter
//
//  Created by Abby Li on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    //set up header area
    self.authorLabel.text = tweet.user.name;
    self.usernameLabel.text = tweet.user.screenName;
    self.dateLabel.text = tweet.createdAtStringShort;
    
    self.contentLabel.text = tweet.text;
    
    //set up pfp
    self.profileImage.image = nil;
    if (tweet.user.pfpURL != nil) {
        [self.profileImage setImageWithURL:tweet.user.pfpURL];
    }
    
    //sets retweet button title to be the number of retweets
    NSString *retweetCountString = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    [self.retweetButton setTitle:retweetCountString forState:UIControlStateNormal];
    //checks if tweet has been retweeted before
    if (tweet.retweeted) {
        [self.retweetButton setSelected:true];
    }
    else {
        [self.retweetButton setSelected:false];
    }
    
    //sets like button title to be the number of likes
    NSString *likeCountString = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    [self.likeButton setTitle:likeCountString forState:UIControlStateNormal];
    //checks if tweet has been favorited before
    if (tweet.favorited) {
        [self.likeButton setSelected:true];
    }
    else {
        [self.likeButton setSelected:false];
    }

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
