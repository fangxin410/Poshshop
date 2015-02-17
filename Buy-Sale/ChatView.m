//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Parse/Parse.h>
#import "ProgressHUD.h"

#import "AppConstant.h"

#import "ChatView.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface ChatView()
{
	NSTimer *timer;
	BOOL isLoading;

	NSString *chatroom;

    
	NSMutableArray *messages;
    

	UIImageView *outgoingBubbleImageView;
	UIImageView *incomingBubbleImageView;
}
@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation ChatView

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWith:(NSString *)chatroom_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	self = [super init];
	chatroom = chatroom_;
	return self;
}

#pragma mark Side Swiping under iOS 4.x
- (BOOL) gestureRecognizersSupported
{
    // Apple's docs: Although this class was publicly available starting with iOS 3.2, it was in development a short period prior to that
    // check if it responds to the selector locationInView:. This method was not added to the class until iOS 3.2.
    return [[[UISwipeGestureRecognizer alloc] init] respondsToSelector:@selector(locationInView:)];
}
- (void) setupGestureRecognizers
{
    // Do nothing under 3.x
    if (![self gestureRecognizersSupported]) return;
    
    // Setup a right swipe gesture recognizer
    UISwipeGestureRecognizer* rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestureRecognizer];
    
}

// Called when a right swipe ocurred
- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer
{
    [self dismissModalViewControllerAnimated:YES];
}



//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
    [self setupGestureRecognizers];
	self.title = @"Chat";

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived) name:@"pushNotification" object:nil];
    
    
	messages = [[NSMutableArray alloc] init];
    

	self.sender = [PFUser currentUser].objectId;

	outgoingBubbleImageView = [JSQMessagesBubbleImageFactory outgoingMessageBubbleImageViewWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
	incomingBubbleImageView = [JSQMessagesBubbleImageFactory incomingMessageBubbleImageViewWithColor:[UIColor jsq_messageBubbleGreenColor]];

	isLoading = NO;
	[self loadMessages];
}


-(void)pushNotificationReceived
{
    [self loadMessages];
    
}


//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidAppear:animated];

	self.collectionView.collectionViewLayout.springinessEnabled = YES;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewWillDisappear:animated];
	[timer invalidate];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadMessages
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (isLoading == NO)
	{
		isLoading = YES;
		JSQMessage *message_last = [messages lastObject];

		PFQuery *query1 = [PFQuery queryWithClassName:PF_CHAT_CLASS_NAME];
		
        
        [query1 whereKey:@"touser" equalTo:self.touser];
        
        
        [query1 whereKey:@"fromuser" equalTo:[PFUser currentUser].email];
        
        ///query2
        
        PFQuery *query2 = [PFQuery queryWithClassName:PF_CHAT_CLASS_NAME];
		
        [query2 whereKey:@"ProductId" equalTo:self.objectId];
        
		[query2 whereKey:@"fromuser" equalTo:self.touser];
        
        
        [query2 whereKey:@"touser" equalTo:[PFUser currentUser].email];
        
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1,query2]];
        
        
        [query whereKey:@"ProductId" equalTo:self.objectId];
        
		if (message_last != nil) [query whereKey:PF_CHAT_CREATEDAT greaterThan:message_last.date];
		[query includeKey:PF_CHAT_USER];
		[query orderByAscending:PF_CHAT_CREATEDAT];
        
		[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
		{
			if (error == nil)
			{
				for (PFObject *object in objects)
				{
                    if ([[PFUser currentUser].email isEqualToString:object[@"touser"]]) {
                        object[@"unread"] = @"0";
                        [object saveInBackground];
                    }
                    
                    
					PFUser *user = object[PF_CHAT_USER];
					
					JSQMessage *message = [[JSQMessage alloc] initWithText:object[PF_CHAT_TEXT] sender:user.objectId date:object.createdAt];
					[messages addObject:message];
				}
				if ([objects count] != 0) [self finishReceivingMessage];
			}
			else [ProgressHUD showError:@"Network error."];
			isLoading = NO;
		}];
	}
}

#pragma mark - JSQMessagesViewController method overrides

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text sender:(NSString *)sender date:(NSDate *)date
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    PFUser* currentUser = [PFUser currentUser];
	PFObject *object = [PFObject objectWithClassName:PF_CHAT_CLASS_NAME];
    
    [object setObject:currentUser forKey:PF_CHAT_USER];
    [object setObject:currentUser.email forKey:@"fromuser"];
    [object setObject:self.touser forKey:PF_CHAT_TO_USER];
    [object setObject:text forKey:PF_CHAT_TEXT];
    [object setObject:self.objectId forKey:@"ProductId"];
    [object setObject:@"1" forKey:@"unread"];
    
    
	[object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
		if (error == nil)
		{
			[JSQSystemSoundPlayer jsq_playMessageSentSound];
			[self loadMessages];
            
            
            PFQuery *pushQuery = [PFInstallation query];
            [pushQuery whereKey:@"user" equalTo:self.touser];
            NSMutableDictionary* tmp = [NSMutableDictionary dictionary];
            [tmp setValue:[PFUser currentUser].username forKey:@"touser"];
            [tmp setValue:self.objectId forKey:@"productid"];
            [tmp setValue:text forKey:@"alert"];
            [tmp setValue:@"Increment" forKey:@"badge"];
            
            
            // Send push notification to query
            PFPush *push = [[PFPush alloc] init];
            [push setQuery:pushQuery]; // Set our Installation query
            [push setMessage:text];
            [push setData:tmp];
            [push sendPushInBackground];
            
		}
		else [ProgressHUD showError:@"Network error"];;
	}];
	[self finishSendingMessage];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didPressAccessoryButton:(UIButton *)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSLog(@"didPressAccessoryButton");
}

#pragma mark - JSQMessages CollectionView DataSource

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return [messages objectAtIndex:indexPath.item];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView bubbleImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessage *message = [messages objectAtIndex:indexPath.item];
	if ([[message sender] isEqualToString:self.sender])
	{
		return [[UIImageView alloc] initWithImage:outgoingBubbleImageView.image highlightedImage:outgoingBubbleImageView.highlightedImage];
	}
	else return [[UIImageView alloc] initWithImage:incomingBubbleImageView.image highlightedImage:incomingBubbleImageView.highlightedImage];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
//	PFUser *user = [users objectAtIndex:indexPath.item];

	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blank_avatar"]];
//	if (avatars[user.objectId] == nil)
//	{
//		PFFile *filePicture = user[PF_USER_THUMBNAIL];
//		[filePicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
//		{
//			if (error == nil)
//			{
//				avatars[user.objectId] = [UIImage imageWithData:imageData];
//				[imageView setImage:avatars[user.objectId]];
//			}
//		}];
//	}
//	else [imageView setImage:avatars[user.objectId]];

	imageView.layer.cornerRadius = imageView.frame.size.width/2;
	imageView.layer.masksToBounds = YES;

	return imageView;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (indexPath.item % 3 == 0)
	{
		JSQMessage *message = [messages objectAtIndex:indexPath.item];
		return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
	}
	return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessage *message = [messages objectAtIndex:indexPath.item];
	if ([message.sender isEqualToString:self.sender])
	{
		return nil;
	}
	
	if (indexPath.item - 1 > 0)
	{
		JSQMessage *previousMessage = [messages objectAtIndex:indexPath.item - 1];
		if ([[previousMessage sender] isEqualToString:message.sender])
		{
			return nil;
		}
	}
//
//	PFUser *user = [users objectAtIndex:indexPath.item];
	return [[NSAttributedString alloc] initWithString:self.touser];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return nil;
}

#pragma mark - UICollectionView DataSource

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return [messages count];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
	
	JSQMessage *message = [messages objectAtIndex:indexPath.item];
	if ([message.sender isEqualToString:self.sender])
	{
		cell.textView.textColor = [UIColor blackColor];
	}
	else
	{
		cell.textView.textColor = [UIColor whiteColor];
	}
	
	cell.textView.linkTextAttributes = @{NSForegroundColorAttributeName:cell.textView.textColor,
										 NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)};
	
	return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (indexPath.item % 3 == 0)
	{
		return kJSQMessagesCollectionViewCellLabelHeightDefault;
	}
	return 0.0f;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessage *message = [messages objectAtIndex:indexPath.item];
	if ([[message sender] isEqualToString:self.sender])
	{
		return 0.0f;
	}
	
	if (indexPath.item - 1 > 0)
	{
		JSQMessage *previousMessage = [messages objectAtIndex:indexPath.item - 1];
		if ([[previousMessage sender] isEqualToString:[message sender]])
		{
			return 0.0f;
		}
	}
	return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 0.0f;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView
				header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSLog(@"didTapLoadEarlierMessagesButton");
}

@end
