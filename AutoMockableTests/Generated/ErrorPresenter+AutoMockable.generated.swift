// Generated using Sourcery 1.3.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable all

import UIKit
@testable import AutoMockable

class ErrorPresenterMock: ErrorPresenter {

    //MARK: - showError

    var showErrorCallsCount = 0
    var showErrorCalled: Bool {
        return showErrorCallsCount > 0
    }
    var showErrorReceivedError: Error?
    var showErrorReceivedInvocations: [Error] = []
    var showErrorClosure: ((Error) -> Void)?

    func showError(_ error: Error) {
        showErrorCallsCount += 1
        showErrorReceivedError = error
        showErrorReceivedInvocations.append(error)
        showErrorClosure?(error)
    }

}
