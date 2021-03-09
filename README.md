## Article related to this project

- [Code Generating Swift Mocks with Sourcery](https://www.vadimbulavin.com/mocking-in-swift-using-sourcery/)
- [Unit Testing Asynchronous Code in Swift](https://www.vadimbulavin.com/unit-testing-async-code-in-swift/)

---

# AutoMockable

The project demonstrates how to code generate Swift mocks using [Sourcery](https://github.com/krzysztofzablocki/Sourcery).

### Usage

Annotate the protocol you want to mock:

```swift
//sourcery: AutoMockable
protocol HTTPClient {
    func execute(
        request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}
```

Then build your Xcode project test target. During the build phase, Sourcery will generate `HTTPClient+AutoMockable.generated.swift` that is ready for use in your tests.

### Sample test

Given `CurrenciesAPIService` that we want to test:

```swift
final class CurrenciesAPIService {
    private let httpClient: HTTPClient

    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    func allCurrencies(completion: @escaping (Result<[CurrencyDTO], Error>) -> Void) {
        httpClient.execute(request: .allCurrencies()) { result in
            completion(
                result.flatMap { data in Result { try JSONDecoder().decode([CurrencyDTO].self, from: data) }}
            )
        }
    }
}
```

And a generated `HTTPClientMock`:

```swift
// Generated using Sourcery 1.3.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable all

import UIKit
@testable import AutoMockable

class HTTPClientMock: HTTPClient {

    //MARK: - execute

    var executeRequestCompletionCallsCount = 0
    var executeRequestCompletionCalled: Bool {
        return executeRequestCompletionCallsCount > 0
    }
    var executeRequestCompletionReceivedArguments: (request: URLRequest, completion: (Result<Data, Error>) -> Void)?
    var executeRequestCompletionReceivedInvocations: [(request: URLRequest, completion: (Result<Data, Error>) -> Void)] = []
    var executeRequestCompletionClosure: ((URLRequest, @escaping (Result<Data, Error>) -> Void) -> Void)?

    func execute(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        executeRequestCompletionCallsCount += 1
        executeRequestCompletionReceivedArguments = (request: request, completion: completion)
        executeRequestCompletionReceivedInvocations.append((request: request, completion: completion))
        executeRequestCompletionClosure?(request, completion)
    }

}
```

The unit tests look like:

```swift
import Foundation
import XCTest
@testable import AutoMockable

class CurrenciesAPIServiceTests: XCTestCase {

    let httpClient = HTTPClientMock()
    lazy var sut = CurrenciesAPIService(httpClient: httpClient)

    func test_allCurrencies_withResponseFailure_returnsOriginalError() throws {
        httpClient.executeRequestCompletionClosure = { _, completion in
            completion(.failure(DummyError()))
        }

        var result: Result<[CurrencyDTO], Error>?

        sut.allCurrencies { result = $0 }

        XCTAssertThrowsError(try result?.get()) { err in
            XCTAssertEqual(err.localizedDescription, "DummyError")
        }
    }

    func test_allCurrencies_withResponseSuccess_returnsValidData() throws {
        let expected = CurrencyDTO(
            currencyCode: "A",
            country: "B",
            currencyName: "C",
            countryCode: "D"
        )
        let data = try JSONEncoder().encode([expected])
        httpClient.executeRequestCompletionClosure = { _, completion in
            completion(.success(data))
        }

        var result: Result<[CurrencyDTO], Error>?

        sut.allCurrencies { result = $0 }

        XCTAssertEqual(try result?.get(), [expected])
    }
}

struct DummyError: LocalizedError {
    var errorDescription: String? {
        return "DummyError"
    }
}
```
