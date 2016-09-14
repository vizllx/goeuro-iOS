//
//  SplashVC.m
//  goeuro_SM
//
//  Created by Sandeep-M on 12/09/16.
//  Copyright © 2016 Sandeep-Mukherjee. All rights reserved.
//

#import "SplashVC.h"



@implementation SplashVC


-(void)viewDidLoad
{
    [self fadeout];
}

-(void)fadeout
{
    self.imgSmallIcon.alpha=0.0f;
    self.activityIndicator.alpha=0.0f;
      self.imgSmallIcon.transform=CGAffineTransformMakeScale(0.001, 0.001);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:2.0 animations:^{
            self.imgBigSplash.alpha=0.0;
            self.imgBigSplash.transform=CGAffineTransformMakeScale(1.8, 1.8);
            
        }completion:^(BOOL finished) {
           
            [UIView animateWithDuration:1.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.topView.backgroundColor = [UIColor colorWithRed:42.0/255.0 green:125.0/255.0 blue:190.0/255.0 alpha:0.6];
                
                self.topView.alpha=0.44;

                self.imgSmallIcon.alpha=1.0f;
                self.imgSmallIcon.transform=CGAffineTransformMakeScale(1.1, 1.1);
                
            } completion:^(BOOL finished) {
                self.activityIndicator.alpha=1.0f;

                [self startLoadingIndicator];
              
                    CGPoint point0 = self.imgTopLayer.layer.position;
                    CGPoint point1 = { point0.x + 33, point0.y };
                    
                    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position.x"];
                    anim.repeatCount=HUGE_VALF;
                
                    anim.fromValue    = @(point0.x);
                    anim.toValue  = @(point1.x);
                    anim.duration   = 14.5f;
                    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    
                    // First we update the model layer's property.
                    self.imgTopLayer.layer.position = point1;
                    
                    // Now we attach the animation.
                    [self.imgTopLayer.layer  addAnimation:anim forKey:@"position.x"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"RemoveSplash"
                     object:self];
                });
                

                
                
            }];

            
        }];
        
        
        
        });
    
    
}

- (void) startLoadingIndicator;
{
    [self.activityIndicator startAnimating ];
    
}





@end
