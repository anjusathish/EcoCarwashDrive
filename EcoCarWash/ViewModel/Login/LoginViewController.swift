//
//  LoginViewController.swift
//  EcoCarWash
//
//  Created by Indium Software on 03/09/21.
//

import UIKit
import TextFieldFloatingPlaceholder

class LoginViewController: BaseViewController {

    @IBOutlet weak var pwdErrLbl: UILabel!
    @IBOutlet weak var emailTF: TextFieldFloatingPlaceholder! {
        didSet{
            emailTF.changeTFColor()
        }
    }
    @IBOutlet weak var passwordTF: TextFieldFloatingPlaceholder!{
        didSet{
            passwordTF.changeTFColor()
        }
    }

    var strValue = ""
    lazy var viewModel: LoginViewModel = {
        return LoginViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.removeObjectForKey("activeUser")
        UserManager.shared.currentUser = nil
        
        viewModel.delegate = self
        
//        emailTF.text = "jim@test.com"
//        passwordTF.text = "Apple@123"
        
    }

    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        
        guard let email = emailTF.text, email.isValidEmail() else {
            displayError(withMessage: .invalidEmail)
            return
        }

        guard let password = passwordTF.text else {
            displayError(withMessage: .invalidPassword)
            return
        }

        viewModel.loginUser(email: email, password: password)
    }
    
    @IBAction func forgetPwdBtn(_ sender: UIButton) {
        let vc = Utilities.sharedInstance.loginSprintController(identifier: Constants.StoryboardIdentifier.forgetPwdVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        let vc = Utilities.sharedInstance.loginSprintController(identifier: Constants.StoryboardIdentifier.signUpVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LoginViewController: LoginDelegate {
    func loginSuccessfull(message: String) {
        print(message)

        if let loggedUser = UserManager.shared.currentUser {
            if loggedUser.isMobileVerified == false {
                
                self.displayServerError(withMessage: "Mobile number didn't verified yet")
                
                let vc = Utilities.sharedInstance.loginSprintController(identifier: Constants.StoryboardIdentifier.mobNoVerificationVC)
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else if loggedUser.lastLogin == nil {
               
                self.displayServerError(withMessage: "Address didn't added yet")

                let vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.AddressSelectionVC)
                self.navigationController?.pushViewController(vc, animated: true)

            } else {
               
                self.displayServerSuccess(withMessage: message)
                
                UserDefaults.standard.set(passwordTF.text, forKey: Constants.UserdefaultKey.password)
                
                let vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.rootVC)
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    }
    
    func loginFailed(message: String) {
        self.displayServerError(withMessage: message)
    }
}

extension  LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        strValue = newString
        if newLength == 0 {
            strValue = ""
            if textField == passwordTF {
                pwdCheck(lbl: pwdErrLbl, string: strValue)
            }
        }
        
        if textField == passwordTF {
            pwdCheck(lbl: pwdErrLbl, string: strValue)
        }
        return true
    }
}
