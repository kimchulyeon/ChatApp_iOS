//
//  Publisher+Ext.swift
//  ChatApp
//
//  Created by chulyeon kim on 11/14/23.
//

import Combine

extension Publisher {
    // cooltime : 새로운 데이터를 발행하기 전에 기다려야하는 시간 간격
    // scheduler : 시간을 관리하고 작업을 스케쥴링하는 객체
    func coolDown<S: Scheduler>(for cooltime: S.SchedulerTimeType.Stride,
                                scheduler: S) -> some Publisher<Self.Output, Self.Failure> {
        
        // self는 현재 Publisher를 가리킨다, Publisher가 데이터를 scheduler(지정한 스레드나 큐)에서 처리하도록 한다
        return self.receive(on: scheduler)
            // .scan 연산자는 이전 값과 새 값을 결합하여 누적 결과를 생성
            // 초기값은 (S.SchedulerTimeType?.none, Self.Output?.none) : (nil, nil) : (마지막으로 데이터가 발행된 시간, 마지막으로 발행된 데이터)
            .scan((S.SchedulerTimeType?.none, Self.Output?.none)) {
                // eventTime : 현재 시간
                let eventTime = scheduler.now
                // .minimumTolerance : 스케쥴러가 작업을 수행할 때 허용하는 최소 시간 차이
                let minimumTolerance = scheduler.minimumTolerance
                // $0은 (S.SchedulerTimeType?, Self.Output?)인 이전의 누적된 결과 (마지막으로 데이터가 발행된 시간, 마지막으로 발행된 데이터)
                // lastSentTime : 마지막을 데이터가 발행된 사간을 확인,
                guard let lastSentTime = $0.0 else {
                    // $1은 클로저에 전달되는 새로운 값
                    // 이전 데이터가 발행되지 않았다면 현재 이벤트 시간과 값을 반환
                    return (eventTime, $1)
                }
                // 현재시간과 마지막 데이터 발행된 시간 차이
                let diff = lastSentTime.distance(to: eventTime)
                
                // 시간 차이가 cooltime보다 크면 마지막으로 데이터가 발행된 시간을 유지
                guard diff >= (cooltime - minimumTolerance) else {
                    // 시간 차이가 cooltime 보다 작으면 새 값을 무시
                    return (lastSentTime, nil)
                }
                // 현재 시간과 새 값을 반환
                return (eventTime, $1)
            }
            .compactMap { $0.1 }
    }
}
