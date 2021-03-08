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
