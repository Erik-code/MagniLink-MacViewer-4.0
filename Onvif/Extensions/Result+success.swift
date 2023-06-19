//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-01.
//

internal extension Result where Success == Void {
    static func success() -> Self { .success(()) }
}
