//
//  MixCacheItem.h
//  MixCache
//
//  Created by longminxiang on 2017/3/26.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MixCacheItem : NSObject<NSCoding>

@property (nonatomic, strong, nonnull) id<NSCoding> obj;

@property (nonatomic, strong, nullable) NSDate *expires;

- (nonnull instancetype)initWithObj:(nonnull id<NSCoding>)obj expires:(nullable NSDate *)expires;

- (BOOL)didExpire;

@end
