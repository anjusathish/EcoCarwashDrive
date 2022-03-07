//
//  YourOrdersViewController.swift
//  Eco carwash Drive
//
//  Created by Indium Software on 20/12/21.
//

import UIKit

class YourOrdersViewController: BaseViewController {

    @IBOutlet weak var orderTableView: UITableView! {
        didSet {
            orderTableView.register(UINib.init(nibName: Constants.TableViewCellID.BookedAppointmentCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellID.BookedAppointmentCell)
        }
    }
    
    lazy var viewModel: AppointmentViewModel = {
        return AppointmentViewModel()
    }()
    
    var listAppointments: [BookedAppointment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        viewModel.getAppointmentList()
        
    }

    @IBAction func filterBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension YourOrdersViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listAppointments.count == 0 {
            
            tableView.setEmptyView(title: "There are no appointments available!")
            
        }else {
            
            tableView.restore()
        }
        
        return listAppointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellID.BookedAppointmentCell, for: indexPath) as! BookedAppointmentCell
        
        let appointmentInfo = listAppointments[indexPath.row]
        
        cell.storeNameLbl.text = appointmentInfo.store?.name
        cell.storeAddressLbl.text = appointmentInfo.store?.address?.address
        cell.completedObLbl.text = appointmentInfo.store?.name
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.orderDetailVC) as! OrderDetailViewController
        
        if let id = listAppointments[indexPath.row].id {
            vc.orderId = "\(id)"
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete {
            
            if let id = listAppointments[indexPath.row].id {
                viewModel.deleteAppointmentList(id: "\(id)")
            }
        }
    }

}

extension YourOrdersViewController: AppointmentDelegate {
    func successful(message: String) {
        self.displayServerSuccess(withMessage: message)
        viewModel.getAppointmentList()
    }
    
    func getStoreList(_storeListData: [Store]) {
        
    }
    
    func getServiceList(_serviceList: [Service]) {
        
    }
    
    func getBookedSlotInfo(_bookedSlotInfo: SlotInfo) {
        
    }
    
    func getCouponListInfo(_couponList: [Coupon]) {
        
    }
    
    func bookAppointment(_appointmentInfo: BookAppointmentModel) {
        
    }
    
    func appointmentList(_appointmentList: [BookedAppointment]) {
        
        listAppointments = _appointmentList
        orderTableView.reloadData()
    }
    
    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
    
    func ratingList(_ratingList: [Rating]) {
        
    }
}
