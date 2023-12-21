//
//  OCRDocument.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-11-10.
//

import Foundation

struct OCRRect
{
    var mRect : CGRect
    var mStart : Int
    var mLength : Int
}

class OCRCharData
{
    var character : Character = " "
    var rect : CGRect = CGRect()
    var blocknumber : Int = 0
}

class OCRBlock
{
    var mOcrData : [OCRCharData] = []
    var language : String = ""
    var rect : CGRect = CGRect()
    
    func calculateRect()
    {
        var maxX = 0.0;
        var maxY = 0.0;
        var minX = CGFloat.greatestFiniteMagnitude;
        var minY = CGFloat.greatestFiniteMagnitude;
        
        for char in mOcrData
        {
            minX = char.rect.minX < minX ? char.rect.minX : minX
            minY = char.rect.minY < minY ? char.rect.minY : minY
            maxX = char.rect.maxX > maxX ? char.rect.maxX : maxX
            maxY = char.rect.maxY > maxY ? char.rect.maxY : maxY
        }
        
        rect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    func getText() -> String
    {
        var result = ""
        
        for data in mOcrData {
            result.append(data.character)
        }
        
        return result
    }
    
    func getRectangles(start : Int, end : Int, count : Int) -> [OCRRect]
    {
        var result : [OCRRect] = []
        
        var maxX : CGFloat = 0
        var maxY : CGFloat = 0
        var minX = CGFloat.greatestFiniteMagnitude
        var minY = CGFloat.greatestFiniteMagnitude
        
        for i in start..<end {
            let d = mOcrData[i]
            
            if d.rect.minX < minX {
                minX = d.rect.minX
            }
            if d.rect.maxX > maxX {
                maxX = d.rect.maxX
            }
            
            if d.rect.minY < minY {
                minY = d.rect.minY
            }
            if d.rect.maxY > maxY {
                maxY = d.rect.maxY
            }
            
            if mOcrData.count > i + 1 {
                
                let d2 = mOcrData[i + 1]
                if (d2.rect.minX < d.rect.minX) {
                    
                    let rect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
                    let ocrRect = OCRRect(mRect: rect, mStart: count + start, mLength: end - start)
                    result.append(ocrRect)
                    maxX = 0
                    maxY = 0
                    minX = CGFloat.greatestFiniteMagnitude
                    minY = CGFloat.greatestFiniteMagnitude
                }
            }
        }
        
        let rect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        let ocrRect = OCRRect(mRect: rect, mStart: count + start, mLength: end - start)
        
        result.append(ocrRect)
        
        return result
    }
    
    func getWordRectangles(position : Int) -> [OCRRect]
    {
        var result : [OCRRect] = []
        
        if mOcrData.count > 0 {
            
            var startRect = false
            var start = 0
            var count = 0
            
            for data in mOcrData {
                
                let whiteSpace = data.character.isWhitespace
                
                if whiteSpace == false && startRect == false
                {
                    start = count
                    startRect = true
                }
                else if whiteSpace && startRect
                {
                    let rect = getRectangles(start: start, end: count, count: position)
                    result.append(contentsOf: rect)
                    startRect = false
                }
                count += 1
            }
        }
        
        return result
    }
}

class OCRPage : NSObject
{
    var mImage : NSImage?
    var mPixels : [UInt8]?
    var mBlocks : [OCRBlock] = []
    var mWordRects : [OCRRect] = []
    
    func getLength() -> Int
    {
        var count = 0
        
        for block in mBlocks {
            count += block.mOcrData.count
        }
        return count
    }
    
    func getText() -> String
    {
        var result = ""
        for block in mBlocks {
            result.append(block.getText())
        }
        
        return result
    }
    
    func getData(pos : Int) -> OCRCharData?
    {
        var p = pos
        if pos >= getLength() {
            p = getLength() - 1
        }
        var total = 0
        
        for block in mBlocks
        {
            total += block.mOcrData.count
            if p < total {
                
                let index = pos - (total - block.mOcrData.count)
                if index < 0 || index >= block.mOcrData.count {
                    return nil
                }
                
                return block.mOcrData[index]
            }
        }
        return nil
    }

    func getBlockPosition(number : Int) -> Int
    {
        var result = 0
        for i in 0..<number
        {
            if mBlocks.count > number {
                result += mBlocks[i].mOcrData.count
            }
        }
        return result
    }
    
    func getBlockNumber(pos : Int) -> Int
    {
        var count = 0
        var blockNumber = 0
        for block in mBlocks {
            count += block.mOcrData.count
            if count > pos {
                return blockNumber
            }
            blockNumber += 1
        }
        if blockNumber == mBlocks.count {
            return mBlocks.count - 1
        }
        return blockNumber
    }
    
    func getWordPosition(pos : Int) -> Int?
    {
        var index = pos
        while index >= 0
        {
            if let data = getData(pos: index)
            {
                if data.character.isWhitespace {
                    index += 1
                    return index
                }
            }
            index -= 1
        }
        return 0
    }
    
    func getWordPosition(pos : CGPoint) -> Int?
    {
        for rect in mWordRects {
            if rect.mRect.contains(pos) {
                return rect.mStart
            }
        }
        return nil
    }
    
    func getBlock(pos : Int) -> OCRBlock?
    {
        let nr = getBlockNumber(pos: pos)
        if nr >= 0 {
            return mBlocks[nr]
        }
        return nil
    }
    
    func getFirstWord() -> NSRange
    {
        var indexPos = 0
        var indexLength = 0
        let length = getLength()
        while indexPos < length
        {
            if let data = getData(pos: indexPos)
            {
                if data.character.isWhitespace == false {
                    break
                }
            }
            indexPos += 1
        }
        indexLength = indexPos
        while indexLength < length
        {
            if let data = getData(pos: indexLength)
            {
                if data.character.isWhitespace {
                    break
                }
            }
            indexLength += 1
        }
        return NSMakeRange(indexPos, indexLength - indexPos)
    }
    
    func getWordRectangles() -> [OCRRect]
    {
        var result : [OCRRect] = []
        var count = 0
        
        for block in mBlocks {
            
            let rect = block.getWordRectangles(position:  count)
            result.append(contentsOf: rect)
            count += block.mOcrData.count
        }
        
        return result
    }
    
    
    func getSelectedRectangles(range : NSRange) -> [CGRect]
    {
        let pos = range.location
        let length = range.length
        
        var result : [CGRect] = []
        
        var maxX = 0.0;
        var maxY = 0.0;
        var minX = CGFloat.greatestFiniteMagnitude;
        var minY = CGFloat.greatestFiniteMagnitude;
        for i in pos..<pos + length
        {
            let cdata = getData(pos: i)
            if let d = cdata
            {
                let r = d.rect
                if r.minX < minX {
                    minX = r.minX
                }
                if r.maxX > maxX {
                    maxX = r.maxX
                }

                if r.minY < minY {
                    minY = r.minY
                }
                if r.maxY > maxY {
                    maxY = r.maxY
                }
                
                let b = getBlock(pos: i)
                if b == nil {
                    return result
                }
                
                let d2 = getData(pos: i + 1)
                if let d2 = d2
                {
                    if d2.rect.minX < d.rect.minX
                    {
                        let newRect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
                        result.append(newRect)
                        maxX = 0.0;
                        maxY = 0.0;
                        minX = CGFloat.greatestFiniteMagnitude;
                        minY = CGFloat.greatestFiniteMagnitude;
                    }
                }
            }
        }
        let newRect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        result.append(newRect)
        
        return result
    }
}

class OCRDocument
{
    var mCurrentPage = 0
    var mPages : [OCRPage] = []
    
    func append(page : OCRPage)
    {
        mPages.append(page)
        page.mWordRects = page.getWordRectangles() //Bör snyggas till
    }
    
    func clear()
    {
        mPages.removeAll()
    }
    
    func getCurrent() -> OCRPage?
    {
        if 0 <= mCurrentPage && mCurrentPage < mPages.count {
            return mPages[mCurrentPage]
        }
        return nil
    }
    
    func next() -> OCRPage?
    {
        if mCurrentPage < mPages.count - 1 {
            mCurrentPage += 1
            return getCurrent()
        }
        return nil
    }
    
    func previous() -> OCRPage?
    {
        if mCurrentPage > 0 {
            mCurrentPage -= 1
            return getCurrent()
        }
        return nil
    }
    
    func goto(number :Int) -> OCRPage?
    {
        if number >= 0 && number < mPages.count && number != mCurrentPage
        {
            mCurrentPage = number
            return getCurrent()
        }
        return nil
    }
    
    func gotoLast() -> OCRPage?
    {
        if mPages.count > 0
        {
            mCurrentPage = mPages.count - 1
            return getCurrent()
        }
        return nil
    }
    
    func delete(number :Int) -> OCRPage?
    {
        if number >= 0 && number < mPages.count
        {
            mPages.remove(at: number)
            if mPages.count == 0 {
                mCurrentPage = 0
                return nil
            }
            
            else if number <= mCurrentPage && mCurrentPage != 0 {
                mCurrentPage -= 1
            }
            
            return getCurrent()
        }
        return nil
    }
}
