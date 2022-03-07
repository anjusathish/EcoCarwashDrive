//
//  UserSettingServiceManager.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 12/11/21.
//

import Foundation

enum UserSettingServiceManager {
    
    case manageUserCars
    case managerAddress
    case updateUserCars(_info: CarRequest, id: Int)
    case updateAddress(_info: UserAddressRequest, id: Int)
    case addAddress(_info: UserAddressRequest)
    case deleteAddress(id: Int)

    var scheme: String {
        switch self {
        case .manageUserCars : return API.scheme
        case .managerAddress : return API.scheme
        case .updateUserCars : return API.scheme
        case .updateAddress  : return API.scheme
        case .addAddress     : return API.scheme
        case .deleteAddress  : return API.scheme
        }
    }
    
    var host: String {
        switch self {
        case .manageUserCars : return API.baseURL
        case .managerAddress : return API.baseURL
        case .updateUserCars : return API.baseURL
        case .updateAddress  : return API.baseURL
        case .addAddress     : return API.baseURL
        case .deleteAddress  : return API.baseURL
        }
    }
    
    var port:Int{
        switch self {
        case .manageUserCars : return API.port
        case .managerAddress : return API.port
        case .updateUserCars : return API.port
        case .updateAddress  : return API.port
        case .addAddress     : return API.port
        case .deleteAddress  : return API.port
        }
    }
    
    var path: String {
        switch self {
        case .manageUserCars : return API.path + "manage_user_cars/"
        case .managerAddress : return API.path + "manage_address/"
        case .updateUserCars(_, let id) : return API.path + "manage_user_cars/\(id)/"
        case .updateAddress(_, let id) : return API.path + "manage_address/\(id)/"
        case .addAddress : return API.path + "manage_address/"
        case .deleteAddress(let id) : return API.path + "manage_address/\(id)/"
        }
    }
    
    var method: String {
        switch self {
        case .manageUserCars : return "GET"
        case .managerAddress : return "GET"
        case .updateUserCars : return "PATCH"
        case .updateAddress  : return "PATCH"
        case .addAddress     : return "POST"
        case .deleteAddress  : return "DELETE"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .manageUserCars : return nil
        case .managerAddress : return nil
        case .updateUserCars : return nil
        case .updateAddress  : return nil
        case .addAddress     : return nil
        case .deleteAddress  : return nil
        }
    }
    
    var headerFields: [String : String]
    {
        switch self {
        case .manageUserCars : return [:]
        case .managerAddress : return [:]
        case .updateUserCars : return [:]
        case .updateAddress  : return [:]
        case .addAddress     : return [:]
        case .deleteAddress  : return [:]
        }
    }
    
    var body: Data? {
        switch self {
        case .manageUserCars : return nil
        case .managerAddress : return nil
        case .updateUserCars(let request, _):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        case .updateAddress(let request, _):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        case .addAddress(let request):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        case .deleteAddress : return nil
        }
    }
}
