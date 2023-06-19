//
//  CameraAirDistanceViewController.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Cocoa

class CameraAirDistanceViewController: CameraBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.orange.cgColor
    }
    
}
