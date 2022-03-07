//
//  SelectCarViewModel.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 08/11/21.
//

import Foundation

protocol SelectCarDelegate {
    func carTypeList(typeList: CarTypeModel)
    func carMakeList(makeList: CarMakeModel)
    func carModelList(modelList: CarModel)
    func failure(message : String)
}

class SelectCarViewModel {
    
    var delegate: SelectCarDelegate!
    
    func selectCarType() {
        
        SelectCarServiceHelper.request(router: SignupServiceManager.carType, completion: { (result : Result<CarTypeModel, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  : self.delegate.carTypeList(typeList: data)
                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }
    
    func selectCarMake(carTypeID: String) {
        
        SelectCarServiceHelper.request(router: SignupServiceManager.carMake(carTypeID: carTypeID), completion: { (result : Result<CarMakeModel, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  : self.delegate.carMakeList(makeList: data)
                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }

    func selectCarModel(carMakeID: String) {
        
        SelectCarServiceHelper.request(router: SignupServiceManager.carModel(carMakeID: carMakeID), completion: { (result : Result<CarModel, CustomError>) in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data)  : self.delegate.carModelList(modelList: data)
                case .failure(let error) : self.delegate.failure(message: "\(error)")
                    
                }
            }
        })
    }
}
