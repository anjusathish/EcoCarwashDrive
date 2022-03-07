//
//  RegisterUserResponse.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 09/11/21.
//

import Foundation

// MARK: - RegisterUserResponse
struct RegisterUserResponse: Codable {
    let version: String?
    let statusCode: Int?
    let message: String?
    let status: Bool?
    let data: UserRegisterData?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case message = "Message"
        case status = "Status"
        case data = "Data"
    }
}

// MARK: - DataClass
struct UserRegisterData: Codable {
    let uuid, name, username, email: String?
    let password, profileImage, mobileNo: String?
    let groups: [Int]?
    let userType: Int?
    let userCars: [UserCar]?

    enum CodingKeys: String, CodingKey {
        case uuid, name, username, email, password
        case profileImage = "profile_image"
        case mobileNo = "mobile_no"
        case groups
        case userType = "user_type"
        case userCars = "user_cars"
    }
}

// MARK: - UserCar
struct UserCar: Codable {
    let carModel: Int?

    enum CodingKeys: String, CodingKey {
        case carModel = "car_model"
    }
}

// MARK: - OtpAuthResponse
struct CommonUpdateResponse: Codable {
    let version: String?
    let statusCode: Int?
    let message: String?
    let status: Bool?
    let data: OtpAuthData?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case message = "Message"
        case status = "Status"
        case data = "Data"
    }
}

// MARK: - DataClass
struct OtpAuthData: Codable {
}
