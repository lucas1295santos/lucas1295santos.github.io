# Swift ranges cheat sheet

Even after some years of experience in Swift, I still find ranges a little bit tricky and have to take a look in the docs or make a playground to test things out, before using them at work. This post is a cheat sheet with examples on how to use ranges.

## What is a range?

A range comprises a collection of elements between a certain lower and upper bound, bounds which might be included or excluded. The simplest use case of ranges that you might have seen, is to iterate on a `for` loop.

```swift
for _ in 0 ..< 5 {
    print("Hello world") // prints Hello world 5 times
}
```

## Cheatsheet

### Ranges to iterate

`...` is a closed range, meaning that it **includes the upper and lower bound**.

```swift
for count in 0...3 {
    print(count) // prints 0 1 2 3
}
```

`..<` is a half-open range, meaning that it **excludes the upper bound** while **includes the lower bound**

```swift
for count in 0..<3 {
    print(count)
}
```

So if you want to iterate through a full array, you probably want to use a half-open range.

```swift
let arr = [1, 3, 5, 7, 9]
for index in 0..<arr.count {
    print(arr[index]) // prints 1 3 5 7 9
}
```

Otherwise, you would crash the program with an index out of range exception.

```swift
let arr = [1, 3, 5, 7, 9]
for index in 0...arr.count {
    print(arr[index]) // prints 1 3 5 7 9 and than CRASHES because it will try to access the index 5 which doesn't exists.
}
```

### Ranges to slice arrays

It's easy to create [array slices](https://developer.apple.com/documentation/swift/arrayslice) using ranges, as the same logic of iterations applies here. It is also super useful to use ranges in their unary operator version. Let's take a look at some ways to slice an array in half.

```swift
let arr = [1, 3, 5, 7, 9]
let midpoint = arr.count / 2 // takes the middle index in this case 2, so arr[midpoint] would be 5 here.
let slice = arr[...midpoint] // creates an ArraySlice<Int> off the array from the first index (0) to the midpoint (2), including it.
for element in slice {
    print(element) // prints 1 3 5
}
```

If you don't want the midpoint you can just use the half-closed range `..<` instead

```swift
let arr = [1, 3, 5, 7, 9]
let midpoint = arr.count / 2 // takes the middle index in this case 2, so arr[midpoint] would be 5 here.
let slice = arr[..<midpoint] // creates an ArraySlice<Int> off the array from the first index (0) to the midpoint (2), excluding it.
for element in slice {
    print(element) // prints 1 3
}
```

And if you want the right half of the array, you can use the closed range `...` postfixed.

```swift
let arr = [1, 3, 5, 7, 9]
let midpoint = arr.count / 2 // takes the middle index in this case 2, so arr[midpoint] would be 5 here.
let slice = arr[midpoint...] // creates an ArraySlice<Int> off the array from the midpoint(2) to the end of the array (4).
for element in slice {
    print(element) // prints 5 7 9
}
```

Strangely, there is no half-closed range postfixed.

### Ranges in Enums

It is not possible to directly associate ranges to Enum cases like this

```swift
// This doesn't work
enum ScoreClassification {
    case awesome = 90...
    case good = 70..<90
    case average = 40..<70
    case bad = ..<40
}
```

To work around that, you could make custom init on your enum and `switch` through the ranges.

```swift
enum ScoreClassification {
    case awesome
    case good
    case average
    case bad

    init(score: Int) {
        switch score {
        case 90...:
            self = .average
        case 70..<90:
            self = .good
        case 40..<70:
            self = .average
        default:
            self = .bad
        }
    }
}

let scoreClassification = ScoreClassification(score: 87)
print(scoreClassification) // prints good
```

## Beyond this article

If you want more details and examples, you can always check the [Apple docs](https://developer.apple.com/documentation/swift/range) for ranges, and [Swift docs](https://docs.swift.org/swift-book/LanguageGuide/BasicOperators.html#ID73) for operators. Beyond official docs, [SwiftLee](https://www.avanderlee.com/swift/ranges-explained) has great use examples.

And if you are in the vibes for learning more Swift related content you can check my [article about typealias](https://www.lucasoliveira.tech/#/post/typealias), where I explain what are type aliases in Swift, and how you could use them to improve code readability.

## Thanks for reading!

Liked this content? Follow me on [Twitter](https://twitter.com/oliveira__lucas) and be the first to know about new articles. Suggestions, feedback, and corrections are always welcome.
