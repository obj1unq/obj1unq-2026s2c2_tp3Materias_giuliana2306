object pepita {
  var energy = 100

  method energy() = energy

  method fly(minutes) {
    energy = energy - minutes * 3
  }
}


class Estudiante {
  var historialDeMateriasAprobadas = []
  var carreras = #{}

  method inscribirseACarrera(_carrera) {
    self.validarInscribirseACarrera(_carrera)
    carreras.add(_carrera)
  }
  method validarInscribirseACarrera(_carrera) {
    if (carreras.contains(_carrera)) {
      self.error("Ya esta inscripto en la carrera" + _carrera)
    }
  }
  method carrerras () {
    return carreras
  }
  method perteneceA(_materia) {
    return carreras.any({carrera => carrera.materias().contains(_materia)})
  } 
  method estaInscriptoEn(_carrera) {
    return carreras.contains(_carrera)
  }
}

class Materia {
  var carreraALaQuePertenece = null

  method carrera() {
    return carreraALaQuePertenece
  }
  method carreraALaQuePertenece(_carrera) {
    carreraALaQuePertenece = _carrera
  }
}

class Carrera {
  var materias = []

  method materias() {
    return materias
  }
  method agregarMateria(_materia) {
    materias.add(_materia)
  }
}