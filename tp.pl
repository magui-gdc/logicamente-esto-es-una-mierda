%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Base de conocimientos inicial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% objetivo(Proyecto, Objetivo, TareaARealizar)
objetivo(higiene, almejas, recolectarMaterial(playa)).
objetivo(higiene, algas, recolectarMaterial(mar)).
objetivo(higiene, grasa, recolectarMaterial(animales)).
objetivo(higiene, hidroxidoDeCalcio, quimica([hacerPolvo, diluirEnAgua])).
objetivo(higiene, hidroxidoDeSodio, quimica([mezclarIngredientes])).
objetivo(higiene, jabon, quimica([mezclarIngredientes, dejarSecar])).

%% Agregar objetivos para otros proyectos aquí...

objetivo(higiene, mascaraFacial, quimica([a,a,a,a,a])).
objetivo(ducha, shampoo, quimica([derretirJabon, a, a, a, a])).
objetivo(arte, mandala, realizarArtesanias(23)).

%% También se espera que agreguen más información para los predicados
%% prerrequisito/2 y conseguido/1 para probar lo que necesiten

prerrequisito(algas, mascaraFacial).
prerrequisito(jabon, shampoo).

% prerrequisito(Prerrequisito, Producto)
prerrequisito(almejas, hidroxidoDeCalcio).
prerrequisito(hidroxidoDeCalcio, hidroxidoDeSodio).
prerrequisito(algas, hidroxidoDeSodio).
prerrequisito(hidroxidoDeSodio, jabon).
prerrequisito(grasa, jabon).

% conseguido(Producto)
conseguido(almejas).
conseguido(algas).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----- PUNTO 1 ------

esDeOrigenAnimal(animales).
esMaterialAnimal(recolectarMaterial(Fuente)):-
    esDeOrigenAnimal(Fuente).

%-tareaPorCientifico(Nombre, Tarea)

reinoCientifico(senku).
reinoCientifico(chrome).
reinoCientifico(kohaku).
reinoCientifico(suika).

%-- Senku

tareaPorCientifico(senku, quimica(_)).
tareaPorCientifico(senku, realizarArtesanias(Dificultad)):-
    Dificultad =< 6.

%-- Chrome

tareaPorCientifico(chrome, recolectarMaterial(Fuente)):-
    not(esMaterialAnimal(recolectarMaterial(Fuente))).
tareaPorCientifico(chrome, quimica(Procesos)):-
    length(Procesos, Cantidad),
    Cantidad =< 3.
    
%-- Kohaku

tareaPorCientifico(kohaku, recolectarMaterial(animales)).

%-- Suika

tareaPorCientifico(suika, recolectarMaterial(playa)).
tareaPorCientifico(suika, recolectarMaterial(bosque)).
tareaPorCientifico(suika, quimica([mezclarIngredientes])). 

%-- Todos

tareaPorCientifico(Nombre, realizarArtesanias(Dificultad)):-
    reinoCientifico(Nombre),
    Dificultad < 3.

%----- PUNTO 2 ------

objetivoFinalDeUnProyecto(Producto, Proyecto):-
    objetivo(Proyecto, Producto, _),
    forall((objetivo(Proyecto, Producto2, _), Producto \= Producto2),
    not(prerrequisito(Producto, Producto2))).

%----- PUNTO 3 ------

esViable(Proyecto):-
    objetivo(Proyecto, _, _),
    forall(objetivo(Proyecto, _, Tarea), 
    (reinoCientifico(Cientifico), tareaPorCientifico(Cientifico, Tarea))).

%----- PUNTO 4 ------ 

esIndispensable(Objetivo, Cientifico, Proyecto):-
    objetivo(Proyecto, Objetivo, Tarea),
    tareaPorCientifico(Cientifico, Tarea),
    not((tareaPorCientifico(Cientifico2, Tarea), Cientifico \= Cientifico2)).

%----- PUNTO 5 ------

cumplioPrerrequisito(Producto):-
  objetivo(_, Producto, _),
  forall(prerrequisito(Prerrequisito, Producto),
  conseguido(Prerrequisito)).

objetivoPendiente(Proyecto, Producto):-
  objetivo(Proyecto, Producto, _),
  not(conseguido(Producto)).

puedeIniciarse(Proyecto, Producto):-
  objetivoPendiente(Proyecto, Producto),
  cumplioPrerrequisito(Producto).

%----- PUNTO 6 ------

seEncuentraEnSuperficie(Fuente):-
  not(seEncuentraBajoTierra(Fuente)),
  not(seEncuentraEnElAgua(Fuente)).
seEncuentraEnElAgua(mar).
seEncuentraBajoTierra(cuevas).

% tiempoEstimado(Tarea, TiempoEstimado)
tiempoEstimado(recolectarMaterial(Fuente), 3):-
  seEncuentraEnSuperficie(Fuente).
tiempoEstimado(recolectarMaterial(Fuente), 8):-
  seEncuentraEnElAgua(Fuente).
tiempoEstimado(recolectarMaterial(Fuente), 48):-
  seEncuentraBajoTierra(Fuente).
tiempoEstimado(quimica(Procesos), TiempoEstimado):-
  length(Procesos, Cantidad),
  TiempoEstimado is (Cantidad * 2).
tiempoEstimado(realizarArtesanias(Dificultad), Dificultad).

tiempoRestante(Proyecto, TiempoTotal):-
  esViable(Proyecto),
  findall(Tiempo,
    (objetivoPendiente(Proyecto, Producto),objetivo(Proyecto, Producto, Tarea), tiempoEstimado(Tarea, Tiempo))
    , ListaTiempo),
  sumlist(ListaTiempo, TiempoTotal).

%----- PUNTO 7 ------

bloqueaAvance(Producto, Producto2):-
  prerrequisito(Producto, Postrrequisito),
  bloqueaAvance(Postrrequisito, Producto2).
bloqueaAvance(Producto, Producto2):-
  prerrequisito(Producto, Producto2).

objetivoCostoso(Producto):-
  objetivo(_, Producto, Tarea),
  tiempoEstimado(Tarea, TiempoEstimado),
  TiempoEstimado > 5.

objetivoCritico(Producto, Proyecto):-
  objetivo(Proyecto, Producto, _),
  objetivo(Proyecto, Producto2, _),
  Producto \= Producto2,
  bloqueaAvance(Producto, Producto2),
  objetivoCostoso(Producto2).


%----- PUNTO 8 ------

esValiosa(Persona, Objetivo, Proyecto):-
  esIndispensable(Objetivo, Persona, Proyecto).
esValiosa(Persona, Objetivo, Proyecto):-
  objetivo(Proyecto, Objetivo, Tarea),
  tareaPorCientifico(Persona, Tarea),
  tiempoEstimado(Tarea, TiempoEstimado),
  tiempoRestante(Proyecto, TiempoTotal),
  TiempoEstimado > TiempoTotal // 2.

esValiosa(Persona, Objetivo, Proyecto):-
  objetivo(Proyecto, Objetivo, Tarea),
  tareaPorCientifico(Persona, Tarea),
  objetivoCritico(Objetivo, Proyecto),
  forall((objetivo(Proyecto, Objetivo2, Tarea2), Objetivo2 \= Objetivo
         ,puedeIniciarse(Proyecto, Objetivo2)), 
        (tareaPorCientifico(Persona2, Tarea2), Persona2 \= Persona)).

convieneTrabajar(Persona, Objetivo, Proyecto):-
  puedeIniciarse(Proyecto, Objetivo),
  esViable(Proyecto),
  esValiosa(Persona, Objetivo, Proyecto).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pruebas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- begin_tests(tp).

%% Tests de referencia
%% Testeo de consultas que esperan que sean ciertas
test(elHidroxidoDeCalcioEsPrerrequisitoDelJabon, nondet):-
  prerrequisito(hidroxidoDeSodio, jabon).

%% Testeo de consultas que esperan que sean falsas
test(elJabonNoEsPrerrequisitoDelHidroxidoDeCalcio, fail):-
  prerrequisito(jabon, hidroxidoDeSodio).

%% Testeo de consultas existenciales con múltiples respuestas => inversibilidad
test(prerrequisitosDelHidroxidoDeSodio, set(Producto == [hidroxidoDeCalcio, algas])):-
  prerrequisito(Producto, hidroxidoDeSodio).

:- end_tests(tp).


%----- Tests Punto 2 ------
:- begin_tests(tp_punto2).

test(elProductoNoPerteneceAlProyecto, fail):-
  objetivoFinalDeUnProyecto(azucar, higiene).
test(elProductoNoEsPrerrequisitoDeAlgunProducto, set(Producto == [jabon, mascaraFacial])):-
  objetivoFinalDeUnProyecto(Producto, higiene).

:- end_tests(tp_punto2).


%----- Tests Punto 3 ------
:- begin_tests(tp_punto3).

% Ya que no hay otras personas reclutadas por el reino científico que puedan hacer artesanías más complejas.
test(realizarArtesaniasConDificultadMayorA6, fail):-
  esViable(arte).
test(proyectosViables, set(Proyecto == [higiene, ducha])):-
  esViable(Proyecto).

:- end_tests(tp_punto3).


%----- Tests Punto 4 ------
:- begin_tests(tp_punto4).

test(kohakuIndispensableParaCazar, nondet):-
  esIndispensable(grasa, kohaku, higiene).
test(chromeNoEsIndispensableParaLaQuimica, fail):-
  esIndispensable(jabon, chrome, higiene).

:- end_tests(tp_punto4).


%----- Tests Punto 5 ------
:- begin_tests(tp_punto5).

test(productoQueAunNoSeConsiguio):-
  objetivoPendiente(higiene, jabon).
test(productosConseguidos, set(Producto == [algas, almejas]), fail):-
  objetivoPendiente(higiene, Producto).
test(seCumplieronTodosLosPrerrequisitosDelProducto):-
  objetivoPendiente(higiene, hidroxidoDeCalcio)

:- end_tests(tp_punto5).


%----- Tests Punto 6 ------
:- begin_tests(tp_punto6).

test(elTiempoRestanteParaHigieneEsDe23Horas, nondet):-
  tiempoRestante(higiene, 23).

test(losMaterialesQueNoSeEncuentranEnLaSuperficieDemoranMasDe3Horas, set(Fuente == [mar, cuevas]), fail):-
  tiempoEstimado(recolectarMaterial(Fuente), 3).

test(elTiempoEstimadoParaLaTareaQuimicaDelHidroxidoDeCalcioEsDe4Horas):-
  objetivo(higiene, hidroxidoDeCalcio, quimica(Procesos)),
  tiempoEstimado(quimica(Procesos), 4).

test(hacerUnMandalaDemoraTantoComoSuDificultad, [Dificultad == 23]):-
  objetivo(arte, mandala, realizarArtesanias(Dificultad)).

:- end_tests(tp_punto6).


%----- Tests Punto 7 ------
:- begin_tests(tp_punto7).

test(lasAlmejasBloqueanVariosAvances, set(Producto == [shampoo, jabon, hidroxidoDeSodio, hidroxidoDeCalcio]), nondet):-
  bloqueaAvance(almejas, Producto).

test(lasAlgasSeEncuentranEnElMarPorLoTantoSonUnObjetivoCostoso, nondet):-
  objetivoCostoso(algas).

test(elHidroxidoDeCalcioNoEsUnObjetivoCostoso, fail):-
  objetivoCostoso(hidroxidoDeCalcio).

test(lasAlgasSonUnObjetivoCritico, nondet):-
  objetivoCritico(algas, _).

:- end_tests(tp_punto7).


%----- Tests Punto 8 ------
:- begin_tests(tp_punto8).

test(sonValiososParaElObjetivoDeHigiene, set(Cientifico == [chrome, kohaku, senku])):-
  esValiosa(Cientifico, _ , higiene).

test(siElProyectoEsHigieneAKohakuLeConvieneTrabajar, nondet):-
  convieneTrabajar(kohaku, grasa, higiene).

:- end_tests(tp_punto8).