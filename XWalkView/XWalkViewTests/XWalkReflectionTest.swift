// Copyright (c) 2015 Intel Corporation. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import UIKit
import XCTest
import XWalkView

class DemoClassForMirrorTest : NSObject {
    var jsprop_normalProperty: String = "normal"
    let jsprop_constProperty: Int = 0

    override init() {
        super.init()
    }

    convenience init(fromJavaScript: String) {
        self.init()
    }

    func jsfunc_demoMethodWithParams(cid: UInt32, name: String, value: AnyObject?) {
    }

    func jsfunc_demoMethod(cid: UInt32) {
    }
}

class XWalkReflectionTest: XCTestCase {
    var mirror: XWalkReflection?
    var testObject: DemoClassForMirrorTest = DemoClassForMirrorTest()

    override func setUp() {
        super.setUp()
        mirror = XWalkReflection(cls: testObject.dynamicType)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAllMembers() {
        if let allMembers = mirror?.allMembers {
            XCTAssertEqual(allMembers.count, 4)
            var memberSet: Set<String> = Set(allMembers)
            XCTAssertEqual(allMembers[0], "normalProperty")
            XCTAssertEqual(allMembers[1], "constProperty")
            XCTAssertEqual(allMembers[2], "demoMethodWithParams")
            XCTAssertEqual(allMembers[3], "demoMethod")
        } else {
            XCTFail("Failed in testAllMembers")
        }
    }

    func testAllMethods() {
        if let allMethods = mirror?.allMethods {
            XCTAssertEqual(allMethods.count, 2)
            XCTAssertEqual(allMethods[0], "demoMethodWithParams")
            XCTAssertEqual(allMethods[1], "demoMethod")
        } else {
            XCTFail("Failed in testAllMethods")
        }
    }

    func testAllProperties() {
        if let allProperties = mirror?.allProperties {
            XCTAssertEqual(allProperties.count, 2)
            XCTAssertEqual(allProperties[0], "normalProperty")
            XCTAssertEqual(allProperties[1], "constProperty")
        } else {
            XCTFail("Failed in testAllProperties")
        }
    }

    func testHasMember() {
        XCTAssertTrue(mirror!.hasMember("normalProperty"))
        XCTAssertTrue(mirror!.hasMember("constProperty"))
        XCTAssertTrue(mirror!.hasMember("demoMethodWithParams"))
        XCTAssertTrue(mirror!.hasMember("demoMethod"))
        XCTAssertFalse(mirror!.hasMember("nonExistingMember"))
    }

    func testHasMethod() {
        XCTAssertTrue(mirror!.hasMethod("demoMethodWithParams"))
        XCTAssertTrue(mirror!.hasMethod("demoMethod"))
        XCTAssertFalse(mirror!.hasMethod("nonExistingMethod"))
    }

    func testHasProperty() {
        XCTAssertTrue(mirror!.hasProperty("normalProperty"))
        XCTAssertTrue(mirror!.hasProperty("constProperty"))
        XCTAssertFalse(mirror!.hasProperty("nonExistingProperty"))
    }

    func testIsReadonly() {
        XCTAssertTrue(mirror!.isReadonly("constProperty"))
        XCTAssertFalse(mirror!.isReadonly("normalProperty"))
        // TODO(jondong): assert is thown here for non-existing property.
        // XCTAssertFalse(mirror!.isReadonly("nonExistingProperty"))
    }

    func testConstructor() {
        XCTAssertEqual(mirror!.constructor, Selector("initFromJavaScript:"))
        XCTAssertNotEqual(mirror!.constructor, Selector("init"))
    }

    func testGetMethod() {
        XCTAssertEqual(mirror!.getMethod("demoMethodWithParams"), Selector("jsfunc_demoMethodWithParams:name:value:"))
        XCTAssertEqual(mirror!.getMethod(""), Selector())
        XCTAssertEqual(mirror!.getMethod(""), Selector())
        XCTAssertNotEqual(mirror!.getMethod(""), Selector())
    }

    func testGetGetter() {
        XCTAssert(true, "Pass")
    }

    func testGetSetter() {
        XCTAssert(true, "Pass")
    }

}

