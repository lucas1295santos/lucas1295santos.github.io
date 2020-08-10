---
date: 2020-08-04 00:00
description: We want our software to be error-proof, but in reality, error scenarios will always exist.<br></br>So this article's objective is to explain why you should handle errors on your app, give you a rule of thumb on when treating errors, and give some practical improvements you could apply on your app.
---
# Improving Error Handling in your App in Swift.

We want our software to be error-proof, but in reality, error scenarios will always exist.

So this article's objective is to explain why you should handle errors on your app, give you a rule of thumb on when treating errors, and give some practical improvements you could apply on your app.

## Why handling errors?

### Finding errors *asap*


Worse than finding a bug on your production app is learning that the bug you just found is around for several releases.

Below is the recipe of failure to ship a hard to catch bug.

```swift
func callMerchant(with telefoneNumber: String?) {
    guard let phone = telefoneNumber else { return }
    // Calling a phone number code goes here
}
```

If for some reason this function is ever invoked with a `nil` telefoneNumber, it will exit without trying to make the phone call, and this could lead to a useless call button on your user interface, that does nothing when pressed.

### Improving User Experience (UX)


It might be really frightening to a user with no technology background to be prompted with an error dialog full of tech words and error codes, especially if he just made a critical action like a purchase. Take a look at the picture on the left.

<img src="https://raw.githubusercontent.com/lucas1295santos/lucas1295santos.github.io/master/images/post4_img1.png" alt="Error notification" style="width:500px;"/>

On the other hand, the picture to the right explains what happened and how the user could proceed.

### Recovering from an error state to a success


With a really well-crafted error recovering strategy you could even recover a user that got in an error state, to the main flow of your application that will lead to a goal (like making a purchase).

Recovering from errors is not only important for the tech team, but it is also beneficial for the business as a whole. Commonly, digital products lose some conversion percentual points due to techinical issues. And good error handling might mitigate this issue.

<img src="https://raw.githubusercontent.com/lucas1295santos/lucas1295santos.github.io/master/images/post4_image2.png" alt="Error state recovery" style="width:500px;"/>

The example above gives clear instructions and even some shortcuts on how to get out of this error and try another product.

## Rule of thumb to handling errors

Maybe your App is nothing like any of the examples I gave so far, and you are not sure where you could improve error handling in your app. So you could follow this rule of thumb to know where you should consider handling errors.

Consider handling errors every time you...

* ...make a request to an external source (networking)
* ...capture user input
* ...encode or decode some data
* ...escape a function prior to its full execution (early return)

## Practical improvements for your App

### Monitoring tool


This is the most important improvement that you could do! With a monitoring tool, you can have useful data to discover, understand, and prioritize errors.

By understanding the volumetry of an error, you could decide between adding a fix to the next version, creating a new version as soon as possible just to fix that error (hotfix), or turn off some remote configuration to disable the problematic feature.

There are several monitoring tools available on the market, like [Dynatrace](https://www.dynatrace.com/) or [New Relic](https://newrelic.com/). The monitoring tool that I use at iFood is [Logz.io](https://logz.io/). It provides all the utility that we need to keep track of error logs:

* Logs over time
* Querying for specific logs
* Configuring alerts to send to Slack
* Dashboard creation

With a good tool setup in the project, it is time to bring a monitoring culture to the team. You could start establishing some new tasks that should be done at every new feature development.

* Map all error cases
* Create logs for the error cases
* Create alerts for the logs to get any critical scenario. It is important that the alerts are sent to a channel where all the devs have access.
* Create a Dashboard containing all the logs for that feature
* Monitor the dashboard periodically. You could make a recurrent event on the calendar to be reminded.

### Swift's Error protocol


Swift's error protocol allows you to create expressive errors that will give you useful information to find and act on a possible issue. Having rich errors will also help you to create insightful dashboards and precise alerts on your monitoring tool.

Below, there is a simple example of how to use it in an enumerator.

```swift
enum SimpleError: Error {
    case generic
    case network(payload: [String: Any])
}
```
In this example, we will capture the payload of the request that caused a network error. Doing so, we could look for patterns on the payloads, and understand what really causes the error.

**Disclaimer:** if you want to do an error treatment like that one where you send the payload from a network request, you must mask any user sensitive data.

You could also conform to this protocol in a `struct` so you can have as much information as you need on the error. This is useful when you want to custom tailor an error for a very specific scenario. 

```swift
struct StructError: Error {
    enum ErrorType {
        case one
        case two
    }
    let line: Int
    let file: String
    let type: ErrorType
    let isUserLoggedIn: Bool
}
// ...
func functionThatThrowsError throws {
    throw StructError(line: 53, file: "main.swift", type: .one, isUserLoggedIn: false)
}
```

Later on your monitoring tool, you could create a dashboard comparing the volumetry when the user has logged in again when it is not logged in, so you can understand if this is a relevant factor that leads to the error.

And if you want the error to also contain localized human-readable messages to display, you could also conform to `LocalizedError` as shown below.

```swift
enum RegisterUserError: Error {
    case emptyName
    case invalidEmail
    case invalidPassword
}

extension RegisterUserError: LocalizedError {
    // errorDescription is the one that you get when using error.localizedDescription
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Name can't be empty"
        case .invalidEmail:
            return "Invalid email format"
        case .invalidPassword:
            return "The password must be at least 8 characters long"
        }
    }
}
```

Now if an error of type `RegisterUserError` happens, you could display `error.localizedDescription` to the user.

### Don't use `nil` as an error


Take a look at the function below, it is uncanny how familiar this code is.

```swift
func getUserPreferences() -> UserPreferences? {
    let dataFromKey = UserDefaults.standard.data.(forKey: "user_preferences")
    guard let data = dataFromKey else { return nil }
    let decoder = JSONDecoder()
    let userPreferences = try? decoder.decode(UserPreferences.self, from: data)
    return userPreferences
}
```

At first glance, pretty standard implementation. Nothing wrong with that. But if this code ever returns `nil`, how would you know if there are no `UserPreferences` set yet or if there is something wrong with our encoding or decoding of this object?

If we want to ship this code to production it would be really nice that the caller of this function would create and save a new `UserPreferences` with default preferences if there are none set, or log an error to our monitoring tool if the decoding failed, so we could investigate and fix it.

Returning `nil` when some error occurs really limits the options you have to handle it.

You could instead make the function throwable, declaring it with `throws` and removing the optional mark `?` from the decoder's `try`. If you never used `throws` in Swift, I strongly recommend you read this [article from Sundell](https://www.swiftbysundell.com/basics/error-handling) and the [Swift docs](https://docs.swift.org/swift-book/LanguageGuide/ErrorHandling.html), as I'll not cover the basics on what it is and how it works.

```swift
func getUserPreferences() throws -> UserPreferences {
    let dataFromKey = UserDefaults.standard.data.(forKey: "user_preferences")
    guard let data = dataFromKey else {
        throw UserPreferencesError.noUserPreferences
    }
    let decoder = JSONDecoder()
    let userPreferences = try decoder.decode(UserPreferences.self, from: data)
    return userPreferences
}
```

**Note: ** on the example above, it would be correct to return `nil` on the `else` clause of the `guard`, as `nil` is in fact the representation of the absence of value. I went all-in on throws just to illustrate better how it could be used.

But what if the errors happen in an asynchronous context? Is it time to return `nil`? Still, not ideal, instead, we could use other Swift's nice feature for error handling that suits really well in asynchronous contexts: `Result`.

`Result` is an `enum` with the form `Result<Success, Failure> where Failure: Error` that has a `success` case with the result of the request as an associated value, and a `failure` case that brings an `Error` associated. Again, if you never heard of `Result` before, I strongly recommend this quick read from [hacking with swift](https://www.hackingwithswift.com/articles/161/how-to-use-result-in-swift#:~:text=Swift's%20Result%20type%20is%20implemented,conforms%20to%20Swift's%20Error%20type.&text=Even%20in%20this%20simple%20scenario%2C%20Result%20has%20provided%20two%20benefits.).

If our `getUserPreferences` fetch its data from a server instead of `UserDefaults`, we could rewrite it like the example below.

```swift
func getUserPreferences(userID id: String, completion: @escaping (Result<UserPreferences, Error>) -> Void) {
    Network.request(.userPreferences(userID: id)) { result in
      switch result {
      case .success(let data):
          do {
              let decoder = JSONDecoder()
              let userPreferences = try decoder.decode(UserPreferences.self, from: data)
              completion(.sucess(userPreferences))
          } catch {
              completion(.failure(error))
          }
      case .failure(let error):
          completion(.failure(error))
      }
    }
}
```

This way, the caller function could differentiate an encoding error from a network error, and log it.

### Separate error handling from the actual functionality


If you are familiar with the `SOLID` principles, you know the importance of the *Single Responsibility Principle (SRP)*. The *SRP* says that our software units should have a single responsibility. What is a responsibility depends on the size of the software unit, the responsibility that a function can have is more narrow than the responsibility that a class or a module could handle.

Take a look on the example below:

```swift
func registerUser(_ user: User) throws {
    guard user.name.isEmpty == false else {
        throw RegisterUserError.emptyName
    }
    guard isValid(email: user.email) else {
        throw RegisterUserError.invalidEmail
    }
    guard isValid(password: user.password) else {
        throw RegisterUserError.invalidPassword
    }
    /*
        Code that registers a user goes here
    */
}
```

The function `registerUser` breaks *SRP* and it is not easy to read because the code that actually register the user is at the end of the function, with all the validation rules first.

We could greatly improve this function by separating the error handling responsibility from the user registering responsibility.

```swift
func registerUser(_ user: User) throws {
    try validateUser(user)
    /*
        Code that registers a user goes here
    */
}

func validateUser(_ user: User) throws {
    guard user.name.isEmpty == false else {
        throw RegisterUserError.emptyName
    }
    guard isValid(email: user.email) else {
        throw RegisterUserError.invalidEmail
    }
    guard isValid(password: user.password) else {
        throw RegisterUserError.invalidPassword
    }
}
```

Conforming to the *SRP* made this function that much easier to read.

## Recap

* 😌 Don't leave errors unhandled, your users will appreciate it.
* ☁️ Use a monitoring tool on your project.
* ❤️ Use Swift's `Error` protocol to get expressive and useful errors.
* 🙅‍♂️ Don't use `nil` as an error.
* 👨‍💻 Separate error validation and treatment from the actual functionality.

## What's next?

If you are interested in error handling, chapter 6 of *Clean Code from Robert C. Martin (a.k.a Uncle Bob)* is a must-read. This chapter was the biggest reference to this article, and it was what really drew my attention to the importance of handling errors. I consider this book a must-have for any software engineer, so you might as well [get it on Amazon](https://www.amazon.com.br/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882).

If you want to know more about `SRP` and the other `SOLID` principles, [this article from hackernoon](https://hackernoon.com/solid-principles-made-easy-67b1246bcdf) is a great light start. And [This repo from ochococo](https://github.com/ochococo/OOD-Principles-In-Swift) gives nice and easy examples and has links to in-depth articles that are really good reading.

Thank you for reading! I hope this is was insightful and that you can apply those ideas on your projects. Take care and good error handling!