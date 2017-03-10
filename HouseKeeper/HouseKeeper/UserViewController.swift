//
//  UserViewController.swift
//  HouseKeeper
//
//  Created by Arjun Chib on 1/25/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import UIKit
import SnapKit

class UserViewController: UIViewController, UITextFieldDelegate {
    
    let wrapper = UIView()
    let group = UIView()
    let titleLabel = UILabel()
    let email = TextField()
    let password = TextField()
    let button = UIButton()
    let switchScreen = UIButton()
    //let skip = UIButton()
    var keyboardHeight = CGFloat(200.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Style.redColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(UserViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(UserViewController.updateKeyboardHeight), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        // title
        titleLabel.text = "Title"
        titleLabel.textColor = Style.whiteColor
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightHeavy)
        
        // email
        email.layer.borderColor = Style.whiteColor.cgColor
        email.placeholder = "Email"
        email.textColor = Style.whiteColor
        email.autocapitalizationType = .none
        email.autocorrectionType = .no
        email.keyboardType = .emailAddress
        email.delegate = self
        
        // password
        password.layer.borderColor = Style.whiteColor.cgColor
        password.placeholder = "Password"
        password.textColor = Style.whiteColor
        password.isSecureTextEntry = true
        password.autocapitalizationType = .none
        password.autocorrectionType = .no
        password.delegate = self
        
        // button
        button.setTitle("Button", for: .normal)
        button.setTitleColor(Style.redColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium)
        button.backgroundColor = Style.whiteColor
        button.layer.cornerRadius = Style.buttonRadius
        
        // switchScreen
        switchScreen.setTitle("Switch this screen", for: .normal)
        switchScreen.setTitleColor(Style.whiteColor, for: .normal)
        switchScreen.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        switchScreen.titleLabel?.textAlignment = .center
        switchScreen.addTarget(self, action: #selector(UserViewController.handleSwitch), for: .touchUpInside)
        
        // skip
//        skip.setTitle("Skip", for: .normal)
//        skip.setTitleColor(Style.whiteColor, for: .normal)
//        skip.titleLabel?.font = UIFont.systemFont(ofSize: 17)
//        skip.titleLabel?.textAlignment = .center
//        skip.addTarget(self, action: #selector(UserViewController.handleDismiss), for: .touchUpInside)
        
        // insert subviews
        group.addSubview(titleLabel)
        group.addSubview(email)
        group.addSubview(password)
        group.addSubview(button)
        group.addSubview(switchScreen)
//      view.addSubview(skip)
        wrapper.addSubview(group)
        view.addSubview(wrapper)
        
        // make contraints
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        email.snp.remakeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        password.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(email.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(password.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        switchScreen.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
//        skip.snp.makeConstraints { (make) in
//            make.width.equalToSuperview()
//            make.bottom.equalTo(view.snp.bottom).inset(20)
//            make.centerX.equalToSuperview()
//            make.height.equalTo(17)
//        }
        
        group.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(40)
            make.center.equalToSuperview()
            make.height.equalTo(250)
        }
        
        wrapper.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    func handleSwitch() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = "flip"
        transition.subtype = kCATransitionFromLeft
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.setViewControllers([
            (navigationController?.viewControllers[1])!,
            (navigationController?.viewControllers[0])!
            ], animated: false)
    }
    
    func handleDismiss() {
        navigationController?.view.layer.removeAllAnimations()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.wrapper.snp.updateConstraints { (make) in
                make.bottom.equalTo(-self.keyboardHeight + 50)
            }
            self.wrapper.superview?.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.wrapper.snp.updateConstraints { (make) in
                make.bottom.equalTo(0)
            }
            self.wrapper.superview?.layoutIfNeeded()
        }
    }
    
    func updateKeyboardHeight(notification: Notification) {
        keyboardHeight = ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size.height)!
    }
    
    func isValidEmail(emailString: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailString) && emailString.characters.count <= 256
    }
    
    func isValidPassword(passwordString: String) -> Bool {
        if passwordString.characters.count <= 32 && passwordString.characters.count >= 8 {
            return true
        } else {
            return false
        }
    }
    
    func isValidAddress(addressString: String) -> Bool {
        let addressRegEx = "[A-Z0-9a-z.]"
        
        let addressTest = NSPredicate(format:"SELF MATCHES %@", addressRegEx)
        return addressTest.evaluate(with: addressString) && addressString.characters.count <= 256
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
