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
}

struct TwitterApiConstants {
    static let getStatusesURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    static let tweetCreateDateKey = "created_at"
    static let tweetContentKey = "text"
    static let tweetUserKey = "user"
    static let currentUserRetweetedKey = "retweeted" // returns bool that says if current user retweeted the tweet
    static let retweetedCountKey = "retweet_count"
    static let  currentUserFavoritedKey = "favorited" // returns bool
    static let favoritedCountKey = "favorite_count"
    struct User {
        static let tweetCreatorNameKey = "name"
        static let tweetCreatorHandleKey = "screen_name"
    }
    
    // parent user (logged in)
    static let profilePictureSecureKey = "profile_image_url_https"
    static let profilePictureKey = "profile_image_url"
}



