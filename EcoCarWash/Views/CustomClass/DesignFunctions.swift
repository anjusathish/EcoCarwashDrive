//
//  DesignFunctions.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 30/11/21.
//

import UIKit

var isBannerShowing = false

func addShadow(obj: UIView, shadColor: UIColor, shadOpacity: Float, shadOff: CGSize) {
    obj.layer.shadowColor = shadColor.cgColor
    obj.layer.shadowOpacity = shadOpacity
    obj.layer.shadowOffset = shadOff
}

func addCornerRadius(btn: UIView, rad: CGFloat) {
    btn.layer.cornerRadius = rad
    btn.layer.masksToBounds = false
}

func placeHolderColor(txtFld: UITextField, text: String, colr: UIColor) {
    txtFld.attributedPlaceholder = NSAttributedString(string: text,
                                                      attributes: [NSAttributedString.Key.foregroundColor: colr])
}

@available(iOS 12.0, *)
func addBottomLine(obj: UIView, colr: UIColor) {

    let screenWidth = UIScreen.main.bounds.size.width
    let border = CALayer()
    let width = CGFloat(5)
    border.borderColor = colr.cgColor
    border.frame = CGRect(x: 0, y: obj.frame.size.height-width, width: screenWidth, height: width)

    border.borderWidth = width
    obj.layer.addSublayer(border)
    obj.layer.masksToBounds = true
}

protocol FunctionProtocol {

}

extension FunctionProtocol where Self: UIViewController {
    func showAlert(msg: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
    }

    func showAlertWithAction(msg: String) {

        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func basicAnimate(val: CGFloat, layout: NSLayoutConstraint, time: TimeInterval, completionBlock:@escaping (_ Checked: Bool) -> Void) {
        UIView.animate(withDuration: time) {

            layout.constant += val
            self.view.layoutIfNeeded()
            completionBlock(true)

        }
    }

    func shrinkToZero(layout: NSLayoutConstraint, time: TimeInterval, completionBlock:@escaping (_ Checked: Bool) -> Void) {
        UIView.animate(withDuration: time) {

            layout.constant = 0
            self.view.layoutIfNeeded()
            completionBlock(true)
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0

        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension UIViewController: FunctionProtocol {
    func ShakeAnimation(shakeBtn: UIButton, shakeLayer: CALayer) {

        let midX = shakeBtn.center.x
        let midY = shakeBtn.center.y

        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.04
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: midX - 5, y: midY)
        animation.toValue = CGPoint(x: midX + 5, y: midY)
        shakeLayer.add(animation, forKey: "position")
    }
}

extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat {
    let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()

    return label.frame.height
}

func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        completion(data, response, error)
        }.resume()
}

func downloadImage(url: URL) -> UIImage {
    print("Download Started")
    var img = UIImage()
    getDataFromUrl(url: url) { data, response, error in
        guard let data = data, error == nil else { return }
        print(response?.suggestedFilename ?? url.lastPathComponent)
        print("Download Finished")
        DispatchQueue.main.async {
            img = UIImage.init(data: data)!
        }
    }
    return img
}

func downloadImg(urlString: String, imgView: UIImageView) {

    let imageUrlString = urlString
    let imageUrl: URL = URL(string: imageUrlString)!

    // Start background thread so that image loading does not make app unresponsive
    DispatchQueue.global(qos: .userInitiated).async {

        do {
        let imageData: NSData = try NSData.init(contentsOf: imageUrl)
            // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                imgView.image = UIImage(data: imageData as Data)!
            }
        } catch {

        }
    }
}
extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var data: Data {
        return try! JSONEncoder().encode(self)
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] ?? [:]
    }
}
