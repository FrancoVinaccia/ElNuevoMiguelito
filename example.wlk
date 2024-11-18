class Comida {
  method peso()
  method aptoCeliaco() 
  method precio()
  method esEspecial() = self.peso() > 250
  method valoracion ()
}

class Provoleta inherits Comida{
  var empanado
  override method aptoCeliaco() = not empanado
  override method esEspecial() = empanado and super()
  override method valoracion() = if(self.esEspecial()) 120 else 80
}

class HambuerguesaCarne inherits Comida{
  var pesoMedallon
  const pan

  override method aptoCeliaco() = pan.aptoCeliaco()
  override method valoracion() = self.peso() / 10
  override method peso () = pesoMedallon + pan.peso()
}

class HamurguesaDoble inherits HambuerguesaCarne {
  override method peso() = super() + pesoMedallon
  override method esEspecial() = self.peso() > 500
}

class Pan {
  var property aptoCeliaco
  var property peso
}

const panIndustrial = new Pan(peso = 60, aptoCeliaco = false)
const panCasero = new Pan(peso = 100, aptoCeliaco = false)
const panDeMaiz = new Pan(peso = 30, aptoCeliaco = true)

class Parrillada inherits Comida {
  var comidas = []
  override method peso() = comidas.sum({comida => comida.peso()})
  override method aptoCeliaco() = comidas.all({comida => comida.aptoCeliaco()})
  override method esEspecial() = comidas.length() > 3 and super()
  override method valoracion() = comidas.max({comida => comida.valoracion()}).valoracion()
}

object celiaco {
  method leAgrada(comida) = comida.aptoCeliaco()  
}

object paladarFino {
  method leAgrada(comida) = comida.valoracion() > 100 or comida.esEspecial()
}

object todoTerreno {
  method leAgrada(comida) = true
}
class Comensal{

  const dinero
  var habito
  
  method leAgrada(comida) = habito.leAgrada(comida)
  method comprar(comida) { 
    dinero - comida.precio()
    parrilla.vender(comida,self)
  }
  method puedeComprar(comida) = dinero > comida.precio()
  method puedeComprarAlgunaComida() = parrilla.comidas.any({comida => self.puedeComprar(comida)})

  method darseUnGusto() {
    var comida = parrilla.comidas.filter({comida => self.leAgrada(comida) and self.puedeComprar(comida)}).max({comida => comida.valoracion()})
    self.comprar(comida)
  }

  method tenerProblemasGastricos() {habito = celiaco} 
  method decicionEconomica() {habito = todoTerreno}
  method ganarLoteria() {habito = paladarFino}
}

object parrilla {
  var comidas = []
  var ingresos = 0
  var comensales = []

  method vender(comida,comensal) { 
  comidas.remove(comida)
  ingresos + comida.precio()
  comensales.add(comensal)
  }

  method hacerPromocion(cantidad){
    comensales.forEach({comensal => comensal.recibirDinero(cantidad)})
  }
}