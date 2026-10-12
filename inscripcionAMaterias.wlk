
class Estudiante {
  var carreras = #{}
  var materiasCursadas = #{}
  var creditos = 0

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
    creditos = creditos + _materia.creditos()
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
  method puedeInscribirseA(_materia) {
    return self.materiaPerteneceACarrera(_materia)   && 
           not self.aproboLaMateria(_materia)        &&
           not self.estaInscriptoEnMateria(_materia) &&
           _materia.requisito().cumpleElRequisito(self, _materia)
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
  method creditos() {
    return creditos
  }
}

class Materia {
  var carrera = null
  var requisito = sinRequisitos
  var estudiantesInscriptos = #{}
  var correlativas = #{}
  var property año = 0
  var property creditos = 0
  var property creditosRequeridos = 0

  method añadirCarrera(_carrera) {
    carrera = _carrera
  }
  method carrera() {
    return carrera
  }
  method estudiantesInscriptos() {
    return estudiantesInscriptos
  }
  method añadirEstudiante(_estudiante) {
    estudiantesInscriptos.add(_estudiante)
  }
  method agregarCorrelativas(_correlativas) {
    correlativas = _correlativas
  }
  method agregarRequisito(_requisito) {
    requisito = _requisito
  }
  method correlativas() {
    return correlativas
  }
  method requisito() {
    return requisito
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
  method materiasAnterioresA(_materia) {
    return materias.filter({materia => materia.año() == (_materia.año() - 1)})
  }
}

class NotaDeMateria {
  var property nota = 0
  var property materia = null
}

object creditos {

  method cumpleElRequisito(_estudiante,_materia) {
    return _estudiante.creditos() >= _materia.creditosRequeridos()
  }
}

object correlativas {

  method cumpleElRequisito(_estudiante, _materia) {
    return _materia.correlativas().all({materia => _estudiante.aproboLaMateria(materia)})
  }
}

object porAño {

  method cumpleElRequisito(_estudiante, _materia) {
    return _materia.carrera().materiasAnterioresA(_materia).all({materia => _estudiante.aproboLaMateria(materia)})
  }
}
object sinRequisitos {
  
  method cumpleElRequisito(_estudiante, _materia) {
    return true
  }
}