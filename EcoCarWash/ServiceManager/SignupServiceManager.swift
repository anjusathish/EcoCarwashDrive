//
//  SignupServiceManager.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 02/11/21.
//

import Foundation

enum SignupServiceManager {
    
    case login(email: String, password: String)
    case carType
    case carMake(carTypeID: String)
    case carModel(carMakeID: String)
    case register(_ info: RegisterRequest)
    case otpAuthenticate(_ info: OtpAuthenticationRequest)
    case resendOTP(_ info: ResendOtpRequest)

    var scheme: String {
        switch self {
        case .login    : return API.scheme
        case .carType  : return API.scheme
        case .carMake  : return API.scheme
        case .carModel : return API.scheme
        case .register : return API.scheme
        case .otpAuthenticate(_):  return API.scheme
        case .resendOTP(_):  return API.scheme
        }
    }
    
    var host: String {
        switch self {
        case .login    : return API.baseURL
        case .carType  : return API.baseURL
        case .carMake  : return API.baseURL
        case .carModel : return API.baseURL
        case .register : return API.baseURL
        case .otpAuthenticate(_): return API.baseURL
        case .resendOTP(_): return API.baseURL
        }
    }
    
    var port:Int{
        switch self {
        case .login    : return API.port
        case .carType  : return API.port
        case .carMake  : return API.port
        case .carModel : return API.port
        case .register : return API.port
        case .otpAuthenticate(_): return API.port
        case .resendOTP(_): return API.port
        }
    }
    
    var path: String {
        switch self {
        case .login    :  return API.auth + "login/"
        case .carType  :  return API.path + "list_car_types"
        case .carMake  :  return API.path + "list_car_make"
        case .carModel :  return API.path + "list_car_model"
        case .register :  return API.auth + "register/"
        case .otpAuthenticate(_): return API.auth + "OTP_authenticate/"
        case .resendOTP(_): return API.auth + "OTP_resend/"
        }
    }
    
    var method: String {
        switch self {
        case .login   : return "POST"
        case .carType : return "GET"
        case .carMake : return "GET"
        case .carModel: return "GET"
        case .register: return "POST"
        case .otpAuthenticate(_): return "POST"
        case .resendOTP(_): return "POST"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .login   : return nil
        case .carType : return nil
        case .carMake(let carTypeID)  : return [URLQueryItem(name: "car_type", value: carTypeID)]
        case .carModel(let carMakeID) : return [URLQueryItem(name: "car_make", value: carMakeID)]
        case .register(_): return nil
        case .otpAuthenticate(_): return nil
        case .resendOTP(_): return nil
        }
    }
    
    var headerFields: [String : String] {
        switch self {
        case .login   : return [:]
        case .carType : return [:]
        case .carMake : return [:]
        case .carModel: return [:]
        case .register: return [:]
        case .otpAuthenticate(_): return [:]
        case .resendOTP(_): return [:]
        }
    }
    
    var body: Data? {
        switch self {
        case .login    : return nil
        case .carType  : return nil
        case .carMake  : return nil
        case .carModel : return nil
        case .register(let request):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        case .otpAuthenticate( let request):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        case .resendOTP( let request):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        }
    }
    
    var formDataParameters : [String : Any]? {
        
        switch self {
            
        case .login(let email, let password) :
            
            let parameters: [String : Any] = ["email"    : email,
                                              "password" : password]
            return parameters
        case .carType : return nil
        case .carMake : return nil
        case .carModel: return nil
        case .register: return nil
        case .otpAuthenticate(_):  return nil
        case .resendOTP(_):  return nil
        }
    }
}
