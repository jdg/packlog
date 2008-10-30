//
//  UserManager.m
//  PackLog
//
//  Created by Jonathan George on 10/13/08.
//  Copyright 2008 JDG. All rights reserved.
//

#import "PackLogAppDelegate.h"
#import "UserManager.h"

#import "TouchXML.h"

@implementation UserManager

@synthesize userEntries;

- (void) fetch {
	PackLogAppDelegate *appDelegate = (PackLogAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *encodedUrl = [NSString stringWithFormat:@"http://%@.backpackit.com/%@/users.xml", appDelegate.subdomain, appDelegate.apiKey];
	NSURL *requestURL = [NSURL URLWithString:encodedUrl];
	NSLog(@"Using URL: %@", encodedUrl);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSMutableURLRequest *post = [NSMutableURLRequest requestWithURL:requestURL];
	[post setHTTPMethod: @"GET"];
	
	NSURLConnection *connection = [NSURLConnection connectionWithRequest:post delegate:self];

	if (connection) {
		NSLog(@"connected.");
		[connection retain];
		receivedData = [[NSMutableData data] retain];
	} else {
		NSLog(@"unable to connect.");
	}
}

- (void) convertXMLDocumentToEntries:(CXMLDocument *)xml
{
	if (userEntries) {
		[userEntries release];
	}
	
	userEntries = [[NSMutableArray alloc] init];
    NSArray *resultNodes = [xml nodesForXPath:@"//user" error:nil];
	
	for (CXMLElement *resultElement in resultNodes) {
		
		NSMutableDictionary *blogItem = [[NSMutableDictionary alloc] init];
		
		int counter;
		int childCounter;
		NSString *parentName = @"";
		
		for(counter = 0; counter < [resultElement childCount]; counter++) {
			
			if ([[resultElement childAtIndex:counter] childCount] > 1) {
				parentName = [[resultElement childAtIndex:counter] name];
				
				for (childCounter = 0; childCounter < [[resultElement childAtIndex:counter] childCount]; childCounter++) {
					[blogItem setObject:[[[resultElement childAtIndex:counter] childAtIndex:childCounter] stringValue] forKey:[NSString stringWithFormat:@"%@_%@", parentName, [[[resultElement childAtIndex:counter] childAtIndex:childCounter] name]]];
				}
			} else {
				[blogItem setObject:[[resultElement childAtIndex:counter] stringValue] forKey:[[resultElement childAtIndex:counter] name]];
			}
		}
		
		// Add the blogItem to the global blogEntries Array so that the view can access it.
		[userEntries addObject:[blogItem copy]];
	}
	
	NSLog(@"userEntries is: %@", userEntries);
}

/*********** NSURLDelegate */
- (void)theConnection:(NSURLConnection *)theConnection
	 didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [theConnection release];
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    [receivedData setLength:0];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	// do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
	
	CXMLDocument *xml = [[CXMLDocument alloc] initWithData:receivedData options:nil error:nil];
	[self convertXMLDocumentToEntries:xml];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"UserRefreshNotification" object:nil userInfo:nil];

	[connection release];
    [receivedData release];
}

@end
