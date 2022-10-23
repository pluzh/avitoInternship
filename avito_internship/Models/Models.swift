//
//  Models.swift
//  avito_internship
//
//  Created by Ангелина Плужникова on 21.10.2022.
//

import Foundation

struct ResultModel: Codable {
    let company: Company
}

struct Company: Codable {
    let name: String
    let employees: [Employees]
}

struct Employees: Codable {
    var name: String
    var phoneNumber: String
    var skills: [String]
    
    enum CodingKeys: String, CodingKey {
            case name
            case phoneNumber = "phone_number"
            case skills
    }
}
