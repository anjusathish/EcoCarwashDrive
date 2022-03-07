//
//  AppointmentServiceManager.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 29/11/21.
//

import Foundation

enum AppointmentServiceManager {
    
    case listStores(distance: String, latitude: String, longitude: String)
    case listService(carType: Int, storeId: Int)
    case bookedSlotList(date: String, storeId: String)
    case listCoupons
    case bookAppointment(_info: BookAppointmentRequest)
    case ListAppointment(status: String)
    case getAppointment(appointmentId: String)
    case deleteAppointment(appointmentId: String)
    case appointmentRating(_info: RatingRequest)
    case getRatingList(isRating: Bool)

    var scheme: String {
        switch self {
        case .listStores, .listService, .bookedSlotList, .listCoupons, .bookAppointment, .ListAppointment, .deleteAppointment, .getAppointment, .appointmentRating, .getRatingList : return API.scheme
        }
    }
    
    var host: String {
        switch self {
        case .listStores, .listService, .bookedSlotList, .listCoupons, .bookAppointment, .ListAppointment, .deleteAppointment, .getAppointment, .appointmentRating, .getRatingList : return API.baseURL
        }
    }
    
    var port:Int{
        switch self {
        case .listStores, .listService, .bookedSlotList, .listCoupons, .bookAppointment, .ListAppointment, .deleteAppointment, .getAppointment, .appointmentRating, .getRatingList : return API.port
        }
    }
    
    var path: String {
        switch self {
        case .listStores:  return API.path + "list_stores/"
        case .listService: return API.path + "list_services/"
        case .bookedSlotList: return API.path + "list_booked_slots/"
        case .listCoupons: return API.path + "list_coupons/"
        case .bookAppointment, .ListAppointment : return API.path + "manage_appointments/"
        case .getAppointment(let id), .deleteAppointment(let id) : return API.path + "manage_appointments/" + id + "/"
        case .appointmentRating, .getRatingList : return API.path + "manage_rating/"
        }
    }
    
    var method: String {
        switch self {
        case .listStores, .listService, .bookedSlotList, .listCoupons, .ListAppointment, .getAppointment, .getRatingList : return "GET"
        case .bookAppointment, .appointmentRating : return "POST"
        case .deleteAppointment : return "DELETE"
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .listStores(let distance, let latitude, let longitude) : return [URLQueryItem(name: "distance", value: distance), URLQueryItem(name: "latitude", value: latitude), URLQueryItem(name: "longitude", value: longitude)]
        
        case .listService(let carType, let storeId) : return [URLQueryItem(name: "car_type", value: "\(carType)"), URLQueryItem(name: "store_id", value: "\(storeId)")]
       
        case .bookedSlotList(let date, let storeId) : return [URLQueryItem(name: "date", value: date), URLQueryItem(name: "store_id", value: storeId)]
      
        case .getRatingList(let isRating) : return [URLQueryItem(name: "user_ratings", value: "\(isRating)".lowercased())]

        case .ListAppointment(let status): return [URLQueryItem(name: "status", value: status)]
            
        case .listCoupons, .bookAppointment, .deleteAppointment, .getAppointment, .appointmentRating : return nil
        }
    }
    
    var headerFields: [String : String]
    {
        switch self {
        case .listStores, .listService, .bookedSlotList, .listCoupons, .bookAppointment, .ListAppointment, .deleteAppointment, .getAppointment, .appointmentRating, .getRatingList : return [:]
        }
    }
    
    var body: Data? {
        switch self {
        case .listStores, .listService, .bookedSlotList, .listCoupons, .ListAppointment, .deleteAppointment, .getAppointment, .getRatingList : return nil
        case .bookAppointment(let request):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)
        case .appointmentRating(let request):
            print(request)
            let encoder = JSONEncoder()
            return try? encoder.encode(request)

        }
    }
    
    var formDataParameters : [String : Any]? {
        
        switch self {
        case .listStores, .listService, .bookedSlotList, .listCoupons, .bookAppointment, .ListAppointment, .deleteAppointment, .getAppointment, .appointmentRating, .getRatingList : return nil
        }
    }
}
