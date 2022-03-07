//
//  LoginResposne.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 08/11/21.
//

import Foundation

// MARK: - UserDetails
struct UserDetails: Codable {
        let version: String?
        let statusCode: Int?
        let message: String?
        let data: LoginInfo?
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
    struct LoginInfo: Codable {
        let accessToken, refreshToken, uuid, name: String?
        let email: String?
        let profileImage: String?
        let mobileNo: String?
        let userType: Int?
        let dateJoined: String?
        var lastLogin: String?
        var isMobileVerified: Bool?
        let userCars: [UserCarDetails]?

        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case refreshToken = "refresh_token"
            case uuid, name, email
            case profileImage = "profile_image"
            case mobileNo = "mobile_no"
            case userType = "user_type"
            case dateJoined = "date_joined"
            case lastLogin = "last_login"
            case isMobileVerified = "is_mobile_verified"
            case userCars = "user_cars"
        }
    }

    // MARK: - UserCar
    struct UserCarDetails: Codable {
        let id: Int?
        let carName, user, status, createdOn: String?
        let carModel: String?
        let carTypeID: Int?
        let carType: String?
        let carMakeID: Int?
        let carMake: String?
        let carModelID: Int?

        enum CodingKeys: String, CodingKey {
            case id
            case carName = "car_name"
            case user, status
            case createdOn = "created_on"
            case carModel = "car_model"
            case carTypeID = "car_type_id"
            case carType = "car_type"
            case carMakeID = "car_make_id"
            case carMake = "car_make"
            case carModelID = "car_model_id"
        }
    }

// MARK: - UserProfileResponse
struct UserProfileResponse: Codable {
    let version: String?
    let statusCode: Int?
    let status: Bool?
    let message: String?
    let data: ProfileData?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case status = "Status"
        case data = "Data"
        case message = "Message"
    }
}

// MARK: - DataClass
struct ProfileData: Codable {
    let uuid, name, username, email: String?
    let profileImage: String?
    let mobileNo: String?
    let isMobileVerified: Bool?

    enum CodingKeys: String, CodingKey {
        case uuid, name, username, email
        case profileImage = "profile_image"
        case mobileNo = "mobile_no"
        case isMobileVerified = "is_mobile_verified"
    }
}

struct LoggedUserDTO: Codable {
    let exp      : Int
    let iat      : Int
    let uuid     : String
    let email    : String
    let username : String
    let userType : Int
}
