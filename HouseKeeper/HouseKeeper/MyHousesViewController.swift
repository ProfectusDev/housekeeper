//
//  MyHousesViewController.swift
//  Open House
//
//  Created by Arjun Chib on 11/9/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class MyHousesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var houses: [House] = []
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    
    override func loadView() {
        super.loadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyHousesViewController.loadHouses), name: NSNotification.Name(rawValue: "loadHouses"), object: nil)
        
        // VC
        title = "My Houses"
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(MyHousesViewController.refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HouseTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        // Bottom Toolbar
        let bottomToolbar = UIToolbar()
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MyHousesViewController.addHouse))
        let cogButtonItem = UIBarButtonItem(image: UIImage(named: "Setting Cog"), style: .plain, target: self, action: #selector(MyHousesViewController.openSettings))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        bottomToolbar.setItems([cogButtonItem, flexibleSpace, addButtonItem], animated: false)
        view.addSubview(bottomToolbar)
        
        bottomToolbar.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.width.equalToSuperview()
        }
    }
    
    func loadHouses() {
        if (Networking.token == "") {
            return
        }
        let headers = generateHeaders()
        Alamofire.request(Networking.baseURL + "/getHouses", method: .get, headers: headers)
            .responseString { response in
                if (response.error != nil) {
                    // self.alert(title: "Add House Failed", message: (response.error?.localizedDescription)!)
                    print("Get Houses Failed: " + (response.error?.localizedDescription)!)
                    return
                }
                let success = validate(statusCode: (response.response?.statusCode)!)
                if success {
                    self.houses.removeAll()
                    let json = JSON(response.data!).arrayValue
                    for houseData in json {
                        var data = houseData.dictionaryValue
                        let hid = data["hid"]?.intValue
                        let address = data["address"]?.stringValue
                        let house = House(hid: hid!, address: address!)
                        self.houses.append(house)
                    }
                    self.tableView.reloadData()
                } else {
                    // self.alert(title: "Registration Failed", message: response.result.value!)
                    print("Get House Failed: " + response.result.value!)
                }
        }
    }
    
    func refresh() {
        loadHouses()
        refreshControl.endRefreshing()
    }
    
    func addHouse() {
        let modal = AddHouseViewController()
        modal.modalPresentationStyle = .overCurrentContext
        present(modal, animated: true, completion: nil)
    }
    
    func openSettings() {
        present(SettingsViewController(), animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel!.text = houses[indexPath.row].address
        cell.imageView?.image = UIImage(named: "Placeholder")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houses.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(HouseViewController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
