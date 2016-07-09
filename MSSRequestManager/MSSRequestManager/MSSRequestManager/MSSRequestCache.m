//
//  MSSRequestCache.m
//  MSSRequestManager
//
//  Created by 于威 on 16/5/9.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSRequestCache.h"
#import <CommonCrypto/CommonDigest.h>

@interface MSSRequestCache ()

@property (nonatomic,strong)NSFileManager *fileManager;
@property (nonatomic,copy)NSString *defaultCachePath;
@property (nonatomic,strong)dispatch_queue_t serialQueue;

@end

@implementation MSSRequestCache

+ (MSSRequestCache *)sharedInstance
{
    static MSSRequestCache *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _defaultCachePath = [paths[0] stringByAppendingPathComponent:@"MSSRequestCache"];
        _serialQueue = dispatch_queue_create("com.mss.MSSRequestCache", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark Private Method
- (NSString *)getDiskCachePathWithRequestItem:(MSSRequestModel *)requestItem
{
    NSString *cacheDiskPath = _defaultCachePath;
    if(requestItem.cacheFolderName.length > 0)
    {
        cacheDiskPath = [NSString stringWithFormat:@"%@/%@",_defaultCachePath,requestItem.cacheFolderName];
    }
    if (![_fileManager fileExistsAtPath:cacheDiskPath])
    {
        [_fileManager createDirectoryAtPath:cacheDiskPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *allValueString = @"";
    if(requestItem.params)
    {
        NSArray *allValuesArray = requestItem.params.allValues;
        allValueString = [allValuesArray componentsJoinedByString:@","];
    }
    NSString *fileName = [NSString stringWithFormat:@"%@%@",requestItem.requestUrl,allValueString];
    NSString *md5String = [self stringToMD5:fileName];
    NSString *path = [NSString stringWithFormat:@"%@/%@",cacheDiskPath,md5String];
    return path;
}

- (NSString *)stringToMD5:(NSString *)name
{
    const char *str = [name UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *md5String = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return md5String;
}

#pragma mark Public Method
- (NSDictionary *)getCacheDictWithRequestItem:(MSSRequestModel *)requestItem
{
    NSString *diskCachePath = [self getDiskCachePathWithRequestItem:requestItem];
    if([_fileManager fileExistsAtPath:diskCachePath])
    {
        NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:diskCachePath];
        return dict;
    }
    return nil;
}

- (void)writeToCacheWithRequestItem:(MSSRequestModel *)requestItem dict:(NSDictionary *)responseDict
{
    if(responseDict)
    {
        dispatch_async(_serialQueue, ^{
            NSString *diskCachePath = [self getDiskCachePathWithRequestItem:requestItem];
            [responseDict writeToFile:diskCachePath atomically:YES];
        });
    }
}

- (void)clearCacheWithRequestItem:(MSSRequestModel *)requestItem
{
    dispatch_async(_serialQueue, ^{
        NSString *diskCachePath = [self getDiskCachePathWithRequestItem:requestItem];
        if([_fileManager fileExistsAtPath:diskCachePath])
        {
            [_fileManager removeItemAtPath:diskCachePath error:nil];
        }
    });
}

- (void)clearFolderCacheWithRequestItem:(MSSRequestModel *)requestItem
{
    if(requestItem.cacheFolderName.length > 0)
    {
        dispatch_async(_serialQueue, ^{
            NSString *cacheFolderPath = [NSString stringWithFormat:@"%@/%@",_defaultCachePath,requestItem.cacheFolderName];
            if([_fileManager fileExistsAtPath:cacheFolderPath])
            {
                [_fileManager removeItemAtPath:cacheFolderPath error:nil];
            }
        });
    }
}

- (void)clearAllCache
{
    dispatch_async(_serialQueue, ^{
        [_fileManager removeItemAtPath:_defaultCachePath error:nil];
    });
}

- (BOOL)cacheIsTimeOutWithRequestItem:(MSSRequestModel *)requestItem
{
    NSString *diskCachePath = [self getDiskCachePathWithRequestItem:requestItem];
    if([_fileManager fileExistsAtPath:diskCachePath])
    {
        NSDictionary *dict = [_fileManager attributesOfItemAtPath:diskCachePath error:nil];
        NSDate *fileCacheDate = dict[NSFileModificationDate];
        NSDate *nowDate = [NSDate date];
        NSTimeInterval time = (long)[nowDate timeIntervalSinceDate:fileCacheDate];
        if(time > requestItem.cacheSecond && requestItem.cacheSecond > 0)
        {
            return YES;
        }
    }
    return NO;
}

@end
