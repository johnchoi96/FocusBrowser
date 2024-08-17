//
//  DeniedURLTableViewCell.swift
//  MyBrowser
//
//  Created by John Choi on 4/30/22.
//  Copyright © 2022 John Choi. All rights reserved.
//

import UIKit

class DeniedURLTableViewCell: UITableViewCell {

    @IBOutlet weak var deniedUrlLabel: UILabel!

    static let nib = UINib(nibName: "DeniedURLTableViewCell", bundle: nil)
    static let identifier = K.Cells.deniedURLCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
