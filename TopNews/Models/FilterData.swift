//
//  FilterData2.swift
//  TopNews
//
//  Created by Ilya Maier on 22.10.2020.
//  Copyright © 2020 mera. All rights reserved.
//

import Foundation

let noFilterIndex = -1

struct FilterData {
    var country = 41;//ru
    var category = noFilterIndex
    var keywords = ""
    var pageSize = 10

    static func countries() -> [String] {
        let allCountries = "ae ar at au be bg br ca ch cn co cu cz de eg fr gb gr hk hu id ie il in it jp kr lt lv ma mx my ng nl no nz ph pl pt ro rs ru sa se sg si sk th tr tw ua us ve za"
        return allCountries.split(separator: " ").map { (subStr) -> String in
            String(subStr)
        }
    }
    static func categories() -> [String] {
        let allCountries = "business entertainment general health science sports technology"
        return allCountries.split(separator: " ").map { (subStr) -> String in
            String(subStr)
        }
    }

}
