//
//  HouseViewController.swift
//  Open House
//
//  Created by Arjun Chib on 11/9/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class HouseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var hid = 0
    var criteria = Array(repeating: [Criterion](), count: Category.allValues.count)
    let tableView = UITableView()
    
    convenience init(hid: Int) {
        self.init()
        self.hid = hid
    }

    override func loadView() {
        super.loadView()
        
        // VC
        view.backgroundColor = UIColor.white
        
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HouseTableViewCell.self, forCellReuseIdentifier: "criterion")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // Navigation Bar
        navigationItem.rightBarButtonItem = editButtonItem
        
        // Networking
        loadCriteria()
    }
    
    // Networking
    func loadCriteria() {
        if (Networking.token == "" || hid == 0) {
            return
        }
        let headers = generateHeaders()
        let parameters: Parameters = ["hid": hid]
        Alamofire.request(Networking.baseURL + "/getCriteria", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseString { response in
                if (response.error != nil) {
                    print("Get criteria failed: " + (response.error?.localizedDescription)!)
                    return
                }
                let success = validate(statusCode: (response.response?.statusCode)!)
                if success {
                    for section in 0..<self.criteria.count {
                        self.criteria[section].removeAll()
                    }
                    let json = JSON(response.data!).arrayValue
                    for criterionData in json {
                        let criterion = Criterion.decodeJSON(data: criterionData.dictionaryValue)
                        let category = criterion.category
                        self.criteria[Category.allValues.index(of: category)!].append(criterion)
                    }
                    self.tableView.reloadData()
                } else {
                    print("Get criteria failed: " + response.result.value!)
                }
        }
    }
    
    // Rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.row < criteria[indexPath.section].count {
            cell = CriterionTableViewCell(style: .default, reuseIdentifier: "criterion")
            cell.textLabel!.text = criteria[indexPath.section][indexPath.row].name
        } else {
            cell = AddCriterionTableViewCell(style: .default, reuseIdentifier: "criterion")
            cell.textLabel!.text = "Add Criterion"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < criteria[indexPath.section].count {
            // nothing
        } else {
            // present view
        }
    }
    
    // Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return criteria.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return criteria[section].count + 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Category.allValues[section].rawValue.capitalized
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightHeavy)
        header.textLabel?.textColor = Style.blackColor
        header.contentView.backgroundColor = Style.whiteColor
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    // Editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let id = self.criteria[indexPath.section][indexPath.row].id
            let headers = generateHeaders()
            let parameters: Parameters = ["id": id, "hid": self.hid]
            Alamofire.request(Networking.baseURL + "/deleteCriteria", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseString { response in
                    if (response.error != nil) {
                        print("Delete criteria failed: " + (response.error?.localizedDescription)!)
                        return
                    }
                    let success = validate(statusCode: (response.response?.statusCode)!)
                    if success {
                        self.criteria[indexPath.section].remove(at: indexPath.row)
                        self.tableView.reloadData()
                    } else {
                        // self.alert(title: "Registration Failed", message: response.result.value!)
                        print("Delete criteria failed: " + response.result.value!)
                    }
            }
        }
        
        return [delete]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
