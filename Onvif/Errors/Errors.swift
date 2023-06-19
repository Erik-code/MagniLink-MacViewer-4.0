//
//  File.swift
//  
//
//  Created by Johannes Bergman on 2021-04-01.
//

import Foundation

enum CameraControllerError : Error {
    case licenseNotFound
    case mediaProfileNotConfiguredProperly
    case unknownError
}

enum NetworkError: Error {
    case errorResponse(error: Error)
    case emptyResponse
    case unknownResponse
    case parserError(error: Error)
    case gotSoapFault(soapFault: SoapFault)
}

enum DeviceError : Error {
    case missingCapabilities
}

enum OnvifError : Error {
    case soapFault(soapFault: SoapFault)
    case parseError
}
