//
//  UserDefaults.swift
//  GR
//
//  Created by 中森えみり on 2021/03/29.
//

import Foundation


class UserDefaultsEX: UserDefaults {
    
    //Element = 要素、Codable = プロトコル(型)
    //JSONEncoderを用いてエンコード(Data型へ変換)→Userdefaultsへセット
    func set<Element: Codable>(value: Element, forKey key: String) {
            let data = try? JSONEncoder().encode(value)
            UserDefaults.standard.setValue(data, forKey: key)

    
    }

    //Element = 要素、Codable = プロトコル(型)
    //JSONDecoderを用いてデコード(Data型を構造体へ変換)
    func codable<Element: Codable>(forKey key: String) -> Element? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        let element = try? JSONDecoder().decode(Element.self, from: data)
        return element
    }
}
