//
//  RegisterViewModel.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 09/11/21.
//

import Foundation

protocol RegisterDelegate {
    func registerSuccessful(data: RegisterUserResponse)
    func failure(message : String)
}

struct RegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
    let user_cars: String
    let profile_image: String
    let username: String
    let mobile_no: String
}

class RegisterViewModel {
    
    var delegate: RegisterDelegate!
    
    func registerUser(info: RegisterRequest) {

        LoginServiceHelper.request(router: SignupServiceManager.register(info), completion: { (result : Result<RegisterUserResponse, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data) :
                    
                        if data.status == true {
                            self.delegate.registerSuccessful(data: data)
                        } else {
                            self.delegate.failure(message: "validation failure")
                        }

                case .failure(let error):
                    
                    self.delegate.failure(message: "\(error)")
                }
            }
        })
    }
}
