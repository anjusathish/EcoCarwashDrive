//
//  MobileNoVerificationViewController.swift
//  EcoCarWash
//
//  Created by Indium Software on 11/09/21.
//

import UIKit

protocol OTPverifyDelegate {
    func otpVerificationSuccessful()
}

class MobileNoVerificationViewController: BaseViewController {

    @IBOutlet weak var mobileNoTF: UITextField!
    @IBOutlet weak var optStaclView: UIStackView!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet var otpCollection: [UITextField]!

    var count = 45
    var isRegisterSuccess = false
    var delegate: OTPverifyDelegate!
    var registerUUID: String?
    
    lazy var viewModel: RegisterViewModel = {
       return RegisterViewModel()
    }()
    
    lazy var OtpViewModel: OtpAuthenticateViewModel = {
        return OtpAuthenticateViewModel()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        viewModel.delegate = self
        OtpViewModel.delegate = self

        otpCollection.forEach { tf in
            tf.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        }

        if let viewControllers = self.navigationController?.viewControllers
        {
            if viewControllers.contains(where: { return $0 is ProfileViewController })
            {
                mobileNoTF.isHidden = true
                optStaclView.isHidden = false
                
                if let userID = UserManager.shared.currentUser?.uuid {
                    let request = ResendOtpRequest(user: userID)
                    OtpViewModel.resendOTP(info: request)
                }

            }
            else
            {
                mobileNoTF.isHidden = false
                optStaclView.isHidden = true
            }
        }
    }

    @objc func update() {
        if(count > 0) {
            count -= 1
            countDownLabel.text = "0:\(count)"
        }
    }

    @objc func textFieldDidChange(textField: UITextField){
        if textField != mobileNoTF {
            let text = textField.text
            if text?.count ?? 0 >= 1 {
                switch textField{
                case otpCollection[0]: otpCollection[1].becomeFirstResponder()
                case otpCollection[1]: otpCollection[2].becomeFirstResponder()
                case otpCollection[2]: otpCollection[3].becomeFirstResponder()
                case otpCollection[3]: otpCollection[4].becomeFirstResponder()
                case otpCollection[4]: otpCollection[5].becomeFirstResponder()
                case otpCollection[5]: otpCollection[5].resignFirstResponder()
                default:
                    break
                }
            }
            else{
                
            }
        }
    }

    @IBAction func resendOtpBtn(_ sender: UIButton) {
        
        if let userID = UserManager.shared.currentUser?.uuid {
            
            let request = ResendOtpRequest(user: userID)
            OtpViewModel.resendOTP(info: request)
        }
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        
        if let viewControllers = self.navigationController?.viewControllers
        {
            if viewControllers.contains(where: { return $0 is SignUpViewController })
            {
                
                guard let mobileNo = mobileNoTF.text?.replacingOccurrences(of: "-", with: ""), !mobileNo.isEmpty, mobileNo.count == 10 else {
                    self.displayError(withMessage: .invalidMobileNumber)
                    return
                }
                
                if isRegisterSuccess {
                    let otp = otpCollection.map({$0.text ?? ""}).joined()
                    
                    if let userID = UserManager.shared.currentUser?.uuid {
                        
                        let request = OtpAuthenticationRequest(user: userID, otp: otp)
                        OtpViewModel.OtpAuthenticate(info: request)
                   
                    } else if let uuid = registerUUID {
                       
                        let request = OtpAuthenticationRequest(user: uuid, otp: otp)
                        OtpViewModel.OtpAuthenticate(info: request)
                    }
                }
                else
                {
                    let request = RegisterRequest(name: RegisterUser.name,
                                                  email: RegisterUser.email,
                                                  password: RegisterUser.password,
                                                  user_cars: RegisterUser.modelID,
                                                  profile_image: "http://graph.facebook.com/702855/picture",
                                                  username: RegisterUser.name + "001",
                                                  mobile_no: mobileNo)
                    viewModel.registerUser(info: request)
                }
            }
            else
            {
                let otp = otpCollection.map({$0.text ?? ""}).joined()
                
                if let userID = UserManager.shared.currentUser?.uuid {
                    
                    let request = OtpAuthenticationRequest(user: userID, otp: otp)
                    OtpViewModel.OtpAuthenticate(info: request)
                }
            }
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MobileNoVerificationViewController: RegisterDelegate {
    func registerSuccessful(data: RegisterUserResponse) {
        optStaclView.isHidden = false
        submitBtn.setTitle("Submit & create account", for: .normal)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        self.displayServerSuccess(withMessage: data.message ?? "")
        isRegisterSuccess = data.status ?? false
        registerUUID = data.data?.uuid
    }
    
    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
}

extension MobileNoVerificationViewController: OtpAuthDelegate {
    
    func otpAuthenticateSuccessful(message: String) {
        self.displayServerSuccess(withMessage: message)
        
        
        if let loggedUser = UserManager.shared.currentUser { /// check whether the user has already logged in
            if let viewControllers = self.navigationController?.viewControllers
            {
                if viewControllers.contains(where: { return $0 is ProfileViewController })
                {
                    delegate.otpVerificationSuccessful()
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    if let _ = loggedUser.lastLogin {
                        let vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.rootVC)
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.AddressSelectionVC)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
        else
        {
            if let viewController = navigationController?.viewControllers.first(where: {$0 is LoginViewController}) {
                navigationController?.popToViewController(viewController, animated: true)
            }
        }
    }
    
    func resendOtpSuccessful(message: String) {
        self.displayServerSuccess(withMessage: message)
    }
    
}

extension MobileNoVerificationViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        mobileNoTF.text = mobileNoTF.text?.applyPatternOnNumbers(pattern: "###-###-####", replacementCharacter: "#")
        return true
    }
}

extension String {
    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}
