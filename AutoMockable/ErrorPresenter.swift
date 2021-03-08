//
//  ErrorPresenter.swift
//  AutoMockable
//
//  Created by Vadim Bulavin on 08.03.2021.
//

import Foundation

//sourcery: AutoMockable
protocol ErrorPresenter {
    func showError(_ error: Error)
}
