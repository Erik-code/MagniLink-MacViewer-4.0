//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-23.
//

import Foundation

@objcMembers public class IntSetting : NSObject {
    public private(set) var value: Int
    public private(set) var min: Int
    public private(set) var max: Int
    
    private override init() {
        self.value = 0
        self.min = 0
        self.max = 0
        
        super.init()
    }
    
    public convenience init(value: Int, min: Int, max: Int) {
        self.init()
        
        self.value = value
        self.min = min
        self.max = max
    }
}
