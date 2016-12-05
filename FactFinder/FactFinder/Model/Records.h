//
//  Records.h
//  LazyTableView
//
//  Created by Arunkumar on 01/12/16.
//  Copyright © 2016 Infosys. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FactViewController.h"

@interface Records : NSObject

@property (nonatomic, strong) UIImage *appIcon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageHref;
@property (nonatomic, strong) NSString *imageDescription;

- (void)startIconDownload:(Records *)appRecord forIndexPath:(NSIndexPath *)indexPath forViewController:(FactViewController *)factViewController imageDictionary:(NSMutableDictionary *)imageDownloadsInProgress factFinderTableView:(UITableView *)factFinderTableView;

@end
