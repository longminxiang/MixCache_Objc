//
//  MixFileCache.m
//  MixCache
//
//  Created by longminxiang on 2017/3/26.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

#import "MixFileCache.h"

@interface MixFileCache ()

@property (nonatomic, strong, nonnull) NSCache *internalCache;
@property (nonatomic, strong, nonnull) dispatch_queue_t queue;
@property (nonatomic, strong, nonnull) NSURL *directory;

@end

@implementation MixFileCache

+ (nonnull instancetype)shared
{
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self alloc] initWithName:@"MixCache"];
    });
    return obj;
}

- (nonnull instancetype)initWithName:(nonnull NSString *)name
{
    if (self = [super init]) {
        NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [NSString stringWithFormat:@"%@/%@", cacheDir, name];
        NSLog(@"create MixCache in %@", path);
        self.directory = [NSURL fileURLWithPath:path];
        
        self.internalCache = [NSCache new];
        self.internalCache.name = name;
        
        self.queue = dispatch_queue_create([name UTF8String], DISPATCH_QUEUE_PRIORITY_DEFAULT);
    }
    return self;
}

- (void)setObject:(nonnull id<NSCoding>)obj key:(nonnull NSString *)key
{
    [self setObject:obj key:key expires:nil];
}

- (void)setObject:(nonnull id<NSCoding>)obj key:(nonnull NSString *)key expires:(nullable NSDate *)expires
{
    MixCacheItem *item = [[MixCacheItem alloc] initWithObj:obj expires:expires];
    [self.internalCache setObject:item forKey:key];
    dispatch_async(self.queue, ^{
        NSString *path = [self getObjURL:key].path;
        [NSKeyedArchiver archiveRootObject:item toFile:path];
    });
}

- (nullable id<NSCoding>)getObject:(nonnull NSString *)key
{
    __block MixCacheItem *item = [self.internalCache objectForKey:key];
    if (!item) {
        dispatch_sync(self.queue, ^{
            NSString *path = [self getObjURL:key].path;
            item = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            if (![item isKindOfClass:[MixCacheItem class]]) {
                item = nil;
            }
        });
    }
    if (item) {
        [item didExpire] ? [self remove:key] : [self.internalCache setObject:item forKey:key];
    }
    return item.obj;
}

- (BOOL)exists:(nonnull NSString *)key
{
    __block MixCacheItem *item = [self.internalCache objectForKey:key];
    if (!item) {
        dispatch_sync(self.queue, ^{
            NSString *path = [self getObjURL:key].path;
            item = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            if (![item isKindOfClass:[MixCacheItem class]]) {
                item = nil;
            }
        });
    }
    return item ? ![item didExpire] : NO;
}

- (void)remove:(nonnull NSString *)key
{
    [self.internalCache removeObjectForKey:key];
    dispatch_async(self.queue, ^{
        [[NSFileManager defaultManager] removeItemAtURL:[self getObjURL:key] error:nil];
    });
}

- (void)removeAll
{
    [self clearInternalCache];
    dispatch_async(self.queue, ^{
        [[NSFileManager defaultManager] removeItemAtURL:self.directory error:nil];
        [[NSFileManager defaultManager] createDirectoryAtURL:self.directory withIntermediateDirectories:YES attributes:nil error:nil];
    });
}

- (void)clearInternalCache
{
    [self.internalCache removeAllObjects];
}

- (nonnull NSURL *)getObjURL:(nonnull NSString *)key
{
    return [self.directory URLByAppendingPathComponent:key];
}

@end
