//
//  DreamHouseViewController.swift
//  HouseKeeper
//
//  Created by John Fiorentino on 3/30/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class DreamHouseViewController: HouseViewController {
    
    init() {
        super.init(house: DreamHouse.shared)
        title = "Dream House"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        tableView.contentInset.top = 0.0
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        chart.isHidden = true
        refreshControl.bounds = refreshControl.bounds.offsetBy(dx: 0, dy: -200)
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let rootViewController = appDelegate.window!.rootViewController as! RootViewController
        view.addSubview(rootViewController.blurEffectView)
    }
    
    
}
