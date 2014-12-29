//
//  ViewController.m
//  QMChat
//
//  Created by QiMENG on 14-12-26.
//  Copyright (c) 2014年 QiMENG. All rights reserved.
//

#import "ViewController.h"
#import "QMXmpp.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[QMXmpp sharedManager] loginXMPPUserName:@"admin" password:@"admin" resource:@"iphone"];
    
    
    [self performSelector:@selector(getData) withObject:nil afterDelay:5];
}



- (void)getData{
    
    NSArray * friends = [[QMXmpp sharedManager] xmppAllFriendList];
    for (XMPPUserCoreDataStorageObject *object in friends) {
        
        NSLog(@"displayName:%@ jidStr:%@ streamBareJidStr:%@ nickname:%@ subscription:%@ ask:%@ unreadMessages:%@ photo:%@ section:%ld sectionName:%@ sectionNum:%d",
              object.displayName,
              object.jidStr,
              object.streamBareJidStr,
              object.nickname,
              object.subscription,
              object.ask,
              object.unreadMessages,
              object.photo,
              object.section,
              object.sectionName,
              [object.sectionNum intValue]);

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
