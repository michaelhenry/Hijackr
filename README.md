# Hijackr🛩

[![CI Status](https://img.shields.io/travis/michaelhenry/Hijackr.svg?style=flat)](https://travis-ci.org/michaelhenry/Hijackr)
[![Version](https://img.shields.io/cocoapods/v/Hijackr.svg?style=flat)](https://cocoapods.org/pods/Hijackr)
[![License](https://img.shields.io/cocoapods/l/Hijackr.svg?style=flat)](https://cocoapods.org/pods/Hijackr)
[![Platform](https://img.shields.io/cocoapods/p/Hijackr.svg?style=flat)](https://cocoapods.org/pods/Hijackr)

## Installation

Hijackr is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Hijackr'
```

## How to Use

To register:

```swift
Hijackr.register()
```

To unregister:

```swift
Hijackr.unregister()
```

To hijack a request:

```swift
Hijackr.hijack(request: request, with: response)
```

Example:

```swift
let request =  URLRequest(url: URL(string: "https://www.google.com")!)
let response = Hijackr.Response(statusCode: 200, body: "hello".data(using: .utf8))
Hijackr.hijack(request: request, with: response)
```

## UnitTest

Test Cases can be found [here](/Example/Tests/)

## Author

michaelhenry, me@iamkel.net

## License

Hijackr is available under the MIT license. See the LICENSE file for more info.
