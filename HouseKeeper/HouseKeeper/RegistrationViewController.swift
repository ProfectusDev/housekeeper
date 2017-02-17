//
//  RegistrationViewController.swift
//  Open House
//
//  Created by Arjun Chib on 11/9/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit
import Alamofire

class RegistrationViewController: UserViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Registration"
        button.setTitle("Sign Up", for: .normal)
        switchScreen.setTitle("Already have an account?", for: .normal)
        skip.setTitle("Skip registration", for: .normal)
        
        button.addTarget(self, action: #selector(RegistrationViewController.handleRegistration), for: .touchUpInside)
    }
    
    func handleRegistration() {
        if !isValidEmail(emailString: email.text!) {
            alert(title: "Registration Failed", message: "Invalid email.")
        } else if !isValidPassword(passwordString: password.text!) {
            alert(title: "Registration Failed", message: "Password must be between 8 and 32 characters.")
        } else {
            let parameters: Parameters = ["email": email, "password": password]
            Alamofire.request(Networking.baseURL + "/createUser", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    switch response.result {
                    case .success:
                        self.handleDismiss()
                    case .failure(let error):
                        print(error)
                        self.alert(title: "Registration Failed", message: response.result.value!)
                    }
            }
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _ = super.textFieldShouldReturn(textField)
        handleRegistration()
        return false
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
