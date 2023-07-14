//
//  CameraBaseViewController.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Cocoa

class CameraBaseViewController: NSViewController {

    var mMetalView : MetalView!
    var name : String { preconditionFailure() }
    var Id : CameraType
    {
        /*preconditionFailure("This method must be overridden")*/
        return .MagniLink
    }
    
    override func loadView() {
        view = MetalView()
        guard let mv = view as? MetalView else {
            return
        }
        mv.setup()
        mMetalView = view as? MetalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func nextNatural()
    {
        guard let camera = EUCModel.shared.cameras.first(where:{ $0.name == name }) else {
            return
        }
        
        let grayscale = camera.nextNatural()
        mMetalView.setNatural(grayscale: grayscale)
    }
    
    func nextPositive()
    {
        guard let camera = EUCModel.shared.cameras.first(where:{ $0.name == name }) else {
            return
        }
        guard let colors = camera.nextPositive() else {
            return
        }
        
        mMetalView.setArtificial(backColor: colors.backColor, foreColor: colors.foreColor)
    }
    
    func nextNegative()
    {
        guard let camera = EUCModel.shared.cameras.first(where:{ $0.name == name }) else {
            return
        }
        guard let colors = camera.nextNegative() else {
            return
        }
        
        mMetalView.setArtificial(backColor: colors.backColor, foreColor: colors.foreColor)
    }
    
}
