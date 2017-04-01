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
    
    var house: House
    var hid: Int
    var criteria = Array(repeating: [Criterion](), count: Category.allValues.count)
    let tableView = UITableView()
    
    init(house: House) {
        self.house = house
        hid = house.hid
        super.init(nibName: nil, bundle: nil)
        updateRank()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HouseViewController.loadCriteria), name: NSNotification.Name(rawValue: "loadCriteria"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HouseViewController.criteriaSelectorChanged), name: NSNotification.Name(rawValue: "radioChanged"), object: nil)
        
        // VC
        view.backgroundColor = UIColor.white
        
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HouseTableViewCell.self, forCellReuseIdentifier: "criterion")
        tableView.backgroundColor = Style.whiteColor
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
        if isCriteriaRow(at: indexPath) {
            cell = CriterionTableViewCell(style: .default, reuseIdentifier: "criterion")
            cell.textLabel?.textColor = Style.redColor
            cell.selectionStyle = .none
            cell.textLabel!.text = criteria[indexPath.section][indexPath.row].name
            let type = criteria[indexPath.section][indexPath.row].type
            var criteriaSelector = CriteriaSelector()
            if type == .binary {
                criteriaSelector = BinaryCriteriaSelector()
            } else if type == .ternary {
                criteriaSelector = TernaryCriteriaSelector()
            }
            criteriaSelector.value = criteria[indexPath.section][indexPath.row].value
            cell.accessoryView = criteriaSelector
        } else {
            cell = AddCriterionTableViewCell(style: .default, reuseIdentifier: "criterion")
            cell.textLabel?.textColor = Style.grayColor
            cell.textLabel!.text = "Add Criterion"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isCriteriaRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Style.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isCriteriaRow(at: indexPath) {
            let modal = AddCriterionViewController()
            modal.hid = hid
            modal.category = Category.allValues[indexPath.section]
            modal.modalPresentationStyle = .overCurrentContext
            present(modal, animated: true, completion: {
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "blur")))
        }
    }
    
    func criteriaSelectorChanged(notification: Notification) {
        let radio = notification.object as! RadioButton
        let criteriaSelector = radio.superview as! CriteriaSelector
        let cell = criteriaSelector.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        criteria[indexPath.section][indexPath.row].value = criteriaSelector.value
        handleCriteriaUpdate(indexPath: indexPath)
        updateRank()
    }
    
    func handleCriteriaUpdate(indexPath: IndexPath) {
        if Networking.token == "" && hid == 0 {
            return
        }
        let id = self.criteria[indexPath.section][indexPath.row].id
        let value = self.criteria[indexPath.section][indexPath.row].value
        let headers = generateHeaders()
        let parameters: Parameters = ["hid": hid, "id": id, "value": value]
        Alamofire.request(Networking.baseURL + "/updateCriterion", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseString { response in
                if (response.error != nil) {
                    print("Update criterion failed: " + (response.error?.localizedDescription)!)
                    return
                }
                let success = validate(statusCode: (response.response?.statusCode)!)
                if !success {
                    print("Update criterion failed: " + response.result.value!)
                }
        }
    }
    
    func updateRank() {
        var rank = 0.0
        for section in criteria {
            for criterion in section {
                rank += Double(criterion.value)
            }
        }
        house.rank = rank
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
        header.layer.zPosition = 0
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
            Alamofire.request(Networking.baseURL + "/deleteCriterion", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return isCriteriaRow(at: indexPath)
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let rowToMove = criteria[sourceIndexPath.section][sourceIndexPath.row]
        criteria[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        criteria[destinationIndexPath.section].insert(rowToMove, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            return sourceIndexPath
        }
        if proposedDestinationIndexPath.row >= criteria[proposedDestinationIndexPath.section].count {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
    // Utility
    func isCriteriaRow(at indexPath: IndexPath) -> Bool {
        return indexPath.row < criteria[indexPath.section].count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
