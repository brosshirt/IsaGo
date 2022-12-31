//
//  genLib.swift
//  front-end
//
//  Created by Benjamin Rosshirt on 12/30/22.
//

import Foundation


extension String {
    func substring(start: Int, end: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(startIndex, offsetBy: end - start)
        return String(self[startIndex..<endIndex])
    }
}
