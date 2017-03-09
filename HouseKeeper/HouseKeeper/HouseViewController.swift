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
    var criteria: [Criterion] = []
    let tableView = UITableView()
    
    convenience init(hid: Int) {
        self.init()
        self.hid = hid
    }
    
    override func loadView() {
        super.loadView()
        
        // VC
        view.backgroundColor = UIColor.white
        title = "The House"
        
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
                    self.criteria.removeAll()
                    let json = JSON(response.data!).arrayValue
                    for criterionData in json {
                        let criterion = Criterion.decodeJSON(data: criterionData.dictionaryValue)
                        self.criteria.append(criterion)
                    }
                    self.tableView.reloadData()
                } else {
                    print("Get criteria failed: " + response.result.value!)
                }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "criterion")
        cell.textLabel!.text = criteria[indexPath.row].name
//        cell.imageView?.image = UIImage(named: "Placeholder")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return criteria.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
