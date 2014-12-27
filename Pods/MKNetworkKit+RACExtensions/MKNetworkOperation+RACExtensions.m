//
//  MKNetworkOperation+RACExtensions.m
//  RACThisLife
//
//  Created by Jacob Jennings on 9/7/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "MKNetworkOperation+RACExtensions.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <objc/message.h>

@implementation MKNetworkOperation (RACExtensions)

- (RACSignal *)rac_progressSignalWithSelector:(SEL)original
{
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    void(^ProgressBlock)(double) = ^(double progress){
        [subject sendNext:@(progress)];
    };
    
    objc_msgSend(self, original, ProgressBlock);
    
    return [subject deliverOn:[RACScheduler scheduler]];
}

- (RACSignal *)rac_downloadProgress
{
    return [self rac_progressSignalWithSelector:@selector(onDownloadProgressChanged:)];
}

- (RACSignal *)rac_uploadProgress
{
    return [self rac_progressSignalWithSelector:@selector(onUploadProgressChanged:)];
}

@end
