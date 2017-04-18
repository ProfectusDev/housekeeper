//
//  AddHouseViewController.swift
//  Open House
//
//  Created by Arjun Chib on 11/9/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


// This class contains the UI elements and the underlying functionality for adding a house
class AddHouseViewController: PopUpViewController {

    let address = TextField()

    // complete viewDidLoad() responsory function
    override func viewDidLoad() {
        super.viewDidLoad()

        // title
        titleLabel.text = "Add House"

        // address
        address.placeholder = "Address"
        address.layer.borderColor = Style.redColor.cgColor
        address.delegate = self

        // submit
        submit.addTarget(self, action: #selector(AddHouseViewController.handleAddHouse), for: .touchUpInside)

        // add subviews
        view.addSubview(address)

        // make constraints
        address.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20.0)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleAddHouse() {
        let newHouse = House(hid: 0, address: address.text!)
        MyHouses.shared.addHouse(house: newHouse)
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "reloadHouses")))
        self.handleDismiss()
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
