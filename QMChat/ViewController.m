//
//  ViewController.m
//  QMChat
//
//  Created by QiMENG on 14-12-26.
//  Copyright (c) 2014年 QiMENG. All rights reserved.
//

#import "ViewController.h"
#import "QMXmpp.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <RACEXTScope.h>
#import <SVProgressHUD.h>
#import <CoreData+MagicalRecord.h>
#import "Test.h"
@interface ViewController () <QMXmppDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    QMXmppShare.delegate = self;
    
    RAC(loginBtn,enabled) = [RACSignal combineLatest:@[userNameTextField.rac_textSignal,
                                                       passwordTextField.rac_textSignal]
                                              reduce:^(NSString *user, NSString * pwd){
                                                  return  @(user.length > 0 && pwd.length > 0);
                                              }];

    RAC(regisBtn,enabled) = [RACSignal combineLatest:@[userNameTextField.rac_textSignal,
                                                       passwordTextField.rac_textSignal]
                                              reduce:^(NSString *user, NSString * pwd){
                                                  return  @(user.length > 0 && pwd.length > 0);
                                              }];

    
    Test * test = [Test MR_createEntity];
    
    
    
    
//    [self fetchedResultsController];
//
//    [self performSelector:@selector(getData) withObject:nil afterDelay:5];
}

#pragma mark - 登录
- (IBAction)touchLogin:(id)sender {
    [SVProgressHUD showWithStatus:@"正在登录..."];
    [QMXmppShare loginXMPPUserName:userNameTextField.text password:passwordTextField.text];
}

#pragma mark - 注册
- (IBAction)touchRegisterBtn:(id)sender {
    [SVProgressHUD showWithStatus:@"正在注册..."];
    [QMXmppShare registrationXMPPUserName:userNameTextField.text password:passwordTextField.text];
    
}

/**
 *  连接服务器失败
 */
- (void)qmXMPPConnectedFail:(id)sender{
    [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
}

/**
 *  登录成功
 */
- (void)qmXMPPLoginSuccess:(id)sender{
    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
    
     [self performSelector:@selector(getData) withObject:nil afterDelay:5];
    
//    [self performSegueWithIdentifier:@"FriendsViewController" sender:nil];
}

/**
 *  登录失败
 */
- (void)qmXMPPLoginFail:(id)sender{
    [SVProgressHUD showErrorWithStatus:@"登录失败"];
}

/**
 *  注册成功
 */
- (void)qmXMPPRegistrationSuccess:(id)sender{
    [SVProgressHUD showSuccessWithStatus:@"注册成功"];
}

/**
 *  注册失败
 */
- (void)qmXMPPRegistrationFail:(id)sender{
    [SVProgressHUD showErrorWithStatus:@"注册失败"];
}


- (void)getData{

    [self performSegueWithIdentifier:@"FriendsViewController" sender:nil];
    
    //发送消息
//    NSArray * friends = [[QMXmpp sharedManager] xmppAllFriendList];
//    XMPPUserCoreDataStorageObject *object = [friends lastObject];
//    [QMXmppShare xmppSendMessageType:@"chat" Body:@"发送消息" toJID:object.jid];
    
    
    
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
