//
//  AppointmentViewController.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 20/10/21.
//

import UIKit
import CoreLocation

protocol StoreDelegate {
    func didSelectStore(_ store: Store)
    func didSelectUpcomingService(_ appointment: BookedAppointment)
}


class AppointmentViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: Constants.TableViewCellID.UpcomingCell, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: Constants.TableViewCellID.UpcomingCell)
        }
    }
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var storeNameLbl: UILabel!
    @IBOutlet weak var closingTimeLbl: UILabel!
    @IBOutlet weak var storeRatingLbl: UILabel!
    @IBOutlet weak var storeImgVw: UIImageView!
    @IBOutlet weak var storeDetailView: UIView!
    @IBOutlet weak var tableHeaderLbl: UILabel!

    var location = CLLocationCoordinate2D()
    var delegate: StoreDelegate!
    var storeList = [Store]()
    var listAppointments: [BookedAppointment] = []
    
    lazy var viewModel: AppointmentViewModel = {
        return AppointmentViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        viewModel.getAppointmentList(status: "upcoming")

    }
    
    
    @IBAction func editAddressBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func openStoreBtn(_ sender: UIButton) {
        let vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.bookAppointmentVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension AppointmentViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listAppointments.count > 0 ?  listAppointments.count : storeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear

        if listAppointments.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellID.UpcomingCell, for: indexPath) as! UpcomingCell
            
            let upcomingData = listAppointments[indexPath.row]
            
            cell.storeName.text = upcomingData.store?.name
            cell.storeAddressLbl.text = upcomingData.store?.address?.address
            cell.paymentTypeLbl.text = upcomingData.paymentType
            cell.orderStatusLbl.text = upcomingData.appointmentStatus
            cell.timeLbl.text = convertDateFormatter(date: upcomingData.date?.components(separatedBy: "T").first ?? "")
            cell.navigateBtn.addTarget(self, action: #selector(navigateAction(_:)), for: .touchUpInside)
            cell.navigateBtn.tag = indexPath.row

            cell.selectedBackgroundView = backgroundView
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellID.VisitedStoreCell, for: indexPath) as! VisitedStoreCell
            
            let store = storeList[indexPath.row]
            
            cell.storeName.text = store.name
            cell.addressLbl.text = store.address?.address
            cell.dateLbl.text = convertDateFormatter(date: store.createdOn?.components(separatedBy: "T").first ?? "")
            
            cell.selectedBackgroundView = backgroundView
            
            return cell
        }
    }
    
    @objc func navigateAction(_ sender: UIButton) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if listAppointments.count > 0 {
            let appointmentInfo = listAppointments[indexPath.row]
            delegate.didSelectUpcomingService(appointmentInfo)
        }
        else
        {
            let store = storeList[indexPath.row]
            storeDetails(store: store)
            delegate.didSelectStore(store)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if listAppointments.count > 0 {
            return 200.0
        }
        return UITableView.automaticDimension
    }
    
    func storeDetails(store: Store) {
        
        AppointmentManager.shared.store = store
        
        storeDetailView.isHidden = false
        storeNameLbl.text = store.name
        storeRatingLbl.text = store.rating
        
        AppointmentInfo.details.storeID = store.id ?? 0
        
        closingTimeLbl.text = "Closes at \(Int(store.storeTimings?.endTime?.components(separatedBy: ":").first ?? "") ?? 0)pm"
        
        storeImgVw.sd_setImage(with: URL(string: store.image ?? ""),
                               placeholderImage: UIImage(named: "profile_avatar"),
                               options: .handleCookies,
                               context: nil)
    }
    
}

extension AppointmentViewController: AppointmentDelegate {
  
    func successful(message: String) {

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
        let window = UIApplication.shared.windows.first
        MBProgressHUD.hide(for: window!, animated: true)

        listAppointments = _appointmentList
        
        tableHeaderLbl.text = listAppointments.count > 0 ? "Upcoming services" : "Previously visited stores"
        
        tableView.reloadData()
    }
    
    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
    
    func ratingList(_ratingList: [Rating]) {
        
    }
}

class VisitedStoreCell: UITableViewCell {
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
}

enum AppointmentStatus: String {
    case Created     = "Created"
    case Accepted    = "Accepted"
    case Assigned    = "Cleaner_Assigned"
    case Departed    = "Cleaner_Departed"
    case Reached     = "Cleaner_Reached"
    case Progress    = "Cleaning_In_Progress"
    case Done        = "Cleaning_Done"
    case Completed   = "Completed"
    case Cancelled   = "Cancelled"
    case Rescheduled = "Rescheduled"
}
