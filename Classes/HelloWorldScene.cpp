#include "HelloWorldScene.h"
#include "MapNative.h"
#include <math.h>

USING_NS_CC;

static HelloWorld *instance;

HelloWorld *HelloWorld::getInstance(){
    
    return instance;
}

Scene* HelloWorld::createScene()
{
    // 'scene' is an autorelease object
    auto scene = Scene::create();
    
    // 'layer' is an autorelease object
    auto layer = HelloWorld::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool HelloWorld::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !Layer::init() )
    {
        return false;
    }
    
    instance = this;
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Vec2 origin = Director::getInstance()->getVisibleOrigin();

    /////////////////////////////
    // 3. add your codes below...
    
    // create a texture cube
    auto textureCube = TextureCube::create("sky_left.JPG", "sky_right.JPG","sky_top.JPG", "sky_bottom.JPG","sky_front.JPG", "sky_back.JPG");
    textureCube->retain();
    //create a skybox
    auto skyBox = Skybox::create();
    skyBox->retain();
    //set cube texture to the skybox
    skyBox->setTexture(textureCube);
    addChild(skyBox);
        
    story0Sprite = Sprite3D::create("story0.obj");
    story0Sprite->setPosition3D(Vec3(0, 0, 0));
    story1Sprite = Sprite3D::create("story1.obj");
    story1Sprite->setPosition3D(Vec3(0, 0.15, 0));
    story2Sprite = Sprite3D::create("story2.obj");
    story2Sprite->setPosition3D(Vec3(0, 0.30, 0));
    
    pinSprite = Sprite3D::create("pin.c3b");
    pinSprite->setPosition3D(Vec3(0, 0, 0));
    pinSprite->setScale(0.1);
    addChild(pinSprite);
    addChild(story0Sprite);
    addChild(story1Sprite);
    addChild(story2Sprite);
    
    mapPosition = Vec2(2338, 2856);
    pinX = 0;
    pinY = 0;
    pinZ = 0;
    story = 0;
    
    follow = true;
    
    camera = Camera::createPerspective(90, (GLfloat)visibleSize.width/visibleSize.height, 0.01, 1000);
    
    // set parameters for camera
    camera->setCameraFlag(CameraFlag::USER1);
    camera->setPosition3D(Vec3(0, 0.15, 0.10));
    camera->lookAt(Vec3(0, 0, 0), Vec3(0, 1, 0));
    
    addChild(camera); //add camera to the scene
    setCameraMask(2);
    
    this->runAction(Follow::create(pinSprite));
    
    auto listener = EventListenerTouchOneByOne::create();
    
    listener->onTouchBegan = CC_CALLBACK_2(HelloWorld::onTouchBegan, this);
    listener->onTouchMoved = CC_CALLBACK_2(HelloWorld::onTouchMoved, this);
    listener->onTouchEnded = CC_CALLBACK_2(HelloWorld::onTouchEnded, this);
    
    this->getEventDispatcher()->addEventListenerWithSceneGraphPriority(listener, this);
    
    return true;
}

bool HelloWorld::onTouchBegan(Touch *touch, Event *event){
    onTouchBeganPoint = touch[0].getLocation();
    return true;
}

void HelloWorld::onTouchMoved(Touch *touch, Event *event){
    auto location = touch[0].getLocation();
    Point newLocation = touch[0].getPreviousLocation()-location;
    story0Sprite->runAction(EaseBackOut::create(MoveBy::create(0.2, Vec3(-newLocation.x*0.0003, 0, newLocation.y*0.0003))));
    story1Sprite->runAction(EaseBackOut::create(MoveBy::create(0.2, Vec3(-newLocation.x*0.0003, 0, newLocation.y*0.0003))));
    story2Sprite->runAction(EaseBackOut::create(MoveBy::create(0.2, Vec3(-newLocation.x*0.0003, 0, newLocation.y*0.0003))));
    pinSprite->runAction(EaseBackOut::create(MoveBy::create(0.2, Vec3(-newLocation.x*0.0003, 0, newLocation.y*0.0003))));
    mapPosition += Vec2(newLocation.x*0.0003*2856, -newLocation.y*0.0003*2856);
    follow = false;
}

void HelloWorld::onTouchEnded(Touch *touch, Event *event){
    auto location = touch[0].getLocation();
    Point newLocation = onTouchBeganPoint-location;
    if(newLocation.length() < 30){
        Point screenPoint = Vec2(touch->getLocationInView().x, touch->getLocationInView().y);
        Point point = HelloWorld::transformPoint(screenPoint);
        
        MapNative::mapData(round(point.x), round(point.y), story);//後で0, つまり階のシステムを構築する
    }
}

Point HelloWorld::transformPoint(Point point){
    Vec3 start(point.x, point.y, 0.0f), end(point.x, point.y, 1.0f);
    
    auto size = Director::getInstance()->getWinSize();
    camera->unproject(size, &start, &start);
    camera->unproject(size, &end, &end);
    
    Vec3 rayDir = end - start;
    rayDir.normalize();
    Vec3 normal = Vec3(0, 1, 0);
    
    float rayDirDotNorm = rayDir.dot(normal);
    float P0DotNorm = -start.dot(normal);
    
    Vec3 result = (rayDir * (P0DotNorm / rayDirDotNorm)) + start;
    //float height = 0.15f * tan(M_PI/4 + atan2(0.10f, 0.15f)) + 0.15f * tan(M_PI/4 - atan2(0.10f,0.15f));//あとでちゃんとした計算で求める
    float height = 0.30;
    //float width = hypotf(0.10f, 0.15f) / cos(M_PI/4);//あとでちゃんとした計算で求める
    float width = 0.18;
    CCLOG("WIDTH:%f HEIGHT:%f", result.x/size.width - 0.5, result.z/size.height + 0.5);
    float x = mapPosition.x + (result.x/size.width - 0.5)*width*2856;
    float y = mapPosition.y + (result.z/size.height + 0.32)*height*2856;
    CCLOG("%f %f", result.x, result.z);
    return Point(x, y);
}

void HelloWorld::onSegmentedControlChanged(int changedStory){
    story0Sprite->runAction(EaseInOut::create(MoveBy::create(1.0, Vec3(0, (story - changedStory)*0.15, 0)), 2));
    story1Sprite->runAction(EaseInOut::create(MoveBy::create(1.0, Vec3(0, (story - changedStory)*0.15, 0)), 2));
    story2Sprite->runAction(EaseInOut::create(MoveBy::create(1.0, Vec3(0, (story - changedStory)*0.15, 0)), 2));
    pinSprite->runAction(EaseInOut::create(MoveBy::create(1.0, Vec3(0, (story - changedStory)*0.15, 0)), 2));
    story = changedStory;
    follow = false;
}

void HelloWorld::onLocationChanged(float latitude, float longitude){
    float angle = 0.24993114888558798;
    float originX = 139.59247926572826;
    float originY = 35.731768811376405;
    float rotatedX = (longitude - originX)*965328.057521775226;
    float rotatedY = (latitude - originY)*1193738.44933359347103;
    
    float gapX = rotatedX*cos(angle)-rotatedY*sin(angle);
    float gapY = -(rotatedX*sin(angle)+rotatedY*cos(angle));
    
    float x = gapX / 2024;
    float y = gapY / 2024;
    if(std::abs(x) < 1 && std::abs(y) < 1){
        if(follow){
            story0Sprite->runAction(MoveBy::create(0.5, Vec3(pinX-x, pinZ, pinY-y)));
            story1Sprite->runAction(MoveBy::create(0.5, Vec3(pinX-x, pinZ, pinY-y)));
            story2Sprite->runAction(MoveBy::create(0.5, Vec3(pinX-x, pinZ, pinY-y)));
            mapPosition -= Vec2((pinX-x)*2856, (pinY-y)*2856);
        }else{
            pinSprite->runAction(MoveBy::create(0.5, Vec3(x-pinX, -pinZ, y-pinY)));
        }
        pinX = x;
        pinY = y;
        pinZ = 0;
        inGakuin = true;
        pinSprite->setVisible(true);
    }else{
        inGakuin = false;
        pinSprite->setVisible(false);
    }
}

void HelloWorld::onLocationBasedBeaconChanged(float pixelX, float pixelY, float pixelZ){
    float x = pixelX / 2856 - 1.0;
    float y = pixelY / 2856 - 1.0;
    float z = pixelZ * 0.15;
    if(std::abs(x) < 1 && std::abs(y) < 1){
        if(follow){
            story0Sprite->runAction(MoveBy::create(0.5, Vec3(pinX-x, pinZ-z, pinY-y)));
            story1Sprite->runAction(MoveBy::create(0.5, Vec3(pinX-x, pinZ-z, pinY-y)));
            story2Sprite->runAction(MoveBy::create(0.5, Vec3(pinX-x, pinZ-z, pinY-y)));
            mapPosition -= Vec2((pinX-x)*2856, (pinY-y)*2856);
        }else{
            pinSprite->runAction(MoveBy::create(0.5, Vec3(x-pinX, z-pinZ, y-pinY)));
        }
        pinX = x;
        pinY = y;
        pinZ = z;
        if(follow){
            MapNative::changeStory(pinZ/0.15);
            story = pinZ/0.15;
        }
        inGakuin = true;
        pinSprite->setVisible(true);
    }else{
        inGakuin = false;
        pinSprite->setVisible(false);
    }
}

void HelloWorld::onLocateButtonTapped(){
    follow = true;
    if(inGakuin){
        pinSprite->runAction(MoveBy::create(0.5, Vec3(((mapPosition.x+518)/2856-1.0)-pinX, story*0.15-pinZ, (mapPosition.y/2856-1.0)-pinY)));
        story0Sprite->runAction(MoveBy::create(0.5, Vec3(((mapPosition.x+518)/2856-1.0)-pinX, story*0.15-pinZ, (mapPosition.y/2856-1.0)-pinY)));
        story1Sprite->runAction(MoveBy::create(0.5, Vec3(((mapPosition.x+518)/2856-1.0)-pinX, story*0.15-pinZ, (mapPosition.y/2856-1.0)-pinY)));
        story2Sprite->runAction(MoveBy::create(0.5, Vec3(((mapPosition.x+518)/2856-1.0)-pinX, story*0.15-pinZ, (mapPosition.y/2856-1.0)-pinY)));
        mapPosition -= Vec2((((mapPosition.x+518)/2856-1.0)-pinX)*2856, ((mapPosition.y/2856-1.0)-pinY)*2856);
        MapNative::changeStory(pinZ/0.15);
        story = pinZ/0.15;
    }
}