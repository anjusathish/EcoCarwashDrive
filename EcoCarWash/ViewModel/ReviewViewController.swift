//
//  ReviewViewController.swift
//  Eco carwash Drive
//
//  Created by Indium Software on 23/12/21.
//

import UIKit

class ReviewViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: Constants.TableViewCellID.ReviewCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellID.ReviewCell)
        }
    }
    
    lazy var viewModel: AppointmentViewModel = {
        return AppointmentViewModel()
    }()
    
    var appointmentId: String = ""
    var ratingData: [Rating] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.getReviewList(by: true)
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        if let vc = navigationController?.viewControllers.first(where: { $0 is RootViewController }) {
            navigationController?.popToViewController(vc, animated: true)
        }
    }
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellID.ReviewCell, for: indexPath) as! ReviewCell
        
        let review = ratingData[indexPath.row]
        
        cell.userNameRatingLbl.text = review.user
        cell.ratingDescriptionLbl.text = review.review
        cell.ratingView.currentRating = review.rating ?? 0

//        if let urlString = user.profileImage, let url = URL(string: urlString) {
//            userRatingImgVw.sd_setImage(with: url, placeholderImage: UIImage(named: "profile_avatar"), options: .continueInBackground, context: [:])
//        }
        
        return cell
    }
}

extension ReviewViewController: AppointmentDelegate {
    
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
        
    }
    
    func ratingList(_ratingList: [Rating]) {
        ratingData = _ratingList
        tableView.reloadData()
    }
    
    func successful(message: String) {
        
    }
    
    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
}
