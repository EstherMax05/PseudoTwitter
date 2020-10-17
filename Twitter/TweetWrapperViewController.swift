//
//  TweetWrapperViewController.swift
//  Twitter
//
//  Created by Esther Max-Onakpoya on 10/17/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetWrapperViewController: UINavigationController {

    var profileImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func willMove(toParent parent: UIViewController?) {
        //
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let viewController = segue.destination as! TweetViewController
        viewController.profileImage = profileImage // modify this
    }
    

}
