//
//  MapViewController.swift
//  EcoCarWash
//
//  Created by Indium Software on 10/09/21.
//

import UIKit
import GoogleMaps
import CoreLocation
import RESideMenu

enum LocationType {
    case current,
         pickup,
         dropoff,
         storePoint
}
    
protocol StoreLocationProtocol {
    var latitude: Double? { get }
    var longitude: Double? { get }
}

struct Coordinate {
    var latitude: Double
    var longitude: Double
}

class MapViewController: BaseViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var locationDragged = false
    var storeMarkers = [GMSMarker]()
    static var zindex: Int32 = 0

    var polyline: GMSPolyline? {
        didSet {
            polyline?.zIndex = INT32_MAX - 1
        }
    }
    
    var oldPolylineArr = [GMSPolyline]()

    var paths = GMSMutablePath()
    var currentPath = GMSPath()

    var currentLocMarker: GMSMarker? {
        didSet {
            oldValue?.map = nil
            guard currentLocMarker != nil else {
                return
            }
        }
    }
    
    var storeMarker: GMSMarker?
    var storesLocation = [CLLocationCoordinate2D]()
    var bottomChildViewController: UIViewController?
    var appointmentVC: AppointmentViewController?
    var navigateVC: NavigateViewController?
    var storesList = [Store]()
    
    lazy var viewModel: AppointmentViewModel = {
        return AppointmentViewModel()
    }()

    var sideMenu = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
     

        setGoogleMap()
        
        sideMenuViewController.delegate = self
        
        view.addSubview(sideMenu)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func setGoogleMap() {
        addHamburgerMenu(isBackAdded: false)
        
        _ = showChildViewController(nil)
        appointmentVC = showChildViewController(.kAppointmentVc) as? AppointmentViewController
        appointmentVC?.delegate = self

        mapView.isMyLocationEnabled = true
        mapView.setMinZoom(6, maxZoom: 20)
        mapView.delegate = self
        mapView.settings.rotateGestures = false
        mapView.settings.tiltGestures = false
        UserManager.shared.googleMapStyle(mapView: mapView)
        
        
        ///Get user current location
        if let _ = LocationManager.sharedManager.locationManager.location?.coordinate {
            
            _ = GMSMutableCameraPosition.camera(withLatitude: 13.047613,  longitude: 80.144363, zoom: 15)
            
            let loc = CLLocationCoordinate2D(latitude: 13.047613, longitude: 80.144363)
            let target = self.setOffsetForCoordinates(mapView: self.mapView, coords: loc)

             displayPlaceAdress(loc, completion: { addressStr in
                 self.appointmentVC?.addressLbl.text = addressStr
            })
            
            UIView.animate(withDuration: 0.5, animations: {
                self.mapView.camera = GMSCameraPosition.init(target: target, zoom: 10)
                self.view.layoutIfNeeded()
            })
            
            setMarkerToLocation(loc, type: .current)
            viewModel.delegate = self
            viewModel.getStoreListFrom(distance: "70", lat: "13.047613", long: "80.144363")
            
        } else {
            LocationManager.sharedManager.locationUpdateBlock = { location, nowTimestamp in
                self.mapView.camera = GMSCameraPosition.init(target: self.setOffsetForCoordinates(mapView: self.mapView, coords: location.coordinate), zoom: 15)
                LocationManager.sharedManager.locationUpdateBlock = nil
            }
        }
    }
        
    func addHamburgerMenu(isBackAdded: Bool = false) {
        sideMenu = UIButton(frame: CGRect(x: 25, y: 60, width: 46, height: 46))
        sideMenu.setImage(nil, for: .normal)
        sideMenu.setImage(isBackAdded ? UIImage(named: "Icon-Arrow-Right") : UIImage(named: "HamburgerMenu"), for: .normal)
        sideMenu.addTarget(self, action: #selector(showSideMenu(_:)), for: .touchUpInside)
        sideMenu.layoutIfNeeded()
    }

    @objc func showSideMenu(_ sender: UIButton) {
        
        if children.first(where: { String(describing: $0.classForCoder) == "NavigateViewController" }) != nil
        {
            print("we have one")
            hideChildViewController()
            AppointmentManager.shared.removeAppointment()
            
            mapView.clear()
            
            for p in (0 ..< self.oldPolylineArr.count) {
                self.oldPolylineArr[p].map = nil
            }
            
            storeMarkers.forEach { marker in
                setMarker(marker.position, mapView: self.mapView, type: .storePoint)
            }
        }
        else
        {
            self.sideMenuViewController.presentLeftMenuViewController()
            appointmentVC?.storeDetailView.isHidden = true
        }
    }
    
    @objc func backBtn(_ sender: UIButton) {
        setGoogleMap()
    }
    
    @discardableResult func showChildViewController(_ childIdentifier: ChildControllers?) -> UIViewController? {
        
        if childIdentifier == nil {
            return nil
        }

        let vc = Utilities.sharedInstance.appointmentController(identifier: childIdentifier!.rawValue)
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

    func setMarkerToLocation(_ location: CLLocationCoordinate2D, type: LocationType) {
        
        let marker = GMSMarker(position: location)
        marker.zIndex = INT32_MAX
        
        switch type {
        case .current:
            currentLocMarker = marker
            marker.icon = self.imageWithImage(image: UIImage(named: "current-location")!,
                                              scaledToSize: CGSize(width: 80, height: 80))
        case .pickup, .dropoff, .storePoint:
            break
        }
        marker.map = mapView
    }
}

extension MapViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let target = setOffsetForCoordinates(mapView: mapView, coords: marker.position)
        mapView.camera = GMSCameraPosition.init(target: target, zoom: 15)

        if marker != currentLocMarker {
//            appointmentVC?.storeDetailView.isHidden = false
            return true
        }
        
//        appointmentVC?.storeDetailView.isHidden = true
        return false
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
//        appointmentVC?.storeDetailView.isHidden = true
    }
    
}

// #MARK: - SideMenu Delegate Methods
extension MapViewController: RESideMenuDelegate {
    
    func sideMenu(_ sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        view.roundCorners(corners: .allCorners, radius: 30)
    }
    
    func sideMenu(_ sideMenu: RESideMenu!, willHideMenuViewController menuViewController: UIViewController!) {
        view.roundCorners(corners: .allCorners, radius: 0)
    }
}

extension MapViewController: AppointmentDelegate, StoreDelegate, PolylineDelegate {
    
    func getStoreList(_storeListData: [Store]) {

        storesList = _storeListData
        
        _ = _storeListData.map { store in
            if let storeAddress = store.address {
                if let lat = storeAddress.latitude, let long = storeAddress.longitude {
                    let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let marker = GMSMarker(position: location)
                    marker.icon = self.imageWithImage(image: UIImage(named: "store-marker")!, scaledToSize: CGSize(width: 30.0, height: 30.0))
                    marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                    self.storeMarkers.append(marker)
//                    setMarker(location, mapView: self.mapView, type: .storePoint)
                }
                
                storeMarkers.forEach { marker in
                    setMarker(marker.position, mapView: self.mapView, type: .storePoint)
                }
                
            }
        }
        appointmentVC?.storeList = _storeListData.sorted(by: {$0.name ?? "" < $1.name ?? ""})
        appointmentVC?.tableView.reloadData()
    }
    
    func didSelectStore(_ store: Store) {
        
        if let address = store.address {
            if let lat = address.latitude, let long = address.longitude {
                
                UIView.animate(withDuration: 0.5, animations: {
                    let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let target = self.setOffsetForCoordinates(mapView: self.mapView, offset: 250, coords: location)
                    
                    self.mapView.camera = GMSCameraPosition.init(target: target, zoom: 10)
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func didSelectUpcomingService(_ appointment: BookedAppointment) {
      
        addHamburgerMenu(isBackAdded: true)
        _ = showChildViewController(nil)
        navigateVC = showChildViewController(.kNavigateVc) as? NavigateViewController
        navigateVC?.delegate = self
        AppointmentManager.shared.appointment = [appointment]
    }

    func drawPolyline(pickup: CLLocationCoordinate2D, dropOff: CLLocationCoordinate2D) {
        
        let pick = CLLocationCoordinate2D(latitude: 11.067952261338192, longitude: 76.95309382209248)
        let drop = CLLocationCoordinate2D(latitude: 13.06975828465107, longitude: 80.28660232849315)

        mapView.clear()
        
        storeMarkers.forEach({ $0.map = nil })
        storeMarkers.removeAll()
        self.view.layoutIfNeeded()

        drawPolylineOnMap(pickup: pick, dropoff: drop)
    }
    
    func drawPolylineOnMap(pickup: CLLocationCoordinate2D, dropoff: CLLocationCoordinate2D) {
        
        RideManager.sharedManager.getDirection(pickup, dropoff: dropoff) { [unowned self] polyline  in
            OperationQueue.main.addOperation {
                self.polyline?.map = nil
                self.polyline = nil
                self.paths = GMSMutablePath()
                let path = GMSPath(fromEncodedPath: polyline)
                self.currentPath = path!
                let polyline = GMSPolyline(path: path)
                polyline.strokeWidth = 4.3
                polyline.strokeColor = UIColor.black
                polyline.map = self.mapView
                self.polyline = polyline
                var bounds = GMSCoordinateBounds()
                self.oldPolylineArr.append(polyline)
                for index in 1...path!.count() {
                    bounds = bounds.includingCoordinate(path!.coordinate(at: index))
                }
                setMarker(pickup, mapView: self.mapView, type: .pickup)
                setMarker(dropoff, mapView: self.mapView, type: .dropoff)

                let mapInsets = UIEdgeInsets(top: 150.0, left: 100.0, bottom: 350.0, right: 100.0)
                self.mapView.animate(with: GMSCameraUpdate.fit(bounds, with: mapInsets))
            }
        }
    }
    
    func failure(message: String) {
        self.displayServerError(withMessage: message)
    }
    
    func getServiceList(_serviceList: [Service]) {
        
    }
    
    func getBookedSlotInfo(_bookedSlotInfo: SlotInfo) {
        
    }
    
    func bookAppointment(_appointmentInfo: BookAppointmentModel) {
        
    }

    func appointmentList(_appointmentList: [BookedAppointment]) {
        
    }

    func ratingList(_ratingList: [Rating]) {
        
    }

    func successful(message: String) {

    }

    func getCouponListInfo(_couponList: [Coupon]) {
        
    }
}
