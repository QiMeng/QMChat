//
//  QMXmpp.m
//  QMChat
//
//  Created by QiMENG on 14-12-27.
//  Copyright (c) 2014年 QiMENG. All rights reserved.
//

#import "QMXmpp.h"

#define kHostName @"10.10.0.138"
#define kHostPort 5222

@interface QMXmpp()

//@property (nonatomic, readwrite) XMPPStream * xmppStream;

@end

@implementation QMXmpp

+ (QMXmpp *)sharedManager
{
    static QMXmpp *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if (!sharedInstance) {
            sharedInstance = [[QMXmpp alloc] init];
            sharedInstance.hostName = @"10.10.0.138";
            sharedInstance.domain = @"qimeng";
        }
    });
    return sharedInstance;
}

- (void)setupStream{
    _xmppStream = [[XMPPStream alloc]init];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 初始化 xmppReconnect
    _xmppReconnect = [[XMPPReconnect alloc] init];
    _xmppReconnect.autoReconnect=YES;//自动重连
    
    // 初始化 xmppRosterStorage   roster
    _xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc]init];
    _xmppRoster = [[XMPPRoster alloc]initWithRosterStorage:_xmppRosterStorage];
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    _xmppRoster.autoFetchRoster = YES;
    _xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    // 初始化 vCard support
    _xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:_xmppvCardStorage];
    _xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppvCardTempModule];
    [_xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppvCardAvatarModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 初始化 capabilities
    _xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    _xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:_xmppCapabilitiesStorage];
    _xmppCapabilities.autoFetchHashedCapabilities = YES;
    _xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    
    // 初始化 message
    _xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    _xmppMessageArchivingModule = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage];
    [_xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    [_xmppMessageArchivingModule activate:_xmppStream];
    [_xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    // 激活xmpp的模块
    [_xmppReconnect         activate:_xmppStream];
    [_xmppRoster            activate:_xmppStream];
    [_xmppvCardTempModule   activate:_xmppStream];
    [_xmppvCardAvatarModule activate:_xmppStream];
    [_xmppCapabilities      activate:_xmppStream];
    
}

#pragma mark - 断开连接
- (void)disconnect {
    [self presenceStype:PresenceStyleUnavailable];
    [_xmppStream disconnect];
    _password = @"";
}

#pragma mark - 改变在线状态
- (void)presenceStype:(PresenceStyle)stype {
    
    NSString * presenceStr = @"unavailable";
    
    switch (stype) {
        case PresenceStyleAvailable:
            presenceStr = @"available";
            break;
        case PresenceStyleAway:
            presenceStr = @"away";
            break;
        case PresenceStyleDoNotdisturb:
            presenceStr = @"do not disturb";
            break;
        case PresenceStyleUnavailable:
            presenceStr = @"unavailable";
            break;
        default:
            break;
    }
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:presenceStr];
    
    NSXMLElement *status = [NSXMLElement elementWithName:@"status"];
    [status setStringValue:@"吭哧吭哧"];
    [presence addChild:status];
    [_xmppStream sendElement:presence];
    
}

#pragma mark - 停止xmpp
- (void)myTeardownStream//
{
    [_xmppStream removeDelegate:self];
    [_xmppRoster removeDelegate:self];
    
    [_xmppReconnect         deactivate];
    [_xmppRoster            deactivate];
    [_xmppvCardTempModule   deactivate];
    [_xmppvCardAvatarModule deactivate];
    [_xmppCapabilities      deactivate];
    
    [_xmppStream disconnect];
    _xmppStream = nil;
    _xmppReconnect = nil;
    _xmppRoster = nil;
    _xmppRosterStorage = nil;
    _xmppvCardStorage = nil;
    _xmppvCardTempModule = nil;
    _xmppvCardAvatarModule = nil;
    _xmppCapabilities = nil;
    _xmppCapabilitiesStorage = nil;
}

#pragma mark - 登录
- (void)loginXMPPUserName:(NSString *)aUserName
                 password:(NSString *)aPassWord {
    [self loginXMPPUserName:aUserName password:aPassWord resource:_resource domain:_domain hostName:_hostName];
}

- (void)loginXMPPUserName:(NSString *)aUserName
                 password:(NSString *)aPassWord
                 resource:(NSString *)aResource {
    
    [self loginXMPPUserName:aUserName password:aPassWord resource:aResource domain:_domain hostName:_hostName];
}

- (void)loginXMPPUserName:(NSString *)aUserName
                 password:(NSString *)aPassWord
                 resource:(NSString *)aResource
                   domain:(NSString *)aDomain {
    
    [self loginXMPPUserName:aUserName password:aPassWord resource:aResource domain:aDomain hostName:_hostName];
    
}

- (void)loginXMPPUserName:(NSString *)aUserName
                 password:(NSString *)aPassWord
                 resource:(NSString *)aResource
                   domain:(NSString *)aDomain
                 hostName:(NSString *)aHostName {
    
    if (_xmppStream == nil) {
        [self setupStream];
    }
    if (![_xmppStream isConnected]) {
        
        _userName = aUserName;
        _password = aPassWord;
        _resource = aResource;
        _domain = aDomain;
        _hostName = aHostName;
        
        isReg = YES;
        
        XMPPJID *jid = [XMPPJID jidWithUser:aUserName domain:aDomain resource:aResource];
        [_xmppStream setMyJID:jid];
        [_xmppStream setHostName:aHostName];
        NSError *error = nil;
        if (![self.xmppStream connectWithTimeout:30 error:&error]) {
            NSLog(@"Connect Error: %@", [[error userInfo] description]);
        }
        
    }
    
}

#pragma mark - 注册
- (void)registrationXMPPUserName:(NSString *)aUserName
                        password:(NSString *)aPassWord {
    [self registrationXMPPUserName:aUserName password:aPassWord resource:_resource domain:_domain hostName:_hostName];
    
}

- (void)registrationXMPPUserName:(NSString *)aUserName
                        password:(NSString *)aPassWord
                        resource:(NSString *)aResource {
    
    [self registrationXMPPUserName:aUserName password:aPassWord resource:aResource domain:_domain hostName:_hostName];
}

- (void)registrationXMPPUserName:(NSString *)aUserName
                        password:(NSString *)aPassWord
                        resource:(NSString *)aResource
                          domain:(NSString *)aDomain {
    [self registrationXMPPUserName:aUserName password:aPassWord resource:aResource domain:aDomain hostName:_hostName];
}

- (void)registrationXMPPUserName:(NSString *)aUserName
                        password:(NSString *)aPassWord
                        resource:(NSString *)aResource
                          domain:(NSString *)aDomain
                        hostName:(NSString *)aHostName {
    if (_xmppStream == nil) {
        [self setupStream];
    }
    if (![_xmppStream isConnected]) {
        
        _userName = aUserName;
        _password = aPassWord;
        _resource = aResource;
        _domain = aDomain;
        _hostName = aHostName;
        
        isReg = NO;

        XMPPJID *jid = [XMPPJID jidWithUser:aUserName domain:aDomain resource:aResource];
        [_xmppStream setMyJID:jid];
        [_xmppStream setHostName:aHostName];
        NSError *error = nil;
        if (![self.xmppStream connectWithTimeout:30 error:&error]) {
            NSLog(@"Connect Error: %@", [[error userInfo] description]);
        }
    }
}
#pragma mark - 连接服务器成功  &&  密码登陆
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    NSError *error = nil;
    NSLog(@"连接服务器成功");
    if (isReg) {
        if (![self.xmppStream authenticateWithPassword:_password error:&error]) {
            NSLog(@"Authenticate Error: %@", [[error userInfo] description]);
        }
    }else {
        
        if (![_xmppStream registerWithPassword:_password error:&error]) {
            NSLog(@"注册 Error: %@", [[error userInfo] description]);
        }
    }
    
}
//注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"注册成功");
    NSError *error = nil;
    //注册成功之后直接登录
    if (![self.xmppStream authenticateWithPassword:_password error:&error]) {
        NSLog(@"Authenticate Error: %@", [[error userInfo] description]);
    }
}
//注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    NSLog(@"注册 Error: %@", [error description]);
}
#pragma mark - 身份验证,
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"登录通过");
    //    [self presenceStype:PresenceStyleAvailable];
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    [[self xmppStream] sendElement:presence];
}
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error//
{
    NSLog(@"登录失败 didNotAuthenticate:%@",error.description);
    [self disconnect];
}


#pragma mark - 获取全部好友列表
- (NSArray *)xmppAllFriendList {
    
    NSManagedObjectContext *context = [[self xmppRosterStorage] mainThreadManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSError *error ;
    NSArray *friends = [context executeFetchRequest:request error:&error];
    
    //    NSArray * friends = [[QMXmpp sharedManager] xmppAllFriendList];
    //    for (XMPPUserCoreDataStorageObject *object in friends) {
    //
    //        NSLog(@"displayName:%@ jidStr:%@ streamBareJidStr:%@ nickname:%@ subscription:%@ ask:%@ unreadMessages:%@ photo:%@ section:%ld sectionName:%@ sectionNum:%d",
    //              object.displayName,
    //              object.jidStr,
    //              object.streamBareJidStr,
    //              object.nickname,
    //              object.subscription,
    //              object.ask,
    //              object.unreadMessages,
    //              object.photo,
    //              object.section,
    //              object.sectionName,
    //              [object.sectionNum intValue]);
    //
    //    }
    
    return friends;
}

#pragma mark - 根据好友的BJID获取,跟好友的聊天记录
- (NSFetchRequest *)xmppSearchFriendMessageWithToBareJidStr:(NSString*)aBJID {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:[[self xmppMessageArchivingCoreDataStorage] mainThreadManagedObjectContext]];
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@", aBJID];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    //    [fetchRequest setFetchLimit:self.fechLimit];  //设置查询最大数据
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    return fetchRequest;
}

#pragma mark - 发送消息
- (void)xmppSendMessageType:(NSString *)type Body:(NSString *)body toJID:(XMPPJID *)toJid{
    XMPPMessage *message = [XMPPMessage messageWithType:type to:toJid];
    [message addBody:body];
    [_xmppStream sendElement:message];
}


//#pragma mark - 获取好友状态
//- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
//    NSString *presenceType = [presence type];
//    NSString *presenceFromUser = [[presence from] user];
//    if (![presenceFromUser isEqualToString:[[sender myJID] user]]) {
//        if ([presenceType isEqualToString:@"available"]) {
//            //
//        } else if ([presenceType isEqualToString:@"unavailable"]) {
//            //
//        }
//    }
//
//    NSLog(@"%@:%@ %@  %@",presenceFromUser,presenceType,presence.show,presence.status);
//
//}

//- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
//{
//    NSLog(@"didReceiveIQ: %@",iq.type);
//    if ([@"result" isEqualToString:iq.type]) {
//        NSXMLElement *query = iq.childElement;
//        if ([@"query" isEqualToString:query.name]) {
//            NSArray *items = [query children];
//            for (NSXMLElement *item in items) {
//                NSString *jid = [item attributeStringValueForName:@"jid"];
//                NSLog(@"JID:%@",jid);
////                XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
//                //                [self.roster addObject:xmppJID];
//            }
//        }
//    }
//    
//    
//    return YES;
//}


@end
