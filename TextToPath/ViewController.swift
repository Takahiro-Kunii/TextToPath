//
//  ViewController.swift
//  TextToPath
//
//  Created by kunii on 2015/11/02.
//  Copyright © 2015年 國居貴浩. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let font = UIFont.systemFontOfSize(40, weight: 10.0)
        if let path = self.unicodeToCGPath(0x65, font:font) {   // 0x65 == UniChar("e".unicodeScalars.first!.value)
            
            //  ベジェ曲線を表示する専用レイヤーを用意
            let shape = CAShapeLayer()
            shape.path = path                           //  ベジェ曲線設定
            shape.frame = CGPathGetBoundingBox(path)    //  矩形設定（レイヤなので設定しなくても表示されるが…）
            
            //  サブレイヤーとして登録
            self.view.layer.addSublayer(shape)
            
            //  位置調整　ほぼ真ん中に配置
            shape.position = self.view.center
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //  指定したfontから、指定したunicodeに対応するCGPathを取り出す
    func unicodeToCGPath(var unicode:UniChar, font:UIFont) -> CGPath? {
        //  取り出しにはCore TextのAPIを使うのでUIFontではなくCTFontを用意しなければいけない
        let ctfont = CTFontCreateWithFontDescriptor(font.fontDescriptor(), font.pointSize, nil)
        
        //  CTFontが管理する文字形状（CGPath）群は、そのCTFont独自のインディックスで管理される
        //  このインディックスはCGGlyph型として定義されていて、指定したunicode列に対応するCGGlyph列を返すAPI
        //      CTFontGetGlyphsForCharacters
        //  を使い取り出せる
        var glyph:CGGlyph = 0               //  指定されたunicodeに対応するインディックス
        if CTFontGetGlyphsForCharacters(ctfont, &unicode, &glyph, 1) {
            //  インディックス（CGGlyph）が取り出せたので、これを指定して対応する文字形状（CGPath）を取り出す
            return CTFontCreatePathForGlyph(ctfont, glyph, nil)
        }
        
        //  インディックスが取り出せなかった（指定したフォントに、指定したunicodeの文字形状が用意されていない等）
        return nil  //  失敗
    }
}

