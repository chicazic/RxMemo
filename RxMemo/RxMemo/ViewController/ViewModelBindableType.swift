//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by 송형욱 on 2020/10/04.
//

import UIKit

protocol ViewModelBindableType {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}
// protocol extension 추가
// 뷰컨트롤러에 추가된 뷰모델 속성에 실제 뷰모델을 저장하고
// 바인드 뷰모델 메소드를 자동으로 호출하는 메소드 만들기
extension ViewModelBindableType where Self: UIViewController {
    // 이렇게 하면 개별 뷰 컨트롤러에서 바인드 뷰 모델 메소드를 직접 호출할 필요가 없기때문에
    // 그만큼 코드가 단순해짐
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        
        bindViewModel()
    }
}
