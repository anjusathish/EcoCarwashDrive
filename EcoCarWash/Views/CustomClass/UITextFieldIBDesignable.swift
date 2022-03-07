import Foundation
import UIKit

@IBDesignable
open class UITextFieldIBDesignable: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

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

    @IBInspectable public var  placeHolderTxtColor: UIColor = UIColor.white {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: placeholder!,
                                                            attributes: [NSAttributedString.Key.foregroundColor: placeHolderTxtColor])
        }
    }

    @IBInspectable public var  addBottomLineColor: UIColor = UIColor.white {
        didSet {
            if #available(iOS 12.0, *) {
                addBottomLine(obj: self, colr: addBottomLineColor)
            } else {
                // Fallback on earlier versions
            }
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
