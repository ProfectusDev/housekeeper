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
        
        // Attach text to title object
        viewTitle.text = "My Dream House"
        
        // Add to subview
        view.addSubview(viewTitle)
        
        viewTitle.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.centerY.equalToSuperview()
            make.bottom.equalTo(20)
        }
    }
}
