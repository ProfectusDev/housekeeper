//
//  CriterionTableViewCell.swift
//  HouseKeeper
//
//  Created by Arjun Chib on 3/8/17.
//  Copyright © 2017 Profectus. All rights reserved.
//

import UIKit

class CriterionTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
