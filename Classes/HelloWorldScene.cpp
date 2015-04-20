#include "HelloWorldScene.h"
#include "3d/CCAnimation3D.h"
#include "3d/CCAnimate3D.h"
#include "3d/CCAttachNode.h"
#include "3d/CCRay.h"
#include "3d/CCSprite3D.h"

USING_NS_CC;

static int tuple_sort( const std::tuple<ssize_t,Effect3D*,CustomCommand> &tuple1, const std::tuple<ssize_t,Effect3D*,CustomCommand> &tuple2 )
{
    return std::get<0>(tuple1) < std::get<0>(tuple2);
}

EffectSprite3D* EffectSprite3D::create(const std::string &path)
{
    if (path.length() < 4)
        CCASSERT(false, "improper name specified when creating Sprite3D");
    
    auto sprite = new (std::nothrow) EffectSprite3D();
    if (sprite && sprite->initWithFile(path))
    {
        sprite->autorelease();
        return sprite;
    }
    CC_SAFE_DELETE(sprite);
    return nullptr;
}

EffectSprite3D::EffectSprite3D()
: _defaultEffect(nullptr)
{
    
}

EffectSprite3D::~EffectSprite3D()
{
    for(auto effect : _effects)
    {
        CC_SAFE_RELEASE_NULL(std::get<1>(effect));
    }
    CC_SAFE_RELEASE(_defaultEffect);
}

void EffectSprite3D::setEffect3D(Effect3D *effect)
{
    if(_defaultEffect == effect) return;
    CC_SAFE_RETAIN(effect);
    CC_SAFE_RELEASE(_defaultEffect);
    _defaultEffect = effect;
}

void EffectSprite3D::addEffect(Effect3DOutline* effect, ssize_t order)
{
    if(nullptr == effect) return;
    effect->retain();
    effect->setTarget(this);
    
    _effects.push_back(std::make_tuple(order,effect,CustomCommand()));
    
    std::sort(std::begin(_effects), std::end(_effects), tuple_sort);
}

const std::string Effect3DOutline::_vertShaderFile = "OutLine.vert";
const std::string Effect3DOutline::_fragShaderFile = "OutLine.frag";
const std::string Effect3DOutline::_keyInGLProgramCache = "Effect3DLibrary_Outline";

GLProgram* Effect3DOutline::getOrCreateProgram()
{
    auto program = GLProgramCache::getInstance()->getGLProgram(_keyInGLProgramCache);
    if(program == nullptr)
    {
        program = GLProgram::createWithFilenames(_vertShaderFile, _fragShaderFile);
        GLProgramCache::getInstance()->addGLProgram(program, _keyInGLProgramCache);
    }
    return program;
}

Effect3DOutline* Effect3DOutline::create()
{
    Effect3DOutline* effect = new (std::nothrow) Effect3DOutline();
    if(effect && effect->init())
    {
        effect->autorelease();
        return effect;
    }
    else
    {
        CC_SAFE_DELETE(effect);
        return nullptr;
    }
}

bool Effect3DOutline::init()
{
    return true;
}

Effect3DOutline::Effect3DOutline()
: _outlineWidth(1.0f)
, _outlineColor(1, 1, 1)
, _sprite(nullptr)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WP8 || CC_TARGET_PLATFORM == CC_PLATFORM_WINRT)
    _backToForegroundListener = EventListenerCustom::create(EVENT_RENDERER_RECREATED,
                                                            [this](EventCustom*)
                                                            {
                                                                auto glProgram = _glProgramState->getGLProgram();
                                                                glProgram->reset();
                                                                glProgram->initWithFilenames(_vertShaderFile, _fragShaderFile);
                                                                glProgram->link();
                                                                glProgram->updateUniforms();
                                                            }
                                                            );
    Director::getInstance()->getEventDispatcher()->addEventListenerWithFixedPriority(_backToForegroundListener, -1);
#endif
}

Effect3DOutline::~Effect3DOutline()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WP8 || CC_TARGET_PLATFORM == CC_PLATFORM_WINRT)
    Director::getInstance()->getEventDispatcher()->removeEventListener(_backToForegroundListener);
#endif
}

void Effect3DOutline::setOutlineColor(const Vec3& color)
{
    if(_outlineColor != color)
    {
        _outlineColor = color;
        if(_glProgramState)
            _glProgramState->setUniformVec3("OutLineColor", _outlineColor);
    }
}

void Effect3DOutline::setOutlineWidth(float width)
{
    if(_outlineWidth != width)
    {
        _outlineWidth = width;
        if(_glProgramState)
            _glProgramState->setUniformFloat("OutlineWidth", _outlineWidth);
    }
}

void Effect3DOutline::setTarget(EffectSprite3D *sprite)
{
    CCASSERT(nullptr != sprite && nullptr != sprite->getMesh(),"Error: Setting a null pointer or a null mesh EffectSprite3D to Effect3D");
    
    if(sprite != _sprite)
    {
        GLProgram* glprogram;
        glprogram = GLProgram::createWithFilenames(_vertShaderFile, _fragShaderFile);
        
        _glProgramState = GLProgramState::create(glprogram);
        
        _glProgramState->retain();
        _glProgramState->setUniformVec3("OutLineColor", _outlineColor);
        _glProgramState->setUniformFloat("OutlineWidth", _outlineWidth);
        
        
        _sprite = sprite;
        
        auto mesh = sprite->getMesh();
        long offset = 0;
        for (auto i = 0; i < mesh->getMeshVertexAttribCount(); i++)
        {
            auto meshvertexattrib = mesh->getMeshVertexAttribute(i);
            
            _glProgramState->setVertexAttribPointer(s_attributeNames[meshvertexattrib.vertexAttrib],
                                                    meshvertexattrib.size,
                                                    meshvertexattrib.type,
                                                    GL_FALSE,
                                                    mesh->getVertexSizeInBytes(),
                                                    (void*)offset);
            offset += meshvertexattrib.attribSizeBytes;
        }
        
        Color4F color(_sprite->getDisplayedColor());
        color.a = _sprite->getDisplayedOpacity() / 255.0f;
        _glProgramState->setUniformVec4("u_color", Vec4(color.r, color.g, color.b, color.a));
    }
    
}

static void MatrixPalleteCallBack( GLProgram* glProgram, Uniform* uniform, int paletteSize, const float* palette)
{
    glUniform4fv( uniform->location, (GLsizei)paletteSize, (const float*)palette );
}

void Effect3DOutline::draw(const Mat4 &transform)
{
    //draw
    Color4F color(_sprite->getDisplayedColor());
    color.a = _sprite->getDisplayedOpacity() / 255.0f;
    _glProgramState->setUniformVec4("u_color", Vec4(color.r, color.g, color.b, color.a));
    if(_sprite && _sprite->getMesh())
    {
        glEnable(GL_CULL_FACE);
        glCullFace(GL_FRONT);
        glEnable(GL_DEPTH_TEST);
        
        auto mesh = _sprite->getMesh();
        glBindBuffer(GL_ARRAY_BUFFER, mesh->getVertexBuffer());
        
        auto skin = _sprite->getMesh()->getSkin();
        if(_sprite && skin)
        {
            auto function = std::bind(MatrixPalleteCallBack, std::placeholders::_1, std::placeholders::_2,
                                      skin->getMatrixPaletteSize(), (float*)skin->getMatrixPalette());
            _glProgramState->setUniformCallback("u_matrixPalette", function);
        }
        
        if(_sprite)
            _glProgramState->apply(transform);
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mesh->getIndexBuffer());
        glDrawElements(mesh->getPrimitiveType(), (GLsizei)mesh->getIndexCount(), mesh->getIndexFormat(), 0);
        CC_INCREMENT_GL_DRAWN_BATCHES_AND_VERTICES(1, mesh->getIndexCount());
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glDisable(GL_DEPTH_TEST);
        glCullFace(GL_BACK);
        glDisable(GL_CULL_FACE);
    }
}

void EffectSprite3D::draw(cocos2d::Renderer *renderer, const cocos2d::Mat4 &transform, uint32_t flags)
{
    for(auto &effect : _effects)
    {
        if(std::get<0>(effect) >=0)
            break;
        CustomCommand &cc = std::get<2>(effect);
        cc.func = CC_CALLBACK_0(Effect3D::draw,std::get<1>(effect),transform);
        renderer->addCommand(&cc);
        
    }
    
    if(!_defaultEffect)
    {
        Sprite3D::draw(renderer, transform, flags);
    }
    else
    {
        _command.init(_globalZOrder);
        _command.func = CC_CALLBACK_0(Effect3D::draw, _defaultEffect, transform);
        renderer->addCommand(&_command);
    }
    
    for(auto &effect : _effects)
    {
        if(std::get<0>(effect) <=0)
            continue;
        CustomCommand &cc = std::get<2>(effect);
        cc.func = CC_CALLBACK_0(Effect3D::draw,std::get<1>(effect),transform);
        renderer->addCommand(&cc);
        
    }
}

Scene* HelloWorld::createScene()
{
    // 'scene' is an autorelease object
    auto scene = Scene::create();
    
    // 'layer' is an autorelease object
    auto layer = HelloWorld::create();//6

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
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Vec2 origin = Director::getInstance()->getVisibleOrigin();

    /////////////////////////////
    // 3. add your codes below...
    
    mapSprite = Sprite3D::create("map.c3b");
    mapSprite->setPosition3D(Vec3(0, 0, 0));
    
    pinSprite = Sprite3D::create("pin.c3b");
    //Effect3DOutline* effect = Effect3DOutline::create();
    //pinSprite->addEffect(effect, -1);
    pinSprite->setPosition3D(Vec3(0, 0, 0));
    pinSprite->setScale(0.1);
    addChild(pinSprite);
    addChild(mapSprite);
    
    camera = Camera::createPerspective(60, (GLfloat)visibleSize.width/visibleSize.height, 0.01, 1000);
    
    // set parameters for camera
    camera->setPosition3D(Vec3(0, 0.15, 0.15));
    camera->lookAt(Vec3(0, 0, 0), Vec3(0, 1, 0));
    
    addChild(camera); //add camera to the scene
    
    auto light = DirectionLight::create(Vec3(-1.0f, -1.0f, 0.0f), Color3B::WHITE);
    addChild (light);
    
    auto r = 0.1f;
    
    auto back = MoveBy::create(5.0f, Vec3(0, 0, -r));
    auto right = MoveBy::create(5.0f, Vec3(-r, 0 , 0));
    auto forward = MoveBy::create(5.0f, Vec3(0, 0, r));
    auto left = MoveBy::create(5.0f, Vec3(+r , 0, 0));
    
    auto sequence = Sequence::create(back, right, forward, left, NULL);
    
    pinSprite->runAction(RepeatForever::create(sequence));
    
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
    mapSprite->runAction(EaseSineInOut::create(MoveBy::create(0.2, Vec3(-newLocation.x*0.0003, 0, newLocation.y*0.0003))));
    pinSprite->runAction(EaseSineInOut::create(MoveBy::create(0.2, Vec3(-newLocation.x*0.0003, 0, newLocation.y*0.0003))));
}

void HelloWorld::onTouchEnded(Touch *touch, Event *event){
    auto location = touch[0].getLocation();
    Point newLocation = onTouchBeganPoint-location;
    if(newLocation.length() < 30){
        Point screenPoint = Vec2(touch->getLocationInView().x, touch->getLocationInView().y);
        Point point = HelloWorld::transformPoint(screenPoint);
        CCLOG("%f, %f", point.x, point.y);
    }
}

Point HelloWorld::transformPoint(Point point)
{
    
    Vec4 start = unProjectPoint(Vec3(point.x, point.y, 0));
    Vec4 end = unProjectPoint(Vec3(point.x, point.y, -1));
    
    Vec4 rayDir = end - start;
    rayDir.normalize();
    Vec4 normal = Vec4(0, 0.15, 0.15, 0);
    
    float rayDirDotNorm = rayDir.dot(normal);
    float P0DotNorm = start.dot(normal);
    
    float t = 0;
    
    if (rayDirDotNorm != 0) {
        t = -P0DotNorm / rayDirDotNorm;
    }
    
    Vec4 result = (rayDir * t) + start;
    Size visibleSize = Director::getInstance()->getVisibleSize();
    return Point(2338 + result.x - visibleSize.width/2, 2856 + result.y - visibleSize.height/2);
}

Vec4 HelloWorld::unProjectPoint(Vec3 point)
{
    
    Size visibleSize = Director::getInstance()->getVisibleSize();
    Rect viewPort = Rect(0, 0, visibleSize.width, visibleSize.height);
    
    Director *d = Director::getInstance();
    
    Mat4 projectionMatrix = d->getMatrix(MATRIX_STACK_TYPE::MATRIX_STACK_PROJECTION);
    Mat4 modelView = _modelViewTransform;
    Mat4 finalMatrix = projectionMatrix * _modelViewTransform;
    assert(finalMatrix.inverse());
    
    Vec4 in = Vec4(point.x, point.y, point.z, 1);
    in.x = (in.x - viewPort.origin.x) / viewPort.size.width;
    in.y = (in.y - viewPort.origin.y) / viewPort.size.height;
    
    in.x = in.x * 2 -1;
    in.y = in.y * 2 -1;
    in.z = in.z * 2 -1;
    
    Vec4 out = finalMatrix * in;
    assert(out.w != 0);
    
    out.x /= out.w;
    out.y /= out.w;
    out.z /= out.w;
    out.w /= out.w;
    
    return out;
    
}