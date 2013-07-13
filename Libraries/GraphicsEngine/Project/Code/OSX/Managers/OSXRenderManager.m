#import "RenderManager.h"
#import "SceneManager.h"
#import "RenderResourceManager.h"


@interface RenderManager ()
{
    SceneManager* sceneManager;
    RenderResourceManager* renderResourceManager;
}

@end

@implementation RenderManager

- (void)load
{
    [self internal_setupOpenGL];
    
    [self registerUpdateBlock:^{
        [self internal_update];
    }];
}

- (void)internal_update
{
//    OpenGLView* openGLView = [EditorAppDelegate sharedApplicationDelegate].openGLView;
//    
//    [openGLView drawRect:openGLView.frame];
}

- (void)internal_clear
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glFlush();
    
    CheckGLError
}

- (void)internal_setupOpenGL
{    
    [renderResourceManager loadShaders];
    [renderResourceManager loadMaterials];
    [renderResourceManager loadModels];
    
    glEnable(GL_DEPTH_TEST);
}

- (void)glkView:(GLKView*)view
     drawInRect:(CGRect)rect
{

}

- (void)openGLView:(OpenGLView*)view
        drawInRect:(CGRect)rect
{
    // TODO : set once, update on view change - see drawInRect
    //glViewport(0, 0, 320.0f, 480.0f);
    
    float
    x = 0,
    y = 0,
    width = 640,
    height = 960;
    
    glViewport(x, y, width, height);

    [self internal_clear];
    
    [sceneManager renderActiveScene];
    
//    glClearColor(0, 1, 0, 0);
//    
//    glClear(GL_COLOR_BUFFER_BIT);
//    //    drawAnObject();
//    glFlush();
}

@end
