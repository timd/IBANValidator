//
//  IBANValidator.swift
//  IBANValidator
//
//  Created by Tim Ducket on 29.10.17.
//  Copyright © 2017 Tim Duckett. All rights reserved.
//

import Foundation

let countries = [ "AL" : 28,
                  "AD" : 24,
                  "AT" : 20,
                  "AZ" : 28,
                  "BH" : 22,
                  "BY" : 28,
                  "BE" : 16,
                  "BA" : 20,
                  "BR" : 29,
                  "BG" : 22,
                  "CR" : 22,
                  "HR" : 21,
                  "CY" : 28,
                  "CZ" : 24,
                  "DK" : 18,
                  "DO" : 28,
                  "TL" : 23,
                  "EE" : 20,
                  "FO" : 18,
                  "FI" : 18,
                  "FR" : 27,
                  "GE" : 22,
                  "DE" : 22,
                  "GI" : 23,
                  "GR" : 27,
                  "GL" : 18,
                  "GT" : 28,
                  "HU" : 28,
                  "IS" : 26,
                  "IE" : 22,
                  "IL" : 23,
                  "IT" : 27,
                  "JO" : 30,
                  "KZ" : 20,
                  "XK" : 20,
                  "KW" : 30,
                  "LV" : 21,
                  "LB" : 28,
                  "LI" : 21,
                  "LT" : 20,
                  "LU" : 20,
                  "MK" : 19,
                  "MT" : 31,
                  "MR" : 27,
                  "MU" : 30,
                  "MC" : 27,
                  "MD" : 24,
                  "ME" : 22,
                  "NL" : 18,
                  "NO" : 15,
                  "PK" : 24,
                  "PS" : 29,
                  "PL" : 28,
                  "PT" : 25,
                  "QA" : 29,
                  "RO" : 24,
                  "SM" : 27,
                  "SA" : 24,
                  "RS" : 22,
                  "SK" : 24,
                  "SI" : 19,
                  "ES" : 24,
                  "SE" : 24,
                  "CH" : 21,
                  "TN" : 24,
                  "TR" : 26,
                  "AE" : 23,
                  "GB" : 22,
                  "VG" : 24 ]

public func IBANValidator(iban: String) -> Bool {
    return false
}

public func checkStartOfIBAN(iban: String) -> Bool {

    let charSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")

    let startChars = iban.prefix(2).uppercased()
    let firstChar = String(startChars.dropLast())
    let secondChar = String(startChars.dropFirst())
    
    return (firstChar.rangeOfCharacter(from: charSet) != nil) && (secondChar.rangeOfCharacter(from: charSet) != nil)

}

public func checkCheckDigits(iban: String) -> Bool {
    
    let charSet = CharacterSet(charactersIn: "0123456789")
    
    let startChars = iban.prefix(4)
    let checkDigits = String(startChars.dropFirst(2))
    
    return checkDigits.rangeOfCharacter(from: charSet) != nil

}

public func checkCountryCode(iban: String) -> Bool {
    
    let startChars = iban.prefix(2).uppercased()

    if let _ = countries[startChars] {
        return true
    }
    
    return false
    
}
