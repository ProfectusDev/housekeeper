//
//  SettingsViewController.swift
//  Open House
//
//  Created by Arjun Chib on 11/9/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit

// The UI elements and underlying functionlality for the settings page
class SettingsViewController: UIViewController {

    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor.white


        // Top Toolbar

        let navigationBar = UINavigationBar()

        let navigationItem = UINavigationItem(title: "Settings")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationBar.setItems([navigationItem], animated: false)

        view.addSubview(navigationBar)

        navigationBar.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalToSuperview()
            make.height.equalTo(64)
        }
    }

    func done() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
