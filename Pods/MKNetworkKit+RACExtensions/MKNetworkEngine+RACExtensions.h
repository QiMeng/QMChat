//
//  MKNetworkEngine+RACExtensions.h
//  MKNetworkKit-iOS
//
//  Created by Jacob Jennings on 9/5/13.
//  Copyright (c) 2013 Steinlogic. All rights reserved.
//

#import <MKNetworkEngine.h>

@class RACSignal;

@interface MKNetworkEngine (RACExtensions)

- (RACSignal *)rac_enqueueOperation:(MKNetworkOperation *)operation;

- (RACSignal *)rac_enqueueOperation:(MKNetworkOperation *)operation forceReload:(BOOL)forceReload;

- (RACSignal *)rac_imageAtURL:(NSURL *)url operation:(MKNetworkOperation **)operation;

- (RACSignal *)rac_imageAtURL:(NSURL *)url size:(CGSize)size operation:(MKNetworkOperation **)operation;

@end
