//
//  OtpAuthenticateViewModel.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 10/11/21.
//

import Foundation

protocol OtpAuthDelegate {
    func otpAuthenticateSuccessful(message: String)
    func resendOtpSuccessful(message: String)
    func failure(message : String)
}

struct OtpAuthenticationRequest: Codable {
    let user : String
    let otp  : String
}

struct ResendOtpRequest: Codable {
    let user : String
}

class OtpAuthenticateViewModel {
    
    var delegate: OtpAuthDelegate!
    
    func OtpAuthenticate(info: OtpAuthenticationRequest) {

        LoginServiceHelper.request(router: SignupServiceManager.otpAuthenticate(info), completion: { (result : Result<CommonUpdateResponse, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data) : self.delegate.otpAuthenticateSuccessful(message: data.message ?? "")
                case .failure(let error): self.delegate.failure(message: "\(error)")
                }
            }
        })
    }
    
    func resendOTP(info: ResendOtpRequest) {

        LoginServiceHelper.request(router: SignupServiceManager.resendOTP(info), completion: { (result : Result<CommonUpdateResponse, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data) : self.delegate.resendOtpSuccessful(message: data.message ?? "")
                case .failure(let error): self.delegate.failure(message: "\(error)")
                }
            }
        })
    }
}
