//
//  PagesNumberLabel.swift
//  MagniLink Viewer
//
//  Created by Erik Sandstrom on 2022-12-09.
//


//class PagesNumberLabel: NSLabel {
//
//    private let mWidth : CGFloat = 150.0
//    private let mHeight : CGFloat = 75.0
//    private let mMargin : CGFloat = 5.0
//    
//    init() {
//
//        super.init(frame: CGRect(x: 0, y: 0, width: mWidth, height: mHeight))
//        backgroundColor = .black
//        textColor = .white
//        textAlignment = .center
//        layer.borderColor = UIColor.white.cgColor
//        layer.borderWidth = 3.0
//        font = UIFont(name: "Avenir", size: 50)
//        
//        setText(text: "0/0")
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//    
//    func update()
//    {
//        guard let width = superview?.bounds.width ,let height = superview?.bounds.height else {
//            return
//        }
//        
//        self.frame = CGRect(x: (width - mWidth) - mMargin, y: mMargin, width: mWidth, height: mHeight)
//    }
//    
//    func setText(text : String)
//    {
//        self.text = text
//    }
//}
