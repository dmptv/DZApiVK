//
//  SampleTableViewController.m
//  DZApiVK
//
//  Created by Dima Tixon on 09/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import "SampleTableViewController.h"

@interface SampleTableViewController ()

@end

@implementation SampleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



/*
 The part I'm showing below is for displaying the messages and does not include the reply widget. This should help get people started in a direction that did what I wanted it to do.
 
 I did this using a tableview, a custom cell containing a UITextView property (but did not add the textview in the storyboard, it is instantiated in code), and a table data array containing instances of my SDMessage class.
 Here is the contents of the SDMessage class interface file:
 
 @interface SDMessage : NSObject
 
 @property (nonatomic, strong) NSNumber *message_id;
 @property (nonatomic, strong) NSString *message_sender;
 @property (nonatomic, strong) NSString *message_content;
 @property (nonatomic, strong) NSString *their_id;
 @property (nonatomic, strong) NSString *timestamp;
 @property (nonatomic, strong) NSDate *dateTime;
 @property (nonatomic, strong) NSString *prettyTimestamp;
 @property (nonatomic, strong) NSNumber *seen;
 
 */



/*
  tableview delegate methods are as follows:
 
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MsgDetailCell";
    MsgDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (!cell) {
        cell = [[MsgDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.frame = CGRectMake(2, 2, tableView.frame.size.width - 4, 30);
    }
    
    // Since we are creating a new UITextfield with every load, set any existing UITextfield instance to nil
    [cell.message removeFromSuperview];
    cell.message = nil;
    
    
    // get the data for this cell (returns self.tableData[indexPath.row])
    SDMessage *cellData = [self cellDataForRowAtIndexPath:indexPath];
    
    // get sender id to configure appearance (if we're sending a message it will appear
    // on the right side, if we received a message the message will be on the left side of the screen)
    long long   theirId = [cellData.message_sender longLongValue];
    
    // we have to do this in code so we can set the frame once and avoid cut off text
    cell.message = [[UITextView alloc] init];
    
    // set cell text
    cell.message.text = cellData.message_content;
    
    // set font and text size (I'm using custom colors here defined in a category)
    [cell.message setFont:[UIFont fontWithName:kMessageFont size:kMessageFontSize]];
    [cell.message setTextColor:[UIColor gh_messageTextColor]];
    
    // our messages will be a different color than their messages
    UIColor *msgColor = (theirId == _myUid) ? [UIColor gh_myMessageBgColor] : [UIColor gh_theirMessageBgColor];
    
    // I want the cell background to be invisible, and only have the
    // message background be colored
    cell.backgroundColor = [UIColor clearColor];
    cell.message.backgroundColor = msgColor;
    cell.message.layer.cornerRadius = 10.0;
    
    // make the textview fit the content (kMessageWidth = 220, kMessageBuffer = 15 ... buffer is amount of space from edge of cell)
    CGSize newSize = [cell.message sizeThatFits:CGSizeMake(kMessageWidth, MAXFLOAT)];
    CGRect newFrame;
    
    // since we are placing the message bubbles justified right or left on the screen
    // we determine if this is our message or someone else's message and set the cell
    // origin accordingly... (if the sender of this message (e.g. theirId) is us, then take the width
    // of the cell, subtract our message width and our buffer and set that x position as our origin.
    // this will position messages we send on the right side of the cell, otherwise the other party
    // in our conversation sent the message, so our x position will just be whatever the buffer is. (in this case 15)
    float originX = (theirId == _myUid) ? cell.frame.size.width - kMessageWidth - kMessageBuffer : kMessageBuffer;
    
    // set our origin at our calculated x-point, and y position of 10
    newFrame.origin = CGPointMake(originX, 10);
    
    // set our message width and newly calculated height
    newFrame.size = CGSizeMake(fmaxf(newSize.width, kMessageWidth), newSize.height);
    
    // set the frame of our textview and disable scrolling of the textview
    cell.message.frame = newFrame;
    cell.message.scrollEnabled  = NO;
    cell.userInteractionEnabled = NO;
    
    // add our textview to our cell
    [cell addSubview:cell.message];
    
    return cell;
}



-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we need to make sure our cell is tall enough so we don't cut off our message bubble
    MsgDetailCell *cell = (MsgDetailCell*)[self tableView:self.tableview cellForRowAtIndexPath:indexPath];
    
    // get the size of the message for this cell
    CGSize newSize = [cell.message sizeThatFits:CGSizeMake(kMessageWidth, MAXFLOAT)];
    
    // get the height of the bubble and add a little buffer of 20
    CGFloat textHeight  = newSize.height + 20;
    
    // don't make our cell any smaller than 60
    textHeight          = (textHeight < 60) ? 60 : textHeight;
    
    return textHeight;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLog(@"didSelectRow: %ld", (long)indexPath.row);
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

*/

/*
 
 // set the desired width of the textbox that will be holding the adjusted text, (for clarity only, set as property or ivar)
 CGFloat widthOfMyTexbox = 250.0;
 
 -(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 //Get a reference to your string to base the cell size on.
 NSString *cellText = [self.tableData objectAtIndex:indexPath.row];
 
 //set the desired size of your textbox
 CGSize constraint = CGSizeMake(widthOfMyTextBox, MAXFLOAT);
 
 //set your text attribute dictionary
 NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14.0] forKey:NSFontAttributeName];
 
 //get the size of the text box
 CGRect textsize = [cellText boundingRectWithSize:constraint
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
 
 //calculate your size
 float textHeight = textsize.size.height +20;
 
 //I have mine set for a minimum size
 textHeight = (textHeight < 50.0) ? 50.0 : textHeight;
 
   return textHeight;
 
 }
 
 */




@end
