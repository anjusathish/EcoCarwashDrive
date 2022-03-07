//
//  PatientDetailServiceManager.swift
//  EcoCarWash
//
//  Created by Indium Software on 09/09/21.
//

import Foundation

enum PatientDetailServiceManager {
    
    case patientDetails(patientId: String)
    case sendChatMessage(_ info: ChatMessageRequest, provId: String, token: String)
    
    var scheme: String {
        switch self {
        case .patientDetails(_), .sendChatMessage  : return API.scheme
        }
    }
    
    var host: String {
        switch self {
        case .patientDetails, .sendChatMessage : return API.baseURL
        }
    }
    
    var port:Int{
        switch self {
        case .patientDetails, .sendChatMessage : return API.port
        }
    }
    var path: String {
        switch self {
        case .patientDetails(let patId):
            return API.auth + "patientEndpoints/v1/patientdetailsresponse/" + patId
        case .sendChatMessage(_, let provId, let token):
            return API.auth + "providerEndpoints/v1/sendChatMessage/" + provId + "/\(token)"
        }
    }
    
    var method: String {
        switch self {
        case .patientDetails : return "GET"
        case .sendChatMessage: return "POST"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .patientDetails  : return nil
        case .sendChatMessage : return nil
        }
    }
    
    var headerFields: [String : String]
    {
        switch self {
        case .patientDetails, .sendChatMessage : return ["API_VERSION" : "1.0", "DEVICE_TYPE" : "iOS"]
        }
    }
    
    var body: Data? {
        switch self {
        case .patientDetails: return nil
        case .sendChatMessage(let request,_,_):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        }
    }
}
