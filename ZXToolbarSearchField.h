/*
 * Name: 	ZXToolbarSearchField.h
 * Project:	Strongbox
 * Created on:	2008-03-11
 *
 * Copyright (C) 2008 Pierre-Hans Corcoran
 *
 * --------------------------------------------------------------------------
 *  This program is free software; you can redistribute it and/or modify it
 *  under the terms of the GNU General Public License (version 2) as published 
 *  by the Free Software Foundation. This program is distributed in the 
 *  hope that it will be useful, but WITHOUT ANY WARRANTY; without even the 
 *  implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
 *  See the GNU General Public License for more details. You should have 
 *  received a copy of the GNU General Public License along with this 
 *  program; if not, write to the Free Software Foundation, Inc., 51 
 *  Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 * --------------------------------------------------------------------------
 */

#import <Cocoa/Cocoa.h>

//! Custom toolbar search field
/*!
 Display a search field in the ZXDocument toolbar. Filters the visible transactions
 based on name and label.
 */
@interface ZXToolbarSearchField : NSToolbarItem {
	//! Link to the custom view in the XIB file
	/*! The custom view is in the ZXDocument.xib file, in a dummy window. */
	IBOutlet NSSearchField *customSearchField;
}
//! Automatically called when waking the view
/*! Sets up the view, specifying hard-coded custom size */
- (void)awakeFromNib;
@end
