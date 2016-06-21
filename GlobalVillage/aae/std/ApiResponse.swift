//
//  ApiResponse.swift
//  socipelago
//
//  Created by Axel Ancona Esselmann on 3/13/16.
//  Copyright © 2016 Axel Ancona Esselmann. All rights reserved.
//

import Foundation

public class ApiResponse {
    public var response: AnyObject? {
        didSet {
            if errorCode == -1 {
                errorMessage = ""
                errorCode    = 0
            }
        }
    }
    public var errorCode: Int = -1
    public var errorMessage: String = "Not Initialized"
}