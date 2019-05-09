//
//  Extensions.swift
//  MoneyBalance
//
//  Created by liza_kaganskaya on 4/28/19.
//  Copyright © 2019 liza_kaganskaya. All rights reserved.
//

import Foundation

extension Date {
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMM")
        return df.string(from: self)
    }
func monthAsNumber() -> String {
    let df = DateFormatter()
    df.setLocalizedDateFormatFromTemplate("MM")
    return df.string(from: self)
}}


