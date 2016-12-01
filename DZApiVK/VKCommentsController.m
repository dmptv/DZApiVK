//
//  VKSLKController.m
//  DZApiVK
//
//  Created by Dima Tixon on 16/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import "VKCommentsController.h"
#import "AKServerManager.h"
#import "VKMessageVC.h"
#import "DetailViewController.h"

#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"

#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import "UITableViewCell+CellForContent.h"
#import "UITableView+ScrolledToBottom.h"

#import "VKPost.h"
#import "AKUser.h"
#import "VKPhoto.h"
#import "VKGroup.h"
#import "VKComment.h"

#import "AKPostCell.h"
#import "VKPostCell1.h"
#import "VKPostDetailCell.h"
#import "VKCommentCell.h"
#import "AddComCell.h"


@interface VKCommentsController () <UITextFieldDelegate>

@property (nonatomic, strong) VKPostDetailCell *postCell;
@property (nonatomic, strong) VKCommentCell *commentCell;

@property (strong, nonatomic) NSMutableArray* commentsArray;
@property (strong, nonatomic) NSMutableArray* attachementsArray;

@property (strong, nonatomic) UITextField* commentTetxField;
@property (strong, nonatomic) NSIndexPath* editingIndexPath;

@end

@implementation VKCommentsController

static NSString *commentIdentifier =  @"PostDetailCell";
static NSString *commentIdentifier2 =  @"VKCommentCell";
static NSString *commentIdentifier3 =  @"AddComCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.commentsArray = [NSMutableArray array];
    [self getCommentsWithCount:20 withOffset:0];

    UITapGestureRecognizer* tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self.view
                                            action:@selector(endEditing:)];
    
    // endEditing - self.view убирает текстфилды с firstResponder
    [self.tableView addGestureRecognizer:tap];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboard:)
     name:UIKeyboardWillChangeFrameNotification
     object:nil];
}



- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void) dealloc {
    // Remove notification for keyboard change events
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillChangeFrameNotification
     object:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 1;
    } else  {
        return [self.commentsArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
            VKPostDetailCell* cell = (VKPostDetailCell*)[tableView dequeueReusableCellWithIdentifier:commentIdentifier];
            if (!cell) {
                cell = [[VKPostDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentIdentifier];
            }
            [self configureCell:cell forRowAtIndexPath:indexPath];
        
            return cell;

    } else if (indexPath.section == 1) {
        VKCommentCell* cell2 = [tableView dequeueReusableCellWithIdentifier:commentIdentifier2];
        if (!cell2) {
            cell2 = [[VKCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentIdentifier2];
        }
        [self configureCell2:cell2 forRowAtIndexPath:indexPath];
        
        return cell2;

    } else {
        AddComCell* cell3 = [tableView dequeueReusableCellWithIdentifier:commentIdentifier3];
        if (!cell3) {
            cell3 = [[AddComCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentIdentifier3];
        }
        [self configureCell3:cell3 forRowAtIndexPath:indexPath ];
        
        self.commentTetxField = cell3.commentTextField;
        
        
        [UIView animateWithDuration:0.3
                              delay:0.3
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self.commentTetxField becomeFirstResponder];
                         }
                         completion:nil];
    
        return cell3;
    }
    
    return nil;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView  heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}



#pragma mark - Configure Cells 1

- (void) configureCell:(VKPostDetailCell *)cell  forRowAtIndexPath:(NSIndexPath *)indexPath {

    VKPost* post = self.post;
    NSString* likes = [NSString stringWithFormat:@"%lu", (long)post.likesCount];
    
    cell.textBody.text = post.text;
    cell.likesLabel.text = likes;
    cell.datePostLabel.text = post.date;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
      // specify different text styles for different blocks of text
    cell.textBody.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cell.datePostLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    cell.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    cell.likesLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    
    NSURLRequest* request = nil;
    
    if (post.from_group != nil) {
        NSURL* URL = [NSURL URLWithString:post.from_group.photo_50];
        request = [NSURLRequest requestWithURL:URL];
        cell.nameLabel.text = post.from_group.name;
        cell.AvatarImage.userInteractionEnabled = NO;
        
    } else if (post.from_user != nil) {
        NSURL* URL = post.from_user.imageURL;
        request = [NSURLRequest requestWithURL:URL];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",
                               post.from_user.firstName, post.from_user.lastName];
        cell.AvatarImage.userInteractionEnabled = YES;
        
    }
    
    cell.AvatarImage.image = nil;
    __weak VKPostDetailCell* weakCell = cell;
    
    [cell.AvatarImage
     setImageWithURLRequest:request
     placeholderImage:nil
     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response,
               UIImage * _Nonnull image) {
         
         weakCell.AvatarImage.image = image;
         
         CALayer *imageLayer = weakCell.AvatarImage.layer;
         
         [imageLayer setCornerRadius:8.0f];
         [imageLayer setBorderWidth:3];
         [imageLayer setBorderColor:[UIColor whiteColor].CGColor];
         [imageLayer setMasksToBounds:YES];
         
         [weakCell layoutSubviews];
         
     }
     failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response,
               NSError * _Nonnull error) {
         NSLog(@"setImageWithURLRequest error %@", [error localizedDescription]);
     }];
    
      // установим фото из атташментс
    [self photosFromPost:post inCell:cell];
    

       // Отправка сообщений автору поста
    UITapGestureRecognizer* tapUserImageGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleTapOnIUserImage:)];
    [cell.AvatarImage addGestureRecognizer:tapUserImageGesture];
}


#pragma mark - Helper For Configure Cell

- (void) photosFromPost:(VKPost*)post inCell:(VKPostDetailCell*)cell {
    
    self.attachementsArray =
    [NSMutableArray arrayWithObjects:cell.attachementImage,
                                     cell.attachementImage2,
                                     cell.attachementImage3, nil];
    
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.attachementsArray];
    NSInteger countArray = [self.attachementsArray count];
    NSURLRequest* requestAttachmentPhoto = nil;
    int i = 0;
    
              // если фото атташ нет
    if ([post.attachmentPhotos count] == 0) {
        for (UIImageView* imageView in self.attachementsArray) {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 imageView.hidden = YES;
                             }];
        }
        
        return;
        
    } else {
               // если фото атташмент существует
        for (VKPhoto* photo in post.attachmentPhotos) {
            NSLog(@"photo.src_big %@", photo.src_big);
            
            UIImageView* imageView = [tempArray objectAtIndex:i++];
            
            // откроем фото атташмент по тапу
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tapGesture =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(openImageVC:)];
            [imageView addGestureRecognizer:tapGesture];
            
            // если используем photo
            if (photo.src_big) {
                NSURL* url = [NSURL URLWithString:photo.src_big];
                requestAttachmentPhoto = [NSURLRequest requestWithURL:url];
                
                  // удалим использованный imageView
                if ([self.attachementsArray count] > 0) {
                    [self.attachementsArray removeObjectAtIndex:0];
                }
                
                imageView.image = nil;
                [self setImageInCell:cell withRequest:requestAttachmentPhoto imageView:imageView];
                
                   // чтобы не падало когда кол-во фото больше чем имэйджВьюх
                if (i == countArray) {
                    break;
                }
            }
            
             //чтобы выходил из метода раньше чем все imageView.hidden
            continue;
        }
        
        // оставшиеся imageView сделаем hidden
        for (UIImageView* imageView in self.attachementsArray) {
            //imageView.hidden = YES;
            [UIView animateWithDuration:0.25
                             animations:^{
                                 imageView.hidden = YES;
                             }];
        }
        
    }
    
}


#pragma mark - Configure Cells 2

- (void) configureCell2:(VKCommentCell *)cell2 forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VKComment* comment = [self.commentsArray objectAtIndex:indexPath.row];
    
    cell2.textBodyLabel.text = comment.text;
    cell2.nameLabel.text = [NSString stringWithFormat:@"%@ %@", comment.user.firstName, comment.user.lastName];
    cell2.dateCommentLabel.text = comment.date;
    
    cell2.textBodyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cell2.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    cell2.dateCommentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    NSURLRequest* request = nil;
    request = [NSURLRequest requestWithURL:comment.user.imageURL];

    cell2.avatarImage.image = nil;
    [self setImageInCell:cell2 withRequest:request imageView:cell2.avatarImage];
    
    [cell2 layoutIfNeeded];
}


#pragma mark - Configure Cells 3

- (void) configureCell3:(AddComCell *)cell3 forRowAtIndexPath:(NSIndexPath *)indexPath {
         //cell.sendButton.selected
    cell3.sendButton.enabled = YES;
    
    // callback from AddComCell
    [cell3 configureCellWithSendCallback:^(NSString *text){
        [[AKServerManager sharedManager]
         commentToPost:self.post.Id   //self.post.Id @"37"
         fromWall:@"58860049"         // 131176878 58860049
         message:text
         onSuccess:^(id result) {
             [self refreshCommentsWithCount:20 withOffset:0];
             
              cell3.commentTextField.text = nil;
             [cell3 layoutSubviews];
         }
         onFailure:^(NSError *error) {
             NSLog(@"error %@", [error localizedDescription]);
         }];
    }];
    
    
    
    [cell3 layoutIfNeeded];
}


#pragma mark - Helper for Cells
- (void) setImageInCell:(UITableViewCell*)cell
            withRequest:(NSURLRequest*)request imageView:(UIImageView*)iView {
    
    UIImageView* imView;
    UITableViewCell* weakCell;
    
    if ([cell isKindOfClass:[VKPostDetailCell class]]) {
        imView = iView;
    }
    
    if ([cell isKindOfClass:[VKCommentCell class]]){
        VKCommentCell* localCell = (VKCommentCell*)cell;
        imView = localCell.avatarImage;
    }
    
    __weak UIImageView* weakImView = imView;
    
    [imView
     setImageWithURLRequest:request
     placeholderImage:nil
     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response,
               UIImage * _Nonnull image) {
         
         weakImView.image = image;
         
         CALayer *imageLayer = weakImView.layer; // берем layer у imageView
         [imageLayer setCornerRadius:8.0f];
         [imageLayer setBorderWidth:3];
         [imageLayer setBorderColor:[UIColor whiteColor].CGColor];
         [imageLayer setMasksToBounds:YES];
         
         [weakCell layoutSubviews];
         
     } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response,
                 NSError * _Nonnull error) {
         
         NSLog(@"setImageWithURLRequest error %@", [error localizedDescription]);
     }];
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(openImageVC:)];
    [imView addGestureRecognizer:tapGesture];
    
    
}



#pragma mark - Notifications actions

-(void)keyboard:(NSNotification *)notification {
      // Retrieve the keyboard begin / end frame values
    CGRect beginFrame = [[notification.userInfo
                          objectForKey:UIKeyboardFrameBeginUserInfoKey]
                                                           CGRectValue];
    CGRect endFrame =  [[notification.userInfo
                         objectForKey:UIKeyboardFrameEndUserInfoKey]
                                                        CGRectValue];
    
    CGFloat delta = (endFrame.origin.y - beginFrame.origin.y);
    
    // Lets only maintain the scroll position if we are already scrolled
    // at the bottom or if there is a change to the keyboard position
    
    if(self.tableView.scrolledToBottom && fabs(delta) > 0.0) {
        UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseIn |
                                         UIViewAnimationOptionBeginFromCurrentState;
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:options
                         animations:^{
 
                             // Make the tableview scroll opposite the change in keyboard offset.
                             // This causes the scroll position to match the change in table size 1 for 1
                             // since the animation is the same as the keyboard expansion
                             
                             self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y - delta);
                             
                         } completion:nil];
    }
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.commentTetxField isFirstResponder]) {
        [self.commentTetxField resignFirstResponder];
    }
    return YES;
}



#pragma mark - UITapGestureRecognizer

- (void) handleTapOnIUserImage:(UITapGestureRecognizer*)recognizer {
    
    /*
       // 1 the view the gesture is attached to.
    UIImageView* imageView = (UIImageView*)recognizer.view;
    
      // 2 используя рекурсию находим супервью Cell
    VKPostDetailCell* cell = (VKPostDetailCell*)[UITableViewCell getParentCellFor:imageView];
    
      // 3 берем идекс пасс этой Cell
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    */
    
    VKPost* post = self.post;
    
    VKMessageVC* vc =
    [self.storyboard instantiateViewControllerWithIdentifier:@"VKMessageVC"];
    
      // обязательные проперти объекта JSQMessagesViewController
    vc.senderId = post.from_user.user_id;
    vc.senderDisplayName = [NSString stringWithFormat:@"%@ %@",
                            post.from_user.firstName, post.from_user.lastName];
    
    vc.avatarIncoming = post.from_user.imageURL;
    vc.avatarOutgoing = [AKServerManager sharedManager].currentUser.imageURL;
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)openImageVC:(UITapGestureRecognizer*)recognizer {
    
    UIImageView* photoView = (UIImageView*)recognizer.view;
    
    UINavigationController* nav =
    [self.storyboard instantiateViewControllerWithIdentifier:@"DetailPhotoNav"];
    
    [nav setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    DetailViewController* vc = (DetailViewController *)[nav topViewController];
    vc.photo = [[UIImage alloc] init];
    vc.photo = photoView.image;
    
    [self presentViewController:nav animated:NO completion:nil];
}


#pragma mark - API

- (void) getCommentsWithCount:(NSInteger)count withOffset:(NSInteger)offset {
    [[AKServerManager sharedManager]
     getCommentsFromWall:@"58860049"
     postID:self.post.Id     //@"138917"
     withOffset:offset
     count:count
     onSuccess:^(NSArray *comments) {
         [self.commentsArray addObjectsFromArray:comments];
         
         NSMutableArray* newPaths = [NSMutableArray array];
         
           // вычисляем разницу между существ рядами и количеством комментов
         for (int i = (int)[self.commentsArray count] - (int)[comments count];
              i < [self.commentsArray count]; i++) {
             
             [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:1]];
         }
         
         [self.tableView beginUpdates];
         [self.tableView insertRowsAtIndexPaths:newPaths
                               withRowAnimation:UITableViewRowAnimationTop];
         [self.tableView endUpdates];
         
     }
     onFailure:^(NSError *error) {
          NSLog(@"error %@", [error localizedDescription]);
     }];
}


- (void) refreshCommentsWithCount:(NSInteger)count withOffset:(NSInteger)offset {
    [[AKServerManager sharedManager]
     getCommentsFromWall:@"58860049"
     postID:self.post.Id     //@"138917"
     withOffset:offset
     count:count
     onSuccess:^(NSArray *comments) {
         
         [self.commentsArray removeAllObjects];
         [self.commentsArray addObjectsFromArray:comments];

         [self.tableView reloadData];
         
     }
     onFailure:^(NSError *error) {
         NSLog(@"error %@", [error localizedDescription]);
     }];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
 */


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
 */


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
