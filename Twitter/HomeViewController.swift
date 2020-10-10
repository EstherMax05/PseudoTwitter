//
//  HomeViewController.swift
//  Twitter
//
//  Created by Esther Max-Onakpoya on 10/9/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
        cell.numberOfReplies.text = String(0)
        cell.numberOfRetweets.text = String(tweetArray[indexPath.row][TwitterApiConstants.retweetedCountKey] as? Int ?? 0)
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !isDoneLoading {
            return view.frame.height
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row+1 == tweetArray.count && isDoneLoading {
            numberOfTweets += Constants.defaultNumberOfTweetsStepper
            getTweets()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
