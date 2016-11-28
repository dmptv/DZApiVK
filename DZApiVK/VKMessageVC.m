//
//  VKMessageVC.m
//  DZApiVK
//
//  Created by Dima Tixon on 07/11/2016.
//  Copyright © 2016 ak. All rights reserved.
//

#import "VKMessageVC.h"
#import "JSQMessagesCollectionView.h"
#import "AKServerManager.h"
#import "VKPost.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>


@interface VKMessageVC () <UITextViewDelegate>

     //== messages is an array to store the various instances of JSQMessage in your app.
@property (strong, nonatomic) NSMutableArray *messages;

     //== Outgoing messages are displayed to the right and incoming messages on the left.
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (strong, nonatomic) NSOperation *currentOperation;
@property (strong, nonatomic) NSOperationQueue *queue;

@property (strong, nonatomic) UIImage *imageAvatarIncoming;
@property (strong, nonatomic) UIImage *imageAvatarOutgoing;

@end

@implementation VKMessageVC




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // рефреш снизу
    
    UIRefreshControl *refreshControlBottom = [[UIRefreshControl alloc] init];
    refreshControlBottom.triggerVerticalOffset = 100.;
    [refreshControlBottom addTarget:self
                             action:@selector(refreshBottom:)
                   forControlEvents:UIControlEventValueChanged];
    self.collectionView.bottomRefreshControl = refreshControlBottom;
    
    
    
    // рефреш сверху
    
    UIRefreshControl *refreshControlTop = [[UIRefreshControl alloc] init];
    [refreshControlTop addTarget:self
                          action:@selector(refreshTop:)
                forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControlTop];
    
    
    
    
    self.navigationItem.title = self.senderDisplayName;

    
      //== data source
    
    self.messages = [NSMutableArray array];
    
    
    
       // аватары взяли из image URL юзера и current usera
    
    self.imageAvatarOutgoing = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.avatarOutgoing]];
    self.imageAvatarIncoming= [UIImage imageWithData:[NSData dataWithContentsOfURL:self.avatarIncoming]];
    
    
    
    
    [self getHistoryMessagesBackgroundFromServer:20 offset:0];
    
    
    
    
       //== JSQMessagesBubbleImageFactory has methods that create the images for the chat bubbles.
    
    JSQMessagesBubbleImageFactory *bubbleFactory= [[JSQMessagesBubbleImageFactory alloc] init];
    
       //==  create the images for outgoing and incoming messages respectively.
       //== And with that, you have the image views needed
       //== to create outgoing and incoming message bubbles!
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    
    
    self.inputToolbar.contentView.textView.delegate = self;

}




- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}




#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self setShowTypingIndicator:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self setShowTypingIndicator:NO];
}





- (void)refreshBottom:(UIRefreshControl *)refreshControl {
    [self updateMessages];
    [refreshControl endRefreshing];
}

- (void)refreshTop:(UIRefreshControl *)refreshControl {
    [self getHistoryMessagesBackgroundFromServer:20 offset:[self.messages count]];
    [refreshControl endRefreshing];
}




#pragma mark - Send Button

      //== This helper method creates a new JSQMessage and adds it to the data source.

- (void)didPressSendButton:(UIButton *)button  withMessageText:(NSString *)text
                                                      senderId:(NSString *)senderId
                                             senderDisplayName:(NSString *)senderDisplayName
                                                          date:(NSDate *)date {
     [self sendMessage:text];
}


- (void)sendMessage:(NSString *)message {
    [[AKServerManager sharedManager] sendMessageForUserId:self.senderId
                                                  message:message
                                                onSuccess:^(id result) {
                                                    
                                                    // очищает inputToolbar от отправленного текста
                                                    
                                                    [self finishSendingMessageAnimated:YES];
                                                    [self getHistoryMessagesBackgroundFromServer:10 offset:0];
                                                }
                                                onFailure:^(NSError *error) {
                                                    NSLog(@"error = %@", [error localizedDescription]);
                                                }];
}




#pragma mark - JSQMessagesCollectionViewDataSource

      //== is much like collectionView(_:cellForItemAtIndexPath:), but for message data.

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView
                                                                 messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
       //Return the actual message at each indexpath.row
    
    return [self.messages objectAtIndex:indexPath.item];
}




       //== This asks the data source for the message bubble image data
       //== that corresponds to the message item at indexPath in the collectionView.

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
                                                                messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {

         //== Here you retrieve the message.
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if (![self incoming:message]) {
        
        //== If the message was sent by the local user, return the outgoing image view.
        
        return self.outgoingBubbleImageData;
        
    } else {
        
        //== Otherwise, return the incoming image view.
        
        return self.incomingBubbleImageData;
    }
}




        //== JSQMessagesViewController provides support for avatars

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
                                                                    avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    UIImage *image = nil;
    
    if (![self incoming:message]) {
        image = self.imageAvatarIncoming;
    } else {
        image = self.imageAvatarOutgoing;
    }
    
    JSQMessagesAvatarImage *avatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:20];
    
    return avatar;
}




- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView
                                               attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[dateFormatter stringFromDate:message.date]];
    
    return attributedString;
}




- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView
                                         attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *message = self.messages[indexPath.item];
    
    if ([self incoming:message]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        
        JSQMessage *previous = self.messages[indexPath.item - 1];
        
        if ([previous.senderId isEqualToString:message.senderId]) {
            return nil;
        }
        
    }
    
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}




#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}




       //==  the standard way to return the number of items in each section; in this case, the number of messages.

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.messages count];
}




     //==  set the text color,

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView
                                                                     cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessagesCollectionViewCell *cell =
    (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
          //== specifying whether or not the message contains media.
    
    if (!message.isMediaMessage) {
        
        if (![self incoming:message]) {
            cell.textView.textColor = [UIColor blackColor];
        } else {
            
              //== If the message is sent by the local user, the text color is white
            
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        
           //== Style for links
        
        cell.textView.linkTextAttributes =
        @{ NSForegroundColorAttributeName : cell.textView.textColor,
           NSUnderlineStyleAttributeName  : @(NSUnderlineStyleThick | NSUnderlinePatternSolid)};
    }
    
    return cell;
}




#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout
                                                                     heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 0.0f;
}




- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout
                                                            heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
      //iOS7-style sender name labels
    
    JSQMessage *currentMessage = [self.messages objectAtIndex:indexPath.item];
    
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    if (indexPath.item - 1 > 0) {
        
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
        
    }
    
    return 0.0f;
}




- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout
                                                                 heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    return kJSQMessagesCollectionViewAvatarSizeDefault;
}




#pragma mark - Synchronizing the Data Source

        // вызывается при рефреш сверху

- (void)getHistoryMessagesBackgroundFromServer:(NSInteger)count offset:(NSInteger)offset {
  
    __weak NSOperation *weakCurrentOperation = self.currentOperation;
    __weak VKMessageVC* weakSelf = self;
    
    self.queue = [[NSOperationQueue alloc] init];
    
    self.currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        if (![weakCurrentOperation isCancelled]) {
            [weakSelf getHistoryMessagesFromServer:count offset:offset];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.collectionView reloadData];
            self.currentOperation = nil;
            
        });
    }];
    
    
    [self.queue addOperation:self.currentOperation];
}




       //== you should see any messages sent earlier along with any new ones you enter:

- (void)getHistoryMessagesFromServer:(NSInteger)count offset:(NSInteger)offset {
    
    [[AKServerManager sharedManager] getHistoryMessagesFromUserId:self.senderId
                                                      senderName:self.senderDisplayName
                                                           count:count
                                                          offset:offset
                                                       onSuccess:^(NSArray *array) {
                                                           
                                                           [self.messages addObjectsFromArray:array];
                                                           
                                                           NSSortDescriptor *date = [[NSSortDescriptor alloc]
                                                                                     initWithKey:@"date" ascending:YES];
                                                           
                                                           [self.messages sortUsingDescriptors:[NSArray arrayWithObject:date]];
                                                           
                                                           //NSLog(@"messages count = %ld", (unsigned long)[self.messages count]);
                                                           
                                                           [self.collectionView reloadData];
                                                           [self scrollToBottomAnimated:YES];
                                                           
                                                       }
                                                       onFailure:^(NSError *error) {
                                                           NSLog(@"error = %@", [error localizedDescription]);
                                                       }];
}




- (void)didPressAccessoryButton:(UIButton *)sender {
    /*
     UIActionSheet *sheet = 
     [[UIActionSheet alloc] initWithTitle:@"Media messages"
                                 delegate:self
                        cancelButtonTitle:@"Cancel"
                   destructiveButtonTitle:nil
                        otherButtonTitles:@"Send photo", @"Send location", @"Send video", nil];
     
     [sheet showFromToolbar:self.inputToolbar];
     */
}




#pragma mark - ABAddPostDelegate

- (void)updateMessages {
    [[AKServerManager sharedManager] getHistoryMessagesFromUserId:self.senderId
                                                       senderName:self.senderDisplayName
                                                            count:MAX(10, [self.messages count])
                                                           offset:0
                                                        onSuccess:^(NSArray *array) {
                                                            
                                                            [self.messages removeAllObjects];
                                                            [self.messages addObjectsFromArray:array];
                                                            
                                                            
                                                            // сортируем по дате
                                                            NSSortDescriptor *date = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
                                                            
                                                            [self.messages sortUsingDescriptors:[NSArray arrayWithObject:date]];
                                                            
                                                            
                                                            [self.collectionView reloadData];
                                                            
                                                        } onFailure:^(NSError *error) {
                                                            NSLog(@"error = %@", [error localizedDescription]);
                                                        }];
}




#pragma mark - Other methods

- (BOOL)incoming:(JSQMessage *)message {
    
      // если the current user sending messages то NO
    
    return ([message.senderId isEqualToString:self.senderId] == NO);
}



- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}





@end





















