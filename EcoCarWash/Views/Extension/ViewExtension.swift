//
//  ViewExtension.swift
//  iJob
//
//  Created by Athiban Ragunathan on 02/03/18.
//  Copyright © 2018 Athiban Ragunathan. All rights reserved.
//

import UIKit

extension UIView{
    
    var globalPoint :CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
    
    var globalFrame :CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
    
    func addDashedBorder() {
        let color = UIColor.cwSecondary.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [2, 2]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}

extension UIViewController {
    
//    func showDateTimePicker(mode : UIDatePicker.Mode, selectedDate : Date? = Date()) -> PickerViewController {
//
//        let vc = UIStoryboard.attendanceStoryboard().instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
//        vc.mode = mode
//        vc.currentDate = selectedDate
//        present(controllerInSelf: vc)
//        return vc
//    }
    
//    func present(controllerInSelf controller : UIViewController) {
//        
//        let popUpController = STPopupController(rootViewController: controller)
//        popUpController.backgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss(gesture:))))
//
//        popUpController.hidesCloseButton = true
//        popUpController.style = .bottomSheet
//        popUpController.navigationBarHidden = true
//        popUpController.containerView.backgroundColor = UIColor.clear
//        popUpController.present(in: self)
//    }
    
    @objc func dismiss(gesture:UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func pwdCheck(lbl: UILabel, string: String) {
        let pwdConstaints = "Password must consist of one uppercase | One symbol | Eight char"
        let uppercase = "one uppercase |"
        let symbol = "One symbol |"
        let char = " Eight char"

        let pwdErrMutableString = NSMutableAttributedString(string: pwdConstaints)
        
        let uppercaseRange = (pwdConstaints as NSString).range(of: uppercase)
        let symbolRange = (pwdConstaints as NSString).range(of: symbol)
        let charRange = (pwdConstaints as NSString).range(of: char)
        
        let isUppercase = checkPwdStatus(text: string).0
        let isSymbol = checkPwdStatus(text: string).1
        let isChar = checkPwdStatus(text: string).2
        
        pwdErrMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: isUppercase ? #colorLiteral(red: 0.1843137255, green: 0.7215686275, blue: 0.1843137255, alpha: 1) : #colorLiteral(red: 0.7176470588, green: 0.137254902, blue: 0.1529411765, alpha: 1), range: uppercaseRange)
        pwdErrMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: isSymbol ? #colorLiteral(red: 0.1843137255, green: 0.7215686275, blue: 0.1843137255, alpha: 1) : #colorLiteral(red: 0.7176470588, green: 0.137254902, blue: 0.1529411765, alpha: 1), range: symbolRange)
        pwdErrMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: isChar ? #colorLiteral(red: 0.1843137255, green: 0.7215686275, blue: 0.1843137255, alpha: 1) : #colorLiteral(red: 0.7176470588, green: 0.137254902, blue: 0.1529411765, alpha: 1), range: charRange)
        
        lbl.attributedText = pwdErrMutableString
    }
    
    func checkPwdStatus(text : String) -> (Bool, Bool, Bool){

        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalResult = texttest.evaluate(with: text)

        let numberResult  = text.count >= 8

        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialResult = texttest2.evaluate(with: text)

        return (capitalResult, specialResult, numberResult)
    }
}
