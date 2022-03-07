//
//  SettingsViewController.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 12/10/21.
//

import UIKit

class SettingsViewController: BaseViewController {

    @IBOutlet weak var makeTF: UITextField!
    @IBOutlet weak var modelTF: UITextField!
    @IBOutlet weak var typeTF: UITextField!
    @IBOutlet weak var homeAddTF: UITextField!
    @IBOutlet weak var officeAddTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!

    lazy var isEdit = (false, false)
    var selectedTF = UITextField()
    var listData = [String]()

    var userAddress = [AddressData]()

    lazy var viewModel: UserSettingsViewModel = {
        return UserSettingsViewModel()
    }()
    
    lazy var carViewModel: SelectCarViewModel = {
        return SelectCarViewModel()
    }()
    
    var typeID: String?
    var makeID : String?
    var modelID : Int?
    var carModelName : String?
    var carID: String?

    var carTypeListArray  = [TypeData]()
    var carMakeListArray  = [MakeData]()
    var carModelListArray = [ModelData]()
    var carDetails = [CarData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        carViewModel.delegate = self

        viewModel.getUserCar()
        viewModel.getUserAddress()
        
        [makeTF, modelTF, typeTF].forEach { (TF) in
            TF?.delegate = self
            TF?.addTarget(self, action: #selector(carDetails(textField:)), for: .touchDown)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(getUserAddress(notification:)), name: .getAddress, object: nil)
        
    }
    
    @objc func getUserAddress(notification: Notification) {
        viewModel.getUserAddress()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .getAddress, object: nil)
    }
    
    @objc func carDetails(textField: UITextField) {
        selectedTF = textField

        switch textField {
        case typeTF  : carViewModel.selectCarType()
        case makeTF  : carViewModel.selectCarMake(carTypeID: typeID ?? "")
        case modelTF : carViewModel.selectCarModel(carMakeID: makeID ?? "")
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
    
    @IBAction func carModelEditBtn(_ sender: UIButton) {
        isEdit.0.toggle()
        editCarModel(isEnabled: isEdit.0)
        sender.setImage(isEdit.0 ? nil : UIImage(named: "edit"), for: .normal)
        sender.setTitle(isEdit.0 ? "Done" : "", for: .normal)
        
        
        if isEdit.0 && sender.title(for: .normal) == "Done" {
            typeTF.text?.removeAll()
            makeTF.text?.removeAll()
            modelTF.text?.removeAll()
        } else {
            
            if typeTF.text?.isEmpty ?? false && makeTF.text?.isEmpty ?? false && modelTF.text?.isEmpty ?? false {
                typeTF.text = carDetails.first?.carType
                makeTF.text = carDetails.first?.carMake
                modelTF.text = carDetails.first?.carModel
                return
            }
        }
        
        if !isEdit.0 {
            if let carDataArr = carDetails.first {
                
                guard !typeTF.text.isNillOrEmpty() else {
                    isEdit.0.toggle()
                    editCarModel(isEnabled: isEdit.0)
                    sender.setImage(nil, for: .normal)
                    sender.setTitle("Done" , for: .normal)
                    self.displayError(withMessage: .emptyType)
                    return
                }
                
                guard !makeTF.text.isNillOrEmpty() else {
                    isEdit.0.toggle()
                    editCarModel(isEnabled: isEdit.0)
                    sender.setImage(nil, for: .normal)
                    sender.setTitle("Done" , for: .normal)
                    self.displayError(withMessage: .emptyMake)
                    return
                }
                
                guard !modelTF.text.isNillOrEmpty() else {
                    isEdit.0.toggle()
                    editCarModel(isEnabled: isEdit.0)
                    sender.setImage(nil, for: .normal)
                    sender.setTitle("Done" , for: .normal)
                    self.displayError(withMessage: .emptyModel)
                    return
                }
                
                let request = CarRequest(status: carDataArr.status ?? "", car_name: carModelName ?? "", car_model: modelID ?? 0)
                viewModel.updateCar(info: request, id: carDataArr.id ?? 0)
            }
        }
    }

    @IBAction func savedAddressEditBtn(_ sender: UIButton) {
        isEdit.1.toggle()

        sender.setImage(isEdit.1 ? nil : UIImage(named: "edit"), for: .normal)
        sender.setTitle(isEdit.1 ? "Done" : "", for: .normal)
        
        tableView.reloadData()
    }

    func editCarModel(isEnabled: Bool) {
        makeTF.isUserInteractionEnabled = isEnabled
        modelTF.isUserInteractionEnabled = isEnabled
        typeTF.isUserInteractionEnabled = isEnabled
    }
    
    func editAddress(isEnabled: Bool) {
        homeAddTF.isUserInteractionEnabled = isEnabled
        officeAddTF.isUserInteractionEnabled = isEnabled
    }
    
    @objc func editAddressBtn(_ sender: UIButton) {
        let vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.AddressSelectionVC) as! AddressSelectionViewController
        vc.updateAddressId = userAddress[sender.tag].id
        vc.isUpdateAddress = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deleteAddressBtn(_ sender: UIButton) {
           
        showAlertWith(title: "Alert!",
                      message: "Are you sure you want to delete this address?", controller: self) { [self] okPressed in
            if let id = userAddress[sender.tag].id {
                viewModel.deleteAddress(id: id)
            }
        } cancelHandler: { cancelPressed in
            
        }
    }
    
    @IBAction func addAddressBtn(_ sender: UIButton) {
        let vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.AddressSelectionVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

extension SettingsViewController: CarConfigDelegate {
    func selectCarConfig(cofig: String) {
        selectedTF.text = cofig
        
        switch selectedTF {
        case typeTF  :
            typeID = String(carTypeListArray.filter({$0.name == cofig}).first?.id ?? 0)
            makeTF.text?.removeAll()
            modelTF.text?.removeAll()
            
        case makeTF  :
            makeID = String(carMakeListArray.filter({$0.name == cofig}).first?.id ?? 0)
            modelTF.text?.removeAll()

        case modelTF :
            modelID = carModelListArray.filter({$0.name == cofig}).first?.id ?? 0
            carModelName = carModelListArray.filter({$0.name == cofig}).first?.name ?? ""
        default : break
        }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userAddress.count == 0 {
            
            tableView.setEmptyView(title: "There are no saved address")
            
        }else {
            
            tableView.restore()
        }

        return userAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellID.AddressTableViewCell, for: indexPath) as! AddressTableViewCell
        
        cell.addressTypeLbl.text = userAddress[indexPath.row].locationName
        cell.addressLbl.text = userAddress[indexPath.row].address?.address
        
        cell.editBtn.addTarget(self, action: #selector(editAddressBtn(_:)), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(deleteAddressBtn(_:)), for: .touchUpInside)
        
        cell.editAddressStackView.isHidden = !isEdit.1
        
        cell.editBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row

        return cell
    }
}

extension SettingsViewController: UserSettingsDelegate {
    
    func getCarsSuccessful(carData: [CarData]) {
        print("Car fetched successfully", carData)
        
        carDetails = carData
        
        typeTF.text = carData.first?.carType
        makeTF.text = carData.first?.carMake
        modelTF.text = carData.first?.carModel
    }
    
    func getAddressSuccessful(address: [AddressData]) {
        print("Address fetched successfully", address)
        MBProgressHUD.hide(for: UIApplication.shared.windows.first!, animated: true)

        userAddress = address
        
        tableViewHeightConst.constant = userAddress.count >= 3 ? 200.0 : CGFloat(65 * userAddress.count) + 20.0
        
        tableView.isScrollEnabled = userAddress.count >= 3

        tableView.reloadData()
    }

    func updateSuccessful(message: String) {
        self.displayServerSuccess(withMessage: message)
    }
    
    func deleteSuccessful(message: String) {
        self.displayServerSuccess(withMessage: message)
        viewModel.getUserAddress()
    }

    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
}

extension SettingsViewController: SelectCarDelegate {
    
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
}

class AddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addressTypeLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editAddressStackView: UIStackView!

}
