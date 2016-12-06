//
//  FactViewController.h
//  LazyTableView
//
//  Created by Arunkumar on 01/12/16.
//  Copyright © 2016 Infosys. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface FactViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *factFinderTableView;
@property (nonatomic, strong) NSArray *entries;
@property (nonatomic, strong) NSDictionary *jsonDictionary;
@property (nonatomic, strong) NSString *barTitle;

// Reload the table view data
- (void)reloadData;

// Stop the pull to refresh
- (void)stopPullToRefresh;

// TerminateAllDownloads
- (void)terminateAllDownloads;

@end

