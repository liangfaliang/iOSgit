//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//


#import "UIView+Manipulation.h"

#pragma mark -

@implementation UIView(Manipulation)

- (void)removeAllSubviews
{
	NSArray * array = [self.subviews copy] ;

	for ( UIView * view in array )
	{
		[view removeFromSuperview];
	}
}
/**
 *  返回当前视图的控制器
 */
- (UIViewController *)viewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    
    if ([self pointInside:point withEvent:event]) {
        int i = 0;
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                if (![hitTestView isKindOfClass:[UITextField class]] && ![hitTestView isKindOfClass:[UITextView class]]) {

                    if (i == self.subviews.count - 1) {
                        if (![hitTestView isKindOfClass:[UIButton class]]){
                        [self endEditing:YES];
                        
                    }
                    }
//                    [self endEditing:YES];
                }
                i ++;
                return hitTestView;
            }
        }
        return self;
    }
    return nil;
    
}

@end


