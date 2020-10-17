//
//  Constants.swift
//  Twitter
//
//  Created by Esther Max-Onakpoya on 10/9/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import Foundation
struct Constants {
    static let logInKey = "LoggedIn"
    static let tweetCellId = "tweetCell"
    static let loadingCell = "loadingCell"
    static let defaultNumberOfTweets = 7
    static let defaultNumberOfTweetsStepper = 3
}

struct TwitterApiConstants {
    static let getStatusesURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    static let updateStatuseURL = "https://api.twitter.com/1.1/statuses/update.json"
    static let destroyFavoritesURL = "https://api.twitter.com/1.1/favorites/destroy.json"
    static let createFavoritesURL = "https://api.twitter.com/1.1/favorites/create.json"
//    static let retweetURL = "https://api.twitter.com/1.1/statuses/retweet/:id.json"
    static func getRetweetURL(with tweetId: Int) -> String {
        return "https://api.twitter.com/1.1/statuses/retweet/\(tweetId).json"
    }
    static func getUnretweetURL(with tweetId: Int) -> String {
        return "https://api.twitter.com/1.1/statuses/unretweet/\(tweetId).json"
    }
//    static let unRetweetURL = "https://api.twitter.com/1.1/statuses/unretweet/:id.json"
    static let getUserURL = "https://api.twitter.com/1.1/users/show.json"
    static let getAccountSettingURL = "https://api.twitter.com/1.1/account/settings.json"
    static let getUserTimelineUrl = "https://api.twitter.com/1.1/statuses/user_timeline.json"
    static let tweetCreateDateKey = "created_at"
    static let tweetContentKey = "text"
    static let tweetUserKey = "user"
    static let currentUserRetweetedKey = "retweeted" // returns bool that says if current user retweeted the tweet
    static let retweetedCountKey = "retweet_count"
    static let currentUserFavoritedKey = "favorited" // returns bool
    static let favoritedCountKey = "favorite_count"
    static let isFavorited = "favorited"
    static let isRetweeted = "retweeted"
    static let numberOfTweetsKey = "count"
    static let idKey = "id"
    struct User {
        static let tweetCreatorNameKey = "name"
        static let tweetCreatorHandleKey = "screen_name"
    }
    
    // parent user (logged in)
    static let profilePictureSecureKey = "profile_image_url_https"
    static let profilePictureKey = "profile_image_url"
}



