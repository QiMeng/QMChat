//
//  QMXmpp.m
//  QMChat
//
//  Created by QiMENG on 14-12-27.
//  Copyright (c) 2014年 QiMENG. All rights reserved.
//

#import "QMXmpp.h"




#define kHostName @"10.10.0.35"
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
        }
    });
    return sharedInstance;
}

- (void)setupStream{
    _xmppStream = [[XMPPStream alloc]init];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    _xmppReconnect = [[XMPPReconnect alloc]init];
    [_xmppReconnect activate:self.xmppStream];

    self.xmppRosterStorage_CoreData = [[XMPPRosterCoreDataStorage alloc] init];
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterStorage_CoreData];
    _xmppRoster.autoFetchRoster = YES;
    _xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    [_xmppRoster            activate:self.xmppStream];
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
//    _xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc]init];
//    _xmppRoster = [[XMPPRoster alloc]initWithRosterStorage:_xmppRosterStorage];
//    [_xmppRoster activate:_xmppStream];
//    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
//    
//    _xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
//    _xmppMessageArchivingModule = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage];
//    [_xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
//    [_xmppMessageArchivingModule activate:_xmppStream];
//    [_xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}
#pragma mark - 登录
- (void)loginXMPPUserName:(NSString *)aUserName
                 password:(NSString *)aPassWord
                 resource:(NSString *)aResource{
    
    if (self.xmppStream == nil) {
        
        [self setupStream];
    }
    
    if (![self.xmppStream isConnected]) {
        
        XMPPJID *jid = [XMPPJID jidWithUser:aUserName domain:kHostName resource:aResource];
        [self.xmppStream setMyJID:jid];
        [self.xmppStream setHostName:kHostName];
        NSError *error = nil;
        if (![self.xmppStream connectWithTimeout:1 error:&error]) {
            NSLog(@"Connect Error: %@", [[error userInfo] description]);
        }
        password = aPassWord;
    }
}

#pragma mark - 连接服务器成功  &&  密码登陆
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    NSError *error = nil;
    
    NSLog(@"连接服务器成功");
    if (![self.xmppStream authenticateWithPassword:password error:&error]) {
        NSLog(@"Authenticate Error: %@", [[error userInfo] description]);
    }
}
#pragma mark - 身份验证,
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"验证通过");
    [self presenceStype:PresenceStyleAway];
}
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error//
{
    NSLog(@"验证失败 didNotAuthenticate:%@",error.description);
    [self disconnect];
}



#pragma mark - 断开连接
- (void)disconnect {
    [self presenceStype:PresenceStyleUnavailable];
    [_xmppStream disconnect];
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
