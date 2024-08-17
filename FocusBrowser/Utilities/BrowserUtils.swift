//
//  BrowserUtils.swift
//  MyBrowser
//
//  Created by John Choi on 11/19/22.
//  Copyright © 2022 John Choi. All rights reserved.
//

import Foundation

extension String {
    func searchToken() -> String {
        let substrings = self.split(separator: " ")
        var returnVal = ""
        for i in 0..<substrings.count {
            returnVal += String(substrings[i])
            if i != substrings.count - 1 {
                returnVal += "+"
            }
        }
        return returnVal
    }
}
