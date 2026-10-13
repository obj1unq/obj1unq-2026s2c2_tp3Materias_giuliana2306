

import materias.*

class Estudiante {
  var property historiaAcademica = new HistoriaAcademica()

  method inscribirseA(_carrera) {
    self.validarInscribirseA(_carrera)
    historiaAcademica.inscribirseA(_carrera)
  }
  
  method validarInscribirseA(_carrera) {
    if (historiaAcademica.carreras().contains(_carrera)) {
      self.error("Ya esta inscripto en la carrera")
    }
  }

  method historiaAcademica() {
    return historiaAcademica
  }

  method estaInscriptaEn(_carrera) {
    return historiaAcademica.estaInscriptaEn(_carrera)
  }

  method materiaPerteneceACarrera(_materia) {
    return historiaAcademica.materiaPerteneceACarrera(_materia)
  }

  method finalizoLaCursadaDe(_materia, _nota) {
    historiaAcademica.finalizoLaCursadaDe(_materia, _nota)
  }

  method promedioDe(_carrera) {
    return historiaAcademica.promedioDe(_carrera)
  }

  method cantDeMateriasAprobadas(_carrera) {
    return historiaAcademica.cantDeMateriasAprobadas(_carrera)
  }

  method promedioDeMateriasAprobadasDeCarreras() {
    return historiaAcademica.promedioDeMateriasAprobadasDeCarreras()
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

  method puedeInscribirseA(_materia) {
    return historiaAcademica.puedeInscribirseA(_materia, self)
  }

  method materiasALasQuePuedeInscribirseEn(_carrera) {
    return historiaAcademica.materiasALasQuePuedeInscribirseEn(_carrera, self)
  }
  method materiasALasQuePuedeInscribirseEn(_carrera, _estudiante) {
    return historiaAcademica.materiasALasQuePuedeInscribirseEn(_carrera, _estudiante)
  }

  method aproboLaMateria(_materia) {
    return historiaAcademica.aproboLaMateria(_materia)
  }

  method creditos() {
    return historiaAcademica.creditos()
  }
}

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
    if ((_nota < 1 || _nota > 10) || 
         self.aproboLaMateria(_materia) ||
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
      _materia.requisito().cumpleElRequisito(_estudiante, _materia)
  }

  method materiasALasQuePuedeInscribirseEn(_carrera, _estudiante) {
    return _carrera.materias().filter({materia => _estudiante.puedeInscribirseA(materia)})
  }

  method carreras() {
    return carreras
  }

  method inscribirseA(_carrera) {
    carreras.add(_carrera)
  }

  method creditos() {
    return self.materiasCursadasAprobadas().sum({notaDeMateria => notaDeMateria.materia().creditos()})
  }

  method creditosDe(_carrera) {
    return self.materiasAprobadasDe(_carrera).sum({notaDeMateria => notaDeMateria.materia().creditos()})
  }
}