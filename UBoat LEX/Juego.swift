//
//  Juego.swift
//  UBoat LEX
//
//  Created by Berganza on 16/12/2014.
//  Copyright (c) 2014 Berganza. All rights reserved.
//

import SpriteKit


class Juego: SKScene {

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
    
    let velocidadFondo: CGFloat = 2
    let anchoScreen: CGFloat = UIScreen.mainScreen().bounds.width
   

    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.cyanColor()
        heroe()
        malo()
        //prismaticos()
        home()
        suelomares()
        crearEscenario()
    }
    
    
    
    
    func heroe() {
        submarino = SKSpriteNode(imageNamed: "yellowsub")
//        submarino.xScale = 1
//        submarino.yScale = 1
        submarino.setScale(0.1)
        submarino.zPosition = 1   
        submarino.position = CGPointMake(500, 50)
        submarino.name = "heroe"
        addChild(submarino)
        moverArriba = SKAction.moveByX(0, y: 20, duration: 0.2)
        moverAbajo = SKAction.moveByX(0, y: -20, duration: 0.2)
    }
    
    func malo(){
        avion = SKSpriteNode(imageNamed: "avion")
        avion.setScale(0.25)
        avion.zPosition=3
        avion.position=CGPointMake(120,300)
        avion.name="malo"
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
        addChild(bomba)
        moverIzq=SKAction.moveByX(-20, y:0, duration: 0.2)
        moverDer=SKAction.moveByX(20, y:0, duration: 0.2)
    }
    
    func suelomares(){
    suelomar.position=CGPointMake(0, 25)
    suelomar.zPosition=3
    suelomar.physicsBody=SKPhysicsBody(rectangleOfSize: CGSizeMake(self.anchoScreen,50))
    suelomar.physicsBody?.dynamic=false
    suelomar.name="suelomares"
    addChild(suelomar)
        
    }
    func home(){
        isla = SKSpriteNode(imageNamed: "isla")
        isla.setScale(0.2)
        isla.zPosition = 3
        isla.position = CGPointMake(20, 45)
        isla.name = "home"
        addChild(isla)

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
    
    func vuelobomba(){
        var jump = SKAction.rotateToAngle(CGFloat(-3.14/2), duration: NSTimeInterval(0.5))
        self.enumerateChildNodesWithName("bombas", usingBlock: { (nodo, stop) -> Void in
            if let bomba = nodo as? SKSpriteNode {
                bomba.runAction(jump)
                bomba.physicsBody=SKPhysicsBody(circleOfRadius: bomba.size.height/2)
               
                
                bomba.position = CGPoint(
                    x: bomba.position.x + self.velocidadFondo/3,
                    y: bomba.position.y - self.velocidadFondo/6)
                
                if (bomba.position.x  >  (self.anchoScreen+bomba.size.width/3)) {
                    bomba.position = CGPointMake(-5,bomba.position.y)
                }
            }
        })
    }
    
    override func update(currentTime: NSTimeInterval) {
        //scrollHorizontal()
        vuelohorizontal()
        vuelobomba()
    }
    
    
    
}
