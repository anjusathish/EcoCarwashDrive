//
//  SaveAddressViewController.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 23/11/21.
//

import UIKit
import DLRadioButton
import CoreLocation

protocol AddressDelegate {
    func didSaveUserAddress()
}

class SaveAddressViewController: BaseViewController {

    @IBOutlet weak var houseNoTf: UITextField!
    @IBOutlet weak var streetTf: UITextField!
    @IBOutlet weak var landmarkTf: UITextField!
    @IBOutlet weak var otherAddressTypeTf: UITextField!
    @IBOutlet weak var otherAddressStackVw: UIStackView!
    @IBOutlet weak var addressContainer: UIView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet var addressBtn : DLRadioButton!
    @IBOutlet var otherButtons : [DLRadioButton]!
    
    lazy var isEdit = false
    var isUpdateAddress: Bool?
    var updateAddressId: Int?
    var addressType = "Home"
    var address = ""
    var coordinates = CLLocationCoordinate2D()
    var delegate: AddressDelegate!
    var updateAddressHandler: (()->())?
    
    lazy var viewModel: UserSettingsViewModel = {
        return UserSettingsViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

        for radioButton in addressBtn.otherButtons {
            radioButton.isSelected = true;
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tapView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func editBtn(_ sender : UIButton) {
        isEdit.toggle()
        sender.setImage(isEdit ? nil : UIImage(named: "edit"), for: .normal)
        sender.setTitle(isEdit ? "Close" : "", for: .normal)
        otherAddressStackVw.isHidden = !isEdit
    }
    
    @IBAction func addressSelectionBtn(radioButton : DLRadioButton) {
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(String(format: "%@ is selected.\n", button.titleLabel!.text!))
                addressType = button.titleLabel!.text!
            }
        } else {
            addressType = radioButton.selected()!.titleLabel!.text!
            print(String(format: "%@ is selected.\n", radioButton.selected()!.titleLabel!.text!))
        }
    }
    
    @IBAction func saveBtn(_ sender : UIButton) {
        
        guard let houseNO = houseNoTf.text, !houseNO.isEmpty else {
            self.displayServerError(withMessage: "House No field cannot be empty!")
            return
        }
        
        guard let street = streetTf.text, !street.isEmpty else {
            self.displayServerError(withMessage: "Street field cannot be empty!")
            return
        }
        
        guard let landmark = landmarkTf.text, !landmark.isEmpty else {
            self.displayServerError(withMessage: "Landmark cannot be empty!")
            return
        }

        let address = "\(houseNO),\(street),\(landmark),\(address)"
        
        let addReq = UserAddressRequest(house_no: houseNoTf.text ?? "",
                                        street: streetTf.text ?? "",
                                        landmark: landmarkTf.text ?? "",
                                        address: address,
                                        latitude: coordinates.latitude,
                                        longitude: coordinates.longitude,
                                        location_name: isEdit ? otherAddressTypeTf.text ?? "" : addressType)
        
        if isUpdateAddress ?? false {
            if let id = updateAddressId {
                viewModel.updateAddress(info: addReq, id: id)
            }
        } else {
            viewModel.addAddress(info: addReq)
        }
    }
}

extension SaveAddressViewController: UserSettingsDelegate {
    
    func getCarsSuccessful(carData: [CarData]) {

    }
    
    func getAddressSuccessful(address: [AddressData]) {
//        self.displayServerSuccess(withMessage: message)
        UserManager.shared.currentUser?.lastLogin = ""
        UserManager.shared.currentUser?.isMobileVerified = true
        
        delegate.didSaveUserAddress()

    }

    func updateSuccessful(message: String) {
        self.displayServerSuccess(withMessage: message)
        UserManager.shared.currentUser?.lastLogin = ""
        UserManager.shared.currentUser?.isMobileVerified = true
        
        delegate.didSaveUserAddress()
    }
    
    func deleteSuccessful(message: String) {

    }

    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
}
