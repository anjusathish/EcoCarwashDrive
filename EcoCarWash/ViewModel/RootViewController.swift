//
//  RootViewController.swift
//  Kinder Care
//
//  Created by CIPL0681 on 11/11/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//

import UIKit
import RESideMenu

class RootViewController: RESideMenu {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func awakeFromNib() {
    
//    if  let userType = UserManager.shared.currentUser?.userType {
//      if let _type = UserType(rawValue:userType ) {
//        
//        if  _type.rawValue == 5 {
//          self.contentViewController = UIStoryboard.dashboardStoryboard().instantiateViewController(withIdentifier: "DashboardVC")
//        }
//          
//        else{
//          self.contentViewController = UIStoryboard.commonDashboardStoryboard().instantiateViewController(withIdentifier: "CommonDashboardVC")
//        }
//      }
//    }
    
    self.contentViewController = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.mapVC)
    self.leftMenuViewController = Utilities.sharedInstance.dashboardController(identifier: Constants.StoryboardIdentifier.leftMenuVC)
    
//    backgroundImage = UIImage(named: "BG")
    
  }
}
