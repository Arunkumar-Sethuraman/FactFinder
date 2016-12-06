//
//  FactViewController.m
//  LazyTableView
//
//  Created by Arunkumar on 01/12/16.
//  Copyright © 2016 Infosys. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "FactViewController.h"
#import "FactIconDownloader.h"
#import "Records.h"
#import "FactIconTableViewCell.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "ParseOperation.h"

@interface FactViewController ()
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation FactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Refresh control intialization
    self.refreshControl = [[UIRefreshControl alloc] init];
    //Create and register cells for Table view
    [self createTableView];
    // Update constraints
    [self updateConstraints];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    // Initialize the refresh control.
    [self createPullToRefresh];
}

- (void)viewDidAppear:(BOOL)animated {
    self.factFinderTableView.frame = self.view.bounds;
    // Perform the background fetch from JSON
    [self performBackgroundTaskToFetchJSON];
}

// Perform the background fetch from JSON
- (void)performBackgroundTaskToFetchJSON {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getLatestFact];
    });
}

// didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // terminate all pending download connections
    [self terminateAllDownloads];
}

#pragma mark - Self methods
// Creating and registering cells in tableview
- (void)createTableView {
    self.factFinderTableView = [[UITableView alloc] init];
    [self.factFinderTableView registerClass:[FactIconTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.factFinderTableView registerClass:[FactIconTableViewCell class] forCellReuseIdentifier:PlaceholderCellIdentifier];
    self.factFinderTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.factFinderTableView.delegate = self;
    self.factFinderTableView.dataSource = self;
    [self.view addSubview:self.factFinderTableView];
}

// Get latest report from JSON
- (void) createPullToRefresh {
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(getLatestFact) forControlEvents:UIControlEventValueChanged];
    [self.factFinderTableView addSubview:self.refreshControl];
}

// Get latest report from JSON
- (void)getLatestFact {
    [ParseOperation parseJSON:self];
}

// Updating the constraints of various elements
- (void)updateConstraints {
    [self.factFinderTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    // 1. Create a dictionary of views and metrics
    NSDictionary *viewsDictionary = @{@"factFinderTableView":self.factFinderTableView};
    NSDictionary *metrics = @{@"vSpacing":@0, @"hSpacing":@0};
    // 2. Define the view Position and automatically the Size
    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-vSpacing-[factFinderTableView]-vSpacing-|" options:0 metrics:metrics views:viewsDictionary];
    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hSpacing-[factFinderTableView]-hSpacing-|" options:0 metrics:metrics views:viewsDictionary];
    [self.view addConstraints:constraint_POS_V];
    [self.view addConstraints:constraint_POS_H];
}

// Reloaddata
- (void)reloadData {
    // Set the navigation bar title while reloading data
    self.navigationController.navigationBar.topItem.title = self.barTitle;
    // Reload table data
    [self.factFinderTableView reloadData];
    // End the refreshing
    if (self.refreshControl) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:kTimeFormat];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        // Stop the refresh
        [self stopPullToRefresh];
    }
}

// Stop the refresh
- (void)stopPullToRefresh {
    [self.refreshControl endRefreshing];
}

// TerminateAllDownloads
- (void)terminateAllDownloads {
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    // Remove all objects from download progress
    [self.imageDownloadsInProgress removeAllObjects];
}

- (CGRect)calculateDescriptionLabelHeight:(Records *)appRecord {
    NSString *stringSize = appRecord.imageDescription;
    CGRect labelHeight = [stringSize
                          boundingRectWithSize: CGSizeMake(_factFinderTableView.bounds.size.width - kIconWidth - (3 * kSepSpacing), 0)
                          options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:@{
                                       NSFontAttributeName : [UIFont systemFontOfSize:kDescriptionFontSize]
                                       }
                          context:nil];
    return labelHeight;
}

- (void)updateTableViewCellContents:(FactIconTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    // Set up the cell representing the app
    Records *appRecord = (self.entries)[indexPath.row];
    // Set the title in Tableview cell
    cell.titleLabel.text = ![appRecord.title isKindOfClass:[NSNull class]] ? appRecord.title : @"";
    // Set the description in Tableview cell
    if (![appRecord.imageDescription isKindOfClass:[NSNull class]]) {
        cell.descriptionLabel.text = appRecord.imageDescription;
        CGRect labelHeight = [self calculateDescriptionLabelHeight:appRecord];
        [cell.descriptionLabel setFrame:CGRectMake(kSepSpacing, cell.titleLabel.frame.size.height, cell.bounds.size.width - kIconWidth - (3 * kSepSpacing), labelHeight.size.height)];
    } else {
        cell.descriptionLabel.text = @"";
    }
    // Only load cached images; defer new downloads until scrolling ends
    if (!appRecord.appIcon) {
        if (self.factFinderTableView.dragging == NO && self.factFinderTableView.decelerating == NO) {
            [self startIconDownload:appRecord forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        cell.iconImage.image = [UIImage imageNamed:@"Placeholder.png"];
    }
    else {
        cell.iconImage.image = appRecord.appIcon;
    }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Records *appRecord = (self.entries)[indexPath.row];
    if (![appRecord.imageDescription isKindOfClass:[NSNull class]]) {
        CGRect labelHeight = [self calculateDescriptionLabelHeight:appRecord];
        float ht = 30 + labelHeight.size.height;
        if (ht < 130) {
            return 130;
        }
        return ht;
    } else {
        return kCustomRowHeight;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (_entries) {
        self.factFinderTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = self.entries.count;
    // if there's no data yet, return enough rows to fill the screen
    if (count == 0) {
        return kCustomRowCount;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FactIconTableViewCell *cell = nil;
    NSUInteger nodeCount = self.entries.count;
    if (nodeCount == 0 && indexPath.row == 0) {
        // Add a placeholder cell while waiting on table data
        cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier forIndexPath:indexPath];
        cell.titleLabel.text = kDataLoading;
        [cell.titleLabel setFrame: CGRectMake(kSepSpacing, 0, cell.bounds.size.width - (2 * kSepSpacing), cell.bounds.size.height)];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        // Leave cells empty if there's no data yet
        if (nodeCount > 0) {
            // Set Frames
            [cell.titleLabel setFrame:CGRectMake(kSepSpacing, 0, self.view.bounds.size.width - (2 * kSepSpacing), 30)];
            [cell.iconImage setFrame:CGRectMake(cell.bounds.size.width - kIconWidth - kSepSpacing, cell.titleLabel.frame.size.height, kIconWidth, kIconHeight)];
            // Update tableview cell contents
            [self updateTableViewCellContents:cell forIndexPath:indexPath];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:(246/255.f) green:(246/255.f) blue:(246/255.f) alpha:1.0];
}

#pragma mark - Table cell image support
// Start the icon download progress
- (void)startIconDownload:(Records *)appRecord forIndexPath:(NSIndexPath *)indexPath {
    FactIconDownloader *factIconDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (factIconDownloader == nil) {
        factIconDownloader = [[FactIconDownloader alloc] init];
        factIconDownloader.records = appRecord;
        [factIconDownloader setCompletionHandler:^{
            FactIconTableViewCell *cell = [self.factFinderTableView cellForRowAtIndexPath:indexPath];
            // Display the newly loaded image
            cell.iconImage.image = appRecord.appIcon;
            cell.iconImage.frame = CGRectMake(cell.bounds.size.width - kIconWidth - kSepSpacing, cell.titleLabel.frame.size.height, kIconWidth, kIconHeight);
            // Remove the FactIconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
        }];
        (self.imageDownloadsInProgress)[indexPath] = factIconDownloader;
        if (![appRecord.imageHref isKindOfClass:[NSNull class]]) {
            [factIconDownloader startDownload:self];
        }
    }
}

// Download image on onscreen rows
- (void)loadImagesForOnscreenRows {
    if (self.entries.count > 0) {
        NSArray *visiblePaths = [self.factFinderTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            Records *appRecord = (self.entries)[indexPath.row];
            if (!appRecord.appIcon) {
            // Avoid the app icon download if the app already has an icon
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
}

#pragma mark - Interface orientation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self reloadData];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreenRows];
}

#pragma mark - Dealloc
// If this view controller is going away, we need to cancel all outstanding downloads.
- (void)dealloc {
    // terminate all pending download connections
    [self terminateAllDownloads];
}

@end
