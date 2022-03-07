//
//  UserCarViewModel.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 12/11/21.
//

import Foundation

protocol UserSettingsDelegate {
    func getCarsSuccessful(carData: [CarData])
    func getAddressSuccessful(address: [AddressData])
    func updateSuccessful(message: String)
    func deleteSuccessful(message: String)
    func failure(message: String)
}

struct CarRequest : Codable {
    let status    : String
    let car_name  : String
    let car_model : Int
}

struct UserAddressRequest : Codable {
    let house_no   : String
    let street    : String
    let landmark  : String
    let address   : String
    let latitude  : Double
    let longitude : Double
    let location_name : String
}

class UserSettingsViewModel {
    
    var delegate: UserSettingsDelegate!
    
    func getUserCar() {
        
        UserSettingServiceHelper.request(router: UserSettingServiceManager.manageUserCars, completion: { (result : Result<UserCarsResponse, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  : self.delegate.getCarsSuccessful(carData: data.data ?? [])
                    
                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }
    
    func getUserAddress() {

        UserSettingServiceHelper.request(router: UserSettingServiceManager.managerAddress, completion: { (result : Result<GetUserAddressResponse, CustomError>) in
            DispatchQueue.main.async {
                switch result {

                case .success(let data)  : self.delegate.getAddressSuccessful(address: data.data ?? [])

                case .failure(let error) : self.delegate.failure(message: "\(error)")

                }
            }
        })
    }
    
    func updateCar(info: CarRequest, id: Int) {
        
        UserSettingServiceHelper.request(router: UserSettingServiceManager.updateUserCars(_info: info, id: id), completion: { (result : Result<CommonUpdateResponse, CustomError>) in
            DispatchQueue.main.async {
                switch result {

                case .success(let data)  : self.delegate.updateSuccessful(message: data.message ?? "")

                case .failure(let error) : self.delegate.failure(message: "\(error)")

                }
            }
        })
    }
    
    func updateAddress(info: UserAddressRequest, id: Int) {
        
        UserSettingServiceHelper.request(router: UserSettingServiceManager.updateAddress(_info: info, id: id), completion: { (result : Result<GetUserAddressResponse, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  : self.delegate.getAddressSuccessful(address: data.data ?? [])
                    
                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }
    
    func addAddress(info: UserAddressRequest) {
        
        UserSettingServiceHelper.request(router: UserSettingServiceManager.addAddress(_info: info), completion: { (result : Result<AddedUserAddressResponse, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  : self.delegate.updateSuccessful(message: data.message ?? "")

                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }

    func deleteAddress(id: Int) {
        
        UserSettingServiceHelper.request(router: UserSettingServiceManager.deleteAddress(id: id), completion: { (result : Result<CommonUpdateResponse, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  : self.delegate.deleteSuccessful(message: data.message ?? "")
                    
                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }
}
