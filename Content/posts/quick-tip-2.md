---
date: 2020-12-13 00:00
description: Swift's type-safety is one of the language's main features, and it is extremely powerful to harness the compiler type-check to your code. In this short article, I'll give some tips to improve readability and clearness of intent using some typing resources available.
---
# Quick tip #2: Typealias to improve readability

Swift's type-safety is one of the language's main features, and it is extremely powerful to harness the compiler type-check to your code. Meaning that making good use of protocols, protocol composition, default values, type-constraints, inheritance and, type aliasing, is important to guide a developer to use your classes, modules, or frameworks in the intended way, as the types constraints the data and its flow. In this short article, I'll give some tips to improve readability and clearness of intent using some typing resources available.

This article is in a way, an iteration on the last one about naming in software. You can read this one independently, but if you are interested in the subject, you can read it [here](https://www.lucasoliveira.tech/posts/naming). The article explains why naming is so important and gives some general advice on how to choose good names in software.

## Typealias

In Swift, typaliases declarations introduce a new name to an existent type. The typealias access scope might be modified by the access modifiers `public`, `private`, and so on. You can read the official documentation [here](https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#grammar_typealias-declaration).

Observe the example below. It shows how to use typealias in its simplest form, and is a nice and simple use case on how typealias can make code easy to understand.

```swift
// Typealias declaration
typealias OrderUUID = String
// Typealias used on a function header
func appendOrder(with: OrderUUID)
// Function being used
appendOrder(with: "08129d15-2246-4157-ace9-5ad896d04764")
```

Typealiasing `String` as `OrderUUID` in this context makes the use of this function unambiguous, and we could even drop the label `with`. Keep in mind that making code as obvious as we can is our main goal here.

Although one could argue that this function is obvious even without the typealiasing, which is reasonable, most projects have some complex functions that receive many arguments, and in some cases, the complexity resides in the model. An `Order` object could have multiple identifier parameters like `uuid`, `number`, `analyticsID` and so on, so depending on the function context, you might be unsure on what is the identifier you should provide, so having the type `OrderUUID` regularly used on the project whenever this identifier is needed, could be the difference-maker.

Another useful use case of typealias is typing closures. The example below shows two functions that fetch and returns a page of items.

```swift
typealias ItemPageCompletion = (Result<ItemPage, Error>) -> Void

func fetchHighlightedItems(completion: @escaping ItemPageCompletion)
func fetchItemList(pageNumber: Int, completion: @escaping ItemPageCompletion)
```

Using the typealias `ItemPageCompletion` to substitute `Result<ItemPage, Error> -> Void` makes function declaration compact without losing meaning. It also makes it easier to glance over the two functions and perceive that both deal with the same type of data.

Last but not least, `TimeInterval` from `Foundation` is a very good example of how type aliases can be effective.

```swift
// From Foundation.NSDate
public typealias TimeInterval = Double
// An example of foundation that uses TimeInterval 
extension NSDate {
    open func addingTimeInterval(_ ti: TimeInterval) -> Self
}
```

Since `Double` is a really broad type that can be used for an infinity of contexts and can mean roughly anything, when dealing with time intervals, Apple's APIs uses only `TimeInterval`. This way the developers that are interacting with the API are not in doubt if the number that they have to provide is the timestamp of some date or an interval. Think of how ambiguous it would be if the function from the example above were written like the following:

```swift
extension NSDate {
    open func adding(_ ti: Double) -> Self
}
```

And the coolest thing about the `TimeInterval` example is how it is possible to add documentation to the type if more information is needed.

<img src="https://raw.githubusercontent.com/lucas1295santos/lucas1295santos.github.io/master/images/post_quicktip2_img1.png" alt="TimeInterval documentation" style="width:480px;"/>

You could create documentation for your own type aliases the same way you would create for a class or function. If you are new to documentation on XCode, [this guide](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html#//apple_ref/doc/uid/TP40016497-CH2-SW1) has everything you have to know (plus some cool formatting tips for playgrounds).

```swift
/// The UUID of an Order, found in the parameter UUID from Order
typealias OrderUUID = String
```

## Thanks for reading!

Liked this content? I always announce new articles on my [Twitter Account](https://twitter.com/oliveira__lucas). Suggestions, feedback, and corrections are always welcome.