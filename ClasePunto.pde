/*
  Clase Punto
  
  Base para construir nodos con propósito diverso.
  
  Miguel Angel Norzagaray Cosío
  UABCS-DSC
*/

class Punto {
  int x, y;
  color Color;
  Punto(int x, int y) {
    this.x = x;
    this.y = y;
    this.Color = ColorPuntoNormal;
  }
  boolean mouseIn() {
    if ( this.x-Radio/2<mouseX && mouseX<this.x+Radio/2  &&
         this.y-Radio/2<mouseY && mouseY<this.y+Radio/2 ) {
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
