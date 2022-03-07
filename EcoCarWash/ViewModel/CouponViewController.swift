//
//  CouponViewController.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 28/10/21.
//

import UIKit


protocol CouponDelegate {
    
    func appliedCoupon(_data: Coupon)
}

class CouponViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.register(UINib.init(nibName: Constants.TableViewCellID.CouponCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellID.CouponCell)
        }
    }
    
    @IBOutlet weak var searchTF  : UITextField!{
        didSet{
            searchTF.delegate = self
        }
    }

    lazy var viewModel: AppointmentViewModel = {
        return AppointmentViewModel()
    }()
    
    var couponList: [Coupon] = []
    var searchCouponInfo: [Coupon] = []
    var strValue: String?
    var delegate: CouponDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        viewModel.getCoupon()
        
    }
    
    @IBAction func applyBtn(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

/// #Mark: - TableView delegate & data source methods
extension CouponViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchCouponInfo.count == 0 {
            tableView.setEmptyView(title: "There is no Coupon available!")
        }else {
            tableView.restore()
        }
        return searchCouponInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellID.CouponCell, for: indexPath) as! CouponCell
        
        let couponInfo = searchCouponInfo[indexPath.row]
        
        cell.couponLbl.text = couponInfo.code
        cell.descripetionLbl.text = couponInfo.couponDescription
        
        cell.applyBtn.addTarget(self, action: #selector(applyCoupon(_:)), for: .touchUpInside)
        cell.applyBtn.tag = indexPath.row
        
        return cell
    }
    
    
    @objc func applyCoupon(_ sender: UIButton) {
        
        delegate.appliedCoupon(_data: searchCouponInfo[sender.tag])
        
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension CouponViewController: AppointmentDelegate {
    
    func getStoreList(_storeListData: [Store]) {
                
    }
    
    func getServiceList(_serviceList: [Service]) {
        
    }
    
    func getBookedSlotInfo(_bookedSlotInfo: SlotInfo) {
        
    }
    
    func getCouponListInfo(_couponList: [Coupon]) {
        
        couponList = _couponList
        searchCouponInfo = _couponList
        tableView.reloadData()
    }
    
    func bookAppointment(_appointmentInfo: BookAppointmentModel) {
        
    }

    func appointmentList(_appointmentList: [BookedAppointment]) {
        
    }

    func successful(message: String) {

    }

    func ratingList(_ratingList: [Rating]) {
        
    }

    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
}

extension CouponViewController: UITextFieldDelegate {
   
    func searchTextField(searchText: String) {
        searchCouponInfo = searchText.count == 0 ? couponList : couponList.filter({$0.code?.lowercased().contains(searchText.lowercased()) as! Bool })
        self.tableView.reloadData()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        strValue = newString
        if newLength == 0 {
            strValue = ""
        }
        searchTextField(searchText: strValue ?? "")
        return true
    }
}
