//
//  ProfileViewController.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 24/09/21.
//

import UIKit
import SDWebImage

class ProfileViewController: BaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet var profileImgBtn: UIButton!
    @IBOutlet var verifyBtn: UIButton!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var imageEditImgVw: UIImageView!
    @IBOutlet var nameEditBtn: UIButton!
    @IBOutlet var emailEditBtn: UIButton!
    @IBOutlet var phoneEditBtn: UIButton!
    @IBOutlet var passwordEditBtn: UIButton!

    lazy var isCommonEdited = false
    lazy var isNameEdited = false
    lazy var isEmailEdited = false
    lazy var isPhoneEdited = false
    lazy var isPasswordEdit = false
    var imagePicker = UIImagePickerController()
    var image = UIImage()
    
    var getProfileViewModel: UserProfileViewModel = {
        return UserProfileViewModel()
    }()
    
    var updateProfileViewModel: UserProfileViewModel = {
        return UserProfileViewModel()
    }()

    var newPassword: String?
    var oldPassword: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProfileViewModel.delegate = self
        updateProfileViewModel.delegate = self
        
        getProfileViewModel.getUserProfile()
        
        passwordTF.delegate = self
        mobileTF.delegate = self
        nameTF.delegate = self
    }
    
    @IBAction func profileImgBtn(_ sender: UIButton){
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction(title: "View Image", style: .default, handler: { _ in
            self.openImage()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true

        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Open Camera
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }else{
            
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- Open Gallary
    func openGallary(){
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }

    func openImage(){
        let vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.openImageVC) as! OpenImageViewController
        vc.selectedImage = profileImageView.image
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func AccDetailsEditBtn(_ sender: UIButton) {
        configureEditBtns(isCommonEdited)
        isCommonEdited.toggle()
                
        profileImgBtn.isUserInteractionEnabled = isCommonEdited
        
        sender.setImage(isCommonEdited ? nil : UIImage(named: "edit"), for: .normal)
        sender.setTitle(isCommonEdited ? "Done" : "", for: .normal)
        
    }
    
    func configureEditBtns(_ isShow: Bool) {
        imageEditImgVw.isHidden = isShow
        nameEditBtn.isHidden = isShow
        emailEditBtn.isHidden = isShow
        phoneEditBtn.isHidden = isShow
        passwordEditBtn.isHidden = isShow
    }
    
    func updateProfileAPI() {
        guard let name = nameTF.text, !name.isEmpty else {
            self.displayError(withMessage: .invalidName)
            return
        }
        
        guard let email = emailTF.text, email.isValidEmail() else {
            self.displayError(withMessage: .invalidEmail)
            return
        }
        
        guard let mobileNo = mobileTF.text, !mobileNo.isEmpty, mobileNo.count == 10 else {
            self.displayError(withMessage: .invalidMobileNumber)
            return
        }
          
        guard let userID = UserManager.shared.currentUser?.uuid else {
            self.displayError(withMessage: .invalidUser)
            return
        }
        
        updateProfileViewModel.updateUserProfile(name: name,
                                                 username: name + "_001",
                                                 email: email,
                                                 profile_image: "",
                                                 mobile_no: mobileNo,
                                                 old_password: oldPassword ?? "",
                                                 new_password: newPassword ?? "",
                                                 uuid: userID)
    }
    
    @IBAction func editNameBtn(_ sender: UIButton) {
        isNameEdited.toggle()
        nameTF.becomeFirstResponder()
        nameTF.isUserInteractionEnabled = isNameEdited
        sender.setImage(isNameEdited ? nil : UIImage(named: "edit"), for: .normal)
        sender.setTitle(isNameEdited ? "Done" : "", for: .normal)
        
        updateProfile(updated: isNameEdited)
    }
    
    @IBAction func editEmailBtn(_ sender: UIButton) {
        isEmailEdited.toggle()
        emailTF.becomeFirstResponder()
        emailTF.isUserInteractionEnabled = isNameEdited
        sender.setImage(isEmailEdited ? nil : UIImage(named: "edit"), for: .normal)
        sender.setTitle(isEmailEdited ? "Done" : "", for: .normal)
        
        updateProfile(updated: isEmailEdited)
    }

    
    @IBAction func editPasswordBtn(_ sender: UIButton) {
        isPasswordEdit.toggle()
        sender.setImage(isPasswordEdit ? nil : UIImage(named: "edit"), for: .normal)
        sender.setTitle(isPasswordEdit ? "Done" : "", for: .normal)
        
        updateProfile(updated: isPasswordEdit)

        if isPasswordEdit == true {
            let vc = Utilities.sharedInstance.loginSprintController(identifier: Constants.StoryboardIdentifier.forgetPwdVC) as! ForgetPasswordViewController
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            UserManager.shared.deleteActiveUser()
        }

    }

    @IBAction func editNumberBtn(_ sender: UIButton) {
        isPhoneEdited.toggle()
        mobileTF.isUserInteractionEnabled = isPhoneEdited
        mobileTF.becomeFirstResponder()
        sender.setImage(isPhoneEdited ? nil : UIImage(named: "edit"), for: .normal)
        sender.setTitle(isPhoneEdited ? "Done" : "", for: .normal)
        
        updateProfile(updated: isPhoneEdited)
    }

    func updateProfile(updated: Bool) {
        if updated == false {
            updateProfileAPI()
        }
    }
    
    func editAccDetails(isEnabled: Bool) {
        imageEditImgVw.isUserInteractionEnabled = isEnabled
        emailTF.isUserInteractionEnabled = isEnabled
        nameTF.isUserInteractionEnabled = isEnabled
        mobileTF.isUserInteractionEnabled = isEnabled
        passwordTF.isUserInteractionEnabled = isEnabled
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            self.image = image
            profileImageView.image = image
        }
        
        if (picker.sourceType == UIImagePickerController.SourceType.camera) {
                        
            let imgName = UUID().uuidString
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName)
            
            let data = image.jpegData(compressionQuality: 0.3)! as NSData
            data.write(toFile: localPath, atomically: true)
            let photoURL = URL.init(fileURLWithPath: localPath)
            
            if let userID = UserManager.shared.currentUser?.uuid {
                
                updateProfileViewModel.updateUserProfile(name: "", username: "", email: "", profile_image: photoURL.absoluteString, mobile_no: "", old_password: "",  new_password: "", uuid: userID)
            }
            
        } else {
            
            if let pickedImageUrl = info[.imageURL] as? URL {
                
                if let userID = UserManager.shared.currentUser?.uuid {
                    
                    updateProfileViewModel.updateUserProfile(name: "", username: "", email: "", profile_image: pickedImageUrl.absoluteString, mobile_no: "", old_password: "",  new_password: "", uuid: userID)
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func verifyBtn(_ sender: UIButton) {
        let vc = Utilities.sharedInstance.loginSprintController(identifier: Constants.StoryboardIdentifier.mobNoVerificationVC) as! MobileNoVerificationViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension ProfileViewController: UserProfileDelegate {
    
    func userProfileDetails(data: UserProfileResponse) {

        if let message = data.message {
            self.displayServerSuccess(withMessage: message)
        }
        
        if let data = data.data {
            nameTF.text = data.name
            emailTF.text = data.email
            mobileTF.text = data.mobileNo
            
            verifyBtn.isHidden = data.isMobileVerified ?? false
            
            if let profileUrlString = data.profileImage{
                if let url = URL(string: profileUrlString) {
                    profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "profile_avatar"))
                }
            }
        }
    }
    
    func updateProfileSuccessful(message: String) {
        self.displayServerSuccess(withMessage: message)
    }

    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
}

extension ProfileViewController: ChangePasswordDelegate {
    func changedPassword(oldPassword: String, newPassword: String) {
        self.newPassword = newPassword
        self.oldPassword = oldPassword
        self.navigationController?.popViewController(animated: true)
    }
}


extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == passwordTF  {
            return false
        }
        return true
    }
}

extension ProfileViewController: OTPverifyDelegate {
    func otpVerificationSuccessful() {
        getProfileViewModel.getUserProfile()
    }
}
