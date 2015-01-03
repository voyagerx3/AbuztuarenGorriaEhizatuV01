//
//  Juego.swift
//  UBoat LEX
//
//  Created by Berganza on 16/12/2014.
//  Copyright (c) 2014 Berganza. All rights reserved.
//

import SpriteKit


class Juego: SKScene, SKPhysicsContactDelegate{
    
    
    var submarino = SKSpriteNode()
    var fragata = SKSpriteNode()
    var prisma = SKSpriteNode()
    var avion = SKSpriteNode()
    var helice = SKSpriteNode()
    var bomba = SKSpriteNode()
    var isla = SKSpriteNode()
    var suelomar = SKNode()
    var fondomenu = SKSpriteNode()
    var moverArriba = SKAction()
    var moverAbajo = SKAction()
    var moverIzq = SKAction()
    var moverDer = SKAction()
    var volarPlano = SKAction()
    var tocaAvion:Bool = false
    var naveTocada:String = ""
    var volverhome:SKSpriteNode!
    var explosion: SKSpriteNode!
    var explosionAtlas = SKTextureAtlas(named: "explosion")
    var explosionFrames = [SKTexture]()
    var colaavion:NSString!
    var escape: SKEmitterNode!
    let label = SKLabelNode(fontNamed: "Avenir")
    let labelvidas=SKLabelNode(fontNamed: "Avenir")
    var labelvidasval=SKLabelNode(fontNamed: "Avenir")
    var vidasval:Int=3
    let labelpuntos=SKLabelNode(fontNamed: "Avenir")
    var labelpuntosval=SKLabelNode(fontNamed: "Avenir")
    var puntosval:Int=0
    var labelmuniciones=SKLabelNode(fontNamed: "Avenir")
    let velocidadFondo: CGFloat = 2
    let anchoScreen: CGFloat = UIScreen.mainScreen().bounds.width
    let altoScreen: CGFloat = UIScreen.mainScreen().bounds.height
    //constantes colisiones
    let categoriasubmarino:UInt32=1<<0
    let categoriabomba:UInt32=1<<1
    let categoriaavion:UInt32=1<<2
    let categoriasuelomar:UInt32=1<<3
    let categoriahome:UInt32=1<<4
    let categoriafragata:UInt32=1<<5
   

    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.cyanColor()
        //detectar colisiones
        self.physicsWorld.contactDelegate=self
        heroe01()
        heroe02()
        malo()
        //prismaticos()
        home()
        suelomares()
        fondomenux()
        activarlabel()
        crearEscenario()
    }
    func fondomenux()
    {
        volverhome=SKSpriteNode(imageNamed: "home-icon")
        volverhome.setScale(0.05)
        volverhome.position=CGPoint(x: anchoScreen-volverhome.size.width*2,y: altoScreen-volverhome.size.height/1.5)
        
        volverhome.name="volverhome"
        volverhome.zPosition=7
        addChild(volverhome)
       // fondomenu=SKSpriteNode(imageNamed: "mar5")
        fondomenu.size.width=anchoScreen
        fondomenu.size.height=altoScreen*0.06
        fondomenu.position=CGPointMake(0+fondomenu.size.width/2,altoScreen-fondomenu.size.height/2)
        fondomenu.color=UIColor.whiteColor()
        fondomenu.zPosition=6
        addChild(fondomenu)
        
        labelvidas.fontColor = UIColor.blackColor()
        labelvidas.fontSize = altoScreen*0.04
        labelvidas.text="Vidas:"
        labelvidas.position = CGPoint(x: fondomenu.size.width*0.10,y: altoScreen-altoScreen*0.04)
        labelvidas.zPosition=6
        addChild(labelvidas)
        
        labelvidasval.fontColor = UIColor.blackColor()
        labelvidasval.fontSize = altoScreen*0.04
        labelvidasval.text=String(vidasval)
        labelvidasval.position = CGPoint(x: fondomenu.size.width*0.15,y: altoScreen-altoScreen*0.04)
        labelvidasval.zPosition=6
        labelvidasval.name = "labelvidasval"
        addChild(labelvidasval)
        
        labelpuntos.fontColor = UIColor.blackColor()
        labelpuntos.fontSize = altoScreen*0.04
        labelpuntos.text="Puntos:"
        labelpuntos.position = CGPoint(x: fondomenu.size.width*0.30,y: altoScreen-altoScreen*0.04)
        labelpuntos.zPosition=6
        addChild(labelpuntos)

        labelpuntosval.fontColor = UIColor.blackColor()
        labelpuntosval.fontSize = altoScreen*0.04
        labelpuntosval.text=""
        labelpuntosval.position = CGPoint(x: fondomenu.size.width*0.40,y: altoScreen-altoScreen*0.04)
        labelpuntosval.zPosition=6
        labelpuntosval.name = "labelpuntosval"
        addChild(labelpuntosval)
    }
    
    
    func heroe01() {
        submarino = SKSpriteNode(imageNamed: "yellowsub")
        submarino.setScale(0.1)
        submarino.zPosition = 1   
        submarino.position = CGPointMake(anchoScreen - submarino.size.width, 50)
        submarino.name = "heroe01"
        submarino.physicsBody=SKPhysicsBody(circleOfRadius: submarino.size.height/2)
        submarino.physicsBody?.dynamic=true
        submarino.physicsBody?.affectedByGravity=false
        submarino.physicsBody?.allowsRotation=false
        submarino.physicsBody?.categoryBitMask=categoriasubmarino
        submarino.physicsBody?.collisionBitMask=categoriahome
        submarino.physicsBody?.contactTestBitMask=categoriahome
        addChild(submarino)
    }

    func heroe02() {
        fragata = SKSpriteNode(imageNamed: "enemigo")
        fragata.setScale(0.2)
        fragata.zPosition = 1
        fragata.position = CGPointMake(anchoScreen - fragata.size.width, 50)
        fragata.name = "heroe02"
        fragata.physicsBody=SKPhysicsBody(circleOfRadius: fragata.size.height/2)
        fragata.physicsBody?.dynamic=true
        fragata.physicsBody?.affectedByGravity=false
        fragata.physicsBody?.allowsRotation=false
        fragata.physicsBody?.categoryBitMask=categoriafragata
        fragata.physicsBody?.collisionBitMask=categoriahome
        fragata.physicsBody?.contactTestBitMask=categoriahome
        addChild(fragata)
    }
    
    func malo(){
        var texturahelicetop:SKTexture=SKTexture(imageNamed: "heliceTop")
        var texturahelicebot:SKTexture=SKTexture(imageNamed: "heliceBot")
        var spin:SKAction = SKAction.animateWithTextures([texturahelicetop,texturahelicebot], timePerFrame: 0.1)
        var spin8:SKAction = SKAction.repeatActionForever(spin)
        avion = SKSpriteNode(imageNamed: "avion")
        avion.setScale(0.25)
        avion.zPosition=2
        avion.position=CGPointMake(120,altoScreen*0.9)
        avion.name="malo"
        avion.physicsBody=SKPhysicsBody(circleOfRadius: avion.size.height/2)
        avion.physicsBody?.affectedByGravity=false
        avion.physicsBody?.dynamic=false
        avion.physicsBody?.allowsRotation=false
        addChild(avion)
        helice = SKSpriteNode(imageNamed: "heliceTop")
        helice.setScale(0.25)
        helice.position = CGPointMake(avion.frame.origin.x+avion.size.width/2,avion.frame.origin.y+avion.size.height+5)
        helice.zPosition=2
        helice.runAction(spin8)
        helice.name="malohelice"
        addChild(helice)
        
        let untypedEmitter : AnyObject = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("escapeParticle", ofType: "sks")!)!
         escape = untypedEmitter as SKEmitterNode

        
        
//        colaavion=NSBundle.mainBundle().pathForResource("escapeParticle",ofType: "sks")
//        //escape = NSKeyedUnarchiver.unarchiveObjectWithFile(colaavion) as SKSpriteNode
//        escape = NSKeyedUnarchiver.unarchiveObjectWithFile(NSBundle.mainBundle().pathForResource("escapeParticle", ofType: "sks")!) as SKSpriteNode
        escape.zPosition=1.9
        escape.position = CGPointMake(avion.frame.origin.x-avion.size.width/2,avion.frame.origin.y+avion.size.height+5)
        escape.name="maloescape"
        addChild(escape)
        
    }
 //&x: CGFloat, &y: CGFloat
    func bombas(x:CGFloat,y:CGFloat){
        bomba = SKSpriteNode(imageNamed: "bomba")
        bomba.setScale(0.1)
        bomba.zPosition=3
        bomba.position=CGPointMake(x,y)
        bomba.name="bombas"
        bomba.physicsBody=SKPhysicsBody(circleOfRadius: bomba.size.height/2)
        bomba.physicsBody?.dynamic = true
        bomba.physicsBody?.affectedByGravity=false
        bomba.physicsBody?.categoryBitMask=categoriabomba
        bomba.physicsBody?.collisionBitMask=categoriasubmarino|categoriasuelomar|categoriafragata
        bomba.physicsBody?.contactTestBitMask=categoriasubmarino|categoriasuelomar|categoriafragata
        addChild(bomba)
        moverIzq=SKAction.moveByX(-20, y:0, duration: 0.2)
        moverDer=SKAction.moveByX(20, y:0, duration: 0.2)
    }
    
    func suelomares(){
        let sizesuelomarl  = CGSize(width: anchoScreen * 1.2, height: 20)
        
        suelomar.position=CGPointMake(0 + sizesuelomarl.width * 0.5, 30 - sizesuelomarl.height * 0.5)
        suelomar.zPosition=3
        suelomar.physicsBody=SKPhysicsBody(rectangleOfSize: sizesuelomarl)
        suelomar.physicsBody?.dynamic=false
        suelomar.physicsBody?.categoryBitMask=categoriasuelomar
        println("\(sizesuelomarl.width * 0.5)")
        suelomar.name="suelomares"
        addChild(suelomar)
        
    }
    func home(){
        isla = SKSpriteNode(imageNamed: "isla")
        isla.setScale(0.2)
        isla.zPosition = 5
        isla.position = CGPointMake(20, 50)
        isla.name = "home"
        isla.physicsBody=SKPhysicsBody(circleOfRadius: isla.size.height/2)
        isla.physicsBody?.affectedByGravity=false
        isla.physicsBody?.dynamic=true
        isla.physicsBody?.allowsRotation=false
        isla.physicsBody?.mass=10000
        isla.physicsBody?.restitution=0
        isla.physicsBody?.categoryBitMask=categoriahome
        
        addChild(isla)

    }
    func   activarlabel(){
        label.fontColor = UIColor.blackColor()
        label.fontSize = 30
        label.text=""
        label.position = CGPoint(x: size.width / 2 - 50, y: size.height / 2)
        label.zPosition=6
        label.name = "labelestado"
        addChild(label)
    }
    
    func setupExplosion( x:CGFloat,y:CGFloat )
    {//explosionAtlas   birdAtlas
        
        var nombreTextura = [NSArray].self
 
        var totalImgs = explosionAtlas.textureNames.count
        
        for var x = 1; x < totalImgs; x++
        {
            var textureName = "explosion-\(x)"
            var texture = explosionAtlas.textureNamed(textureName)
            explosionFrames.append(texture)
            
        }
        explosion=SKSpriteNode(texture: explosionFrames[0])
        
        explosion.position=CGPointMake(x,y)
        
        addChild(explosion)

        explosion.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(explosionFrames, timePerFrame: 0.4, resize: false, restore: false)))
        
        //explosion.runAction(SKAction.repeatAction(SKAction.animateWithTextures(explosionFrames, timePerFrame: 0.2), count: 2))
        explosion.runAction(SKAction.playSoundFileNamed("explosionbomba.wav", waitForCompletion: false))
        explosion.runAction(SKAction.removeFromParent())
        
        
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        
        for toke: AnyObject in touches {
            
            let dondeTocamos = toke.locationInNode(self)
            let spriteTocado = self.nodeAtPoint(dondeTocamos)
//            if dondeTocamos.x > avion.position.x {
//            if avion.position.x < 750 {
//                    avion.runAction(moverIzq)
//                }
//            } else {
//                
//                if avion.position.x > 50 {
//                    avion.runAction(moverDer)
//                }
//            }
            // Recuperamos el nodo que haya en el punto tocado
            if (spriteTocado.name != nil && (spriteTocado is SKSpriteNode)) {
                tocaAvion = true
                // Encendemos el semáforo
                naveTocada = spriteTocado.name!
                NSLog(naveTocada)
                if (naveTocada == "volverhome")
                {
                    let transicion = SKTransition.revealWithDirection(SKTransitionDirection.Left, duration: 0.5)
                    
                    let  aparecerEscena = Menu(size: self.size)
                    
                    aparecerEscena.scaleMode = SKSceneScaleMode.AspectFill
                    
                    self.scene?.view?.presentScene(aparecerEscena, transition: transicion)
                }
                
                if (naveTocada == "malo")
                {
                    bombas(avion.position.x,y: avion.position.y)
                    vuelobomba()
                    //heroe()
                }
                
                // Guardamos el valor del nombre de la nave tocada
            }
            
        }
        
        
    }
    
    
    
    
    
    func prismaticos() {
        prisma = SKSpriteNode(imageNamed: "prismatic")
        prisma.setScale(0.66)
        prisma.zPosition = 2
        prisma.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        addChild(prisma)
    }
    
    func crearEscenario() {
         for var indice = 0; indice < 2; ++indice {
            let fondo = SKSpriteNode(imageNamed: "mar4")
            fondo.position = CGPoint(x: indice * Int(fondo.size.width), y: 0)
            fondo.name = "fondo"
            fondo.zPosition = 0
            addChild(fondo)
        }
    
    }
    
    
    func scrollHorizontal() {
        
        self.enumerateChildNodesWithName("fondo", usingBlock: { (nodo, stop) -> Void in
            if let fondo = nodo as? SKSpriteNode {
                
                fondo.position = CGPoint(
                    x: fondo.position.x - self.velocidadFondo,
                    y: fondo.position.y)
                
                if fondo.position.x <= -fondo.size.width {
                    fondo.position = CGPointMake(
                        fondo.position.x + fondo.size.width * 2,
                        fondo.position.y)
                }
            }
        })
        
        
    }
    
 
    func vuelohorizontal() {
        self.enumerateChildNodesWithName("malo", usingBlock: { (nodo, stop) -> Void in
            if let avion = nodo as? SKSpriteNode {
                avion.position = CGPoint(
                    x: avion.position.x + self.velocidadFondo,
                    y: avion.position.y)
               
                if (avion.position.x  >  (self.anchoScreen+avion.size.width/3)) {
                    avion.position = CGPointMake(-5,avion.position.y)
                }
            }
        })
  //////
        self.enumerateChildNodesWithName("malohelice", usingBlock: { (nodo, stop) -> Void in
            if let malohelice = nodo as? SKSpriteNode {
                malohelice.position = CGPoint(
                    x: self.avion.position.x + self.velocidadFondo + self.avion.size.width/2-4,
                    y: self.avion.position.y-2)
                
                if (malohelice.position.x  >  (self.anchoScreen+self.avion.size.width/3)) {
                    self.avion.position = CGPointMake(-5,self.avion.position.y)
                }
            }
        })
   ///////
        self.enumerateChildNodesWithName("maloescape", usingBlock: { (nodo, stop) -> Void in
            if let maloescape = nodo as? SKEmitterNode {
                maloescape.position = CGPoint(
                    x: self.avion.position.x + self.velocidadFondo + self.avion.size.width/2-4,
                    y: self.avion.position.y-2)
                
                if (maloescape.position.x  >  (self.anchoScreen+self.avion.size.width/3)) {
                    self.avion.position = CGPointMake(-5,self.avion.position.y)
                }
            }
        })
        
        
        
    }
    func vuelosubmarino() {
        self.enumerateChildNodesWithName("heroe01", usingBlock: { (nodo, stop) -> Void in
            if let yellowsub = nodo as? SKSpriteNode {
                yellowsub.position = CGPoint(
                    x: yellowsub.position.x - self.velocidadFondo * 0.4,
                    y: yellowsub.position.y)
                
                if (yellowsub.position.x  >  (self.anchoScreen+yellowsub.size.width/3)) {
                    yellowsub.position = CGPointMake(-5,yellowsub.position.y)
                }
            }
        })
    }
    
    func vuelobomba(){
        var jump = SKAction.rotateToAngle(CGFloat(-3.14/2), duration: NSTimeInterval(0.5))
        self.enumerateChildNodesWithName("bombas", usingBlock: { (nodo, stop) -> Void in
            if let bomba = nodo as? SKSpriteNode {
                bomba.runAction(jump)
                bomba.position = CGPoint(
                    x: bomba.position.x + self.velocidadFondo * 0.8,
                    y: bomba.position.y - self.velocidadFondo)

            }
        })
    }
   
    func labelestado(texto:String) {
         label.text = texto
    }
    
    override func update(currentTime: NSTimeInterval) {
        //scrollHorizontal()
        vuelohorizontal()
        vuelosubmarino()
        vuelobomba()
        
    }
    func   didBeginContact(contact: SKPhysicsContact) {
        
        let node1:SKNode = contact.bodyA.node!;
        let node2:SKNode = contact.bodyB.node!;
        labelestado("contacto..." + " entre " + node1.name! + " y  " + node2.name! )
        
        if ( node1.name=="malo" && node2.name=="bombas")
        {labelestado(    node1.name! + " y  " + node2.name! + " Bomba VA!!" )}
        
        if ( node1.name=="suelomares" && node2.name=="bombas")
        {labelestado( node1.name! + " y  " + node2.name! + " Explosión" )
            
        bomba.removeFromParent()
        setupExplosion(bomba.position.x,y: bomba.position.y)
        //explosion.removeFromParent()
        }
        
        if ( node1.name=="heroe01" && node2.name=="bombas")
        {labelestado(node1.name! + " y  " + node2.name! + " Winner" )
            submarino.removeFromParent()
            bomba.removeFromParent()
            setupExplosion(bomba.position.x,y: bomba.position.y)
            puntosval=puntosval+100
            labelpuntosval.text=String(puntosval)
        }
        if ( node1.name=="heroe02" && node2.name=="bombas")
        {labelestado(node1.name! + " y  " + node2.name! + " Winner" )
            fragata.removeFromParent()
            bomba.removeFromParent()
            setupExplosion(bomba.position.x,y: bomba.position.y)
            puntosval=puntosval+50
            labelpuntosval.text=String(puntosval)
        }
        
        
        if ( node1.name=="heroe01" && node2.name=="home")
        {labelestado(    node1.name! + " y  " + node2.name! + " ....Loser" )
            vidasval--
            labelvidasval.text=String(vidasval)
            puntosval=puntosval-10
            labelpuntosval.text=String(puntosval)
            submarino.removeFromParent()
        }
        
        println(node1.name)
        println(node2.name)
       
    }
    
    
    
}
