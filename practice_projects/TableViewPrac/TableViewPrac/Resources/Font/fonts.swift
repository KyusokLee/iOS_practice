//
//  fonts.swift
//  TableViewPrac
//
//  Created by Kyus'lee on 2022/08/24.
//

import Foundation
import UIKit

// 원하는 Fonts를 다운받은 후, Xcode에서 사용하는 방법
// 참고 (reference): https://jerry-bakery.tistory.com/entry/iOS-%ED%8F%B0%ED%8A%B8-%EC%A0%81%EC%9A%A9%ED%95%98%EB%8A%94-%EB%B2%95

// 1. 원하는 곳에서 폰트를 다운
// 2. 다운 파일을 열고, 서체 다운
// 3. 서체 관리자에서 다운받은 폰트를 finder에서 열고, otf파일을 입수
// 4. otf파일을 원하는 프로젝트에 드래그해서 넣기
// 5. info.plist에 추가한 폰트를 명시해주기
// 6. information property list에서 Fonts provided by application을 추가
// 7. 추가한 item의 value에 확장자 파일명까지 정확히 입력
// 8. 폰트를 적용시키기 위새 xcode에서 폰트가 어떤 이름으로 되어있느지 확인
// 확인방법

//for family in UIFont.familyNames {
//    print(family)
//
//    for sub in UIFont.fontNames(forFamilyName: family) {
//        print("=====> \(sub)")
//    }
//}

// 9. 등록된 font이름을 원하는 곳에서 사용함으로서, 폰트 적용시키기 완료!
