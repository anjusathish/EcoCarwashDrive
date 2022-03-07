//
//  AddressSelectionViewController.swift.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 18/11/21.
//

import UIKit
import GoogleMaps

enum ChildControllers: String {
    case kConfirmAddressVc = "ConfirmAddressViewController",
         kSaveAddressVc = "SaveAddressViewController",
         kAppointmentVc = "AppointmentViewController",
         kNavigateVc = "NavigateViewController"
}

class AddressSelectionViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var markerImgVw: UIImageView!
 
    var bottomChildViewController: UIViewController?
    var confirmAddressVc: ConfirmAddressViewController?
    var saveAddressVc: SaveAddressViewController?

    var coordinate = CLLocationCoordinate2D()
    var addressStr = String()
    var isUpdateAddress: Bool?
    var updateAddressId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGoogleMap()
        
        _ = showChildViewController(nil)
        confirmAddressVc = showChildViewController(.kConfirmAddressVc) as? ConfirmAddressViewController
        confirmAddressVc?.delegate = self

    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setGoogleMap() {
        mapView.isMyLocationEnabled = true
        mapView.setMinZoom(6, maxZoom: 20)
        mapView.delegate = self
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
        UserManager.shared.googleMapStyle(mapView: mapView)
        
        if let latitude = LocationManager.sharedManager.locationManager.location?.coordinate.latitude,
            let longitude = LocationManager.sharedManager.locationManager.location?.coordinate.longitude {
            _ = GMSMutableCameraPosition.camera(withLatitude: latitude,
                                                     longitude: longitude,
                                                     zoom: 15)
            mapView.camera = GMSCameraPosition.init(target: self.setOffsetForCoordinates(mapView: mapView, coords: LocationManager.sharedManager.locationManager.location!.coordinate), zoom: 15)
            
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            displayPlaceAdress(CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) { address in
                self.confirmAddressVc?.addressLbl.text = address
                self.addressStr = address
            }
        } else {
            LocationManager.sharedManager.locationUpdateBlock = { location, nowTimestamp in
                self.mapView.camera = GMSCameraPosition.init(target: self.setOffsetForCoordinates(mapView: self.mapView, coords: location.coordinate), zoom: 15)
                LocationManager.sharedManager.locationUpdateBlock = nil
            }
        }
    }
            
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @discardableResult func showChildViewController(_ childIdentifier: ChildControllers?) -> UIViewController? {
        
        if childIdentifier == nil {
            return nil
        }

        let vc = Utilities.sharedInstance.dashboardController(identifier: childIdentifier!.rawValue)
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        bottomChildViewController = vc
        return vc
    }
    
    func hideChildViewController() {
        DispatchQueue.main.async {
            self.bottomChildViewController?.willMove(toParent: self)
            self.bottomChildViewController?.view.removeFromSuperview()
            self.bottomChildViewController?.removeFromParent()
            self.bottomChildViewController = nil
        }
    }

}

extension AddressSelectionViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let coordinate = self.mapView.projection.coordinate(for: CGPoint.init(x: self.view.center.x, y: self.view.center.y - 23.5))
        
        self.coordinate = coordinate
        displayPlaceAdress(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)){ address in
            self.confirmAddressVc?.addressLbl.text = address
            self.addressStr = address
        }
    }
}

extension AddressSelectionViewController: ConfirmAddressDelegate {
   
    func didPressConfirmAddressButton() {
        
        _ = showChildViewController(nil)
        saveAddressVc = showChildViewController(.kSaveAddressVc) as? SaveAddressViewController
        saveAddressVc?.address = addressStr
        saveAddressVc?.coordinates = coordinate
        saveAddressVc?.isUpdateAddress = isUpdateAddress
        saveAddressVc?.updateAddressId = updateAddressId
        saveAddressVc?.delegate = self
    }
    
    func didPressCurrentLocation() {
        didPressMyLocation()
    }
    
    func didPressMyLocation() {
        if let coordinate = LocationManager.sharedManager.locationManager.location?.coordinate {
            if let mapView = mapView {
                mapView.animate(toLocation: self.setOffsetForCoordinates(mapView: mapView, coords: coordinate))
                mapView.animate(toZoom: 15)
            }
            let centerPoint = CGPoint.init(x: self.view.center.x, y: self.view.center.y)
            let markerCoordinates = mapView.projection.coordinate(for: centerPoint)
            
            self.coordinate = markerCoordinates
            self.displayPlaceAdress(markerCoordinates) { address in
                self.confirmAddressVc?.addressLbl.text = address
                self.addressStr = address
            }
            return
        }
    }
}

extension AddressSelectionViewController: AddressDelegate {
    
    func didSaveUserAddress() {
        if let viewControllers = self.navigationController?.viewControllers
        {
            if viewControllers.contains(where: { return $0 is RootViewController })
            {
                NotificationCenter.default.post(name: .getAddress, object: nil)
                hideChildViewController()
                self.navigationController?.popViewController(animated: true)
            }
            else{
                let vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.rootVC)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
