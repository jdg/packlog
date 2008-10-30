//
//  PackLogAppDelegate.m
//  PackLog
//
//  Created by Jonathan George on 10/9/08.
//  Copyright JDG 2008. All rights reserved.
//

#import "PackLogAppDelegate.h"
#import "Beacon.h"

@implementation PackLogAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize subdomain, apiKey, userId, usesSSL;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	NSString *applicationCode = @"";
	[Beacon initAndStartBeaconWithApplicationCode:applicationCode useCoreLocation:YES];

	self.subdomain = [[NSUserDefaults standardUserDefaults] stringForKey:@"subdomain_key"];
	self.apiKey    = [[NSUserDefaults standardUserDefaults] stringForKey:@"api_key"];
	self.userId    = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_id"];
	self.usesSSL   = [[NSUserDefaults standardUserDefaults] stringForKey:@"uses_ssl"];

	if ([self.usesSSL isEqualToString:@""] || self.usesSSL == nil) {
		[self saveUsesSSL:@"NO"];
	}

    [window addSubview:tabBarController.view];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{   
    if (!url) {
        return NO;
    }

    NSString *URLString = [url absoluteString];

    if (!URLString) {
        return NO;
    }

	[self saveApiKey:[url password]];
	[self saveSubdomain:[url user]];

    return YES;
}

- (void)saveApiKey:(NSString *)key {
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults) {
		[standardUserDefaults setObject:key forKey:@"api_key"];
		[standardUserDefaults synchronize];
	}	
	
	self.apiKey = key;
}

- (void)saveSubdomain:(NSString *)key {
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults) {
		[standardUserDefaults setObject:key forKey:@"subdomain_key"];
		[standardUserDefaults synchronize];
	}	
	
	self.subdomain = key;
}

- (void)saveUserId:(NSString *)key {
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults) {
		[standardUserDefaults setObject:key forKey:@"user_id"];
		[standardUserDefaults synchronize];
	}	
	
	self.userId = key;
}

- (void)saveUsesSSL:(NSString *)key {
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults) {
		[standardUserDefaults setObject:key forKey:@"uses_ssl"];
		[standardUserDefaults synchronize];
	}	

	self.usesSSL = key;
}

- (BOOL)isSetup {
	if ([self.subdomain isEqualToString:@""] || [self.apiKey isEqualToString:@""] || [self.userId isEqualToString:@""]
		|| self.subdomain == nil || self.apiKey == nil || self.userId == nil) {
		return NO;
	}

	return YES;
}

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/

- (void)applicationWillTerminate:(UIApplication *)application {
	[[Beacon shared] endBeacon];
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

