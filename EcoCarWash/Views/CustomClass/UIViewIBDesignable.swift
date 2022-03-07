import Foundation
import UIKit

@IBDesignable
open class UIViewIBDesignable: UIImageView {
    public override init(frame: CGRect) {
        super.init(frame: frame)

    }
    @IBInspectable public var cornerRad: CGFloat = 0.00 {
        didSet {
            self.layer.cornerRadius = cornerRad

        }
    }
    @IBInspectable public var  ShadowObjColor: UIColor = UIColor.black {
        didSet {
            addShadow(obj: self, shadColor: ShadowObjColor, shadOpacity: ShadowShadOpacity, shadOff: ShadowShadOff)
        }
    }
    @IBInspectable public var  ShadowShadOff: CGSize = CGSize.init(width: 5, height: 5) {
        didSet {
            addShadow(obj: self, shadColor: ShadowObjColor, shadOpacity: ShadowShadOpacity, shadOff: ShadowShadOff)
        }
    }
    @IBInspectable public var  ShadowShadOpacity: Float = 0.4 {
        didSet {
            addShadow(obj: self, shadColor: ShadowObjColor, shadOpacity: ShadowShadOpacity, shadOff: ShadowShadOff)
        }
    }

    @IBInspectable public var  bordColor: UIColor = UIColor.black {
        didSet {

            self.layer.borderColor = bordColor.cgColor
        }
    }

    @IBInspectable public var  bordWidth: CGFloat = 1.00 {
        didSet {

            self.layer.borderWidth = bordWidth
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
