//
//  CTButton.swift
//  Clear Thinking
//
//  Created by Athiban Ragunathan on 02/07/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CTButton: UIButton {
    
    @IBInspectable var style: Int = 0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 20 {
         didSet {
             updateView()
         }
     }
    
    @IBInspectable var bgColor: UIColor = .ctBlue {
            didSet {
                updateView()
            }
        }
    
    var shadowLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch style {
        case 0:
            if shadowLayer == nil {
                
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
                shadowLayer.fillColor = UIColor.ctBlue.cgColor
                
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                shadowLayer.shadowOpacity = 0.5
                shadowLayer.shadowRadius = 2
                
                layer.insertSublayer(shadowLayer, at: 0)
                self.setTitleColor(UIColor.white, for: .normal)
            }
        case 1:
            layer.cornerRadius = cornerRadius
            layer.borderWidth = 1
            layer.borderColor = UIColor.ctBlue.cgColor
        case 2:
            if shadowLayer != nil {
                shadowLayer.removeFromSuperlayer()
                shadowLayer = nil
            }
            layer.cornerRadius = 15
            backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            setTitleColor(UIColor.black, for: .normal)
        case 3:
            if shadowLayer != nil {
            shadowLayer.removeFromSuperlayer()
            shadowLayer = nil
            }
           layer.cornerRadius = 15
           layer.borderWidth = 1
           layer.borderColor = UIColor.ctYellow.cgColor
           backgroundColor = .ctYellow
     //      backgroundColor = UIColor.white.withAlphaComponent(0.5)
           setTitleColor(UIColor.white, for: .normal)
        case 4:
            layer.borderWidth = 0
            layer.cornerRadius = cornerRadius
            backgroundColor = bgColor
            setTitleColor(.white, for: .normal)
        default: break
        }
    }
    
    func updateView() {
        
        switch style {
        case 0:
            if shadowLayer != nil {
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
                shadowLayer.fillColor = UIColor.ctYellow.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                shadowLayer.shadowOpacity = 0.5
                shadowLayer.shadowRadius = 2
                self.setTitleColor(UIColor.white, for: .normal)
            }
        case 1:
            layer.cornerRadius = cornerRadius
            layer.borderWidth = 1
            layer.borderColor = UIColor.ctBlue.cgColor
        case 2:
            if shadowLayer != nil {
                shadowLayer.removeFromSuperlayer()
                shadowLayer = nil
            }
            layer.cornerRadius = 10
            backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            setTitleColor(UIColor.white, for: .normal)
            case 4:
                       layer.borderWidth = 0
                       layer.cornerRadius = cornerRadius
                       backgroundColor = bgColor
                       setTitleColor(.white, for: .normal)
        default: break
        }
    }
}

@IBDesignable
open class IBButtonClass: UIButton {
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

    @IBInspectable public var  bottomlineColor: UIColor = UIColor.black {
        didSet {
            if #available(iOS 12.0, *) {
                addBottomLine(obj: self, colr: bottomlineColor)
            } else {
                // Fallback on earlier versions
            }
        }
    }

    @IBInspectable public var  bordWidth: CGFloat = 2.00 {
        didSet {

            self.layer.borderWidth = bordWidth
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
