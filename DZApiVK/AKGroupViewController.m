//
//  AKGroupViewController.m
//  DZApiVK
//
//  Created by Kanat A on 20/10/16.
//  Copyright © 2016 ak. All rights reserved.
//

#import "AKGroupViewController.h"
#import "VKMessageVC.h"
#import "VKAddPostVC.h"
#import "VKCommentsController.h"
#import "DetailViewController.h"

#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>

#import "AKServerManager.h"

#import "AKPostCell.h"
#import "VKPostCell1.h"
#import "VKAddPostCell.h"
#import "UITableViewCell+CellForContent.h"

#import "AKUser.h"
#import "VKPost.h"
#import "VKGroup.h"
#import "VKPhoto.h"

@interface AKGroupViewController ()

@property (strong, nonatomic) NSMutableArray* postArray;
@property (assign, nonatomic) BOOL firstTimeAppear;
@property (assign, nonatomic) BOOL loadingData;
@property (nonatomic, strong) UIRefreshControl *topRefreshControl;

@property (strong, nonatomic) VKPost* post;

@end

@implementation AKGroupViewController

static NSInteger postsInRequest = 10;


- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.firstTimeAppear = YES;
    self.postArray = [NSMutableArray array];
    
    UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(refreshWall)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    UIRefreshControl* refreshControl2 = [[UIRefreshControl alloc] init];
    refreshControl2.triggerVerticalOffset = 100.;
    [refreshControl2 addTarget:self
                        action:@selector(refreshBottom)
              forControlEvents:UIControlEventValueChanged];
    self.tableView.bottomRefreshControl = refreshControl2;

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    
    if (self.firstTimeAppear) {
        self.firstTimeAppear = NO;
        
        [[AKServerManager sharedManager] authorizeUser:^(AKUser *user) {
            [AKServerManager sharedManager].currentUser = user;
            [self getPostsFromServer];
        }];
    }
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.tableView.estimatedRowHeight = 65.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
  
    NSOperationQueue* mQueue = [NSOperationQueue mainQueue];
    __weak AKGroupViewController* weakSelf = self;
    
     // если пользователь на айфоне в бакграунде сменит шрифт
    [[NSNotificationCenter defaultCenter]
     addObserverForName:UIContentSizeCategoryDidChangeNotification
     object:nil
     queue:mQueue
     usingBlock:^(NSNotification * _Nonnull note) {
         [weakSelf.tableView reloadData];
     }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return [self.postArray count];
    }
}


#pragma mark -
#pragma mark Cell Data Source

- (UITableViewCell *) tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"PostCell";
    static NSString* identifier1 = @"PostCell1";
    static NSString* identifierAdd = @"AddPostCell";
    
                   //** Add post with Callback **
    if (indexPath.section == 0) {
        VKAddPostCell* addCell = (VKAddPostCell*)[tableView dequeueReusableCellWithIdentifier:identifierAdd];
        
        [addCell configureCellWithStarCallback:^{
                // вызываем VC с которого отправим пост
            VKAddPostVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VKAddPostVC"];
            [self.navigationController pushViewController:vc animated:YES];
            
            NSLog(@"configureCellWithStarCallback");
        }];
        return addCell;

    } else {
        VKPost* post = [self.postArray objectAtIndex:indexPath.row];
        
                  //** если атташмент фото **
        if ([post.attachmentPhotos count] > 0) {
            
            AKPostCell* cell = (AKPostCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
            
            NSString* likes = [NSString stringWithFormat:@"%lu", post.likesCount];
            NSString* comments = [NSString stringWithFormat:@"%lu", post.commentsCount];
            
            cell.postCellLabel.text = post.text;
            [cell.addLikeButton    setTitle:likes    forState:UIControlStateNormal];
            [cell.addCommentButton setTitle:comments forState:UIControlStateNormal];
            cell.dateLabel.text = post.date;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            // specify different text styles for different blocks of text
            cell.postCellLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            cell.dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            cell.userNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            
            NSURLRequest* request = nil;
            if (post.from_group != nil) {
                NSURL* URL = [NSURL URLWithString:post.from_group.photo_50];
                request = [NSURLRequest requestWithURL:URL];
                cell.userNameLabel.text = post.from_group.name;
                cell.userImageView.userInteractionEnabled = NO;
                
            } else if (post.from_user != nil) {
                NSURL* URL = post.from_user.imageURL;
                request = [NSURLRequest requestWithURL:URL];
                cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@",
                                           post.from_user.firstName, post.from_user.lastName];
                cell.userImageView.userInteractionEnabled = YES;
            }
            
            cell.userImageView.image = nil;
            [self setImageInCell:cell withRequest:request imageView:cell.userImageView];
        
            NSURLRequest* requestAttachmentPhoto = nil;
            
            for (VKPhoto* photo in post.attachmentPhotos) {
                if (photo.src_big) {
                    NSURL* url = [NSURL URLWithString:photo.src_big];
                    requestAttachmentPhoto = [NSURLRequest requestWithURL:url];
                }
            }
            
            cell.attachmentPhotoImageView.image = nil;
            [self setImageInCell:cell withRequest:requestAttachmentPhoto imageView:cell.attachmentPhotoImageView];
            
                // откроем фото атташмент по тапу
            cell.attachmentPhotoImageView.userInteractionEnabled = YES;
        
            
            UITapGestureRecognizer *tapGesture =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(openImageVC:)];
            [cell.attachmentPhotoImageView addGestureRecognizer:tapGesture];

               // Отправка сообщений по тапу на автора
            UITapGestureRecognizer* tapUserImageGesture =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(handleTapOnIUserImage:)];
            
            [cell.userImageView addGestureRecognizer:tapUserImageGesture];
            
            return cell;
   
        } else {
                //** без атташмент фото **
            
            VKPostCell1* cell = (VKPostCell1*)[tableView dequeueReusableCellWithIdentifier:identifier1];
            
            NSString* likes = [NSString stringWithFormat:@"%lu", post.likesCount];
            NSString* comments = [NSString stringWithFormat:@"%lu", post.commentsCount];
            
            cell.postCellLabel.text = post.text;
            [cell.addLikeButton    setTitle:likes    forState:UIControlStateNormal];
            [cell.addCommentButton setTitle:comments forState:UIControlStateNormal];
            cell.dateLabel.text = post.date;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                // specify different text styles for different blocks of text
            cell.postCellLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            cell.dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            cell.userNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            
            NSURLRequest* request = nil;
            
            if (post.from_group != nil) {
                NSURL* URL = [NSURL URLWithString:post.from_group.photo_50];
                request = [NSURLRequest requestWithURL:URL];
                cell.userNameLabel.text = post.from_group.name;
                
            } else if (post.from_user != nil) {
                NSURL* URL = post.from_user.imageURL;
                request = [NSURLRequest requestWithURL:URL];
                cell.userNameLabel.text = [NSString stringWithFormat:@"%@ %@",
                                           post.from_user.firstName, post.from_user.lastName];
            }
            
            cell.userImageView.image = nil;
            [self setImageInCell:cell withRequest:request imageView:cell.userImageView];
            
                // Отправка сообщений по тапу на автора
            cell.userImageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer* tapUserImageGesture =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(handleTapOnIUserImage:)];
            [cell.userImageView addGestureRecognizer:tapUserImageGesture];
            
            return cell;
        }
    }
    
    return nil;
}


#pragma mark - Helper for Cells

- (void) setImageInCell:(UITableViewCell*)cell
            withRequest:(NSURLRequest*)request imageView:(UIImageView*)iV {
    
    UIImageView* imView;
    UITableViewCell* weakCell;
    
    if ([cell isKindOfClass:[VKPostCell1 class]]) {
       VKPostCell1* localCell = (VKPostCell1*)cell;
        imView = localCell.userImageView;
    }
    
    if ([cell isKindOfClass:[AKPostCell class]]){
        AKPostCell* localCell = (AKPostCell*)cell;
        
        if ([iV isEqual:localCell.userImageView]) {
            imView = localCell.userImageView;
        } else if ([iV isEqual:localCell.attachmentPhotoImageView]) {
            imView = localCell.attachmentPhotoImageView;
        }
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

}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension; // Auto Layout elements in the cell
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}


- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        VKCommentsController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VKCommentsController"];
        VKPost* post = [self.postArray objectAtIndex:indexPath.row];
        vc.post = post;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}




#pragma mark - UITapGestureRecognizer

- (void) handleTapOnIUserImage:(UITapGestureRecognizer*)recognizer {
    
      // 1 the view the gesture is attached to.
    UIImageView* imageView = (UIImageView*)recognizer.view;
    
      // 2 используя рекурсию находим супервью Cell
    VKPostCell1* cell = (VKPostCell1*)[UITableViewCell getParentCellFor:imageView];
    
      // 3 берем идекс пасс этой Cell
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
      // 4 из массива данных берем post по этому индексу
    VKPost* post = [self.postArray objectAtIndex:indexPath.row];
    
     // берем VC из сториборда со всеми его UI элементами
    VKMessageVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VKMessageVC"];
    
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

- (void) getPostsFromServer {
    
    [[AKServerManager sharedManager]
     getGroupWall:@"58860049"           // 58860049 5670544 131176878
     withOffset:[self.postArray count]
     count:postsInRequest
     onSucces:^(NSArray *posts) {
         [self.postArray addObjectsFromArray:posts];
         
         NSMutableArray* newPaths = [NSMutableArray array];
         
         // начинаем с существующих рядов и до скольки должно быть рядов
         for (int i = (int)[self.postArray count] - (int)[posts count]; i < [self.postArray count]; i++) {
             [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:1]];
         }
         
         [self.tableView beginUpdates];
         [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
         [self.tableView endUpdates];
     }
     onFailure:^(NSError *error) {
         NSLog(@"error = %@", [error localizedDescription]);
     }];
}


#pragma mark - Refresh Actions

- (void) refreshBottom {
    
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [[AKServerManager sharedManager]
         getGroupWall:@"58860049"
         withOffset:[self.postArray count]
         count:postsInRequest
         onSucces:^(NSArray *posts) {
             
             [self.postArray addObjectsFromArray:posts];
             NSMutableArray* newPaths = [NSMutableArray array];
             
               // начинаем с существующих рядов и до скольки должно быть рядов
             for (int i = (int)[self.postArray count] - (int)[posts count]; i < [self.postArray count]; i++) {
                 [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:1]];
             }
             
             [self.tableView beginUpdates];
             [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
             [self.tableView endUpdates];
         }
         onFailure:^(NSError *error) {
             NSLog(@"error = %@", [error localizedDescription]);
         }];
        
        [self.tableView.bottomRefreshControl endRefreshing];
    });
}


- (void) refreshWall {
    
    [[AKServerManager sharedManager] getGroupWall:@"58860049"
                                       withOffset:0
                                            count:MAX(postsInRequest, [self.postArray count])
                                         onSucces:^(NSArray *posts) {
                                             [self.postArray removeAllObjects];
                                             [self.postArray addObjectsFromArray:posts];
                                             
                                             [self.tableView reloadData];
                                             [self.refreshControl endRefreshing];
                                         }
                                        onFailure:^(NSError *error) {
                                            NSLog(@"error = %@", [error localizedDescription]);
                                            [self.refreshControl endRefreshing];
                                        }];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIContentSizeCategoryDidChangeNotification
     object:nil];
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].

 }
 











@end
