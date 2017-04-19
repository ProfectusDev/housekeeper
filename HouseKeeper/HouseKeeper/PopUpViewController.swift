//
//  PopUpViewController.swift
//  HouseKeeper
//
//  Created by Arjun Chib on 2/17/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import UIKit

// Creation of the pop up window for adding a new house 
class PopUpViewController: UIViewController, UITextFieldDelegate {

    let radius = CGFloat(15.0)

    let titleLabel = UILabel()
    let submit = UIButton()
    let cancel = UIButton()
    var keyboardHeight = CGFloat(258.0)
    var layedout = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // events
        let tap = UITapGestureRecognizer(target: self, action: #selector(UserViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(UserViewController.updateKeyboardHeight), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        // view styles
        view.backgroundColor = Style.whiteColor
        view.layer.cornerRadius = radius
        view.layer.shadowColor = Style.blackColor.cgColor
        view.layer.shadowRadius = 2.0
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)

        // title
        titleLabel.text = "Title"
        titleLabel.textColor = Style.blackColor
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightHeavy)

        // cancel button
        cancel.setTitle("Cancel", for: UIControlState.normal)
        cancel.setTitleColor(Style.whiteColor, for: UIControlState.normal)
        cancel.backgroundColor = Style.redColor
        cancel.addTarget(self, action: #selector(PopUpViewController.handleDismiss), for: .touchUpInside)

        // submit button
        submit.setTitle("Add", for: UIControlState.normal)
        submit.setTitleColor(Style.whiteColor, for: UIControlState.normal)
        submit.backgroundColor = Style.redColor

        // Add primitives to the view
        view.addSubview(titleLabel)
        view.addSubview(submit)
        view.addSubview(cancel)

        // make contraints
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(30)
        }

        submit.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.width.equalTo(view.frame.width / 2)
            make.bottom.equalTo(0)
            make.height.equalTo(60)
        }

        cancel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.width.equalTo(view.frame.width / 2)
            make.bottom.equalTo(0)
            make.height.equalTo(60)
        }
    }

    override func viewDidLayoutSubviews() {
        if !layedout {
            layoutFrameWithoutKeyboard()
            layedout = true
        }

        cancel.round(corners: .bottomLeft, radius: radius)
        submit.round(corners: .bottomRight, radius: radius)
    }

    func layoutFrameWithKeyboard(textField: UITextField) {
        let width = Style.screenWidth - 40.0
        let height = width * 0.75
        let x = CGFloat(20.0)
        let y = Style.screenHeight - keyboardHeight - height - 20.0
        let frame  = CGRect(x: x, y: y, width: width, height: height)

        self.view.frame = frame
    }

    func layoutFrameWithoutKeyboard() {
        let width = Style.screenWidth - 40.0
        let height = width * 0.75
        let x = CGFloat(20.0)
        let y = Style.screenHeight / 2.0 - height / 2.0
        let frame  = CGRect(x: x, y: y, width: width, height: height)

        self.view.frame = frame
    }

    func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "unblur")))
    }

    func updateKeyboardHeight(notification: Notification) {
        let newKeyboardHeight = ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size.height)!
        if newKeyboardHeight > keyboardHeight {
            keyboardHeight = newKeyboardHeight
        }
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
            self.layoutFrameWithKeyboard(textField: textField)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.layoutFrameWithoutKeyboard()
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
