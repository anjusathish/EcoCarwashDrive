//
//  RatingViewController.swift
//  Eco carwash Drive
//
//  Created by Indium Software on 22/12/21.
//

import UIKit

class RatingViewController: BaseViewController {

    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var userName: UILabel! {
        didSet {
            if let name = UserManager.shared.currentUser?.name {
                userName.text = name
            }
        }
    }
    @IBOutlet weak var profileImgVw: UIImageView! {
        didSet {
            if let img = UserManager.shared.currentUser?.profileImage{
                if let urlString = img.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
                    if let url = URL(string: urlString) {
                        profileImgVw.sd_setImage(with: url, placeholderImage: UIImage(named: "profile_avatar"), options: .continueInBackground, context: [:])
                    }
                }
            }
        }
    }

    lazy var viewModel: AppointmentViewModel = {
        return AppointmentViewModel()
    }()
    
    var appointmentId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        
    }
   
    @IBAction func closeBtn(_ sender: UIButton) {
        if let viewController = navigationController?.viewControllers.first(where: {$0 is RootViewController}) {
            navigationController?.popToViewController(viewController, animated: true)
        }
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        let request = RatingRequest(rating: ratingView.currentRating, review: "Good service!", is_approved: false, appointment: appointmentId)
        viewModel.postAppointmentRating(info: request)
    }
}

extension RatingViewController: AppointmentDelegate {
    
    func successful(message: String) {
        self.displayServerSuccess(withMessage: message)
        
        let vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.reviewVC) as! ReviewViewController
        vc.appointmentId = "\(appointmentId)"
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
    
    func getCouponListInfo(_couponList: [Coupon]) {
        
    }
    
    func bookAppointment(_appointmentInfo: BookAppointmentModel) {
        
    }
    
    func appointmentList(_appointmentList: [BookedAppointment]) {
        
    }
    
    func ratingList(_ratingList: [Rating]) {
        
    }

}
