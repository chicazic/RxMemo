//
//  TransitionModel.swift
//  RxMemo
//
//  Created by 송형욱 on 2020/10/05.
//

import Foundation

enum TransitionStyle {
    case root
    case push
    case modal
}

enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
