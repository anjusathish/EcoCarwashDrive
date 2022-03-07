//
//  TextfieldExtension.swift
//  iJob
//
//  Created by Athiban Ragunathan on 24/02/18.
//  Copyright © 2018 Athiban Ragunathan. All rights reserved.
//

import UIKit
import TextFieldFloatingPlaceholder

extension UITextField {
    
    func addImage(image : UIImage) {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.leftView = imageView
        self.leftViewMode = .always
        self.tintColor = UIColor.ctBlue
    }
    
    func addRightImage(image : UIImage) {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.rightView = imageView
        self.rightViewMode = .always
        self.tintColor = UIColor.ctBlue
    }
    
    func addRightLabelText(text : String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 15))
        label.text = text
        label.textColor = UIColor.ctBlue
        label.font = UIFont.systemFont(ofSize: 13)
        self.rightView = label
        self.rightViewMode = .always
        self.tintColor = UIColor.ctBlue
    }
}

extension TextFieldFloatingPlaceholder {
    func changeTFColor() {
        floatingPlaceholderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 0.7307429029)
        validationFalseLineColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        validationTrueLineColor  = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        validationFalseLineEditingColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        validationTrueLineEditingColor  = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        floatingPlaceholderMinFontSize = 15
    }

}
