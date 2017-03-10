//
//  ViewController.swift
//  OpenHouse
//
//  Created by Arjun Chib on 11/7/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit

class RootViewController: UINavigationController {
    
    let blurEffectView = UIVisualEffectView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.blur), name: NSNotification.Name(rawValue: "blur"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.unBlur), name: NSNotification.Name(rawValue: "unblur"), object: nil)
        
        view.backgroundColor = UIColor.white
        navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightHeavy)]
        
        blurEffectView.frame = self.view.frame
        
        self.view.addSubview(blurEffectView)
        blurEffectView.isHidden = true
    }
    
    func blur() {
        blurEffectView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.blurEffectView.effect = UIBlurEffect(style: .light)
        }
    }
    
    func unBlur() {
//        UIView.animate(withDuration: 0.3) {
//            self.blurEffectView.effect = nil
//        }
//        
//        UIView.animate(withDuration: 0.3, animations: { 
//            self.blurEffectView.effect = nil
//        }, completion: {
//            blurEffectView.isHidden
//        })
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.blurEffectView.effect = nil
        }, completion: { (complete: Bool) in
            self.blurEffectView.isHidden = true
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

