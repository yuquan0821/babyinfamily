//
//  ParticleEmitter3D.h
//  Particles
//
//  Created by Jeff LaMarche on 12/30/08.
//  Copyright 2008 Jeff LaMarche Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenGLCommon.h"

// Generates float from -1.0 to 1.0 for calculating random variance
#define Particle3DRandom() (((float)(arc4random() % 100) / 50.0) - 1.0)

// Old version, for doing GL_TRIANGLES
#define DeclareSquare() static const GLfloat square[18] = { 0.01, 0.01, 0.0, -0.01,  0.01, 0.0,0.01, -0.01, 0.0,0.01, -0.01, 0.0,-0.01,  0.01, 0.0, -0.01, -0.01, 0.0 }    
#define PolyScale (0.01 * oneParticle->particleSize)
typedef struct {
	Vertex3D		position;
	Vertex3D		lastPosition;
	Vector3D		direction;
	
	NSTimeInterval	timeToDie;
	NSTimeInterval  timeWasBorn;
	
	Color3D			color;
	Color3D			colorAtEnd;
	Color3D			colorAtBeginning;
	
	GLfloat			particleSize;
	
	void			*prev;
	void			*next;
} Particle3D;
// This will be used to indicated different ways of drawing particles
typedef enum  {
	ParticleEmitter3DDrawPoints,
	ParticleEmitter3DDrawLines,
	ParticleEmitter3DDrawDiamonds,
	ParticleEmitter3DDrawSquares,
	ParticleEmitter3DDrawCircles,
	ParticleEmitter3DDrawTriangles,
	ParticleEmitter3DDrawTextureMap,
	ParticleEmitterDrawModeCount
} ParticleEmitter3DDrawMode;

@class OpenGLTexture3D;
@class Texture2D;
@interface ParticleEmitter3D : NSObject {
	long						identifier;
	NSString					*name;
	
	Vertex3D					position;
	Rotation3D					rotation;
	GLfloat						azimuthVariance;
	GLfloat						pitchVariance;
	
	GLfloat						speed;
	GLfloat						speedVariance;
	
	Particle3D					*particle;
	Particle3D					*particlePool;
	
	GLuint						lifetimeParticlesCount;
	GLuint						currentParticleCount;
	
	GLuint						particlesEmittedPerSecond;
	GLuint						particleEmitVariance;
	NSTimeInterval				particleLifespan;
	NSTimeInterval				particleLifespanVariance;
	
	Color3D						startColor;
	Color3D						startColorVariance;
	Color3D						finishColor;
	Color3D						finishColorVariance;
	
	Vector3D					force;
	Vector3D					forceVariance;
	
	ParticleEmitter3DDrawMode	mode;
	
	GLfloat						particleSize;
	GLfloat						particleSizeVariance;
	
	BOOL						isEmitting;
	
	OpenGLTexture3D				*texture;
	
@private
	NSTimeInterval				lastDrawTime;
	GLfloat						*vertices;				// All the vertices to be drawn
	GLfloat						*vertexColors;			// The colors of the vertices
	GLfloat						*textureCoords;			// The texture coordinates arrays
	GLfloat						*normals;				// The normals array
	BOOL						stopped;			
}
@property long									identifier;
@property (nonatomic, strong) NSString *		name;
@property Vertex3D								position;
@property Rotation3D							rotation;
@property GLfloat								azimuthVariance;
@property GLfloat								pitchVariance;

@property GLfloat								speed;
@property GLfloat								speedVariance;

@property Particle3D *							particle;
@property Particle3D *							particlePool;

@property GLuint								lifetimeParticlesCount;
@property GLuint								currentParticleCount;
@property GLuint								particlesEmittedPerSecond;
@property GLuint								particleEmitVariance;
@property NSTimeInterval						particleLifespan;
@property NSTimeInterval						particleLifespanVariance;
@property Color3D								startColor;
@property Color3D								startColorVariance;
@property Color3D								finishColor;
@property Color3D								finishColorVariance;
@property Vector3D								force;
@property Vector3D								forceVariance;
@property ParticleEmitter3DDrawMode				mode;
@property GLfloat								particleSize;
@property GLfloat								particleSizeVariance;
@property (readonly) BOOL						isEmitting;
@property (nonatomic, strong) OpenGLTexture3D	*texture;

+ (long)getNextIdentifier;
- (id)initWithName:(NSString *)inName 
		  position:(Vertex3D)inPosition
		  rotation:(Rotation3D)inRotation
   azimuthVariance:(GLfloat)inAzimuthVariance
	 pitchVariance:(GLfloat)inPitchVariance
			 speed:(GLfloat)inSpeed
	 speedVariance:(GLfloat)inSpeedVariance
particlesPerSecond:(GLuint)inParticlesEmittedPerSecond
particlesPerSecondVariance:(GLuint)inParticlesEmittedVariance
  particleLifespan:(NSTimeInterval)inParticleLifespan
particleLifespanVariance:(NSTimeInterval)inParticleLifespanVariance
		startColor:(Color3D)inStartColor
startColorVariance:(Color3D)inStartColorVariance
	   finishColor:(Color3D)inFinishColor
finishColorVariance:(Color3D)inFinishColorVariance
		   force:(Vector3D)ingravity
   forceVariance:(Vector3D)inforceVariance
			  mode:(ParticleEmitter3DDrawMode)inMode
	  particleSize:(GLfloat)inParticleSize
particleSizeVariance:(GLfloat)inParticleSizeVariance
		   texture:(OpenGLTexture3D *)inTexture;
- (void)drawSelf;
- (void)startEmitting;
- (void)stopEmitting;
- (NSInteger)theoreticalMaxParticles;
- (void)flushArrays;
- (void)allocateArrays;
// Call this if you get a low-memory warning - if it's not emitting, 
// it will free up the memory being used for the emitter's pool
- (void)flushPool;
@end

#pragma mark -
#pragma mark Inline functons
