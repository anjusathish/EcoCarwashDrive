//
//  SignUpViewController.swift
//  EcoCarWash
//
//  Created by Indium Software on 10/09/21.
//

import UIKit
import TextFieldFloatingPlaceholder

struct RegisterUser {
    static var name     : String = ""
    static var email    : String = ""
    static var password : String = ""
    static var modelID  : String = ""
}

class SignUpViewController: BaseViewController {

    @IBOutlet weak var nameTF: TextFieldFloatingPlaceholder!
    @IBOutlet weak var emaiTF: TextFieldFloatingPlaceholder!
    @IBOutlet weak var pwdTF: TextFieldFloatingPlaceholder!
    @IBOutlet weak var confirmPwdTF: TextFieldFloatingPlaceholder!
    @IBOutlet weak var pwdErrLbl: UILabel!
    @IBOutlet weak var pwdMatchErrLbl: UILabel!
    
    var strValue = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        [nameTF, emaiTF, pwdTF, confirmPwdTF].forEach { tf in
            tf.changeTFColor()
        }
        
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        
        guard let email = emaiTF.text, email.isValidEmail() else {
            displayError(withMessage: .invalidEmail)
            return
        }
        
        guard let password = pwdTF.text, checkPwdStatus(text: password).0, checkPwdStatus(text: password).1,  checkPwdStatus(text: password).2 else {
            displayError(withMessage: .invalidPassword)
            return
        }

        guard let confirmPwd = confirmPwdTF.text, checkPwdStatus(text: confirmPwd).0, checkPwdStatus(text: confirmPwd).1,  checkPwdStatus(text: confirmPwd).2 else {
            displayError(withMessage: .invalidPassword)
            return
        }

        guard password == confirmPwd else {
            displayError(withMessage: .invalidPasswordMismatch)
            return
        }

        RegisterUser.name = nameTF.text ?? ""
        RegisterUser.email = email
        RegisterUser.password = password
        
        let vc = Utilities.sharedInstance.loginSprintController(identifier: Constants.StoryboardIdentifier.selectYourCarVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension  SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        strValue = newString
        if newLength == 0 {
            strValue = ""
            if textField == pwdTF {
                pwdCheck(lbl: pwdErrLbl, string: strValue)
            }
        }
        
        if textField == pwdTF{
            pwdCheck(lbl: pwdErrLbl, string: strValue)
        } else if textField == confirmPwdTF {
            pwdMatchErrLbl.isHidden = pwdTF.text == strValue
        }

        return true
    }
}

