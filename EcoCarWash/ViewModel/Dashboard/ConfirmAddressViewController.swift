//
//  ConfirmAddressViewController.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 18/11/21.
//

import UIKit

protocol ConfirmAddressDelegate {
    func didPressCurrentLocation()
    func didPressConfirmAddressButton()
}

class ConfirmAddressViewController: BaseViewController {

    @IBOutlet weak var currentLocBtn: UIButton!
    @IBOutlet weak var addressLbl: UILabel!

    var delegate: ConfirmAddressDelegate?
    
    var btnAction: (()->())?
    var addressAndType: ((String, String)->Void)?
        
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func currentLocationBtn(_ sender: UIButton) {
        delegate?.didPressCurrentLocation()
    }
    
    @IBAction func editAddressBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func confirmBtn(_ sender: UIButton) {
        delegate?.didPressConfirmAddressButton()
    }
}
