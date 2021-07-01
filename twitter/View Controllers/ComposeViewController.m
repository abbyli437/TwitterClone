//
//  ComposeViewController.m
//  twitter
//
//  Created by Abby Li on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetText;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tweetText.delegate = self;
}

- (IBAction)closeWindow:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set the max character limit
    int characterLimit = 280;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.tweetText.text stringByReplacingCharactersInRange:range withString:text];

    // Should the new text should be allowed? True/False
    return newText.length < characterLimit;
}

- (IBAction)sendTweet:(id)sender {
    [[APIManager shared] postStatusWithText:self.tweetText.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            NSLog(@"Compose Tweet Success!");
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
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
