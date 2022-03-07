//
//  NavigateViewController.swift
//  Eco carwash Drive
//
//  Created by Indium Software on 28/01/22.
//

import UIKit
import GoogleMaps
import CoreLocation
import FirebaseDatabase

protocol PolylineDelegate {
    func drawPolyline(pickup: CLLocationCoordinate2D, dropOff: CLLocationCoordinate2D)
}

class NavigateViewController: BaseViewController {

    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var storeProfileImgVw: UIImageView!
    @IBOutlet weak var bookingTimeLbl: UILabel!
    @IBOutlet weak var paymentModeLbl: UILabel!
    @IBOutlet weak var navigateBtn: UIButton!
    @IBOutlet weak var tableHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var serviceTableView: UITableView!{
        didSet {
            serviceTableView.register(UINib(nibName: Constants.TableViewCellID.ServiceTypeCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellID.ServiceTypeCell)
        }
    }

    var interiorService  : [Service] = []
    var exteriorService  : [Service] = []
    var overallService   : [[Service]] = []
    var headerData       = [String]()
    
    let dbRef = Database.database().reference()
    
    var delegate: PolylineDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getServiceInfo()
        observiceDatabase()
        
        let appointment = AppointmentManager.shared.appointment?.first
        
        storeName.text = appointment?.store?.name
        storeAddress.text = appointment?.store?.address?.address
        bookingTimeLbl.text = appointment?.date?.getDateAsStringWith(inFormat: "yyyy-MM-dd'T'HH:mm:ssZ", outFormat: "HH:mm")
        paymentModeLbl.text = appointment?.paymentType
        
        storeProfileImgVw.sd_setImage(with: URL(string: appointment?.store?.image ?? ""),
                               placeholderImage: UIImage(named: "profile_avatar"),
                               options: .handleCookies,
                               context: nil)

    }
    
    func getServiceInfo() {
        
        if let service = AppointmentManager.shared.appointment?.first?.services {
            
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
            serviceTableView.reloadData()
        }
    }
    
    @IBAction func navigateBtn(_ sender: UIButton) {
        observiceDatabase(isNavigate: true)
    }
    
    func observiceDatabase(isNavigate: Bool = false) {
        
        if let trackingID = AppointmentManager.shared.appointment?.first?.trackingID {
            let coordinatePath = "appointments/\(trackingID)"
            
            if let userLoc = LocationManager.sharedManager.locationManager.location?.coordinate {
                
                dbRef.child(coordinatePath).observe(.value) { snapShot in
                                
                    if snapShot.exists() {

                        guard let cleanerCoor = snapShot.value as? NSDictionary else { return }
                        guard let coordinate  = cleanerCoor["coordinates"] as? NSDictionary else { return }
                        
                        let lat = coordinate["latitude"] as! Double
                        let long = coordinate["longitude"] as! Double
                        
                        let pickupLoc = CLLocationCoordinate2D(latitude: userLoc.latitude, longitude: userLoc.longitude)
                        let dropOffLoc = CLLocationCoordinate2D(latitude: lat, longitude: long)

                        self.delegate?.drawPolyline(pickup: pickupLoc, dropOff: dropOffLoc)
                        
                        if isNavigate {
                            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                                let urlString = "http://maps.google.com/?saddr=\(userLoc.latitude),\(userLoc.longitude)&daddr=\(lat),\(long)"
                                UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
                            } else {
                                self.displayServerSuccess(withMessage: "Google map is not available!")
                                if let url = URL(string: "https://apps.apple.com/in/app/google-maps-transit-food/id585027354") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }
                    }
                    else
                    {
                        print("no snapshots exist")
                    }
                }
            }
        } else {
            self.displayServerError(withMessage: "Cleaner didn't assigned yet to navigate!")
        }
    }
    

}

// MARK: - Tableview delegate and data source methods
extension NavigateViewController: UITableViewDelegate, UITableViewDataSource {
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return overallService[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellID.ServiceTypeCell, for: indexPath) as! ServiceTypeCell
        
        cell.serviceLbl.text = overallService[indexPath.section][indexPath.row].title
        cell.serviceLbl.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        cell.bulletView.backgroundColor = UIColor.white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 25))
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10))

        label.font = UIFont(name: "HelveticaNeue-Regular", size: 16)
        label.textColor = UIColor.white
       
        label.text = headerData[section]
      
        headerView.backgroundColor = .clear
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
