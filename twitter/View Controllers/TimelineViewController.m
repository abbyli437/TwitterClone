//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchTweets];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)fetchTweets {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = tweets;
            [self.tableView reloadData];
            NSLog(@"😎😎😎 Successfully loaded home timeline");
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (IBAction)logoutTap:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    
    cell.tweet = tweet;
    //set up header area
    cell.authorLabel.text = tweet.user.name;
    cell.usernameLabel.text = tweet.user.screenName;
    cell.dateLabel.text = tweet.createdAtString;
    
    cell.contentLabel.text = tweet.text;
    
    //set up pfp
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.profileImage.image = nil;
    [cell.profileImage setImageWithURL:url];
    
    //sets retweet button title to be the number of retweets
    NSString *retweetCountString = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    [cell.retweetButton setTitle:retweetCountString forState:UIControlStateNormal];
    //checks if tweet has been retweeted before
    if (tweet.retweeted) {
        [cell.retweetButton setSelected:true];
    }
    
    //sets like button title to be the number of likes
    NSString *likeCountString = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    [cell.likeButton setTitle:likeCountString forState:UIControlStateNormal];
    //checks if tweet has been favorited before
    if (tweet.favorited) {
        [cell.likeButton setSelected:true];
    }
    
    return cell;
}

- (void)didTweet:(Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UINavigationController *navigationController = [segue destinationViewController];
    
    //for compose tweet
    if ([navigationController isKindOfClass:[ComposeViewController class]]) {
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    else if ([navigationController isKindOfClass:[DetailsViewController class]]) {
        //for details
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
           
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tweet;
    }
}



@end
