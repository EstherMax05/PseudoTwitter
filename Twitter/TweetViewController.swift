//
//  TweetViewController.swift
//  Twitter
//
//  Created by Esther Max-Onakpoya on 10/15/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {
    private let MAX_COUNT = 140
    private var count = 0
    var profileImage : UIImage?
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var tweetTextView: UITextView!
    @IBOutlet var numberOfCharsLeftLabel: UILabel!
    @IBAction func didTapTweet(_ sender: UIBarButtonItem) {
        if let tweet = tweetTextView.text {
            TwitterAPICaller.client?.postRequest(url: TwitterApiConstants.updateStatuseURL, parameters: ["status": tweet], success: {self.dismiss(animated: true, completion: nil)}, failure: {(Error) in
                print("Error posting tweet")
            })
        } else {
            print("Tweet not created by user")
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func didTapBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var tweetNavBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        let navController = self.navigationController as! TweetWrapperViewController
        profileImage = navController.profileImage
        tweetNavBar.backBarButtonItem?.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.image = profileImage
        tweetTextView.delegate = self
//        tweetTextView.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        count = tweetTextView.text.count
        updateCountLabel()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == ""{
            print("Delete")
        }
        print("count: ", count, "; range lo: ", range.lowerBound, "; range up: ", range.upperBound, "; text: ", text)
        if range.location + text.count >= MAX_COUNT && text != ""{
            if (MAX_COUNT - count) > 0 {
                let str = text[text.startIndex..<text.index(text.startIndex, offsetBy: MAX_COUNT - range.lowerBound)]
                print("STRINGFSA! ", str)
                count += str.count
                updateCountLabel()
                tweetTextView.text.append(contentsOf: str)
            }
            return false
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        tweetTextView.text = ""
        tweetTextView.textColor = UIColor.black
        return true
    }
    
    func updateCountLabel() {
        numberOfCharsLeftLabel.text = String(count)+"/140"
        if count > 120{
            numberOfCharsLeftLabel.textColor = UIColor.systemRed
        } else if count > 100 {
            numberOfCharsLeftLabel.textColor = UIColor.systemOrange
        } else {
            if #available(iOS 13.0, *) {
                numberOfCharsLeftLabel.textColor = UIColor.secondaryLabel
            } else {
                // Fallback on earlier versions
                numberOfCharsLeftLabel.textColor = UIColor.systemGray
            }
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
