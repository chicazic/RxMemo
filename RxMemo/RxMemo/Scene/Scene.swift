//
//  Scene.swift
//  RxMemo
//
//  Created by 송형욱 on 2020/10/05.
//

import UIKit
// 앱에서 구현할 Scene 열거형
enum Scene {
    // Scene과 연관된 뷰모델을 연관값으로 구현
    case list(MemoListViewModel)
    case detail(MemoDetailViewModel)
    case compose(MemoComposeViewModel)
}
// 스토리보드에 있는 scene을 생성
// 연관값에 저장된 뷰모델을 바인딩해서 리턴하는 메소드 구현
extension Scene {
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        // 메모목록 씬을 생성
        // 뷰모델 바인딩해서 리턴
        case .list(let viewModel):
            // 설정된 storyboard ID 넣기
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else {
                fatalError()
            }
            guard var listVC = nav.viewControllers.first as? MemoListViewController else {
                fatalError()
            }
            // 뷰모델은 네비게이션 컨트롤러에 인베이드 되어있는 루트뷰컨트롤러에 바인딩
            listVC.bind(viewModel: viewModel)
            // 리턴시에는 네비게이션컨트롤러를 리턴한다
            return nav
        // 상세보기 씬을 생성
        case .detail(let viewModel):
            guard var detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else {
                fatalError()
            }
            
            detailVC.bind(viewModel: viewModel)
            return detailVC
        case .compose(let viewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else {
                fatalError()
            }
            guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else {
                fatalError()
            }
            
            composeVC.bind(viewModel: viewModel)
            return nav
        }
        
    }
}
