//
//  DetailsViewController.m
//  twitter
//
//  Created by Abby Li on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImage;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.authorLabel.text = self.tweet.user.name;
    self.usernameLabel.text = self.tweet.user.screenName;
    self.dateLabel.text = self.tweet.createdAtString;
    
    self.contentText.text = self.tweet.text;
    
    //set up pfp
    self.profileImage.image = nil;
    if (self.tweet.user.pfpURL != nil) {
        [self.profileImage setImageWithURL:self.tweet.user.pfpURL];
    }
    self.profileImage.layer.cornerRadius  = self.profileImage.frame.size.width/2;
    
    //set up retweet button
    if (self.tweet.retweeted) {
        [self.retweetButton setSelected:true];
    }
    else {
        [self.retweetButton setSelected:false];
    }
    NSString *retweetCountString = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    [self.retweetButton setTitle:retweetCountString forState:UIControlStateNormal];
    
    //set up like button
    if (self.tweet.favorited) {
        [self.likeButton setSelected:true];
    }
    else {
        [self.likeButton setSelected:false];
    }
    NSString *likeCountString = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    [self.likeButton setTitle:likeCountString forState:UIControlStateNormal];
    
    //deals with media embed
    self.mediaImage.image = nil;
    if (self.tweet.mediaURL != nil) {
        [self.mediaImage setImageWithURL:self.tweet.mediaURL];
    }
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
    else {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        //updates cell UI
        [self refreshRetweetData];
        
        //sends POST request
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
             }
         }];
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
    else {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        [self refreshLikeData];
        
        //sends POST request
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
             }
         }];
    }
}

- (void)refreshLikeData {
    NSString *likeCountString = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    [self.likeButton setTitle:likeCountString forState:UIControlStateNormal];
    if (self.tweet.favorited) {
        [self.likeButton setSelected:true];
    }
    else {
        [self.likeButton setSelected:false];
    }
}

- (void)refreshRetweetData {
    NSString *retweetCountString = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    [self.retweetButton setTitle:retweetCountString forState:UIControlStateNormal];
    if (self.tweet.retweeted) {
        [self.retweetButton setSelected:true];
    }
    else {
        [self.retweetButton setSelected:false];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
