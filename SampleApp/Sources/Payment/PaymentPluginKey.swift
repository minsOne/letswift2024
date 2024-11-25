//
//  PaymentPluginKey.swift
//  SampleApp
//
//  Created by minsOne on 11/25/24.
//


import WebKit

struct PaymentPluginInfo {
    let uuid: String
    let paymentAmount: Int
    let paymentTransactionId: String
    let paymentId: String
    let paymentGoodsName: String
}

final class PaymentPluginKey:
    JSPluginKey,
    JSPluginKeyType {
    typealias Value = PaymentPluggable
}

protocol PaymentPluggable: JSInterfacePluggable {
    typealias Info = PaymentPluginInfo

    func set(_ closure: @escaping (Info, WKWebView) -> Void)
}
