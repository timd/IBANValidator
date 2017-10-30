//
//  IBANValidatorTests.swift
//  IBANValidatorTests
//
//  Created by Tim Ducket on 29.10.17.
//  Copyright © 2017 Tim Duckett. All rights reserved.
//

import Quick
import Nimble

@testable import IBANValidator

class IBANValidatorTests: QuickSpec {
    
    override func spec() {
        
        describe("When coarse format checking") {
            
            context("non-valid characters", {
                
                it("should clean out spaces", closure: {
                    let IBANUnderTest = "DE12 3456 7890 1234 5678 90"
                    let cleanedIban = "DE12345678901234567890"
                    let result = cleanIban(iban: IBANUnderTest)
                    expect(result).to(equal(cleanedIban))
                })

                it("should clean out dashes", closure: {
                    let IBANUnderTest = "DE12-3456-7890-1234-5678-90"
                    let cleanedIban = "DE12345678901234567890"
                    let result = cleanIban(iban: IBANUnderTest)
                    expect(result).to(equal(cleanedIban))
                })

                it("should reject invalid characters", closure: {
                    let IBANUnderTest = "DE*123,456789🐶01234567890"
                    let result = checkInvalidChars(iban: IBANUnderTest)
                    expect(result).to(beFalse())
                })

                it("should pass valid characters", closure: {
                    let IBANUnderTest = "DE12345678901234567890"
                    let result = checkInvalidChars(iban: IBANUnderTest)
                    expect(result).to(beTrue())
                })

            })
            
            context("IBAN start characters", {
            
                it("should reject an IBAN that starts with numbers", closure: {
                    let IBANUnderTest = "12345678901234567890"
                    let result = checkStartOfIBAN(iban: IBANUnderTest)
                    expect(result).to(beFalse())
                })

                it("should reject an IBAN that starts with a single uppercase letter", closure: {
                    let IBANUnderTest = "A12345678901234567890"
                    let result = checkStartOfIBAN(iban: IBANUnderTest)
                    expect(result).to(beFalse())
                })

                it("should reject an IBAN that starts with a single lowercase letter", closure: {
                    let IBANUnderTest = "a12345678901234567890"
                    let result = checkStartOfIBAN(iban: IBANUnderTest)
                    expect(result).to(beFalse())
                })

                it("should reject an IBAN that starts with non-alpha characters", closure: {
                    let IBANUnderTest = "🐶🐔12345678901234567890"
                    let result = checkStartOfIBAN(iban: IBANUnderTest)
                    expect(result).to(beFalse())
                })

                it("should pass an IBAN that starts with two uppercase letters", closure: {
                    let IBANUnderTest = "AB12345678901234567890"
                    let result = checkStartOfIBAN(iban: IBANUnderTest)
                    expect(result).to(beTrue())
                })

                it("should pass an IBAN that starts with two lowercase letters", closure: {
                    let IBANUnderTest = "ab12345678901234567890"
                    let result = checkStartOfIBAN(iban: IBANUnderTest)
                    expect(result).to(beTrue())
                })

                it("should reject an IBAN with alpha characters in the checkdigits", closure: {
                    let IBANUnderTest = "ABCD345678901234567890"
                    let result = checkCheckDigits(iban: IBANUnderTest)
                    expect(result).to(beFalse())
                })
                
                it("should pass an IBAN with numeric characters in the checkdigits", closure: {
                    let IBANUnderTest = "AB11345678901234567890"
                    let result = checkCheckDigits(iban: IBANUnderTest)
                    expect(result).to(beTrue())
                })
                
                it("should reject an IBAN with an invalid country code", closure: {
                    let IBANUnderTest = "XY11345678901234567890"
                    let result = checkCountryCode(iban: IBANUnderTest)
                    expect(result).to(beFalse())
                })

                it("should pass an IBAN with an valid country code", closure: {
                    let IBANUnderTest = "DE11345678901234567890"
                    let result = checkCountryCode(iban: IBANUnderTest)
                    expect(result).to(beTrue())
                })

                it("should pass an IBAN with an valid lowercase country code", closure: {
                    let IBANUnderTest = "de11345678901234567890"
                    let result = checkCountryCode(iban: IBANUnderTest)
                    expect(result).to(beTrue())
                })
                
            })
            
            describe("length", {
                
                it("should reject IBANs that have more than 34 characters", closure: {
                    let IBANUnderTest = "DE345678901234567890123456789012345"
                    let result = checkLength(iban: IBANUnderTest)
                    expect(result).to(beFalse())
                })
                
                it("should reject IBANs with invalid lengths", closure: {
                    // DE = 22, BE = 16, MT = 31,
                    let DE_ibanUnderTest = "DE345678901234567890123"
                    let BE_ibanUnderTest = "BE345678901234567"
                    let MT_ibanUnderTest = "MT345678901234567890123456789012"
                    expect(checkLength(iban: DE_ibanUnderTest)).to(beFalse())
                    expect(checkLength(iban: BE_ibanUnderTest)).to(beFalse())
                    expect(checkLength(iban: MT_ibanUnderTest)).to(beFalse())
                })

                it("should pass IBANs with correct lengths", closure: {
                    // DE = 22, BE = 16, MT = 31,
                    let DE_ibanUnderTest = "DE34567890123456789012"
                    let BE_ibanUnderTest = "BE34567890123456"
                    let MT_ibanUnderTest = "MT34567890123456789012345678901"
                    expect(checkLength(iban: DE_ibanUnderTest)).to(beTrue())
                    expect(checkLength(iban: BE_ibanUnderTest)).to(beTrue())
                    expect(checkLength(iban: MT_ibanUnderTest)).to(beTrue())
                })

            })

        }
        
    }
    
}
