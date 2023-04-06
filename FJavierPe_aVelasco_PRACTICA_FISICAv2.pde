
//F.Javier Peña Velasco - TDIM - Práctica asignatura Física - UOC - dic2021
//“Certifico que he hecho esta PEC de forma completamente individual y solo con la ayuda que del PDC.”
/*
///////// LEYES FÍSICAS QUE INTERVIENEN EN LA SIMULACIÓN DE ESTE JUEGO///////////////

   LEY DE SNELL
Esta ley muestra como se desvía un rayo de luz al pasar de un medio a otro. Al ser diferente la velocidad a la que viaja la luz dependiendo
del medio que atraviesa, esta propiedad nos ofrece con referencia al vacio respecto del medio en cuestión, el indice de refracción(IR) de 
este último. Este IR multiplicado por el seno del ángulo de incidencia respecto de la normal  nos servirá para determinar el recorrido que tendrá el haz 
de luz al pasar de un medio a otro con distintos IR.
En el juego se ha utililizado los IR de aire 1.0 y agua 1.33 para simular este efecto al cambiar de medio y de acuerdo al enunciado solamente
cuando el fotón se dirije desde la zona de ladrillos(aire) hacia la pala sumergida en el agua.  (líneas 319 a 330) aplicamos 
formula de Snell en lineas 322

   3ª LEY DE NEWTON
Siempre que un cuerpo A hace una fuerza sobre un cuerpo B (acción), el cuerpo B hace la misma fuerza sobre A en sentido contrario (reacción).
Esta ley la podemos observar en el choque que realiza el fotón contra los distintos elementos.

   CHOQUE ELASTICO
Se define por choque elástico aquel en el que no existe perdida de energía cinética.
El fotón experimenta esta propiedad en cada uno de los encuentros que realiza con los diferentes elementos del juego. Ya sean, las paredes 
perimetrales, la paleta (en el momento central) o los ladrillos del muro, en el momento que el fotón choca con estos, no existe intercambio de masas y el fotón
describe despues del momento del choque la misma velocidad pero en sentido contrario.
   
   MRU
Se define por el movimiento rectilineo que describe un movil y en el que independientemente del momento recorre la misma distancia
ya que su velocidad no varía.
En el juego se podría definir el MRU en las siguientes situaciones; Mientras el fotón se encuentra en cualquiera de los dos elementos
aire o agua (en cada uno viaja a una velocidad)por separado.
Cumple el movimiento rectilineo uniforme hasta el momento en el que ve interrumpida su trayectoria rectilinea por el choque contra un
muro perimetral, ladrillo o pala.


   MRUA
Se define como el movimiento rectilineo descrito por un movil cuya velocidad experimenta aumentos positivos o negativos de forma lineal
en el tiempo.
La pala decribe un movimiento uniformemente acelerado, al ser movida esta desde su posición de reposo independientemente en ambos sentidos
hasta un punto determinado, durante ese trayecto, variando su velocidad y no así su aceleración
*/

float posicionX = width;//Posición X inicial fotón
float posicionY = 300;  //Posición Y inicial fotón
float posicionX1; // Variables de posicion temporales usadas para hallar ángulo de incidencia
float posicionY1; // 
float posicionX2; // 
float posicionY2; //
float anguloRadianes; // ángulo que describe la trayectoria en radianes (calculado en la funcion pública ángulos)
float anguloGrados; // pasa radianes a grados (calculado en la funcion pública ángulos)
float rfract2; // definida en linea 322

float n1 = 1.00; // Indice de refracción aire
float n2 = 1.33; // indice de refracción agua
float velocidadX = 0;  // velocidad de X en base al indice del aire  0.0 = 1.0 ir //
float velocidadX1 = 0;  // velocidad en X nos determinará el ángulo dentro del agua, en la línea 322 aplicamos formula  para implementar simulación de refracción 
float velocidadY = 5; // 0.0 = 5.0 vel ficticia, equivaldria a una ir 1.00 (aire)
float velocidadY1 = 1.25; //valor a restar a velocidad en Y dentro del agua = 3·10^8/1,33 = 2.25·10^8 ==> 5· 2.25·10^8/3·10^8 = 3.75 ==> 5-3.75=1.25
float paleta_Alto = 20;
float paleta_Largo = 100;
float dimX = 15; //diametro X fotón
float dimY = 15; //diametro Y fotón
int puntos = 0; // contador puntos
int vidas = 5; // contador vidas
String nombre = "F.Javier Peña Velasco - TDIM - Práctica asignatura Física - UOC - dic2021";
float ancho = 48;
float alto = 15;

// variables para animación/decoración del juego. Usamos posiciones aleatorias
float velNube = 0.25;
float posNubeX = random(-120,600);
float posNubeY = random(0,140);
float velOla = 0.2;
float posOlaX = random(60,120);
float posOlaY = random(260,460);
float tempOlaX = posOlaX;
float velPez = 0.18;
float posPezX = -30;
float posPezX1 = -400;
float posPezY = random(350,460);
float posPezY1 = random(300,400);

int pantalla = 0; //Variable para la máquina de estado integrada en el draw mediante condicionales

Ladrillo[] fila1; //declaramos las diferentes filas del muro a derribar
Ladrillo[] fila2;
Ladrillo[] fila3;
Ladrillo[] fila4;
Ladrillo[] fila5;
Ladrillo[] fila6;

PImage img01;//Declaramos imágenes 
PImage img02;
PImage img03;
PImage img04;

////////////////////////// CLASE LADRILLO //////////////////////////////
//En esta clase se define el ladrillo, como se muestra y sus colisiones
public class Ladrillo{
  private float x,y; //declaramos posición X e Y del centro del ladrillo
  private float ladrilloWidth, ladrilloHeight; //declaramos ancho y alto del objeto ladrillo
  float ladrilloU, ladrilloD, ladrilloL, ladrilloR; //declaramos caras del ladrillo
  
  Ladrillo(float x, float y, float ladrilloWidth, float ladrilloHeight){
    this.x = x;
    this.y = y;
    this.ladrilloWidth = ladrilloWidth;
    this.ladrilloHeight = ladrilloHeight;
      //definimos sus caras
    ladrilloU = y - ladrilloHeight/2;
    ladrilloD = y + ladrilloHeight/2;
    ladrilloL = x - ladrilloWidth/2;
    ladrilloR = x + ladrilloWidth/2;    
   }
   void dibujaLadrillo(){
     noStroke();
     fill(220);
     rect(x,y,ladrilloWidth,ladrilloHeight);
   }
   //declaramos parámetros X e Y correspondientes al sistema de booleanos de colisones del ladrillo
   //pasaremos posteriormente en la llamada, en esos parámetros los valores de las posiciones X e Y del fotón
   boolean colision(float puntoX, float puntoY)
   {boolean resp = false;
     if(puntoX  < ladrilloL || puntoX >  ladrilloR){
     resp = false;
     }else if(puntoY  > ladrilloD || puntoY  < ladrilloU ){
     resp = false;
   }else{resp = true;}
   return resp;
   }

}

////////////////////////////////////SETUP/////////////////////////////////////////////
void setup() {
  size(800, 600);
  background(200);
  smooth(6);
  img01 = loadImage("nube.png");
  img02 = loadImage("ola.png");
  img03 = loadImage("estrella.png");
  img04 = loadImage("pez.png");
  filas();
 frameRate(60);
 PFont font1;
font1 = loadFont("Unispace-Bold-48.vlw"); //Usaremos esta tipografía durante el juego
textFont(font1, 48);

}


  

////////////////////////////////////DRAW//////////////////////////////////////////////

void draw() {

// Condicionales de pantalla de inicio con las instrucciones y opciones que actuan a modo de máquina de estado
  if (pantalla == 0){
  instrucciones();
  }
// Condicional para inicio del juego
  if(mousePressed && mouseButton == LEFT){
  pantalla = 1;
  }
  if(pantalla == 1){
  juego();
  }
// Condicional para reset del juego
  if (keyPressed) {
    if (key == 'r' || key == 'R') {
    pantalla = 2;
    }
  }
  if(pantalla == 2){
  reinicio();}

//condicionales para salir del programa
  if (keyPressed) {
    if (key == 'e' || key == 'E') {
    pantalla = 3;
    }
  }
  if (pantalla == 3){
  salir();
  }
//condicionales para mostrar el nombre
  if (keyPressed) {
    if (key == 'n' || key == 'N'){
        pantalla = 4;
      if (pantalla == 4){
              mostrarNombre();
              //establecemos condiciones para que aparezca este texto durante la pantalla de juego
         if (posicionY != 300 && puntos > 0){
                text("juego en Pausa, presiona el botón izquierdo del ratón para continuar",400,240);
         }
       }
     }     
   }

}


///////////////////////////// FUNCIÓN QUE MUESTRA EL NOMBRE ////////////////////////////
void mostrarNombre(){
  fill(220);
  textSize(15);
  textAlign(CENTER);
  text(nombre,400,50);

}


///////////////////////////// FUNCIÓN INSTRUCCIONES ///////////////////////////////////

void instrucciones(){

  fill(170);
  textSize(18);
  textAlign(CENTER);
  text("Botón Izquierdo del ratón = iniciar partida",400,125);
  text("tecla N = Nombre del alumno",400,175);
  text("tecla R = Reiniciar partida",400,225);
  text("tecla E = Salir", 400, 275);
  text("Al mover el RATÓN de izquierda a derecha se moverá la pala",400,340);
  text("Arkanoid con refracción", 400, 400);
  textSize(13);
  text("El típico juego de romper el muro, con la particularidad de que",400,450);
  text("en vez de una bola/pelota jugaremos con un fotón que atravesará",400,470);
  text("aire y agua con sus distintos indices de refracción.   SUERTE!!",400,490);

}



///////////////////////////// FUNCIÓN JUEGO ///////////////////////////////////

void juego(){

  marcador();
    noStroke();
  fondos();
  aniFondos();
    rectMode(CENTER);
  dibuja_Ladrillos();
    rectMode(CORNER);

  //Pone en marcha velocidades X e Y del fotón
  posicionX += velocidadX;
  posicionY += velocidadY;

  rectMode(CENTER);
  //Dibujamos fotón
  fill(206, 234, 120);
  ellipse(posicionX, posicionY, dimX, dimY);
  rectMode(CORNER);

  //Dibujamos paleta
  fill(180);

  if (mouseX >= 700){
    mouseX = 699;
  }
  rect(mouseX, 540, paleta_Largo, paleta_Alto,10);
  fill(170);
  rect(mouseX+35, 540, 30, paleta_Alto); //zona central de la paleta

  fill(255);

//Condicionales para colosiones del fotón con paredes y paleta
  if (posicionX > width-dimX/2) {
                    //pared derecha, invierte velocidad de X(fotón)
        velocidadX = -velocidadX;
                    //Almacenamos donde choca para determinar el ángulo
        posicionX1 = posicionX;
        posicionY1 = posicionY;
          } else if (posicionX < dimX/2) {
                      //pared izquierda, invierte velocidad de X(fotón)
        velocidadX = -velocidadX;
                      //Almacenamos donde choca para determinar el ángulo
        posicionX1 = posicionX;
        posicionY1 = posicionY;
          } else if (posicionY == 545-10 && posicionX > mouseX && posicionX < mouseX + paleta_Largo/2 - 15) {
                      //parte izquierda de la paleta manda la bola con inclinación a la izquierda e invierte velocidad de X e Y(fotón)
        velocidadY = -velocidadY;
        velocidadX = -2;
      }else if (posicionY == 545-10 && posicionX > mouseX + paleta_Largo/2 - 15 && posicionX < mouseX + paleta_Largo/2 + 15) {
                      //parte central de la paleta (30px), manda la bola sin inclinación e invierte velocidad de X e Y(fotón)
        velocidadY = -velocidadY;
        velocidadX = 0;
      }else if (posicionY == 545-10 && posicionX > mouseX + paleta_Largo/2 + 15 &&  posicionX < mouseX + paleta_Largo + 15) {
                      //parte derecha de la paleta manda la bola con inclinación a la derecha e invierte velocidad de X e Y(fotón)
        velocidadY = -velocidadY;
        velocidadX = 2;
      } else if (posicionY > height) {
                      //pared inferior, si la bola cae, la reinicia en una posición aleatoria en X
                      //sin inclinación
                      //descuenta una vida
        posicionX = width/random(2,4);
        posicionY = height/2;

        velocidadX = 0;
        velocidadY = 5;

        vidas -= 1;

      }else if (posicionY < dimY/2) {
                      //pared superior, invierte velocidad de Y
        velocidadY = -velocidadY;
                       //Almacenamos donde choca para determinar el ángulo
        posicionX1 = posicionX;
        posicionY1 = posicionY;       
      }

  println("posX: " + posicionX,"posY :" + posicionY);
  println("posX1: " + posicionX1,"posY1 :" + posicionY1);
  println("anguloRadianes: "+ anguloRadianes,"anguloGrados: "+anguloGrados,"rfract2 :"+rfract2);
  println("velocidad X: " + velocidadX,"velocidad Y: " + velocidadY);

// Condicional que aplica refracción al fotón SOLAMENTE al entrar en el agua
 if (   posicionY == 250  && velocidadY == 5){
    angulo();
    rfract2 = asin(n1*sin(anguloGrados)/n2);
    velocidadX1 = rfract2;
    velocidadX = velocidadX + velocidadX1;  // cambia velocidad X al entrar el fotón dentro del agua
    velocidadY =  velocidadY - velocidadY1; // cambia velocidad Y al entrar el fotón dentro del agua

  }
  // velocidad al salir del agua
 if (posicionY == 250 && velocidadY == -3.75){
      velocidadY =  -5;}

  // Condicional que gestiona cuando nos quedamos sin vida    
 if(vidas == 0){
   posicionY = -50;
   velocidadX = 0;
   velocidadY = 0;
   textSize(30);
   textAlign(CENTER);
  text("GAME OVER", width/2,height/2);
  text("PUNTOS: "+puntos, width/2,370);
   textSize(24);
  text("presiona tecla C para continuar", width/2,470);
    if (keyPressed) {
      if( key == 'c' || key == 'C') {
          pantalla = 2;
         if(pantalla == 2){
                  reinicio();
         }
      }
    }
  }
   //Condicional para cuando  obtenemos la máxima puntuación
  if(puntos == 1680){
   posicionY = -50; //escondemos fotón
   velocidadX = 0; //paramos velocidad
   velocidadY = 0; // "         "
   textSize(30);
   textAlign(CENTER);
  text("ENHORABUENA!!", width/2,height/2);
  text("PUNTOS: "+puntos, width/2,370);
   textSize(24);
  text("presiona tecla C para continuar", width/2,470);
    if (keyPressed) {
      if( key == 'c' || key == 'C') {
          pantalla = 2;
         if(pantalla == 2){
                  reinicio();
         }
      }
    }    
  }



}

/////////////////////////////ANGULO////////////////////////////////////////////////
public void angulo(){
  posicionX2 = posicionX-posicionX1;//posicionX1-posicionX;
  posicionY2 = posicionY-posicionY1;//posicionY1-posicionY;
  anguloRadianes = atan2(posicionY2,posicionX2); // ángulo de incidencia al entrar en el agua depues del momento de los choques con muros perimetrales o ladrillos
  anguloGrados=degrees(anguloRadianes);
}

///////////////////////////// FUNCIÓN REINICIO ///////////////////////////////////
void reinicio(){
 //Reseteamos variables del juego a sus valores iniciales y llamamos a la función setup
 pantalla = 0;
 puntos = 0;
 vidas = 5;
 posicionX = width/random(2,4);
 posicionY = height/2;
 velocidadX = 0;
 velocidadY = 5;
 setup();


}

///////////////////////////// FUNCIÓN PARA SALIR ///////////////////////////////////

void salir(){
  exit();
}

///////////////////////////// FUNCIÓN FONDOS ///////////////////////////////////
void fondos(){
  fill(100,170,230, 50); //  Transparencia y color  del fondo simula cielo
  rect(0, 0, width, height/2.4); //Corresponde a la parte de pantalla que tiene aire
  fill(100,150,200,30);// // Transparencia y color  del fondo simula agua
  rect(0, height/2.4, width,height); //Espacio con agua
  fill(100,150,200);//color  del fondo zona paleta y marcadores
  fill(175,1);
  rect(0, 540, width,height); //Zona paleta y marcadores
}

///////////////////////////// FUNCIÓN ANIMACIÓN/DECORACIONES //////////////////////
void aniFondos(){
  tint(200);
  posNubeX += velNube;
  if(posNubeX > 800){
  posNubeX = -120;
  }
  image(img01,posNubeX,posNubeY,120,72);
   image(img01,posNubeX+160,posNubeY-45,120,72);
    image(img01,posNubeX+460,posNubeY-25,120,72);

   posOlaX += velOla;
   if(tempOlaX  < posOlaX - 8){
     posOlaX -= velOla + 8;

   }
   tint(0,130,160,15);
     image(img02,posOlaX,posOlaY,120,18);
       image(img02,posOlaX+160,posOlaY+100,120,18);
          image(img02,posOlaX+320,posOlaY+50,120,18);
             image(img02,posOlaX+440,posOlaY+40,120,18);
                image(img02,posOlaX+560,posOlaY+80,120,18);
                    image(img02,posOlaX-120,posOlaY+60,120,18);
                       image(img02,posOlaX-260,posOlaY+40,120,18);
   
   tint(200);                   
   posPezX += velPez; 
   posPezX1 += velPez;
   image(img04,posPezX,posPezY,50,27);
     image(img04,posPezX-180,posPezY+50,40,22);
     if(posPezX > width+180){
       posPezX = -30;
       posPezY = random(270,400);
     }
     image(img04,posPezX1,posPezY1+100,30,18);
     if(posPezX1 > width){
       posPezX1 = -400;
       posPezY1 = random(270,400);
     }
}

///////////////////////////// FUNCIÓN MARCADOR ///////////////////////////////////
void marcador(){
  //Función que gestiona la información en pantalla durante el juego
 textSize(14);
 fill(220);
 textAlign(CENTER);
 if(posicionY >= 250 /* && velocidadY > 0 */ ){
     text("IR que está atravesando el fotón :" + n2, width/2,590);
     }else{text("IR que está atravesando el fotón :" + n1, width/2,590);}
 textAlign(LEFT);
 text("PUNTOS: " + puntos, 20,590);
 text("VIDAS: " + vidas, 700,590);
 }


///////////////////////////// FUNCIÓN DIBUJO DE LADRILLOS /////////////////////////
void dibuja_Ladrillos(){
  //Serie de bucles for encargados de dibujar las filas de ladrillos
  //con condicionales anidados para actuar al detectar las colisiones

  for(int i = 0; i < fila1.length; i++){
  // condicional para dibujar los ladrillos de la fila1
  if(fila1[i] != null){
  fila1[i].dibujaLadrillo();
    if(fila1[i].colision(posicionX,posicionY)){
        fila1[i]=null; //
        velocidadY = -velocidadY;
        puntos +=  5;    
         //Almacenamos donde choca para determinar el ángulo
        posicionX1 = posicionX;
        posicionY1 = posicionY;
        textAlign(CENTER);
        textSize(31);
        text("+5",width/2,height/2.6);
        tint(210,170);
        image(img03,width/2.25,height/3.65,110,100);                
        }
      }
    }

  for(int i = 0; i < fila2.length; i++){
  // condicional para dibujar los ladrillos de la fila2
  if(fila2[i] != null){
  fila2[i].dibujaLadrillo();
    if(fila2[i].colision(posicionX,posicionY)){
        fila2[i]=null; //
        velocidadY = -velocidadY;
        puntos +=  10;
         //Almacenamos donde choca para determinar el ángulo
        posicionX1 = posicionX;
        posicionY1 = posicionY;
        textAlign(CENTER);
        textSize(31);
        text("+10",width/2,height/2.6);
        tint(210,170);
        image(img03,width/2.25,height/3.65,110,100);
        }
      }
    }

  for(int i = 0; i < fila3.length; i++){
  // condicional para dibujar los ladrillos de la fila3
  if(fila3[i] != null){
  fila3[i].dibujaLadrillo();
    if(fila3[i].colision(posicionX,posicionY)){
        fila3[i]=null; //
        velocidadY = -velocidadY;
        puntos +=  15;
         //Almacenamos donde choca para determinar el ángulo
        posicionX1 = posicionX;
        posicionY1 = posicionY;
        textAlign(CENTER);
        textSize(31);
        text("+15",width/2,height/2.6);
        tint(210,170);
        image(img03,width/2.25,height/3.65,110,100);
        }
      }
    }

  for(int i = 0; i < fila4.length; i++){
  // condicional para dibujar los ladrillos de la fila4
  if(fila4[i] != null){
  fila4[i].dibujaLadrillo();
    if(fila4[i].colision(posicionX,posicionY)){
        fila4[i]=null; //
        velocidadY = -velocidadY;
        puntos +=  20;
         //Almacenamos donde choca para determinar el ángulo
        posicionX1 = posicionX;
        posicionY1 = posicionY;
        textAlign(CENTER);
        textSize(31);
        text("+20",width/2,height/2.6);
        tint(210,170);
        image(img03,width/2.25,height/3.65,110,100);
        }
      }
    }

  for(int i = 0; i < fila5.length; i++){
  // condicional para dibujar los ladrillos de la fila5
  if(fila5[i] != null){
  fila5[i].dibujaLadrillo();
    if(fila5[i].colision(posicionX,posicionY)){
        fila5[i]=null; //
        velocidadY = -velocidadY;
        puntos +=  25;
         //Almacenamos donde choca para determinar el ángulo
        posicionX1 = posicionX;
        posicionY1 = posicionY;
        textAlign(CENTER);
        textSize(31);
        text("+25",width/2,height/2.6);
        tint(210,170);
        image(img03,width/2.25,height/3.65,110,100);
        }
      }
    }

  for(int i = 0; i < fila6.length; i++){
  // condicional para dibujar los ladrillos de la fila5
  if(fila6[i] != null){
  fila6[i].dibujaLadrillo();
    if(fila6[i].colision(posicionX,posicionY)){
        fila6[i]=null; //
        velocidadY = -velocidadY;
        puntos +=  30;
         //Almacenamos donde choca para determinar el ángulo
        posicionX1 = posicionX;
        posicionY1 = posicionY;
        textAlign(CENTER);
        textSize(31);
        text("+30",width/2,height/2.6);
        tint(210,170);
        image(img03,width/2.25,height/3.65,110,100);
        }
      }
    }

}



///////////////////////////// FUNCIÓN FILAS ///////////////////////////////////
//Definimos número y posición de cada uno de los ladrillos
void filas(){
fila1 = new Ladrillo[16];
 fila1[0] = new Ladrillo(25,150,ancho,alto);
 fila1[1] = new Ladrillo(75,150,ancho,alto);
 fila1[2] = new Ladrillo(125,150,ancho,alto);
 fila1[3] = new Ladrillo(175,150,ancho,alto);
 fila1[4] = new Ladrillo(225,150,ancho,alto);
 fila1[5] = new Ladrillo(275,150,ancho,alto);
 fila1[6] = new Ladrillo(325,150,ancho,alto);
 fila1[7] = new Ladrillo(375,150,ancho,alto);
 fila1[8] = new Ladrillo(425,150,ancho,alto);
 fila1[9] = new Ladrillo(475,150,ancho,alto);
 fila1[10] = new Ladrillo(525,150,ancho,alto);
 fila1[11] = new Ladrillo(575,150,ancho,alto);
 fila1[12] = new Ladrillo(625,150,ancho,alto);
 fila1[13] = new Ladrillo(675,150,ancho,alto);
 fila1[14] = new Ladrillo(725,150,ancho,alto);
 fila1[15] = new Ladrillo(775,150,ancho,alto);
  fila2 = new Ladrillo[16];
 fila2[0] = new Ladrillo(25,132,ancho,alto);
 fila2[1] = new Ladrillo(75,132,ancho,alto);
 fila2[2] = new Ladrillo(125,132,ancho,alto);
 fila2[3] = new Ladrillo(175,132,ancho,alto);
 fila2[4] = new Ladrillo(225,132,ancho,alto);
 fila2[5] = new Ladrillo(275,132,ancho,alto);
 fila2[6] = new Ladrillo(325,132,ancho,alto);
 fila2[7] = new Ladrillo(375,132,ancho,alto);
 fila2[8] = new Ladrillo(425,132,ancho,alto);
 fila2[9] = new Ladrillo(475,132,ancho,alto);
 fila2[10] = new Ladrillo(525,132,ancho,alto);
 fila2[11] = new Ladrillo(575,132,ancho,alto);
 fila2[12] = new Ladrillo(625,132,ancho,alto);
 fila2[13] = new Ladrillo(675,132,ancho,alto);
 fila2[14] = new Ladrillo(725,132,ancho,alto);
 fila2[15] = new Ladrillo(775,132,ancho,alto);
   fila3 = new Ladrillo[16];
 fila3[0] = new Ladrillo(25,114,ancho,alto);
 fila3[1] = new Ladrillo(75,114,ancho,alto);
 fila3[2] = new Ladrillo(125,114,ancho,alto);
 fila3[3] = new Ladrillo(175,114,ancho,alto);
 fila3[4] = new Ladrillo(225,114,ancho,alto);
 fila3[5] = new Ladrillo(275,114,ancho,alto);
 fila3[6] = new Ladrillo(325,114,ancho,alto);
 fila3[7] = new Ladrillo(375,114,ancho,alto);
 fila3[8] = new Ladrillo(425,114,ancho,alto);
 fila3[9] = new Ladrillo(475,114,ancho,alto);
 fila3[10] = new Ladrillo(525,114,ancho,alto);
 fila3[11] = new Ladrillo(575,114,ancho,alto);
 fila3[12] = new Ladrillo(625,114,ancho,alto);
 fila3[13] = new Ladrillo(675,114,ancho,alto);
 fila3[14] = new Ladrillo(725,114,ancho,alto);
 fila3[15] = new Ladrillo(775,114,ancho,alto);
  fila4 = new Ladrillo[16];
 fila4[0] = new Ladrillo(25,96,ancho,alto);
 fila4[1] = new Ladrillo(75,96,ancho,alto);
 fila4[2] = new Ladrillo(125,96,ancho,alto);
 fila4[3] = new Ladrillo(175,96,ancho,alto);
 fila4[4] = new Ladrillo(225,96,ancho,alto);
 fila4[5] = new Ladrillo(275,96,ancho,alto);
 fila4[6] = new Ladrillo(325,96,ancho,alto);
 fila4[7] = new Ladrillo(375,96,ancho,alto);
 fila4[8] = new Ladrillo(425,96,ancho,alto);
 fila4[9] = new Ladrillo(475,96,ancho,alto);
 fila4[10] = new Ladrillo(525,96,ancho,alto);
 fila4[11] = new Ladrillo(575,96,ancho,alto);
 fila4[12] = new Ladrillo(625,96,ancho,alto);
 fila4[13] = new Ladrillo(675,96,ancho,alto);
 fila4[14] = new Ladrillo(725,96,ancho,alto);
 fila4[15] = new Ladrillo(775,96,ancho,alto);
   fila5 = new Ladrillo[16];
 fila5[0] = new Ladrillo(25,78,ancho,alto);
 fila5[1] = new Ladrillo(75,78,ancho,alto);
 fila5[2] = new Ladrillo(125,78,ancho,alto);
 fila5[3] = new Ladrillo(175,78,ancho,alto);
 fila5[4] = new Ladrillo(225,78,ancho,alto);
 fila5[5] = new Ladrillo(275,78,ancho,alto);
 fila5[6] = new Ladrillo(325,78,ancho,alto);
 fila5[7] = new Ladrillo(375,78,ancho,alto);
 fila5[8] = new Ladrillo(425,78,ancho,alto);
 fila5[9] = new Ladrillo(475,78,ancho,alto);
 fila5[10] = new Ladrillo(525,78,ancho,alto);
 fila5[11] = new Ladrillo(575,78,ancho,alto);
 fila5[12] = new Ladrillo(625,78,ancho,alto);
 fila5[13] = new Ladrillo(675,78,ancho,alto);
 fila5[14] = new Ladrillo(725,78,ancho,alto);
 fila5[15] = new Ladrillo(775,78,ancho,alto);
    fila6 = new Ladrillo[16];
 fila6[0] = new Ladrillo(25,60,ancho,alto);
 fila6[1] = new Ladrillo(75,60,ancho,alto);
 fila6[2] = new Ladrillo(125,60,ancho,alto);
 fila6[3] = new Ladrillo(175,60,ancho,alto);
 fila6[4] = new Ladrillo(225,60,ancho,alto);
 fila6[5] = new Ladrillo(275,60,ancho,alto);
 fila6[6] = new Ladrillo(325,60,ancho,alto);
 fila6[7] = new Ladrillo(375,60,ancho,alto);
 fila6[8] = new Ladrillo(425,60,ancho,alto);
 fila6[9] = new Ladrillo(475,60,ancho,alto);
 fila6[10] = new Ladrillo(525,60,ancho,alto);
 fila6[11] = new Ladrillo(575,60,ancho,alto);
 fila6[12] = new Ladrillo(625,60,ancho,alto);
 fila6[13] = new Ladrillo(675,60,ancho,alto);
 fila6[14] = new Ladrillo(725,60,ancho,alto);
 fila6[15] = new Ladrillo(775,60,ancho,alto);
}
