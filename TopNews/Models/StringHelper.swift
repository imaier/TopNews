//
//  StringHelper.swift
//  TopNews
//
//  Created by Ilya Maier on 28.10.2020.
//  Copyright © 2020 mera. All rights reserved.
//

import Foundation
/*
    https://stackoverflow.com/questions/32305891/index-of-a-substring-in-a-string-with-swift
 
    usage:

    let str = "abcde"
    if let index = str.index(of: "cd") {
        let substring = str[..<index]   // ab
        let string = String(substring)
        print(string)  // "ab\n"
    }
 
    let str = "Hello, playground, playground, playground"
    str.index(of: "play")      // 7
    str.endIndex(of: "play")   // 11
    str.indices(of: "play")    // [7, 19, 31]
    str.ranges(of: "play")     // [{lowerBound 7, upperBound 11}, {lowerBound 19, upperBound 23}, {lowerBound 31, upperBound 35}]
 
    case insensitive sample

    let query = "Play"
    let ranges = str.ranges(of: query, options: .caseInsensitive)
    let matches = ranges.map { str[$0] }   //
    print(matches)  // ["play", "play", "play"]
 
 */


extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}


extension String {

    func contains(subString string: String, options: String.CompareOptions = []) -> Bool {
        let subStringIndex = index(of: string, options: options) ?? endIndex
        return subStringIndex != endIndex
    }

}

