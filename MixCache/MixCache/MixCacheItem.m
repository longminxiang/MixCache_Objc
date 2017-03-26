//
//  MixCacheItem.m
//  MixCache
//
//  Created by longminxiang on 2017/3/26.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

#import "MixCacheItem.h"

@implementation MixCacheItem

- (nonnull instancetype)initWithObj:(nonnull id<NSCoding>)obj expires:(nullable NSDate *)expires
{
    if (self = [super init]) {
        self.obj = obj;
        self.expires = expires;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.obj = [aDecoder decodeObjectForKey:@"obj"];
        self.expires = [aDecoder decodeObjectForKey:@"expires"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.obj forKey:@"obj"];
    if (self.expires) {
        [aCoder encodeObject:self.expires forKey:@"expires"];
    }
}

- (BOOL)didExpire
{
    return self.expires.timeIntervalSinceNow < 0;
}

@end
