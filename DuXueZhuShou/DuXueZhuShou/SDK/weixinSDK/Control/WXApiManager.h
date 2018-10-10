//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
typedef	void	(^BeeServiceBlock)( NSInteger state );
@protocol WXApiManagerDelegate <NSObject>

@optional

- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;

@end

@interface WXApiManager : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;
@property (nonatomic, copy) BeeServiceBlock				PayResults;
@property (nonatomic, copy) void (^AuthRespblock) (SendAuthResp *sap);
+ (instancetype)sharedManager;
-(void)setAuthRespblock:(void (^)(SendAuthResp *sap))AuthRespblock;
-(void)setPayResults:(BeeServiceBlock)PayResults;

@end
