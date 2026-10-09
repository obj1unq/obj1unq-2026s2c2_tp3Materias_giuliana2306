
class Estudiante {
  var carreras = #{}

  method inscribirseA(_carrera) {
    self.validarInscribirseA(_carrera)
    carreras.add(_carrera)
  }
  method validarInscribirseA(_carrera) {
    if(carreras.contains(_carrera)) {
      self.error("Ya esta inscripto en la carrera")
    }
  }
  method carreras() {
    return carreras
  }
  method materiaPerteneceACarrera(_materia) {
    return carreras.any({carrera => carrera.materias().contains(_materia)})
  }
  method estaInscriptaEn(_carrera) {
    return carreras.contains(_carrera)
  }
}

class Materia {
  const carrera = null

  method añadirCarrera(_carrera) {
    carrera.add(_carrera)
  }
  method carrera() {
    return carrera
  }
}

class Carrera {
  var materias = #{}

  method materias() {
    return materias
  }
  method agregarMateria(_materia) {
    materias.add(_materia)
  }
}

class NotaDeMateria {
  var property nota = 0
  var property materia = null
}