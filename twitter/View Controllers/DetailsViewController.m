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
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.authorLabel.text = self.tweet.user.name;
    self.usernameLabel.text = self.tweet.user.screenName;
    self.dateLabel.text = self.tweet.createdAtString;
    
    self.contentLabel.text = self.tweet.text;
    
    //set up pfp
    self.profileImage.image = nil;
    [self.profileImage setImageWithURL:self.tweet.user.pfpURL];
    
    //set up retweet button
    if (self.tweet.retweeted) {
        [self.retweetButton setSelected:true];
    }
    NSString *retweetCountString = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    [self.retweetButton setTitle:retweetCountString forState:UIControlStateNormal];
    
    //set up like button
    if (self.tweet.favorited) {
        [self.likeButton setSelected:true];
    }
    NSString *likeCountString = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    [self.likeButton setTitle:likeCountString forState:UIControlStateNormal];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
