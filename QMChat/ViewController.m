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
    NSManagedObjectContext *context = [[[QMXmpp sharedManager] xmppRosterStorage_CoreData] mainThreadManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSError *error ;
    NSArray *friends = [context executeFetchRequest:request error:&error];
    

    for (XMPPUserCoreDataStorageObject *object in friends) {
        NSString *name = [object displayName];
        if (!name) {
            name = [object nickname];
        }
        if (!name) {
            name = [object jidStr];
        }
        
        NSLog(@"name : %@",name);

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
