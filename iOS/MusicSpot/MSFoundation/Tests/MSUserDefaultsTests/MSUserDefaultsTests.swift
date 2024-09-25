//
//  MSUserDefaultsTests.swift
//  MSFoundation
//
//  Created by 이창준 on 11/14/23.
//

import MSUserDefaults
import XCTest

final class MSUserDefaultsTests: XCTestCase {

    // MARK: Properties

    // MARK: Private

    @UserDefaultsWrapped("sut", defaultValue: FakeCodableData(name: "Fake", number: 0))
    private var sut: FakeCodableData

    // MARK: Overridden Functions

    // MARK: Internal

    override func setUp() {
        UserDefaults.standard.removeObject(forKey: "sut")
    }

    // MARK: Functions

    func testUserDefaults_Wrapper를사용해_저장과로드_성공() {
        let fake = FakeCodableData(name: "MusicSpot", number: 231215)
        sut = fake

        XCTAssertTrue(
            sut.isEqual(to: fake),
            "UserDefaults로 저장한 값과 로드한 값이 일치하지 않습니다."
        )
    }

}
