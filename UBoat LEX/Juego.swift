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
    
    var prisma = SKSpriteNode()
    var avion = SKSpriteNode()
    var bomba = SKSpriteNode()
    var isla = SKSpriteNode()
    var suelomar = SKNode()
    var moverArriba = SKAction()
    var moverAbajo = SKAction()
    var moverIzq=SKAction()
    var moverDer=SKAction()
    var volarPlano = SKAction()
    var tocaAvion:Bool = false
    var naveTocada:String = ""
    
    let label = SKLabelNode(fontNamed: "Avenir")
    let velocidadFondo: CGFloat = 2
    let anchoScreen: CGFloat = UIScreen.mainScreen().bounds.width
    //constantes colisiones
    let categoriasubmarino:UInt32=1<<0
    let categoriabomba:UInt32=1<<1
    let categoriaavion:UInt32=1<<2
    let categoriasuelomar:UInt32=1<<3
    let categoriahome:UInt32=1<<4
    
   

    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.cyanColor()
        //detectar colisiones
        self.physicsWorld.contactDelegate=self
        heroe()
        malo()
        //prismaticos()
        home()
        suelomares()
        activarlabel()
        crearEscenario()
    }

    func heroe() {
        submarino = SKSpriteNode(imageNamed: "yellowsub")
        submarino.setScale(0.1)
        submarino.zPosition = 1   
        submarino.position = CGPointMake(500, 50)
        submarino.name = "heroe"
        submarino.physicsBody=SKPhysicsBody(circleOfRadius: submarino.size.height/2)
        
        submarino.physicsBody?.dynamic=true
        submarino.physicsBody?.affectedByGravity=false
        submarino.physicsBody?.allowsRotation=false
        submarino.physicsBody?.categoryBitMask=categoriasubmarino
        submarino.physicsBody?.collisionBitMask=categoriahome
        submarino.physicsBody?.contactTestBitMask=categoriahome
        addChild(submarino)
        moverArriba = SKAction.moveByX(0, y: 20, duration: 0.2)
        moverAbajo = SKAction.moveByX(0, y: -20, duration: 0.2)
    }
    
    func malo(){
        avion = SKSpriteNode(imageNamed: "avion")
        avion.setScale(0.25)
        avion.zPosition=2
        avion.position=CGPointMake(120,300)
        avion.name="malo"
        avion.physicsBody=SKPhysicsBody(circleOfRadius: avion.size.height/2)
        avion.physicsBody?.affectedByGravity=false
        avion.physicsBody?.dynamic=true
        avion.physicsBody?.allowsRotation=false
        addChild(avion)
        
        moverIzq=SKAction.moveByX(-20, y:0, duration: 0.2)
        moverDer=SKAction.moveByX(20, y:0, duration: 0.2)  
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
        bomba.physicsBody?.categoryBitMask=categoriabomba
        bomba.physicsBody?.collisionBitMask=categoriasubmarino|categoriasuelomar
        bomba.physicsBody?.contactTestBitMask=categoriasubmarino|categoriasuelomar
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        
        for toke: AnyObject in touches {
            
            let dondeTocamos = toke.locationInNode(self)
            let spriteTocado = self.nodeAtPoint(dondeTocamos)
            
            
            if dondeTocamos.x > avion.position.x {
            if avion.position.x < 750 {
                    avion.runAction(moverIzq)
                }
            } else {
                
                if avion.position.x > 50 {
                    avion.runAction(moverDer)
                }
            }
            // Recuperamos el nodo que haya en el punto tocado
            if (spriteTocado.name != nil && (spriteTocado is SKSpriteNode)) {
                tocaAvion = true
                // Encendemos el semáforo
                naveTocada = spriteTocado.name!
                NSLog(naveTocada)
                if (naveTocada == "malo")
                {
                    bombas(avion.position.x,y: avion.position.y)
                    vuelobomba()
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
    }
    func vuelosubmarino() {
        self.enumerateChildNodesWithName("heroe", usingBlock: { (nodo, stop) -> Void in
            if let yellowsub = nodo as? SKSpriteNode {
                yellowsub.position = CGPoint(
                    x: yellowsub.position.x - self.velocidadFondo ,
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
                    x: bomba.position.x + self.velocidadFondo/3,
                    y: bomba.position.y - self.velocidadFondo/6)
                
                if (bomba.position.x  >  (self.anchoScreen+bomba.size.width/3)) {
                    bomba.position = CGPointMake(-5,bomba.position.y)
                }
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
        labelestado("contacto...")
        println("toyaqui")
    }
    
    
    
}
