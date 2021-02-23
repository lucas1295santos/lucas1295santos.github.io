---
date: 2021-02-23 00:00
description: Enumerations is one of Swift's coolest features for its versatility in representing a group of related values. They can become even more versatile and expressive combined with protocols such as `Equatable`. This short article shows some tricks to do so.
---
<img src="https://raw.githubusercontent.com/lucas1295santos/lucas1295santos.github.io/master/images/equatable-enums-header.png" alt="Equatable enums in Swift"/>

# Quick tip #3: Equatable enums in Swift

Enumerations is one the Swift's coolest features for its versatility in representing a group of related values. They can become even more versatile and expressive combined with protocols such as `Equatable`. This short article shows some tricks to do so.

This article assumes that you know what an enum is in Swift. If you are not sure about that, I highly recommend you to read the [Swift docs on Enums](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html#ID147) and [this post by John Sundell](https://www.swiftbysundell.com/basics/enums/) that will cover all the basics and some more.

## Comparing enums

Since an enum represents a finite set of options or states, we often want to compare values between enums, and the main way of doing that is using a `switch` statement like represented below:

``` swift
enum CameraPermissionStatus {
    case granted
    case notDetermined
    case denied
    case restricted
}

func presentCameraScene(with status: CameraPermissionStatus) {
    switch status {
    case .granted:
        routeToCameraScene()
    case .notDetermined:
        presentCameraPermissionAlert()
    case .denied:
        presentSystemPermissionsSettings()
    case .restricted:
        presentRestrictedAccessDialog()
    }
}
```

## Using switch

Usually, you want to do a specific action for each enum case, that's why a `switch` statement is so fitting. Only in different cases like testing, you are interested in a single case, so a direct comparison would be better.

``` swift
func test_getCameraPermission_expectedToBeGranted() {
    permissionProviderStub.permissionToBeReturned = .granted

    let permission = sut.getCameraPermission()
        
    XCTAssertEqual(permission, .granted)
}
```

A piece of cake, isn't it?

Things can become a little tricky when the enum has an associated value.

``` swift
enum FeedbackAction {
    case toast(message: String)
    case alert(title: String, message: String)
    case retryConnection
}

func test_getFeedback_whenErrorIsInvalidCard_expectAlert() {
    let sut = PurchaseError(code: "INVALID_CARD")
    
    let feedback = sut.getFeedback()
    
    XCTAssertEqual(feedback, .alert)
}
```

Now if you try to do a similar test, like the one above, with this enum you'll get the error `Global function 'XCTAssertEqual(_:_:_:file:line:)' requires that 'FeedbackAction' conform to 'Equatable'`. So the obvious way of fixing this test would be to assert inside a `switch` statement.

``` swift
func test_getFeedback_whenErrorIsInvalidCard_expectAlert() {
    let sut = PurchaseError(code: "INVALID_CARD")
    
    let feedback = sut.getFeedback()
    
    switch feedback {
    case .alert(let title, let message):
        XCTAssertEqual(title, "Invalid card")
        XCTAssertEqual(message, "Review card information and try again")
    default:
        XCTFail("Expected alert feedback action")
    }
}
```

Using the `switch` statement allowed us to assert that the type and all the associated values are matching the expected, at the cost of having to add the `XCTFail` at the default case as otherwise, the test would pass even without executing the assertions. Remember that a test success is the absence of failures, so a test without asserts is still a success. But what would this test look like if we were to assert the `retryConnection` case?

```swift
func test_getFeedback_whenErrorIsNoNetwork_expectRetryConnection() {
    let sut = PurchaseError(code: "NO_NETWORK")
    
    let feedback = sut.getFeedback()
    
    switch feedback {
    case .retryConnection:
        break
    default:
        XCTFail("Expected retryConnection feedback action")
    }
}
```

Since the case `retryConnection` has no associated values, we don't have any assertions to do in the `switch` statement, so the test would pass by not asserting anything, or fail by the `XCTFail` on the `default` case. Besides looking weird, this test isn't clearly following the Arrange, Act, Assert (AAA) pattern since there is no assert.

If you are not sure what this AAA thing is, [this article from Mark Seemann](https://blog.ploeh.dk/2013/06/24/a-heuristic-for-formatting-code-according-to-the-aaa-pattern/) briefly explains it, and gives good examples on how to write tests using this pattern. The AAA pattern is a basic standard for testing in many languages, so it is worth the effort to learn and practice it.

## Using Equatable

A cleaner way of doing the same test would be to make `FeedbackAction` conform to `Equatable`.

``` swift
enum FeedbackAction: Equatable {
    case toast(message: String)
    case alert(title: String, message: String)
    case retryConnection
}

func test_getFeedback_whenErrorIsInvalidCard_expectAlert() {
    let sut = PurchaseError(code: "INVALID_CARD")
    
    let receivedFeedback = sut.getFeedback()
    
    let expectedFeedback = FeedbackAction.alert(
        title: "Invalid card",
        message: "Review card information and try again"
    )
    XCTAssertEqual(receivedFeedback, expectedFeedback)
}
```

By default when an enum is conforming to equatable, two values are considered equal if they are the same case and if all the associated values are equal.

``` swift
let a = FeedbackAction.alert(title: "123", message: "abc")
let b = FeedbackAction.alert(title: "hello", message: "abc")
let c = FeedbackAction.alert(title: "123", message: "abc")
let d = FeedbackAction.toast(message: "abc")

a == b // false
a == c // true
a == d // false
```

So if your enum has associated values only from primitive types or types that have a built-in implementation of `Equatable`, you can just make the enum conform to the protocol and it will work like magic. Conversely, on a non-trivial custom type, you may have to implement `Equatable` conformance on this type, or give up and use the `switch` strategy.

## Thanks for reading!

Liked this content? I always announce new articles on my [Twitter Account](https://twitter.com/oliveira__lucas). Suggestions, feedback, and corrections are always welcome.