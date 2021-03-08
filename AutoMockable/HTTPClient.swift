//
//  HTTPClient.swift
//  AutoMockable
//
//  Created by Vadim Bulavin on 07.03.2021.
//

import Foundation

//sourcery: AutoMockable
protocol HTTPClient {
    func execute(
        request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}
