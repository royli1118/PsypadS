//
//  TickTableViewCell.swift
//  PsyPad
//
//  Created by Roy Li on 28/10/18.
//  Copyright © 2018 David Lawson. All rights reserved.
//

import Foundation

class TickTableViewCell: UITableViewCell {
    @IBOutlet var altTextLabel: UILabel!
    @IBOutlet var altDetailTextLabel: UILabel!
    @IBOutlet var altImageView: UIImageView!
    
    
    func styleCellSelected() {
        altImageView.isHidden = false
        altTextLabel.textColor = UIColor.blue
    }
    func styleCellNormal() {
        altImageView.isHidden = true
        altTextLabel.textColor = UIColor.black
    }
}
