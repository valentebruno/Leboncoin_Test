# Create a universal application (iPhone, iPad) in Swift

It should display a list of ads available on the API
https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json

The correspondence of category IDs can be found on the API
https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json

The API contract can be viewed at this address:
https://raw.githubusercontent.com/leboncoin/paperclip/master/swagger.yaml

## The expected points in the project are:
*  An architecture that respects the single responsibility principle
*  Creation of interfaces mixing UIKit and SwiftUI (for example, one screen with one
 and another with the other)
* Development in Swift
* The code must be versioned (Git) on an online platform such as Github or Bitbucket (no zip) and must be immediately executable on the master branch
*  No external libraries or code generation tools are allowed
*  The project must be compatible with iOS 16+ (compilation and tests)
*  Retrieval of all data available in the swagger via an API call

## We will also pay particular attention to the following points:
*  Unit tests
* UX and UI efforts
*  Application performance
* Swifty code

## List of items
Each item should include at least an image, a category, a title, and a price.

An indicator should also warn if the item is urgent.

## Detail page
When tapping on an item, a detailed view should be displayed with all the information
provided in the API.
