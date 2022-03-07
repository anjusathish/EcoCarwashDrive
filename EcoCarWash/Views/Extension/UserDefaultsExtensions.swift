//
//  UserDefaultsExtensions.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 20/10/21.
//

import Foundation

extension UserDefaults {
    
    func isUserLoggedIn() -> Bool {
        guard let _ = UserDefaults.standard.object(forKey: "IS_LOGGEDIN") else {
            return false
        }
        return true
    }
    
    func userPassword() -> String {
        if let password: String = UserDefaults.standard.string(forKey: Constants.UserdefaultKey.password) {
            return password
        } else {
            return ""
        }
    }
    
    // MARK: - RemoveObjects 
    class func removeObjectForKey(_ defaultName: String) {
        UserDefaults.standard.removeObject(forKey: defaultName)
        UserDefaults.standard.synchronize()
    }
}

extension UINavigationController {
    func getViewController<T: UIViewController>(of type: T.Type) -> UIViewController? {
        return self.viewControllers.first(where: { $0 is T })
    }

    func popToViewController<T: UIViewController>(of type: T.Type, animated: Bool) {
        guard let viewController = self.getViewController(of: type) else { return }
        self.popToViewController(viewController, animated: animated)
    }
}
