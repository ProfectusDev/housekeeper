//
//  SettingsViewController.swift
//  Open House
//
//  Created by Arjun Chib on 11/9/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    var settingsViewControllers: [[UIViewController]] = []
    
    let sectionTitles = [
        "Dream House",
        "User"
    ]
    
    override func loadView() {
        super.loadView()
        
        title = "Settings"
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // View Controllers
        let dreamHouseVC = DreamHouseViewController(house: House(hid: 0, address: "Dream House"))
        let userProfileVC = UserProfileViewController()
        settingsViewControllers.append([dreamHouseVC])
        settingsViewControllers.append([userProfileVC])
        
        // Add Subviews
        view.addSubview(tableView)
        
        // Layout
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalToSuperview()
            make.bottom.equalTo(0)
        }
    }
    
    func done() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = settingsViewControllers[indexPath.section][indexPath.row].title
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsViewControllers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsViewControllers[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = settingsViewControllers[indexPath.section][indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
