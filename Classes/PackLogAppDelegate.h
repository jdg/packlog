//
//  PackLogAppDelegate.h
//  PackLog
//
//  Created by Jonathan George on 10/9/08.
//  Copyright JDG 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackLogAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;

	NSString *subdomain;
	NSString *apiKey;
	NSString *userId;

	NSString *usesSSL;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) NSString *subdomain;
@property (nonatomic, retain) NSString *apiKey;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *usesSSL;

- (void)saveApiKey:(NSString *)key;
- (void)saveSubdomain:(NSString *)key;
- (void)saveUserId:(NSString *)key;
- (void)saveUsesSSL:(NSString *)key;

@end
