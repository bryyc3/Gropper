//
//  NumberParse.swift
//  Gropper
//
//  Created by Bryce King on 12/8/25.
//

import Foundation
import PhoneNumberKit

let phoneNumberUtility = PhoneNumberUtility()

func NumberParse(number: String) throws -> String? {
    guard let parsed = try? phoneNumberUtility.parse(number, ignoreType: true) else {
        throw NumberParseError.parseErr
    }
    return phoneNumberUtility.format(parsed, toType: .e164, withPrefix: true)
}

enum NumberParseError: Error {
    case parseErr
}
