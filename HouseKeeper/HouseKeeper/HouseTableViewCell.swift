//
//  HouseTableViewCell.swift
//  Open House
//
//  Created by Arjun Chib on 11/18/16.
//  Copyright © 2016 Profectus. All rights reserved.
//

import UIKit


// The house list table UI
class HouseTableViewCell: UITableViewCell {

    let group = UIView()
    let photoView = UIImageView()
    let titleLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        photoView.layer.cornerRadius = 12.0
        photoView.clipsToBounds = true

        addSubview(group)
        group.addSubview(photoView)
        group.addSubview(titleLabel)

        group.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        photoView.snp.makeConstraints({ (make) in
            make.size.equalTo(100).priority(1000)
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        })

        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(130)
            make.top.equalTo(15)
        })
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            group.snp.updateConstraints({ (make) in
                make.left.equalTo(35)
            })
        } else {
            group.snp.updateConstraints({ (make) in
                make.left.equalTo(0)
            })
        }

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
