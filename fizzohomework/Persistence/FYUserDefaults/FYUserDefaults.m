//
//  FYUserDefaults.m
//  ForYou
//
//  Created by marcus on 2017/8/1.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYUserDefaults.h"
#import "FYFoundationCategory.h"

@interface FYUserDefaults()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation FYUserDefaults

#define kAccessToken @"kAccessToken"
#define kShowComeInVersion @"kShowComeInVersion"
#define kFYUser @"kFYUser"
#define kInsuranceNoticeHasReadFlag @"kInsuranceNoticeHasReadFlag"

#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static FYUserDefaults *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[FYUserDefaults alloc] init];
    });
    return instance;
}

#pragma mark - getters and setters

//- (void)saveUser:(FYUser *)user {
//    self.user = user;
//    [self.userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:kFYUser];
//    [self.userDefaults synchronize];
//}

- (void)cleatUser{
    [self.userDefaults removeObjectForKey:kFYUser];
    [self.userDefaults synchronize];
}

//- (FYUser *)user {
//    if (!_user) {
//        _user = [NSKeyedUnarchiver unarchiveObjectWithData:[self.userDefaults objectForKey:kFYUser]];
//    }
//    return _user;
//}

- (NSUserDefaults *)userDefaults {
    if (_userDefaults == nil) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

- (void)saveAccessToken:(NSString *)accessToken {
    [self.userDefaults setObject:accessToken forKey:kAccessToken];
    [self.userDefaults synchronize];
}

- (NSString *)accessToken {
    
    
    return [self.userDefaults objectForKey:kAccessToken];
}

- (void)setShowComeInVersion:(NSString *)showComeInVersion {
    [self.userDefaults setObject:showComeInVersion forKey:kShowComeInVersion];
    [self.userDefaults synchronize];
}

- (NSString *)showComeInVersion {
    return [self.userDefaults objectForKey:kShowComeInVersion];
}


- (void)setInsuranceNoticeHasReadFlag:(BOOL)insuranceNoticeHasReadFlag{
    [self.userDefaults setBool:insuranceNoticeHasReadFlag forKey:kInsuranceNoticeHasReadFlag];
    [self.userDefaults synchronize];
}
- (BOOL)insuranceNoticeHasReadFlag{
    return [self.userDefaults boolForKey:kInsuranceNoticeHasReadFlag];
}

#pragma mark --- userId
//- (NSString *)getUserId{
//    return [NSString isEmpty:self.user.userId] ? @"" : self.user.userId;
//}



- (NSInteger)fy_integerWithKey:(NSString *)key{
    return [self.userDefaults integerForKey:key];
}
- (void)saveInteger:(NSInteger)number forKey:(NSString *)key{
    [self.userDefaults setInteger:number forKey:key];
    [self.userDefaults synchronize];
}


@end
