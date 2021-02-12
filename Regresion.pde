/* 
    Regresión lineal
    
    Programa de ejemplo de regresión lineal simple con
    indicaciones de error adicionales. 
    
    A partir de la tabla se calcula el modelo
      
        f(x) = mx + b
        
    y se evalúa el error calculando los errores |y-f(x)|.
    
    La interfaz permite:
      - agregar puntos con el botón derecho,
      - marcar puntos con el botón izquierdo,
      - mover el punto marcado con el botón izquierdo,
      - aplicar el modelo con el botón izquierdo,
      - indicar la líneas de error por punto y
      - marcar la franja del error estimado de la regresión.
    
    Prof. Miguel Angel Norzagaray Cosío
    UABCS/DSC
*/

// Recta de ajuste: y = mx + b
float m;
float b;

float Sx, Sy, Sx2, Sxy;
float xProm, yProm;
float Sigma;
float ErrorMedio, Se2;
float Error_m=0, Error_b=0;

int Radio = 12;
color ColorFondo = 240;

color ColorPuntoNormal = #0000FF;
color ColorPuntoMarcado = #00FF00;
color ColorPuntoTocado = #FF0000;

Punto PuntoMarcado=null;
float TamVentana;

ArrayList<Punto> Puntos = new ArrayList();

CheckBox[] BoxMostrar = new CheckBox[2];
boolean MostrarErrores;
boolean MostrarFranja;

void setup()
{
    size(850,600);
    TamVentana = height;
    Ayuda();
    BoxMostrar[0] = new CheckBox(TamVentana+10, TamVentana/2+10,
                                false, "Líneas de error");
    BoxMostrar[1] = new CheckBox(TamVentana+10, TamVentana/2+40,
                                false, "Franja de error");   
}

void draw()
{
    background(ColorFondo);
    fill(0);
    stroke(0);
    rect(0,0,TamVentana,TamVentana);
    textSize(20);
    text("Regresión Lineal",TamVentana+40,25);
    textSize(12);
    text("Unidades en pixeles",TamVentana+60,45);
    
    if ( mouseX>TamVentana )
      cursor(HAND);
    else
      cursor(CROSS);
    
    BoxMostrar[0].Dibujar();
    MostrarErrores = BoxMostrar[0].Estado();
    BoxMostrar[1].Dibujar();
    MostrarFranja = BoxMostrar[1].Estado();
    
    PintarEjes();
    for (Punto n : Puntos) {
        if ( n.mouseIn()==true )
            n.Color = ColorPuntoTocado;
        else if ( PuntoMarcado != n )
            n.Color = ColorPuntoNormal;
        n.Dibujar();
    }
            
    if ( PuntoMarcado != null ) {
        int x = PuntoMarcado.x;
        int y = PuntoMarcado.y;
        PuntoMarcado.Color = ColorPuntoMarcado;
        fill(0,255,0);
        textSize(14);
        text( "("+str(x-TamVentana/2)+
              ", "+str(-(y-TamVentana/2))+")",
                  TamVentana/2-115,15);
        if ( Puntos.size() > 2  &&  MostrarErrores ) {
            textSize(10);
            text(str(PuntoMarcado.error), 
                    x + (x<TamVentana/2?5:-50),
                    (y + m*x + b)/2 );
        }
    } //<>//
        
    if ( Puntos.size() > 1 ) {
        Regresion();
        stroke(255,255,0);
        strokeWeight(2);
        line(0, b, TamVentana, m*TamVentana + b);
        strokeWeight(1);
        ErrorMedio = Se2 = 0;
        for (Punto n : Puntos) {
            stroke(#FF8800);
            if ( MostrarErrores )
                line(n.x, n.y, n.x, m*n.x + b);
            n.error = abs(m*n.x + b - n.y);
            ErrorMedio += n.error;
            Se2 = n.error*n.error;
        }
        int n = Puntos.size();
        ErrorMedio /= n;
        Sigma = sqrt(Se2 / (n-2));
        Error_m = Sigma*sqrt(n/(n*Sx2 - Sx*Sx ));
        Error_b = sqrt( Sx2/n )*Error_m;
        if ( MostrarFranja ) {
            stroke(#C9C95F);
            line(0, b-Error_b, TamVentana, m*TamVentana + b-Error_b);
            line(0, b+Error_b, TamVentana, m*TamVentana + b+Error_b);
        }
        if ( mousePressed  &&  mouseButton == LEFT  &&  
                      mouseX < TamVentana )
            Pronosticar();
        Info();
    }
    textSize(10);
    text("manc",width-28,height-2);
}

void PintarEjes()
{
    stroke(150);
    strokeWeight(2);
    line(TamVentana/2,0,TamVentana/2,TamVentana);
    line(0,TamVentana/2,TamVentana,TamVentana/2);
}

void Regresion()
{
    Sx = Sy = Sx2 = Sxy = 0;
    
    for ( Punto n : Puntos ) {
        Sx += n.x;
        Sy += n.y;
        Sx2 += n.x*n.x;
        Sxy += n.x*n.y;
    }
    int n = Puntos.size();
    xProm = Sx/n;
    yProm = Sy/n;
    float Discr = n*Sx2-Sx*Sx;
    if ( Discr==0 )
        return;
    m = (n*Sxy - Sx*Sy)/Discr;
    b = (Sx2*Sy - Sxy*Sx)/Discr;
}

// Se aplica el modelo mx+b para estimar nuevos puntos
// de manera continua
void Pronosticar()
{
    float Base = TamVentana/2+60;
    int Px = mouseX;
    float Py = m*Px+b;
    float Mitad = TamVentana/2;
    
    fill(#00FF0E);
    ellipse(Px, Py, Radio/2, Radio/2);
    stroke(#00FF0E);
    textSize(10);
    line(Px, Py, Px, Mitad);
    text(str(Px), Px-10, Mitad +(Py>Mitad?-4:12));
    line(mouseX, m*mouseX+b, TamVentana/2, m*mouseX+b);
    text(str(int(Py)), Mitad +(Px>Mitad?-22:4), Py+5);
    
    textSize(16);
    fill(0);
    text("Pronóstico del modelo:", TamVentana+20, Base+30);
    fill(#008000);
    text("f("+str(Px)+") = "+str(Py), TamVentana+20, Base+50);
}

void Info()
{
    int Base = 100;
    textSize(16);
    fill(0);
    text(""+str(Puntos.size())+" puntos",TamVentana+20,Base);
    text("m = "+str(-m), TamVentana+20,Base+25);
    float d = m*TamVentana/2 + b - TamVentana/2;
    text("b = "+str(-d), TamVentana+20,Base+50);
    if ( Puntos.size()==2 )
        return;
    text("Error medio: "+str(ErrorMedio),TamVentana+20,Base+75);
    text("Error m: "+str(Error_m),TamVentana+20,Base+100);
    text("Error b: "+str(Error_b),TamVentana+20,Base+125);
}

// Botón derecho agrega un punto. 
// Botón izquierdo mueve un punto.
void mouseClicked()
{
    Punto n=null;
  
    BoxMostrar[0].click();
    BoxMostrar[1].click();
    if ( mouseX>TamVentana-Radio )
        return;
    if ( mouseButton == RIGHT ) {
        for (Punto a : Puntos) 
            if ( a.mouseIn() )
                return;
        n = new Punto(mouseX, mouseY);
        Puntos.add(n);
        return;
    } 
    
    if ( Puntos.isEmpty() )
        return;
    for ( Punto a : Puntos) {
        if ( a.mouseIn() ) {
            n = a;
            PuntoMarcado = n;
            n.Color = ColorPuntoMarcado;
            return;
        }
    }
    if ( PuntoMarcado != null ) {
        PuntoMarcado.Color = ColorPuntoNormal;
        PuntoMarcado = null;
    }
}

void mouseDragged() 
{
    if ( mouseX > TamVentana-Radio )
        return;
    if ( PuntoMarcado != null  &&  PuntoMarcado.mouseIn() ) {
        PuntoMarcado.Mover(pmouseX,pmouseY);
        return;
    }
    if ( Puntos.size() > 1  &&  
                mouseButton == LEFT )
        Pronosticar();
}

void mousePressed()
{
    if ( mouseX>TamVentana-Radio )
        return;
    if ( Puntos.size() > 1 )
        Pronosticar();
}

void Ayuda()
{
    println("Click derecho agrega un punto");
    println("Click izquierdo marca/desmarca un punto o aplica el mmodelo");
    println("Un punto marcado puede ser arrastrado por el mouse");
    println("¡Feliz ajuste lineal!");
}

/* Fin de archivo */
 
