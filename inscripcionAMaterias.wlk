
class Estudiante {
  var historialDeMateriasAprobadas = []
  var carreras = #{}
  var materiasCursadas = []

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
  method finalizacionDeCursadaDe(_materia, _nota) {
    self.validarFinalizacionDeCursadaDe(_materia, _nota)

    const materia1 = new NotaDeMateria()

    materia1.nota(_nota)
    materia1.materia(_materia)

    materiasCursadas.add(materia1)
    self.añadirSiAprobo(materia1,_nota)
  }
  method añadirSiAprobo(_materia,_nota) {
    if (_nota >= 6) {
      historialDeMateriasAprobadas.add(_materia)
    }  
  }
  method validarFinalizacionDeCursadaDe(_materia, _nota) {
    if ((_nota < 1 || _nota > 10) || 
        self.fueAprobadaAntes(_materia) || 
        not self.perteneceA(_materia)) {
          self.error("No es posible añadir la materia" + _materia)
        }
  }
  
  method fueAprobadaAntes(_materia) {
    return materiasCursadas.any({notaDeMateria => notaDeMateria.materia() == _materia && 
                                                  notaDeMateria.nota() >= 6})
  }
  method cantidadDeMateriasAprobadasDe(_carrera) {
    return self.materiasAprobadasDe(_carrera).size()
  }
  method materiasAprobadasDe(_carrera) {
    return historialDeMateriasAprobadas.filter({notaDeMateria => notaDeMateria.materia().carrera() == _carrera})
  }
  method promedioDeMateriasDe(_carrera) {
    self.validarPromedioDeMateriasDe(_carrera)
    return self.sumaDeMateriasDe(_carrera) / self.cantidadDeMateriasAprobadasDe(_carrera)
  }
  method validarPromedioDeMateriasDe(_carrera) {
    if (not self.estaInscriptoEn(_carrera) || self.cantidadDeMateriasAprobadasDe(_carrera) == 0) {
      self.error("No esta inscripto en la carrera")
    }
  }
  method sumaDeMateriasDe(_carrera) {
    return self.materiasAprobadasDe(_carrera).sum({notaDeMateria => notaDeMateria.nota()})
  }
  method cantidadTotalDeMateriasAprobadas() {
    return historialDeMateriasAprobadas.size()
  }
  method promedioDeTodasLasMaterias() {
    return self.sumaDeTodasLasMaterias() / self.cantidadTotalDeMateriasAprobadas()
  }
  method sumaDeTodasLasMaterias() {
    return historialDeMateriasAprobadas.sum({notaDeMateria => notaDeMateria.nota() })
  }
  method materiasCursadasDe(_materia) {
    return materiasCursadas.filter({notaDeMateria => notaDeMateria.materia() == _materia})
  }
  method cursadasDe(_materia) {
    return self. materiasCursadasDe(_materia).map({notaDeMateria => notaDeMateria.nota()})
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

class NotaDeMateria {
  var property nota = 0
  var property materia = null
}