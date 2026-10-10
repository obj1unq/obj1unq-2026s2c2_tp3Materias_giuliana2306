
class Estudiante {
  var carreras = #{}
  var materiasCursadas = #{}

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
  method finalizoLaCursadaDe(_materia, _nota) {
    self.validarFinalizoLaCursadaDe(_materia,_nota)
    
    const cursadaDeMateria = new NotaDeMateria()

    cursadaDeMateria.nota(_nota)
    cursadaDeMateria.materia(_materia)

    materiasCursadas.add(cursadaDeMateria)
  }
  method validarFinalizoLaCursadaDe(_materia, _nota) {
    if ((_nota < 1 || _nota > 10 ) || self.aproboLaMateria(_materia) || not self.materiaPerteneceACarrera(_materia)) {
      self.error("No se puede registrar la materia")
    }
  }
  method aproboLaMateria(_materia) {
    return materiasCursadas.any({notaDeMateria => notaDeMateria.materia() == _materia && notaDeMateria.nota() >= 6})
  }
  method promedioDe(_carrera) {
    return self.sumaDeNotasAprobadasDe(_carrera) / self.cantDeMateriasAprobadas(_carrera)
  }
  method sumaDeNotasAprobadasDe(_carrera) {
    return self.materiasAprobadasDe(_carrera).sum({notaDeMateria => notaDeMateria.nota()})
  }
  method materiasAprobadasDe(_carrera) {
    return materiasCursadas.filter({notaDeMateria => notaDeMateria.materia().carrera() == _carrera
           && notaDeMateria.nota() >=6})
  }
  method cantDeMateriasAprob() {
    return materiasCursadas.count({notaDeMateria => notaDeMateria.nota() >=6})
  }
  method cantDeMateriasAprobadas(_carrera) {
    return self.materiasAprobadasDe(_carrera).size()
  }
  method promedioDeMateriasAprobadasDeCarreras() {
    return self.sumaDeNotasAprobadas() / self.cantDeMateriasAprob()
  }
  method sumaDeNotasAprobadas() {
    return self.materiasCursadasAprobadas().sum({notaDeMateria => notaDeMateria.nota() })
  }
  method materiasCursadasAprobadas() {
    return materiasCursadas.filter({notaDeMateria => notaDeMateria.nota() >= 6})
  }
  method estaInscriptoEnMateria(_materia) {
    return _materia.estudiantesInscriptos().contains(self)
  }
  method cumpleLosRequisitosDe(_materia) {
    return _materia.requisitos().all({requisito => self.aproboLaMateria(requisito)})
  }
  method puedeInscribirseA(_materia) {
    return self.materiaPerteneceACarrera(_materia)   && 
           not self.aproboLaMateria(_materia)        &&
           not self.estaInscriptoEnMateria(_materia) &&
           self.cumpleLosRequisitosDe(_materia)
  }
  method inscribirseAMateria(_materia) {
    self.validarInscribirseAMateria(_materia)
    _materia.añadirEstudiante(self)
  }
  method validarInscribirseAMateria(_materia) {
    if (not self.puedeInscribirseA(_materia)) {
      self.error("No puede inscribirse a la materia")
    }
  }
  method materiasALasQuePuedeInscribirseEn(_carrera, _estudiante) {
    return _carrera.materias().filter({materia => _estudiante.puedeInscribirseA(materia)})
  }
}

class Materia {
  var carrera = null
  var requisitos = #{}
  var estudiantesInscriptos = #{}

  method añadirCarrera(_carrera) {
    carrera = _carrera
  }
  method carrera() {
    return carrera
  }
  method requisitos(_values) {
    requisitos = _values
  }
  method requisitos() {
    return requisitos
  }
  method estudiantesInscriptos() {
    return estudiantesInscriptos
  }
  method añadirEstudiante(_estudiante) {
    estudiantesInscriptos.add(_estudiante)
  }
}

class Carrera {
  var materias = #{}

  method materias() {
    return materias
  }
  method agregarMateria(_materia) {
    materias.add(_materia)
     _materia.añadirCarrera(self)
  }
}

class NotaDeMateria {
  var property nota = 0
  var property materia = null
}