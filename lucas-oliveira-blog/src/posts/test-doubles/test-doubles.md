# Writing good tests with Tests Doubles

Writing unit tests is one of the key responsibilities of a developer. Although writing a test is not that hard, setting up a controlled environment where you can unit test one component might be challenging, especially if your component is surrounded by legacy code. Setting up testing doubles is a winner technique to tackle this problem.

If you are starting out on unit tests, you may already face issues like testing passing on your machine, and failing on your teammate's, or tests randomly failing without you making any changes related to the tests. And if you never faced issues like that, eventually, you will. Frequently those problems are due to the component that you are testing directly or indirectly depending on a resource that might change over executions, like responses from network requests, DataBase state, UserDefaults state, or even variables of a singleton.

Let's take a look at this example:

```swift
// This label is part of my ViewController. If the user already registered its name, this label
// should greet by the name, else, it will greet the user as Guest.
class ViewController: UIViewController {
    var greetingsLabel = UILabel()

    func configure() {
        let userName = UserData().getUserName() ?? "Guest"
        greetingsLabel.text = "Hello, \(userName)!"
    }
    /*
        More code here...
    */
}

// And this is our UserData class, it saves and gets the user name from UserDefaults.

class UserData {
    func saveUserName(name: String) {
        UserDefaults.standard.setValue(name, forKey: "USER_NAME")
    }

    func getUserName() -> String? {
        UserDefaults.standard.string(forKey: "USER_NAME")
    }
}

// Now we will unit test the logic of our ViewController

class ViewControllerTests: XCTestCase {
    func test_greetingsLabel_beforeSettingName_expectNameToBeGuest() {
        let sut = ViewController()

        sut.configure()

        XCTAssertEqual(sut.greetingsLabel.text, "Hello, Guest!")
    }

    func test_greetingsLabel_afterSettingName_expectNameToEqualsUserName() {
        let sut = ViewController()
        UserData().saveUserName(name: "John")

        sut.configure()

        XCTAssertEqual(sut.greetingsLabel.text, "Hello, John!")
    }
}
```

After writing this code, you can test them on the simulator, and it will work fine. You can run the tests, and they will pass, as they should. After asserting that the code works, you start working on your next feature, and when you execute the tests you will be taken by surprise as the test `test_greetingsLabel_beforeSettingName_expectNameToBeGuest` will fail, even if you didn't do any change to the label `greetingsLabel` on the `ViewController` or the data class `UserData`.

The test fails because the second time you execute this test, the simulator that you run your tests on has already saved the value "John" for the key `USER_NAME` on UserDefaults. This value is set on the second test (`test_greetingsLabel_afterSettingName_expectNameToEqualsUserName`). So instead of setting the text to "Hello, Guest!", it will set to "Hello, John!", therefore failing the test.

## What is a Test Double

In the movies, a stunt double is a professional that replaces the actor on interpreting a character in scenes of risky stunts, or highly demanding athletic skills. The stunt double should be similar enough to the actor to convince the audience and convey the idea that the character is doing the stunts in the movie. The idea of a test double is really similar: a test double is a class that replaces the desired class during tests.

Think about the example we just saw, where the tests failed after executing two times. A really nice way to solve our problem would be to somehow use the class `UserData` just on our app's "production" code, but when testing we would use a class just like `UserData`, but instead of getting information on UserDefaults, it could return whatever we want. So when testing the ViewController's label, we could set this class to return John, and assert that the text of the label is "Hello, John!", and on the next text set it to return nil, and assert that text is "Hello, Guest!". This way our test would not depend on UserDefaults and would be consistent for sure.

This is the concept of a test double, and the main way to achieve that is by creating a protocol that defines the methods that a `UserData` class should have.

```swift
protocol UserDataProtocol {
    func saveUserName(name: String)
    func getUserName() -> String?
}

// After creating the protocol, we make UserData conform to that protocol

class UserData: UserDataProtocol {
    func saveUserName(name: String) {
        UserDefaults.standard.setValue(name, forKey: "USER_NAME")
    }

    func getUserName() -> String? {
        UserDefaults.standard.string(forKey: "USER_NAME")
    }
}

// And we create the test double of UserData

class UserDataMock: UserDataProtocol {
    func saveUserName(name: String) {}

    var userNameToBeReturned: String?
    func getUserName() -> String? {
        return userNameToBeReturned
    }
}
```

Notice how we created a variable `userNameToBeReturned` to give us total control of what the method `getUserName` returns, and it does not depends on UserDefaults. The next step to solve the test problem is to make it possible to use `UserData` when running the app, and `UserDataMock` when testing.

## Dependency Inversion Principle

The Dependency Inversion Principle (`DIP`) is part of the `SOLID` set of good practices for Object-Oriented Design. The main idea of this principle is that your objects should depend on abstractions and not concrete implementations. And as in our last example, protocols are a good way of creating abstractions.

Depending on abstractions gives you a lot of flexibility to change the implementation of a component without propagating changes to its neighbors (the components that interact with it). And also the abstractions will help us to improve testability, as we can easily slip in a test double to replace a dependency at testing time.

Let's take a look at how we could make our `ViewController` stop depending on `UserData` and depending on the abstraction `UserDataProtocol` instead.

```swift
class ViewController: UIViewController {
    var greetingsLabel = UILabel()
    // Holding an instance of an object that implements UserDataProtocol
    let userData: UserDataProtocol

    // We set the default value of userData as a new instance of a UserData object by default
    // Doing it this way, it is important to remember to init this class passing a new instance
    // of UserDataMock when testing
    init(userData: UserDataProtocol = UserData()) {
        self.userData = userData
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        // Now instead of creating a UserData instance, and using it. We will use the
        // instance provided at init time, that could be the real UserData, or the
        // test double UserDataMock.
        let userName = userData.getUserName() ?? "Guest"
        greetingsLabel.text = "Hello, \(userName)!"
    }
}
```

Now that the `ViewController` is set up, let's rewrite the `ViewControllerTests` using test doubles to have a reliable test.

```swift
    func test_greetingsLabel_userNameIsNil_expectNameToBeGuest() {
        let userData = UserDataMock()
        // sets up UserDataMock to return nil when getUserName is called
        userData.userNameToBeReturned = nil
        // makes the ViewController use the test double
        let sut = ViewController(userData: userData)

        sut.configure()

        XCTAssertEqual(sut.greetingsLabel.text, "Hello, Guest!")
    }

    func test_greetingsLabel_userNameIsNotNil_expectNameToEqualsUserName() {
        let userData = UserDataMock()
        // sets up UserDataMock to return John when getUserName is called
        userData.userNameToBeReturned = "John"
        let sut = ViewController(userData: userData)

        sut.configure()

        XCTAssertEqual(sut.greetingsLabel.text, "Hello, John!")
    }
```

Finally, the `ViewControllerTest` is reliable, as the logic of `greetingsLabel` is isolated, and it does not depend on any external component.

## Final thoughts

To master the usage of test doubles, you have to master writing testable code, which requires a lot of practice writing code with bad testability and than improving it.

One thing to keep in mind is that you always have to decide which dependencies of your class can be decoupled from it, meaning that if the dependency change implementation, the class can continue working without changing as well. So on the class's tests, you can use test doubles to substitute every decoupled dependency, and test the class in a reliable and consistent environment, where you can easily test any scenario in a way that the tests will only fail if internal logic changes.

## Beyond this article

If you want to know more about `DIP` and the other `SOLID` principles, [this article from hackernoon](https://hackernoon.com/solid-principles-made-easy-67b1246bcdf) is a great light start. And [This repo from ochococo](https://github.com/ochococo/OOD-Principles-In-Swift) gives nice and easy examples and has links to in-depth articles that are really good reading.

If you want to know how to unit test asynchronous code, check out [my article about it](https://www.lucasoliveira.tech/#/post/async-tests).

## Thanks for reading!

Liked this content? Follow me on [Twitter](https://twitter.com/oliveira__lucas) and be the first to know about new articles. Suggestions, feedback, and corrections are always welcome.
