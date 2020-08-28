/* 
    Regresión lineal
    
    Programa de ejemplo de regresión lineal simple con
    indicaciones de error adicionales. Botón derecho agrega puntos,
    botón izquierdo los marca y mueve.
    
    A partir de la tabla se calcula el modelo
      
        f(x) = mx + b
        
    y se evalúa el error calculando los errores y-f(x).
    
    Miguel Angel Norzagaray Cosío
    UABCS/DSC
*/

int Radio = 12;
color ColorFondo = 240;

// Para la edición inicial
color ColorPuntoNormal = #0000FF;
color ColorPuntoMarcado = #00FF00;
color ColorPuntoTocado = #FF0000;

Punto PuntoMarcado=null;
float TamVentana;

ArrayList<Punto> Puntos = new ArrayList();

// Recta de ajuste: y = mx + b
float m;
float b;
float ErrorMedio;

void setup()
{
    size(850,600);
    TamVentana = height;
    cursor(CROSS);
}

void draw()
{
    background(ColorFondo);
    fill(0);
    stroke(0);
    rect(0,0,TamVentana,TamVentana);
    textSize(20);
    text("Regresión Lineal",TamVentana+15,25);
    PintarEjes();
    for (Punto n : Puntos) 
        if ( n.mouseIn()==true )
            n.Color = ColorPuntoTocado;
        else if ( PuntoMarcado != n )
            n.Color = ColorPuntoNormal;
    if ( PuntoMarcado != null )
        PuntoMarcado.Color = ColorPuntoMarcado;
    for (Punto n : Puntos)
        n.Dibujar(); 
        
    if ( Puntos.size() > 1 ) {
        Regresion();
        stroke(255,255,0);
        strokeWeight(2);
        line(0, b, TamVentana, m*TamVentana + b);
        strokeWeight(1);
        ErrorMedio = 0;
        for (Punto n : Puntos) {
            stroke(#FF8800);
            line(n.x, n.y, n.x, m*n.x + b);
            ErrorMedio += abs(m*n.x + b - n.y);
        }
        ErrorMedio /= Puntos.size();
        Info();
    }
}

void PintarEjes()
{
  stroke(150);
  strokeWeight(2);
  line(TamVentana/2,0,TamVentana/2,TamVentana);
  line(0,TamVentana/2,TamVentana,TamVentana/2);
}

void Info()
{
    textSize(16);
    fill(0);
    text(""+str(Puntos.size())+" puntos",TamVentana+20,75);
    text("m = "+str(-m), TamVentana+20,100);
    float d = m*TamVentana/2 + b - TamVentana/2;
    text("b = "+str(-d), TamVentana+20,125);
    text("Error medio: "+str(ErrorMedio),TamVentana+20,150);
}

// Botón derecho agrega un punto. 
// Botón izquierdo mueve un punto.
void mouseClicked()
{
    Punto n=null;
  
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

void Regresion()
  {
    float Sx=0, Sy=0, Sx2=0, Sxy=0;
    
    for ( Punto n : Puntos ) {
        float x = n.x;
        float y = n.y;
        Sx += x;
        Sy += y;
        Sx2 += x*x;
        Sxy += x*y;
    }
    int n = Puntos.size();
    float Discr = n*Sx2-Sx*Sx;
    if ( Discr==0 )
        return;
    m = (n*Sxy - Sx*Sy)/Discr;
    b = (Sx2*Sy - Sxy*Sx)/Discr;
}

void mouseDragged() 
{
    if ( PuntoMarcado == null )
        return;
    if ( !PuntoMarcado.mouseIn() ) 
        return;
    if ( mouseX > TamVentana-Radio )
        return;
    PuntoMarcado.Mover(mouseX,mouseY);
}

/* Fin de archivo */
 
