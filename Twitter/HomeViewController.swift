//
//  HomeViewController.swift
//  Twitter
//
//  Created by Esther Max-Onakpoya on 10/9/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

struct ProfileData {
    var profileImage : UIImage
    var backgroundImage : UIImage
    var userName : String
    var userHandle : String
    var tagline : String
    var numberOfTweets : Int
    var numOfFollowing : Int
    var numOfFollowers : Int
    
    init(profileImage : UIImage,  backgroundImage : UIImage, userName : String, userHandle : String, tagline : String, numberOfTweets : Int, numOfFollowing : Int,  numOfFollowers : Int) {
        self.profileImage = profileImage
        self.backgroundImage  = backgroundImage
            self.userName = userName
        self.userHandle = userHandle
        self.tagline = tagline
        self.numberOfTweets = numberOfTweets
        self.numOfFollowing = numOfFollowing
        self.numOfFollowers = numOfFollowers
    }
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {
    func shouldRetweet(_ isRetweeted: Bool, tweetId: Int) {
        let url = isRetweeted ? TwitterApiConstants.getRetweetURL(with: tweetId) : TwitterApiConstants.getUnretweetURL(with: tweetId)
        TwitterAPICaller.client?.postRequest(url: url, parameters: [TwitterApiConstants.idKey: tweetId], success: {print("success")}, failure: {(Error) in
            print("Error posting tweet")
        })
        
    }
    
    func shouldLike(_ isLiked: Bool, tweetId: Int) {
        let url = isLiked ? TwitterApiConstants.createFavoritesURL : TwitterApiConstants.destroyFavoritesURL
        TwitterAPICaller.client?.postRequest(url: url, parameters: [TwitterApiConstants.idKey: tweetId], success: {print("success")}, failure: {(Error) in
            print("Error posting tweet")
        })
    }
    
    private var settings_dict : NSDictionary!
    private var userHandle = "PreciousMax7"
    private var userDict : NSDictionary!
    var numberOfTweets = Constants.defaultNumberOfTweets
    var tweetArray = [NSDictionary]()
    var isDoneLoading = false {
        didSet {
            if isDoneLoading == true {
                tableView.reloadData()
                if self.tableRefreshControl.isRefreshing {
                    self.tableRefreshControl.endRefreshing()
                }
            }
        }
    }
    
    let tableRefreshControl = UIRefreshControl()
    
    @IBOutlet var tableView: UITableView!
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: Constants.logInKey)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(tweetArray.count, 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isDoneLoading{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.loadingCell) as! LoadingCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tweetCellId) as! TweetCell
        cell.numberOfLikes.text = String(tweetArray[indexPath.row][TwitterApiConstants.favoritedCountKey] as? Int ?? 0)
        cell.isliked = tweetArray[indexPath.row][TwitterApiConstants.isFavorited] as? Bool ?? false
        cell.numberOfReplies.text = String(0)
        cell.numberOfRetweets.text = String(tweetArray[indexPath.row][TwitterApiConstants.retweetedCountKey] as? Int ?? 0)
        cell.isRetweeted = tweetArray[indexPath.row][TwitterApiConstants.isRetweeted] as? Bool ?? false
        cell.tweetContent.text = tweetArray[indexPath.row][TwitterApiConstants.tweetContentKey] as? String
        if let tweetDate = tweetArray[indexPath.row][TwitterApiConstants.tweetCreateDateKey] as? String {
            let components = tweetDate.components(separatedBy: " ")
            cell.tweetDate.text = components[1] + " " + components[2]
        }
        
        let user = tweetArray[indexPath.row][TwitterApiConstants.tweetUserKey] as! [String : Any]
        let profileImageUrl = user[TwitterApiConstants.profilePictureSecureKey] as? String ?? user[TwitterApiConstants.profilePictureKey] as? String
        if let url = profileImageUrl {
            cell.profileImageView.image = getImage(url: url)
        }
        cell.userHandle.text = user[TwitterApiConstants.User.tweetCreatorNameKey] as? String
        cell.userName.text = user[TwitterApiConstants.User.tweetCreatorHandleKey] as? String
        
        cell.tweetId = (tweetArray[indexPath.row][TwitterApiConstants.idKey] as? Int)!
        cell.tweetCellDelegate = self
        
        return cell
    }
    
    func getImage(url: String) -> UIImage? {
        if let posterURL = URL(string: url) {
            if let posterImage = try? Data(contentsOf: posterURL) {
                return UIImage(data: posterImage)
            }
        }
        return nil
    }
    
    func getTweets() {
        TwitterAPICaller.client?.getDictionariesRequest(url: TwitterApiConstants.getStatusesURL, parameters: [TwitterApiConstants.numberOfTweetsKey: numberOfTweets], success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.isDoneLoading = true
        }, failure: { (Error) in
            print("Tweet retrieval failed")
            if self.tableRefreshControl.isRefreshing {
                self.tableRefreshControl.endRefreshing()
            }
        })
        numberOfTweets += Constants.defaultNumberOfTweetsStepper
        
    }
    
    @objc func getTweetsAction() {
        numberOfTweets = Constants.defaultNumberOfTweets
        getTweets()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getTweets()
        tableRefreshControl.addTarget(self, action: #selector(getTweetsAction), for: .valueChanged)
        tableView.refreshControl = tableRefreshControl
        
        getUSerInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getTweets()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isDoneLoading {
            return view.frame.height
        }
        return UITableView.automaticDimension
    }
    
    /*
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row+1 == tweetArray.count && isDoneLoading {
            numberOfTweets += Constants.defaultNumberOfTweetsStepper
            getTweets()
        }
    }*/
    
    func getUSerInfo() {
        TwitterAPICaller.client?.getDictionaryRequest(url: TwitterApiConstants.getAccountSettingURL, parameters: [:],  success: { (setting: NSDictionary) in
            self.userHandle = setting["screen_name"] as? String ?? "noName"
        }, failure: { (Error) in
            print("Setting retrieval failed")
        })
        // get user object
        TwitterAPICaller.client?.getDictionaryRequest(url: TwitterApiConstants.getUserURL, parameters: ["screen_name":userHandle],  success: { (user_dict: NSDictionary) in
            // self.settings_dict = setting
            self.userDict = user_dict
        }, failure: { (Error) in
            print("User retrieval failed")
        })
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        /*
        // get settings
        TwitterAPICaller.client?.getDictionaryRequest(url: TwitterApiConstants.getAccountSettingURL, parameters: [:],  success: { (setting: NSDictionary) in
            self.userHandle = setting["screen_name"] as? String ?? "noName"
        }, failure: { (Error) in
            print("Setting retrieval failed")
        })
        // get user object
        TwitterAPICaller.client?.getDictionaryRequest(url: TwitterApiConstants.getUserURL, parameters: [:],  success: { (user_dict: NSDictionary) in
            // self.settings_dict = setting
            self.userDict = user_dict
        }, failure: { (Error) in
            print("User retrieval failed")
        })
 */
        
        // screen_name; description (nullable); favourites_count; statuses_count; friends_count; followers_count
        
        if segue.identifier == "toProfileView" {
            // send profile data
            let name = userDict["name"] as? String ?? "Servant Girl"
            let tagline = userDict["description"] as? String ?? "JESUS is the WAY, the TRUTH and the LIFE"
            let favouritesCount = userDict["favourites_count"] as? Int ?? -1
            let numberOfTweets = userDict["statuses_count"] as? Int ?? -1
            let numberOfFollowing = userDict["friends_count"] as? Int ?? -1
            let numberOfFollowers = userDict["followers_count"] as? Int ?? -1

            let profileImageUrl = userDict[TwitterApiConstants.profilePictureSecureKey] as? String ?? userDict[TwitterApiConstants.profilePictureKey] as? String
            var profileImage : UIImage?
            if let url = profileImageUrl {
                profileImage = getImage(url: url)
            }
            
            var bannerImage : UIImage?
            if let url = userDict["profile_banner_url"] as? String {
                bannerImage = getImage(url: url)
            }
            let profileData = ProfileData(profileImage: (profileImage ?? UIImage(named: "profile-icon"))!, backgroundImage: (bannerImage ?? UIImage(named: "profile-icon"))!, userName: name, userHandle: userHandle, tagline: tagline, numberOfTweets: numberOfTweets, numOfFollowing: numberOfFollowing, numOfFollowers: numberOfFollowers)
            
            let viewController = segue.destination as! ProfileViewController
            viewController.profileData = profileData
        }
        if segue.identifier == "toTweetView" {
            // send profile picture
            let viewController = segue.destination as! TweetWrapperViewController
            var profileImage : UIImage?
            let profileImageUrl = userDict[TwitterApiConstants.profilePictureSecureKey] as? String ?? userDict[TwitterApiConstants.profilePictureKey] as? String
            if let url = profileImageUrl {
                profileImage = getImage(url: url)
            }
            viewController.profileImage = profileImage // modify this
        }
    }
    

}
