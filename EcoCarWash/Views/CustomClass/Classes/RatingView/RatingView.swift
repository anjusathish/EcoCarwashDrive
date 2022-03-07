//
//  RatingView.swift
//  HIYR
//
//  Created by Evgeniy Leychenko on 07.12.16.
//  Copyright © 2016 theappsolutions.com. All rights reserved.
//

import UIKit

@IBDesignable
public class RatingView: UIView {

    @IBInspectable public var selectedImage: UIImage? {
        didSet { setNeedsLayout() }
    }
    @IBInspectable public var unselectedImage: UIImage? {
        didSet { setNeedsLayout() }
    }
    @IBInspectable public var maxRating: Int = 1 {
        didSet { setNeedsLayout() }
    }
    @IBInspectable public var currentRating: Int = 1 {
        didSet { update(with: currentRating) }
    }
    @IBInspectable public var interButtonSpace: CGFloat = 3 {
        didSet { setNeedsLayout() }
    }
    
    private var starButtons: [UIButton] = []

    // MARK: - Lifecycle -
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        clear()
        
        addStarButtons(quantity: maxRating)
        updateWidth()
        update(with: currentRating)
    }
    
    // MARK: - Actions -
    
    @objc private func ratingAction(_ sender: UIButton) {
        guard let buttonIndex = starButtons.firstIndex(of: sender) else { return }
        
        currentRating = buttonIndex + 1
        update(with: currentRating)
    }
    
    @objc private func touchAction(_ sender: UIButton) {
        sender.isHighlighted = false
    }
    
    // MARK: - Private -
    
    private func clear() {
        starButtons.forEach({ $0.removeFromSuperview() })
        starButtons.removeAll()
    }
    
    private func addStarButtons(quantity: Int) {
        let buttonSide = frame.size.height
        
        for index in 0..<quantity {
            let newButton = makeStarButton()
            addSubview(newButton)
            starButtons.append(newButton)
            
            newButton.frame = CGRect(x: CGFloat(index) * (buttonSide + interButtonSpace),
                                     y: 0,
                                     width: buttonSide,
                                     height: buttonSide)
        }
    }
    
    private func makeStarButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = isUserInteractionEnabled
        button.adjustsImageWhenDisabled = false
        
        button.setBackgroundImage(selectedImage, for: .selected)
        button.setBackgroundImage(unselectedImage, for: .normal)
        
        button.addTarget(self, action: #selector(ratingAction), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchAction), for: .allTouchEvents)
        
        return button
    }
    
    private func update(with rating: Int) {
        for (index, button) in starButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
    
    private func updateWidth() {
        let totalButtonsSpace = CGFloat(maxRating) * frame.size.height
        let totalInterButtonsSpace = CGFloat(maxRating - 1) * interButtonSpace
        let width = totalButtonsSpace + totalInterButtonsSpace
        
        if let widthConstraint = constraints.first(where: { $0.firstAttribute == .width }) {
            widthConstraint.constant = width
        } else {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
}
