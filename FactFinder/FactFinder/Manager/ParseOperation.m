//
//  ParseOperation.m
//  FactFinder
//
//  Created by Arunkumar on 05/12/16.
//  Copyright © 2016 Infosys. All rights reserved.
//

#import "ParseOperation.h"
#import "Reachability.h"
#import "Records.h"
#import "Constants.h"

@implementation ParseOperation

// ParseJSON
+ (void)parseJSON:(FactViewController*) factViewController {
    NetworkStatus networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    NSError *errorObj = nil;
    if (networkStatus == NotReachable) {
        [self handleError:errorObj forViewController:factViewController];
    } else {
        // Convert string to URL
        NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:jsonAppFeed] encoding:NSISOLatin1StringEncoding error:&errorObj];
        NSDictionary *parsedDict = nil;
        // Encode to data
        NSData *metOfficeData = [string dataUsingEncoding:NSUTF8StringEncoding];
        if(!metOfficeData){
            // Handling error
            [self handleError:errorObj forViewController:factViewController];
        }
        else {
            // Getting parsed dictionary from JSON Serialization class
            parsedDict = [NSJSONSerialization JSONObjectWithData:metOfficeData options:kNilOptions error:&errorObj];
            if ([parsedDict isKindOfClass:[NSDictionary class]]) {
                // Set the navigation bar title
                NSString *appTitle = [parsedDict valueForKey:kTitle];
                factViewController.barTitle = [NSString stringWithFormat:@"%@", appTitle];
                // Get the information from rows key
                NSMutableArray *rows = [parsedDict valueForKey:kRows];
                NSMutableArray *tempRecords = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in rows) {
                    //Update in Record object
                    Records *records = [[Records alloc] init];
                    records.title = [dict valueForKey:kTitle];
                    records.imageDescription = [dict valueForKey:kDescription];
                    records.imageHref = [dict valueForKey:kImageHref];
                    if (![records.title isKindOfClass:[NSNull class]]) {
                        [tempRecords addObject:records];
                    }
                }
                // Update in viewcontroller entries for table view data
                factViewController.entries = tempRecords;
                // UI updates
                dispatch_async(dispatch_get_main_queue(), ^{
                    [factViewController reloadData];
                });
            }
        }
    }
}

// Handle error
+ (void)handleError:(NSError *)error forViewController:(FactViewController*)factViewController {
    NSString *errorMessage = [error localizedDescription];
    // Alert user that our current record was deleted, and then we leave this view controller
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kConnectivityIssue
                                                                   message:errorMessage
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
}

@end
