//
//  RideManager.swift
//  Eco carwash Drive
//
//  Created by Indium Software on 02/02/22.
//

import Foundation
import GoogleMaps
import CoreLocation

open class RideManager: NSObject {
    
    public static let sharedManager = RideManager()
    
    var session: URLSession

    fileprivate enum Constants {
        static let googleRoadApiUrl = "https://maps.googleapis.com/maps/api/directions/json"
    }
    
    override init() {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        session = URLSession(configuration: configuration)
        super.init()
    }
    

    open func getDirection(_ pickup: CLLocationCoordinate2D, dropoff: CLLocationCoordinate2D, completionHandler:@escaping (String) -> Void) {
        
        if let url = URL(string: Constants.googleRoadApiUrl+"?origin=\(pickup.latitude),\(pickup.longitude)&destination=\(dropoff.latitude),\(dropoff.longitude)&key=AIzaSyCbIZG5t2EOjRWKwalBz56IdNkvqzK1gts") {
         
            let request = URLRequest(url: url)
            print("API URL: \(url) \n Method: GET")
            
            session.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil && data != nil else {
                    return
                }
                if let response = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String, AnyObject> {
                    if let array = response["routes"] as? Array<Dictionary<String, AnyObject>> {
                        if let polyline = array.first?["overview_polyline"]?["points"] as? String {
                            completionHandler(polyline)
                        }
                    }
                }
            }) .resume()
        }
    }
}
