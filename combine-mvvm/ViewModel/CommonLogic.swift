//
//  CommonLogic.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/25.
//

import Foundation
import CoreGraphics

class CommonLogic {
    //이미지 사이즈 계산
    func calculateRatio(imageSize: CGSize, screenSize: CGSize) -> CGFloat {
        return imageSize.height * screenSize.width / imageSize.width
    }
}
