
class Habitaciones {
	const ocupantes = #{}
	
	method estaVacia() = ocupantes.isEmpty()
	method nivelDeConfort(persona) = 10 + self.condicionAdicional(persona)
	method condicionAdicional(persona)
	method puedeEntrar(unaPersona) = self.estaVacia() or self.sePuedeEntrar(unaPersona)
	method sePuedeEntrar(unaPersona)
	method entrar(unaPersona){
		if (self.puedeEntrar(unaPersona)){
			if (unaPersona.habitacionDondeEsta() != null){
				unaPersona.habitacionDondeEsta().ocupantes().remove(unaPersona)
			}
			unaPersona.habitacionDondeEsta(self)
			ocupantes.add(unaPersona)
		}
		else 
			self.error("No puede entrar a la habitacion manito")
	}
	method ocupantesEnHabitacion() = ocupantes.asSet()
	method mayorOcupante() = ocupantes.find({o => o.edad() == self.edadDelMayorOcupante()})
	method edadDelMayorOcupante() = self.edadDeLosOcupantes().max()
	method edadDeLosOcupantes() = ocupantes.map({o => o.edad()})
}

class HabitacionDeUsoGeneral inherits Habitaciones {
	override method condicionAdicional(persona) {}
	override method sePuedeEntrar(unaPersona) = true
}

class Dormitorio inherits Habitaciones {
	const personasQueDuermen = #{}
	
	override method condicionAdicional(persona) {
		if (personasQueDuermen.contains(persona)){
			return 10/personasQueDuermen.size()
		}
		else 
			return 0
	}
	override method sePuedeEntrar(unaPersona) = personasQueDuermen.all({o => self.ocupanteDuerme(o)})
	method ocupanteDuerme(unOcupante) = personasQueDuermen.contains(unOcupante)
}

class Banio inherits Habitaciones {
	override method condicionAdicional(persona) = if(persona.edad() <= 4){2}else{5}
	override method sePuedeEntrar(unaPersona) = ocupantes.any(unaPersona.edad() <= 4)
}

class Cocina inherits Habitaciones {
	var superficie 
	method porcentajeDeSuperficie() = superficieCocina.porcentaje()
	override method condicionAdicional(persona){
		if (persona.habilidadesDeCocina()){
			return superficie * self.porcentajeDeSuperficie() / 100
		}
		else
			return 0
	}
	override method sePuedeEntrar(unaPersona) = not unaPersona.habilidadesDeCocina() or (unaPersona.habilidadesDeCocina() and not self.hayPersonaConHabilidadDeCocina())
	method hayPersonaConHabilidadDeCocina() = ocupantes.any({o => o.habilidadesDeCocina()})
}

object superficieCocina {
	var property porcentaje = 10
}