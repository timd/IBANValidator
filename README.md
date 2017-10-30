# IBANValidator
Being a small Swift framework to check validity of IBAN codes. It's based on the the ISO 13616:2007 standard, which defines a checksum process described (here)[https://en.wikipedia.org/wiki/International_Bank_Account_Number#Validating_the_IBAN].

## Installation

*Carthage:*

1. Add `github "timd/IBANValidator"` to the Cartfile
1. Run `carthage update`
1. Add the framework to the Link Binary with Libraries build phase, and add to the Carthage Run Script build phase as per the Carthage documentation.

*Cocoapods:*

Not yet.

## Usage

1. Import the framework into the class: `import IBANValidator`
2. Test the IBAN:

```swift
let validIBAN = "AL90208110080000001039531801"

do {
    
    let _ = try IBANValidator(iban: validIBAN)
    
    // Validation was successful, carry on
    
} catch let error as IBANValidationError {
    
    // Handle error
    print(error)
    
} catch {
    
    // Something else went wrong
    
}
```

## Validation errors

Errors are returned as an `IBANValidationError`:

```swift
public enum IBANValidationError: String, LocalizedError {
    case invalidChecksum = "Invalid checksum"
    case invalidCountryCode = "Invalid country code"
    case invalidLength = "Invalid length"
    case invalidCharacters = "Invalid characters"
}
```
* `invalidChecksum` is returned if the checksum calculation fails. This indicates an invalid IBAN.
* `invalidCountryCode` is returned if the country code does not appear on the list of supported countries (see the list at the top of `IBANValidator.swift` for the current list
* `invalidLength` is returned if the provided IBAN is longer than 34 characters; or exceeds the length defined as the maximum for the country (these differ from country to country) 
* `invalidCharacters` is returned if the provided IBAN contains non-alphanumeric characters. The IBAN standard doesn't support Emoji yet.

## Country codes

As a convenience for populating things like picker lists, `IBANValidator` exposes the `countries` property which is an `Array` of `Dictionaries` containing a two-letter country code as the key. When sorted, this could be used as the data source for a picker to speed up the IBAN data entry and reduce use errors.

## Acknowledgements

This framework uses Marcel Kröker's [Swift-Big-Integer library](https://github.com/mkrd/Swift-Big-Integer).
Sample IBAN numbers can be obtained [here](https://www.iban-bic.com/sample_accounts.html).

## Disclaimer

Use at your own risk. You probably don't want to rely on this library alone if you're doing anything as dramatic as transferring real money. But it's a good starting point...
