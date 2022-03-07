//
//  UserProfileViewModel.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 11/11/21.
//

import Foundation
import UIKit

protocol UserProfileDelegate {
    func userProfileDetails(data: UserProfileResponse)
    func updateProfileSuccessful(message: String)
    func failure(message: String)
}

struct ProfileRequest: Codable {
    let name: String
    let username: String
    let email: String
//    let profile_image: String
    let mobile_no: String
    let old_password: String
    let new_password: String
}

class UserProfileViewModel {
    
    var delegate: UserProfileDelegate!
    
    func getUserProfile() {
        
        UserProfileServiceHelper.request(router: UserProfileServiceManager.getProfileData, completion: { (result : Result<UserProfileResponse, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  : self.delegate.userProfileDetails(data: data)
                    
                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }
    
    func updateUserProfile(name: String, username: String, email: String, profile_image: String, mobile_no: String ,old_password: String, new_password: String, uuid: String) {
        UserProfileServiceHelper.requestFormData(router: UserProfileServiceManager.updateprofileData(name: name, username: username, email: email, profile_image: profile_image, mobile_no: mobile_no, old_password: old_password, new_password: new_password, uuid: uuid), completion: { (result : Result<UserProfileResponse, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  : self.delegate.userProfileDetails(data: data)

                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }
}
