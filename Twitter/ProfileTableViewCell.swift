//
//  ProfileTableViewCell.swift
//  Twitter
//
//  Created by Esther Max-Onakpoya on 10/15/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userHandleLabel: UILabel!
    @IBOutlet var taglineLabel: UILabel!
    @IBOutlet var numberOfTweetsLabel: UILabel!
    @IBOutlet var numberOfFollowingLabel: UILabel!
    @IBOutlet var numberOfFollowersLabel: UILabel!
    @IBOutlet var profileNavBar: UINavigationItem!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileNavBar.backBarButtonItem?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func update(backgroundImage: UIImage?, profileImage: UIImage?, userName: String, userHandle: String, tagline: String, numberOfTweets: Int, numberOfFollowers: Int, numberOfFollowing: Int) {
        backgroundImageView.image = backgroundImage
        profileImageView.image = profileImage
        userNameLabel.text = userName
        userHandleLabel.text = userHandle
        taglineLabel.text = tagline
        numberOfTweetsLabel.text = String(numberOfTweets)
        numberOfFollowingLabel.text = String(numberOfFollowing)
        numberOfFollowersLabel.text = String(numberOfFollowers)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
