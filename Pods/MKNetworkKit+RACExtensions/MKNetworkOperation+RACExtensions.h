//
//  MKNetworkOperation+RACExtensions.h
//  RACThisLife
//
//  Created by Jacob Jennings on 9/7/13.
//  Copyright (c) 2013 Jacob Jennings. All rights reserved.
//

#import "MKNetworkOperation.h"

@class RACSignal;

@interface MKNetworkOperation (RACExtensions)

- (RACSignal *)rac_downloadProgress;

- (RACSignal *)rac_uploadProgress;

@end
