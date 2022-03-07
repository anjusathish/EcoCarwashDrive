//
//  AppointmentManager.swift
//  Eco carwash Drive
//
//  Created by Indium Software on 10/12/21.
//

import UIKit

class AppointmentManager: NSObject  {
    
    private var _serviceDetails: [Service]?
    private var _storeInfo: Store?
    private var _appointmentInfo: [BookedAppointment]?

    var service : [Service]? {
        get
        {
            return _serviceDetails
        }
        set
        {
            _serviceDetails = newValue
            
            if let _ = _serviceDetails {
                saveService()
            }
        }
    }
    
    var store : Store? {
        get
        {
            return _storeInfo
        }
        set
        {
            _storeInfo = newValue
            
            if let _ = _storeInfo {
                saveStore()
            }
        }
    }

    var appointment : [BookedAppointment]? {
        get
        {
            return _appointmentInfo
        }
        set
        {
            _appointmentInfo = newValue
            
            if let _ = _appointmentInfo {
                saveAppointment()
            }
        }
    }
    class var shared: AppointmentManager {
        struct Singleton {
            static let instance = AppointmentManager()
        }
        return Singleton.instance
    }
    
    private struct SerializationKeys {
        static let services = "services"
        static let store = "store"
        static let appointment = "appointment"
    }
    
    private override init () {
        super.init()
        
        if UserManager.shared.isLoggedInUser() {
            getService()
            getStore()
            getAppointment()
        }
    }

    // MARK: - Service data get and save
    func getService() {
        let defaults = UserDefaults.standard
        if let savedService = defaults.object(forKey: SerializationKeys.services) as? Data {
            let decoder = JSONDecoder()
            if let loadData = try? decoder.decode([Service].self, from: savedService) {
                service = loadData
            }
        }
    }

    func saveService() {
        if let user = _serviceDetails {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(user) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: SerializationKeys.services)
            }
        }
    }

    // MARK: - Store data get and save
    func getStore() {
        let defaults = UserDefaults.standard
        if let savedStore = defaults.object(forKey: SerializationKeys.store) as? Data {
            let decoder = JSONDecoder()
            if let storeData = try? decoder.decode(Store.self, from: savedStore) {
                store = storeData
            }
        }
    }

    func saveStore() {
        if let user = _serviceDetails {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(user) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: SerializationKeys.store)
            }
        }
    }
    
    // MARK: - APpointment data get and save
    func getAppointment() {
        let defaults = UserDefaults.standard
        if let appointmentData = defaults.object(forKey: SerializationKeys.appointment) as? Data {
            let decoder = JSONDecoder()
            if let appointmentData = try? decoder.decode([BookedAppointment].self, from: appointmentData) {
                appointment = appointmentData
            }
        }
    }

    func saveAppointment() {
        if let user = _appointmentInfo {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(user) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: SerializationKeys.appointment)
            }
        }
    }

    func removeService() {
        UserDefaults.removeObjectForKey(SerializationKeys.services)
        service = nil
    }
    
    func removeStore() {
        UserDefaults.removeObjectForKey(SerializationKeys.store)
        store = nil
    }
    
    func removeAppointment() {
        UserDefaults.removeObjectForKey(SerializationKeys.appointment)
        store = nil
    }
}
