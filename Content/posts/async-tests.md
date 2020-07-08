---
date: 2020-07-07 00:00
description: When you are starting out on testing your code, you might find asynchronous methods a little bit tricky to test. <br></br> But do not worry, *XCTestExpectation* got you covered if you want to assert that an async block *will* execute, or even assert that it *will not* execute.
---
# Testing asynchronous code

When you are starting out on testing your code, you might find asynchronous methods a little bit tricky to test.

But do not worry, `XCTestExpectation` got you covered if you want to assert that an async block **will** execute, or even assert that it **will not** execute.

In this post, I'll show you a really common case where you'll want to test an asynchronous method, and how to use `XCTestExpectation` to create an expectation that a block will be executed on the future, and how to create an inverted expectation to assert that a block will not be executed on the future.

## The use case

Let's say that you are creating a feature that displays information about an item that your app sells. This feature will download the item details from an endpoint on a server whenever the user selects an item from a list. Then you will get the item ID and make an HTTP request to this endpoint to retrieve the item details. But to be more efficient on data usage, you also should cache every item fetched, so if the user wants to see details of an item that was already cached, instead of fetching it from the endpoint, you'll return the cached item.

To achieve this goal, this feature will have an `ItemWorker` class. It's objective is to return an item, given an ID. This class will contain the mechanism to get the item from a cache through a `CacheRepository` or, request it to the endpoint using `Network`. 

This is a possible implementation of this class:

``` swift
final class ItemWorker {
    private let network: NetworkProtocol
    private let cache: CacheRepositoryProtocol
    
    init(
        network: NetworkProtocol = Network.shared,
        cache: CacheRepositoryProtocol = CacheRepository.shared
    ) {
        self.network = network
        self.cache = cache
    }
    
    func requestItem(withID id: String, completion: @escaping (Result<Item, Error>) -> Void) {
        // If the cache contains the item, return the item
        if let cachedItem: Item = cache.get(forKey: id) {
            completion(.success(cachedItem))
        } else {
            let request = ItemRequest.itemByID(id: id)
            // Request an item passing the ID
            network.request(request) { [weak self] (result: Result<Item, Error>) in
                if case let Result.success(item) = result {
                    // Cache the item if succeded
                    self?.cache.set(item: item, forKey: item.id)
                }
                // Return what was fetched
                completion(result)
            }
        }
    }
}
```

Notice on this example that `Network` and `CacheRepository` are **singletons**, but however, I didn't use their shared instance directly. I used a **Dependency injection** technique to make `ItemWorker` depend on protocols instead. So this way, when we test this class, we can create mocked-up classes that conform to `NetworkProtocol` and `CacheRepositoryProtocol` that give us full control to test any network scenario or cache state that we want. If you never heard of this concept, I highly recommend that you read [this definition from Martin Fowler](https://martinfowler.com/articles/injection.html#FormsOfDependencyInjection). Mastering dependency injection will take your testing abilities to a whole new level.

If you need a little bit more of context to understand my implementation of `ItemWorker`, you can see the definition of the `NetworkProtocol`, `CacheRepositoryProtocol`, `ItemRequest` and `Item` bellow.

```swift
protocol NetworkProtocol {
    func request<T: Codable>(_ request: NetworkRequest, completion: @escaping (Result<T, Error>) -> Void)
}

protocol CacheRepositoryProtocol {
    func get<T: Codable>(forKey: String) -> T?
    func set<T: Codable>(item: T, forKey: String)
}

enum ItemRequest: NetworkRequest {
    case itemByID(id: String)
}

struct Item: Codable {
    let id: String
    let name: String
}
```


## XCTExpectation

Now that we have an `ItemWorker` that meets the requirements, we should write a test to assert that the requirements are indeed met. Our worker class will fetch the `Item` from the network only if the `Item` is not cached.

First, we will define our test cases. I like to be really descriptive, using the function names to state what is being tested, and what should happen. So if in a future point of time this test fails, it is easy to understand what is broken.

``` swift
final class ItemWorkerTests: XCTestCase {
    // Sut means subject under test. It is what we are testing here.
    private lazy var sut = ItemWorker()
    
    func test_requestItem_itemIsNotCached_expectRequestingItem() {

    }
    
    func test_requestItem_itemIsCached_expectNotRequestingItem() {

    }
}
```

Then, we should mock-up `Network` and `CacheRepository`, because we can't have our test to rely on network availability or cache state on the testing device. A good test should always pass if the code is correct, and it should always fail if the code is incorrect.

``` swift
final class ItemWorkerTests: XCTestCase {
    let network = NetworkSpy()
    let cache = CacheRepositoryMock()
    private lazy var sut = ItemWorker(network: network, cache: cache)
    
    func test_requestItem_itemIsNotCached_expectRequestingItem() {

    }
    
    func test_requestItem_itemIsCached_expectNotRequestingItem() {

    }
}

final class NetworkSpy: NetworkProtocol {
    func request<T: Codable>(_ request: NetworkRequest, completion: @escaping (Result<T, Error>) -> Void) {

    }
}

final class CacheRepositoryMock: CacheRepositoryProtocol {
    var cachedObjectToBeReturned: Codable?
    
    func get<T: Codable>(forKey: String) -> T? {
        return cachedObjectToBeReturned as? T
    }
    
    func set<T: Codable>(item: T, forKey: String) {}
}
```

Note how I added the property `cachedObjectToBeReturned` to easily control a hypothetical scenario of the `CacheRepository` state.

Now we are ready to implement our test cases. Let's begin from the case where there is no cache, and `ItemWorker` should fetch it from the `Network`. And we'll do it using `XCTestExpectation`.

A `XCTestExpectation` is a promise that you are creating now to be fulfilled in the future (using `expectation.fulfill()`). It is meant to be used paired with the method `wait(for expectations: , timeout:)` that asserts that all the expectations are fulfilled in a given time interval. Take a look at the implementation of the first test case, so you can understand what that means. You can also read the [docs from Apple](https://developer.apple.com/documentation/xctest/asynchronous_tests_and_expectations/testing_asynchronous_operations_with_expectations).

``` swift
// First we adapted our mocked up Network to fulfill an expectation when something is requested
final class NetworkSpy: NetworkProtocol {
    var requestCompleteExpectation: XCTestExpectation?
    func request<T: Codable>(_ request: NetworkRequest, completion: @escaping (Result<T, Error>) -> Void) {
        requestCompleteExpectation?.fulfill()
    }
}

// ...
final class ItemWorkerTests: XCTestCase {
    // ...
    func test_requestItem_itemIsNotCached_expectRequestingItem() {
        // Creates an expectation that will be fulfilled once the item is requested
        let expectation = XCTestExpectation(description: "itemRequest")
        network.requestCompleteExpectation = expectation
        // Mock up a state where the cache doesn't have the requested item
        cache.cachedObjectToBeReturned = nil
        // Requests
        sut.requestItem(withID: "1234", completion: { _ in })
        // Waits for a second, if the expectation IS NOT fulfilled, fails
        wait(for: [expectation], timeout: 1)
    }
    // ...
}
```

The test above should pass, because:
- `CacheRepositoryMock` returns no item.
- `NetworkSpy` is called, fulfilling the expectation.
- The expectation that `wait` is waiting for, is fulfilled before the timeout of 1 second.

Now, to the test case where the `CacheRepository` does have the `Item` cached, and we should not request it from the `Network`, we will use the property `isInverted` from `XCTestExpectation`. This makes the expectation function the exact opposite way of a non-inverted one. This means that `wait(for expectations: , timeout:)` now asserts that the timeout expires before the expectation is fulfilled. For inverted expectations, if the expectation is fulfilled, the test fails. And this is perfect to assert that code is not executed in the future.

``` swift
final class ItemWorkerTests: XCTestCase {
    // ...
    func test_requestItem_itemIsCached_expectNotRequestingItem() {
        // Creates an expectation that will be fulfilled once the item is requested
        let expectation = XCTestExpectation(description: "itemRequest")
        // Set the expectation to inveted, meaning that we expect it to not be fulfilled
        expectation.isInverted = true
        network.requestCompleteExpectation = expectation
        cache.cachedObjectToBeReturned = Item(id: "1234", name: "Mac")
        
        sut.requestItem(withID: "1234", completion: { _ in })
        // Waits for a second, if the expectation IS fulfilled, fails
        wait(for: [expectation], timeout: 1)
    }
    // ...
}
```

The test above should pass, because:
- `CacheRepositoryMock` returns an item.
- The worker returns this item not calling `NetworkSpy`, so the expectation is never fulfilled.
- The 1 second timeout defined on the `wait` method expires.

## Pro tip: using reasonable timeouts

``` swift
wait(for: [expectation], timeout: 10)
```

In the code above, if the expectation is not inverted, and it is fulfilled in 1 second, the test will pass without actually waiting the whole 10 seconds. But on the other hand, if it is an inverted expectation, the test will take 10 seconds to end the assertion.

Having tests that take long to complete is harmful to your project. This is especially important if you work on a large enterprise app, where having tests that clutter the CI/CD machines, decreases team productivity and costs the company money.

Thank you for reading! I hope this is was an useful learning. Take care and good coding!