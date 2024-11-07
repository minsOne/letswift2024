//
//  PaymentPlugin.swift
//  SampleApp
//
//  Created by minsOne on 11/3/24.
//

import WebKit

struct PaymentPluginInfo
{
    let uuid: String
    let paymentAmount: Int
    let paymentTransactionId: String
    let paymentId: String
    let paymentGoodsName: String
}

final class PaymentPluginKey:
    JSPluginKey,
    JSPluginKeyType
{
    typealias Value = PaymentPluggable
}

protocol PaymentPluggable: JSInterfacePluggable
{
    typealias Info = PaymentPluginInfo
    
    func set(
        _ closure: @escaping (Info, WKWebView) -> Void)
}

final class PaymentPlugin:
    ScanJSPlugin,
    PaymentPluggable,
    JSInterfacePluggable
{
    typealias KeyType = PaymentPluginKey
    let action = "payment"
    
    func callAsAction(_ message: [String: Any],
                      with: WKWebView)
    {}
    
    func set(
        _ closure: @escaping (Info, WKWebView) -> Void)
    {
        self.closure = closure
    }
    
    private var closure: ((Info, WKWebView) -> Void)?
}
