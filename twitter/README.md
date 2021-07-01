# Project 3 - *TwitterClone*

**TwitterClone** is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: **X** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User sees app icon in home screen and styled launch screen
- [x] User can sign in using OAuth login flow
- [x] User can Logout
- [x] User can view last 20 tweets from their home timeline
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
- [x] User can pull to refresh.
- [x] User can tap the retweet and favorite buttons in a tweet cell to retweet and/or favorite a tweet.
- [x] User can compose a new tweet by tapping on a compose button.
- [x] Using AutoLayout, the Tweet cell should adjust its layout for iPhone 11, Pro and SE device sizes as well as accommodate device rotation.
- [x] User should display the relative timestamp for each tweet "8m", "7h"
- [x] Tweet Details Page: User can tap on a tweet to view it, with controls to retweet and favorite.

The following **optional** features are implemented:

- [ ] User can view their profile in a *profile tab*
  - Contains the user header view: picture and tagline
  - Contains a section with the users basic stats: # tweets, # following, # followers
  - [ ] Profile view should include that user's timeline
- [ ] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count. Refer to [[this guide|unretweeting]] for help on implementing unretweeting.
- [ ] Links in tweets are clickable.
- [ ] User can tap the profile image in any tweet to see another user's profile
  - Contains the user header view: picture and tagline
  - Contains a section with the users basic stats: # tweets, # following, # followers
- [ ] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [ ] When composing, you should have a countdown for the number of characters remaining for the tweet (out of 280) (**1 point**)
- [ ] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [ ] User can reply to any tweet, and replies should be prefixed with the username and the reply_id should be set when posting the tweet (**2 points**)
- [ ] User sees embedded images in tweet if available
- [ ] User can switch between timeline, mentions, or profile view through a tab bar (**3 points**)
- [ ] Profile Page: pulling down the profile page should blur and resize the header image. (**4 points**)


The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I want to figure out how to display a user's retweets on their timeline when they retweet something.
2. I refactored my code like we did for Flix and I'm curious how custom property setters work. I tried using the same code in my details view controller as the timeline view controller but it didn't work in the details view.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://media.giphy.com/media/qV5fJy1UaBVU96HLHE/giphy.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [Kap](https://getkap.co/).

## Notes

Describe any challenges encountered while building the app.

- figuring out how to tell if the destinataion view controller from the home timeline was the compose tweet controller or the details view controller. Ended up solving this by adding identifiers to each segue.
- like button- I realized that a tweet can only be liked once so I get a 403 forbidden error if I try to like a tweet again. Workaround was to reflect the change in the home timeline and have a bool property detailing if a tweet has already been liked in TweetCell. The first fix gives the user a visual reminder and the 2nd fix prevents the user from sending another Post to like the tweet in the backend. 
- composing a tweet- I noticed that I couldn't see tweets I composed at the beginning of my timeline and realized that I was using the wrong method to insert my new tweet into my array of tweets. My old method inserted the tweet at the end of the array instead of at Index 0, which is at the top. 

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [DateTools](https://github.com/MatthewYork/DateTools) - date tool library

## License

    Copyright [yyyy] [name of copyright owner]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
