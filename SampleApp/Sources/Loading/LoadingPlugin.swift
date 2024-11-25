//
//  LoadingPlugin.swift
//  SampleApp
//
//  Created by minsOne on 11/3/24.
//

import WebKit

final class LoadingPlugin:
    ScanJSPlugin,
    LoadingPluggable,
    JSInterfacePluggable
{
    typealias KeyType = LoadingPluginKey
    let action = "loading"

    func callAsAction(_ message: [String: Any],
                      with webView: WKWebView)
    {
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

private extension LoadingPlugin {
    struct Parser {
        let info: Info

        init?(_ dictonary: [String: Any]) {
            guard
                let uuid = dictonary["uuid"] as? String,
                let body = dictonary["body"] as? [String: Any],
                let isShown = body["isShown"] as? Bool
            else { return nil }

            info = .init(uuid: uuid, isShown: isShown)
        }
    }
}
