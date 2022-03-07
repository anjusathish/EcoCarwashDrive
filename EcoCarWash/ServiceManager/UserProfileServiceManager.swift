//
//  UserProfileServiceManager.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 11/11/21.
//

import UIKit

enum UserProfileServiceManager {
    
    case getProfileData
    case updateprofileData(name: String, username: String, email: String, profile_image: String, mobile_no: String ,old_password: String, new_password: String, uuid: String)
    
    var scheme: String {
        switch self {
        case .getProfileData  : return API.scheme
        case .updateprofileData: return API.scheme
        }
    }
    
    var host: String {
        switch self {
        case .getProfileData : return API.baseURL
        case .updateprofileData :return API.baseURL
        }
    }
    
    var port:Int{
        switch self {
        case .getProfileData : return API.port
        case .updateprofileData :return API.port
        }
    }
    var path: String {
        switch self {
        case .getProfileData:  return API.path + "manage_profile/"
        case .updateprofileData(_, _, _, _, _, _, _, let uuid): return API.path + "manage_profile/" + uuid + "/"
        }
    }
    
    var method: String {
        switch self {
        case .getProfileData : return "GET"
        case .updateprofileData : return "PATCH"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .getProfileData  : return nil
        case .updateprofileData : return nil
        }
    }
    
    var headerFields: [String : String]
    {
        switch self {
        case .getProfileData : return [:]
        case .updateprofileData : return [:]
        }
    }
    
    var body: Data? {
        switch self {
        case .getProfileData: return nil
        case .updateprofileData : return nil
        }
    }
    
    var formDataParameters : [String : Any]? {
        
        switch self {
        case .getProfileData: return nil
        case .updateprofileData(let name, let username, let email, let profile_image, let mobile_no ,let old_password,let new_password, _):
            
            let parameters: [String : Any] = [ "name": name,
                                               "username": username,
                                               "email": email,
                                               "profile_image": profile_image,
                                               "mobile_no": mobile_no,
                                               "old_password": old_password,
                                               "new_password": new_password
                                             ].filter({ $0.value as? String != ""})
            return parameters
        }
    }
}

