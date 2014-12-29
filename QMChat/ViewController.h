//
//  ViewController.h
//  QMChat
//
//  Created by QiMENG on 14-12-26.
//  Copyright (c) 2014年 QiMENG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QMXmpp.h"

@interface ViewController : UIViewController <NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
}


@end

