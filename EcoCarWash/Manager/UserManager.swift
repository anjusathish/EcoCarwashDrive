//
//  UserManager.swift
//  Kinder Care
//
//  Created by CIPL0681 on 06/12/19.
//  Copyright © 2019 Athiban Ragunathan. All rights reserved.
//


import Foundation
import GoogleMaps
import JWTDecode

class UserManager: NSObject {
    
    private var _currentUser: LoginInfo?

    var currentUser : LoginInfo? {
        get {
            return _currentUser
        }
        set {
            _currentUser = newValue
            
            if let _ = _currentUser {
                saveUser()
            }
        }
    }

    class var shared: UserManager {
        struct Singleton {
            static let instance = UserManager()
        }
        return Singleton.instance
    }
    
    private struct SerializationKeys {
        static let activeUser = "activeUser"
    }
    
    private override init () {
        super.init()
        
        // Load last logged user data if exists
        if isLoggedInUser() {
            getUser()
        }
    }
    
    func isLoggedInUser() -> Bool {
        guard let _ = UserDefaults.standard.object(forKey: SerializationKeys.activeUser)  else {
            return false
        }
        return true
    }
    
    func saveUser() {
        if let user = _currentUser {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(user) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: SerializationKeys.activeUser)
            }
        }
    }

    func getUser() {
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: SerializationKeys.activeUser) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginInfo.self, from: savedPerson) {
                currentUser = loadedPerson
            }
        }
    }
    
    func deleteActiveUser() {
        // remove active user from storage
        UserDefaults.removeObjectForKey(SerializationKeys.activeUser)
        // free user object memory
        currentUser = nil
        
        let viewController = Utilities.sharedInstance.loginSprintController(identifier: Constants.StoryboardIdentifier.loginVC)
        let navController = UINavigationController(rootViewController: viewController)
        navController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navController
    }
    
    open func googleMapStyle(mapView: GMSMapView) {
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }

    open func loggedUserDetails() ->  LoggedUserDTO {
        var jwtData = LoggedUserDTO(exp: 0, iat: 0, uuid: "", email: "", username: "", userType: 0)
        if let token = UserManager.shared.currentUser?.accessToken {
            if let jwtDict = try? decode(jwt: token).body  {
                do {
                    let json = try JSONSerialization.data(withJSONObject: jwtDict)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    jwtData = try decoder.decode(LoggedUserDTO.self, from: json)
                } catch {
                    print(error)
                }
            }
        }
        return jwtData
    }
}
