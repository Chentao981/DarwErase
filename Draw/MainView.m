//
//  MainView.m
//  Draw
//
//  Created by Chentao on 2019/3/8.
//  Copyright © 2019 Chentao. All rights reserved.
//

#import "MainView.h"

@interface MainView()

@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)UIImageView *drawImageView;

@property(nonatomic,strong)UIBezierPath *path;

@property(nonatomic,strong)UIButton *drawButton;

@property(nonatomic,strong)UIButton *eraseButton;

@property(nonatomic,assign)BOOL erase;

@end

@implementation MainView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image.jpg"]];
        [self addSubview:self.imageView];
        
        self.drawImageView =[[UIImageView alloc]init];
        [self addSubview:self.drawImageView];
        
        self.drawButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 30, 100, 40)];
        self.drawButton.backgroundColor = [UIColor grayColor];
        [self.drawButton setTitle:@"Draw" forState:UIControlStateNormal];
        [self.drawButton addTarget:self action:@selector(drawButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.drawButton];
        
        self.eraseButton = [[UIButton alloc]initWithFrame:CGRectMake(180, 30, 100, 40)];
        self.eraseButton.backgroundColor = [UIColor grayColor];
        [self.eraseButton setTitle:@"Erase" forState:UIControlStateNormal];
        [self.eraseButton addTarget:self action:@selector(eraseButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.eraseButton];
        
    }
    return self;
}

-(void)drawButtonHandler:(UIButton *)button{
    self.erase = NO;
}

-(void)eraseButtonHandler:(UIButton *)button{
    self.erase = YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint beganPoint = [self getTouchSet:touches];
    self.path=[UIBezierPath bezierPath];
    [self.path moveToPoint:beganPoint];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint movePoint = [self getTouchSet:touches];
    [self.path addLineToPoint:movePoint];
    
    [self setEraseBrush:self.path];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}


- (CGPoint)getTouchSet:(NSSet *)touches{
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}

- (void)setEraseBrush:(UIBezierPath *)path{
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0);
    
    [self.drawImageView.image drawInRect:self.bounds];
    
    if (self.erase) {
        [[UIColor clearColor] set];
    }else{
        [[UIColor redColor] set];
    }
    
    path.lineWidth = 10;
    
    [path strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
    
    [path stroke];
    
    self.drawImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
}

-(void)layoutSubviews{
    self.drawImageView.frame=CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

@end
