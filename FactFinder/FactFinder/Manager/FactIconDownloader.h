//
//  FactIconDownloader.h
//  LazyTableView
//
//  Created by Arunkumar on 01/12/16.
//  Copyright © 2016 Infosys. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "FactViewController.h"
@class Records;

@interface FactIconDownloader : NSObject

@property (nonatomic, strong) Records *records;
@property (nonatomic, copy) void (^completionHandler)(void);

// Start icon download
- (void)startDownload:(FactViewController *)factViewController;

// Cancel icon download
- (void)cancelDownload;

@end
