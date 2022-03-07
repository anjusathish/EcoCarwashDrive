//
//  PatientDetailViewModel.swift
//  EcoCarWash
//
//  Created by Indium Software on 09/09/21.
//

import UIKit

enum AttendanceType : Int {
    case absent = 4
    case present = 3
    case signin = 1
    case signout = 2
}

protocol PatientDetailDelegate {
    func getPatientDetailSuccess(attendanceList : Patient)
    func failure(message : String)
}

class PatientDetailViewModel {
    
    var delegate: PatientDetailDelegate!
    
    func attendanceList(patientId: String){
        
        PatientDetailServiceHelper.request(router: PatientDetailServiceManager.patientDetails(patientId: patientId), completion: { (result : Result<PatientDetailResponse, CustomError>) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let data) :
                    if let _data = data.patient {
                        self.delegate.getPatientDetailSuccess(attendanceList: _data)
                    }
                case .failure(let error):
                    self.delegate.failure(message: "\(error)")
                }
            }
            
        })
    }
}
