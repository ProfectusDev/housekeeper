//
//  SettingsViewController.swift
//  Open House
//
//  Created by Arjun Chib on 11/9/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    let dreamHouseVC = DreamHouseViewController()
    
    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor.white
        
        
        // Top Toolbar
        let navigationBar = UINavigationBar()
        
        let navigationItem = UINavigationItem(title: "Settings")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationBar.setItems([navigationItem], animated: false)
        
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Add Subviews
        view.addSubview(tableView)
        view.addSubview(navigationBar)
        view.addSubview(dreamHouseVC.view)
        
        // Layout
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalTo(0)
        }
        
        navigationBar.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalToSuperview()
            make.height.equalTo(64)
        }
        
        dreamHouseVC.view.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalTo(0)
        }
    }
    
    func done() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
