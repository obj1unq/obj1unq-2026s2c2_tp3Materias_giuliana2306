import materia.*
class HistoriaAcademica {
  var materiasCursadas = []
  var carreras = #{}

  method materiaPerteneceACarrera(_materia) {
    return carreras.any({carrera => carrera.materias().contains(_materia)})
  }

  method estaInscriptaEn(_carrera) {
    return carreras.contains(_carrera)
  }

  method finalizoLaCursadaDe(_materia, _nota) {
    self.validarFinalizoLaCursadaDe(_materia, _nota)

    const cursadaDeMateria = new NotaDeMateria()
    cursadaDeMateria.nota(_nota)
    cursadaDeMateria.materia(_materia)

    materiasCursadas.add(cursadaDeMateria)
  }

  method validarFinalizoLaCursadaDe(_materia, _nota) {
    if ( self.aproboLaMateria(_materia) ||
          not self.materiaPerteneceACarrera(_materia)) {
          self.error("No se puede registrar la materia")
    }
  }

  method aproboLaMateria(_materia) {
    return materiasCursadas.any({notaDeMateria => notaDeMateria.materia() == _materia && notaDeMateria.nota() >= 6})
  }

  method materiasAprobadasDe(_carrera) {
    return materiasCursadas.filter({notaDeMateria => notaDeMateria.materia().carrera() == _carrera && 
                                                    notaDeMateria.nota() >= 6 })
  }

  method cantDeMateriasAprobadas(_carrera) {
    return self.materiasAprobadasDe(_carrera).size()
  }

  method sumaDeNotasAprobadasDe(_carrera) {
    return self.materiasAprobadasDe(_carrera).sum({notaDeMateria => notaDeMateria.nota()})
  }

  method promedioDe(_carrera) {
    return self.sumaDeNotasAprobadasDe(_carrera) / self.cantDeMateriasAprobadas(_carrera)
  }

  method materiasCursadasAprobadas() {
    return materiasCursadas.filter({notaDeMateria => notaDeMateria.nota() >= 6})
  }

  method cantDeMateriasAprob() {
    return self.materiasCursadasAprobadas().size()
  }

  method sumaDeNotasAprobadas() {
    return self.materiasCursadasAprobadas().sum({notaDeMateria => notaDeMateria.nota()})
  }

  method promedioDeMateriasAprobadasDeCarreras() {
    return self.sumaDeNotasAprobadas() / self.cantDeMateriasAprob()
  }

  method cursadasDe(_materia) {
    return materiasCursadas.filter({notaDeMateria => notaDeMateria.materia() == _materia})
  }

  method estaInscriptoEnMateria(_materia, _estudiante) {
    return _materia.estudiantesInscriptos().contains(_estudiante)
  }

  method puedeInscribirseA(_materia, _estudiante) {
    return self.materiaPerteneceACarrera(_materia) &&
      not self.aproboLaMateria(_materia) &&
      not self.estaInscriptoEnMateria(_materia, _estudiante) &&
      self.estudianteCumpleElRequisito(_materia,_estudiante)
  }
  method estudianteCumpleElRequisito(_materia,_estudiante) {
    return _materia.requisito().cumpleElRequisito(_estudiante, _materia)
  }

  method materiasALasQuePuedeInscribirseEn(_carrera, _estudiante) {
    return _carrera.materias().filter({materia => self.puedeInscribirseA(materia, _estudiante)})
  }

  method carreras() {
    return carreras
  }

  method inscribirseA(_carrera) {
    self.validarInscribirseA(_carrera)
    carreras.add(_carrera)
  }
  method validarInscribirseA(_carrera) {
    if (carreras.contains(_carrera)) {
      self.error("Ya esta inscripto en la carrera")
    }
  }

  method creditos() {
    return self.materiasCursadasAprobadas().sum({notaDeMateria => notaDeMateria.materia().creditos()})
  }

  method creditosDe(_carrera) {
    return self.materiasAprobadasDe(_carrera).sum({notaDeMateria => notaDeMateria.materia().creditos()})
  }
  method inscribirseAMateria(_materia,_estudiante) {
    self.validarInscribirseAMateria(_materia, _estudiante)
    _materia.añadirEstudiante(_estudiante)
  }
  method validarInscribirseAMateria(_materia, _estudiante){
     if (not self.puedeInscribirseA(_materia, _estudiante)) {
      self.error("No puede inscribirse a la materia")
    }
  }
}
class Estudiante {
  var property historiaAcademica = new HistoriaAcademica()

  method inscribirseA(_carrera) {
    historiaAcademica.inscribirseA(_carrera)
  }
  method historiaAcademica() {
    return historiaAcademica
  }

  method estaInscriptaEn(_carrera) {
    return historiaAcademica.estaInscriptaEn(_carrera)
  }

  method finalizoLaCursadaDe(_materia, _nota) {
    historiaAcademica.finalizoLaCursadaDe(_materia, _nota)
  }

  method inscribirseAMateria(_materia) {
    historiaAcademica.inscribirseAMateria(_materia, self)
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
  var  nota = 0
  var property materia = new Materia()

  method nota() {
    return nota
  }
  method nota(_nota) {
    self.validarNota(_nota)
        nota = _nota
  }
  method validarNota(_nota) {
    if (_nota < 1 || _nota > 10) {
        self.error("La nota no es valida")
    }
  }
}

object creditos {

  method cumpleElRequisito(_estudiante,_materia) {
    return  _estudiante.historiaAcademica().creditosDe(_materia.carrera()) >= _materia.creditosRequeridos()
  }
}

object correlativas {

  method cumpleElRequisito(_estudiante, _materia) {
    return _materia.correlativas().all({materia => _estudiante.historiaAcademica().aproboLaMateria(materia)})
}
}

object porAño {

  method cumpleElRequisito(_estudiante, _materia) {
    return _materia.carrera().materiasAnterioresA(_materia).all({materia => 
                                                           _estudiante.historiaAcademica().aproboLaMateria(materia)})
  }
}
object sinRequisitos {
  
  method cumpleElRequisito(_estudiante, _materia) {
    return true
  }
}