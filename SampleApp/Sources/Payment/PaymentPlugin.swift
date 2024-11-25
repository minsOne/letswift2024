//
//  PaymentPlugin.swift
//  SampleApp
//
//  Created by minsOne on 11/3/24.
//

import WebKit

final class PaymentPlugin:
    ScanJSPlugin,
    PaymentPluggable,
    JSInterfacePluggable {
    typealias KeyType = PaymentPluginKey
    let action = "payment"

    func callAsAction(_ message: [String: Any], with webView: WKWebView) {
        guard
            let result = Parser(message)
        else { return }

        closure?(result.info, webView)
    }

    func set(_ closure: @escaping (Info, WKWebView) -> Void) {
        self.closure = closure
    }

    private var closure: ((Info, WKWebView) -> Void)?
}

private extension PaymentPlugin {
    struct Parser {
        let info: Info

        init?(_ dictonary: [String: Any]) {
            guard
                let uuid = dictonary["uuid"] as? String,
                let body = dictonary["body"] as? [String: Any],
                let paymentAmount = body["paymentAmount"] as? Int,
                let paymentTransactionId = body["paymentTransactionId"] as? String,
                let paymentId = body["paymentId"] as? String,
                let paymentGoodsName = body["paymentGoodsName"] as? String
            else { return nil }

            info = .init(
                uuid: uuid,
                paymentAmount: paymentAmount,
                paymentTransactionId: paymentTransactionId,
                paymentId: paymentId,
                paymentGoodsName: paymentGoodsName
            )
        }
    }
}
