//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by 송형욱 on 2020/10/05.
//

import Foundation
import RxSwift

// 프로토콜 선언
// 씬코디네이터가 공통적으로 구현해야되는 멤버를 구현

protocol SceneCoordinatorType {
    // 새로운 씬을 표시
    // 파라미터로 대상 씬과 트렌지션스타일 애니메이션플래그를 전달
    @discardableResult
    func transition(to scene: Scene, Using style: TransitionStyle, animated: Bool) -> Completable
    // 현재 씬을 닫고 이전 씬으로 돌아감
    @discardableResult
    func close(animated: Bool) -> Completable
    
    // Completable 여기에 구독자를 추가하고 화면전환이 완료된 후에 원하는 작업을 구현가능
    // @discardableResult 를 추가해서 리턴형을 선언하지 않는다는 경고는 생성 X
}
