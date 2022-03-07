//
//  SelectCarModel.swift
//  Eco Car Wash Service
//
//  Created by Indium Software on 08/11/21.
//

import Foundation


// MARK: - CarTypeModel
struct CarTypeModel: Codable {
    let version: String?
    let statusCode: Int?
    let status: Bool?
    let data: [TypeData]?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case status = "Status"
        case data = "Data"
    }
}

// MARK: - Datum
struct TypeData: Codable {
    let id: Int?
    let name: String?
}


// MARK: - CarMakeModel
struct CarMakeModel: Codable {
    let version: String?
    let statusCode: Int?
    let status: Bool?
    let message: String?
    let data: [MakeData]?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case status = "Status"
        case message = "Message"
        case data = "Data"
    }
}

// MARK: - Datum
struct MakeData: Codable {
    let id, type: Int?
    let name: String?
}

// MARK: - CarModel
struct CarModel: Codable {
    let version: String?
    let statusCode: Int?
    let status: Bool?
    let message: String?
    let data: [ModelData]?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case statusCode = "StatusCode"
        case status = "Status"
        case message = "Message"
        case data = "Data"
    }
}

// MARK: - Datum
struct ModelData: Codable {
    let id, make: Int?
    let name: String?
}
