//
//  String+Extension.swift
//  RxMVVM
//
//  Created by Bheem Singh on 27/06/19.
//  Copyright © 2019 Bheem Singh. All rights reserved.
//

import Foundation

extension String {
    func maxLength(length: Int) -> String {
        var str = self
        let nsString = str as NSString
        if nsString.length >= length {
            str = nsString.substring(with:
                NSRange(
                    location: 0,
                    length: nsString.length > length ? length : nsString.length)
            )
        }
        return  str
    }
    
}
