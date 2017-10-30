//
//  CompleteTests.swift
//  IBANValidatorTests
//
//  Created by Tim Ducket on 30.10.17.
//  Copyright © 2017 Tim Duckett. All rights reserved.
//

import Quick
import Nimble

class CompleteTests: QuickSpec {
    
    override func spec() {
     
        describe("The consolidated process") {
            
            it("should return true for a valid IBAN", closure: {
                let ibanUnderTest = "NL11ABNA0481433284"
                let result = IBANValidator(iban: ibanUnderTest)
                expect(result).to(equal(true))
            })
            
            it("should return false for an invalid IBAN", closure: {
                let ibanUnderTest = "NL33ABNA0481433284"
                let result = IBANValidator(iban: ibanUnderTest)
                expect(result).to(equal(false))
            })

        }
        
    }
    
}
