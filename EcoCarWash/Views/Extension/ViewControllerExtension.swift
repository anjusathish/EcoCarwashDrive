//
//  ViewControllerExtension.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 26/11/21.
//

import UIKit
import GoogleMaps

public extension UIViewController {

    internal func setMarker(_ coordinate: CLLocationCoordinate2D, mapView: GMSMapView, type: LocationType) {
                        
        DispatchQueue.main.async {
            let marker = GMSMarker(position: coordinate)
            
            let markerView = type == .current ? UIImage(named: "current-location") : type == .pickup ? UIImage(named: "black-marker") : type == .dropoff ? UIImage(named: "dropoff-marker") : UIImage(named: "store-marker")
            
            marker.icon = self.imageWithImage(image: markerView!, scaledToSize: CGSize(width: 50.0, height: 50.0))
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.map = mapView
            marker.zIndex = MapViewController.zindex + 1
        }
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func setOffsetForCoordinates(mapView: GMSMapView, offset: CGFloat = 50, coords:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        mapView.camera = GMSCameraPosition.init(target: coords, zoom: 15)
        let point = mapView.projection.point(for: coords)
        let pointInNewView = mapView.convert(point, from: mapView)
        let offsetCoords = mapView.projection.coordinate(for: CGPoint.init(x: pointInNewView.x, y: pointInNewView.y + 50))
        return offsetCoords
    }
    
    func displayPlaceAdress(_ placeCoordinate: CLLocationCoordinate2D, completion: @escaping ((String) -> ())) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(placeCoordinate) { (results, _) in
            if let adress = results?.firstResult() {
                DispatchQueue.main.async {
                    let addressStr = (adress.lines?.first.isNillOrEmpty())! ? adress.locality ?? adress.country ?? "Unnamed place" : (adress.lines?.first!)!
                    completion(addressStr)
                    print("------------>",addressStr)
                }
            }
        }
    }
    
    func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertedDate = dateFormatter.date(from: date)

        guard dateFormatter.date(from: date) != nil else {
            print(false, "no date from string")
            return ""
        }

        dateFormatter.dateFormat = "d MMM yyyy"///this is what you want to convert format
        let timeStamp = dateFormatter.string(from: convertedDate!)

        return timeStamp
    }

    func calculatePercentage(value:Double, percentageVal: Double) -> Double{
        let val = value * percentageVal
        return val / 100.0
    }

}

class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}
