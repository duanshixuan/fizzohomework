//
//  FYUserDefaults.h
//  ForYou
//
//  Created by marcus on 2017/8/1.
//  Copyright © 2017年 ForYou. All rights reserved.
//  NSUserDefaults管理类

#import <Foundation/Foundation.h>
//#import "FYUser.h"

@interface FYUserDefaults : NSObject

/**
 FYUserDefaults单例
 
 @return FYUserDefaults单例
 */
+ (instancetype )sharedInstance;

//保存、获取用户信息
//- (void)saveUser:(FYUser *)user;
- (void)cleatUser;

- (void)saveAccessToken:(NSString *)accessToken;
- (NSString *)accessToken;
- (NSString *)getUserId;

- (void)setShowComeInVersion:(NSString *)showComeInVersion;
- (NSString *)showComeInVersion;

//用户是否已读购买保险规则
- (void)setInsuranceNoticeHasReadFlag:(BOOL)insuranceNoticeHasReadFlag;
- (BOOL)insuranceNoticeHasReadFlag;


//@property(nonatomic, strong)FYUser * user;


- (NSInteger)fy_integerWithKey:(NSString *)key;
- (void)saveInteger:(NSInteger)number forKey:(NSString *)key;

@end
