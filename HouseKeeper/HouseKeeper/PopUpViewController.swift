//
//  PopUpViewController.swift
//  HouseKeeper
//
//  Created by Arjun Chib on 2/17/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
    let radius = CGFloat(15.0)
    
    let titleLabel = UILabel()
    let address = TextField()
    let submit = UIButton()
    let cancel = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // view styles
        view.backgroundColor = Style.whiteColor
        view.layer.cornerRadius = radius
        view.layer.shadowColor = Style.blackColor.cgColor
        view.layer.shadowRadius = 2.0
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
        // title
        titleLabel.text = "Title"
        titleLabel.textColor = Style.blackColor
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightHeavy)
        
        // address
        address.placeholder = "Address"
        address.layer.borderColor = Style.redColor.cgColor
        
        // cancel button
        cancel.setTitle("Cancel", for: UIControlState.normal)
        cancel.setTitleColor(Style.whiteColor, for: UIControlState.normal)
        cancel.backgroundColor = Style.redColor
        cancel.addTarget(self, action: #selector(PopUpViewController.handleCancel), for: .touchUpInside)
        
        // submit button
        submit.setTitle("Add", for: UIControlState.normal)
        submit.setTitleColor(Style.whiteColor, for: UIControlState.normal)
        submit.backgroundColor = Style.redColor
//        submit.addTarget(self, action: #selector(self.addHouse), for: .touchUpInside)
        
        // Add primitives to the view
        view.addSubview(titleLabel)
        view.addSubview(address)
        view.addSubview(submit)
        view.addSubview(cancel)
        
        // make contraints
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(30)
        }
        
        address.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20.0)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
        }
        
        submit.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.width.equalTo(view.frame.width / 2)
            make.bottom.equalTo(0)
            make.height.equalTo(60)
        }
        
        cancel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.width.equalTo(view.frame.width / 2)
            make.bottom.equalTo(0)
            make.height.equalTo(60)
        }
    }
    
    override func viewDidLayoutSubviews() {
        let width = Style.screenWidth - 40.0
        let height = width * 0.75
        let x = CGFloat(20.0)
        let y = Style.screenHeight / 2.0 - height / 2.0
        let frame  = CGRect(x: x, y: y, width: width, height: height)
        
        self.view.frame = frame
        
        cancel.round(corners: .bottomLeft, radius: radius)
        submit.round(corners: .bottomRight, radius: radius)
    }
    
    func handleCancel() {
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
