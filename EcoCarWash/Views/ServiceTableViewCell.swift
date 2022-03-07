//
//  ServiceTableViewCell.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 25/10/21.
//

import UIKit
import BEMCheckBox

class ServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var serviceTitleLbl: UILabel!
    @IBOutlet weak var timeTakenLbl: UILabel!
    @IBOutlet weak var checkBox: BEMCheckBox!{
        didSet{
            checkBox.boxType = .square
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
