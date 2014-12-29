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

    //注册
//    [QMXmppShare registrationXMPPUserName:@"Dawn2" password:@"1111"];
    //登录
    [QMXmppShare loginXMPPUserName:@"Dawn" password:@"1111"];
//
    [self fetchedResultsController];
//
    [self performSelector:@selector(getData) withObject:nil afterDelay:5];
}

- (void)getData{

    
    //发送消息
    NSArray * friends = [[QMXmpp sharedManager] xmppAllFriendList];
    XMPPUserCoreDataStorageObject *object = [friends lastObject];
    [QMXmppShare xmppSendMessageType:@"chat" Body:@"发送消息" toJID:object.jid];
    
    
    
//  消息列表
//    NSManagedObjectContext *context = [[QMXmpp sharedManager].xmppMessageArchivingCoreDataStorage mainThreadManagedObjectContext];
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
//    NSFetchRequest *request = [[NSFetchRequest alloc]init];
//    [request setEntity:entityDescription];
//    NSError *error ;
//    NSArray *messages = [context executeFetchRequest:request error:&error];
//    
////    XMPPMessageArchiving_Message_CoreDataObject *object = [self.dataArray objectAtIndex:indexPath.row];
//    for (XMPPMessageArchiving_Message_CoreDataObject *obj in messages) {
//        NSLog(@"%@:%@",obj.bareJidStr,obj.body);
//    }

    
//  好友列表
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
    
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController == nil)
    {
        NSManagedObjectContext *moc = [[QMXmpp sharedManager].xmppMessageArchivingCoreDataStorage mainThreadManagedObjectContext];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:moc];
        
        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
        
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, nil];
        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@", self.friendJID.bare];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
//        [fetchRequest setPredicate:predicate];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:moc
                                                                         sectionNameKeyPath:nil
                                                                                  cacheName:nil];
        [fetchedResultsController setDelegate:self];
        
        NSError *error = nil;
        if (![fetchedResultsController performFetch:&error])
        {
            
        }
        
    }
    
    return fetchedResultsController;
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    
    switch (type) {
            
        case NSFetchedResultsChangeInsert:{
            XMPPMessageArchiving_Message_CoreDataObject *message = (XMPPMessageArchiving_Message_CoreDataObject *)anObject;
            NSLog(@"\n NSFetchedResultsChangeInsert :%@: %@",message.bareJidStr, message.body);
//
//            NSString *messageBody = @"";
//            if (message.body) {
//                messageBody = message.body;
//            }
//            else{
//                self.showTypingIndicator = YES;
//                return;
//            }
//            if ([message isOutgoing]) {
//                [self.messages addObject:[[JSQMessage alloc] initWithText:messageBody sender:self.sender date:message.timestamp]];
//            }
//            else{
//                [self.messages addObject:[[JSQMessage alloc] initWithText:messageBody sender:message.bareJidStr date:message.timestamp]];
//            }
//            
//            [self.collectionView.collectionViewLayout invalidateLayoutWithContext:[JSQMessagesCollectionViewFlowLayoutInvalidationContext context]];
//            [self.collectionView reloadData];
//            
//            [self scrollToBottomAnimated:YES];
            break;
        }
        case NSFetchedResultsChangeUpdate:{
            XMPPMessageArchiving_Message_CoreDataObject *message = (XMPPMessageArchiving_Message_CoreDataObject *)anObject;
            NSLog(@"NSFetchedResultsChangeUpdate : %@", message.body);
//            
//            NSString *messageBody = @"";
//            
//            if (message.body) {
//                messageBody = message.body;
//                self.showTypingIndicator = NO;
//            }
//            
//            JSQMessage *jsqMessage = [self.messages objectAtIndex:indexPath.row];
//            [jsqMessage setText:messageBody];
//            
//            [self.messages replaceObjectAtIndex:indexPath.row withObject:jsqMessage];
//            [self.collectionView.collectionViewLayout invalidateLayoutWithContext:[JSQMessagesCollectionViewFlowLayoutInvalidationContext context]];
//            [self.collectionView reloadData];
//            
//            [self scrollToBottomAnimated:YES];
        }
        case NSFetchedResultsChangeDelete:{
            NSLog(@"NSFetchedResultsChangeDelete");
//            if (indexPath.row <= [self.messages count]) {
//                
//                
//                self.showTypingIndicator = NO;
//            }
            break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
