//
//  LocationManager.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 18/11/21.
//

import UIKit
import CoreLocation
import Foundation

public enum TrackingMode: String {
    case updateLocation = "updateLocation"
    case readyUpdates = "readyUpdates"
    case rideTracking = "rideTracking"
    case riderTracking = "riderTracking"
    case none = "none"
}

open class LocationManager: NSObject, CLLocationManagerDelegate {

    private var lastLocationUpdateTimesatmp: TimeInterval?
    
    var appName: String {
        get {
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        }
    }
    
    public static let sharedManager = LocationManager()
    public let locationManager = CLLocationManager()
    open var status = CLAuthorizationStatus.denied
    open var locationUpdateBlock: ((CLLocation, TimeInterval) -> Void)?
    open var trackingMode: TrackingMode = .none {
        didSet {
            trackingMode == .none ? startUpdatingLocation() : startUpdatingLocation()
        }
    }

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = appName == "Facedrive" ? false : true
    }

    public func startUpdatingLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        //locationManager.allowsBackgroundLocationUpdates = trackingMode == .riderTracking ? false : true
        locationManager.allowsBackgroundLocationUpdates = appName == "Facedrive" ? false : true
        locationManager.startUpdatingLocation()
    }

    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = appName == "Facedrive" ? false : true
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LocationServiceStatusChanged"), object: self)
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let nowUptimeTimestamp = ProcessInfo.processInfo.systemUptime
        guard let recentLocation = locations.last else { return }
        guard let updateBlock = locationUpdateBlock else { return }
        let nowTimestamp = Date().timeIntervalSince1970
        if trackingMode == .riderTracking { updateBlock(recentLocation, nowTimestamp) }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LocationChanged"), object: nil)
        guard abs(nowUptimeTimestamp - (lastLocationUpdateTimesatmp ?? TimeInterval())) >= 4 else { return }
        lastLocationUpdateTimesatmp = nowUptimeTimestamp
        updateBlock(recentLocation, nowTimestamp)
    }

    public func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {

    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if trackingMode == .none, let updateBlock = locationUpdateBlock {
            updateBlock(locationManager.location ?? CLLocation(), Date().timeIntervalSince1970)
            locationUpdateBlock = nil
        }
    }

}
