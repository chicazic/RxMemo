//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by 송형욱 on 2020/10/04.
//

import UIKit

// protocol 선언을 추가
class MemoListViewController: UIViewController, ViewModelBindableType {
    //필수 멤버 추가 (이렇게 형식 추가하고 메모리스트 뷰 모델로 선언)
    var viewModel: MemoListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // 비어있는 바인드 뷰 모델 메소드 추가
    func bindViewModel() {
        
    }
}
