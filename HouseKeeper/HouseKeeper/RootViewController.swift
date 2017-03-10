//
//  ViewController.swift
//  OpenHouse
//
//  Created by Arjun Chib on 11/7/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit

class RootViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightHeavy)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

