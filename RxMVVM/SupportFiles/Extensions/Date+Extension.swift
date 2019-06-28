//
//  Date+Extension.swift
//  RxMVVM
//
//  Created by Bheem Singh on 28/06/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import Foundation

extension Date{
    // Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
}
