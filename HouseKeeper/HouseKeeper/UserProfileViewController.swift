//
//  UserProfileViewController.swift
//  HouseKeeper
//
//  Created by Arjun Chib on 4/14/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    let button = UIButton()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = "Profile"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(button)

        // button
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(Style.whiteColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium)
        button.backgroundColor = Style.redColor
        button.layer.cornerRadius = Style.buttonRadius
        button.addTarget(self, action: #selector(UserProfileViewController.handleLogout), for: .touchUpInside)
        
        // layout views
        button.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalToSuperview().inset(50)
            make.top.equalTo(100)
            make.centerX.equalToSuperview()
        }
    }
    
    func handleLogout() {
        let defaults = UserDefaults.standard
        defaults.setValue(nil, forKey: defaultsKeys.email)
        defaults.setValue(nil, forKey: defaultsKeys.password)
        defaults.synchronize()
        Networking.token = ""
        
        dismiss(animated: true, completion: {
            let appDelegate  = UIApplication.shared.delegate as! AppDelegate
            let viewController = appDelegate.window!.rootViewController as! RootViewController
            viewController.launchLoginVC(animated: true)
        })
        
        navigationController?.popToRootViewController(animated: false)
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
