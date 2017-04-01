//
//  CriterionTableViewCell.swift
//  HouseKeeper
//
//  Created by Arjun Chib on 3/8/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import UIKit

// This class contains the criterion table 
class CriterionTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textLabel?.textColor = Style.redColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
