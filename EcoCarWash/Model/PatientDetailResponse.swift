//
//  PatientDetailResponse.swift
//  EcoCarWash
//
//  Created by Indium Software on 09/09/21.
//

import Foundation

// MARK: - PatientDetailsModel
struct PatientDetailResponse: Codable {
    let status: Bool?
    let errorID: Int?
    let patient: Patient?
    
    enum CodingKeys: String, CodingKey {
        case status
        case errorID = "errorId"
        case patient
    }
}

// MARK: - Patient
struct Patient: Codable {
    let id, name, fname, lname: String?
    let note, bdProviderID, bdProviderName, rdProviderID: String?
    let rdProviderName, gender, dob, countryCode: String?
    let hospital, hospitalID, wardName, picURL: String?
    let joiningTime, dischargeTime, acceptTime, inviteTime: String?
    let lastMessageTime, docBoxPatientID, docBoxManagerID, score: String?
    let qSofaScore, gcsScore: Int?
    let eyeResponse, verbalResponse, motorResponse: String?
    let oxygenSupplement: Bool?
    let patientCondition: String?
    let urgent: Bool?
    let dischargeMessage, recordNumber, covidPositive, teamID: String?
    let teamName, syncTime, completedBy, time: String?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, fname, lname, note
        case bdProviderID = "bdProviderId"
        case bdProviderName
        case rdProviderID = "rdProviderId"
        case rdProviderName, gender, dob, countryCode, hospital
        case hospitalID = "hospitalId"
        case wardName
        case picURL = "picUrl"
        case joiningTime, dischargeTime, acceptTime, inviteTime, lastMessageTime
        case docBoxPatientID = "docBoxPatientId"
        case docBoxManagerID = "docBoxManagerId"
        case score, qSofaScore, gcsScore, eyeResponse, verbalResponse, motorResponse, oxygenSupplement, patientCondition, urgent, dischargeMessage, recordNumber, covidPositive
        case teamID = "teamId"
        case teamName, syncTime
        case completedBy = "completed_by"
        case time, status
    }
}


// MARK: - UserCarsResponse
struct UserCarsResponse: Codable {
    let version: String?
    let statusCode: Int?
    let status: Bool?
    let data: [CarData]?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case status = "Status"
        case data = "Data"
    }
}

// MARK: - Datum
struct CarData: Codable {
    let id: Int?
    let carName, status, createdOn, updatedOn: String?
    let user, carModel, carType, carMake: String?

    enum CodingKeys: String, CodingKey {
        case id
        case carName = "car_name"
        case status
        case createdOn = "created_on"
        case updatedOn = "updated_on"
        case user
        case carModel = "car_model"
        case carType = "car_type"
        case carMake = "car_make"
    }
}

// MARK: - UserAddressResponse
struct GetUserAddressResponse: Codable {
    let version: String?
    let statusCode: Int?
    let status: Bool?
    let data: [AddressData]?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case status = "Status"
        case data = "Data"
    }
}

// MARK: - Datum
struct AddressData: Codable {
    let id: Int?
    let address: Address?
    let locationName, createdOn, updatedOn, user: String?

    enum CodingKeys: String, CodingKey {
        case id, address
        case locationName = "location_name"
        case createdOn = "created_on"
        case updatedOn = "updated_on"
        case user
    }
}

// MARK: - Address
struct Address: Codable {
    let id: Int?
    let houseNo, street: String?
    let landmark: String?
    let address , status: String?
    let latitude, longitude: Double?
    let createdOn, updatedOn: String?

    enum CodingKeys: String, CodingKey {
        case id
        case houseNo = "house_no"
        case street, landmark, address, latitude, longitude, status
        case createdOn = "created_on"
        case updatedOn = "updated_on"
    }
}

// MARK: - AddedUserAddressResponse
struct AddedUserAddressResponse: Codable {
    let version: String?
    let statusCode: Int?
    let message: String?
    let data: UserAddress?
    let status: Bool?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case message = "Message"
        case data = "Data"
        case status = "Status"
    }
}

// MARK: - DataClass
struct UserAddress: Codable {
    let id: Int?
    let address: Address?
    let locationName, user, createdOn: String?

    enum CodingKeys: String, CodingKey {
        case id, address
        case locationName = "location_name"
        case user
        case createdOn = "created_on"
    }
}
