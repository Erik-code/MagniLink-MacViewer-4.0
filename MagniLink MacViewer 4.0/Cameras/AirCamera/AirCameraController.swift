//
//  AirCameraController.swift
//  MagniLink Viewer
//
//  Created by Erik Sandstrom on 2023-03-02.
//

import Foundation

class AirCameraController
{
    var mCameraController : CameraController?
    
    public func createAsync(ip: String) async throws -> CameraController {
        return try await withCheckedThrowingContinuation { continuation in
            CameraController.create(ip: ip) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func getStreamSettingsAsync() async throws -> StreamSettings {
        return try await withCheckedThrowingContinuation { continuation in
            mCameraController!.getStreamSettings() { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func setQualityAsync(quality: Float) async throws -> Void {
        return try await withCheckedThrowingContinuation { continuation in
            mCameraController!.setQuality(quality: quality) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func setFrameRateAsync(frameRate: Int) async throws -> Void {
        return try await withCheckedThrowingContinuation { continuation in
            mCameraController!.setFrameRate(frameRate: frameRate) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func setResolutionAsync(width: Int, height: Int) async throws -> Void {
        return try await withCheckedThrowingContinuation { continuation in
            mCameraController!.setResolution(width: width, height: height) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    func configurePresetsAsync() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            mCameraController!.configurePresets() { result in
                continuation.resume(with: result)
            }
        }
    }
}
