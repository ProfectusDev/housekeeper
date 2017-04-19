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
    
    var houses = MyHouses.shared.houses
    var filteredHouses: [House] = []
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    let settingsNavigationController = UINavigationController(rootViewController: SettingsViewController())
    
    override func loadView() {
        super.loadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyHousesViewController.reloadHouses), name: NSNotification.Name(rawValue: "reloadHouses"), object: nil)
        
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
        definesPresentationContext = false
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
        super.viewWillAppear(animated)
        MyHouses.shared.syncHouses(completion: { (success) in
            self.reloadHouses()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MyHouses.shared.syncHouses(completion: { (success) in
            self.reloadHouses()
        })
    }
    
    func reloadHouses() {
        houses = MyHouses.shared.houses
        self.houses.sort { (houseA, houseB) -> Bool in
            return houseA.rank > houseB.rank
        }
        self.tableView.reloadData()
    }
    
    func refresh() {
        MyHouses.shared.syncHouses(completion: { (success) in
            self.reloadHouses()
            self.refreshControl.endRefreshing()
        })
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
        
        var house = houses[indexPath.row]
        if searchController.isActive && searchController.searchBar.text != "" {
            house = filteredHouses[indexPath.row]
        } else {
            house = houses[indexPath.row]
        }
        cell.titleLabel.text = house.address
        cell.descriptionLabel.text = "Dream House Similarity: \(round(house.rank * 100))%"
        
        cell.photoView.image = house.image
        
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
            MyHouses.shared.removeHouse(at: indexPath.row)
            self.reloadHouses()
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
