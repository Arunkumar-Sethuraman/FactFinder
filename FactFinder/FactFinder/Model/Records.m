//
//  Records.m
//  LazyTableView
//
//  Created by Arunkumar on 01/12/16.
//  Copyright © 2016 Infosys. All rights reserved.
//
#import "Records.h"
#import "FactIconDownloader.h"
#import "FactIconTableViewCell.h"

@implementation Records

// Start the icon download progress
- (void)startIconDownload:(Records *)appRecord forIndexPath:(NSIndexPath *)indexPath forViewController:(FactViewController *)factViewController imageDictionary:(NSMutableDictionary *)imageDownloadsInProgress factFinderTableView:(UITableView *)factFinderTableView {
    FactIconDownloader *factIconDownloader = (imageDownloadsInProgress)[indexPath];
    if (factIconDownloader == nil) {
        factIconDownloader = [[FactIconDownloader alloc] init];
        factIconDownloader.records = appRecord;
        [factIconDownloader setCompletionHandler:^{
            FactIconTableViewCell *cell = [factFinderTableView cellForRowAtIndexPath:indexPath];
            // Display the newly loaded image
            cell.iconImage.image = appRecord.appIcon;
            cell.iconImage.frame = CGRectMake(cell.bounds.size.width - kIconWidth - kSepSpacing, cell.titleLabel.frame.size.height, kIconWidth, kIconHeight);
            // Remove the FactIconDownloader from the in progress list.
            // This will result in it being deallocated.
            [imageDownloadsInProgress removeObjectForKey:indexPath];
        }];
        (imageDownloadsInProgress)[indexPath] = factIconDownloader;
        if (![appRecord.imageHref isKindOfClass:[NSNull class]]) {
            [factIconDownloader startDownload:factViewController];
        }
    }
}

@end
