//
//  AddCriterionViewController.swift
//  HouseKeeper
//
//  Created by Arjun Chib on 3/10/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import UIKit
import Alamofire

// Functionality for adding custom criterion
class AddCriterionViewController: PopUpViewController {

    var house: House?
    var category = Category.other
    let name = TextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        // title
        titleLabel.text = "Add Criterion"

        // address
        name.placeholder = "Name"
        name.layer.borderColor = Style.redColor.cgColor
        name.delegate = self

        // submit
        submit.addTarget(self, action: #selector(AddCriterionViewController.handleAddCriterion), for: .touchUpInside)

        // add subviews
        view.addSubview(name)

        // make constraints
        name.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20.0)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
        }

    }

    func handleAddCriterion() {
        if house != nil {
            if let index = Category.allValues.index(of: category) {
                let criterion = Criterion(id: 0)
                criterion.category = category
                criterion.name = name.text!
                house?.criteria[index].append(criterion)
            }
        }
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "reloadCriteria")))
        self.handleDismiss()
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
