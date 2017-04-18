//
//  LoginViewController.swift
//  Open House
//
//  Created by Arjun Chib on 11/9/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

// Contains the UI elements and underlying funtionality for logging in
class LoginViewController: UserViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "Login"
        button.setTitle("Sign In", for: .normal)
        switchScreen.setTitle("Don't have an account?", for: .normal)
//      skip.setTitle("Skip sign in", for: .normal)

        button.addTarget(self, action: #selector(LoginViewController.handleLogin), for: .touchUpInside)
    }

    func handleLogin() {
        if !isValidEmail(emailString: email.text!) {
            alert(title: "Login Failed", message: "Invalid email.")
        } else if !isValidPassword(passwordString: password.text!) {
            alert(title: "Login Failed", message: "Invalid password.")
        } else {
            let parameters: Parameters = ["email": email.text!, "password": password.text!]
            Alamofire.request(Networking.baseURL + "/login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    if (response.error != nil) {
                        self.alert(title: "Registration Failed", message: (response.error?.localizedDescription)!)
                        return
                    }
                    let success = validate(statusCode: (response.response?.statusCode)!)
                    if success {
                        let defaults = UserDefaults.standard
                        defaults.setValue(self.email.text!, forKey: defaultsKeys.email)
                        defaults.setValue(self.password.text!, forKey: defaultsKeys.password)
                        defaults.synchronize()
                        self.handleDismiss()
                        let json = JSON(response.data!)
                        Networking.token = json["token"].stringValue
                        MyHouses.shared.pullHouses(completion: { success in
                            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "reloadHouses")))
                        })
                    } else {
                        self.alert(title: "Login Failed", message: response.result.value!)
                    }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
