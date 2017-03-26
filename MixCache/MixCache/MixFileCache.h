//
//  MixFileCache.h
//  MixCache
//
//  Created by longminxiang on 2017/3/26.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixCacheItem.h"

@interface MixFileCache : NSObject

+ (nonnull instancetype)shared;

- (nonnull instancetype)initWithName:(nonnull NSString *)name;

- (void)setObject:(nonnull id<NSCoding>)obj key:(nonnull NSString *)key;

- (void)setObject:(nonnull id<NSCoding>)obj key:(nonnull NSString *)key expires:(nullable NSDate *)expires;

- (nullable id<NSCoding>)getObject:(nonnull NSString *)key;

- (BOOL)exists:(nonnull NSString *)key;

- (void)remove:(nonnull NSString *)key;

- (void)removeAll;

- (void)clearInternalCache;

@end
