//
//  TweetCell.swift
//  Twitter
//
//  Created by Esther Max-Onakpoya on 10/9/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {


    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userHandle: UILabel!
    @IBOutlet var tweetDate: UILabel!
    @IBOutlet var tweetContent: UILabel!
    
    @IBOutlet var numberOfReplies: UILabel!
    @IBOutlet var numberOfRetweets: UILabel!
    @IBOutlet var numberOfLikes: UILabel!
    @IBAction func replyButtonTapped(_ sender: UIButton) {
        
    }
    @IBAction func retweetButtonTapped(_ sender: UIButton) {
    }
    @IBAction func likedTweetButton(_ sender: UIButton) {
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
