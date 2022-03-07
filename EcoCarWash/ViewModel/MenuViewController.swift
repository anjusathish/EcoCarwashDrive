//
//  MenuViewController.swift
//  Kinder Care
//
//  Created by CIPL0681 on 08/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {
    
//    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var slidemenuTableView: UITableView!
    @IBOutlet weak var profileImgBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    var menuItemsArr = ["Your orders", "Settings", "Help & Support","Logout"]
    var menuImgArr   = ["YourOrders", "Settings", "Help&Support", "Logout"]
    
    var vc : UIViewController!
    
    var profileFirstName : String?
    var profileLastName : String?
    var profileImage : UIImage?
    
    
    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        if let _currentUser = UserManager.shared.currentUser {
            nameLabel.text = _currentUser.name ?? ""
            
            if let img = UserManager.shared.currentUser?.profileImage{
                if let urlString = img.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
                    if let url = URL(string: urlString) {
                        profileImgBtn.sd_setImage(with: url, for: .normal, placeholderImage: UIImage(named: "profile_avatar"), options: .continueInBackground, context: [:])
                    }
                }

            } else {
                profileImgBtn.setImage(UIImage(named: "profile_avatar"), for: .normal)
            }
        }
        
        self.slidemenuTableView.register(UINib(nibName: "SlideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SlideMenuTableViewCell")
        
//        self.mainView.backgroundColor = UIColor.clear
        self.slidemenuTableView.backgroundColor = UIColor.clear
        
//        self.slideMenu()
//        self.profileName()
        slidemenuTableView.reloadData()
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        headerView.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.sideMenuViewController.setContentViewController(UIStoryboard.profileStoryboard().instantiateViewController(withIdentifier: "ProfileVC"), animated: true)
        self.sideMenuViewController.hideViewController()
    }
    
    
    
    @IBAction func profileBtn(_ sender: UIButton) {
        self.sideMenuViewController.hideViewController()

        let vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.profileVC)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {

    }

    
    private func alert() {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to Logout?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {
            action in
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { action in
            
            UserManager.shared.deleteActiveUser()
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension MenuViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuItemsArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlideMenuTableViewCell", for: indexPath) as! SlideMenuTableViewCell
        
        cell.labelMenu.text = menuItemsArr[indexPath.row]
        
        if menuItemsArr[indexPath.row] == "Messages"{
//            cell.labelCount.isHidden = true
//            cell.labelCount.layer.cornerRadius = cell.labelCount.frame.height/2
//            cell.labelCount.layer.masksToBounds = false
//            cell.labelCount.clipsToBounds = true
//            cell.trailingLabelCount.constant = 60.0
        }else{
//            cell.labelCount.isHidden = true
        }
        let menuIcon = menuImgArr[indexPath.row]
        cell.imgMenu.image = UIImage.init(named: menuIcon)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        if selectedIndex == indexPath.row{
            cell.labelMenu.textColor = UIColor.white
            cell.imgMenu.tintColor = UIColor.white
        }else{
            cell.labelMenu.textColor = UIColor.white
            cell.imgMenu.tintColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.row
        self.slidemenuTableView.reloadData()
        self.userModule()
        
    }
    
    func userModule() {
        switch selectedIndex {
        case 0:
            vc = Utilities.sharedInstance.appointmentController(identifier: Constants.StoryboardIdentifier.yourOrdersVC)
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.settingsVC)
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            break
        case 3:
            vc = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.mapVC)
            self.sideMenuViewController.setContentViewController(vc, animated: true)
            self.alert()
        default : break
        }
        
        self.sideMenuViewController.hideViewController()
    }
}

