/*
  Clase Punto
  
  Base para construir nodos con propósito diverso.
  
  Miguel Angel Norzagaray Cosío
  UABCS-DSC
*/

class Punto {
    int x, y;
    float error;
    color Color;
    Punto(int _x, int _y) {
        x = _x;
        y = _y;
        Color = ColorPuntoNormal;
    }
    boolean mouseIn() {
        if ( x-Radio/2<mouseX && mouseX<x+Radio/2  &&
             y-Radio/2<mouseY && mouseY<y+Radio/2 ) {
               return true;
        }
         return false;
    }
    void Mover(int x, int y) {
        if ( x<Radio ) 
            x = Radio+1;
        this.x = x;
        if ( y<Radio ) 
            y = Radio+1;
        if ( y > height-Radio )
            y = height-Radio-1;
        this.y = y;
    }
    void Dibujar() {
        if ( !mouseIn() )
            noStroke();
        fill(this.Color);
        ellipse(x, y, Radio, Radio);
        stroke(25);
    }
}

/* Fin de archivo */
