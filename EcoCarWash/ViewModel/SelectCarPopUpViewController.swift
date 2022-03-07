//
//  SelectCarPopUpViewController.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 23/09/21.
//

import UIKit

protocol CarConfigDelegate {
    func selectCarConfig(cofig: String)
}


class SelectCarPopUpViewController: UIViewController {

    @IBOutlet weak var seachTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var searchTF  : CTTextField!{
        didSet{
            searchTF.delegate = self
        }
    }
    
    var filterType = String()
    var carData = [String]()
    var searchData = [String]()
    var delegate: CarConfigDelegate?
    var strValue: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchData = carData
        seachTypeLabel.text = "Select your \(filterType.lowercased())"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissPopup(gesture:)))
        dismissView.addGestureRecognizer(tap)
    }

    func searchTextField(searchText: String) {
        searchData = searchText.count == 0 ? carData : carData.filter({$0.lowercased().contains(searchText.lowercased())})
        self.tableView.reloadData()
    }

    @objc func dismissPopup(gesture: UITapGestureRecognizer) {
        dismiss()
    }
    
    func dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
}


extension SelectCarPopUpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searchData.count == 0 {
            tableView.setEmptyView(title: "There are no \(filterType.lowercased())")
        }else {
            tableView.restore()
        }
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchData[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 16)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss()
        delegate?.selectCarConfig(cofig: searchData[indexPath.row])
    }
    
}


extension SelectCarPopUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        strValue = newString
        if newLength == 0 {
            strValue = ""
        }
        searchTextField(searchText: strValue ?? "")
        return true
    }
}
