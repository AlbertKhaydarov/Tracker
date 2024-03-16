//
//  YandexMobileService.swift
//  Tracker
//
//  Created by Альберт Хайдаров on 16.03.2024.
//

import Foundation

import YandexMobileMetrica

final class YandexMetricaService {
    static let shared = YandexMetricaService()

    private init() {
        guard let configuration = YMMYandexMetricaConfiguration(
            apiKey: "6760e66d-fa79-4693-8fe6-34884a72e579") else {
            return
        }
        YMMYandexMetrica.activate(with: configuration)
    }

    func sendReport(about event: String, and item: String?, on screen: String) {
        let params: [AnyHashable: Any] = ["event": event, "item": item ?? "", "screen": screen]
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { (error) in
            print("DID FAIL REPORT EVENT: %@")
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
