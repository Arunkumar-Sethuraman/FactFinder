//
//  ParseOperation.h
//  FactFinder
//
//  Created by Arunkumar on 05/12/16.
//  Copyright © 2016 Infosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FactViewController.h"

@interface ParseOperation : NSObject

// ParseJSON
+ (void)parseJSON:(FactViewController*) factViewController;

// Handle error
+ (void)handleError:(NSError *)error forViewController:(FactViewController*)factViewController;

@end
