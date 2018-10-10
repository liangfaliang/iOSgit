//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//

//



#pragma mark -

@interface BeeUIActionSheet : UIActionSheet<UIActionSheetDelegate>


#define DEF_STATIC_PROPERTY3( __name, __prefix, __prefix2 ) \
- (NSString *)__name \
{ \
return (NSString *)[[self class] __name]; \
} \
+ (NSString *)__name \
{ \
return [NSString stringWithFormat:@"%@.%@.%s", __prefix, __prefix2, #__name]; \

#define DEF_SIGNAL( __name )				DEF_STATIC_PROPERTY3( __name, @"signal", [self description] )

#define AS_STATIC_PROPERTY( __name ) \
- (NSString *)__name; \
+ (NSString *)__name;
#define AS_SIGNAL( __name )					AS_STATIC_PROPERTY( __name )
AS_SIGNAL( WILL_PRESENT )	// 将要显示
AS_SIGNAL( DID_PRESENT )	// 已经显示
AS_SIGNAL( WILL_DISMISS )	// 将要隐藏
AS_SIGNAL( DID_DISMISS )	// 已经隐藏

@property (nonatomic, retain) UIView *				parentView;
@property (nonatomic, retain) NSObject *			userData;

- (void)showInViewController:(UIViewController *)controller;	// samw as presentForController:
- (void)presentForController:(UIViewController *)controller;
- (void)dismissAnimated:(BOOL)animated;

- (void)addCancelTitle:(NSString *)title;
- (void)addCancelTitle:(NSString *)title signal:(NSString *)signal object:(id)object;
- (void)addButtonTitle:(NSString *)title signal:(NSString *)signal;
- (void)addButtonTitle:(NSString *)title signal:(NSString *)signal object:(id)object;
- (void)addDestructiveTitle:(NSString *)title signal:(NSString *)signal;
- (void)addDestructiveTitle:(NSString *)title signal:(NSString *)signal object:(id)object;

@end


