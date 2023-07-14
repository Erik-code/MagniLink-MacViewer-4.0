//
//  ColorModels.swift
//  MagniLink Viewer
//
//  Created by Erik Sandstrom on 2022-09-22.
//

import Foundation
import SwiftUI

enum ColorType : CaseIterable{
    case natural
    case artificial
    case positive
    case negative
    
    init(value : Int)
    {
        let allCases = type(of: self).allCases
        self = allCases[value]
    }
    
    func intValue() -> Int
    {
        let allCases = type(of: self).allCases
        return allCases.firstIndex(of: self)!
    }
}

struct ColorManager
{
    init()
    {
        self.init(aValue: 0x1)
    }
    
    init(aValue : Int)
    {
        artificialColorIndex = aValue & 0xF
        positiveColorIndex = (aValue & 0xF0) >> 4
        negativeColorIndex = (aValue & 0xF00) >> 8
        colorType = ColorType(value: (aValue & 0x3000) >> 12)
        grayscale = (aValue & 0x4000) != 0
    }
    
    var intValue : Int
    {
        get{
            var result = artificialColorIndex & 0xF
            result |= positiveColorIndex << 4
            result |= negativeColorIndex << 8
            result |= colorType.intValue() << 12
            result |= (grayscale ? 0x1 : 0x0) << 14
            return result
        }
    }
    
    var artificialColorIndex = 1
    var positiveColorIndex = 0
    var negativeColorIndex = 0
    var colorType = ColorType.natural
    var grayscale = false
}

protocol ColorModelDelegate : AnyObject
{
//    func swiftUIPressed(model: ColorModel)
    func colorTrianglePressed(model: ColorModel)
}

class ColorModel : ObservableObject, Hashable
{
    static func == (lhs: ColorModel, rhs: ColorModel) -> Bool {
        lhs.hash == rhs.hash
    }
    var delegate : ColorModelDelegate?
    
    @Published var backColor : Color
    @Published var foreColor : Color
    @Published var positive : Bool
    @Published var negative : Bool
    var left = true
    var hash = Double.random(in: 0...1)
    
    func rightPressed()
    {
        left = false
        delegate?.colorTrianglePressed(model: self)
    }
    
    func leftPressed()
    {
        left = true
        delegate?.colorTrianglePressed(model : self)
    }
    
    init(backColor: Color, foreColor: Color, positive: Bool, negative: Bool) {
        self.backColor = backColor
        self.foreColor = foreColor
        self.positive = positive
        self.negative = negative
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(hash)
    }
}

class CameraColorModel : ObservableObject, Equatable, Hashable
{
    @Published var colors : [ColorModel]
    @Published var grayscale : Bool = true
    @State var name : String
    
    var changedFlag = false
    
    var localizedName : String
    {
        get{
            return NSLocalizedString(name, comment: "")
        }
    }

    var colorManager = ColorManager()
    
    init(name : String, colors: [ColorModel]) {
        self.colors = colors
        self.name = name
    }
    
    var positiveColor : ColorModel?
    {
        get
        {
            if colorManager.positiveColorIndex < 0 || colorManager.positiveColorIndex >= colors.count {
                return nil
            }
            return colors[colorManager.positiveColorIndex]
        }
    }
    
    var negativeColor : ColorModel?
    {
        get
        {
            if colorManager.negativeColorIndex < 0 || colorManager.negativeColorIndex >= colors.count {
                return nil
            }
            let color = colors[colorManager.negativeColorIndex]
            return ColorModel(backColor: color.foreColor, foreColor: color.backColor, positive: true, negative: true)
        }
    }
    
    var artificialColor : ColorModel?
    {
        get
        {
            let pos = colorManager.artificialColorIndex % 2 == 1
            let index = (colorManager.artificialColorIndex - 1) / 2
            if (pos)
            {
                //colorManager.colorType = .positive
                colorManager.positiveColorIndex = index
                return positiveColor
            }
            else
            {
                //colorManager.colorType = .negative
                colorManager.negativeColorIndex = index
                return negativeColor
            }
        }
    }
    
    func setNaturalColor(grayscale : Bool)
    {
        colorManager.colorType = .natural
        colorManager.grayscale = grayscale
    }
    
    func setArtificial(aIndex: Int) -> ColorModel
    {
        let pos = aIndex % 2 == 1
        colorManager.artificialColorIndex = aIndex;
        let index = (aIndex - 1) / 2;
        if (pos)
        {
            colorManager.colorType = .positive
            colorManager.positiveColorIndex = index;
            return colors[colorManager.positiveColorIndex]
        }
        else
        {
            colorManager.colorType = .negative
            colorManager.negativeColorIndex = index;
            return colors[colorManager.negativeColorIndex];
        }
    }
    
    func nextNatural() -> Bool
    {
        if grayscale == false {
            colorManager.grayscale = false
        }
        
        if (colorManager.colorType != .natural)
        {
            colorManager.colorType = .natural
            return colorManager.grayscale
        }
        else if grayscale {
            colorManager.grayscale = !colorManager.grayscale
        }
        
        return colorManager.grayscale;
    }
    
    func nextPositive() -> ColorModel?
    {
        return positiveHelp(aDir: 1)
    }

    func previousPositive() -> ColorModel?
    {
        return positiveHelp(aDir: -1)
    }

    func nextNegative() -> ColorModel?
    {
        return negativeHelp(aDir: 1)
    }

    func previousNegative() -> ColorModel?
    {
        return negativeHelp(aDir: -1)
    }

    func nextArtificial() -> ColorModel?
    {
        return artificialHelp(aDir: 1)
    }

    func previousArtificial() -> ColorModel?
    {
        return artificialHelp(aDir: -1)
    }
    
    func artificialHelp(aDir : Int) -> ColorModel?
    {
        if colorManager.colorType == .natural
        {
            colorManager.colorType = .artificial
        }
        else
        {
            repeat
            {
                colorManager.artificialColorIndex = (colorManager.artificialColorIndex + colors.count * 2 + 1 + aDir) % (colors.count * 2 + 1)
                if colorManager.artificialColorIndex == 0 {
                    colorManager.artificialColorIndex = 1
                }

            } while ((colorManager.artificialColorIndex % 2 == 1 && colors[(colorManager.artificialColorIndex - 1) / 2].positive) ||
                      (colorManager.artificialColorIndex % 2 == 0 && colors[(colorManager.artificialColorIndex - 1) / 2].negative)) == false
        }
        return artificialColor
    }

    func getNumberOfPositives() -> Int
    {
        var count = 0
        for model in colors
        {
            if model.positive
            {
                count+=1
            }
        }
        return count
    }

    func getNumberOfNegatives() -> Int
    {
        var count = 0
        for model in colors
        {
            if model.negative
            {
                count+=1
            }
        }
        return count
    }

    func positiveHelp(aDir : Int) -> ColorModel?
    {
        let nrPositives = getNumberOfPositives()
        if nrPositives > 0
        {
            if colorManager.colorType != .positive
            {
                colorManager.colorType = .positive
            }
            else if nrPositives > 1
            {
                repeat
                {
                    colorManager.positiveColorIndex = (colorManager.positiveColorIndex + colors.count + aDir) % colors.count

                } while colors[colorManager.positiveColorIndex].positive != true
            }
            return colors[colorManager.positiveColorIndex]
        }
        return nil;
    }

    func negativeHelp(aDir : Int) -> ColorModel?
    {
        let nrNegatives = getNumberOfNegatives()
        if (nrNegatives > 0)
        {
            if colorManager.colorType != .negative
            {
                colorManager.colorType = .negative
            }
            else if nrNegatives > 1
            {
                repeat
                {
                    colorManager.negativeColorIndex = (colorManager.negativeColorIndex + colors.count + aDir) % colors.count;

                } while colors[colorManager.negativeColorIndex].negative != true
            }
            return negativeColor
        }
        return nil;
    }
    
    func add()
    {
        if colors.count < 6 {
            changedFlag = true
            let model = ColorModel(backColor: Color(red: 1.0, green: 1.0, blue: 1.0),
                                   foreColor: Color(red: 0.0, green: 0.0, blue: 0.0), positive: true, negative: true)
            
            model.delegate = colors.first?.delegate
            
            colors.append(model)
            CameraModel.shared.objectWillChange.send()
        }
    }
    
    func remove(model : ColorModel)
    {
        if colors.count > 1 {
            changedFlag = true
            colors.removeAll(where: { $0 == model} )
        }
    }
    
    func standard()
    {
        changedFlag = true
        let delegate = colors.first?.delegate
        let model = CameraColorModel.createStandardColors(name: name)
        colors = model.colors
        for color in colors {
            color.delegate = delegate
        }
        CameraModel.shared.objectWillChange.send()
    }

    static func createStandardColors(name : String) -> CameraColorModel
    {
        var colors = [ColorModel]()
        
        let red = Color(red: 1.0, green: 0.0, blue: 0.0)
        let green = Color(red: 0.0, green: 1.0, blue: 0.0)
        let blue = Color(red: 0.0, green: 0.0, blue: 1.0)
        let white = Color(red: 1.0, green: 1.0, blue: 1.0)
        let black = Color(red: 0.0, green: 0.0, blue: 0.0)
        let yellow = Color(red: 1.0, green: 1.0, blue: 0.0)
        
        colors.append(ColorModel(backColor: white, foreColor: black, positive: true, negative: true))
        colors.append(ColorModel(backColor: yellow, foreColor: black, positive: true, negative: true))
        colors.append(ColorModel(backColor: green, foreColor: black, positive: true, negative: true))
        colors.append(ColorModel(backColor: red, foreColor: black, positive: true, negative: true))
        colors.append(ColorModel(backColor: yellow, foreColor: blue, positive: true, negative: true))
        colors.append(ColorModel(backColor: white, foreColor: blue, positive: true, negative: true))
    
        let camera = CameraColorModel(name: name, colors: colors)
        return camera
    }
    
    static func createForCameraFromSettings(name: String) -> CameraColorModel
    {
        let cameraArray = Preferences.shared.artificialColors[name]
        
        if let array = cameraArray
        {
            var colors = [ColorModel]()
            
            for i in 0..<array.count/2
            {
                let backColor = Color(color: array[2*i])
                let foreColor = Color(color: array[2*i+1])
                let positive = (array[2*i+1] & 0x1000000) != 0
                let negative = (array[2*i+1] & 0x2000000) != 0
                
                colors.append(ColorModel(backColor: backColor, foreColor: foreColor, positive: positive, negative: negative))
            }
            let camera = CameraColorModel(name: name, colors: colors)
            return camera
        }
        return CameraColorModel.createStandardColors(name: name)
    }
    
    func saveToSettings()
    {
        saveColorManager()
        
        var settingsColors = Preferences.shared.artificialColors
        
        var array = [Int]()
        for i in 0..<colors.count {
            
            let back = colors[i].backColor.intValue
            var fore = colors[i].foreColor.intValue
            
            if colors[i].positive {
                fore = fore | (0x1 << 24)
            }
            if colors[i].negative {
                fore = fore | (0x1 << 25)
            }
            
            array.append(back)
            array.append(fore)
        }
        settingsColors[name] = array
        Preferences.shared.artificialColors = settingsColors
    }
    
    func saveColorManager()
    {
        var colors = Preferences.shared.colorManagers
        colors[name] = colorManager.intValue
        Preferences.shared.colorManagers = colors
    }
    
    static func == (lhs: CameraColorModel, rhs: CameraColorModel) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

