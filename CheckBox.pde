/**
  CheckBox    Clase de apoyo
  
Ejemplo de uso:
  CheckBox EjemBox = new CheckBox( 
                      x, y,        esq. sup. izq. del cuadro
                      false,       valor inicial
                      "Mensaje"    mensaje del control
             );
*/

class CheckBox {
    float x, y;
    boolean Activo;
    String Msg;
    CheckBox(float _x, float _y, boolean f, String msg){
        x = _x;
        y = _y;
        Activo = f;
        Msg = msg;
    }
    boolean Estado() {
        return Activo;
    }
    void Dibujar () {
        stroke(255);
        if ( Activo )
            fill( MouseIn()? #00FF00: #00E000);
        else
            fill( MouseIn()? #FFA000 : #FF0000 );
        rect(x, y, 20, 20, 5, 5, 5, 5);
        if ( Activo ) {
          strokeWeight(2);
          stroke(#0000ff);
          line(x+5, y+10, x+8, y+15);
          line(x+8, y+15, x+16, y+5);
        }
        fill(0);
        textSize(14);
        text(Msg,x+30,y+15);
        strokeWeight(1);
    }
    void  click() {
        if ( MouseIn() )
            Activo = !Activo;
    }
    boolean MouseIn(){
        return  mouseX > x+2  &&  mouseX < x+18 
            &&  mouseY > y+2  &&  mouseY < y+18;
    }
}
