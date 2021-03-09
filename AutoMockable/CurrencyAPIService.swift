//
//  CurrencyAPIService.swift
//  AutoMockable
//
//  Created by Vadim Bulavin on 09.03.2021.
//

import Foundation

struct CurrencyDTO: Codable, Equatable {
    let currencyCode: String
    let country: String
    let currencyName: String
    let countryCode: String
}

class RealCurrenciesAPIService {
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

extension URLRequest {
    static func allCurrencies() -> URLRequest {
        let rawPath = "https://gist.githubusercontent.com/V8tr/b8d3e63f7d987d3298cc83c9362f1c6e/raw/ad3f8f697835ec2dbd9a36779f84ffed9911c8aa/currencies.json"
        guard let url = URL(string: rawPath) else { fatalError() }
        return URLRequest(url: url)
    }
}
