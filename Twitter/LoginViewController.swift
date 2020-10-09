//
//  LoginViewController.swift
//  Twitter
//
//  Created by Esther Max-Onakpoya on 10/3/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var loginButton: UIButton!
    
    @IBAction func tappedLogin(_ sender: UIButton) {
        let requestUrl = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: requestUrl, success: {
            UserDefaults.standard.set(true, forKey: Constants.logInKey)
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }, failure: {(Error) in
            print("Could not peform segue")
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = loginButton.frame.height/4
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: Constants.logInKey){
            self.performSegue(withIdentifier: "loginSegue", sender: self)
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
