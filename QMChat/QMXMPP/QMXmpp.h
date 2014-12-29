//
//  QMXmpp.h
//  QMChat
//
//  Created by QiMENG on 14-12-27.
//  Copyright (c) 2014年 QiMENG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <XMPPFramework.h>

#import "XMPP.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPRoster.h"
#import "XMPPReconnect.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPMessageArchiving.h"
//presence 的状态：
//
//available 上线
//
//away 离开
//
//do not disturb 忙碌
//
//unavailable 下线

typedef enum
{
    PresenceStyleAvailable,      //上线
    PresenceStyleAway,           //离开
    PresenceStyleDoNotdisturb,   //忙碌
    PresenceStyleUnavailable     //下线
}PresenceStyle;


@interface QMXmpp : NSObject 

@property (nonatomic, copy) NSString * hostName;    //主机ip地址
@property (nonatomic, copy) NSString * domain;      //服务器名

@property (nonatomic, copy) NSString * userName;    //用户名
@property (nonatomic, copy) NSString * password;    //密码
@property (nonatomic, copy) NSString * resource;    //资源id


@property (nonatomic, strong) XMPPStream *xmppStream;

/** XMPP花名册存储对象（CoreData） */
@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRosterStorage_CoreData;
@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchivingModule;

+ (QMXmpp *)sharedManager;

/**
 *  登录xmpp
 *
 *  @param aUserName 账号
 *  @param aPassWord 密码
 *  @param aResource 资源id
 */
- (void)loginXMPPUserName:(NSString *)aUserName
                 password:(NSString *)aPassWord
                 resource:(NSString *)aResource;


/**
 *  获取全部好友列表
 *
 *  @return 好友列表 < XMPPUserCoreDataStorageObject >
 */
- (NSArray *)xmppAllFriendList;



/**
 *  退出登录
 */
- (void)disconnect;


@end
