//
//  LoadingPlugin.swift
//  SampleApp
//
//  Created by minsOne on 11/3/24.
//

import WebKit

struct LoadingPluginInfo
{
    let uuid: String
    let isShow: Bool
}

final class LoadingPluginKey:
    JSPluginKey,
    JSPluginKeyType
{
    typealias Value = LoadingPluggable
    var key: String { "loading" }
}

protocol LoadingPluggable: JSInterfacePluggable
{
    typealias Info = LoadingPluginInfo
    
    func set(
        _ closure: @escaping (Info, WKWebView) -> Void)
}

final class LoadingPlugin:
    ScanJSPlugin,
    LoadingPluggable,
    JSInterfacePluggable
{
    typealias KeyType = LoadingPluginKey
    let action = "loading"
    
    func callAsAction(_ message: [String: Any],
                      with: WKWebView) {}
    func set(
        _ closure: @escaping (Info, WKWebView) -> Void)
    {
        self.closure = closure
    }
    
    private var closure: ((Info, WKWebView) -> Void)?
}
