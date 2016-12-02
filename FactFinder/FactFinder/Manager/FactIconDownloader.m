//
//  FactIconDownloader.m
//  LazyTableView
//
//  Created by Arunkumar on 01/12/16.
//  Copyright © 2016 Infosys. All rights reserved.
//
#import "FactIconDownloader.h"
#import "Records.h"

#define kAppIconSize 48

@interface FactIconDownloader ()
@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;
@end

@implementation FactIconDownloader

// Start Download
- (void)startDownload
{
    // Create request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.records.imageHref]];
    // Create an session data task to obtain and download the app icon
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       // in case we want to know the response status code
                                                       // NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                                                       if (error != nil) {
                                                           if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection) {
                                                               // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                                                               // then your Info.plist has not been properly configured to match the target server.
                                                               //
                                                               abort();
                                                           }
                                                       }
                                                       // Used for highest level of abstraction
                                                       // NSOperationQueue is pretty well used for complex dependencies compared to GCD
                                                       [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                           // Set appIcon and clear temporary data/image
                                                           UIImage *image = [[UIImage alloc] initWithData:data];
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
                                                           // call our completion handler to tell our client that our icon is ready for display
                                                           if (self.completionHandler != nil) {
                                                               self.completionHandler();
                                                           }
                                                       }];
                                                   }];
    [self.sessionTask resume];
}

// CancelDownload
- (void)cancelDownload {
    // Cancelling the session task
    [self.sessionTask cancel];
    _sessionTask = nil;
}

@end

