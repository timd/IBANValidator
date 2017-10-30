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
            
            context("IBAN start characters", {
            
                it("should reject an IBAN that starts with numbers", closure: {
                    let IBANUnderTest = "12345678901234567890"
                    let result = checkStartOfIBAN(iban: IBANUnderTest)
                    expect(result).to(beFalse())
                })

                it("should reject an IBAN that starts with a single letter", closure: {
                    let IBANUnderTest = "A12345678901234567890"
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
            
            

        }
        
    }
    
}
