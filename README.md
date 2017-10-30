# IBANValidator
Being a small Swift framework to check validity of IBAN codes

## Installation

*Carthage:*

1. Add `github "timd/IBANValidator"` to the Cartfile
1. Run carthage update
1. Add the framework to the Link Binary with Libraries build phase, and add to the Carthage Run Script build phase as per the Carthage documentation.

*Cocoapods:*

Not yet.

## Usage

1. Import the framework into the class: `import IBANValidator`
2. Test the IBAN:

```
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

```
public enum IBANValidationError: String, LocalizedError {
    case invalidChecksum = "Invalid checksum"
    case invalidCountryCode = "Invalid country code"
    case invalidLength = "Invalid length"
    case invalidCharacters = "Invalid characters"
}
```

## Acknowledgements

This framework uses Marcel Kröker's [Swift-Big-Integer library](https://github.com/mkrd/Swift-Big-Integer).
Sample IBAN numbers can be obtained [here](https://www.iban-bic.com/sample_accounts.html).
