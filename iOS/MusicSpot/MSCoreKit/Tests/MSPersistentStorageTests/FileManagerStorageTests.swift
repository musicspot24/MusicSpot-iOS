//
//  MSPersistentStorageTests.swift
//  MSCoreKit
//
//  Created by 이창준 on 11/14/23.
//

import OSLog
import XCTest
@testable import MSPersistentStorage

final class MSPersistentStorageTests: XCTestCase {

    // MARK: Properties

    private let fileStorage = FileManagerStorage()

    // MARK: Functions

    // MARK: Internal

    // MARK: - Setup

    // MARK: - Test

    func test_StorageURL생성출력_항상성공() {
        guard let storageURL = fileStorage.storageURL() else {
            XCTFail("FileManagerStorage 디렉토리 URL 휙득에 실패했습니다.")
            return
        }
        os_log("\(storageURL)")
    }

    func test_FileURL생성출력_항상성공() {
        let key = UUID().uuidString
        guard let fileURL = fileStorage.fileURL(forKey: key) else {
            XCTFail("파일 디렉토리 URL 휙득에 실패했습니다.")
            return
        }
        os_log("\(fileURL)")
    }

    func test_StorageURL디렉토리_생성_성공() {
        guard let url = fileStorage.storageURL() else {
            XCTFail("FileManagerStorage 디렉토리 URL 휙득에 실패했습니다.")
            return
        }

        let result = fileStorage.createDirectory(at: url)
        switch result {
        case .success(let url):
            let parentURL = url
            let fileExists = fileStorage.fileExists(atPath: parentURL, isDirectory: true)
            XCTAssertFalse(fileExists, "디렉토리 생성에 실패했습니다: \(parentURL)")

        case .failure(let error):
            XCTFail("디렉토리 생성에 실패했습니다: \(error)")
        }
    }

    func test_StorageURL디렉토리_전체삭제_성공() throws {
        guard let url = fileStorage.storageURL() else {
            XCTFail("FileManagerStorage 디렉토리 URL 휙득에 실패했습니다.")
            return
        }
        fileStorage.createDirectory(at: url)

        try fileStorage.deleteAll()

        let fileExists = fileStorage.fileExists(atPath: url, isDirectory: true)
        XCTAssertFalse(fileExists, "디렉토리 전체 삭제 후에는 디렉토리가 존재하면 안됩니다.")
    }

    func test_StorageURL에_디렉토리가없을경우_생성_성공() throws {
        try fileStorage.deleteAll()

        guard let storageURL = fileStorage.storageURL(create: true) else {
            XCTFail("FileManagerStorage 디렉토리 URL 휙득에 실패했습니다.")
            return
        }

        let fileExists = fileStorage.fileExists(atPath: storageURL, isDirectory: true)
        XCTAssertFalse(fileExists, "storageURL(create: true)는 디렉토리가 존재하지 않을 경우 새로 생성해야 합니다.")
    }

    func test_FileManagerStorage에_데이터저장_성공() {
        let sut = MockCodableData(title: "boostcamp", content: "wm8")
        let key = "S045"

        let storedData = fileStorage.set(value: sut, forKey: key)
        XCTAssertNotNil(storedData, "데이터가 저장되지 않았습니다.")
    }

    func test_FileManagerStorage에서_데이터로드_성공() {
        let sut = MockCodableData(title: "boostcamp", content: "wm8")
        let key = "S045"
        fileStorage.set(value: sut, forKey: key)

        guard let storedData = fileStorage.get(MockCodableData.self, forKey: key) else {
            XCTFail("데이터 읽기에 실패했습니다.")
            return
        }

        XCTAssertEqual(
            sut,
            storedData,
            "목표 데이터와 불러온 값이 다릅니다.")
    }

    func test_FileManagerStorage에서_모든데이터저장불러오기_성공() {
        let sut1 = MockCodableData(title: "boostcamp", content: "wm8")
        let sut2 = MockCodableData(title: "boostcamp", content: "wm8")
        let key1 = "S045"
        let key2 = "S034"

        fileStorage.set(value: sut1, forKey: key1)
        fileStorage.set(value: sut2, forKey: key2)

        guard let allStoredData = fileStorage.getAllOf(MockCodableData.self) else {
            XCTFail("데이터 읽기에 실패했습니다.")
            return
        }

        XCTAssertEqual(allStoredData.count, 2, "데이터 저장에 실패하였습니다.")
        XCTAssertTrue(allStoredData.allSatisfy { $0 == sut1 || $0 == sut2 })
    }

    func test_FileManagerStorage에서_모든데이터저장불러올때_폴더하위항목까지_읽을수있는지_실패() {
        let sut1 = MockCodableData(title: "boostcamp", content: "wm8")
        let sut2 = MockCodableData(title: "boostcamp", content: "wm8")
        let key1 = "S045"
        let key2 = "/handsome/jeonmingun/S034"

        fileStorage.set(value: sut1, forKey: key1)
        fileStorage.set(value: sut2, forKey: key2)

        guard let allStoredData = fileStorage.getAllOf(MockCodableData.self) else {
            XCTFail("데이터 읽기에 실패했습니다.")
            return
        }

        XCTAssertEqual(allStoredData.count, 2, "데이터 저장에 실패하였습니다.")
        XCTAssertFalse(allStoredData.allSatisfy { $0 == sut1 || $0 == sut2 })
    }

    func test_Date형식_저장할_수_있는지_성공() {
        let sut = Date.now
        let key = "S034"

        fileStorage.set(value: sut, forKey: key)

        guard let storedData = fileStorage.get(Date.self, forKey: key) else {
            XCTFail("데이터 읽기에 실패했습니다.")
            return
        }

        XCTAssertEqual(
            sut.description,
            storedData.description,
            "목표 데이터와 불러온 값이 다릅니다.")
    }

    // MARK: Private

}
