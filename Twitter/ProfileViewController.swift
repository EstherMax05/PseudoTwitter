//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Esther Max-Onakpoya on 10/16/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    var profileData : ProfileData!
    private var tweetArray = [NSDictionary]()
    var userHandle = "PreciousMax7"
    var userDict : NSDictionary!
    var isDoneLoading = false {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if profileData == nil {
            // dirty code but need to submit
            TwitterAPICaller.client?.getDictionaryRequest(url: TwitterApiConstants.getAccountSettingURL, parameters: [:],  success: { (setting: NSDictionary) in
                self.userHandle = setting["screen_name"] as? String ?? "noName"
            }, failure: { (Error) in
                print("Setting retrieval failed")
            })
            
            // get user object
            TwitterAPICaller.client?.getDictionaryRequest(url: TwitterApiConstants.getUserURL, parameters: ["screen_name":userHandle],  success: { [self] (user_dict: NSDictionary) in
                // self.settings_dict = setting
                self.userDict = user_dict
                let name = user_dict["name"] as? String ?? "Servant Girl"
                let tagline = user_dict["description"] as? String ?? "JESUS is the WAY, the TRUTH and the LIFE"
                let numberOfTweets = user_dict["statuses_count"] as? Int ?? -1
                let numberOfFollowing = user_dict["friends_count"] as? Int ?? -1
                let numberOfFollowers = user_dict["followers_count"] as? Int ?? -1

                let profileImageUrl = user_dict[TwitterApiConstants.profilePictureSecureKey] as? String ?? user_dict[TwitterApiConstants.profilePictureKey] as? String
                var profileImage : UIImage?
                if let url = profileImageUrl {
                    profileImage = self.getImage(url: url)
                }
                
                var bannerImage : UIImage?
                if let url = user_dict["profile_banner_url"] as? String {
                    bannerImage = self.getImage(url: url)
                }
                self.profileData = ProfileData(profileImage: (profileImage ?? UIImage(named: "profile-icon"))!, backgroundImage: (bannerImage ?? UIImage(named: "profile-icon"))!, userName: name, userHandle: self.userHandle, tagline: tagline, numberOfTweets: numberOfTweets, numOfFollowing: numberOfFollowing, numOfFollowers: numberOfFollowers)
                self.isDoneLoading = true
            }, failure: { (Error) in
                print("User retrieval failed")
            })
        } else {
            isDoneLoading = true
        }
        getTweets()
        tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count + 1
    }
    
    func getTweets() {
        
        
        // get usertimeline
        TwitterAPICaller.client?.getDictionariesRequest(url: TwitterApiConstants.getUserTimelineUrl, parameters: [TwitterApiConstants.User.tweetCreatorHandleKey: userHandle], success: {(userTimelineDict: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in userTimelineDict {
                self.tweetArray.append(tweet)
            }
        }, failure: {(Error) in
            print("Error posting tweet")
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return view.frame.height/2
        }
        return UITableView.automaticDimension
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if isDoneLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileViewCell", for: indexPath) as! ProfileTableViewCell
            cell.update(backgroundImage: profileData.backgroundImage, profileImage: profileData.profileImage, userName: profileData.userName, userHandle: profileData.userHandle, tagline: profileData.tagline, numberOfTweets: profileData.numberOfTweets, numberOfFollowers: profileData.numOfFollowers, numberOfFollowing: profileData.numOfFollowing)
            return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            return cell
        }
        
        // configure tweetcell
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tweetCellId) as! TweetCell
        let index = indexPath.row - 1
        cell.numberOfLikes.text = String(tweetArray[index][TwitterApiConstants.favoritedCountKey] as? Int ?? 0)
        cell.isliked = tweetArray[index][TwitterApiConstants.isFavorited] as? Bool ?? false
        cell.numberOfReplies.text = String(0)
        cell.numberOfRetweets.text = String(tweetArray[index][TwitterApiConstants.retweetedCountKey] as? Int ?? 0)
        cell.isRetweeted = tweetArray[index][TwitterApiConstants.isRetweeted] as? Bool ?? false
        cell.tweetContent.text = tweetArray[index][TwitterApiConstants.tweetContentKey] as? String
        if let tweetDate = tweetArray[index][TwitterApiConstants.tweetCreateDateKey] as? String {
            let components = tweetDate.components(separatedBy: " ")
            cell.tweetDate.text = components[1] + " " + components[2]
        }
        
        let user = tweetArray[index][TwitterApiConstants.tweetUserKey] as! [String : Any]
        let profileImageUrl = user[TwitterApiConstants.profilePictureSecureKey] as? String ?? user[TwitterApiConstants.profilePictureKey] as? String
        if let url = profileImageUrl {
            cell.profileImageView.image = getImage(url: url)
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height/2
            if #available(iOS 13.0, *) {
                cell.profileImageView.layer.borderColor = CGColor(red: 0.01911348291, green: 0.6245462894, blue: 0.9610264897, alpha: 0.5)
            } else {
                // Fallback on earlier versions
                cell.profileImageView.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            }
            cell.profileImageView.layer.borderWidth = 2
        }
        cell.userHandle.text = user[TwitterApiConstants.User.tweetCreatorNameKey] as? String
        cell.userName.text = user[TwitterApiConstants.User.tweetCreatorHandleKey] as? String

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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
