//
//  SelectYourCarViewController.swift
//  EcoCarWash
//
//  Created by Indium Software on 11/09/21.
//

import UIKit
import TTGSnackbar

class SelectYourCarViewController: BaseViewController {

    @IBOutlet weak var typeTextfield : UITextField!
    @IBOutlet weak var makeTextfield : UITextField!
    @IBOutlet weak var modelTextfield: UITextField!
    
    lazy var viewModel: SelectCarViewModel = {
        return SelectCarViewModel()
    }()
    
    var typeID: String?
    var makeID : String?
    
    var carTypeListArray  = [TypeData]()
    var carMakeListArray  = [MakeData]()
    var carModelListArray = [ModelData]()

    var selectedTF = UITextField()
    var listData = [String]()
    
    var registerUser: RegisterUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        
        [makeTextfield, modelTextfield, typeTextfield].forEach { tf in
            tf?.delegate = self
            tf?.addTarget(self, action: #selector(openDropDown(textField:)), for: .touchDown)
        }
    }
    
    @objc func openDropDown(textField: UITextField) {
        selectedTF = textField
                
        switch textField {
        case typeTextfield  : viewModel.selectCarType()
        case makeTextfield  : viewModel.selectCarMake(carTypeID: typeID ?? "")
        case modelTextfield : viewModel.selectCarModel(carMakeID: makeID ?? "")
        default : break
        }
    }
    
    func showPopUp() {
        let vc = Utilities.sharedInstance.loginSprintController(identifier: Constants.StoryboardIdentifier.selectCarPopUpVC) as! SelectCarPopUpViewController
        vc.filterType = selectedTF.placeholder?.description ?? ""
        vc.carData = listData
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        let vc = Utilities.sharedInstance.loginSprintController(identifier: Constants.StoryboardIdentifier.mobNoVerificationVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension SelectYourCarViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}


extension SelectYourCarViewController: CarConfigDelegate {
    
    func selectCarConfig(cofig: String) {
        selectedTF.text = cofig
        
        switch selectedTF {
        case typeTextfield  : typeID = String(carTypeListArray.filter({$0.name == cofig}).first?.id ?? 0)
        case makeTextfield  : makeID = String(carMakeListArray.filter({$0.name == cofig}).first?.id ?? 0)
        case modelTextfield : RegisterUser.modelID = String(carModelListArray.filter({$0.name == cofig}).first?.id ?? 0)
        default : break
        }
        
    }
}

extension SelectYourCarViewController: SelectCarDelegate {
    
    func carTypeList(typeList: CarTypeModel) {
        print(typeList)
        carTypeListArray = typeList.data ?? []
        
        if let carTypes: [String] = typeList.data?.map({$0.name ?? ""}) {
            listData = carTypes
        }
        showPopUp()
    }
    
    func carMakeList(makeList: CarMakeModel) {
        print(makeList)
        carMakeListArray = makeList.data ?? []
        
        if let carMakes: [String] = makeList.data?.map({$0.name ?? ""}) {
            listData = carMakes
        }
        showPopUp()
    }
    
    func carModelList(modelList: CarModel) {
        print(modelList)
        carModelListArray = modelList.data ?? []
        
        if let carModels: [String] = modelList.data?.map({$0.name ?? ""}) {
            listData = carModels
        }
        showPopUp()
    }
    
    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
}
