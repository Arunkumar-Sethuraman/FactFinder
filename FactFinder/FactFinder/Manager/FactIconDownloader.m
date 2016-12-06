//
//  FactIconDownloader.m
//  LazyTableView
//
//  Created by Arunkumar on 01/12/16.
//  Copyright © 2016 Infosys. All rights reserved.
//
#import "FactIconDownloader.h"
#import "Records.h"
#import "Reachability.h"
#import "Constants.h"
#define kAppIconSize 48

@interface FactIconDownloader ()
@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;
@end

@implementation FactIconDownloader

// Start Download
- (void)startDownload:(FactViewController *)factViewController {
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (!(networkStatus == NotReachable)) {
        // Create request
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.records.imageHref]];
        // Create an session data task to obtain and download the app icon
        _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           // Used for highest level of abstraction
                                                           // NSOperationQueue is pretty well used for complex dependencies compared to GCD
                                                           [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                               // Set appIcon and clear temporary data/image
                                                               UIImage *image = [[UIImage alloc] initWithData:data];
                                                               if (image) {
                                                                   if (image.size.width != kAppIconSize || image.size.height != kAppIconSize) {
                                                                       CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
                                                                       UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
                                                                       CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                                                                       [image drawInRect:imageRect];
                                                                       self.records.appIcon = UIGraphicsGetImageFromCurrentImageContext();
                                                                       UIGraphicsEndImageContext();
                                                                   } else {
                                                                       self.records.appIcon = image;
                                                                   }
                                                               } else {
                                                                   self.records.appIcon = [UIImage imageNamed:kPlaceholder];
                                                               }
                                                               // call our completion handler to tell our client that our icon is ready for display
                                                               if (self.completionHandler != nil) {
                                                                   self.completionHandler();
                                                               }
                                                           }];
                                                       }];
        [self.sessionTask resume];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:kConnectivityIssue
                                                                       message:kInternetConnection
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                             //stop refresh
                                                             [factViewController stopPullToRefresh];
                                                         }];
        
        [alert addAction:OKAction];
        // Present the viewcontroller for alert
        [factViewController presentViewController:alert animated:YES completion:nil];
        [factViewController terminateAllDownloads];
    }
}

// CancelDownload
- (void)cancelDownload {
    // Cancelling the session task
    [self.sessionTask cancel];
    _sessionTask = nil;
}

@end

