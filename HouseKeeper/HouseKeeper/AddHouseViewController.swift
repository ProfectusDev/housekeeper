//
//  AddHouseViewController.swift
//  Open House
//
//  Created by Arjun Chib on 11/9/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit
import Alamofire

class AddHouseViewController: UIViewController {
    
    // complete viewDidLoad() responsory function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup view primitives
        view.backgroundColor = Style.redColor
        
        // title
        let title = UILabel()
        title.text = "New House"
        title.textColor = UIColor.white
        
        // address
        let address = UITextField()
        address.placeholder = "Address"
        address.borderStyle  = UITextBorderStyle.roundedRect
        address.layer.borderColor = UIColor.white.cgColor
        address.layer.cornerRadius = 10
        address.backgroundColor = UIColor.white
        address.layer.borderWidth = 1.0
        
        
        // submission button
        let submit = UIButton()
        submit.setTitle("Add", for: UIControlState.normal)
        submit.setTitleColor(Style.redColor, for: UIControlState.normal)
        submit.layer.cornerRadius = 10
        submit.backgroundColor = UIColor.white
        submit.addTarget(self, action: #selector(self.addHouse), for: .touchUpInside)
        
        // cancellation button
        let cancel = UIButton()
        cancel.setTitle("Cancel", for: UIControlState.normal)
        cancel.setTitleColor(Style.redColor, for: UIControlState.normal)
        cancel.backgroundColor = UIColor.white
        cancel.layer.cornerRadius = 10
        cancel.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        
        // Add primitives to the view
        view.addSubview(title)
        view.addSubview(address)
        view.addSubview(submit)
        view.addSubview(cancel)
        
        // Constrain primitives using SnapKit
        // title
        title.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(50)
        }
        // address
        address.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
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
    
    func addHouse(address: AnyObject) {
        // Return house data to storage
        // COMPLETE
        let parameters: Parameters = ["address": address.text!]
        Alamofire.request(Networking.baseURL + "/addHouse", parameters: parameters).responseString { response in
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
        // Dismiss Modal ViewController
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancel(submit: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
