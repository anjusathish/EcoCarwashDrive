//
//  BookAppointmentViewController.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 21/10/21.
//

import UIKit

class BookAppointmentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.register(UINib(nibName: Constants.TableViewCellID.AccesoriesCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellID.AccesoriesCell)
        }
    }
    
    @IBOutlet weak var storeNameLbl: UILabel!
    @IBOutlet weak var storeRatingLbl: UILabel!
    @IBOutlet weak var closingTimeLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if let storeInfo = AppointmentManager.shared.store {
            storeNameLbl.text = storeInfo.name
            storeRatingLbl.text = storeInfo.rating
            addressLbl.text = storeInfo.address?.address
            closingTimeLbl.text = "Closes at \(Int(storeInfo.storeTimings?.endTime?.components(separatedBy: ":").first ?? "") ?? 0)pm"
        }
    }

    @IBAction func bookNowBtn(_ sender: UIButton) {
        let vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.serviceTypeVC) as! ServiceTypeViewController
        AppointmentInfo.details.appointment_nature = .Store
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension BookAppointmentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellID.AccesoriesCell, for: indexPath) as! AccesoriesCell
        return cell
    }
}
