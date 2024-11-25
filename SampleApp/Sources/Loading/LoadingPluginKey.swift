//
//  LoadingPluginKey.swift
//  SampleApp
//
//  Created by minsOne on 11/25/24.
//

import WebKit

final class LoadingPluginKey:
    JSPluginKey,
    JSPluginKeyType
{
    typealias Value = LoadingPluggable
    var key: String { "loading" }
}

struct LoadingPluginInfo {
    let uuid: String
    let isShown: Bool
}

protocol LoadingPluggable: JSInterfacePluggable {
    typealias Info = LoadingPluginInfo

    func set(_ closure: @escaping (Info, WKWebView) -> Void)
}
