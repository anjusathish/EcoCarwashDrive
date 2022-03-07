//
//  DayItemView.swift
//  Ana Vodafone
//
//  Created by Ahmed Nasser on 1/16/19.
//  Copyright © 2019 Vodafone Egypt. All rights reserved.
//

import UIKit

class DayItemView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var selectedDateView: UIView!
    var value : String?
    private var color : UIColor?
    private var bgColor : UIColor?
    var loadFirstTime = false
    var selected:Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    private func nibSetup() {
        contentView = loadViewFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(contentView)
    }
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of:self))
        let nib = UINib(nibName: String(describing: type(of:self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    func setData(date: String, day: String) {
        self.value = date
        self.dateLbl.text = date
        self.dayLbl.text = day
    }
    func setLabelColor(_ color :UIColor,newValue:String?){
        self.color = color
        if dateLbl != nil {
            self.dateLbl.textColor = color
        }
    }
    
    override func setSmoothSelected(_ selected: Bool) {
        self.selected = selected
        self.color = UIColor.cwBlue
        self.bgColor = selected ? .cwSecondary : .white
        
        
        loadFirstTime = true
        if dateLbl != nil {
            self.selectedDateView.backgroundColor = bgColor
            self.dateLbl.textColor = color
        }
    }
}
