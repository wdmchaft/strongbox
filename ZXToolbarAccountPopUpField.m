/*
 * Name: 	ZXToolbarAccountPopUpField.m
 * Project:	Strongbox
 * Created on:	2008-06-03
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

#import "ZXToolbarAccountPopUpField.h"


@implementation ZXToolbarAccountPopUpField
- (void)awakeFromNib
{
	[self setView:customPopUp];
	[self setMinSize:NSMakeSize(100, NSHeight([customPopUp frame]))];
	[self setMaxSize:NSMakeSize(150, NSHeight([customPopUp frame]))];
}
@end
