//
//  CurrenciesAPIServiceTests.swift
//  AutoMockableTests
//
//  Created by Vadim Bulavin on 09.03.2021.
//

import Foundation
import XCTest
@testable import AutoMockable

class CurrenciesAPIServiceTests: XCTestCase {

    let httpClient = HTTPClientMock()
    lazy var sut = CurrenciesAPIService(httpClient: httpClient)

    func test_allCurrencies_createsCorrectRequest() {
        sut.allCurrencies { _ in () }

        XCTAssertEqual(httpClient.executeRequestCompletionReceivedArguments?.request, .allCurrencies())
    }

    func test_allCurrencies_withMalformedData_returnsError() throws {
        httpClient.executeRequestCompletionClosure = { _, completion in
            completion(.success(Data()))
        }

        var result: Result<[CurrencyDTO], Error>?

        sut.allCurrencies { result = $0 }

        XCTAssertThrowsError(try result?.get())
    }

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
