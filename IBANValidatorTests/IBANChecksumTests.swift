//
//  IBANModuloTests.swift
//  IBANValidatorTests
//
//  Created by Tim Duckett on 30.10.17.
//  Copyright © 2017 Tim Duckettt. All rights reserved.
//

import Quick
import Nimble

@testable import IBANValidator

class IBANChecksumTests: QuickSpec {
    
    override func spec() {
        
        describe("When preparing to calculate the checksum") {
            
            it("should rearrange the IBAN ready for checking", closure: {
                let ibanUnderTest = "DE1234567890123456789012"
                let rearrangedIban = "34567890123456789012DE00"
                expect(rearrange(iban: ibanUnderTest)).to(equal(rearrangedIban))
            })
            
            it("should replace letters with values", closure: {
                let ibanUnderTest1 = "DE34567890123456789012345"
                let rearrangedIban1 = "131434567890123456789012345"
                expect(replaceAlphaChars(iban: ibanUnderTest1)).to(equal(rearrangedIban1))

                let ibanUnderTest2 = "NL11ABNA0481433284"
                let rearrangedIban2 = "232111101123100481433284"
                expect(replaceAlphaChars(iban: ibanUnderTest2)).to(equal(rearrangedIban2))

            })
            
        }
        
        describe("When calculating the checksum") {
            
            it("should calculate the checksum correctly", closure: {
                
                // NL14ABNA0226614812
                let ibanUnderTest1 = "101123100226614812232100"
                let checksum1 = calculateChecksum(iban: ibanUnderTest1)
                expect(checksum1).to(equal("14"))

                // NL11ABNA0481433284
                let ibanUnderTest2 = "101123100481433284232100"
                let checksum2 = calculateChecksum(iban: ibanUnderTest2)
                expect(checksum2).to(equal("11"))

            })
            
        }
        
    }
    
}
