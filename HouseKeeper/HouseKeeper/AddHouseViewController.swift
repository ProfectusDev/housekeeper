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
        if Networking.userID == 0 {
            return
        }
        let headers = generateHeaders()
        let parameters: Parameters = ["address": address.text!, "id": Networking.userID]
        Alamofire.request(Networking.baseURL + "/addHouse", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseString { response in
                if (response.error != nil) {
//                    self.alert(title: "Add House Failed", message: (response.error?.localizedDescription)!)
                    print("Add House Failed: " + (response.error?.localizedDescription)!)
                    return
                }
                let success = validate(statusCode: (response.response?.statusCode)!)
                if success {
                    self.handleDismiss()
                    let json = JSON(response.data!)
                    print(json)
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "loadHouses")))
                } else {
//                    self.alert(title: "Registration Failed", message: response.result.value!)
                    print("Add House Failed: " + response.result.value!)
                }
        }
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
