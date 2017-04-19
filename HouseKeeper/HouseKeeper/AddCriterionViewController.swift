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
class AddCriterionViewController: PopUpViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var house: House?
    var category = Category.other
    let name = TextField()
    let dataType = TextField()
    let pickerView = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // title
        titleLabel.text = "Add Criterion"

        // name
        name.placeholder = "Name"
        name.layer.borderColor = Style.redColor.cgColor
        name.delegate = self
        
        // type
        dataType.placeholder = "Type"
        dataType.layer.borderColor = Style.redColor.cgColor
        dataType.delegate = self
        
        // picker
        pickerView.delegate = self
        dataType.inputView = pickerView

        // submit
        submit.addTarget(self, action: #selector(AddCriterionViewController.handleAddCriterion), for: .touchUpInside)

        // add subviews
        view.addSubview(name)
        view.addSubview(dataType)

        // make constraints
        name.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30.0)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
        }
        
        dataType.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(20.0)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
        }

    }

    func handleAddCriterion() {
        if house != nil {
            let criterion = Criterion(id: 0)
            criterion.category = category
            criterion.name = name.text!
            if let category = DataType(rawValue: dataType.text!) {
                criterion.type = category
            }
            house?.addCriterion(criterion: criterion, to: category)
        }
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "reloadCriteria")))
        self.handleDismiss()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DataType.allValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DataType.allValues[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dataType.text = DataType.allValues[row].rawValue
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
