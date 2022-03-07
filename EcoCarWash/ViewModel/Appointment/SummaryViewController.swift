//
//  SummaryViewController.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 28/10/21.
//

import UIKit

class SummaryViewController: BaseViewController {

    @IBOutlet weak var tableHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var accessoryStackView: UIStackView!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var finalPriceLbl: UILabel!
    @IBOutlet weak var carTypeLbl: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
  
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: Constants.TableViewCellID.ServiceTypeCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellID.ServiceTypeCell)
        }
    }
    
    @IBOutlet weak var couponDottedBorderVw: UIView! {
        didSet {
            couponDottedBorderVw.addDashedBorder()
        }
    }

    var appliedCouponData: Coupon?
    var interiorService  : [Service] = []
    var exteriorService  : [Service] = []
    var overallService   : [[Service]] = []
    var totalPrice       : Double = 0.0
    var headerData       = [String]()
    var appointmentDate  = String()
    
    lazy var viewModel: AppointmentViewModel = {
       return AppointmentViewModel()
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        getServiceInfo()
        
        if let finalPrice = AppointmentManager.shared.service?.compactMap({ Double($0.price ?? "")}) {
            totalPrice = finalPrice.reduce(0, +)
            finalPriceLbl.text = "₹\(totalPrice)/-"
        }
        
        if let carType = UserManager.shared.currentUser?.userCars?.first?.carType {
            carTypeLbl.text = carType
        }
        
        if let storeInfo = AppointmentManager.shared.store {
            storeName.text = storeInfo.name
            storeAddress.text = storeInfo.address?.address
        }
    }
    
    func getServiceInfo() {
        
        if let service = AppointmentManager.shared.service {
            
            let interiorData = service.filter({ ServiceType(rawValue: $0.serviceType ?? "") == .Interior })
            let exteriorData = service.filter({ ServiceType(rawValue: $0.serviceType ?? "") == .Exterior })
            
            overallService.append(interiorData)
            overallService.append(exteriorData)
                        
            _ = overallService.map({ serviceArr in
                
                if let type = serviceArr.first?.serviceType, let service = service.first?.serviceNature {
                    
                    headerData.append("\(type) (\(service))")
                }
            })
            
            let offset: CGFloat = headerData.count == 2 ? 80.0 : 40.0
            let serviceCount = Int(interiorData.count) + Int(exteriorData.count)
            
            tableHeightConstant.constant = CGFloat(25 * serviceCount) + offset
            tableView.reloadData()
        }
    }

    
    @IBAction func changeStoreBtn(_ sender: UIButton) {
        AppointmentManager.shared.removeService()
        AppointmentManager.shared.removeStore()

        if let viewController = navigationController?.viewControllers.first(where: {$0 is RootViewController}) {
            navigationController?.popToViewController(viewController, animated: true)
        }
    }
    
    @IBAction func viewCouponBtn(_ sender: UIButton) {
        let vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.couponVC) as! CouponViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func placeOrderBtn(_ sender: UIButton) {
        
        guard let carID = UserManager.shared.currentUser?.userCars?.first?.id else {
            self.displayServerSuccess(withMessage: "Car ID is missing!")
            return
        }
        
        if let service = AppointmentManager.shared.service, let store = AppointmentManager.shared.store {
            
            if let appliedCouponData = appliedCouponData {
                
                let request = BookAppointmentRequest(services: service.map({$0.id ?? 0}), date: appointmentDate, total_time: service.map({ $0.timetaken ?? 0 }).reduce(0, +), appointment_nature: "Store", appointment_type: "Normal", payment_type: "UPI", payment_status: "Paid", amount_paid: totalPrice, store: store.id!,  user_address: 53, user_car: carID, address: store.address?.address ?? "", latitude: store.address?.latitude ?? 0.0, longitude: store.address?.longitude ?? 0.0, applied_coupon: appliedCouponData.id ?? 0)
                
                viewModel.bookAppointment(info: request)
                
            } else {
                
                let request = BookAppointmentRequest(services: service.map({$0.id ?? 0}), date: appointmentDate, total_time: service.map({ $0.timetaken ?? 0 }).reduce(0, +), appointment_nature: service.first?.serviceNature ?? "", appointment_type: "Normal", payment_type: "UPI", payment_status: "Paid", amount_paid: totalPrice, store: store.id!,  user_address: 53, user_car: carID, address: store.address?.address ?? "", latitude: store.address?.latitude ?? 0.0, longitude: store.address?.longitude ?? 0.0, applied_coupon: appliedCouponData?.id ?? 0)
                
                viewModel.bookAppointment(info: request)
            }
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: - Tableview delegate and data source methods
extension SummaryViewController: UITableViewDelegate, UITableViewDataSource {
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return overallService[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellID.ServiceTypeCell, for: indexPath) as! ServiceTypeCell
        
        cell.serviceLbl.text = overallService[indexPath.section][indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 25))
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10))

        label.font = UIFont(name: "HelveticaNeue-Regular", size: 16)
        label.textColor = UIColor.cwBlue
       
        label.text = headerData[section]
      
        headerView.backgroundColor = .white
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}

// MARK: - Coupon delegate
extension SummaryViewController: CouponDelegate {
 
    func appliedCoupon(_data: Coupon) {
        
        print(_data)
        appliedCouponData = _data
        couponDottedBorderVw.isHidden = false
        
        let discount = Double(_data.discount ?? "") ?? 0.0
        let finalPrice = AppointmentManager.shared.service?.compactMap({ Double($0.price ?? "")}).reduce(0, +) ?? 0.0

        totalPrice = calculatePercentage(value: finalPrice, percentageVal: discount)
        
        discountLbl.text   = "₹\(Int(discount)) Off"
        finalPriceLbl.text = "₹\(totalPrice)/-"
        self.view.layoutIfNeeded()
    }
}

// MARK: - Book appointment delegate
extension SummaryViewController: AppointmentDelegate {
    
    func bookAppointment(_appointmentInfo: BookAppointmentModel) {
        
        self.displayServerSuccess(withMessage: _appointmentInfo.message ?? "")
        
        AppointmentManager.shared.removeService()
        AppointmentManager.shared.removeStore()

        
        let vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.RatingVC) as! RatingViewController
        if let id = _appointmentInfo.data?.id {
            vc.appointmentId = id
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }

    func getStoreList(_storeListData: [Store]) {
        
    }
    
    func getServiceList(_serviceList: [Service]) {
        
    }
    
    func getBookedSlotInfo(_bookedSlotInfo: SlotInfo) {
        
    }
    
    func appointmentList(_appointmentList: [BookedAppointment]) {
        
    }

    func successful(message: String) {

    }

    func getCouponListInfo(_couponList: [Coupon]) {
        
    }
    
    func ratingList(_ratingList: [Rating]) {
        
    }

}
