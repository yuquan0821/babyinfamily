//
//  coinView.h
//  CoinDemoUikit
//
//  Created by gump on 8/31/12.
//  Copyright (c) 2012 gump. All rights reserved.
//
#define COINPOINT_OFFSET 
#import "SoundEffect.h"

@protocol coinViewDelegate <NSObject>

-(void)coinAnimationFinished;

@end

@class coinImageView;
@class ParticleEmitter3D;

@interface coinView : UIView
{
    EAGLContext         *context;
    GLuint              viewRenderbuffer, viewFramebuffer;
    GLint               backingWidth;
	GLint               backingHeight;
    GLuint              depthRenderbuffer;
    bool                bDrawPraticle;
    UILabel             *textlabel;
    NSTimer             *coinTimer;
    
    int                 coinTotleNum;
    int                 curCoinNum;
    CGPoint             coinPoint;
    int                 iticktime;
}

@property (nonatomic,retain) NSMutableArray                 *emitters;
@property (nonatomic,retain) NSMutableArray                 *images;
@property (nonatomic,retain) NSMutableArray                 *deleteemitters;
@property (nonatomic,retain) NSMutableArray                 *deleteimages;
@property (nonatomic,retain) id<coinViewDelegate>             coindelegate;
@property (nonatomic,retain) SoundEffect                     *sound;

-(void)initOpenGl;
-(BOOL)createFramebuffer;
-(void)destroyFramebuffer;
-(void)createmitter:(CGPoint) point;
-(void)creatimage:(CGPoint) point;
-(id)initWithFrame:(CGRect)frame withNum:(NSInteger)num;


@end
