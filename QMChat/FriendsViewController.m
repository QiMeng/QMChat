//
//  FriendsViewController.m
//  QMChat
//
//  Created by QiMENG on 12/30/14.
//  Copyright (c) 2014 QiMENG. All rights reserved.
//

#import "FriendsViewController.h"
#import "QMXmpp.h"
@interface FriendsViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray * friends;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _friends = [QMXmppShare xmppAllFriendList];
    
    myTableView.tableFooterView = [UIView new];
    
    [myTableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return _friends.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    
    XMPPUserCoreDataStorageObject *object = _friends[indexPath.row];
    
    cell.textLabel.text = object.displayName;
    
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
