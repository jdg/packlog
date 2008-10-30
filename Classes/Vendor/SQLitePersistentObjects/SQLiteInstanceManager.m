//
//  SQLiteInstanceManager.m
// ----------------------------------------------------------------------
// Part of the SQLite Persistent Objects for Cocoa and Cocoa Touch
//
// (c) 2008 Jeff LaMarche (jeff_Lamarche@mac.com)
// ----------------------------------------------------------------------
// This code may be used without restriction in any software, commercial,
// free, or otherwise. There are no attribution requirements, and no
// requirement that you distribute your changes, although bugfixes and 
// enhancements are welcome.
// 
// If you do choose to re-distribute the source code, you must retain the
// copyright notice and this license information. I also request that you
// place comments in to identify your changes.
//
// For information on how to use these classes, take a look at the 
// included eadme.txt file
// ----------------------------------------------------------------------

#import "SQLiteInstanceManager.h"

static SQLiteInstanceManager *sharedSQLiteManager = nil;

#pragma mark Private Method Declarations
@interface SQLiteInstanceManager (private)
- (NSString *)databaseFilepath;
@end

@implementation SQLiteInstanceManager
#pragma mark -
#pragma mark Singleton Methods
+ (id)sharedManager 
{
	@synchronized(self) 
	{
        if (sharedSQLiteManager == nil) 
            [[self alloc] init]; 
    }
    return sharedSQLiteManager;
}
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedSQLiteManager == nil) 
		{
            sharedSQLiteManager = [super allocWithZone:zone];
            return sharedSQLiteManager; 
        }
    }
    return nil;
}
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
- (id)retain
{
    return self;
}
- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}
- (void)release
{
    // never release
}
- (id)autorelease
{
    return self;
}
#pragma mark -
-(sqlite3 *)database
{
	static BOOL first = YES;
	char *errmsg = NULL;
	
	if (first || database == NULL)
	{
		first = NO;
		if (!sqlite3_open([[self databaseFilepath] UTF8String], &database) == SQLITE_OK) 
		{
			// Even though the open failed, call close to properly clean up resources.
			NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
			sqlite3_close(database);
		}
		
		if (sqlite3_exec(database, "PRAGMA encoding = \"UTF-8\"", NULL, NULL, &errmsg) != SQLITE_OK) {
			NSAssert1(0, @"Failed to switch encoding to UTF-8 with message '%s'.", errmsg);
			sqlite3_free(errmsg);
		} 
	}
	return database;
}
#pragma mark -
- (void)dealloc
{
	[databaseFilepath release];
	[super dealloc];
}
#pragma mark -
#pragma mark Private Methods
- (NSString *)databaseFilepath
{
	if (databaseFilepath == nil)
	{
		NSMutableString *ret = [NSMutableString string];
		NSString *appName = [[NSProcessInfo processInfo] processName];
		for (int i = 0; i < [appName length]; i++)
		{
			NSRange range = NSMakeRange(i, 1);
			NSString *oneChar = [appName substringWithRange:range];
			if (![oneChar isEqualToString:@" "]) 
				[ret appendString:[oneChar lowercaseString]];
		}
#if (TARGET_OS_MAC && ! (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR))
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
		NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
		NSString *saveDirectory = [basePath stringByAppendingPathComponent:appName];
#else
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *saveDirectory = [paths objectAtIndex:0];
#endif
		NSString *saveFileName = [NSString stringWithFormat:@"%@.sqlite3", ret];
		NSString *filepath = [saveDirectory stringByAppendingPathComponent:saveFileName];
		
		databaseFilepath = [filepath retain];
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:saveDirectory]) 
			[[NSFileManager defaultManager] createDirectoryAtPath:saveDirectory withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return databaseFilepath;
}
@end
