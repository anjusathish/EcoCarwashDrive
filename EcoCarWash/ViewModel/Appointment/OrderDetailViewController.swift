//
//  OrderDetailViewController.swift
//  Eco carwash Drive
//
//  Created by Indium Software on 21/12/21.
//

import UIKit

class OrderDetailViewController: BaseViewController {

    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var carMakeLbl: UILabel!
    @IBOutlet weak var carModelLbl: UILabel!
    @IBOutlet weak var carTypeLbl: UILabel!
    @IBOutlet weak var serviceStatusImgVw: UIImageView!
    @IBOutlet weak var serviceModeLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var paymentModeLbl: UILabel!
    @IBOutlet weak var paymentStatusLbl: UILabel!
    @IBOutlet weak var tableHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var collectionHeightConst: NSLayoutConstraint!
    @IBOutlet weak var cleanerNameLbl: UILabel!
    @IBOutlet weak var cleanerImgVw: UIImageView!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var userRatingImgVw: UIImageView!
    @IBOutlet weak var userNameRatingLbl: UILabel!
    @IBOutlet weak var ratingDescriptionLbl: UILabel!
    @IBOutlet weak var carImgCollectionView: UICollectionView!
    @IBOutlet weak var couponDottedBorderVw: UIView! {
        didSet {
            couponDottedBorderVw.addDashedBorder()
        }
    }
    @IBOutlet weak var serviceTblVw: UITableView! {
        didSet {
            serviceTblVw.register(UINib(nibName: Constants.TableViewCellID.ServiceTypeHeaderCell, bundle: nil), forHeaderFooterViewReuseIdentifier: Constants.TableViewCellID.ServiceTypeHeaderCell)
        }
    }
    
    var orderId: String = ""
    var appointmentInfo: BookedAppointment?
    var headerData: [(String, String)] = []
    var headerCarImageData: [String] = []
    var overallService: [[Service]] = []
    var appointmentRatingInfo: AppointmentRating?
    var appointmentImageInfo: [[AppointmentImage]] = []
    lazy var viewModel: AppointmentViewModel = {
       return AppointmentViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        viewModel.getAppointment(by: orderId)
    }
    
    func getServiceData(service: [Service]) {
        
        let interiorData = service.filter({ ServiceType(rawValue: $0.serviceType ?? "") == .Interior })
        let exteriorData = service.filter({ ServiceType(rawValue: $0.serviceType ?? "") == .Exterior })
        
        overallService.append(interiorData)
        overallService.append(exteriorData)
                    
        _ = overallService.map({ serviceArr in
            
            if let type = serviceArr.first?.serviceType, let nature = serviceArr.first?.serviceNature {
                headerData.append((type, nature))
            }
        })
        
        let offset: CGFloat = headerData.count == 2 ? 80.0 : 40.0
        let serviceCount = Int(interiorData.count) + Int(exteriorData.count)
        
        tableHeightConstant.constant = CGFloat(30 * serviceCount) + offset
        serviceTblVw.reloadData()
    }
    
    func getCarImageData(appointmentImg: [AppointmentImage]) {
        
        let beforeData = appointmentImg.filter({ $0.imageType == "Before" })
        let afterData = appointmentImg.filter({ $0.imageType == "After" })
        
        appointmentImageInfo.append(beforeData)
        appointmentImageInfo.append(afterData)
                    
        _ = appointmentImageInfo.map({ carImgArr in
            
            if let imageType = carImgArr.first?.imageType {
                headerCarImageData.append(imageType)
            }
        })
        
        let offset: CGFloat = 20.0
        let imageCount = appointmentImageInfo.count
        
        collectionHeightConst.constant = CGFloat(130 * imageCount) + offset
        carImgCollectionView.reloadData()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Tableview methods
extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerData.count
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return overallService[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(reuseIdentifier: Constants.TableViewCellID.ServiceCell, for: indexPath) as! ServiceCell
        cell.serviceNameLbl.text = overallService[indexPath.section][indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.TableViewCellID.ServiceTypeHeaderCell) as! ServiceTypeHeaderCell
        
        header.serviceTypeLbl.text = headerData[section].0
        header.serviceTypeNature.text = headerData[section].1

        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
}


extension OrderDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return headerCarImageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appointmentImageInfo[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewID.CarImageCollectionCell, for: indexPath) as! CarImageCollectionCell
        
        cell.headerLbl.isHidden = indexPath.row != 0
        cell.headerLbl.text = headerCarImageData[indexPath.section]
        
        if let urlString = appointmentImageInfo[indexPath.section][indexPath.item].image,
           let url = URL(string: urlString),
           let data = try? Data(contentsOf: url) {
            cell.carImgVw.image = UIImage(data: data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.openImageVC) as! OpenImageViewController
        if let urlString = appointmentImageInfo[indexPath.section][indexPath.item].image,
           let url = URL(string: urlString), let data = try? Data(contentsOf: url) {
            vc.selectedImage = UIImage(data: data)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Appointment Delegate
extension OrderDetailViewController: AppointmentDelegate {
   
    func appointmentList(_appointmentList: [BookedAppointment]) {
        
        let appointment = _appointmentList.first
        appointmentInfo = appointment

        customerNameLbl.text = appointment?.customer?.name
        carMakeLbl.text = appointment?.userCar?.carMake
        carModelLbl.text = appointment?.userCar?.carModel
        carTypeLbl.text = appointment?.userCar?.carType
        serviceModeLbl.text = appointment?.appointmentNature

        let paidAmount = Double(appointment?.amountPaid ?? "") ?? 0.0

        if let coupon = appointment?.appliedCoupon {
            couponDottedBorderVw.isHidden = false
            
            let discount = Double(coupon.discount ?? "") ?? 0.0
            let finalPrice = calculatePercentage(value: paidAmount, percentageVal: discount)
            
            discountLbl.text = "₹\(Int(discount)) Off"
            priceLbl.text = "₹\(finalPrice)/-"
        }
        else
        {
            couponDottedBorderVw.isHidden = true
            priceLbl.text = "₹\(paidAmount)/-"
        }
        
        paymentModeLbl.text = appointment?.paymentType
        paymentStatusLbl.text = appointment?.paymentStatus

        if let _service = appointment?.services {
            getServiceData(service: _service)
        }
        
        if let _carImgData = appointment?.appointmentImages {
            getCarImageData(appointmentImg: _carImgData)
        }
        
        if let rating = appointment?.appointmentRating {
            ratingView.currentRating = rating.rating ?? 0
            ratingDescriptionLbl.text =  rating.review
            
            if let user = UserManager.shared.currentUser {
                userNameRatingLbl.text = user.name
                if let urlString = user.profileImage, let url = URL(string: urlString) {
                    userRatingImgVw.sd_setImage(with: url, placeholderImage: UIImage(named: "profile_avatar"), options: .continueInBackground, context: [:])
                }
            }
        }
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
    
    func successful(message: String) {
        
    }
    
    func ratingList(_ratingList: [Rating]) {
        
    }

    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
}


class ServiceCell: UITableViewCell {
    @IBOutlet weak var serviceNameLbl: UILabel!
}

class CarImageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var carImgVw: UIImageView!
}
