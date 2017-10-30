//
//  IBANValidator.swift
//  IBANValidator
//
//  Created by Tim Duckett on 29.10.17.
//  Copyright © 2017 Tim Duckettt. All rights reserved.
//

import Foundation

public enum IBANValidationError: String, LocalizedError {
    case invalidChecksum = "Invalid checksum"
    case invalidCountryCode = "Invalid country code"
    case invalidLength = "Invalid length"
    case invalidCharacters = "Invalid characters"
}

public enum ResultType<T, Error> {
    case failure(Error)
    case success(T)
}

private let countries = [ "AL" : 28,
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

private let letters = [
    "A": 10,
    "B": 11,
    "C": 12,
    "D": 13,
    "E": 14,
    "F": 15,
    "G": 16,
    "H": 17,
    "I": 18,
    "J": 19,
    "K": 20,
    "L": 21,
    "M": 22,
    "N": 23,
    "O": 24,
    "P": 25,
    "Q": 26,
    "R": 27,
    "S": 28,
    "T": 29,
    "U": 30,
    "V": 31,
    "W": 32,
    "X": 33,
    "Y": 34,
    "Z": 35]

    public func IBANValidator(iban: String) throws -> Bool {
        
        // Check invalid chars
        if !checkInvalidChars(iban: iban) { throw IBANValidationError.invalidCharacters }
        
        // Clean IBAN
        let cleanedIban = cleanIban(iban: iban)
        
        // Check length
        do {
            try _ = checkLength(iban: cleanedIban)
        } catch let error as IBANValidationError {
            
            switch  error {
            case .invalidCountryCode:
                throw IBANValidationError.invalidCountryCode
            default:
                throw IBANValidationError.invalidLength
            }
        }
        
        //if !checkLength(iban: cleanedIban) { throw IBANValidationError.invalidLength }
        
        // Check start is valid
        if !checkStartOfIBAN(iban: cleanedIban) { throw IBANValidationError.invalidCharacters }
        
        // Check country code
        if !checkCountryCode(iban: cleanedIban) { throw IBANValidationError.invalidCountryCode }
        
        // Isolate existing checksum
        let startChars = cleanedIban.prefix(4)
        let existingChecksum = String(startChars.suffix(2))
        
        // Rearrange
        let rearrangedIban = rearrange(iban: cleanedIban)
        
        // Replace alpha chars
        let nonAlphaIban = replaceAlphaChars(iban: rearrangedIban)
        
        // Calculate checksum
        let calculatedChecksum = calculateChecksum(iban: nonAlphaIban)
        
        // Test that checksums match
        if calculatedChecksum != existingChecksum { throw IBANValidationError.invalidChecksum }
        
        return true
        
    }
    
    
// Gross validation tests



internal func checkInvalidChars(iban: String) -> Bool {
    
    if iban.components(separatedBy: CharacterSet.alphanumerics).joined().count != 0 {
        return false
    }
    
    return true
    
}

internal func cleanIban(iban: String) -> String {
    return iban.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
}

internal func checkStartOfIBAN(iban: String) -> Bool {

    let charSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")

    let startChars = iban.prefix(2).uppercased()
    let firstChar = String(startChars.dropLast())
    let secondChar = String(startChars.dropFirst())
    
    return (firstChar.rangeOfCharacter(from: charSet) != nil) && (secondChar.rangeOfCharacter(from: charSet) != nil)

}

internal func checkCheckDigits(iban: String) -> Bool {
    
    let charSet = CharacterSet(charactersIn: "0123456789")
    
    let startChars = iban.prefix(4)
    let checkDigits = String(startChars.dropFirst(2))
    
    return checkDigits.rangeOfCharacter(from: charSet) != nil

}

internal func checkCountryCode(iban: String) -> Bool {
    
    let startChars = iban.prefix(2).uppercased()

    if let _ = countries[startChars] {
        return true
    }
    
    return false
    
}

internal func checkLength(iban: String) throws -> Bool {
    
    if iban.count > 34 { throw IBANValidationError.invalidLength }
    
    // Split country characters
    let startChars = iban.prefix(2).uppercased()
    
    if let length = countries[startChars] {
        
        if iban.count == length {
            return true
        } else {
            throw IBANValidationError.invalidLength
        }
        
    } else {
        // Invalid country code, reject
        throw IBANValidationError.invalidCountryCode
    }
    
}

// Rearrangement

internal func rearrange(iban: String) -> String {
    
    let startIndex = iban.startIndex
    
    // Get first 4 chars
    let firstFourCharsIndex = iban.index(startIndex, offsetBy: 4)
    let firstFourChars = String(iban[startIndex..<firstFourCharsIndex])
    
    // Discard chars 3,4 (old checksum)
    let firstTwoChars = firstFourChars.prefix(2)
    
    // Get remaining chars
    let remainingChars = String(iban[firstFourCharsIndex...])
    
    return remainingChars + firstTwoChars + "00"
    
}
    
internal func replaceAlphaChars(iban: String) -> String {
    
    let charSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    var updatedIban = iban
    
    while (updatedIban.rangeOfCharacter(from: charSet) != nil) {
    
        for (key, value) in letters {
        
            // Find key in iban
            if let keyRange = updatedIban.range(of: key) {
                updatedIban.replaceSubrange(keyRange, with: String(value))
            }

        }
        
    }
    
    return updatedIban
    
}

internal func calculateChecksum(iban: String) -> String {
        
    let ibanNumber = BInt(iban)
        
    let modulus = ibanNumber % 97
        
    let checksumInt = 98 - modulus
        
    if (checksumInt < 10) {
        return "0\(checksumInt)"
    }
        
    return "\(checksumInt)"
        
}
    


