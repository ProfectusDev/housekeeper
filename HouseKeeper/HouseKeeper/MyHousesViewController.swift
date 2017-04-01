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

class MyHousesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var houses: [House] = []
    var filteredHouses: [House] = []
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    let settingsNavigationController = UINavigationController(rootViewController: SettingsViewController())
    
    override func loadView() {
        super.loadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyHousesViewController.loadHouses), name: NSNotification.Name(rawValue: "loadHouses"), object: nil)
        
        // VC
        title = "Houses"
        
        // Table View
        refreshControl.addTarget(self, action: #selector(MyHousesViewController.refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.contentInset.bottom = 44.0
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HouseTableViewCell.self, forCellReuseIdentifier: "house")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // Search Bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
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
        
        // Navigation bar
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        houses.sort { (houseA, houseB) -> Bool in
            return houseA.rank > houseB.rank
        }
        tableView.reloadData()
    }
    
    func loadHouses() {
        if (Networking.token == "") {
            return
        }
        let headers = generateHeaders()
        Alamofire.request(Networking.baseURL + "/getHouses", method: .get, headers: headers)
            .responseString { response in
                if (response.error != nil) {
                    print("Get houses failed: " + (response.error?.localizedDescription)!)
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
                    print("Get house failed: " + response.result.value!)
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
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "blur")))
    }
    
    func openSettings() {
        present(settingsNavigationController, animated: true, completion: nil)
    }
    
    func closeSettings() {
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredHouses = houses.filter { house in
            return house.address.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HouseTableViewCell(style: .default, reuseIdentifier: "house")
        cell.photoView.image = UIImage(named: "Placeholder")
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.titleLabel.text = filteredHouses[indexPath.row].address
        } else {
            cell.titleLabel.text = houses[indexPath.row].address
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredHouses.count
        }
        return houses.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let house = houses[indexPath.row]
        let houseVC = HouseViewController(house: house)
        houseVC.title = houses[indexPath.row].address
        navigationController?.pushViewController(houseVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let headers = generateHeaders()
            let parameters: Parameters = ["hid": self.houses[indexPath.row].hid]
            Alamofire.request(Networking.baseURL + "/deleteHouse", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseString { response in
                    if (response.error != nil) {
                        print("Delete house failed: " + (response.error?.localizedDescription)!)
                        return
                    }
                    let success = validate(statusCode: (response.response?.statusCode)!)
                    if success {
                        self.houses.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    } else {
                        // self.alert(title: "Registration Failed", message: response.result.value!)
                        print("Delete house failed: " + response.result.value!)
                    }
            }
        }
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
