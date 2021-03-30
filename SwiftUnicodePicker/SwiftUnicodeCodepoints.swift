//
//  SwiftUnicodeCodepoints.swift
//  SwiftUnicodePicker
//
//  Created by Claes Wihlborg on 2021-03-21.
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

typealias cpSlice = (low: UInt32, hgh: UInt32)

let operatorHeadSlices: [cpSlice] = [
    (0x21,0x21), (0x25,0x26), (0x2A,0x2B), (0x2D,0x2F),
    (0x3C,0x3F), (0x5E,0x5E), (0x7C,0x7C), (0x7E,0x7E),
    (0x00A1,0x00A7),
    (0x00A9,0x00A9), (0x00AB,0x00AC), (0x00AE,0x00AE),
    (0x00B0,0x00B1), (0x00B6,0x00B6), (0x00BB,0x00BB), (0x00BF,0x00BF),
    (0x00D7,0x00D7), (0x00F7,0x00F7),
    (0x2016,0x2017), (0x2020,0x2027), (0x2030,0x203E),
    (0x2041,0x2053), (0x2055,0x205E),
    (0x2190,0x23E7), (0x23E9,0x23F3), (0x23F8,0x23FE),
    (0x2500,0x269C), (0x26A0,0x26B2), (0x26BD,0x26BE), (0x26C4,0x26C5),
    (0x26C8,0x26C8), (0x26CB,0x26CB), (0x26CE,0x26CF), (0x26D1,0x26D1),
    (0x26D3,0x26D4), (0x26E2,0x26E2), (0x26E9,0x26EA), (0x26F0,0x26F5),
    (0x26F7,0x26FA), (0x26FD,0x26FD),
    (0x2701,0x275E), (0x2761,0x2775),
    (0x2794,0x27CD), (0x27D0,0x2B4C), (0x2B50,0x2B55), (0x2B58,0x2B58),
    (0x2B60,0x2B65), (0x2B82,0x2B83), (0x2B90,0x2B91), (0x2B95,0x2B95),
    (0x2E00,0x2E18), (0x2E1A,0x2E31), (0x2E3A,0x2E3B), (0x2E40,0x2E41),
    (0x3001,0x3003), (0x3008,0x3020), (0x3030,0x3030)
]

let operatorSlices: [cpSlice] = [
    (0x0300,0x036F),
    (0x1DC0,0x1DCF), (0x1DD3,0x1DD9), (0x1DDB,0x1DE6), (0x1DFB,0x1DFB), (0x1DFE,0x1DFF),
    (0x20D0,0x20E1), (0x20E3,0x20F0),
    (0xFE20,0xFE2F),
]

let operatorSpecialCodepoints: [UInt32:String] = [
    0x21: "A postfix operator can't begin with !",
    0x26: "& can't be overloaded as prefix operator",
    0x2A: "/* and */ are reserved and can´t be overloaded",
    0x2D: "The token -> is reserved and can't be overloaded",
    0x2E: "A single dot can't be overloaded. Dots may only exist in compound operators starting with a dot",
    0x2F: "//, /*, */ are reserved and can´t be overloaded",
    0x3C: "< can't be overloaded as prefix operator",
    0x3D: "= can not be overloaded as is, only together with other characters",
    0x3E: "> can't be overloaded as postfix operator. Futhermore, the token -> is reserved and can't be overloaded",
    0x3F: "? can not be overloaded as is, only together with other characters. A postfix operator can't begin with ?",
]


let identifierHeadSlices: [cpSlice] = [
//    (0x0041, 0x005a), (0x005f, 0x005f), (0x0061, 0x007a),
//    (0x00a8, 0x00a8), (0x00aa, 0x00aa), (0x00ad, 0x00ad), (0x00af, 0x00af),
//    (0x00b2, 0x00b5), (0x00b7, 0x00ba), (0x00bc, 0x00be), (0x00c0, 0x00d6),
//    (0x00d8, 0x00f6), (0x00f8, 0x02ff), (0x0370, 0x086f), (0x08a0, 0x167f),
//    (0x1681, 0x1169f),
//    (0x1700,  0x180d), (0x180f, 0x1dbf), (0x1e00, 0x1fff), (0x200b, 0x200d),
//    (0x202a, 0x202e), (0x203f, 0x2040), (0x2054, 0x2054), (0x2070, 0x209F),
//    (0x2100, 0x218f), (0x2460, 0x24ff), (0x2776, 0x2793), (0x2c00, 0x2dff),
//    (0x2e80, 0x2fdf), (0x2ff0, 0x2fff), (0x3004, 0x3007), (0x3021, 0x302f),
//    (0x3031, 0xd7ff), (0xf900, 0xfb06), (0xfb13, 0xfb17), (0xfb1d, 0xfd3d),
//    (0xfd40, 0xfdcf), (0xfdf0, 0xfe1f), (0xfe30, 0xfe44), (0xfe47, 0xfffd),
//    (0x10100, 0x101ff), (0x10280, 0x103df), (0x10400, 0x1056f),
//    (0x10800, 0x108af), (0x108e0, 0x1093f),
//    (0x109a0, 0x10a9f), (0x10ac0, 0x10baf),
//    (0x10c00, 0x10c4f), (0x10c80, 0x10d3f), (0x10e60, 0x10ebf), (0x10f00, 0x10f6f),
//    (0x10fb0, 0x1124f), (0x11280, 0x1137f), (0x11400, 0x114df),
//    (0x11680, 0x116cf),
//    (0x11700, 0x1173f), (0x11800, 0x1184f), (0x118a0, 0x1195f), (0x119a0, 0x11aaf),
//    (0x11ac0, 0x11aff), (0x11c00, 0x11cbf), (0x11d00, 0x11daf), (0x11ee0, 0x11eff),
//    (0x11fb0, 0x11aff),
//    (0x14400, 0x1467f), (0x16800, 0x16a6f),
//    (0x16ad0, 0x16b8f), (0x16e40, 0x16e9f), (0x16f00, 0x16f9f), (0x16fe0, 0x18d08),
//    (0x1b000, 0x1b2ff), (0x1bc00, 0x1bcaf), (0x1d000, 0x1d24f), (0x1d2e0, 0x1d37f),
//    (0x1d400, 0x1daaf), (0x1e000, 0x1e02f), (0x1e100, 0x1e14f), (0x1e2c0, 0x1e2ff),
//    (0x1e800, 0x1e8df), (0x1e900, 0x1e95f), (0x1ec70, 0x1ecbf), (0x1ed00, 0x1ed4f),
//    (0x1ee00, 0x1eeff),
    (0x1f600, 0x1f64f), // Emoticons
    (0x1f90c, 0x1f93a), (0x1f93c, 0x1f945), (0x1f947, 0x1f978), (0x1f97a, 0x1f9cb),
    (0x1f9cd, 0x1f9ff), // Supplemental Symbols and Pictographs
    (0x1f300, 0x1f321), (0x1f324, 0x1f393), (0x1f396, 0x1f397), (0x1f399, 0x1f39b),
    (0x1f39e, 0x1f3f0), (0x1f3f3, 0x1f3f5), (0x1f3f7, 0x1f53d), (0x1f549, 0x1f54e),
    (0x1f550, 0x1f567), (0x1f56f, 0x1f570), (0x1f573, 0x1f57a), (0x1f587, 0x1f587),
    (0x1f58a, 0x1f58d), (0x1f590, 0x1f590), (0x1f595, 0x1f596), (0x1f5a4, 0x1f5a5),
    (0x1f5a8, 0x1f5a8), (0x1f5b1, 0x1f5b2), (0x1f5bc, 0x1f5bc), (0x1f5c2, 0x1f5c4),
    (0x1f5d1, 0x1f5d3), (0x1f5dc, 0x1f5de), (0x1f5e1, 0x1f5e1), (0x1f5e3, 0x1f5e3),
    (0x1f5e8, 0x1f5e8), (0x1f5ef, 0x1f5ef), (0x1f5f3, 0x1f5f3),
    (0x1f5fe, 0x1f5ff), // Miscellaneous Symbols And Pictographs
    (0x1f680, 0x1f6c5), (0x1f6cb, 0x1f6d2), (0x1f6d5, 0x1f6d7), (0x1f6e0, 0x1f6e5),
    (0x1f6e9, 0x1f6e9), (0x1f6eb, 0x1f6ec), (0x1f6f0, 0x1f6f0),
    (0x1f6f3, 0x1f6fc), // Transport and Map Symbols
    (0x1fa70, 0x1fa74), (0x1fa78, 0x1fa7a), (0x1fa80, 0x1fa86), (0x1fa90, 0x1faa8),
    (0x1fab0, 0x1fab6), (0x1fac0, 0x1fac2), (0x1fad0, 0x1fad6), // Symbols and Pictographs Extended-A
    (0x1f000, 0x1f02b), // Mah Jong
    (0x1f030, 0x1f093), // Domino
    (0x1f0a0, 0x1f0ae), (0x1f0b1, 0x1f0be), (0x1f0c1, 0x1f0cf),
    (0x1f0d1, 0x1f0df), // Cards
    (0x1f18e, 0x1f18f), (0x1f191, 0x1f19a), // Enclosed alphanumeric supplement
    (0x1f7e0, 0x1f7eb), // Geometric Shapes Extended

    (0x16a0, 0x16f8), // Futhark
    (0x10600, 0x10730), (0x10740, 0x10755), (0x10760, 0x10767), // Linear A
    (0x10000, 0x1000a), (0x1000d, 0x10026), (0x10028, 0x1003a), (0x1003c, 0x1003d),
    (0x1003f, 0x1004d), (0x10050, 0x1005d), // Linear B Syllabary
    (0x10080, 0x100fa), // Linear B Ideograms
    (0x10980, 0x1099f), // Meroitic Hieroglyphs
    (0x13000, 0x1342e), // Hieroglyphs
    (0x11580, 0x115dd), // Siddham
    (0x12000, 0x12399), // Cuneiform
    (0x20A0, 0x20bf), // Currency symbols

    //    (0x20000, 0x2a6df), (0x2a700, 0x2ebe0),
    //    (0x2f800, 0x2fa1f), (0x30000, 0x3134f),
    //    (0xe0000, 0xe007f), (0xe0100, 0xe01ef),
]

let identifierSlices: [cpSlice] = [
    (0x0030,0x0039),
    (0x0300,0x036F),
    (0x1DC0,0x1DCF), (0x1DD3,0x1DD9), (0x1DDB,0x1DE6), (0x1DFB,0x1DFB), (0x1DFE,0x1DFF),
    (0x20D0,0x20E1), (0x20E3,0x20F0),
    (0xFE20,0xFE2F)
]

let identifierSpecialCodepoints: [UInt32:String] = [
    :
]


func verifyCodepointsA(points:[cpSlice])->Bool {
    let sortedPoints = points.sorted(by: {$0.low < $1.low})
    // Chech that slices has content, don't overlap and are within UnicodeBlock
    var lastSlice: cpSlice = (0,0)
    var lastBlock: Int = 0
    var result = true
    for slice in sortedPoints {
        if slice.low <= lastSlice.hgh {
            result = false
            print(String(format: "Codepoint %04x is out of sequence", slice.low))
        }
        for point in slice.low...slice.hgh {
            while point > unicodeBlocks[lastBlock].last {
                lastBlock += 1
            }
            if point < unicodeBlocks[lastBlock].first {
                result = false
                print(String(format: "Codepoint %04x is not in block", point))
            }
        }
        lastSlice = slice
    }
    return result
}

func verifyCodepointsB(special: [UInt32:String], head: [cpSlice])->Bool {
    // Check that special codepoints are also in head
    var result = true
    loop:    for point in special.keys {
        for slice in head {
            if point >= slice.low && point <= slice.hgh {
                break loop
            }
        }
        result = false
        print(String(format: "Special codepoint %04x is not in head", point))
    }
    return result
}

func verifyCodepoints()->Bool {
    let opS: [cpSlice] = (operatorHeadSlices + operatorSlices)
    let b1 = verifyCodepointsA(points: opS)
    let b5 = verifyCodepointsB(special: operatorSpecialCodepoints, head: operatorHeadSlices)
    print("verifying Operator Codepoints finished result = \(b1 && b5)")
    let idS: [cpSlice] = (identifierHeadSlices + identifierSlices)
    let b3 = verifyCodepointsA(points: idS)
    let b6 = verifyCodepointsB(special: identifierSpecialCodepoints, head: identifierHeadSlices)
    print("verifying Identifier Codepoints finished result = \(b3 && b6)")
    let result = b1 && b3 && b5 && b6
    return result
}

