//
//  DataSource.swift
//  SwiftUnicodePicker
//
//  Created by Claes Wihlborg on 2021-03-19.
//

/*
 The MIT License (MIT)

 Copyright (c) 2021 Claes Wihlborg

 Permission is hereby granted, free of charge, to any person obtaining a copy of this
 software and associated documentation files (the "Software"), to deal in the Software
 without restriction, including without limitation the rights to use, copy, modify,
 merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
 persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or
 substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
 BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


import Foundation


typealias UnicodeTableIndex = Int

struct UnicodeTableRow: Identifiable {
    var id:Int
    static var idGenerator = 0
    let base: UInt32
    let segment: BlockTableIndex
    let chars: [UInt32]
    init(_ base: UInt32, _ segment: BlockTableIndex, _ chars: [UInt32]) {
        self.id = UnicodeTableRow.idGenerator
        UnicodeTableRow.idGenerator += 1
        self.base = base
        self.segment = segment
        self.chars = chars
    }
}


typealias BlockTableIndex = Int

typealias BlockTableRow = (offset: Int, title: String)


struct MyDataSource {
    let unicodeTable: [UnicodeTableRow]
    let blockTable: [BlockTableRow]
    let specialCodepoints: [UInt32:String]
    let otherCharacters: Set<UInt32>
    init(_ unicodeTable: [UnicodeTableRow],
         _ blockTable: [BlockTableRow],
         _ specialCodepoints: [UInt32:String],
         _ otherCharacters: Set<UInt32>) {
        self.unicodeTable = unicodeTable
        self.blockTable = blockTable
        self.specialCodepoints = specialCodepoints
        self.otherCharacters = otherCharacters
    }
    init() {
        self.unicodeTable = []
        self.blockTable = []
        self.specialCodepoints = [:]
        self.otherCharacters = Set()
    }
}




func dumpUTLine(rad: UnicodeTableRow, blockTable: [BlockTableRow]) {
    if rad.base == 0 {
        print(String(format:"%4d ***** ", rad.segment) + blockTable[rad.segment].title)
    }
    else {
        let format = rad.base < 0x10000 ? "%4d  %04X " : "%4d %5X "
        print("\(String(format: format, rad.segment, rad.base))   ", separator: "", terminator: "")
        for r in rad.chars {
            print(" \(r) ", separator: "", terminator: "")
        }
        print("")
    }
}


func dumpDataSource(_ source: MyDataSource) {
    print("##########  Segment table  (\(source.blockTable.count) entries)  ##########")
    for block in source.blockTable {
        print(String(format: " %4d ", block.offset) + block.title)
    }

    print("\n##########  Allowed Characters  (\(source.unicodeTable.count) entries)  ##########")
    for r in source.unicodeTable {
        dumpUTLine( rad: r, blockTable: source.blockTable )
    }
}


func createDataSource(heads: [cpSlice], others: [cpSlice], specials: [UInt32:String]) -> MyDataSource {
    var unicodeTable: [UnicodeTableRow] = []
    var blockTable: [BlockTableRow] = []
    var otherCharacters: Set<UInt32> = .init()
    let codepoints: [cpSlice] = (heads + others)//.sorted(by: {$0.low < $1.low})

    var currentBlock = -1
    var currentBase: UInt32 = 16
    var currentChars: [UInt32] = []
    for slice in codepoints {
        for r in slice.low...slice.hgh {
            let base = r & 0xfffff0
            var newRow = (base != currentBase)
            let newSeg = (currentBlock == -1) || (r > unicodeBlocks[currentBlock].last) || (r < unicodeBlocks[currentBlock].first)
            if (newRow || newSeg) && (currentBlock != -1) {
                unicodeTable.append(UnicodeTableRow(currentBase, blockTable.count-1, currentChars))
                newRow = true
            }
            if newSeg {
                currentBlock = -1
                repeat {
                    currentBlock += 1
                } while r > unicodeBlocks[currentBlock].last
                blockTable.append(BlockTableRow(unicodeTable.count, unicodeBlocks[currentBlock].name))
                unicodeTable.append(UnicodeTableRow(0, blockTable.count-1, []))
            }
            if newRow {
                currentBase = base
                currentChars = [0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0]
            }
            currentChars[Int(r & 15)] = r
        }
    }
    unicodeTable.append(UnicodeTableRow(currentBase, blockTable.count - 1, currentChars))

    for slice in others {
        for r in slice.low...slice.hgh {
            otherCharacters.insert(r)
        }
    }

    let source = MyDataSource(unicodeTable, blockTable, specials, otherCharacters)
    return source
}


let operatorDataSource = createDataSource(heads: operatorHeadSlices,
                                          others: operatorSlices,
                                          specials: operatorSpecialCodepoints)

let identifierDataSource = createDataSource(heads: identifierHeadSlices,
                                            others: identifierSlices,
                                            specials: identifierSpecialCodepoints)
