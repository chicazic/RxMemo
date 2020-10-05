//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by 송형욱 on 2020/10/05.
//

import Foundation
import RxSwift
import RxCocoa

// 씬코디네이터 클래스를 선언하고
// 프로토콜을 채용
class SceneCoordinator: SceneCoordinatorType {
    // 리소스 정리에 사용
    private let bag = DisposeBag()
    
    // 씬코디네이터는 화면전환을 담당
    // 윈도우 인스턴스와 현재 화면에 표시되어있는 씬을 가지고 있어야함
    private var window: UIWindow
    private var currentVC: UIViewController
    
    // 두 속성을 초기화하는 생성자를 추가
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    @discardableResult
    func transition(to scene: Scene, Using style: TransitionStyle, animated: Bool) -> Completable {
        // 전환결과를 방출할 서브젝트를 선언
        let subject = PublishSubject<Void>()
        
        // 씬을 생성해서 상수에 저장
        let target = scene.instantiate()
        
        // transition에 따라서 실제 결과 처리
        switch style {
        // root인 경우에는 루트뷰컨트롤러를 바꿔주면 됨
        case .root:
            currentVC = target
            window.rootViewController = target
            // 마지막부분 서브젝트 컴플리트 이벤트를 전달한다
            subject.onCompleted()
        // push는 네비게이션컨트롤러에 임베이드 되어있을때만 의미가 있음
        case .push:
            // 임베이드 확인하고 되어있지않다면 에러이벤트를 전달하고 중지
            guard let nav = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            // 만약 임베이드 되어있다면 씬을 푸쉬하고 컴플리트 이벤트를 전달
            nav.pushViewController(target, animated: animated)
            currentVC = target
            
            subject.onCompleted()
        // 마지막 모달에서는 씬을 프레젠트
        case .modal:
            currentVC.present(target, animated: animated) {
                // 컴플리티드 이벤트는 컴플리션에서 전달
                subject.onCompleted()
            }
            currentVC = target
        }
        // ignoreElements 연산자를 호출하면 completable로 변환되어 리턴됨
        return subject.ignoreElements()
    }
    // completable 을 직접 구현하는 방식으로 구현
    @discardableResult
    func close(animated: Bool) -> Completable {
        return Completable.create { [unowned self] completable in
            // 뷰컨트롤러가 모달방식으로 표현되어있다면 현재씬을 디스미스
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC
                    completable(.completed)
                }
            } else if let nav = self.currentVC.navigationController {
                // 네비게이션 스택에 푸쉬되어있다면 팝
                // 팝을 할수 없는 상황이라면 에러이벤트 호출 후 종료
                guard nav.popViewController(animated: animated) != nil else {
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            } else {
                // 나머지 경우에는 그냥 에러이벤트만 전달하고 종료
                completable(.error(TransitionError.unknown))
            }
            return Disposables.create()
        }
    }
}
