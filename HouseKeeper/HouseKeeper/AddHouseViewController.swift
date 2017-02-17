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
        

        // Setup view primitives
        view.backgroundColor = Style.redColor
        
        // title
        let title = UILabel()
        title.text = "New House"
        title.textColor = UIColor.white
        
        // name
        let name = UITextField()
        name.placeholder = "Name Your House!"
        name.layer.borderColor = Style.redColor.cgColor
        name.borderStyle  = UITextBorderStyle.roundedRect
        name.layer.borderColor = UIColor.white.cgColor
        name.layer.cornerRadius = 10
        name.backgroundColor = UIColor.white
        name.layer.borderWidth = 1.0

        // address
        let address = UITextField()
        address.placeholder = "Address"
        address.layer.borderColor = Style.redColor.cgColor
        address.borderStyle  = UITextBorderStyle.roundedRect
        address.layer.borderColor = UIColor.white.cgColor
        address.layer.cornerRadius = 10
        address.backgroundColor = UIColor.white
        address.layer.borderWidth = 1.0
        
        // description
        let description = UITextView()
        description.text = "Notes"
        description.clearsOnInsertion = true
        description.layer.borderColor = UIColor.white.cgColor
        description.layer.cornerRadius = 10
        description.backgroundColor = UIColor.white
        description.layer.borderWidth = 1.0
        

        
        // submit
        submit.addTarget(self, action: #selector(AddHouseViewController.handleAddHouse), for: .touchUpInside)
        

        // add subviews
        //view.addSubview(address)

        // Add primitives to the view
        view.addSubview(title)
        view.addSubview(name)
        view.addSubview(address)
        view.addSubview(description)
        view.addSubview(submit)
        view.addSubview(cancel)

        
        // make constraints
        address.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()

            make.centerY.equalToSuperview().offset(20.0)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)

//            make.centerY.equalTo( (view.frame.height / 4) )
//            make.left.equalTo(10)
//            make.right.equalTo(-10)
        }
        // name
        name.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50.0)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
        }
        // description
        description.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(view.frame.height)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        // submit
        submit.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.width.equalTo((view.frame.width / 2) - 30)
            make.bottom.equalTo(-10)
        }
        // cancel
        cancel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo((view.frame.width / 2) - 30)
            make.bottom.equalTo(-10)
        }
        
    }
    
    func addHouse(address: AnyObject, Constant: AnyObject) {
        // Return house data to storage
        // COMPLETE
        let parameters: Parameters = ["address": address.text!]
        Alamofire.request(Constant.host + "/addHouse", parameters: parameters).responseString { response in
            if ((response.response) != nil) {
                if response.result.isSuccess && (response.response?.statusCode)! < 400 {
                    //pass
                } else {
                    //pass
                }
            } else {
                //pass
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleAddHouse() {
        let headers = generateHeaders()
        print(headers)
        print(Networking.token)
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
