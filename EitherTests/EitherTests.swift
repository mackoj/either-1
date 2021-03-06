//
//  EitherTests.swift
//  EitherTests
//
//  Created by Kevin McGladdery on 6/6/17.
//  Copyright © 2017 Kevin McGladdery. All rights reserved.
//

import XCTest
import Either

class EitherTests: XCTestCase {
    
    struct User {
        let name: String
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLeftandRight() {
        let testUser = User(name: "Montgomery Scott")
        
        let user: Either<String, User> = .right(testUser)
        let failure: Either<String, User> = .left("No such user")
        
        XCTAssertTrue(Either.isRight(user))
        XCTAssertTrue(Either.isLeft(failure))
        XCTAssertFalse(Either.isLeft(user))
        XCTAssertFalse(Either.isRight(failure))
    }
    
    func testLeftsandRights() {
        let user1: Either<String, String> = .right("James Kirk")
        let user2: Either<String, String> = .right("William Riker")
        let failure: Either<String, String> = .left("No such user")
        let list: [Either<String, String>] = [user1, user2, failure]
        
        XCTAssertEqual(Either.rights(list).count, 2)
        XCTAssertEqual(Either.lefts(list).count, 1)
    }
    
    func testRightValue() {
        let testUser = User(name: "Montgomery Scott")
        let data: Either<String, User> = .right(testUser)
        
        XCTAssertEqual(data.rightValue()!.name, "Montgomery Scott")
    }
    
    func testLeftValue() {
        let data: Either<String, User> = .left("no such user")
        
        XCTAssertEqual(data.leftValue()!, "no such user")
    }
    
    func testMap() {
        let data: Either<String, String> = .right("James Kirk")
        let result = data.map { name in User.init(name: name) }
        
        switch(result) {
        case let .right(user): XCTAssertEqual(user.name, "James Kirk")
        default: fatalError()
        }
    }
    
    func testMapOnLefts() {
        let data: Either<String, Int> = .left("a terrible error")
        let result = data.map { n in n + n }
        
        switch(result) {
        case let .left(str): XCTAssertEqual(str, "a terrible error")
        default: fatalError()
        }
    }
    
    static func flatMapTest(str:String) -> Either<String, [String]> {
        return .right([str, "and another string"])
    }
    
    func testFlatmap() {
        let e: Either<String, String> = .right("whatever")
        let result = e.flatMap(EitherTests.flatMapTest)
        
        switch result {
        case let .right(arr): XCTAssertEqual(["whatever", "and another string"], arr)
        default: fatalError()
        }
    }
    
    func testFlatmapOnLefts() {
        let e: Either<String, String> = .left("whatever")
        let result = e.flatMap(EitherTests.flatMapTest)
        
        switch result {
        case let .left(error): XCTAssertEqual("whatever", error)
        default: fatalError()
        }
    }
    
    func testFlatmapOperator() {
        let e: Either<String, String> = .right("whatever")
        let result = e >>- EitherTests.flatMapTest
        
        switch result {
        case let .right(arr): XCTAssertEqual(["whatever", "and another string"], arr)
        default: fatalError()
        }
    }
}
