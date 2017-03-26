//
//  MixCacheTests.m
//  MixCacheTests
//
//  Created by longminxiang on 2017/3/26.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MixFileCache.h"

@interface MixCacheTests : XCTestCase

@end

@implementation MixCacheTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit
{
    MixFileCache *cache = [[MixFileCache alloc] initWithName:@"global"];
    XCTAssertNotNil(cache);
    
    XCTAssertNotNil([MixFileCache shared]);
}

- (void)testSetObj {
    NSString *obj = @"sssssss";
    [[MixFileCache shared] setObject:@"sssssss" key:@"key1"];
    NSString *obj1 = (NSString *)[[MixFileCache shared] getObject:@"key1"];
    XCTAssertEqual(obj, obj1);
}

- (void)testExist
{
    [[MixFileCache shared] setObject:[NSDate date] key:@"key2"];
    XCTAssert([[MixFileCache shared] exists:@"key2"]);
    [[MixFileCache shared] remove:@"key2"];
    XCTAssert(![[MixFileCache shared] exists:@"key2"]);
    
    [[MixFileCache shared] setObject:[NSDate date] key:@"key2"];
    XCTAssert([[MixFileCache shared] exists:@"key2"]);
    [[MixFileCache shared] removeAll];
    XCTAssert(![[MixFileCache shared] exists:@"key2"]);
}

@end
