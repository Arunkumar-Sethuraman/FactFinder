//
//  AppDelegate.m
//  LazyTableView
//
//  Created by Arunkumar on 01/12/16.
//  Copyright © 2016 Infosys. All rights reserved.
//
#import "AppDelegate.h"
#import "ViewController.h"
#import "Records.h"
#import "Constants.h"

@interface AppDelegate ()

@property(nonatomic, strong) UINavigationController *navigationController;
@property(nonatomic, strong) ViewController *viewController;
@property(nonatomic, strong) NSData *jsonData;

@end

@implementation AppDelegate

// DidFinishLaunchingWithOptions
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.viewController = [[ViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

// ParseJSON
-(void)parseJSON {
    NSError *errorObj = nil;
    // Convert string to URL
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:jsonAppFeed] encoding:NSISOLatin1StringEncoding error:&errorObj];
    NSDictionary *parsedDict = nil;
    // Encode to data
    NSData *metOfficeData = [string dataUsingEncoding:NSUTF8StringEncoding];
    if(!metOfficeData){
        NSLog(kNoData);
    }
    else {
        // Getting parsed dictionary from JSON Serialization class
        parsedDict = [NSJSONSerialization JSONObjectWithData:metOfficeData options:kNilOptions error:&errorObj];
        if ([parsedDict isKindOfClass:[NSDictionary class]]) {
            // Set the navigation bar title
            NSString *appTitle = [parsedDict valueForKey:kTitle];
            self.viewController.barTitle = [NSString stringWithFormat:@"%@", appTitle];
            // Get the information from rows key
            NSMutableArray *rows = [parsedDict valueForKey:kRows];
            NSMutableArray *tempRecords = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in rows) {
                //Update in Record object
                Records *records = [[Records alloc] init];
                records.title = [dict valueForKey:kTitle];
                records.imageDescription = [dict valueForKey:kDescription];
                records.imageHref = [dict valueForKey:kImageHref];
                if (![records.title isKindOfClass:[NSNull class]] && ![records.imageDescription isKindOfClass:[NSNull class]] && ![records.imageHref isKindOfClass:[NSNull class]]) {
                    [tempRecords addObject:records];
                }
            }
            // Update in viewcontroller entries for table view data
            self.viewController.entries = tempRecords;
            // UI updates
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewController reloadData];
            });
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
