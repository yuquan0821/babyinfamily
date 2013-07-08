//
//  ParticleEmitter3D.m
//  Particles
//
//  Created by Jeff LaMarche on 12/30/08.
//  Copyright 2008 Jeff LaMarche Consulting. All rights reserved.
//

#import "ParticleEmitter3D.h"
#import "OpenGLTexture3D.h"

GLuint Particle3DCount(Particle3D *list)
{
	Particle3D *oneParticle = list;
	int count = 0;
	while (oneParticle)
	{	
		count++;
		oneParticle = oneParticle->next;
	}
	return count;
}

Particle3D * Particle3DMake(Vector3D direction, NSTimeInterval timeToDie, Color3D colorAtEnd, Color3D colorAtBeginning, GLfloat inParticleSize)
{
	Particle3D *ret = malloc(sizeof(Particle3D));
	ret->position = Vertex3DMake(0.0, 0.0, 0.0);
	ret->lastPosition = Vertex3DMake(0.0, 0.0, 0.0);
	ret->direction = direction;
	ret->timeToDie = timeToDie;
	ret->colorAtEnd = colorAtEnd;
	ret->colorAtBeginning = colorAtBeginning;
	ret->color = colorAtBeginning;
	ret->particleSize = inParticleSize;
	ret->timeWasBorn = [NSDate timeIntervalSinceReferenceDate];
	ret->prev = NULL;
	ret->next = NULL;
	
	return ret;
}
// This function deletes a particle and repairs the gap created in the list
// We actually don't use this function now because we don't free objects
// until the end - we maintain a pool of removed particles and we
// use Particle3DFreeCascade in dealloc
//
// We probably should look at adding a way to release the unused particles
// if we're not currently emitting - perhaps a "flush" method on the
// Particle3DEmitter class
void Particle3DFree(Particle3D *particle)
{
	Particle3D *prev = particle->prev;
	Particle3D *next = particle->next;
	
	if (prev)
		prev->next = particle->next;
	if (next)
		next->prev = particle->prev;
	
	free(particle);
}
// This function frees a particle and ALL of its siblings
void Particle3DFreeCascade(Particle3D *particle)
{
	if (particle->next != NULL)
		Particle3DFreeCascade(particle->next);
	if (particle->prev != NULL)
		Particle3DFreeCascade(particle->prev);
	free(particle);
}
void Particle3DMoveParticleToPool(Particle3D *particle, ParticleEmitter3D *emitter)
{	
	Particle3D *particleNext = particle->next;
	Particle3D *particlePrev = particle->prev;
	
	// Repair gap in particle list caused by removal of this particle
	if (particleNext)
		particleNext->prev = particlePrev;
	if (particlePrev)
		particlePrev->next = particleNext;
	
	// Particle will become first object in pool, so no prev
	particle->prev = NULL;
	
	// Since it's first, the old first becomes its next
	particle->next =  emitter.particlePool;
	if (emitter.particlePool)
		emitter.particlePool->prev = particle;
	
	// And point the pool at the new first member
	emitter.particlePool = particle;
	
}
void Particle3DGetParticleFromPool(ParticleEmitter3D *emitter)
{	
	// Grab the first particle in the pool
	Particle3D *particle = emitter.particlePool;	
	
	// Get pointers to particles affected by the move
	// Since we always grab the first one, don't worry about repairing prevous link
	Particle3D *poolNext = particle->next;
	Particle3D *particleFirst = emitter.particle;
	
	if (poolNext)
		poolNext->prev = NULL;
	emitter.particlePool = poolNext;
	
	particle->prev = NULL;
	particle->next = particleFirst;
	if (particleFirst)
		particleFirst->prev = particle;
	emitter.particle = particle;
}

void Particle3DAddNewParticleToList(ParticleEmitter3D *emitter,Vector3D direction, NSTimeInterval timeToDie, Color3D colorAtEnd, Color3D colorAtBeginning, GLfloat particleSize)
{
	
	// If the list doesn't exist and the pool doesn't exist, just create a new one to act as the list
	if (emitter.particlePool == NULL)
	{
		// Creating new particle and adding to list
		Particle3D *newParticle =  Particle3DMake(direction, timeToDie, colorAtEnd, colorAtBeginning, particleSize);
		Particle3D *currentFirstParticle = emitter.particle;
		currentFirstParticle->prev = newParticle;
		newParticle->next = currentFirstParticle;
		emitter.particle = newParticle;
		emitter.currentParticleCount++;
		emitter.lifetimeParticlesCount++;
	}
	// If pool exists, move one from the pool to the front of the list and set its properties
	else 
	{
		Particle3DGetParticleFromPool(emitter);
		emitter.currentParticleCount++;
		emitter.lifetimeParticlesCount++;
		emitter.particle->position = Vertex3DMake(0.0, 0.0, 0.0);
		emitter.particle->lastPosition = Vertex3DMake(0.0, 0.0, 0.0);
		emitter.particle->direction = direction;
		emitter.particle->timeToDie = timeToDie;
		emitter.particle->colorAtEnd = colorAtEnd;
		emitter.particle->particleSize = particleSize;
		emitter.particle->colorAtBeginning = colorAtBeginning;
		emitter.particle->color = colorAtBeginning;
		emitter.particle->timeToDie = timeToDie;
		emitter.particle->timeWasBorn = [NSDate timeIntervalSinceReferenceDate];
	}
	
}
// This function checks all particles to see if they have died, and moves the dead ones to the pool
void Particle3DCullDeadParticles(ParticleEmitter3D *emitter)
{
	
	Particle3D *oneParticle = emitter.particle;
	NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
	
	// oneParticle should now be the first item in the list, if it wasn't already
	while (oneParticle)
	{
		// Any particle who's time to die is after now, we take them out of the list and put them in the pool
		Particle3D *nextParticle = oneParticle->next;
		//NSLog(@"%@: oneParticle->timeToDie: %f (now = %f)", emitter, oneParticle->timeToDie, now);
		if (now > oneParticle->timeToDie)
		{
			Particle3DMoveParticleToPool(oneParticle, emitter);
			emitter.currentParticleCount--;
		}
		oneParticle = nextParticle;
	}
	
	
}

// This is going to fire a lot, so we avoid the messaging overhead:
void Particle3DMoveAndCreateParticles( NSTimeInterval timeElapsed /*since last call*/, ParticleEmitter3D *emitter)
{
	
	Particle3DCullDeadParticles(emitter);
	
	Particle3D *particle = emitter.particle;
	//particle->prev = NULL;
	
	Particle3D *oneParticle = particle;
	GLuint newParticleCount = emitter.particlesEmittedPerSecond * timeElapsed;
	NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
	// If the emitter's particlesPerSecond is small, newParticleCount may never be large
	// enough to cause even 1 particle to be emitted. To deal with this, we need to keep
	// track of partial count, and use it to bump the particles emitted up to 1 once enough
	// fractional particles have accumulated.
	GLfloat partialCount = 0;
	partialCount += (GLfloat)(emitter.particlesEmittedPerSecond) * timeElapsed;
	if (partialCount >= 1.0)
	{
		newParticleCount++;
		partialCount = 0;
	}
	if (emitter.isEmitting)
	{
		for (int i = 0; i < newParticleCount; i++)
		{
			NSTimeInterval howLongToLive = emitter.particleLifespan + (Particle3DRandom() * emitter.particleLifespanVariance);
			GLfloat azimuth = emitter.azimuthVariance * Particle3DRandom();
			GLfloat pitch = 90.0 + (emitter.pitchVariance * Particle3DRandom());
			Vector3D direction;
			Vector3DRotateToDirection(pitch, azimuth, &direction);
			
			
			GLfloat speed = emitter.speed + (emitter.speedVariance * Particle3DRandom());
			direction.x *= (speed);
			direction.y *= (speed);
			direction.z *= (speed);
			
			Color3D start = emitter.startColor;
			start.red *= emitter.startColor.red + (emitter.startColorVariance.red * Particle3DRandom());
			start.blue *= emitter.startColor.blue + (emitter.startColorVariance.blue * Particle3DRandom());
			start.green *= emitter.startColor.green + (emitter.startColorVariance.green * Particle3DRandom());
			
			Color3D finish = emitter.finishColor;
			finish.red *= emitter.finishColor.red + (emitter.finishColorVariance.red * Particle3DRandom());
			finish.blue *= emitter.finishColor.blue + (emitter.finishColorVariance.blue * Particle3DRandom());
			finish.green *= emitter.finishColor.green + (emitter.finishColorVariance.green * Particle3DRandom());
			
			GLfloat particleSize = emitter.particleSize + (emitter.particleSizeVariance * Particle3DRandom());
			if (particle == NULL)
			{
				particle = Particle3DMake(direction, now+howLongToLive, finish, start, particleSize);
				oneParticle = particle;
				emitter.particle = particle;
			}
			else
				Particle3DAddNewParticleToList(emitter, direction, now + howLongToLive, finish, start, particleSize);
		}	
	}
	while (oneParticle != NULL)
	{
		oneParticle->lastPosition = oneParticle->position;
		oneParticle->position.x += oneParticle->direction.x * timeElapsed;
		oneParticle->position.y += oneParticle->direction.y * timeElapsed;
		oneParticle->position.z += oneParticle->direction.z * timeElapsed;
		oneParticle->direction.x += (emitter.force.x + (emitter.forceVariance.x * Particle3DRandom())) * timeElapsed;
		oneParticle->direction.y += (emitter.force.y + (emitter.forceVariance.y * Particle3DRandom())) * timeElapsed;
		oneParticle->direction.z += (emitter.force.z + (emitter.forceVariance.z * Particle3DRandom())) * timeElapsed;
		
		
		GLfloat percentThroughLife = (now < oneParticle->timeWasBorn) ? 0.0 : (now - oneParticle->timeWasBorn) / (oneParticle->timeToDie - oneParticle->timeWasBorn);
		if (percentThroughLife > 1.0)
			percentThroughLife = 1.0;
		
		oneParticle->color = Color3DInterpolate(oneParticle->colorAtBeginning, oneParticle->colorAtEnd, percentThroughLife);
		
		oneParticle = oneParticle->next;
	}
}


@implementation ParticleEmitter3D
@synthesize identifier;
@synthesize name;
@synthesize position;
@synthesize rotation;
@synthesize azimuthVariance;
@synthesize pitchVariance;
@synthesize speed;
@synthesize speedVariance;
@synthesize forceVariance;
@synthesize particle;
@synthesize particlePool;
@synthesize lifetimeParticlesCount;
@synthesize currentParticleCount;
@synthesize particlesEmittedPerSecond;
@synthesize particleEmitVariance;
@synthesize particleLifespan;
@synthesize particleLifespanVariance;
@synthesize startColor;
@synthesize startColorVariance;
@synthesize finishColor;
@synthesize finishColorVariance;
@synthesize force;
@synthesize	mode;
@synthesize particleSize;
@synthesize particleSizeVariance;
@synthesize isEmitting;
@synthesize texture;
#pragma mark -
#pragma mark Class Methods
+ (long)getNextIdentifier
{
	// This is to allow the user to distinguish between 
	// emitters without having to do string comparisons on name
	static long ident = 0;
	return ident++;
}
#pragma mark -
#pragma mark Init Methods
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
{
	if ((self = [super init]))
	{
		self.identifier = [ParticleEmitter3D getNextIdentifier];
		self.name = inName;
		self.position = inPosition;
		self.azimuthVariance = inAzimuthVariance;
		self.pitchVariance = inPitchVariance;
		self.speed = inSpeed;
		self.speedVariance = inSpeedVariance;
		self.particlesEmittedPerSecond = inParticlesEmittedPerSecond;
		self.particleEmitVariance = inParticlesEmittedVariance;
		self.particleLifespan = inParticleLifespan;
		self.particleLifespanVariance = inParticleLifespanVariance;
		self.startColor = inStartColor;
		self.startColorVariance = inStartColorVariance;
		self.finishColor = inFinishColor;
		self.finishColorVariance = inFinishColorVariance;
		self.force = ingravity;
		self.forceVariance = inforceVariance;
		self.mode = inMode;
		self.particleSize = inParticleSize;
		self.particleSizeVariance = inParticleSize;
		self.texture = inTexture;
		lastDrawTime = 0.0;
		currentParticleCount = 1;		
	}
	return self;
}
#pragma mark -
- (void)drawSelf
{
	if (stopped)
		return;
	
	int particleCounter = 0;
	Particle3D *oneParticle = particle;
	
	
	
	if (lastDrawTime > 0)
	{
		Particle3DMoveAndCreateParticles( [NSDate timeIntervalSinceReferenceDate] - lastDrawTime, self);
		
		
		glPushMatrix();
		glLoadIdentity();
		
		[OpenGLTexture3D useDefaultTexture];
		
		
		glTranslatef(position.x, position.y, position.z);
		glRotatef(rotation.x, 1.0, 0.0, 0.0);
		glRotatef(rotation.y, 0.0, 1.0, 0.0);
		glRotatef(rotation.z, 0.0, 0.0, 1.0);
		
		
		if (vertices == NULL)
		{
			[self flushArrays];
			[self allocateArrays];
		}
		
		// ----------------------------------------------------------------
		// TODO: There are huge opportunities for refactoring below
		//
		// Note:	This is not production-level code. It should function
		//			okay for most purposes, but don't use this as a model
		//			of what your OpenGL code should look like. There is
		//			a huge amount of copy and paste going on below, which 
		//			generally should be an indication there are opportunities
		//			for refactoring. I haven't done that her mostly because I
		//			don't have much time for this project right now. 
		//
		//			Refactoring OpenGL code property requires establishing
		//			a baseline with the performace tools, and then 
		//			re-running and monitoring performance as you move code
		//			into generalized cases, to make sure that you haven't
		//			sacrificed too much performance in the process of 
		//			making the code easier to maintain and read.
		//
		//			In the code below, I've also avoided loops - there are
		//			several unrolled loops where the code could be 
		//			shortened considerably by using loops. The same applies
		//			here - if you're working with something like this where
		//			you have potential performance bottelenecks, you need
		//			to use the performance tools to monitor the impact of
		//			the changes.
		//
		//			I don't have the luxury of time to do that work, so
		//			I'm offering the code because I think it may be helpful
		//			to some people, but do not make the assumption that 
		//			this should be used as reference code, or as an example
		//			of the "best" way to write your rendering code.
		// ----------------------------------------------------------------
		
		switch (mode) 
		{
			case ParticleEmitter3DDrawPoints:
			{
				while (oneParticle)
				{
					Vertex3D *partPosition = &oneParticle->position;
					vertices[(particleCounter * 3)] = partPosition->x;
					vertices[(particleCounter * 3) + 1] = partPosition->y;
					vertices[(particleCounter * 3) + 2] = partPosition->z;
					Color3D *partColor = &oneParticle->color;
					vertexColors[(particleCounter * 4)] = partColor->red;
					vertexColors[(particleCounter * 4) + 1] = partColor->green;
					vertexColors[(particleCounter * 4) + 2] = partColor->blue;
					vertexColors[(particleCounter * 4) + 3] = partColor->alpha;
					
					oneParticle = oneParticle->next;
					particleCounter++;
				}
				glEnableClientState(GL_VERTEX_ARRAY);
				glEnableClientState (GL_COLOR_ARRAY);
				glColorPointer(4, GL_FLOAT, 0, vertexColors);
				glVertexPointer(3, GL_FLOAT, 0, vertices);
				glDrawArrays(GL_POINTS, 0, currentParticleCount);
				glDisableClientState(GL_VERTEX_ARRAY);
				glDisableClientState(GL_COLOR_ARRAY);
				break;
			}
			case ParticleEmitter3DDrawLines:
			{			
				while (oneParticle)
				{
					Vertex3D *startPoint = &oneParticle->position;
					vertices[(particleCounter * 6)] = startPoint->x;
					vertices[(particleCounter * 6) + 1] = startPoint->y;
					vertices[(particleCounter * 6) + 2] = startPoint->z;
					
					Vertex3D *endPoint = &oneParticle->lastPosition;
					vertices[(particleCounter * 6) + 3] = endPoint->x;
					vertices[(particleCounter * 6) + 4] = endPoint->y;
					vertices[(particleCounter * 6) + 5] = endPoint->z;
					
					Color3D *partColor = &oneParticle->color;
					vertexColors[(particleCounter * 8)] = partColor->red;
					vertexColors[(particleCounter * 8) + 1] = partColor->green;
					vertexColors[(particleCounter * 8) + 2] = partColor->blue;
					vertexColors[(particleCounter * 8) + 3] = partColor->alpha;
					vertexColors[(particleCounter * 8) + 4] = partColor->red;
					vertexColors[(particleCounter * 8) + 5] = partColor->green;
					vertexColors[(particleCounter * 8) + 6] = partColor->blue;
					vertexColors[(particleCounter * 8) + 7] = partColor->alpha;
					
					oneParticle = oneParticle->next;
					particleCounter++;
				}
				glEnableClientState(GL_VERTEX_ARRAY);
				glEnableClientState (GL_COLOR_ARRAY);
				glColorPointer(4, GL_FLOAT, 0, vertexColors);
				glVertexPointer(3, GL_FLOAT, 0, vertices);
				glDrawArrays(GL_LINES, 0, currentParticleCount*2);
				glDisableClientState(GL_VERTEX_ARRAY);
				glDisableClientState(GL_COLOR_ARRAY);
				break;
			}
			case ParticleEmitter3DDrawTriangles:
			{				
				while (oneParticle)
				{
					Vertex3D *point1 = &oneParticle->position;
					vertices[(particleCounter * 9)] = point1->x - PolyScale;
					vertices[(particleCounter * 9) + 1] = point1->y - PolyScale;
					vertices[(particleCounter * 9) + 2] = point1->z;
					vertices[(particleCounter * 9) + 3] = point1->x;
					vertices[(particleCounter * 9) + 4] = point1->y + PolyScale;
					vertices[(particleCounter * 9) + 5] = point1->z;
					vertices[(particleCounter * 9) + 6] = point1->x + PolyScale;
					vertices[(particleCounter * 9) + 7] = point1->y - PolyScale;
					vertices[(particleCounter * 9) + 8] = point1->z;
					
					Color3D *partColor = &oneParticle->color;
					vertexColors[(particleCounter * 12)] = partColor->red;
					vertexColors[(particleCounter * 12) + 1] = partColor->green;
					vertexColors[(particleCounter * 12) + 2] = partColor->blue;
					vertexColors[(particleCounter * 12) + 3] = partColor->alpha;
					vertexColors[(particleCounter * 12) + 4] = partColor->red;
					vertexColors[(particleCounter * 12) + 5] = partColor->green;
					vertexColors[(particleCounter * 12) + 6] = partColor->blue;
					vertexColors[(particleCounter * 12) + 7] = partColor->alpha;
					vertexColors[(particleCounter * 12) + 8] = partColor->red;
					vertexColors[(particleCounter * 12) + 9] = partColor->green;
					vertexColors[(particleCounter * 12) + 10] = partColor->blue;
					vertexColors[(particleCounter * 12) + 11] = partColor->alpha;
					
					oneParticle = oneParticle->next;
					particleCounter++;
				}
				billboardCurrentMatrix();
				glEnableClientState(GL_VERTEX_ARRAY);
				glEnableClientState (GL_COLOR_ARRAY);
				glColorPointer(4, GL_FLOAT, 0, vertexColors);
				glVertexPointer(3, GL_FLOAT, 0, vertices);
				glDrawArrays(GL_TRIANGLES, 0, currentParticleCount*3);
				glDisableClientState(GL_VERTEX_ARRAY);
				glDisableClientState(GL_COLOR_ARRAY);
				break;
			}
			case ParticleEmitter3DDrawDiamonds:
			{				
				while (oneParticle)
				{
					Vertex3D *point1 = &oneParticle->position;
					vertices[(particleCounter * 18)] = point1->x - PolyScale;
					vertices[(particleCounter * 18) + 1] = point1->y;
					vertices[(particleCounter * 18) + 2] = point1->z;
					
					vertices[(particleCounter * 18) + 3] = point1->x;
					vertices[(particleCounter * 18) + 4] = point1->y + PolyScale;
					vertices[(particleCounter * 18) + 5] = point1->z;
					
					vertices[(particleCounter * 18) + 6] = point1->x + PolyScale;
					vertices[(particleCounter * 18) + 7] = point1->y;
					vertices[(particleCounter * 18) + 8] = point1->z;
					
					vertices[(particleCounter * 18) + 9] = point1->x - PolyScale;
					vertices[(particleCounter * 18) + 10] = point1->y;
					vertices[(particleCounter * 18) + 11] = point1->z;
					
					vertices[(particleCounter * 18) + 12] = point1->x + PolyScale;
					vertices[(particleCounter * 18) + 13] = point1->y;
					vertices[(particleCounter * 18) + 14] = point1->z;
					
					vertices[(particleCounter * 18) + 15] = point1->x;
					vertices[(particleCounter * 18) + 16] = point1->y - PolyScale;
					vertices[(particleCounter * 18) + 17] = point1->z;
					
					// TODO: Figure out if these loops need to be unrolled like this, could reduce lines a lot with loop - USE SHARK
					Color3D *partColor = &oneParticle->color;
					vertexColors[(particleCounter * 24)] = partColor->red;
					vertexColors[(particleCounter * 24) + 1] = partColor->green;
					vertexColors[(particleCounter * 24) + 2] = partColor->blue;
					vertexColors[(particleCounter * 24) + 3] = partColor->alpha;
					vertexColors[(particleCounter * 24) + 4] = partColor->red;
					vertexColors[(particleCounter * 24) + 5] = partColor->green;
					vertexColors[(particleCounter * 24) + 6] = partColor->blue;
					vertexColors[(particleCounter * 24) + 7] = partColor->alpha;
					vertexColors[(particleCounter * 24) + 8] = partColor->red;
					vertexColors[(particleCounter * 24) + 9] = partColor->green;
					vertexColors[(particleCounter * 24) + 10] = partColor->blue;
					vertexColors[(particleCounter * 24) + 11] = partColor->alpha;
					vertexColors[(particleCounter * 24) + 12] = partColor->red;
					vertexColors[(particleCounter * 24) + 13] = partColor->green;
					vertexColors[(particleCounter * 24) + 14] = partColor->blue;
					vertexColors[(particleCounter * 24) + 15] = partColor->alpha;
					vertexColors[(particleCounter * 24) + 16] = partColor->red;
					vertexColors[(particleCounter * 24) + 17] = partColor->green;
					vertexColors[(particleCounter * 24) + 18] = partColor->blue;
					vertexColors[(particleCounter * 24) + 19] = partColor->alpha;
					vertexColors[(particleCounter * 24) + 20] = partColor->red;
					vertexColors[(particleCounter * 24) + 21] = partColor->green;
					vertexColors[(particleCounter * 24) + 22] = partColor->blue;
					vertexColors[(particleCounter * 24) + 23] = partColor->alpha;
					
					oneParticle = oneParticle->next;
					particleCounter++;
				}
				billboardCurrentMatrix();
				glEnableClientState(GL_VERTEX_ARRAY);
				glEnableClientState (GL_COLOR_ARRAY);
				glColorPointer(4, GL_FLOAT, 0, vertexColors);
				glVertexPointer(3, GL_FLOAT, 0, vertices);
				glDrawArrays(GL_TRIANGLES, 0, currentParticleCount*6);
				glDisableClientState(GL_VERTEX_ARRAY);
				glDisableClientState(GL_COLOR_ARRAY);
				break;
			}
			case ParticleEmitter3DDrawSquares:
			case ParticleEmitter3DDrawTextureMap:
			{	
				if (mode == ParticleEmitter3DDrawTextureMap)
					[texture bind];
				else
					[OpenGLTexture3D useDefaultTexture];
				
				while (oneParticle)
				{
					Vertex3D *point1 = &oneParticle->position;
					vertices[(particleCounter * 12)] = point1->x + PolyScale;
					vertices[(particleCounter * 12) + 1] = point1->y + PolyScale;
					vertices[(particleCounter * 12) + 2] = point1->z;
					
					vertices[(particleCounter * 12) + 3] = point1->x - PolyScale;
					vertices[(particleCounter * 12) + 4] = point1->y + PolyScale;
					vertices[(particleCounter * 12) + 5] = point1->z;
					
					vertices[(particleCounter * 12) + 6] = point1->x + PolyScale;
					vertices[(particleCounter * 12) + 7] = point1->y - PolyScale;
					vertices[(particleCounter * 12) + 8] = point1->z;
					
					vertices[(particleCounter * 12) + 9] = point1->x - PolyScale;
					vertices[(particleCounter * 12) + 10] = point1->y - PolyScale;
					vertices[(particleCounter * 12) + 11] = point1->z;
					
					if (mode == ParticleEmitter3DDrawTextureMap)
					{
						textureCoords[(particleCounter * 8)] = 1.0;
						textureCoords[(particleCounter * 8) + 1] = 1.0;
						textureCoords[(particleCounter * 8) + 2] = 0.0;
						textureCoords[(particleCounter * 8) + 3] = 1.0;
						textureCoords[(particleCounter * 8) + 4] = 1.0;
						textureCoords[(particleCounter * 8) + 5] = 0.0;
						textureCoords[(particleCounter * 8) + 6] = 0.0;
						textureCoords[(particleCounter * 8) + 7] = 0.0;
					}
					
					// TODO: Figure out if these loops need to be unrolled like this, could reduce lines a lot with loop - USE SHARK
					Color3D *partColor = &oneParticle->color;
					vertexColors[(particleCounter * 16)] = partColor->red;
					vertexColors[(particleCounter * 16) + 1] = partColor->green;
					vertexColors[(particleCounter * 16) + 2] = partColor->blue;
					vertexColors[(particleCounter * 16) + 3] = partColor->alpha;
					vertexColors[(particleCounter * 16) + 4] = partColor->red;
					vertexColors[(particleCounter * 16) + 5] = partColor->green;
					vertexColors[(particleCounter * 16) + 6] = partColor->blue;
					vertexColors[(particleCounter * 16) + 7] = partColor->alpha;
					vertexColors[(particleCounter * 16) + 8] = partColor->red;
					vertexColors[(particleCounter * 16) + 9] = partColor->green;
					vertexColors[(particleCounter * 16) + 10] = partColor->blue;
					vertexColors[(particleCounter * 16) + 11] = partColor->alpha;
					vertexColors[(particleCounter * 16) + 12] = partColor->red;
					vertexColors[(particleCounter * 16) + 13] = partColor->green;
					vertexColors[(particleCounter * 16) + 14] = partColor->blue;
					vertexColors[(particleCounter * 16) + 15] = partColor->alpha;
					
					oneParticle = oneParticle->next;
					particleCounter++;
				}
				glEnableClientState(GL_VERTEX_ARRAY);
				glEnableClientState (GL_COLOR_ARRAY);
				
				if (mode == ParticleEmitter3DDrawTextureMap)
				{
					[texture bind];
					glEnable (GL_BLEND);
					glBlendFunc (GL_ONE, GL_ONE);
					glDisable(GL_DEPTH_TEST);
					glEnable(GL_TEXTURE);
					glEnable(GL_POINT_SPRITE_OES);
					glEnableClientState(GL_TEXTURE_COORD_ARRAY);
					glEnableClientState(GL_NORMAL_ARRAY);
					glTexCoordPointer(2, GL_FLOAT, 0, textureCoords);
					glNormalPointer(GL_FLOAT, 0, normals);
				}
				else
					[OpenGLTexture3D useDefaultTexture];
				
				billboardCurrentMatrix();
				glColorPointer(4, GL_FLOAT, 0, vertexColors);
				glVertexPointer(3, GL_FLOAT, 0, vertices);
				for (int i = 0; i < particleCounter; i++)
				{
					GLushort indices[] = {(i*4), (i*4)+1, (i*4)+2, (i*4)+3};
					glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, indices);
				}
				
				glDisableClientState(GL_VERTEX_ARRAY);
				glDisableClientState(GL_COLOR_ARRAY);
				
				if (mode == ParticleEmitter3DDrawTextureMap)
				{
					glDisable(GL_TEXTURE);
					glDisableClientState(GL_NORMAL_ARRAY);
					glDisableClientState(GL_TEXTURE_COORD_ARRAY);
					glEnable(GL_DEPTH_TEST);
				}				
				break;
			}
			case ParticleEmitter3DDrawCircles:
			{				
				while (oneParticle)
				{
					Vertex3D *point1 = &oneParticle->position;
					
					vertices[(particleCounter * 33)] = point1->x + (0.008660 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 1] = point1->y + (0.005000 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 2] = point1->z;
					
					vertices[(particleCounter * 33) + 3] = point1->x + (0.005000 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 4] = point1->y + (0.008660 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 5] = point1->z;
					
					vertices[(particleCounter * 33) + 6] = point1->x;
					vertices[(particleCounter * 33) + 7] = point1->y + (0.010000 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 8] = point1->z;
					
					vertices[(particleCounter * 33) + 9] = point1->x - (0.005000 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 10] = point1->y + (0.008660 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 11] = point1->z;
					
					vertices[(particleCounter * 33) + 12] = point1->x - (0.008660 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 13] = point1->y + (0.005000 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 14] = point1->z;
					
					vertices[(particleCounter * 33) + 15] = point1->x - (0.010000 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 16] = point1->y;
					vertices[(particleCounter * 33) + 17] = point1->z;
					
					vertices[(particleCounter * 33) + 18] = point1->x - (0.008660 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 19] = point1->y - (0.00500 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 20] = point1->z;
					
					vertices[(particleCounter * 33) + 21] = point1->x - (0.005000 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 22] = point1->y - (0.008660 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 23] = point1->z;
					
					vertices[(particleCounter * 33) + 24] = point1->x;
					vertices[(particleCounter * 33) + 25] = point1->y - (0.010000 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 26] = point1->z;
					
					vertices[(particleCounter * 33) + 27] = point1->x + (0.005000 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 28] = point1->y - (0.008660 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 29] = point1->z;
					
					vertices[(particleCounter * 33) + 30] = point1->x + (0.008660 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 31] = point1->y - (0.00500 * oneParticle->particleSize);
					vertices[(particleCounter * 33) + 32] = point1->z;
					
					
					// TODO: Figure out if these loops need to be unrolled like this, could reduce lines a lot with loop - USE SHARK
					Color3D *partColor = &oneParticle->color;
					vertexColors[(particleCounter * 44)] = partColor->red;
					vertexColors[(particleCounter * 44) + 1] = partColor->green;
					vertexColors[(particleCounter * 44) + 2] = partColor->blue;
					vertexColors[(particleCounter * 44) + 3] = partColor->alpha;
					vertexColors[(particleCounter * 44) + 4] = partColor->red;
					vertexColors[(particleCounter * 44) + 5] = partColor->green;
					vertexColors[(particleCounter * 44) + 6] = partColor->blue;
					vertexColors[(particleCounter * 44) + 7] = partColor->alpha;
					vertexColors[(particleCounter * 44) + 8] = partColor->red;
					vertexColors[(particleCounter * 44) + 9] = partColor->green;
					vertexColors[(particleCounter * 44) + 10] = partColor->blue;
					vertexColors[(particleCounter * 44) + 11] = partColor->alpha;
					vertexColors[(particleCounter * 44) + 12] = partColor->red;
					vertexColors[(particleCounter * 44) + 13] = partColor->green;
					vertexColors[(particleCounter * 44) + 14] = partColor->blue;
					vertexColors[(particleCounter * 44) + 15] = partColor->alpha;
					vertexColors[(particleCounter * 44) + 16] = partColor->red;
					vertexColors[(particleCounter * 44) + 17] = partColor->green;
					vertexColors[(particleCounter * 44) + 18] = partColor->blue;
					vertexColors[(particleCounter * 44) + 19] = partColor->alpha;
					vertexColors[(particleCounter * 44) + 20] = partColor->red;
					vertexColors[(particleCounter * 44) + 21] = partColor->green;
					vertexColors[(particleCounter * 44) + 22] = partColor->blue;
					vertexColors[(particleCounter * 44) + 23] = partColor->alpha;
					vertexColors[(particleCounter * 44) + 24] = partColor->red;
					vertexColors[(particleCounter * 44) + 25] = partColor->green;
					vertexColors[(particleCounter * 44) + 26] = partColor->blue;
					vertexColors[(particleCounter * 44) + 27] = partColor->alpha;
					vertexColors[(particleCounter * 44) + 28] = partColor->red;
					vertexColors[(particleCounter * 44) + 29] = partColor->green;
					vertexColors[(particleCounter * 44) + 30] = partColor->blue;
					vertexColors[(particleCounter * 44) + 31] = partColor->alpha;
					vertexColors[(particleCounter * 44) + 32] = partColor->red;
					vertexColors[(particleCounter * 44) + 33] = partColor->green;
					vertexColors[(particleCounter * 44) + 34] = partColor->blue;
					vertexColors[(particleCounter * 44) + 35] = partColor->alpha;
					vertexColors[(particleCounter * 44) + 36] = partColor->red;
					vertexColors[(particleCounter * 44) + 37] = partColor->green;
					vertexColors[(particleCounter * 44) + 38] = partColor->blue;
					vertexColors[(particleCounter * 44) + 39] = partColor->alpha;
					vertexColors[(particleCounter * 44) + 40] = partColor->red;
					vertexColors[(particleCounter * 44) + 41] = partColor->green;
					vertexColors[(particleCounter * 44) + 42] = partColor->blue;
					vertexColors[(particleCounter * 44) + 43] = partColor->alpha;
					
					oneParticle = oneParticle->next;
					particleCounter++;
				}
				billboardCurrentMatrix();
				glEnableClientState(GL_VERTEX_ARRAY);
				glEnableClientState (GL_COLOR_ARRAY);
				glColorPointer(4, GL_FLOAT, 0, vertexColors);
				glVertexPointer(3, GL_FLOAT, 0, vertices);
				//glDrawArrays(GL_TRIANGLE_FAN, 0, currentParticleCount*11);
				for (int i = 0; i < particleCounter; i++)
				{
					GLushort indices[] = {(i*11), (i*11)+1, (i*11)+2, (i*11)+3, (i*11)+4, (i*11)+5, (i*11)+6, (i*11)+7, (i*11)+8, (i*11)+9, (i*11)+10};
					glDrawElements(GL_TRIANGLE_FAN, 11, GL_UNSIGNED_SHORT, indices);
				}
				glDisableClientState(GL_VERTEX_ARRAY);
				glDisableClientState(GL_COLOR_ARRAY);				
				break;
			}
			default:
				break;
		}
		
		
		glPopMatrix();
	}
	lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
	
	
}
- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ (Emitter)", self.name];
}
- (void)startEmitting
{
	isEmitting = YES;
	stopped = NO;
	[[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(kill) object:nil];
	
}
- (void)kill
{
	NSLog(@"Killing %@", self);
	stopped = YES;
	
	// TODO: There's a problem with deallocating particles. 
	// Somehow, the first particle in the pool ends up with a prev value 
	// pointing to the last object in the list, causing an infinite loop. 
	// Not sure where it's getting introduced.
//	Particle3DFreeCascade(particle);
//	Particle3DFreeCascade(particlePool);
	//[self flushArrays];
}
- (void)stopEmitting
{
	isEmitting = NO;
	//[self performSelector:@selector(kill) withObject:nil afterDelay:particleLifespan + particleLifespanVariance/2];
    [self kill];
}
- (void)allocateArrays
{
	switch (mode) 
	{
		case ParticleEmitter3DDrawPoints:
		{
			vertices = malloc(sizeof(GLfloat) * 3 * [self theoreticalMaxParticles] );
			vertexColors = malloc(sizeof(GLfloat) * 4 * [self theoreticalMaxParticles]);
			break;
		}
		case ParticleEmitter3DDrawLines:
		{
			vertices = malloc(sizeof(GLfloat) * 3 * [self theoreticalMaxParticles] * 2);
			vertexColors = malloc(sizeof(GLfloat) * 4 * [self theoreticalMaxParticles] * 2);
			break;
		}
		case ParticleEmitter3DDrawTriangles:
		{
			vertices = malloc(sizeof(GLfloat) * 3 * [self theoreticalMaxParticles] * 3);
			vertexColors = malloc(sizeof(GLfloat) * 4 * [self theoreticalMaxParticles] * 3);
			break;
		}
		case ParticleEmitter3DDrawDiamonds:
		{
			vertices = malloc(sizeof(GLfloat) * 3 * [self theoreticalMaxParticles] * 6);
			vertexColors = malloc(sizeof(GLfloat) * 4 * [self theoreticalMaxParticles] * 6);				
			break;
		}
		case ParticleEmitter3DDrawSquares:
		case ParticleEmitter3DDrawTextureMap:
		{
			vertices = malloc(sizeof(GLfloat) * 3 * [self theoreticalMaxParticles] * 4);
			vertexColors = malloc(sizeof(GLfloat) * 4 * [self theoreticalMaxParticles] * 4);
			if (mode == ParticleEmitter3DDrawTextureMap)
			{
				textureCoords = malloc(sizeof(GLfloat) * 2 * [self theoreticalMaxParticles] * 4);
				normals = calloc(sizeof(GLfloat) * [self theoreticalMaxParticles], 6);
				
			}
			break;
		}
		case ParticleEmitter3DDrawCircles:
		{
			vertices = malloc(sizeof(GLfloat) * 3 * [self theoreticalMaxParticles] * 11);
			vertexColors = malloc(sizeof(GLfloat) * 4 * [self theoreticalMaxParticles] * 11);
			break;
		}
		default:
			break;
	}
	
}
- (void)flushArrays
{
	if (vertices != NULL) 
	{
		free(vertices);
		vertices = NULL;
	}
	if (vertexColors != NULL)
	{
		free(vertexColors);
		vertexColors = NULL;
	}
	if (textureCoords != NULL)
	{
		free(textureCoords);
		textureCoords = NULL;
	}
	if (normals != NULL)
	{
		free(normals);
		normals = NULL;
	}
}
- (NSInteger)theoreticalMaxParticles
{
	return (particlesEmittedPerSecond + (particleEmitVariance/2+1)) * (particleLifespan + (particleLifespanVariance/2+1));
}
- (void)flushPool
{
	if (!isEmitting)
	{
        if(particlePool != nil)
        {
            Particle3DFreeCascade(particlePool);
        }
        
        if(particle != nil)
        {
            Particle3DFreeCascade(particle);
        }
        
		self.particle = NULL;
		self.particlePool = NULL;
	}
}
#pragma mark -
- (void)dealloc
{
	if (isEmitting)
		[self stopEmitting];
	[self flushArrays];
    if(particlePool != NULL)
    {
        //Particle3DFreeCascade(particlePool);
        free(particlePool);
    }
	
    if(particle != NULL)
    {
       //Particle3DFreeCascade(particle);
        free(particle);
    }
    
   // self.particle = NULL;
    //self.particlePool = NULL;
    [super dealloc];

}
@end
