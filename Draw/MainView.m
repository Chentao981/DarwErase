//
//  MainView.m
//  Draw
//
//  Created by Chentao on 2019/3/8.
//  Copyright © 2019 Chentao. All rights reserved.
//

#import "MainView.h"
#import "KCLGraphItem.h"
#import "KCLGraphPath.h"
#import "KCLGraphText.h"

@interface MainView()

@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)UIImageView *drawImageView;

@property(nonatomic,strong)UIBezierPath *path;

@property(nonatomic,strong)UIButton *drawButton;

@property(nonatomic,strong)UIButton *eraseButton;

@property(nonatomic,strong)UIButton *textButton;

@property(nonatomic,assign)BOOL erase;

@property(nonatomic,strong)NSMutableArray <KCLGraphItem *> *graphItems;

@property(nonatomic,strong)KCLGraphPath *graphLine;

@end

@implementation MainView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.graphItems = [[NSMutableArray alloc]init];
        
        self.imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image.jpg"]];
        [self addSubview:self.imageView];
        
        self.drawImageView =[[UIImageView alloc]init];
        [self addSubview:self.drawImageView];
        
        self.drawButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 30, 80, 40)];
        self.drawButton.backgroundColor = [UIColor grayColor];
        [self.drawButton setTitle:@"Draw" forState:UIControlStateNormal];
        [self.drawButton addTarget:self action:@selector(drawButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.drawButton];
        
        self.eraseButton = [[UIButton alloc]initWithFrame:CGRectMake(130, 30, 80, 40)];
        self.eraseButton.backgroundColor = [UIColor grayColor];
        [self.eraseButton setTitle:@"Erase" forState:UIControlStateNormal];
        [self.eraseButton addTarget:self action:@selector(eraseButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.eraseButton];
        
        self.textButton = [[UIButton alloc]initWithFrame:CGRectMake(230, 30, 80, 40)];
        self.textButton.backgroundColor = [UIColor grayColor];
        [self.textButton setTitle:@"Text" forState:UIControlStateNormal];
        [self.textButton addTarget:self action:@selector(textButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.textButton];
        
    }
    return self;
}

-(void)drawButtonHandler:(UIButton *)button{
    self.erase = NO;
}

-(void)eraseButtonHandler:(UIButton *)button{
    self.erase = YES;
}

-(void)textButtonHandler:(UIButton *)button{
    KCLGraphText *graphText=[[KCLGraphText alloc]init];
    graphText.string = @"你好，测试";
    graphText.frame = CGRectMake(100, 100, 50, 100);
    
    graphText.type = KCLGraphItemTypeText;
    graphText.color = [UIColor redColor];
    [self.graphItems addObject:graphText];
    
    
    [self drawGraphText:graphText];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint beganPoint = [self getTouchSet:touches];
    
    self.graphLine =  [[KCLGraphPath alloc]init];
    self.graphLine.path = [UIBezierPath bezierPath];
    [self.graphLine.path moveToPoint:beganPoint];
    
    if (self.erase) {
        self.graphLine.type = KCLGraphItemTypeErase;
        self.graphLine.color = [UIColor clearColor];
        self.graphLine.path.lineWidth = 20;
    }else{
        self.graphLine.type = KCLGraphItemTypeLine;
        self.graphLine.color = [UIColor redColor];
        self.graphLine.path.lineWidth = 10;
    }
    [self.graphItems addObject:self.graphLine];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint movePoint = [self getTouchSet:touches];
    [self.graphLine.path addLineToPoint:movePoint];
    
    [self drawGraphPath:self.graphLine];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}


- (CGPoint)getTouchSet:(NSSet *)touches{
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}


-(void)drawGraphPath:(KCLGraphPath *)graphPath{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0);
    [self.drawImageView.image drawInRect:self.bounds];
    [graphPath.color set];
    
    [graphPath.path strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
    [graphPath.path stroke];
    
    self.drawImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

-(void)drawGraphText:(KCLGraphText *)graphText{
    CGPoint textPoint = graphText.frame.origin;
    CGSize textSize = graphText.frame.size;
    
    UIFont *textFont = [UIFont fontWithName:@"Arial" size:textSize.height];
    NSString *text = graphText.string;
    NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSDictionary *attributes = @{NSForegroundColorAttributeName : graphText.color, NSBackgroundColorAttributeName : [UIColor clearColor], NSFontAttributeName : textFont};
    [textAttrStr setAttributes:attributes range:NSMakeRange(0, text.length)];
    
    CGRect frame = [textAttrStr boundingRectWithSize:CGSizeMake(10000, FLT_MAX) options:NSStringDrawingUsesFontLeading context:nil];
    frame.size.height += 1;
    
    CGFloat textScale = textSize.width / frame.size.width;
    if (isnan(textScale) || isinf(textScale)) {
        textScale = 1.0;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0);
    [self.drawImageView.image drawInRect:self.bounds];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSaveGState(context);
    CGContextScaleCTM(context, textScale, textScale);

    //由于context缩放会导致x，y也会缩放，所以要还原x，y
    CGFloat drawTextX = textPoint.x / textScale;
    CGFloat drawTextY = textPoint.y / textScale;
    CGFloat drawTextW = frame.size.width;
    CGFloat drawTextH = frame.size.height;
    
    if (isnan(drawTextX) || isinf(drawTextX)) {
        drawTextX = 0;
    }
    
    if (isnan(drawTextY) || isinf(drawTextY)) {
        drawTextY=0;
    }
    
    if (isnan(drawTextW) || isinf(drawTextW)) {
        drawTextW=0;
    }
    
    if (isnan(drawTextH) || isinf(drawTextH)) {
        drawTextH = 0;
    }
    
    [textAttrStr drawInRect:CGRectMake(drawTextX, drawTextY, drawTextW, drawTextH)];
    
    CGContextRestoreGState(context);

    self.drawImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

//- (void)setEraseBrush:(UIBezierPath *)path{
//
//    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0);
//
//    [self.drawImageView.image drawInRect:self.bounds];
//
//    if (self.erase) {
//        [[UIColor clearColor] set];
//        path.lineWidth = 15;
//    }else{
//        [[UIColor redColor] set];
//        path.lineWidth = 10;
//    }
//
//
//    path.lineJoinStyle = kCGLineJoinRound;
//    path.lineCapStyle = kCGLineCapRound;
//
//    [path strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
//
//    [path stroke];
//
//    self.drawImageView.image = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
//
//}

-(void)layoutSubviews{
    self.drawImageView.frame=CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));

    self.drawImageView.image = nil;
    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0);

    [self.drawImageView.image drawInRect:self.bounds];

    for (KCLGraphItem *graphItem in self.graphItems) {
        if (KCLGraphItemTypeErase == graphItem.type || KCLGraphItemTypeLine == graphItem.type) {
            KCLGraphPath *graphPath = (KCLGraphPath *)graphItem;
            [graphPath.color set];
            [graphPath.path strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
            [graphPath.path stroke];
        }
    }

    
//    //////////////////////////////
//    //// General Declarations
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    for (int i=1; i<10; i++) {
//
//        CGContextSaveGState(context);
//        CGContextScaleCTM(context, i, i);
//
//        CGRect textRect = CGRectMake(i*10, i*10, 114, 21);
//        {
//            NSString* textContent = @"Hello, World!";
//
//            NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle alloc] init];
//            textStyle.alignment = NSTextAlignmentLeft;
//
//            NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: UIFont.buttonFontSize], NSForegroundColorAttributeName: UIColor.blackColor, NSParagraphStyleAttributeName: textStyle};
//
//            CGFloat textTextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY) options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
//
//            //CGContextClipToRect(context, textRect);
//            //[textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (textRect.size.height - textTextHeight) / 2, textRect.size.width, textTextHeight) withAttributes: textFontAttributes];
//
//            [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) , textRect.size.width, textTextHeight) withAttributes: textFontAttributes];
//
//
//            CGContextRestoreGState(context);
//        }
//    }
//
//
//
//
//
////    CGContextRestoreGState(context);
//    //////////////////////////////

    self.drawImageView.image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
}


@end
