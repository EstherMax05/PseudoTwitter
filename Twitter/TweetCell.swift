//
//  TweetCell.swift
//  Twitter
//
//  Created by Esther Max-Onakpoya on 10/9/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit
protocol TweetCellDelegate {
    func shouldRetweet(_ isRetweeted: Bool,  tweetId: Int)
    func shouldLike(_ isLiked: Bool, tweetId: Int)
}
class TweetCell: UITableViewCell {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userHandle: UILabel!
    @IBOutlet var tweetDate: UILabel!
    @IBOutlet var tweetContent: UILabel!
    
    @IBOutlet var numberOfReplies: UILabel!
    @IBOutlet var numberOfRetweets: UILabel!
    @IBOutlet var numberOfLikes: UILabel!
    
    @IBOutlet var likedButton: UIButton!
    @IBOutlet var retweetButton: UIButton!
    
    var tweetCellDelegate: TweetCellDelegate!
    
    var tweetId : Int!
    var isliked = false {
        didSet {
            replaceImage(likedButton, activeImage: "favor-icon-red", inActiveImage: "favor-icon", isActive: isliked)
        }
    }
    var isRetweeted = false{
        didSet {
            replaceImage(retweetButton, activeImage: "retweet-icon-green", inActiveImage: "retweet-icon", isActive: isRetweeted)
        }
    }

    @IBAction func replyButtonTapped(_ sender: UIButton) {
        
    }
    @IBAction func retweetButtonTapped(_ sender: UIButton) {
        // numberOfRetweets.text = isRetweeted ? String(Int(numberOfRetweets.text)-1) : String(Int(numberOfRetweets.text)+1)
        if let numOfRts = Int(numberOfRetweets.text ?? "") {
            numberOfRetweets.text = isRetweeted ? String(numOfRts-1) : String(numOfRts+1)
        }
        isRetweeted = isRetweeted ? false : true
//        replaceImage(sender, activeImage: "favor-icon-red", inActiveImage: "favor-icon", isActive: isRetweeted)
        tweetCellDelegate.shouldRetweet(isRetweeted, tweetId: tweetId)
    }
    @IBAction func likedTweetButton(_ sender: UIButton) {
        if let numOfLikes = Int(numberOfLikes.text ?? "") {
            numberOfLikes.text = isliked ? String(numOfLikes-1) : String(numOfLikes+1)
        }
        isliked = isliked ? false : true
        tweetCellDelegate.shouldLike(isliked, tweetId: tweetId)
    }
    
    func replaceImage(_ sender: UIButton, activeImage: String, inActiveImage: String, isActive: Bool) {
        if isActive {
            sender.setImage(UIImage(named: activeImage), for: .normal)
        } else {
            sender.setImage(UIImage(named: inActiveImage), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
