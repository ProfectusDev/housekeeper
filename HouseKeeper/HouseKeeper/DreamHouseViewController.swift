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
    
    let viewTitle = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Attach text to viewTitle object
        viewTitle.text = "My Dream House"        
        
        // Add to subview
        view.addSubview(viewTitle)
        
        viewTitle.snp.makeConstraints { make in
            make.top.equalTo(3)
            make.centerX.equalToSuperview()
        }
    }
}
