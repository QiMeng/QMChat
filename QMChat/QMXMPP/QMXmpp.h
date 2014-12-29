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
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPCapabilities.h"


#define QMXmppShare [QMXmpp sharedManager]

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


@interface QMXmpp : NSObject  {
    
    
    BOOL isReg; //用于判断注册.还是登录; 
    
}

@property (nonatomic, copy) NSString * hostName;    //主机ip地址
@property (nonatomic, copy) NSString * domain;      //服务器名

@property (nonatomic, copy) NSString * userName;    //用户名
@property (nonatomic, copy) NSString * password;    //密码
@property (nonatomic, copy) NSString * resource;    //资源id

@property (nonatomic, strong) XMPPStream *xmppStream;

/** XMPP花名册存储对象（CoreData） */
@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong) XMPPvCardCoreDataStorage *xmppvCardStorage;
@property (nonatomic, strong) XMPPvCardTempModule * xmppvCardTempModule;
@property (nonatomic, strong) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong) XMPPCapabilitiesCoreDataStorage * xmppCapabilitiesStorage;
@property (nonatomic, strong) XMPPCapabilities *xmppCapabilities;


@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchivingModule;

+ (QMXmpp *)sharedManager;

/**
 *  登录
 *
 *  @param aUserName 账号
 *  @param aPassWord 密码
 *
 *  ex:[QMXmppShare loginXMPPUserName:@"QiMENG" password:@"QiMENG"];
 *
 */
- (void)loginXMPPUserName:(NSString *)aUserName
                 password:(NSString *)aPassWord;

- (void)loginXMPPUserName:(NSString *)aUserName
                 password:(NSString *)aPassWord
                 resource:(NSString *)aResource;

- (void)loginXMPPUserName:(NSString *)aUserName
                 password:(NSString *)aPassWord
                 resource:(NSString *)aResource
                   domain:(NSString *)aDomain;

- (void)loginXMPPUserName:(NSString *)aUserName
                 password:(NSString *)aPassWord
                 resource:(NSString *)aResource
                   domain:(NSString *)aDomain
                 hostName:(NSString *)aHostName;

/**
 *  注册
 *
 *  @param aUserName 账号
 *  @param aPassWord 密码
 *
 *  ex:[QMXmppShare registrationXMPPUserName:@"QiMENG" password:@"QiMENG"];
 *
 */
- (void)registrationXMPPUserName:(NSString *)aUserName
                        password:(NSString *)aPassWord;

- (void)registrationXMPPUserName:(NSString *)aUserName
                        password:(NSString *)aPassWord
                        resource:(NSString *)aResource;

- (void)registrationXMPPUserName:(NSString *)aUserName
                        password:(NSString *)aPassWord
                        resource:(NSString *)aResource
                          domain:(NSString *)aDomain;

- (void)registrationXMPPUserName:(NSString *)aUserName
                        password:(NSString *)aPassWord
                        resource:(NSString *)aResource
                          domain:(NSString *)aDomain
                        hostName:(NSString *)aHostName;

/**
 *  获取全部好友列表
 *
 *  @return 好友列表 < XMPPUserCoreDataStorageObject >
 */
- (NSArray *)xmppAllFriendList;

- (NSFetchRequest *)xmppSearchFriendMessageWithToBareJidStr:(NSString*)aBJID;

/**
 *  发送消息
 *
 *  @param type  消息类型
 *  @param body  消息体
 *  @param toJid 发送对象
 */
- (void)xmppSendMessageType:(NSString *)type Body:(NSString *)body toJID:(XMPPJID *)toJid;

/**
 *  退出登录
 */
- (void)disconnect;


@end
