//
//  MKNetworkEngine+RACExtensions.m
//  MKNetworkKit-iOS
//
//  Created by Jacob Jennings on 9/5/13.
//  Copyright (c) 2013 Steinlogic. All rights reserved.
//

#import "MKNetworkEngine+RACExtensions.h"
#import "MKNetworkOperation.h"

#import <ReactiveCocoa/ReactiveCocoa.h> 

typedef MKNetworkOperation *(^RACNetworkOperationBlock)(MKNKImageBlock imageBlock, MKNKResponseErrorBlock errorBlock);

@implementation MKNetworkEngine (RACExtensions)

#pragma mark - Helper Methods

/** Helper method for invoking the original version of one of the enqueueOperation methods.  */
- (RACSignal *)rac_categoryWithOriginalMethod:(dispatch_block_t)original operation:(MKNetworkOperation *)operation
{
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        [self sendResponse:[completedOperation responseJSON]
                 toSubject:subject
              forOperation:completedOperation
                     count:0];
        
        [subject sendCompleted];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [subject sendError:error];
        [subject sendCompleted];
    }];
    
    original();
    
    return [subject deliverOn:[RACScheduler scheduler]];
}

- (void)sendResponse:(id)response toSubject:(RACReplaySubject *)subject forOperation:(MKNetworkOperation *)operation count:(NSInteger)count
{
    if (count > 1) {
        [subject sendError:nil];
        return;
    }
    
    if (response != nil) {
        [subject sendNext:response];
        return;
    }
    
    [self sendResponse:[operation responseString] toSubject:subject forOperation:operation count:(count+1)];
}

/** Helper method for invoking the original version of the image fetching methods. */
- (RACSignal *)rac_imageCategoryWithOriginalMethod:(RACNetworkOperationBlock)original operation:(MKNetworkOperation **)operation
{
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    MKNKImageBlock imageBlock = ^(UIImage *fetchedImage, NSURL *url, BOOL isInCache){
        [subject sendNext:fetchedImage];
        [subject sendCompleted];
    };
    
    MKNKResponseErrorBlock errorBlock = ^(MKNetworkOperation *completedOperation, NSError *error){
        [subject sendError:error];
        [subject sendCompleted];
    };
    
    MKNetworkOperation *op = original(imageBlock, errorBlock);
    
    if (operation) {
        (*operation) = op;
    }
    
    return [subject deliverOn:[RACScheduler scheduler]];
}

#pragma mark - Public Category Methods

- (RACSignal *)rac_enqueueOperation:(MKNetworkOperation *)operation
{
    return [self rac_categoryWithOriginalMethod:^{ [self enqueueOperation:operation]; }
                                      operation:operation];
}

- (RACSignal *)rac_enqueueOperation:(MKNetworkOperation *)operation forceReload:(BOOL)forceReload
{
    return [self rac_categoryWithOriginalMethod:^{ [self enqueueOperation:operation forceReload:forceReload]; }
                                      operation:operation];
}

- (RACSignal *)rac_imageAtURL:(NSURL *)url operation:(MKNetworkOperation **)operation
{
    RACNetworkOperationBlock originalMethod = ^MKNetworkOperation *(MKNKImageBlock imageBlock, MKNKResponseErrorBlock errorBlock) {
        return [self imageAtURL:url completionHandler:imageBlock errorHandler:errorBlock];
    };
    
    return [self rac_imageCategoryWithOriginalMethod:originalMethod operation:operation];
}

- (RACSignal *)rac_imageAtURL:(NSURL *)url size:(CGSize)size operation:(MKNetworkOperation **)operation
{
    RACNetworkOperationBlock originalMethod = ^MKNetworkOperation *(MKNKImageBlock imageBlock, MKNKResponseErrorBlock errorBlock) {
        return [self imageAtURL:url size:size completionHandler:imageBlock errorHandler:errorBlock];
    };
    
    return [self rac_imageCategoryWithOriginalMethod:originalMethod operation:operation];
}

@end
