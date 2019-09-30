//
//  ServantTableViewHeaderView.swift
//  FateIndex+
//
//  Created by Peter Guan on 2019/8/1.
//  Copyright © 2019 管君. All rights reserved.
//

import UIKit

class ServantTableViewHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "ServantTableViewHeaderView"
    
    var title: String? {
        didSet {
            textLabel?.text = title
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        title = nil
    }
    
}
