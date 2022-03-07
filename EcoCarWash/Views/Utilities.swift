//
//  Utilities.swift
//  EWNBABY
//
//  Created by Sathish S on 05/07/21.
//  Copyright © 2018 CIPL0501MOBILITY. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class Utilities: NSObject {
    
    static let sharedInstance = Utilities()
    var getAppCurrentLanguage = Locale.preferredLanguages[0]
    var getDeviceCurrentLanguage = NSLocale.current.languageCode
    
    func loginSprintController(identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    func dashboardController(identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    func appointmentController(identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Appointment", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }

    // MARK: - Alert Methods
    class func displayFailureAlertWithMessage(title : String, message: String, controller : UIViewController){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        let alertOKButton = UIAlertAction(title: "OK", style:.cancel, handler: nil)
        alert.addAction(alertOKButton)
        controller.present(alert, animated: true, completion: {
        })
    }
    
    class func showSuccessFailureAlertWithDismissHandler(title : String, message: String, controller : UIViewController, alertDismissed:@escaping ((_ okPressed: Bool)->Void)){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertOKButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            alertDismissed(true)
        })
        alert.addAction(alertOKButton)
        controller.present(alert, animated: true, completion: {
            
        })
    }
    
    class func showAlert(title : String, message: String, controller : UIViewController, alertDismissed:@escaping ((_ okPressed: Bool) -> Void),cancelHandler:@escaping ((_ cancelPressed: Bool)->Void)){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertOKButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            alertDismissed(true)
        })
        let alertCancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { action in
            cancelHandler(true)
        })
        alert.addAction(alertOKButton)
        alert.addAction(alertCancelButton)
        
        controller.present(alert, animated: true, completion: {
            
        })
    }
    
    class func showActivityIndicator() {
        if  let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            let frame = CGRect(x: UIScreen.main.bounds.width/2 - 30, y: UIScreen.main.bounds.height/2 - 30, width: 44, height: 44)
            let indicator = NVActivityIndicatorView(frame: frame, type: .circleStrokeSpin, color: .black, padding: .none)
            indicator.tag = 3232
            DispatchQueue.main.async {
                indicator.startAnimating()
            }
            window.addSubview(indicator)
            window.isUserInteractionEnabled = false
        }
    }
    
    class  func stopActivityIndicator() {
        if  let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            if let indicator = window.viewWithTag(3232) as? NVActivityIndicatorView {
                DispatchQueue.main.async {
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                }
            }
            window.isUserInteractionEnabled = true
        }
    }

    //MARK:- TextField LeftView
    class func leftGapView(_ fortextfield: UITextField)
    {
        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 15, height: fortextfield.frame.size.height+10))
        
        let bgview=UIView.init(frame: CGRect(x: 0, y: 0, width: 15, height: fortextfield.frame.size.height+10))
        bgview.backgroundColor = UIColor.clear
        
        fortextfield.leftViewMode = UITextField.ViewMode.always
        fortextfield.leftView=leftView
        leftView.addSubview(bgview)
    }
    
    // MARK: - ValidateEmail
    func validateEmail(with email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    // MARK: - ValidatePassword
    class func isPasswordValid(with Password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{6,}")
        return passwordTest.evaluate(with: Password)
    }
    
    // MARK: - validateMobileNumber
    class func validateMobileNumber(with mobileNumber: String) -> Bool {
        let mobileNoRegex = "[789][0-9]{9}"
        let mobileNoTest = NSPredicate(format: "SELF MATCHES %@", mobileNoRegex)
        return mobileNoTest.evaluate(with: mobileNumber)
    }
    
    
    func setImageAtLeft(image:String,textField:UITextField){
        textField.leftViewMode = UITextField.ViewMode.always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: image)
        imageView.image = image
        imageView .contentMode = UIView.ContentMode .scaleAspectFit
        view .addSubview(imageView)
        imageView.frame.origin.x = (view.bounds.size.width - imageView.frame.size.width) / 2.0 - 5
        textField.leftView = view;
    }
    
    func setImageAtRight(image:String,textField:UITextField)
    {
        textField.rightViewMode = UITextField.ViewMode.always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        let imageView = UIImageView(frame: CGRect(x:10, y: 0, width: 20, height: 20))
        let image = UIImage(named: image)
        imageView.image = image
        imageView .contentMode = UIView.ContentMode .scaleAspectFit
        view .addSubview(imageView)
        imageView.frame.origin.x = (view.bounds.size.width - imageView.frame.size.width) / 2.0 - 5
        textField.rightView = view;
    }
    
    class func jsonStringify(jsonString: String) -> [Dictionary<String,Any>] {
        var jsonArray = [Dictionary<String,Any>]()
        let data = jsonString.data(using: .utf8)!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>] ?? []
            print(jsonArray)
        } catch let error as NSError {
            print(error)
        }
        return jsonArray
    }
}

extension UserDefaults{
    //MARK: Retrieve Token
    func getAuthToken() -> String{
        if let token : String = UserDefaults.standard.string(forKey: ""){
            return token
        }else{
            return ""
        }
    }
    
    func getProviderID() -> Int {
        if let providerID = UserDefaults.standard.value(forKey: "") as? Int {
            return providerID
        }else{
            return 0
        }
    }
}

