/*
 * Name: 	ZXAccountMO.m
 * Project:	Strongbox
 * Created on:	2008-07-16
 *
 * Copyright (C) 2008 Pierre-Hans Corcoran
 *
 * --------------------------------------------------------------------------
 *  This program is  free software;  you can redistribute  it and/or modify it
 *  under the terms of the GNU General Public License (version 2) as published 
 *  by  the  Free Software Foundation.  This  program  is  distributed  in the 
 *  hope  that it will be useful,  but WITHOUT ANY WARRANTY;  without even the 
 *  implied warranty of MERCHANTABILITY  or  FITNESS FOR A PARTICULAR PURPOSE.  
 *  See  the  GNU General Public License  for  more  details.  You should have 
 *  received  a  copy  of  the  GNU General Public License   along  with  this 
 *  program;   if  not,  write  to  the  Free  Software  Foundation,  Inc., 51 
 *  Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 * --------------------------------------------------------------------------
 */

#import "ZXAccountMO.h"
#import "ZXTransactionMO.h"
#import "ZXNotifications.h"
#import "ZXAccountMergeController.h"
#import "ZXAppController.h"

@implementation ZXAccountMO
//! Posts a notification if name is changed
/*!
 Use specialSetName: to avoid notification posting.
 \sa specialSetName:
 */
- (void)setValue:(id)value forKey:(NSString *)key
{
	[super setValue:value forKey:key];
	if([key isEqual:@"name"] && [ZXAppController shouldPostNotifications]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:ZXAccountNameDidChangeNotification object:self];
	}
}

- (void)specialSetName:(NSString *)newName
{
	[super setValue:newName forKey:@"name"];
}

- (void)recalculateBalance:(NSNotification *)note
{
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:self.managedObjectContext];
	
	NSPredicate *balancePredicate = [NSPredicate predicateWithFormat: @"account == %@", self];
	id dateSort = [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES] autorelease]];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity:entityDescription];
	[fetchRequest setPredicate:balancePredicate];
	[fetchRequest setSortDescriptors:dateSort];
	NSError *error = nil;
	NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if(array == nil) {
		return;
	}
	
	double balance = 0;
	for(id obj in array) {
		double add = [[obj valueForKey:@"deposit"] doubleValue] - [[obj valueForKey:@"withdrawal"] doubleValue];
		balance += add;
		[obj setValue:[NSNumber numberWithDouble:balance] forKey:@"balance"];
	}
	[self setValue:[NSNumber numberWithDouble:balance] forKey:@"balance"];
}

- (void)mergeWithAccounts:(NSArray *)allAccounts controller:(id)controller
{
	NSMutableArray *newAccounts = [allAccounts mutableCopy];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Transaction" 
							     inManagedObjectContext:self.managedObjectContext];
	
	[newAccounts removeObjectIdenticalTo:self];
	
	NSPredicate *accountPredicate = [NSPredicate predicateWithFormat:@"account IN %@", newAccounts];
		
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity:entityDescription];
	[fetchRequest setPredicate:accountPredicate];
	NSError *error = nil;
	NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest 
								  error:&error];
	if(array == nil) {
		return;
	}
	[controller setValue:[NSNumber numberWithInt:[array count]] 
		      forKey:@"progressTotal"];
	[controller setValue:[NSNumber numberWithInt:0] 
		      forKey:@"progressCount"];
	int i = 0;
	for(ZXTransactionMO *tx in array) {
		[controller setValue:[NSNumber numberWithInt:i] 
			      forKey:@"progressCount"];
		[controller updateView:self];
		[tx setValue:self forKey:@"account"];
		i += 1;
	}
	[controller updateView:self];
	for(id acc in newAccounts) {
		if(acc == self) continue;
		[self.managedObjectContext deleteObject:acc];
	}
	if([ZXAppController shouldPostNotifications]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:ZXAccountTotalDidChangeNotification 
								    object:self];
	}
}
@end
