# Project 4 - *Twitter Clone*
**NOTICE** Still working on deploying backend and polishing app UI.
**Twitter Clone** is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: **24** hours spent in total (BUT WORTH THE TIME)

## Week 1 User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow
- [x] User can view last 20 tweets from their home timeline
- [x] The current signed in user will be persisted across restarts
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
- [x] Retweeting and favoriting should increment the retweet and favorite count.

The following **optional** features are implemented:

- [ ] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [ ] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [ ] User can pull to refresh.

## Week 2 User Stories
The following **required** functionality is completed:

- [x] Tweet Details Page: User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [x] Profile page:
   - [x] Contains the user header view
   - [x] Contains a section with the users basic stats: # tweets, # following, # followers
- [x] Home Timeline: Tapping on a user image should bring up that user's profile page
- [x] Compose Page: User can compose a new tweet by tapping on a compose button.

The following **optional** features are implemented:

- [ ] When composing, you should have a countdown in the upper right for the tweet limit.
- [ ] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [ ] Profile Page
   - [ ] Implement the paging view for the user description.
   - [ ] As the paging view moves, increase the opacity of the background screen. See the actual Twitter app for this effect
   - [ ] Pulling down the profile page should blur and resize the header image.
- [ ] Account switching
   - [ ] Long press on tab bar to bring up Account view with animation
   - [ ] Tap account to switch to
   - [ ] Include a plus button to Add an Account
   - [ ] Swipe to delete an account


The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. 
2. 

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/RxbBPaH.gif' title='Week 1 Video Walkthrough' width='' alt='Video Walkthrough' />
<img src='http://i.imgur.com/BAs0g6Q.gif' title='Week 2 Video Walkthrough' width='' alt='Video Walkthrough2' />
<img src='http://i.imgur.com/4zJIKqv.png' title='Tweet Screenshot' width='' alt='Screenshot of Tweet from Walkthrough' />
GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.Al

Figuring out how to get the data from over the network was tricky because I had to choose which parameters to pass for the REST API.
I had to read a lot through the documentations and look at the API console to figure out the right url. Also, this was the first time I have worked with closures. Still trying to wrap my head around them, but I have a general gist of what's going on :o

Also getting the profile by pressing a user's profile picture was tricky for segue since the element was image view. Then getting the
user data to the the next view was tricky because that data was not part of the image view (it was part of the Tweet in the cell). So I had to implement delegation to get it to work. Also this is the first application that I built that uses multiple segues in a single application. That was tricky at first, but
then I got the hang  of it with practice :)

Still need to clean up the code. It's pretty messy, and I'd like to clean up the UI a bit as well. More to come!

## License

Copyright [2017] [name of copyright owner]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
